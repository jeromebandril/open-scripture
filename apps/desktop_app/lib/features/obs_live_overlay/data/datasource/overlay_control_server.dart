import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../../domain/entities/overlay_models.dart';

class OverlayControlServer {
  final Future<String> Function(String fileName) readOverlayFile;
  final Future<void> Function() ensureAssetsExtracted;

  HttpServer? _server;
  String? _controllerToken;
  final _clients = <WebSocket>{};
  OverlaySnapshot _snapshot = OverlaySnapshot.initial();

  bool get isRunning => _server != null;
  OverlaySnapshot get snapshot => _snapshot;
  void setSnapshot(OverlaySnapshot next) => _snapshot = next;

  OverlayControlServer({
    required this.ensureAssetsExtracted,
    required this.readOverlayFile,
  });

  Future<void> start({required int port}) async {
    if (isRunning) return;
    await ensureAssetsExtracted();
    _controllerToken = _generateToken();
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    _server!.listen(_handleHttp);
  }

  Future<void> stop() async {
    for (final ws in _clients.toList()) {
      try {
        await ws.close();
      } catch (_) {}
    }
    _clients.clear();
    await _server?.close(force: true);
    _server = null;
  }

  void broadcastState() {
    final msg = WsMsg('state', {'payload': _snapshot.toJson()}).encode();

    for (final ws in _clients.toList()) {
      try {
        ws.add(msg);
      } catch (_) {
        _clients.remove(ws);
      }
    }
  }

  Future<void> _handleHttp(HttpRequest req) async {
    try {
      if (req.uri.path == '/ws' && WebSocketTransformer.isUpgradeRequest(req)) {
        await _handleWs(req);
        return;
      }

      // Simple routing
      if (req.uri.path == '/' || req.uri.path == '/overlay') {
        // Serve overlay.html (used by OBS)
        final html = await readOverlayFile('overlay.html');

        _respondText(req, html, contentType: ContentType.html);
        return;
      }

      if (req.uri.path == '/overlay.js') {
        final js = await readOverlayFile('overlay.js');
        _respondText(req, js,
            contentType: ContentType('application', 'javascript'));
        return;
      }

      if (req.uri.path == '/overlay.css') {
        final css = await readOverlayFile('overlay.css');
        _respondText(req, css, contentType: ContentType('text', 'css'));
        return;
      }

      req.response.statusCode = HttpStatus.notFound;
      await req.response.close();
    } catch (e) {
      try {
        req.response
          ..statusCode = HttpStatus.internalServerError
          ..write('Internal Server Error');
        await req.response.close();
      } catch (_) {}
    }
  }

  Future<void> _handleWs(HttpRequest req) async {
    final remote = req.connectionInfo?.remoteAddress;
    final isLoopback = remote != null && remote.isLoopback;

    final ws = await WebSocketTransformer.upgrade(req);
    _clients.add(ws);

    String? role;
    bool authed = false;

    // Require a hello first
    ws.listen(
      (dynamic data) {
        if (data is! String) return;

        Map<String, dynamic> msg;
        try {
          msg = WsMsg.decode(data);
        } catch (_) {
          ws.add(WsMsg('error', {
            'code': 'BAD_REQUEST',
            'message': 'Invalid JSON',
          }).encode());
          return;
        }

        final type = (msg['type'] ?? '') as String;

        // Handshake
        if (type == 'hello') {
          role = (msg['role'] ?? '') as String;

          // Overlay is read-only and only meant for the local OBS browser source.
          if (role == 'overlay' && !isLoopback) {
            ws.add(WsMsg('error', {
              'code': 'FORBIDDEN',
              'message': 'Overlay role only allowed from localhost',
            }).encode());
            ws.close();
            return;
          }

          // Controller/desktop can mutate state, so they always need the token,
          // including from localhost.
          if (role == 'controller' || role == 'desktop') {
            final token = (msg['token'] ?? '') as String;
            if (!_tokenMatches(token)) {
              ws.add(WsMsg('error', {
                'code': 'UNAUTH',
                'message': 'Invalid token',
              }).encode());
              ws.close();
              return;
            }
          }

          authed = true;
          ws.add(WsMsg('state', {'payload': _snapshot.toJson()}).encode());
          ws.add(WsMsg('ok').encode());
          return;
        }

        if (!authed) {
          ws.add(WsMsg('error', {
            'code': 'UNAUTH',
            'message': 'Send hello first',
          }).encode());
          return;
        }

        // Only controllers can send commands
        if (type == 'command') {
          if (role != 'controller' && role != 'desktop') {
            ws.add(WsMsg('error', {
              'code': 'FORBIDDEN',
              'message': 'Not allowed',
            }).encode());
            return;
          }
          _handleCommand(ws, msg);
          return;
        }
      },
      onDone: () => _clients.remove(ws),
      onError: (_) => _clients.remove(ws),
      cancelOnError: true,
    );
  }

  void _handleCommand(WebSocket ws, Map<String, dynamic> msg) {
    final name = (msg['name'] ?? '') as String;
    final payload = (msg['payload'] ?? const {}) as Map<String, dynamic>;

    switch (name) {
      case 'setText':
        print('setting text now...');
        final id = (payload['id'] ?? '') as String;
        final text = (payload['text'] ?? '') as String;
        if (id.isEmpty) {
          ws.add(
              WsMsg('error', {'code': 'BAD_REQUEST', 'message': 'Missing id'})
                  .encode());
          return;
        }
        final existing =
            _snapshot.items[id] ?? const OverlayItem(text: '', visible: true);
        _snapshot = _snapshot.copyWithItem(id, existing.copyWith(text: text));
        broadcastState();
        ws.add(WsMsg('ok').encode());
        return;

      case 'setVisible':
        final id = (payload['id'] ?? '') as String;
        final visible = payload['visible'];
        if (id.isEmpty || visible is! bool) {
          ws.add(WsMsg('error', {
            'code': 'BAD_REQUEST',
            'message': 'Missing id/visible'
          }).encode());
          return;
        }
        final existing =
            _snapshot.items[id] ?? const OverlayItem(text: '', visible: true);
        _snapshot =
            _snapshot.copyWithItem(id, existing.copyWith(visible: visible));
        broadcastState();
        ws.add(WsMsg('ok').encode());
        return;

      default:
        ws.add(WsMsg(
                'error', {'code': 'BAD_REQUEST', 'message': 'Unknown command'})
            .encode());
        return;
    }
  }

  void _respondText(HttpRequest req, String body,
      {required ContentType contentType}) async {
    req.response.headers.contentType = contentType;
    req.response.headers
        .set('Cache-Control', 'no-store'); // avoid stale overlay
    req.response.write(body);
    await req.response.close();
  }

  static String _generateToken({int bytesLength = 32}) {
    final rand = Random.secure();
    final bytes = List<int>.generate(bytesLength, (_) => rand.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  bool _tokenMatches(String provided) {
    final expected = _controllerToken;
    if (expected == null || expected.isEmpty) return false;
    if (provided.length != expected.length) return false;
    var diff = 0;
    for (var i = 0; i < expected.length; i++) {
      diff |= provided.codeUnitAt(i) ^ expected.codeUnitAt(i);
    }
    return diff == 0;
  }
}

import 'dart:async';
import 'dart:io';

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

  Future<void> start({
    required int port,
    required String controllerToken,
  }) async {
    if (isRunning) return;
    await ensureAssetsExtracted();
    _controllerToken = controllerToken;
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

        if (type == 'hello') {
          role = (msg['role'] ?? '') as String;

          // Prevent LAN from acting as overlay client
          if (role == 'overlay' && !isLoopback) {
            ws.add(WsMsg('error', {
              'code': 'FORBIDDEN',
              'message': 'Overlay role only allowed from localhost',
            }).encode());
            ws.close();
            return;
          }

          // Controllers from LAN must provide token
          if (role == 'controller' && !isLoopback) {
            final token = (msg['token'] ?? '') as String;
            if (token != _controllerToken) {
              ws.add(WsMsg('error', {
                'code': 'UNAUTH',
                'message': 'Invalid token',
              }).encode());
              return;
            }
          }

          authed = true;

          // Immediately send snapshot
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
          print('command verified');
          if (role != 'controller' && !(isLoopback && role == 'desktop')) {
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
}

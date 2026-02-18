import 'overlay_control_server.dart';
import 'overlay_file_system.dart';

/// Manages server life-cycle
class OverlayServerManager {
  final OverlayFilesystem fs;

  OverlayControlServer? _server;

  OverlayServerManager({required this.fs});

  bool get isRunning => _server != null;

  OverlayControlServer get server {
    final r = _server;
    if (r == null) throw StateError('Server not started');
    return r;
  }

  Future<void> start({
    int port = 17890,
    required String controllerToken,
  }) async {
    if (_server != null) return;

    await fs.ensureExtracted();

    final server = OverlayControlServer(
      port: port,
      controllerToken: controllerToken,
      readOverlayFile: fs.readOverlayFile,
    );

    await server.start();

    _server = server;
  }

  Future<void> stop() async {
    final s = _server;
    if (s == null) return;

    await s.stop();

    _server = null;
  }
}

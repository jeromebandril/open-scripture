abstract class RemoteControllerRepo {
  Future<void> start({required int port});
  Future<void> stop();
}

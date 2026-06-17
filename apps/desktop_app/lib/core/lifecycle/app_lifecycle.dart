abstract class AppLifecycleService {
  /// return true to exit the app
  Future<bool> onExitRequested();
}

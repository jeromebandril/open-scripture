import 'package:path_provider/path_provider.dart';

class ApplicationConstants {
  static const String baseURL = 'https://ebible.org/Scriptures';

  static Future<String> getApplicationPath() async {
    return (await getApplicationSupportDirectory()).path;
  }
}

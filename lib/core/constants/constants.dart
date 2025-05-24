import 'package:path_provider/path_provider.dart';

const String contentSourceURL = 'https://ebible.org/Scriptures';

Future<String> getApplicationPath() async {
  return (await getApplicationSupportDirectory()).path;
}

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'settings_datasource.dart';

abstract class SettingsDatasourceDesktopBase<T>
    implements SettingsDatasource<T> {
  Future<File> settingsFile({required String fileName}) async {
    final dir = await getApplicationSupportDirectory();
    final settingsDir = Directory(p.join(dir.path, 'settings'));
    if (!await settingsDir.exists()) {
      await settingsDir.create(recursive: true);
    }
    return File(p.join(settingsDir.path, fileName));
  }
}

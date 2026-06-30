import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/engines/settings/datasource/settings_datasource_desktop.dart';
import '../../domain/entities/bible_importer_settings.dart';

class BibleImporterSettingsDatasourceImpl
    extends SettingsDatasourceDesktopBase<BibleImporterSettings> {
  final String _fileName = 'bible_importer_settings.json';

  Future<String> _getDefaultSwordPath() async {
    final supportDir = await getApplicationSupportDirectory();
    return p.join(supportDir.path, 'sword');
  }

  @override
  Future<BibleImporterSettings> loadSettings() async {
    try {
      final file = await settingsFile(fileName: _fileName);
      final defaultPath = await _getDefaultSwordPath();

      if (!await file.exists()) {
        final defaults =
            BibleImporterSettings(swordInstallationPath: defaultPath);
        await saveSettings(defaults);
        return defaults;
      }

      final content = await file.readAsString();
      final decoded = jsonDecode(content);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid settings format');
      }

      final settings = BibleImporterSettings.fromJson(decoded);

      // Case 2: File exists but the path field inside is empty or corrupt
      if (settings.swordInstallationPath.isEmpty) {
        final patchedSettings =
            settings.copyWith(swordInstallationPath: defaultPath);
        await saveSettings(patchedSettings);
        return patchedSettings;
      }

      return settings;
    } catch (e) {
      final defaultPath = await _getDefaultSwordPath();
      return BibleImporterSettings(swordInstallationPath: defaultPath);
    }
  }

  @override
  Future<void> saveSettings(BibleImporterSettings settings) async {
    try {
      final file = await settingsFile(fileName: _fileName);
      final tmp = File('${file.path}.tmp');

      final jsonString =
          const JsonEncoder.withIndent('  ').convert(settings.toJson());

      // Write temp
      await tmp.writeAsString(jsonString, flush: true);

      // Replace target atomically where possible
      if (await file.exists()) {
        await file.delete();
      }
      await tmp.rename(file.path);
    } catch (e) {
      throw Exception('Failed to save remote controller settings');
    }
  }
}

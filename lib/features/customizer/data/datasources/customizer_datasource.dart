import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/cubit/customizer_cubit.dart';

abstract class CustomizerDatasource {
  /// Saves customizations locally.
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> saveTheme(CustomizerState theme);

  /// Load customizations.
  ///
  /// Throws a [InstallationException] if it fails
  Future<CustomizerState> loadTheme();
}

class CustomizerDatasourceImpl implements CustomizerDatasource {
  const CustomizerDatasourceImpl({this.fileName = 'settings.json'});

  final String fileName;

  Future<File> _settingsFile() async {
    final dir = await getApplicationSupportDirectory();
    final settingsDir = Directory(p.join(dir.path, 'settings'));
    if (!await settingsDir.exists()) {
      await settingsDir.create(recursive: true);
    }
    return File(p.join(settingsDir.path, fileName));
  }

  @override
  Future<void> saveTheme(CustomizerState theme) async {
    try {
      final file = await _settingsFile();
      final tmp = File('${file.path}.tmp');

      final jsonString =
          const JsonEncoder.withIndent('  ').convert(theme.toJson());

      // Write temp
      await tmp.writeAsString(jsonString, flush: true);

      // Replace target atomically where possible
      if (await file.exists()) {
        await file.delete();
      }
      await tmp.rename(file.path);
    } catch (e) {
      throw Exception();
    }
  }

  /// Load settings. If missing, returns defaults and writes them once.
  /// If corrupted, renames the bad file and returns defaults.
  @override
  Future<CustomizerState> loadTheme() async {
    try {
      final file = await _settingsFile();

      if (!await file.exists()) {
        const defaults = CustomizerState();
        await saveTheme(defaults);
        return defaults;
      }

      try {
        final content = await file.readAsString();
        final decoded = jsonDecode(content);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('settings.json root is not an object');
        }
        return CustomizerState.fromJson(decoded);
      } catch (e) {
        // Backup the corrupted file for debugging
        final backupPath =
            '${file.path}.corrupt.${DateTime.now().millisecondsSinceEpoch}';
        try {
          await file.rename(backupPath);
        } catch (_) {
          // If rename fails (e.g., permissions), ignore and proceed with defaults
        }
        const defaults = CustomizerState();
        await saveTheme(defaults);
        return defaults;
      }
    } catch (e) {
      throw Exception();
    }
  }
}

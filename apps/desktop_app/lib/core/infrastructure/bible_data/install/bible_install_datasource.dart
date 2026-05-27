import 'package:open_scripture/core/engines/bible_compiler/domain/models/artifact.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/importer_registry.dart';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package_factory.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart'
    as driftdb;
import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/error/exception.dart';
import 'package:open_scripture/core/infrastructure/database/installation_queries.dart';
import 'package:open_scripture/core/di/injection_container.dart' as di;

abstract class BibleInstallDatasource {
  /// Installs a previously downloaded bible archive into the local store.
  ///
  /// This method assumes the archive has already been downloaded to the
  /// deterministic location used by the remote data source (based on [bibleId]).
  ///
  /// Installation typically includes:
  /// - reading the downloaded ZIP file from disk
  /// - extracting USFX + metadata
  /// - parsing XML into models
  /// - writing content to SQLite (usually in a transaction)
  /// - cleanup of temporary artifacts
  ///
  /// Returns a [Stream] of [InstallProgress] describing the installation
  /// lifecycle (installing, writing to DB, done, failed).
  ///
  /// Errors are surfaced through the stream error channel as an [AppException]
  /// subtype (e.g. InstallFileMissingException, InstallParseException,
  /// InstallDatabaseException).
  Stream<InstallProgress> installBible(Artifact artifact);

  /// Uninstalls an installed bible from the local store.
  ///
  /// This should remove the bible metadata and all related content rows.
  ///
  /// Throws an [AppException] subtype if the operation fails.
  /// Common cases:
  /// - [UninstallNotFoundException] if the bible is not installed
  /// - [UninstallationException] for unexpected database failures
  Future<void> uninstallBible(String id);
}

class BibleInstallDatasourceImpl implements BibleInstallDatasource {
  final driftdb.AppDb db = di.sl();
  final ImporterRegistry importerRegistry = di.sl();
  final SourcePackageFactory sourcePackageFactory = di.sl();

  @override
  Stream<InstallProgress> installBible(Artifact artifact) async* {
    try {
      yield const InstallProgress(
        stage: InstallStage.installing,
        message: 'Preparing source...',
      );
      final pkg = await sourcePackageFactory.fromPath(artifact.path);

      yield const InstallProgress(
        stage: InstallStage.installing,
        message: 'Detecting format...',
      );
      final importer = await importerRegistry.resolve(pkg);

      yield InstallProgress(
        stage: InstallStage.installing,
        message: 'Parsing ${importer.formatId}...',
      );
      final canonical = await importer.importFrom(pkg);

      if (canonical.hasErrors) {
        yield InstallProgress(
          stage: InstallStage.failed,
          message: 'Import produced errors',
        );
        return;
      }

      yield const InstallProgress(
        stage: InstallStage.installing,
        message: 'Writing to database...',
      );
      try {
        await db.insertBible(
          canonical.data.bibleMeta,
          canonical.data.books,
          canonical.data.segments,
          canonical.data.spans,
        );
      } catch (e, st) {
        throw InstallDatabaseException(
          'Failed inserting bible into database',
          cause: e,
          stackTrace: st,
        );
      }

      yield const InstallProgress(
        stage: InstallStage.done,
        message: 'Installed',
      );
    } on InstallDatabaseException catch (e) {
      yield InstallProgress(
        stage: InstallStage.failed,
        received: 0,
        total: 0,
        message: e.message,
      );
    } catch (e) {
      yield const InstallProgress(
        stage: InstallStage.failed,
        received: 0,
        total: 0,
        message: 'Installation failed (unexpected error)',
      );
    }
  }

  @override
  Future<void> uninstallBible(String id) async {
    try {
      final deleted =
          await (db.delete(db.bibles)..where((b) => b.extId.equals(id))).go();

      if (deleted == 0) {
        throw UninstallNotFoundException('Bible not found: $id');
      }
    } catch (e, st) {
      if (e is UninstallNotFoundException) rethrow;

      throw UninstallationException(
        'Failed to uninstall bible: $id',
        cause: e,
        stackTrace: st,
      );
    }
  }
}

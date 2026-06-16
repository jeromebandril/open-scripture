import 'package:open_scripture/core/engines/bible_compiler/import/importer_registry.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';
import 'package:open_scripture/shared/data/services/source_fetcher_service.dart';
import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/data/datasources/bible_installation_datasource/drift_bible_installation_datasource_impl.dart';
import 'package:open_scripture/shared/domain/entities/bible_source.dart';
import 'package:open_scripture/shared/domain/services/bible_installer_strategy.dart';

class CanonicalInstallerStrategy implements BibleInstallerStrategy {
  final SourceFetcherService _fetcher;
  final ImporterRegistry _compiler;
  final BibleInstallationDataSource _localDataSource;

  CanonicalInstallerStrategy(
      {required SourceFetcherService fetcher,
      required ImporterRegistry compiler,
      required BibleInstallationDataSource localDataSource})
      : _fetcher = fetcher,
        _compiler = compiler,
        _localDataSource = localDataSource;

  @override
  Stream<InstallProgress> install(BibleSourceType source) async* {
    try {
      // STEP 1: FETCH
      yield InstallProgress(
          stage: InstallStage.downloading, message: 'Fetching...');
      final sourcePackage = await _fetcher.resolveSource(source);

      // STEP 2: PARSE
      yield const InstallProgress(
          stage: InstallStage.parsing, message: 'Parsing...');
      final importer = await _compiler.resolve(sourcePackage);
      final canonicalPackage = await importer.importFrom(sourcePackage);

      // STEP 3: COORDINATE & MAP TO AGNOSTIC DTOs
      yield const InstallProgress(
          stage: InstallStage.installing, message: 'Preparing installation...');

      final translation = canonicalPackage.data.bibleTranslation;

      final translationDto =
          TranslationInstallDtoMapper.fromDomain(translation);

      final bookDtos = canonicalPackage.data.books
          .map((b) => BookInstallDto(
                book: b.book,
                longName: b.longName,
                shortName: b.shortName,
              ))
          .toList();

      final List<VerseSegmentInstallDto> segmentDtos = [];
      for (final verse in canonicalPackage.data.verses) {
        for (final segment in verse.segments) {
          segmentDtos.add(VerseSegmentInstallDto(
            book: verse.ref.book,
            chapter: verse.ref.chapter,
            verse: verse.ref.verseStart!,
            segmentIndex: segment.segmentIndex,
            isParagraphStart: segment.isParagraphStart,
            spans: segment.spans,
          ));
        }
      }

      // STEP 4: PERSIST
      yield const InstallProgress(
          stage: InstallStage.installing, message: 'Saving to database...');
      await _localDataSource.installBible(
        languageEnglishName: translation.langEngName ?? 'Unknown',
        languageIsoCode: translation.langIsoCode ?? 'und',
        languageNativeName: translation.langNativeName,
        translation: translationDto,
        books: bookDtos,
        segments: segmentDtos,
      );

      yield const InstallProgress(
          stage: InstallStage.done, message: 'Success!');
    } catch (e) {
      yield InstallProgress(stage: InstallStage.failed, message: e.toString());
    } finally {
      await _fetcher.cleanup(source);
    }
  }

  @override
  Future<void> uninstall(dynamic bibleId) async {
    if (bibleId is! int) {
      throw ArgumentError.value(bibleId, 'bibleId',
          'Expected an int, but received a ${bibleId.runtimeType}.');
    }

    await _localDataSource.uninstallBible(bibleId: bibleId);
  }
}

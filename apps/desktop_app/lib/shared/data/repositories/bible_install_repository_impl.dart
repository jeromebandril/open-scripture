import 'package:open_scripture/core/engines/bible_compiler/import/importer_registry.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';
import 'package:open_scripture/shared/data/services/source_fetcher_service.dart';
import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/data/datasources/drift_bible_installation_datasource_impl.dart';

import '../../domain/repositories/bible_install_repository.dart';
import '../../domain/entities/bible_source.dart';

class BibleInstallRepositoryImpl implements BibleInstallRepository {
  final SourceFetcherService _fetcher;
  final ImporterRegistry _compiler;
  final BibleInstallationDataSource
      _localDataSource; // <-- Communicates only via the abstract interface

  BibleInstallRepositoryImpl(
      this._fetcher, this._compiler, this._localDataSource);

  @override
  Stream<InstallProgress> install(BibleSource source) async* {
    try {
      // STEP 1: FETCH
      yield InstallProgress(
          stage: InstallStage.downloading, message: 'Fetching...');
      final sourcePackage = await _fetcher.resolveSource(source);

      // STEP 2: PARSE (Yields Pure Domain Entities via the compiler)
      yield const InstallProgress(
          stage: InstallStage.parsing, message: 'Parsing...');
      final importer = await _compiler.resolve(sourcePackage);
      final canonicalPackage = await importer.importFrom(sourcePackage);

      // STEP 3: COORDINATE & MAP TO AGNOSTIC DTOs
      yield const InstallProgress(
          stage: InstallStage.installing, message: 'Preparing installation...');

      final translation = canonicalPackage.data.bibleTranslation;

      final translationDto = TranslationInstallDto(
        extId: translation.extId,
        name: translation.name,
        abbreviation: translation.abbreviation,
        description: translation.description,
      );

      final bookDtos = canonicalPackage.data.books
          .map((b) => BookInstallDto(
                book: b.book,
                longName: b.longName,
                shortName: b.shortName,
              ))
          .toList();

      // Flattens the nested structure: Verses -> Segments
      final List<VerseSegmentInstallDto> segmentDtos = [];
      for (final verse in canonicalPackage.data.verses) {
        for (final segment in verse.segments) {
          segmentDtos.add(
            VerseSegmentInstallDto(
              book: verse.ref.book,
              chapter: verse.ref.chapter,
              // should be not null since it is used as coordinate
              verse: verse.ref.verseStart!,
              segmentIndex: segment.segmentIndex,
              isParagraphStart: segment.isParagraphStart,
              spans: segment.spans,
            ),
          );
        }
      }

      // STEP 4: PERSIST (Hand over to the datasource layer)
      yield const InstallProgress(
          stage: InstallStage.installing, message: 'Saving to database...');

      await _localDataSource.installBible(
        languageEnglishName: translation.langEngName ?? 'Unknown',
        languageIsoCode: translation.langIsoCode ?? 'und', // undefined
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
}

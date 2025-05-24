import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/data/models/verse_model.dart';

import 'package:the_smyrna_bible_v2/core/domain/entities/verse.dart';

import 'package:the_smyrna_bible_v2/core/error/failure.dart';

import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/entities/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/datasources/bible_local_datasource.dart';

import '../../domain/repositories/reader_repository.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final BibleLocalDatasource localDatasource;

  const ReaderRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<Verse>>> getVerses(
      BibleReference reference) async {
    try {
      final List<VerseModel> models =
          await localDatasource.getVerses(reference);
      final List<Verse> verses = models.map((m) => m.toDomain()).toList();
      return Right(verses);
    } catch (e) {
      return Left(NotFoundFailure());
    }
  }

  // @override
  // Future<Either<Failure, Translation>> getTranslation(String id) {
  //   // TODO: implement getTranslation
  //   throw UnimplementedError();
  // }

  // @override
  // Future<Either<Failure, Translation>> openTranslation(String id) {
  //   // TODO: implement openTranslation
  //   throw UnimplementedError();
  // }
}

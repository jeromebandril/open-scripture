import 'package:flutter/foundation.dart';

import '../../../../core/infrastructure/database/daos/pericopes_dao.dart';
import '../../../../shared/domain/entities/bible_book.dart';
import '../../domain/entities/pericope.dart';
import '../../domain/entities/pericope_set.dart';
import '../models/pericope_set_dto.dart';

abstract class PericopeDatasource {
  Future<List<PericopeSet>> getAllPericopeSets();
  Future<PericopeSet?> getPericopeSetByExtId(String extId);
  Future<void> insertPericopeSet(PericopeSet pericopeSet);
  Future<void> updatePericopeSet(PericopeSet pericopeSet);
  Future<void> deletePericopeSet(String extId);
  Future<void> assignPericopeSetToLanguage(
      String langIsoCode, String? setExtId);
  Future<String?> getAssignedPericopeSetForLanguage(String langIsoCode);
  Future<List<Pericope>> getForChapter(
    String bibleExtId,
    BibleBook book,
    int chapter,
  );
}

class PericopeDatasourceImpl implements PericopeDatasource {
  final PericopesDao _dao;

  PericopeDatasourceImpl(this._dao);

  @override
  Future<List<PericopeSet>> getAllPericopeSets() async {
    final sets = await _dao.getAllPericopeSets();
    return sets.map(PericopeSetDto.fromJson).toList();
  }

  @override
  Future<void> assignPericopeSetToLanguage(
    String langIsoCode,
    String? setExtId,
  ) async {
    if (setExtId != null) {
      _dao.insertOrUpdatePericopeAssignment(
        langIsoCode: langIsoCode,
        setExtId: setExtId,
      );
      return;
    }
    _dao.deletePericopeAssignment(langIsoCode);
  }

  @override
  Future<void> deletePericopeSet(String extId) async =>
      _dao.deletePericopeSet(extId);

  @override
  Future<String?> getAssignedPericopeSetForLanguage(String langIsoCode) {
    // TODO: implement getAssignedPericopeSetForLanguage
    throw UnimplementedError();
  }

  @override
  Future<PericopeSet?> getPericopeSetByExtId(String extId) {
    // TODO: implement getPericopeSetByExtId
    throw UnimplementedError();
  }

  @override
  Future<void> insertPericopeSet(PericopeSet pericopeSet) {
    // _importer.importUserFile(source);
    // TODO: implement insertPericopeSet
    throw UnimplementedError();
  }

  @override
  Future<void> updatePericopeSet(PericopeSet pericopeSet) {
    // TODO: implement updatePericopeSet
    throw UnimplementedError();
  }

  @override
  Future<List<Pericope>> getForChapter(
    String bibleExtId,
    BibleBook book,
    int chapter,
  ) async {
    final rows = await _dao.getForChapter(bibleExtId, book, chapter);
    return rows
        .map((r) => Pericope(
              setId: r.setId,
              bookId: r.bookId,
              chapter: r.startChapter,
              startVerse: r.startVerse,
              endVerse: r.endVerse,
              title: r.title,
            ))
        .toList();
  }
}

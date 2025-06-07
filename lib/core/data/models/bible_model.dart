import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/database/database.dart';

import '../../domain/entities/e_bible.dart';

class BibleModel extends Equatable {
  final int? id;
  final String bibleName;
  final String abbreviation;
  final String? langEngName;
  final String? langNativeName;
  final String? langAbbreviation;
  final String? originSource;

  const BibleModel(
      {required this.id,
      required this.bibleName,
      required this.abbreviation,
      this.langEngName,
      this.langNativeName,
      this.langAbbreviation,
      this.originSource});

  factory BibleModel.fromDatabase(GetBiblesResult dbBible) {
    return BibleModel(
      id: dbBible.id,
      bibleName: dbBible.bibleName,
      abbreviation: dbBible.bibleNameAbbreviation,
    );
  }

  EBible toDomain() {
    return EBible(
      bibleName: bibleName,
      abbreviation: abbreviation,
      langEngName: langEngName,
      langNativeName: langNativeName,
      langAbbreviation: langAbbreviation,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bibleName,
        abbreviation,
        langEngName,
        langNativeName,
        langAbbreviation,
        originSource,
      ];
}

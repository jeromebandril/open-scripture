import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/database/database.dart';

class BibleMeta extends Equatable {
  final int? id;
  final String extId;
  final String bibleName;
  final String abbreviation;
  final String? langEngName;
  final String? langNativeName;
  final String? langIsoCode;
  final String? originSource;
  final bool isAlreadyInstalled;

  const BibleMeta({
    this.id,
    required this.extId,
    required this.bibleName,
    required this.abbreviation,
    this.langEngName,
    this.langNativeName,
    this.langIsoCode,
    this.originSource,
    this.isAlreadyInstalled = false,
  });

  factory BibleMeta.fromDatabase(Bible b) {
    return BibleMeta(
      id: b.id,
      extId: b.extId,
      bibleName: b.bibleName,
      abbreviation: b.bibleNameAbbreviation,
      originSource: b.originSource,
      isAlreadyInstalled: true,
    );
  }

  BibleMeta copyWith({
    int? id,
    String? extId,
    String? bibleName,
    String? abbreviation,
    String? langEngName,
    String? langNativeName,
    String? langAbbreviation,
    String? originSource,
    bool? isAlreadyInstalled,
  }) {
    return BibleMeta(
      id: id ?? this.id,
      extId: extId ?? this.extId,
      bibleName: bibleName ?? this.bibleName,
      abbreviation: abbreviation ?? this.abbreviation,
      langEngName: langEngName ?? this.langEngName,
      langNativeName: langNativeName ?? this.langNativeName,
      langIsoCode: langAbbreviation ?? this.langIsoCode,
      originSource: originSource ?? this.originSource,
      isAlreadyInstalled: isAlreadyInstalled ?? this.isAlreadyInstalled,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bibleName,
        abbreviation,
        langEngName,
        langNativeName,
        langIsoCode,
        originSource,
        isAlreadyInstalled
      ];
}

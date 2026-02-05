import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/database/database.dart';

class BibleMeta extends Equatable {
  final int? id;
  final String usfxId;
  final String bibleName;
  final String bibleNameLocal;
  final String abbreviation;
  final String? langEngName;
  final String? langNativeName;
  final String? langIsoCode;
  final String? originSource;
  final bool isAlreadyInstalled;

  const BibleMeta({
    this.id,
    required this.usfxId,
    required this.bibleName,
    required this.bibleNameLocal,
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
      usfxId: b.usfxId,
      bibleName: b.bibleName,
      bibleNameLocal: b.bibleNameLocal,
      abbreviation: b.bibleNameAbbreviation,
      originSource: b.originSource,
      isAlreadyInstalled: true,
    );
  }

  BibleMeta copyWith({
    int? id,
    String? extId,
    String? bibleName,
    String? bibleNameLocal,
    String? abbreviation,
    String? langEngName,
    String? langNativeName,
    String? langAbbreviation,
    String? originSource,
    bool? isAlreadyInstalled,
  }) {
    return BibleMeta(
      id: id ?? this.id,
      usfxId: extId ?? this.usfxId,
      bibleName: bibleName ?? this.bibleName,
      abbreviation: abbreviation ?? this.abbreviation,
      langEngName: langEngName ?? this.langEngName,
      langNativeName: langNativeName ?? this.langNativeName,
      langIsoCode: langAbbreviation ?? this.langIsoCode,
      originSource: originSource ?? this.originSource,
      isAlreadyInstalled: isAlreadyInstalled ?? this.isAlreadyInstalled,
      bibleNameLocal: bibleNameLocal ?? this.bibleNameLocal,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bibleName,
        bibleNameLocal,
        abbreviation,
        langEngName,
        langNativeName,
        langIsoCode,
        originSource,
        isAlreadyInstalled
      ];
}

import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart';

class BibleMeta extends Equatable {
  final int? id;
  final String extId;
  final String bibleName;
  final String bibleNameLocal;
  final String abbreviation;
  final String? langEngName;
  final String? langNativeName;
  final String? langIsoCode;
  final String? originSource;
  final String? originFormat;
  final String? description;
  final String? copyright;
  final bool isAlreadyInstalled;

  const BibleMeta({
    this.id,
    required this.extId,
    required this.bibleName,
    required this.bibleNameLocal,
    required this.abbreviation,
    this.langEngName,
    this.langNativeName,
    this.langIsoCode,
    this.originSource,
    this.originFormat,
    this.isAlreadyInstalled = false,
    this.description,
    this.copyright,
  });

  factory BibleMeta.fromDatabase(Bible b) {
    return BibleMeta(
      id: b.id,
      extId: b.extId,
      bibleName: b.bibleName,
      bibleNameLocal: b.bibleNameLocal,
      abbreviation: b.bibleNameAbbreviation,
      originSource: b.originSource,
      originFormat: b.originFormat,
      description: b.description,
      copyright: b.copyright,
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
    String? langIsoCode,
    String? originSource,
    String? originFormat,
    String? description,
    String? copyright,
    bool? isAlreadyInstalled,
  }) {
    return BibleMeta(
      id: id ?? this.id,
      extId: extId ?? this.extId,
      bibleName: bibleName ?? this.bibleName,
      bibleNameLocal: bibleNameLocal ?? this.bibleNameLocal,
      abbreviation: abbreviation ?? this.abbreviation,
      originSource: originSource ?? this.originSource,
      originFormat: originFormat ?? this.originFormat,
      description: description ?? this.description,
      copyright: copyright ?? this.copyright,
      langEngName: langEngName ?? this.langEngName,
      langNativeName: langNativeName ?? this.langNativeName,
      langIsoCode: langIsoCode ?? this.langIsoCode,
      isAlreadyInstalled: isAlreadyInstalled ?? this.isAlreadyInstalled,
    );
  }

  Map<String, String> toMap() {
    return {
      'Id': '$id',
      'usfxId': '$extId',
      'Name': '$bibleName',
      'Local Name': '$bibleNameLocal',
      'Abbreviation': '$abbreviation',
      'Origin Source': '$originSource',
      'Original Format': '$originFormat',
      'Description': '$description',
      'Copyright': '$copyright',
      'Language (eng)': '$langEngName',
      'Language (native)': '$langNativeName',
      'Language (iso 639)': '$langIsoCode',
    };
  }

  Map<String, String> toJson() {
    return {
      'id': '$id',
      'usfx_id': '$extId',
      'name': '$bibleName',
      'local_name': '$bibleNameLocal',
      'abbreviation': '$abbreviation',
      'origin_source': '$originSource',
      'original_format': '$originFormat',
      'description': '$description',
      'copyright': '$copyright',
      'language_eng': '$langEngName',
      'language_native': '$langNativeName',
      'language_iso_code': '$langIsoCode',
    };
  }

  BibleMeta fromJson(Map<String, dynamic> json) {
    return BibleMeta(
      id: int.tryParse(json['id'] as String? ?? ''),
      extId: json['usfx_id'] as String,
      bibleName: json['name'] as String,
      bibleNameLocal: json['local_name'] as String,
      abbreviation: json['abbreviation'] as String,
      originSource: json['origin_source'] as String?,
      originFormat: json['original_format'] as String?,
      description: json['description'] as String?,
      copyright: json['copyright'] as String?,
      langEngName: json['language_eng'] as String?,
      langNativeName: json['language_native'] as String?,
      langIsoCode: json['language_iso_code'] as String?,
    );
  }

  @override
  String toString() {
    return '''
    id: $id 
    usfxId: $extId 
    bibleName: $bibleName 
    localBibleName: $bibleNameLocal 
    abbreviation: $abbreviation 
    originSource: $originSource
    originFormat: $originFormat
    desc: $description 
    copyright: $copyright 
    langEngName: $langEngName 
    langNativeName: $langNativeName 
    langIsoCode: $langIsoCode 
    ''';
  }

  @override
  List<Object?> get props => [
        id,
        bibleName,
        bibleNameLocal,
        abbreviation,
        originSource,
        originFormat,
        description,
        copyright,
        langEngName,
        langNativeName,
        langIsoCode,
        isAlreadyInstalled
      ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Languages extends Table with TableInfo<Languages, Language> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Languages(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _langEngNameMeta =
      const VerificationMeta('langEngName');
  late final GeneratedColumn<String> langEngName = GeneratedColumn<String>(
      'langEngName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _langNativeNameMeta =
      const VerificationMeta('langNativeName');
  late final GeneratedColumn<String> langNativeName = GeneratedColumn<String>(
      'langNativeName', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _langIsoCodeMeta =
      const VerificationMeta('langIsoCode');
  late final GeneratedColumn<String> langIsoCode = GeneratedColumn<String>(
      'langIsoCode', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, langEngName, langNativeName, langIsoCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'languages';
  @override
  VerificationContext validateIntegrity(Insertable<Language> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('langEngName')) {
      context.handle(
          _langEngNameMeta,
          langEngName.isAcceptableOrUnknown(
              data['langEngName']!, _langEngNameMeta));
    } else if (isInserting) {
      context.missing(_langEngNameMeta);
    }
    if (data.containsKey('langNativeName')) {
      context.handle(
          _langNativeNameMeta,
          langNativeName.isAcceptableOrUnknown(
              data['langNativeName']!, _langNativeNameMeta));
    }
    if (data.containsKey('langIsoCode')) {
      context.handle(
          _langIsoCodeMeta,
          langIsoCode.isAcceptableOrUnknown(
              data['langIsoCode']!, _langIsoCodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Language map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Language(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      langEngName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}langEngName'])!,
      langNativeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}langNativeName']),
      langIsoCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}langIsoCode']),
    );
  }

  @override
  Languages createAlias(String alias) {
    return Languages(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Language extends DataClass implements Insertable<Language> {
  final int id;
  final String langEngName;
  final String? langNativeName;
  final String? langIsoCode;
  const Language(
      {required this.id,
      required this.langEngName,
      this.langNativeName,
      this.langIsoCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['langEngName'] = Variable<String>(langEngName);
    if (!nullToAbsent || langNativeName != null) {
      map['langNativeName'] = Variable<String>(langNativeName);
    }
    if (!nullToAbsent || langIsoCode != null) {
      map['langIsoCode'] = Variable<String>(langIsoCode);
    }
    return map;
  }

  LanguagesCompanion toCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      id: Value(id),
      langEngName: Value(langEngName),
      langNativeName: langNativeName == null && nullToAbsent
          ? const Value.absent()
          : Value(langNativeName),
      langIsoCode: langIsoCode == null && nullToAbsent
          ? const Value.absent()
          : Value(langIsoCode),
    );
  }

  factory Language.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Language(
      id: serializer.fromJson<int>(json['id']),
      langEngName: serializer.fromJson<String>(json['langEngName']),
      langNativeName: serializer.fromJson<String?>(json['langNativeName']),
      langIsoCode: serializer.fromJson<String?>(json['langIsoCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'langEngName': serializer.toJson<String>(langEngName),
      'langNativeName': serializer.toJson<String?>(langNativeName),
      'langIsoCode': serializer.toJson<String?>(langIsoCode),
    };
  }

  Language copyWith(
          {int? id,
          String? langEngName,
          Value<String?> langNativeName = const Value.absent(),
          Value<String?> langIsoCode = const Value.absent()}) =>
      Language(
        id: id ?? this.id,
        langEngName: langEngName ?? this.langEngName,
        langNativeName:
            langNativeName.present ? langNativeName.value : this.langNativeName,
        langIsoCode: langIsoCode.present ? langIsoCode.value : this.langIsoCode,
      );
  Language copyWithCompanion(LanguagesCompanion data) {
    return Language(
      id: data.id.present ? data.id.value : this.id,
      langEngName:
          data.langEngName.present ? data.langEngName.value : this.langEngName,
      langNativeName: data.langNativeName.present
          ? data.langNativeName.value
          : this.langNativeName,
      langIsoCode:
          data.langIsoCode.present ? data.langIsoCode.value : this.langIsoCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Language(')
          ..write('id: $id, ')
          ..write('langEngName: $langEngName, ')
          ..write('langNativeName: $langNativeName, ')
          ..write('langIsoCode: $langIsoCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, langEngName, langNativeName, langIsoCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Language &&
          other.id == this.id &&
          other.langEngName == this.langEngName &&
          other.langNativeName == this.langNativeName &&
          other.langIsoCode == this.langIsoCode);
}

class LanguagesCompanion extends UpdateCompanion<Language> {
  final Value<int> id;
  final Value<String> langEngName;
  final Value<String?> langNativeName;
  final Value<String?> langIsoCode;
  const LanguagesCompanion({
    this.id = const Value.absent(),
    this.langEngName = const Value.absent(),
    this.langNativeName = const Value.absent(),
    this.langIsoCode = const Value.absent(),
  });
  LanguagesCompanion.insert({
    this.id = const Value.absent(),
    required String langEngName,
    this.langNativeName = const Value.absent(),
    this.langIsoCode = const Value.absent(),
  }) : langEngName = Value(langEngName);
  static Insertable<Language> custom({
    Expression<int>? id,
    Expression<String>? langEngName,
    Expression<String>? langNativeName,
    Expression<String>? langIsoCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langEngName != null) 'langEngName': langEngName,
      if (langNativeName != null) 'langNativeName': langNativeName,
      if (langIsoCode != null) 'langIsoCode': langIsoCode,
    });
  }

  LanguagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? langEngName,
      Value<String?>? langNativeName,
      Value<String?>? langIsoCode}) {
    return LanguagesCompanion(
      id: id ?? this.id,
      langEngName: langEngName ?? this.langEngName,
      langNativeName: langNativeName ?? this.langNativeName,
      langIsoCode: langIsoCode ?? this.langIsoCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (langEngName.present) {
      map['langEngName'] = Variable<String>(langEngName.value);
    }
    if (langNativeName.present) {
      map['langNativeName'] = Variable<String>(langNativeName.value);
    }
    if (langIsoCode.present) {
      map['langIsoCode'] = Variable<String>(langIsoCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesCompanion(')
          ..write('id: $id, ')
          ..write('langEngName: $langEngName, ')
          ..write('langNativeName: $langNativeName, ')
          ..write('langIsoCode: $langIsoCode')
          ..write(')'))
        .toString();
  }
}

class Bibles extends Table with TableInfo<Bibles, Bible> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Bibles(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _usfxIdMeta = const VerificationMeta('usfxId');
  late final GeneratedColumn<String> usfxId = GeneratedColumn<String>(
      'usfxId', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _languageIdMeta =
      const VerificationMeta('languageId');
  late final GeneratedColumn<int> languageId = GeneratedColumn<int>(
      'languageId', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _bibleNameMeta =
      const VerificationMeta('bibleName');
  late final GeneratedColumn<String> bibleName = GeneratedColumn<String>(
      'bibleName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _bibleNameLocalMeta =
      const VerificationMeta('bibleNameLocal');
  late final GeneratedColumn<String> bibleNameLocal = GeneratedColumn<String>(
      'bibleNameLocal', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _bibleNameAbbreviationMeta =
      const VerificationMeta('bibleNameAbbreviation');
  late final GeneratedColumn<String> bibleNameAbbreviation =
      GeneratedColumn<String>('bibleNameAbbreviation', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          $customConstraints: 'NOT NULL');
  static const VerificationMeta _originSourceMeta =
      const VerificationMeta('originSource');
  late final GeneratedColumn<String> originSource = GeneratedColumn<String>(
      'originSource', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        usfxId,
        languageId,
        bibleName,
        bibleNameLocal,
        bibleNameAbbreviation,
        originSource
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bibles';
  @override
  VerificationContext validateIntegrity(Insertable<Bible> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usfxId')) {
      context.handle(_usfxIdMeta,
          usfxId.isAcceptableOrUnknown(data['usfxId']!, _usfxIdMeta));
    } else if (isInserting) {
      context.missing(_usfxIdMeta);
    }
    if (data.containsKey('languageId')) {
      context.handle(
          _languageIdMeta,
          languageId.isAcceptableOrUnknown(
              data['languageId']!, _languageIdMeta));
    }
    if (data.containsKey('bibleName')) {
      context.handle(_bibleNameMeta,
          bibleName.isAcceptableOrUnknown(data['bibleName']!, _bibleNameMeta));
    } else if (isInserting) {
      context.missing(_bibleNameMeta);
    }
    if (data.containsKey('bibleNameLocal')) {
      context.handle(
          _bibleNameLocalMeta,
          bibleNameLocal.isAcceptableOrUnknown(
              data['bibleNameLocal']!, _bibleNameLocalMeta));
    } else if (isInserting) {
      context.missing(_bibleNameLocalMeta);
    }
    if (data.containsKey('bibleNameAbbreviation')) {
      context.handle(
          _bibleNameAbbreviationMeta,
          bibleNameAbbreviation.isAcceptableOrUnknown(
              data['bibleNameAbbreviation']!, _bibleNameAbbreviationMeta));
    } else if (isInserting) {
      context.missing(_bibleNameAbbreviationMeta);
    }
    if (data.containsKey('originSource')) {
      context.handle(
          _originSourceMeta,
          originSource.isAcceptableOrUnknown(
              data['originSource']!, _originSourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bible map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bible(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      usfxId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usfxId'])!,
      languageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}languageId']),
      bibleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bibleName'])!,
      bibleNameLocal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bibleNameLocal'])!,
      bibleNameAbbreviation: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}bibleNameAbbreviation'])!,
      originSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}originSource']),
    );
  }

  @override
  Bibles createAlias(String alias) {
    return Bibles(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['FOREIGN KEY(languageId)REFERENCES languages(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Bible extends DataClass implements Insertable<Bible> {
  final int id;
  final String usfxId;
  final int? languageId;
  final String bibleName;
  final String bibleNameLocal;
  final String bibleNameAbbreviation;
  final String? originSource;
  const Bible(
      {required this.id,
      required this.usfxId,
      this.languageId,
      required this.bibleName,
      required this.bibleNameLocal,
      required this.bibleNameAbbreviation,
      this.originSource});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usfxId'] = Variable<String>(usfxId);
    if (!nullToAbsent || languageId != null) {
      map['languageId'] = Variable<int>(languageId);
    }
    map['bibleName'] = Variable<String>(bibleName);
    map['bibleNameLocal'] = Variable<String>(bibleNameLocal);
    map['bibleNameAbbreviation'] = Variable<String>(bibleNameAbbreviation);
    if (!nullToAbsent || originSource != null) {
      map['originSource'] = Variable<String>(originSource);
    }
    return map;
  }

  BiblesCompanion toCompanion(bool nullToAbsent) {
    return BiblesCompanion(
      id: Value(id),
      usfxId: Value(usfxId),
      languageId: languageId == null && nullToAbsent
          ? const Value.absent()
          : Value(languageId),
      bibleName: Value(bibleName),
      bibleNameLocal: Value(bibleNameLocal),
      bibleNameAbbreviation: Value(bibleNameAbbreviation),
      originSource: originSource == null && nullToAbsent
          ? const Value.absent()
          : Value(originSource),
    );
  }

  factory Bible.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bible(
      id: serializer.fromJson<int>(json['id']),
      usfxId: serializer.fromJson<String>(json['usfxId']),
      languageId: serializer.fromJson<int?>(json['languageId']),
      bibleName: serializer.fromJson<String>(json['bibleName']),
      bibleNameLocal: serializer.fromJson<String>(json['bibleNameLocal']),
      bibleNameAbbreviation:
          serializer.fromJson<String>(json['bibleNameAbbreviation']),
      originSource: serializer.fromJson<String?>(json['originSource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usfxId': serializer.toJson<String>(usfxId),
      'languageId': serializer.toJson<int?>(languageId),
      'bibleName': serializer.toJson<String>(bibleName),
      'bibleNameLocal': serializer.toJson<String>(bibleNameLocal),
      'bibleNameAbbreviation': serializer.toJson<String>(bibleNameAbbreviation),
      'originSource': serializer.toJson<String?>(originSource),
    };
  }

  Bible copyWith(
          {int? id,
          String? usfxId,
          Value<int?> languageId = const Value.absent(),
          String? bibleName,
          String? bibleNameLocal,
          String? bibleNameAbbreviation,
          Value<String?> originSource = const Value.absent()}) =>
      Bible(
        id: id ?? this.id,
        usfxId: usfxId ?? this.usfxId,
        languageId: languageId.present ? languageId.value : this.languageId,
        bibleName: bibleName ?? this.bibleName,
        bibleNameLocal: bibleNameLocal ?? this.bibleNameLocal,
        bibleNameAbbreviation:
            bibleNameAbbreviation ?? this.bibleNameAbbreviation,
        originSource:
            originSource.present ? originSource.value : this.originSource,
      );
  Bible copyWithCompanion(BiblesCompanion data) {
    return Bible(
      id: data.id.present ? data.id.value : this.id,
      usfxId: data.usfxId.present ? data.usfxId.value : this.usfxId,
      languageId:
          data.languageId.present ? data.languageId.value : this.languageId,
      bibleName: data.bibleName.present ? data.bibleName.value : this.bibleName,
      bibleNameLocal: data.bibleNameLocal.present
          ? data.bibleNameLocal.value
          : this.bibleNameLocal,
      bibleNameAbbreviation: data.bibleNameAbbreviation.present
          ? data.bibleNameAbbreviation.value
          : this.bibleNameAbbreviation,
      originSource: data.originSource.present
          ? data.originSource.value
          : this.originSource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bible(')
          ..write('id: $id, ')
          ..write('usfxId: $usfxId, ')
          ..write('languageId: $languageId, ')
          ..write('bibleName: $bibleName, ')
          ..write('bibleNameLocal: $bibleNameLocal, ')
          ..write('bibleNameAbbreviation: $bibleNameAbbreviation, ')
          ..write('originSource: $originSource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, usfxId, languageId, bibleName,
      bibleNameLocal, bibleNameAbbreviation, originSource);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bible &&
          other.id == this.id &&
          other.usfxId == this.usfxId &&
          other.languageId == this.languageId &&
          other.bibleName == this.bibleName &&
          other.bibleNameLocal == this.bibleNameLocal &&
          other.bibleNameAbbreviation == this.bibleNameAbbreviation &&
          other.originSource == this.originSource);
}

class BiblesCompanion extends UpdateCompanion<Bible> {
  final Value<int> id;
  final Value<String> usfxId;
  final Value<int?> languageId;
  final Value<String> bibleName;
  final Value<String> bibleNameLocal;
  final Value<String> bibleNameAbbreviation;
  final Value<String?> originSource;
  const BiblesCompanion({
    this.id = const Value.absent(),
    this.usfxId = const Value.absent(),
    this.languageId = const Value.absent(),
    this.bibleName = const Value.absent(),
    this.bibleNameLocal = const Value.absent(),
    this.bibleNameAbbreviation = const Value.absent(),
    this.originSource = const Value.absent(),
  });
  BiblesCompanion.insert({
    this.id = const Value.absent(),
    required String usfxId,
    this.languageId = const Value.absent(),
    required String bibleName,
    required String bibleNameLocal,
    required String bibleNameAbbreviation,
    this.originSource = const Value.absent(),
  })  : usfxId = Value(usfxId),
        bibleName = Value(bibleName),
        bibleNameLocal = Value(bibleNameLocal),
        bibleNameAbbreviation = Value(bibleNameAbbreviation);
  static Insertable<Bible> custom({
    Expression<int>? id,
    Expression<String>? usfxId,
    Expression<int>? languageId,
    Expression<String>? bibleName,
    Expression<String>? bibleNameLocal,
    Expression<String>? bibleNameAbbreviation,
    Expression<String>? originSource,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usfxId != null) 'usfxId': usfxId,
      if (languageId != null) 'languageId': languageId,
      if (bibleName != null) 'bibleName': bibleName,
      if (bibleNameLocal != null) 'bibleNameLocal': bibleNameLocal,
      if (bibleNameAbbreviation != null)
        'bibleNameAbbreviation': bibleNameAbbreviation,
      if (originSource != null) 'originSource': originSource,
    });
  }

  BiblesCompanion copyWith(
      {Value<int>? id,
      Value<String>? usfxId,
      Value<int?>? languageId,
      Value<String>? bibleName,
      Value<String>? bibleNameLocal,
      Value<String>? bibleNameAbbreviation,
      Value<String?>? originSource}) {
    return BiblesCompanion(
      id: id ?? this.id,
      usfxId: usfxId ?? this.usfxId,
      languageId: languageId ?? this.languageId,
      bibleName: bibleName ?? this.bibleName,
      bibleNameLocal: bibleNameLocal ?? this.bibleNameLocal,
      bibleNameAbbreviation:
          bibleNameAbbreviation ?? this.bibleNameAbbreviation,
      originSource: originSource ?? this.originSource,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usfxId.present) {
      map['usfxId'] = Variable<String>(usfxId.value);
    }
    if (languageId.present) {
      map['languageId'] = Variable<int>(languageId.value);
    }
    if (bibleName.present) {
      map['bibleName'] = Variable<String>(bibleName.value);
    }
    if (bibleNameLocal.present) {
      map['bibleNameLocal'] = Variable<String>(bibleNameLocal.value);
    }
    if (bibleNameAbbreviation.present) {
      map['bibleNameAbbreviation'] =
          Variable<String>(bibleNameAbbreviation.value);
    }
    if (originSource.present) {
      map['originSource'] = Variable<String>(originSource.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BiblesCompanion(')
          ..write('id: $id, ')
          ..write('usfxId: $usfxId, ')
          ..write('languageId: $languageId, ')
          ..write('bibleName: $bibleName, ')
          ..write('bibleNameLocal: $bibleNameLocal, ')
          ..write('bibleNameAbbreviation: $bibleNameAbbreviation, ')
          ..write('originSource: $originSource')
          ..write(')'))
        .toString();
  }
}

class Books extends Table with TableInfo<Books, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Books(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _bibleIdMeta =
      const VerificationMeta('bibleId');
  late final GeneratedColumn<int> bibleId = GeneratedColumn<int>(
      'bibleId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _usfxIdMeta = const VerificationMeta('usfxId');
  late final GeneratedColumn<String> usfxId = GeneratedColumn<String>(
      'usfxId', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _osisIdMeta = const VerificationMeta('osisId');
  late final GeneratedColumn<String> osisId = GeneratedColumn<String>(
      'osisId', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _bookOrderMeta =
      const VerificationMeta('bookOrder');
  late final GeneratedColumn<int> bookOrder = GeneratedColumn<int>(
      'bookOrder', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _longNameMeta =
      const VerificationMeta('longName');
  late final GeneratedColumn<String> longName = GeneratedColumn<String>(
      'longName', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _shortNameMeta =
      const VerificationMeta('shortName');
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
      'shortName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, bibleId, usfxId, osisId, bookOrder, longName, shortName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(Insertable<Book> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bibleId')) {
      context.handle(_bibleIdMeta,
          bibleId.isAcceptableOrUnknown(data['bibleId']!, _bibleIdMeta));
    } else if (isInserting) {
      context.missing(_bibleIdMeta);
    }
    if (data.containsKey('usfxId')) {
      context.handle(_usfxIdMeta,
          usfxId.isAcceptableOrUnknown(data['usfxId']!, _usfxIdMeta));
    } else if (isInserting) {
      context.missing(_usfxIdMeta);
    }
    if (data.containsKey('osisId')) {
      context.handle(_osisIdMeta,
          osisId.isAcceptableOrUnknown(data['osisId']!, _osisIdMeta));
    } else if (isInserting) {
      context.missing(_osisIdMeta);
    }
    if (data.containsKey('bookOrder')) {
      context.handle(_bookOrderMeta,
          bookOrder.isAcceptableOrUnknown(data['bookOrder']!, _bookOrderMeta));
    }
    if (data.containsKey('longName')) {
      context.handle(_longNameMeta,
          longName.isAcceptableOrUnknown(data['longName']!, _longNameMeta));
    }
    if (data.containsKey('shortName')) {
      context.handle(_shortNameMeta,
          shortName.isAcceptableOrUnknown(data['shortName']!, _shortNameMeta));
    } else if (isInserting) {
      context.missing(_shortNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {bibleId, usfxId},
      ];
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bibleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bibleId'])!,
      usfxId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usfxId'])!,
      osisId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}osisId'])!,
      bookOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookOrder']),
      longName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}longName']),
      shortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shortName'])!,
    );
  }

  @override
  Books createAlias(String alias) {
    return Books(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY(bibleId)REFERENCES bibles(id)ON DELETE CASCADE',
        'UNIQUE(bibleId, usfxId)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final int bibleId;
  final String usfxId;
  final String osisId;
  final int? bookOrder;
  final String? longName;
  final String shortName;
  const Book(
      {required this.id,
      required this.bibleId,
      required this.usfxId,
      required this.osisId,
      this.bookOrder,
      this.longName,
      required this.shortName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bibleId'] = Variable<int>(bibleId);
    map['usfxId'] = Variable<String>(usfxId);
    map['osisId'] = Variable<String>(osisId);
    if (!nullToAbsent || bookOrder != null) {
      map['bookOrder'] = Variable<int>(bookOrder);
    }
    if (!nullToAbsent || longName != null) {
      map['longName'] = Variable<String>(longName);
    }
    map['shortName'] = Variable<String>(shortName);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      bibleId: Value(bibleId),
      usfxId: Value(usfxId),
      osisId: Value(osisId),
      bookOrder: bookOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOrder),
      longName: longName == null && nullToAbsent
          ? const Value.absent()
          : Value(longName),
      shortName: Value(shortName),
    );
  }

  factory Book.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      bibleId: serializer.fromJson<int>(json['bibleId']),
      usfxId: serializer.fromJson<String>(json['usfxId']),
      osisId: serializer.fromJson<String>(json['osisId']),
      bookOrder: serializer.fromJson<int?>(json['bookOrder']),
      longName: serializer.fromJson<String?>(json['longName']),
      shortName: serializer.fromJson<String>(json['shortName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bibleId': serializer.toJson<int>(bibleId),
      'usfxId': serializer.toJson<String>(usfxId),
      'osisId': serializer.toJson<String>(osisId),
      'bookOrder': serializer.toJson<int?>(bookOrder),
      'longName': serializer.toJson<String?>(longName),
      'shortName': serializer.toJson<String>(shortName),
    };
  }

  Book copyWith(
          {int? id,
          int? bibleId,
          String? usfxId,
          String? osisId,
          Value<int?> bookOrder = const Value.absent(),
          Value<String?> longName = const Value.absent(),
          String? shortName}) =>
      Book(
        id: id ?? this.id,
        bibleId: bibleId ?? this.bibleId,
        usfxId: usfxId ?? this.usfxId,
        osisId: osisId ?? this.osisId,
        bookOrder: bookOrder.present ? bookOrder.value : this.bookOrder,
        longName: longName.present ? longName.value : this.longName,
        shortName: shortName ?? this.shortName,
      );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      bibleId: data.bibleId.present ? data.bibleId.value : this.bibleId,
      usfxId: data.usfxId.present ? data.usfxId.value : this.usfxId,
      osisId: data.osisId.present ? data.osisId.value : this.osisId,
      bookOrder: data.bookOrder.present ? data.bookOrder.value : this.bookOrder,
      longName: data.longName.present ? data.longName.value : this.longName,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('bibleId: $bibleId, ')
          ..write('usfxId: $usfxId, ')
          ..write('osisId: $osisId, ')
          ..write('bookOrder: $bookOrder, ')
          ..write('longName: $longName, ')
          ..write('shortName: $shortName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bibleId, usfxId, osisId, bookOrder, longName, shortName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.bibleId == this.bibleId &&
          other.usfxId == this.usfxId &&
          other.osisId == this.osisId &&
          other.bookOrder == this.bookOrder &&
          other.longName == this.longName &&
          other.shortName == this.shortName);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<int> bibleId;
  final Value<String> usfxId;
  final Value<String> osisId;
  final Value<int?> bookOrder;
  final Value<String?> longName;
  final Value<String> shortName;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.bibleId = const Value.absent(),
    this.usfxId = const Value.absent(),
    this.osisId = const Value.absent(),
    this.bookOrder = const Value.absent(),
    this.longName = const Value.absent(),
    this.shortName = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required int bibleId,
    required String usfxId,
    required String osisId,
    this.bookOrder = const Value.absent(),
    this.longName = const Value.absent(),
    required String shortName,
  })  : bibleId = Value(bibleId),
        usfxId = Value(usfxId),
        osisId = Value(osisId),
        shortName = Value(shortName);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<int>? bibleId,
    Expression<String>? usfxId,
    Expression<String>? osisId,
    Expression<int>? bookOrder,
    Expression<String>? longName,
    Expression<String>? shortName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bibleId != null) 'bibleId': bibleId,
      if (usfxId != null) 'usfxId': usfxId,
      if (osisId != null) 'osisId': osisId,
      if (bookOrder != null) 'bookOrder': bookOrder,
      if (longName != null) 'longName': longName,
      if (shortName != null) 'shortName': shortName,
    });
  }

  BooksCompanion copyWith(
      {Value<int>? id,
      Value<int>? bibleId,
      Value<String>? usfxId,
      Value<String>? osisId,
      Value<int?>? bookOrder,
      Value<String?>? longName,
      Value<String>? shortName}) {
    return BooksCompanion(
      id: id ?? this.id,
      bibleId: bibleId ?? this.bibleId,
      usfxId: usfxId ?? this.usfxId,
      osisId: osisId ?? this.osisId,
      bookOrder: bookOrder ?? this.bookOrder,
      longName: longName ?? this.longName,
      shortName: shortName ?? this.shortName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bibleId.present) {
      map['bibleId'] = Variable<int>(bibleId.value);
    }
    if (usfxId.present) {
      map['usfxId'] = Variable<String>(usfxId.value);
    }
    if (osisId.present) {
      map['osisId'] = Variable<String>(osisId.value);
    }
    if (bookOrder.present) {
      map['bookOrder'] = Variable<int>(bookOrder.value);
    }
    if (longName.present) {
      map['longName'] = Variable<String>(longName.value);
    }
    if (shortName.present) {
      map['shortName'] = Variable<String>(shortName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('bibleId: $bibleId, ')
          ..write('usfxId: $usfxId, ')
          ..write('osisId: $osisId, ')
          ..write('bookOrder: $bookOrder, ')
          ..write('longName: $longName, ')
          ..write('shortName: $shortName')
          ..write(')'))
        .toString();
  }
}

class VerseSegments extends Table with TableInfo<VerseSegments, VerseSegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VerseSegments(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'bookId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _chapterNumberMeta =
      const VerificationMeta('chapterNumber');
  late final GeneratedColumn<int> chapterNumber = GeneratedColumn<int>(
      'chapterNumber', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _verseNumberMeta =
      const VerificationMeta('verseNumber');
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
      'verseNumber', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _segmentIndexMeta =
      const VerificationMeta('segmentIndex');
  late final GeneratedColumn<int> segmentIndex = GeneratedColumn<int>(
      'segmentIndex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _paragraphStartMeta =
      const VerificationMeta('paragraphStart');
  late final GeneratedColumn<int> paragraphStart = GeneratedColumn<int>(
      'paragraphStart', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'textContent', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _subtitleMeta =
      const VerificationMeta('subtitle');
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
      'subtitle', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bookId,
        chapterNumber,
        verseNumber,
        segmentIndex,
        paragraphStart,
        textContent,
        subtitle
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_segments';
  @override
  VerificationContext validateIntegrity(Insertable<VerseSegment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bookId')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['bookId']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapterNumber')) {
      context.handle(
          _chapterNumberMeta,
          chapterNumber.isAcceptableOrUnknown(
              data['chapterNumber']!, _chapterNumberMeta));
    } else if (isInserting) {
      context.missing(_chapterNumberMeta);
    }
    if (data.containsKey('verseNumber')) {
      context.handle(
          _verseNumberMeta,
          verseNumber.isAcceptableOrUnknown(
              data['verseNumber']!, _verseNumberMeta));
    } else if (isInserting) {
      context.missing(_verseNumberMeta);
    }
    if (data.containsKey('segmentIndex')) {
      context.handle(
          _segmentIndexMeta,
          segmentIndex.isAcceptableOrUnknown(
              data['segmentIndex']!, _segmentIndexMeta));
    } else if (isInserting) {
      context.missing(_segmentIndexMeta);
    }
    if (data.containsKey('paragraphStart')) {
      context.handle(
          _paragraphStartMeta,
          paragraphStart.isAcceptableOrUnknown(
              data['paragraphStart']!, _paragraphStartMeta));
    }
    if (data.containsKey('textContent')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['textContent']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(_subtitleMeta,
          subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {bookId, chapterNumber, verseNumber, segmentIndex},
      ];
  @override
  VerseSegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseSegment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookId'])!,
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapterNumber'])!,
      verseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verseNumber'])!,
      segmentIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}segmentIndex'])!,
      paragraphStart: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paragraphStart'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}textContent'])!,
      subtitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtitle']),
    );
  }

  @override
  VerseSegments createAlias(String alias) {
    return VerseSegments(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY(bookId)REFERENCES books(id)ON DELETE CASCADE',
        'UNIQUE(bookId, chapterNumber, verseNumber, segmentIndex)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class VerseSegment extends DataClass implements Insertable<VerseSegment> {
  final int id;
  final int bookId;
  final int chapterNumber;
  final int verseNumber;
  final int segmentIndex;
  final int paragraphStart;
  final String textContent;
  final String? subtitle;
  const VerseSegment(
      {required this.id,
      required this.bookId,
      required this.chapterNumber,
      required this.verseNumber,
      required this.segmentIndex,
      required this.paragraphStart,
      required this.textContent,
      this.subtitle});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bookId'] = Variable<int>(bookId);
    map['chapterNumber'] = Variable<int>(chapterNumber);
    map['verseNumber'] = Variable<int>(verseNumber);
    map['segmentIndex'] = Variable<int>(segmentIndex);
    map['paragraphStart'] = Variable<int>(paragraphStart);
    map['textContent'] = Variable<String>(textContent);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    return map;
  }

  VerseSegmentsCompanion toCompanion(bool nullToAbsent) {
    return VerseSegmentsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterNumber: Value(chapterNumber),
      verseNumber: Value(verseNumber),
      segmentIndex: Value(segmentIndex),
      paragraphStart: Value(paragraphStart),
      textContent: Value(textContent),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
    );
  }

  factory VerseSegment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseSegment(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapterNumber: serializer.fromJson<int>(json['chapterNumber']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      segmentIndex: serializer.fromJson<int>(json['segmentIndex']),
      paragraphStart: serializer.fromJson<int>(json['paragraphStart']),
      textContent: serializer.fromJson<String>(json['textContent']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'chapterNumber': serializer.toJson<int>(chapterNumber),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'segmentIndex': serializer.toJson<int>(segmentIndex),
      'paragraphStart': serializer.toJson<int>(paragraphStart),
      'textContent': serializer.toJson<String>(textContent),
      'subtitle': serializer.toJson<String?>(subtitle),
    };
  }

  VerseSegment copyWith(
          {int? id,
          int? bookId,
          int? chapterNumber,
          int? verseNumber,
          int? segmentIndex,
          int? paragraphStart,
          String? textContent,
          Value<String?> subtitle = const Value.absent()}) =>
      VerseSegment(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        verseNumber: verseNumber ?? this.verseNumber,
        segmentIndex: segmentIndex ?? this.segmentIndex,
        paragraphStart: paragraphStart ?? this.paragraphStart,
        textContent: textContent ?? this.textContent,
        subtitle: subtitle.present ? subtitle.value : this.subtitle,
      );
  VerseSegment copyWithCompanion(VerseSegmentsCompanion data) {
    return VerseSegment(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      verseNumber:
          data.verseNumber.present ? data.verseNumber.value : this.verseNumber,
      segmentIndex: data.segmentIndex.present
          ? data.segmentIndex.value
          : this.segmentIndex,
      paragraphStart: data.paragraphStart.present
          ? data.paragraphStart.value
          : this.paragraphStart,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseSegment(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('paragraphStart: $paragraphStart, ')
          ..write('textContent: $textContent, ')
          ..write('subtitle: $subtitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, chapterNumber, verseNumber,
      segmentIndex, paragraphStart, textContent, subtitle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseSegment &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterNumber == this.chapterNumber &&
          other.verseNumber == this.verseNumber &&
          other.segmentIndex == this.segmentIndex &&
          other.paragraphStart == this.paragraphStart &&
          other.textContent == this.textContent &&
          other.subtitle == this.subtitle);
}

class VerseSegmentsCompanion extends UpdateCompanion<VerseSegment> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<int> chapterNumber;
  final Value<int> verseNumber;
  final Value<int> segmentIndex;
  final Value<int> paragraphStart;
  final Value<String> textContent;
  final Value<String?> subtitle;
  const VerseSegmentsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.segmentIndex = const Value.absent(),
    this.paragraphStart = const Value.absent(),
    this.textContent = const Value.absent(),
    this.subtitle = const Value.absent(),
  });
  VerseSegmentsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required int chapterNumber,
    required int verseNumber,
    required int segmentIndex,
    this.paragraphStart = const Value.absent(),
    required String textContent,
    this.subtitle = const Value.absent(),
  })  : bookId = Value(bookId),
        chapterNumber = Value(chapterNumber),
        verseNumber = Value(verseNumber),
        segmentIndex = Value(segmentIndex),
        textContent = Value(textContent);
  static Insertable<VerseSegment> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<int>? chapterNumber,
    Expression<int>? verseNumber,
    Expression<int>? segmentIndex,
    Expression<int>? paragraphStart,
    Expression<String>? textContent,
    Expression<String>? subtitle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'bookId': bookId,
      if (chapterNumber != null) 'chapterNumber': chapterNumber,
      if (verseNumber != null) 'verseNumber': verseNumber,
      if (segmentIndex != null) 'segmentIndex': segmentIndex,
      if (paragraphStart != null) 'paragraphStart': paragraphStart,
      if (textContent != null) 'textContent': textContent,
      if (subtitle != null) 'subtitle': subtitle,
    });
  }

  VerseSegmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? bookId,
      Value<int>? chapterNumber,
      Value<int>? verseNumber,
      Value<int>? segmentIndex,
      Value<int>? paragraphStart,
      Value<String>? textContent,
      Value<String?>? subtitle}) {
    return VerseSegmentsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      paragraphStart: paragraphStart ?? this.paragraphStart,
      textContent: textContent ?? this.textContent,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['bookId'] = Variable<int>(bookId.value);
    }
    if (chapterNumber.present) {
      map['chapterNumber'] = Variable<int>(chapterNumber.value);
    }
    if (verseNumber.present) {
      map['verseNumber'] = Variable<int>(verseNumber.value);
    }
    if (segmentIndex.present) {
      map['segmentIndex'] = Variable<int>(segmentIndex.value);
    }
    if (paragraphStart.present) {
      map['paragraphStart'] = Variable<int>(paragraphStart.value);
    }
    if (textContent.present) {
      map['textContent'] = Variable<String>(textContent.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseSegmentsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('paragraphStart: $paragraphStart, ')
          ..write('textContent: $textContent, ')
          ..write('subtitle: $subtitle')
          ..write(')'))
        .toString();
  }
}

class SegmentSpans extends Table with TableInfo<SegmentSpans, SegmentSpan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SegmentSpans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _segmentIdMeta =
      const VerificationMeta('segmentId');
  late final GeneratedColumn<int> segmentId = GeneratedColumn<int>(
      'segmentId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _startOffsetMeta =
      const VerificationMeta('startOffset');
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
      'startOffset', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _endOffsetMeta =
      const VerificationMeta('endOffset');
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
      'endOffset', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _spanTypeMeta =
      const VerificationMeta('spanType');
  late final GeneratedColumn<int> spanType = GeneratedColumn<int>(
      'spanType', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, segmentId, startOffset, endOffset, spanType, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'segment_spans';
  @override
  VerificationContext validateIntegrity(Insertable<SegmentSpan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('segmentId')) {
      context.handle(_segmentIdMeta,
          segmentId.isAcceptableOrUnknown(data['segmentId']!, _segmentIdMeta));
    } else if (isInserting) {
      context.missing(_segmentIdMeta);
    }
    if (data.containsKey('startOffset')) {
      context.handle(
          _startOffsetMeta,
          startOffset.isAcceptableOrUnknown(
              data['startOffset']!, _startOffsetMeta));
    } else if (isInserting) {
      context.missing(_startOffsetMeta);
    }
    if (data.containsKey('endOffset')) {
      context.handle(_endOffsetMeta,
          endOffset.isAcceptableOrUnknown(data['endOffset']!, _endOffsetMeta));
    } else if (isInserting) {
      context.missing(_endOffsetMeta);
    }
    if (data.containsKey('spanType')) {
      context.handle(_spanTypeMeta,
          spanType.isAcceptableOrUnknown(data['spanType']!, _spanTypeMeta));
    } else if (isInserting) {
      context.missing(_spanTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SegmentSpan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SegmentSpan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      segmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}segmentId'])!,
      startOffset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}startOffset'])!,
      endOffset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}endOffset'])!,
      spanType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}spanType'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload']),
    );
  }

  @override
  SegmentSpans createAlias(String alias) {
    return SegmentSpans(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY(segmentId)REFERENCES verse_segments(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class SegmentSpan extends DataClass implements Insertable<SegmentSpan> {
  final int id;
  final int segmentId;
  final int startOffset;
  final int endOffset;
  final int spanType;
  final String? payload;
  const SegmentSpan(
      {required this.id,
      required this.segmentId,
      required this.startOffset,
      required this.endOffset,
      required this.spanType,
      this.payload});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['segmentId'] = Variable<int>(segmentId);
    map['startOffset'] = Variable<int>(startOffset);
    map['endOffset'] = Variable<int>(endOffset);
    map['spanType'] = Variable<int>(spanType);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    return map;
  }

  SegmentSpansCompanion toCompanion(bool nullToAbsent) {
    return SegmentSpansCompanion(
      id: Value(id),
      segmentId: Value(segmentId),
      startOffset: Value(startOffset),
      endOffset: Value(endOffset),
      spanType: Value(spanType),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
    );
  }

  factory SegmentSpan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SegmentSpan(
      id: serializer.fromJson<int>(json['id']),
      segmentId: serializer.fromJson<int>(json['segmentId']),
      startOffset: serializer.fromJson<int>(json['startOffset']),
      endOffset: serializer.fromJson<int>(json['endOffset']),
      spanType: serializer.fromJson<int>(json['spanType']),
      payload: serializer.fromJson<String?>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'segmentId': serializer.toJson<int>(segmentId),
      'startOffset': serializer.toJson<int>(startOffset),
      'endOffset': serializer.toJson<int>(endOffset),
      'spanType': serializer.toJson<int>(spanType),
      'payload': serializer.toJson<String?>(payload),
    };
  }

  SegmentSpan copyWith(
          {int? id,
          int? segmentId,
          int? startOffset,
          int? endOffset,
          int? spanType,
          Value<String?> payload = const Value.absent()}) =>
      SegmentSpan(
        id: id ?? this.id,
        segmentId: segmentId ?? this.segmentId,
        startOffset: startOffset ?? this.startOffset,
        endOffset: endOffset ?? this.endOffset,
        spanType: spanType ?? this.spanType,
        payload: payload.present ? payload.value : this.payload,
      );
  SegmentSpan copyWithCompanion(SegmentSpansCompanion data) {
    return SegmentSpan(
      id: data.id.present ? data.id.value : this.id,
      segmentId: data.segmentId.present ? data.segmentId.value : this.segmentId,
      startOffset:
          data.startOffset.present ? data.startOffset.value : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      spanType: data.spanType.present ? data.spanType.value : this.spanType,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SegmentSpan(')
          ..write('id: $id, ')
          ..write('segmentId: $segmentId, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('spanType: $spanType, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, segmentId, startOffset, endOffset, spanType, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SegmentSpan &&
          other.id == this.id &&
          other.segmentId == this.segmentId &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.spanType == this.spanType &&
          other.payload == this.payload);
}

class SegmentSpansCompanion extends UpdateCompanion<SegmentSpan> {
  final Value<int> id;
  final Value<int> segmentId;
  final Value<int> startOffset;
  final Value<int> endOffset;
  final Value<int> spanType;
  final Value<String?> payload;
  const SegmentSpansCompanion({
    this.id = const Value.absent(),
    this.segmentId = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.spanType = const Value.absent(),
    this.payload = const Value.absent(),
  });
  SegmentSpansCompanion.insert({
    this.id = const Value.absent(),
    required int segmentId,
    required int startOffset,
    required int endOffset,
    required int spanType,
    this.payload = const Value.absent(),
  })  : segmentId = Value(segmentId),
        startOffset = Value(startOffset),
        endOffset = Value(endOffset),
        spanType = Value(spanType);
  static Insertable<SegmentSpan> custom({
    Expression<int>? id,
    Expression<int>? segmentId,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<int>? spanType,
    Expression<String>? payload,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (segmentId != null) 'segmentId': segmentId,
      if (startOffset != null) 'startOffset': startOffset,
      if (endOffset != null) 'endOffset': endOffset,
      if (spanType != null) 'spanType': spanType,
      if (payload != null) 'payload': payload,
    });
  }

  SegmentSpansCompanion copyWith(
      {Value<int>? id,
      Value<int>? segmentId,
      Value<int>? startOffset,
      Value<int>? endOffset,
      Value<int>? spanType,
      Value<String?>? payload}) {
    return SegmentSpansCompanion(
      id: id ?? this.id,
      segmentId: segmentId ?? this.segmentId,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      spanType: spanType ?? this.spanType,
      payload: payload ?? this.payload,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (segmentId.present) {
      map['segmentId'] = Variable<int>(segmentId.value);
    }
    if (startOffset.present) {
      map['startOffset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['endOffset'] = Variable<int>(endOffset.value);
    }
    if (spanType.present) {
      map['spanType'] = Variable<int>(spanType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SegmentSpansCompanion(')
          ..write('id: $id, ')
          ..write('segmentId: $segmentId, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('spanType: $spanType, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }
}

class VerseText extends Table with TableInfo<VerseText, VerseTextData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VerseText(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _bibleIdMeta =
      const VerificationMeta('bibleId');
  late final GeneratedColumn<int> bibleId = GeneratedColumn<int>(
      'bibleId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _bookUsfxIdMeta =
      const VerificationMeta('bookUsfxId');
  late final GeneratedColumn<String> bookUsfxId = GeneratedColumn<String>(
      'bookUsfxId', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'bookId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _chapterNumberMeta =
      const VerificationMeta('chapterNumber');
  late final GeneratedColumn<int> chapterNumber = GeneratedColumn<int>(
      'chapterNumber', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _verseNumberMeta =
      const VerificationMeta('verseNumber');
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
      'verseNumber', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'textContent', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bibleId,
        bookUsfxId,
        bookId,
        chapterNumber,
        verseNumber,
        textContent
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_text';
  @override
  VerificationContext validateIntegrity(Insertable<VerseTextData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bibleId')) {
      context.handle(_bibleIdMeta,
          bibleId.isAcceptableOrUnknown(data['bibleId']!, _bibleIdMeta));
    } else if (isInserting) {
      context.missing(_bibleIdMeta);
    }
    if (data.containsKey('bookUsfxId')) {
      context.handle(
          _bookUsfxIdMeta,
          bookUsfxId.isAcceptableOrUnknown(
              data['bookUsfxId']!, _bookUsfxIdMeta));
    } else if (isInserting) {
      context.missing(_bookUsfxIdMeta);
    }
    if (data.containsKey('bookId')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['bookId']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapterNumber')) {
      context.handle(
          _chapterNumberMeta,
          chapterNumber.isAcceptableOrUnknown(
              data['chapterNumber']!, _chapterNumberMeta));
    } else if (isInserting) {
      context.missing(_chapterNumberMeta);
    }
    if (data.containsKey('verseNumber')) {
      context.handle(
          _verseNumberMeta,
          verseNumber.isAcceptableOrUnknown(
              data['verseNumber']!, _verseNumberMeta));
    } else if (isInserting) {
      context.missing(_verseNumberMeta);
    }
    if (data.containsKey('textContent')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['textContent']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {bibleId, bookUsfxId, chapterNumber, verseNumber},
      ];
  @override
  VerseTextData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseTextData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bibleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bibleId'])!,
      bookUsfxId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bookUsfxId'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookId'])!,
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapterNumber'])!,
      verseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verseNumber'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}textContent'])!,
    );
  }

  @override
  VerseText createAlias(String alias) {
    return VerseText(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY(bookId)REFERENCES books(id)ON DELETE CASCADE',
        'UNIQUE(bibleId, bookUsfxId, chapterNumber, verseNumber)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class VerseTextData extends DataClass implements Insertable<VerseTextData> {
  final int id;
  final int bibleId;
  final String bookUsfxId;
  final int bookId;
  final int chapterNumber;
  final int verseNumber;
  final String textContent;
  const VerseTextData(
      {required this.id,
      required this.bibleId,
      required this.bookUsfxId,
      required this.bookId,
      required this.chapterNumber,
      required this.verseNumber,
      required this.textContent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bibleId'] = Variable<int>(bibleId);
    map['bookUsfxId'] = Variable<String>(bookUsfxId);
    map['bookId'] = Variable<int>(bookId);
    map['chapterNumber'] = Variable<int>(chapterNumber);
    map['verseNumber'] = Variable<int>(verseNumber);
    map['textContent'] = Variable<String>(textContent);
    return map;
  }

  VerseTextCompanion toCompanion(bool nullToAbsent) {
    return VerseTextCompanion(
      id: Value(id),
      bibleId: Value(bibleId),
      bookUsfxId: Value(bookUsfxId),
      bookId: Value(bookId),
      chapterNumber: Value(chapterNumber),
      verseNumber: Value(verseNumber),
      textContent: Value(textContent),
    );
  }

  factory VerseTextData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseTextData(
      id: serializer.fromJson<int>(json['id']),
      bibleId: serializer.fromJson<int>(json['bibleId']),
      bookUsfxId: serializer.fromJson<String>(json['bookUsfxId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapterNumber: serializer.fromJson<int>(json['chapterNumber']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      textContent: serializer.fromJson<String>(json['textContent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bibleId': serializer.toJson<int>(bibleId),
      'bookUsfxId': serializer.toJson<String>(bookUsfxId),
      'bookId': serializer.toJson<int>(bookId),
      'chapterNumber': serializer.toJson<int>(chapterNumber),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'textContent': serializer.toJson<String>(textContent),
    };
  }

  VerseTextData copyWith(
          {int? id,
          int? bibleId,
          String? bookUsfxId,
          int? bookId,
          int? chapterNumber,
          int? verseNumber,
          String? textContent}) =>
      VerseTextData(
        id: id ?? this.id,
        bibleId: bibleId ?? this.bibleId,
        bookUsfxId: bookUsfxId ?? this.bookUsfxId,
        bookId: bookId ?? this.bookId,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        verseNumber: verseNumber ?? this.verseNumber,
        textContent: textContent ?? this.textContent,
      );
  VerseTextData copyWithCompanion(VerseTextCompanion data) {
    return VerseTextData(
      id: data.id.present ? data.id.value : this.id,
      bibleId: data.bibleId.present ? data.bibleId.value : this.bibleId,
      bookUsfxId:
          data.bookUsfxId.present ? data.bookUsfxId.value : this.bookUsfxId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      verseNumber:
          data.verseNumber.present ? data.verseNumber.value : this.verseNumber,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseTextData(')
          ..write('id: $id, ')
          ..write('bibleId: $bibleId, ')
          ..write('bookUsfxId: $bookUsfxId, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('textContent: $textContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bibleId, bookUsfxId, bookId, chapterNumber, verseNumber, textContent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseTextData &&
          other.id == this.id &&
          other.bibleId == this.bibleId &&
          other.bookUsfxId == this.bookUsfxId &&
          other.bookId == this.bookId &&
          other.chapterNumber == this.chapterNumber &&
          other.verseNumber == this.verseNumber &&
          other.textContent == this.textContent);
}

class VerseTextCompanion extends UpdateCompanion<VerseTextData> {
  final Value<int> id;
  final Value<int> bibleId;
  final Value<String> bookUsfxId;
  final Value<int> bookId;
  final Value<int> chapterNumber;
  final Value<int> verseNumber;
  final Value<String> textContent;
  const VerseTextCompanion({
    this.id = const Value.absent(),
    this.bibleId = const Value.absent(),
    this.bookUsfxId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.textContent = const Value.absent(),
  });
  VerseTextCompanion.insert({
    this.id = const Value.absent(),
    required int bibleId,
    required String bookUsfxId,
    required int bookId,
    required int chapterNumber,
    required int verseNumber,
    required String textContent,
  })  : bibleId = Value(bibleId),
        bookUsfxId = Value(bookUsfxId),
        bookId = Value(bookId),
        chapterNumber = Value(chapterNumber),
        verseNumber = Value(verseNumber),
        textContent = Value(textContent);
  static Insertable<VerseTextData> custom({
    Expression<int>? id,
    Expression<int>? bibleId,
    Expression<String>? bookUsfxId,
    Expression<int>? bookId,
    Expression<int>? chapterNumber,
    Expression<int>? verseNumber,
    Expression<String>? textContent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bibleId != null) 'bibleId': bibleId,
      if (bookUsfxId != null) 'bookUsfxId': bookUsfxId,
      if (bookId != null) 'bookId': bookId,
      if (chapterNumber != null) 'chapterNumber': chapterNumber,
      if (verseNumber != null) 'verseNumber': verseNumber,
      if (textContent != null) 'textContent': textContent,
    });
  }

  VerseTextCompanion copyWith(
      {Value<int>? id,
      Value<int>? bibleId,
      Value<String>? bookUsfxId,
      Value<int>? bookId,
      Value<int>? chapterNumber,
      Value<int>? verseNumber,
      Value<String>? textContent}) {
    return VerseTextCompanion(
      id: id ?? this.id,
      bibleId: bibleId ?? this.bibleId,
      bookUsfxId: bookUsfxId ?? this.bookUsfxId,
      bookId: bookId ?? this.bookId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      textContent: textContent ?? this.textContent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bibleId.present) {
      map['bibleId'] = Variable<int>(bibleId.value);
    }
    if (bookUsfxId.present) {
      map['bookUsfxId'] = Variable<String>(bookUsfxId.value);
    }
    if (bookId.present) {
      map['bookId'] = Variable<int>(bookId.value);
    }
    if (chapterNumber.present) {
      map['chapterNumber'] = Variable<int>(chapterNumber.value);
    }
    if (verseNumber.present) {
      map['verseNumber'] = Variable<int>(verseNumber.value);
    }
    if (textContent.present) {
      map['textContent'] = Variable<String>(textContent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseTextCompanion(')
          ..write('id: $id, ')
          ..write('bibleId: $bibleId, ')
          ..write('bookUsfxId: $bookUsfxId, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('textContent: $textContent')
          ..write(')'))
        .toString();
  }
}

class VerseTextFts extends Table
    with
        TableInfo<VerseTextFts, VerseTextFt>,
        VirtualTableInfo<VerseTextFts, VerseTextFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VerseTextFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'textContent', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: '');
  static const VerificationMeta _bibleIdMeta =
      const VerificationMeta('bibleId');
  late final GeneratedColumn<String> bibleId = GeneratedColumn<String>(
      'bibleId', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [textContent, bibleId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_text_fts';
  @override
  VerificationContext validateIntegrity(Insertable<VerseTextFt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('textContent')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['textContent']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('bibleId')) {
      context.handle(_bibleIdMeta,
          bibleId.isAcceptableOrUnknown(data['bibleId']!, _bibleIdMeta));
    } else if (isInserting) {
      context.missing(_bibleIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  VerseTextFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseTextFt(
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}textContent'])!,
      bibleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bibleId'])!,
    );
  }

  @override
  VerseTextFts createAlias(String alias) {
    return VerseTextFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(textContent, bibleId UNINDEXED, content=\'verse_text\', content_rowid=\'id\')';
}

class VerseTextFt extends DataClass implements Insertable<VerseTextFt> {
  final String textContent;
  final String bibleId;
  const VerseTextFt({required this.textContent, required this.bibleId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['textContent'] = Variable<String>(textContent);
    map['bibleId'] = Variable<String>(bibleId);
    return map;
  }

  VerseTextFtsCompanion toCompanion(bool nullToAbsent) {
    return VerseTextFtsCompanion(
      textContent: Value(textContent),
      bibleId: Value(bibleId),
    );
  }

  factory VerseTextFt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseTextFt(
      textContent: serializer.fromJson<String>(json['textContent']),
      bibleId: serializer.fromJson<String>(json['bibleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'textContent': serializer.toJson<String>(textContent),
      'bibleId': serializer.toJson<String>(bibleId),
    };
  }

  VerseTextFt copyWith({String? textContent, String? bibleId}) => VerseTextFt(
        textContent: textContent ?? this.textContent,
        bibleId: bibleId ?? this.bibleId,
      );
  VerseTextFt copyWithCompanion(VerseTextFtsCompanion data) {
    return VerseTextFt(
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      bibleId: data.bibleId.present ? data.bibleId.value : this.bibleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseTextFt(')
          ..write('textContent: $textContent, ')
          ..write('bibleId: $bibleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(textContent, bibleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseTextFt &&
          other.textContent == this.textContent &&
          other.bibleId == this.bibleId);
}

class VerseTextFtsCompanion extends UpdateCompanion<VerseTextFt> {
  final Value<String> textContent;
  final Value<String> bibleId;
  final Value<int> rowid;
  const VerseTextFtsCompanion({
    this.textContent = const Value.absent(),
    this.bibleId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VerseTextFtsCompanion.insert({
    required String textContent,
    required String bibleId,
    this.rowid = const Value.absent(),
  })  : textContent = Value(textContent),
        bibleId = Value(bibleId);
  static Insertable<VerseTextFt> custom({
    Expression<String>? textContent,
    Expression<String>? bibleId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (textContent != null) 'textContent': textContent,
      if (bibleId != null) 'bibleId': bibleId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VerseTextFtsCompanion copyWith(
      {Value<String>? textContent, Value<String>? bibleId, Value<int>? rowid}) {
    return VerseTextFtsCompanion(
      textContent: textContent ?? this.textContent,
      bibleId: bibleId ?? this.bibleId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (textContent.present) {
      map['textContent'] = Variable<String>(textContent.value);
    }
    if (bibleId.present) {
      map['bibleId'] = Variable<String>(bibleId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseTextFtsCompanion(')
          ..write('textContent: $textContent, ')
          ..write('bibleId: $bibleId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final Languages languages = Languages(this);
  late final Bibles bibles = Bibles(this);
  late final Books books = Books(this);
  late final VerseSegments verseSegments = VerseSegments(this);
  late final SegmentSpans segmentSpans = SegmentSpans(this);
  late final VerseText verseText = VerseText(this);
  late final Index ixVerseTextBible = Index('ix_verse_text_bible',
      'CREATE INDEX ix_verse_text_bible ON verse_text (bibleId, bookUsfxId, chapterNumber, verseNumber)');
  late final VerseTextFts verseTextFts = VerseTextFts(this);
  late final Trigger verseTextAi = Trigger(
      'CREATE TRIGGER verse_text_ai AFTER INSERT ON verse_text BEGIN INSERT INTO verse_text_fts ("rowid", textContent, bibleId) VALUES (new.id, new.textContent, new.bibleId);END',
      'verse_text_ai');
  late final Index ixSpansSegment = Index('ix_spans_segment',
      'CREATE INDEX ix_spans_segment ON segment_spans (segmentId, startOffset)');
  late final Index uxLanguagesIso = Index('ux_languages_iso',
      'CREATE UNIQUE INDEX ux_languages_iso ON languages (langIsoCode)');
  Selectable<int> resolveBookNameToId(int bibleId, String bname) {
    return customSelect(
        'SELECT b.id FROM books AS b WHERE b.bibleId = ?1 AND(b.usfxId = ?2 OR shortName = ?2)',
        variables: [
          Variable<int>(bibleId),
          Variable<String>(bname)
        ],
        readsFrom: {
          books,
        }).map((QueryRow row) => row.read<int>('id'));
  }

  Selectable<GetBiblesResult> getBibles() {
    return customSelect(
        'SELECT b.id, b.usfxId, b.languageId, b.bibleName, b.bibleNameLocal, b.bibleNameAbbreviation, b.originSource, l.langEngName, l.langIsoCode, l.langNativeName FROM bibles AS b JOIN languages AS l ON b.languageId = l.id',
        variables: [],
        readsFrom: {
          bibles,
          languages,
        }).map((QueryRow row) => GetBiblesResult(
          id: row.read<int>('id'),
          usfxId: row.read<String>('usfxId'),
          languageId: row.readNullable<int>('languageId'),
          bibleName: row.read<String>('bibleName'),
          bibleNameLocal: row.read<String>('bibleNameLocal'),
          bibleNameAbbreviation: row.read<String>('bibleNameAbbreviation'),
          originSource: row.readNullable<String>('originSource'),
          langEngName: row.read<String>('langEngName'),
          langIsoCode: row.readNullable<String>('langIsoCode'),
          langNativeName: row.readNullable<String>('langNativeName'),
        ));
  }

  Selectable<GetBibleResult> getBible(int bibleId) {
    return customSelect(
        'SELECT b.id, b.usfxId, b.languageId, b.bibleName, b.bibleNameLocal, b.bibleNameAbbreviation, b.originSource, l.langEngName, l.langIsoCode, l.langNativeName FROM bibles AS b JOIN languages AS l ON b.languageId = l.id WHERE b.id = ?1',
        variables: [
          Variable<int>(bibleId)
        ],
        readsFrom: {
          bibles,
          languages,
        }).map((QueryRow row) => GetBibleResult(
          id: row.read<int>('id'),
          usfxId: row.read<String>('usfxId'),
          languageId: row.readNullable<int>('languageId'),
          bibleName: row.read<String>('bibleName'),
          bibleNameLocal: row.read<String>('bibleNameLocal'),
          bibleNameAbbreviation: row.read<String>('bibleNameAbbreviation'),
          originSource: row.readNullable<String>('originSource'),
          langEngName: row.read<String>('langEngName'),
          langIsoCode: row.readNullable<String>('langIsoCode'),
          langNativeName: row.readNullable<String>('langNativeName'),
        ));
  }

  Selectable<GetVerseSegmentsForChapterResult> getVerseSegmentsForChapter(
      int bibleId, String bookusfxId, int chapterNumber) {
    return customSelect(
        'SELECT * FROM verse_segments AS s JOIN books AS b ON b.id = s.bookId WHERE b.bibleId = ?1 AND b.usfxId = ?2 AND s.chapterNumber = ?3 ORDER BY s.verseNumber, s.segmentIndex',
        variables: [
          Variable<int>(bibleId),
          Variable<String>(bookusfxId),
          Variable<int>(chapterNumber)
        ],
        readsFrom: {
          verseSegments,
          books,
        }).map((QueryRow row) => GetVerseSegmentsForChapterResult(
          id: row.read<int>('id'),
          bookId: row.read<int>('bookId'),
          chapterNumber: row.read<int>('chapterNumber'),
          verseNumber: row.read<int>('verseNumber'),
          segmentIndex: row.read<int>('segmentIndex'),
          paragraphStart: row.read<int>('paragraphStart'),
          textContent: row.read<String>('textContent'),
          subtitle: row.readNullable<String>('subtitle'),
          id1: row.read<int>('id'),
          bibleId: row.read<int>('bibleId'),
          usfxId: row.read<String>('usfxId'),
          osisId: row.read<String>('osisId'),
          bookOrder: row.readNullable<int>('bookOrder'),
          longName: row.readNullable<String>('longName'),
          shortName: row.read<String>('shortName'),
        ));
  }

  Selectable<GetSegmentsForChapterWithSpansResult>
      getSegmentsForChapterWithSpans(
          int bibleId, String bookusfxId, int chapterNumber) {
    return customSelect(
        'SELECT s.id AS segmentId, s.bookId, s.chapterNumber, s.verseNumber, s.segmentIndex, s.paragraphStart, s.textContent, s.subtitle, COALESCE((SELECT json_group_array(json_object(\'segmentId\', sp.segmentId, \'id\', sp.id, \'startOffset\', sp.startOffset, \'endOffset\', sp.endOffset, \'spanType\', sp.spanType, \'payload\', sp.payload)) FROM segment_spans AS sp WHERE sp.segmentId = s.id ORDER BY sp.startOffset), json(\'[]\')) AS spansJson FROM verse_segments AS s LEFT JOIN segment_spans AS sp ON sp.segmentId = s.id JOIN books AS b ON b.id = s.bookId WHERE b.bibleId = ?1 AND b.usfxId = ?2 AND s.chapterNumber = ?3 GROUP BY s.id ORDER BY s.verseNumber, s.segmentIndex, sp.startOffset',
        variables: [
          Variable<int>(bibleId),
          Variable<String>(bookusfxId),
          Variable<int>(chapterNumber)
        ],
        readsFrom: {
          verseSegments,
          segmentSpans,
          books,
        }).map((QueryRow row) => GetSegmentsForChapterWithSpansResult(
          segmentId: row.read<int>('segmentId'),
          bookId: row.read<int>('bookId'),
          chapterNumber: row.read<int>('chapterNumber'),
          verseNumber: row.read<int>('verseNumber'),
          segmentIndex: row.read<int>('segmentIndex'),
          paragraphStart: row.read<int>('paragraphStart'),
          textContent: row.read<String>('textContent'),
          subtitle: row.readNullable<String>('subtitle'),
          spansJson: row.read<String>('spansJson'),
        ));
  }

  Selectable<GetSegmentsByBibleIdResult> getSegmentsByBibleId(int bibleId) {
    return customSelect(
        'SELECT vs.id, bookId, b.usfxId AS bookUsfxId, chapterNumber, verseNumber, segmentIndex FROM verse_segments AS vs JOIN books AS b ON b.id = vs.bookId WHERE b.bibleId = ?1',
        variables: [
          Variable<int>(bibleId)
        ],
        readsFrom: {
          verseSegments,
          books,
        }).map((QueryRow row) => GetSegmentsByBibleIdResult(
          id: row.read<int>('id'),
          bookId: row.read<int>('bookId'),
          bookUsfxId: row.read<String>('bookUsfxId'),
          chapterNumber: row.read<int>('chapterNumber'),
          verseNumber: row.read<int>('verseNumber'),
          segmentIndex: row.read<int>('segmentIndex'),
        ));
  }

  Selectable<Book> getBooks(int bibleId) {
    return customSelect('SELECT * FROM books WHERE bibleId = ?1 ORDER BY id',
        variables: [
          Variable<int>(bibleId)
        ],
        readsFrom: {
          books,
        }).asyncMap(books.mapFromRow);
  }

  Selectable<int?> getMaxChapter(int bookId) {
    return customSelect(
        'SELECT MAX(chapterNumber) AS chapter_count FROM verse_segments WHERE bookId = ?1',
        variables: [
          Variable<int>(bookId)
        ],
        readsFrom: {
          verseSegments,
        }).map((QueryRow row) => row.readNullable<int>('chapter_count'));
  }

  Selectable<int?> getMaxVerse(int bookId, int chapter) {
    return customSelect(
        'SELECT MAX(verseNumber) AS _c0 FROM verse_segments WHERE bookId = ?1 AND chapterNumber = ?2',
        variables: [
          Variable<int>(bookId),
          Variable<int>(chapter)
        ],
        readsFrom: {
          verseSegments,
        }).map((QueryRow row) => row.readNullable<int>('_c0'));
  }

  Future<int> clearVerseText(int bibleId) {
    return customUpdate(
      'DELETE FROM verse_text WHERE bibleId = ?1',
      variables: [Variable<int>(bibleId)],
      updates: {verseText},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> populateVerseText(int bibleId) {
    return customInsert(
      'INSERT INTO verse_text (bibleId, bookUsfxId, bookId, chapterNumber, verseNumber, textContent) SELECT b.bibleId, b.usfxId, v.bookId, v.chapterNumber, v.verseNumber, (SELECT GROUP_CONCAT(vs2.textContent, \' \') FROM verse_segments AS vs2 WHERE vs2.bookId = v.bookId AND vs2.chapterNumber = v.chapterNumber AND vs2.verseNumber = v.verseNumber ORDER BY vs2.segmentIndex) AS textContent FROM (SELECT DISTINCT bookId, chapterNumber, verseNumber FROM verse_segments) AS v JOIN books AS b ON b.id = v.bookId WHERE b.bibleId = ?1',
      variables: [Variable<int>(bibleId)],
      updates: {verseText},
    );
  }

  Selectable<SearchVersesResult> searchVerses(
      int bibleId, String query, int limit) {
    return customSelect(
        'WITH hits AS (SELECT "rowid", bm25(verse_text_fts) AS rank FROM verse_text_fts WHERE CAST(bibleId AS INTEGER) = ?1 AND verse_text_fts MATCH ?2 ORDER BY rank LIMIT ?3) SELECT vt.bibleId, vt.bookUsfxId, vt.chapterNumber, vt.verseNumber FROM hits JOIN verse_text AS vt ON vt.id = hits."rowid" ORDER BY hits.rank',
        variables: [
          Variable<int>(bibleId),
          Variable<String>(query),
          Variable<int>(limit)
        ],
        readsFrom: {
          verseTextFts,
          verseText,
        }).map((QueryRow row) => SearchVersesResult(
          bibleId: row.read<int>('bibleId'),
          bookUsfxId: row.read<String>('bookUsfxId'),
          chapterNumber: row.read<int>('chapterNumber'),
          verseNumber: row.read<int>('verseNumber'),
        ));
  }

  Selectable<int> testQuery(String q) {
    return customSelect(
        'SELECT "rowid" FROM verse_text_fts WHERE verse_text_fts MATCH ?1 LIMIT 100',
        variables: [
          Variable<String>(q)
        ],
        readsFrom: {
          verseTextFts,
        }).map((QueryRow row) => row.read<int>('rowid'));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        languages,
        bibles,
        books,
        verseSegments,
        segmentSpans,
        verseText,
        ixVerseTextBible,
        verseTextFts,
        verseTextAi,
        ixSpansSegment,
        uxLanguagesIso
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('bibles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('books', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('books',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('verse_segments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('verse_segments',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('segment_spans', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('books',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('verse_text', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('verse_text',
                limitUpdateKind: UpdateKind.insert),
            result: [
              TableUpdate('verse_text_fts', kind: UpdateKind.insert),
            ],
          ),
        ],
      );
}

typedef $LanguagesCreateCompanionBuilder = LanguagesCompanion Function({
  Value<int> id,
  required String langEngName,
  Value<String?> langNativeName,
  Value<String?> langIsoCode,
});
typedef $LanguagesUpdateCompanionBuilder = LanguagesCompanion Function({
  Value<int> id,
  Value<String> langEngName,
  Value<String?> langNativeName,
  Value<String?> langIsoCode,
});

class $LanguagesFilterComposer extends Composer<_$AppDb, Languages> {
  $LanguagesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langEngName => $composableBuilder(
      column: $table.langEngName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langNativeName => $composableBuilder(
      column: $table.langNativeName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langIsoCode => $composableBuilder(
      column: $table.langIsoCode, builder: (column) => ColumnFilters(column));
}

class $LanguagesOrderingComposer extends Composer<_$AppDb, Languages> {
  $LanguagesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langEngName => $composableBuilder(
      column: $table.langEngName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langNativeName => $composableBuilder(
      column: $table.langNativeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langIsoCode => $composableBuilder(
      column: $table.langIsoCode, builder: (column) => ColumnOrderings(column));
}

class $LanguagesAnnotationComposer extends Composer<_$AppDb, Languages> {
  $LanguagesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get langEngName => $composableBuilder(
      column: $table.langEngName, builder: (column) => column);

  GeneratedColumn<String> get langNativeName => $composableBuilder(
      column: $table.langNativeName, builder: (column) => column);

  GeneratedColumn<String> get langIsoCode => $composableBuilder(
      column: $table.langIsoCode, builder: (column) => column);
}

class $LanguagesTableManager extends RootTableManager<
    _$AppDb,
    Languages,
    Language,
    $LanguagesFilterComposer,
    $LanguagesOrderingComposer,
    $LanguagesAnnotationComposer,
    $LanguagesCreateCompanionBuilder,
    $LanguagesUpdateCompanionBuilder,
    (Language, BaseReferences<_$AppDb, Languages, Language>),
    Language,
    PrefetchHooks Function()> {
  $LanguagesTableManager(_$AppDb db, Languages table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $LanguagesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $LanguagesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $LanguagesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> langEngName = const Value.absent(),
            Value<String?> langNativeName = const Value.absent(),
            Value<String?> langIsoCode = const Value.absent(),
          }) =>
              LanguagesCompanion(
            id: id,
            langEngName: langEngName,
            langNativeName: langNativeName,
            langIsoCode: langIsoCode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String langEngName,
            Value<String?> langNativeName = const Value.absent(),
            Value<String?> langIsoCode = const Value.absent(),
          }) =>
              LanguagesCompanion.insert(
            id: id,
            langEngName: langEngName,
            langNativeName: langNativeName,
            langIsoCode: langIsoCode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $LanguagesProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Languages,
    Language,
    $LanguagesFilterComposer,
    $LanguagesOrderingComposer,
    $LanguagesAnnotationComposer,
    $LanguagesCreateCompanionBuilder,
    $LanguagesUpdateCompanionBuilder,
    (Language, BaseReferences<_$AppDb, Languages, Language>),
    Language,
    PrefetchHooks Function()>;
typedef $BiblesCreateCompanionBuilder = BiblesCompanion Function({
  Value<int> id,
  required String usfxId,
  Value<int?> languageId,
  required String bibleName,
  required String bibleNameLocal,
  required String bibleNameAbbreviation,
  Value<String?> originSource,
});
typedef $BiblesUpdateCompanionBuilder = BiblesCompanion Function({
  Value<int> id,
  Value<String> usfxId,
  Value<int?> languageId,
  Value<String> bibleName,
  Value<String> bibleNameLocal,
  Value<String> bibleNameAbbreviation,
  Value<String?> originSource,
});

class $BiblesFilterComposer extends Composer<_$AppDb, Bibles> {
  $BiblesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usfxId => $composableBuilder(
      column: $table.usfxId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bibleName => $composableBuilder(
      column: $table.bibleName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bibleNameLocal => $composableBuilder(
      column: $table.bibleNameLocal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bibleNameAbbreviation => $composableBuilder(
      column: $table.bibleNameAbbreviation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originSource => $composableBuilder(
      column: $table.originSource, builder: (column) => ColumnFilters(column));
}

class $BiblesOrderingComposer extends Composer<_$AppDb, Bibles> {
  $BiblesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usfxId => $composableBuilder(
      column: $table.usfxId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bibleName => $composableBuilder(
      column: $table.bibleName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bibleNameLocal => $composableBuilder(
      column: $table.bibleNameLocal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bibleNameAbbreviation => $composableBuilder(
      column: $table.bibleNameAbbreviation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originSource => $composableBuilder(
      column: $table.originSource,
      builder: (column) => ColumnOrderings(column));
}

class $BiblesAnnotationComposer extends Composer<_$AppDb, Bibles> {
  $BiblesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usfxId =>
      $composableBuilder(column: $table.usfxId, builder: (column) => column);

  GeneratedColumn<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => column);

  GeneratedColumn<String> get bibleName =>
      $composableBuilder(column: $table.bibleName, builder: (column) => column);

  GeneratedColumn<String> get bibleNameLocal => $composableBuilder(
      column: $table.bibleNameLocal, builder: (column) => column);

  GeneratedColumn<String> get bibleNameAbbreviation => $composableBuilder(
      column: $table.bibleNameAbbreviation, builder: (column) => column);

  GeneratedColumn<String> get originSource => $composableBuilder(
      column: $table.originSource, builder: (column) => column);
}

class $BiblesTableManager extends RootTableManager<
    _$AppDb,
    Bibles,
    Bible,
    $BiblesFilterComposer,
    $BiblesOrderingComposer,
    $BiblesAnnotationComposer,
    $BiblesCreateCompanionBuilder,
    $BiblesUpdateCompanionBuilder,
    (Bible, BaseReferences<_$AppDb, Bibles, Bible>),
    Bible,
    PrefetchHooks Function()> {
  $BiblesTableManager(_$AppDb db, Bibles table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $BiblesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $BiblesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $BiblesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> usfxId = const Value.absent(),
            Value<int?> languageId = const Value.absent(),
            Value<String> bibleName = const Value.absent(),
            Value<String> bibleNameLocal = const Value.absent(),
            Value<String> bibleNameAbbreviation = const Value.absent(),
            Value<String?> originSource = const Value.absent(),
          }) =>
              BiblesCompanion(
            id: id,
            usfxId: usfxId,
            languageId: languageId,
            bibleName: bibleName,
            bibleNameLocal: bibleNameLocal,
            bibleNameAbbreviation: bibleNameAbbreviation,
            originSource: originSource,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String usfxId,
            Value<int?> languageId = const Value.absent(),
            required String bibleName,
            required String bibleNameLocal,
            required String bibleNameAbbreviation,
            Value<String?> originSource = const Value.absent(),
          }) =>
              BiblesCompanion.insert(
            id: id,
            usfxId: usfxId,
            languageId: languageId,
            bibleName: bibleName,
            bibleNameLocal: bibleNameLocal,
            bibleNameAbbreviation: bibleNameAbbreviation,
            originSource: originSource,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $BiblesProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Bibles,
    Bible,
    $BiblesFilterComposer,
    $BiblesOrderingComposer,
    $BiblesAnnotationComposer,
    $BiblesCreateCompanionBuilder,
    $BiblesUpdateCompanionBuilder,
    (Bible, BaseReferences<_$AppDb, Bibles, Bible>),
    Bible,
    PrefetchHooks Function()>;
typedef $BooksCreateCompanionBuilder = BooksCompanion Function({
  Value<int> id,
  required int bibleId,
  required String usfxId,
  required String osisId,
  Value<int?> bookOrder,
  Value<String?> longName,
  required String shortName,
});
typedef $BooksUpdateCompanionBuilder = BooksCompanion Function({
  Value<int> id,
  Value<int> bibleId,
  Value<String> usfxId,
  Value<String> osisId,
  Value<int?> bookOrder,
  Value<String?> longName,
  Value<String> shortName,
});

class $BooksFilterComposer extends Composer<_$AppDb, Books> {
  $BooksFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usfxId => $composableBuilder(
      column: $table.usfxId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get osisId => $composableBuilder(
      column: $table.osisId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookOrder => $composableBuilder(
      column: $table.bookOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get longName => $composableBuilder(
      column: $table.longName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnFilters(column));
}

class $BooksOrderingComposer extends Composer<_$AppDb, Books> {
  $BooksOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usfxId => $composableBuilder(
      column: $table.usfxId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get osisId => $composableBuilder(
      column: $table.osisId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookOrder => $composableBuilder(
      column: $table.bookOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get longName => $composableBuilder(
      column: $table.longName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnOrderings(column));
}

class $BooksAnnotationComposer extends Composer<_$AppDb, Books> {
  $BooksAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bibleId =>
      $composableBuilder(column: $table.bibleId, builder: (column) => column);

  GeneratedColumn<String> get usfxId =>
      $composableBuilder(column: $table.usfxId, builder: (column) => column);

  GeneratedColumn<String> get osisId =>
      $composableBuilder(column: $table.osisId, builder: (column) => column);

  GeneratedColumn<int> get bookOrder =>
      $composableBuilder(column: $table.bookOrder, builder: (column) => column);

  GeneratedColumn<String> get longName =>
      $composableBuilder(column: $table.longName, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);
}

class $BooksTableManager extends RootTableManager<
    _$AppDb,
    Books,
    Book,
    $BooksFilterComposer,
    $BooksOrderingComposer,
    $BooksAnnotationComposer,
    $BooksCreateCompanionBuilder,
    $BooksUpdateCompanionBuilder,
    (Book, BaseReferences<_$AppDb, Books, Book>),
    Book,
    PrefetchHooks Function()> {
  $BooksTableManager(_$AppDb db, Books table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $BooksFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $BooksOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $BooksAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bibleId = const Value.absent(),
            Value<String> usfxId = const Value.absent(),
            Value<String> osisId = const Value.absent(),
            Value<int?> bookOrder = const Value.absent(),
            Value<String?> longName = const Value.absent(),
            Value<String> shortName = const Value.absent(),
          }) =>
              BooksCompanion(
            id: id,
            bibleId: bibleId,
            usfxId: usfxId,
            osisId: osisId,
            bookOrder: bookOrder,
            longName: longName,
            shortName: shortName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bibleId,
            required String usfxId,
            required String osisId,
            Value<int?> bookOrder = const Value.absent(),
            Value<String?> longName = const Value.absent(),
            required String shortName,
          }) =>
              BooksCompanion.insert(
            id: id,
            bibleId: bibleId,
            usfxId: usfxId,
            osisId: osisId,
            bookOrder: bookOrder,
            longName: longName,
            shortName: shortName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $BooksProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Books,
    Book,
    $BooksFilterComposer,
    $BooksOrderingComposer,
    $BooksAnnotationComposer,
    $BooksCreateCompanionBuilder,
    $BooksUpdateCompanionBuilder,
    (Book, BaseReferences<_$AppDb, Books, Book>),
    Book,
    PrefetchHooks Function()>;
typedef $VerseSegmentsCreateCompanionBuilder = VerseSegmentsCompanion Function({
  Value<int> id,
  required int bookId,
  required int chapterNumber,
  required int verseNumber,
  required int segmentIndex,
  Value<int> paragraphStart,
  required String textContent,
  Value<String?> subtitle,
});
typedef $VerseSegmentsUpdateCompanionBuilder = VerseSegmentsCompanion Function({
  Value<int> id,
  Value<int> bookId,
  Value<int> chapterNumber,
  Value<int> verseNumber,
  Value<int> segmentIndex,
  Value<int> paragraphStart,
  Value<String> textContent,
  Value<String?> subtitle,
});

class $VerseSegmentsFilterComposer extends Composer<_$AppDb, VerseSegments> {
  $VerseSegmentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get segmentIndex => $composableBuilder(
      column: $table.segmentIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paragraphStart => $composableBuilder(
      column: $table.paragraphStart,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnFilters(column));
}

class $VerseSegmentsOrderingComposer extends Composer<_$AppDb, VerseSegments> {
  $VerseSegmentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get segmentIndex => $composableBuilder(
      column: $table.segmentIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paragraphStart => $composableBuilder(
      column: $table.paragraphStart,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnOrderings(column));
}

class $VerseSegmentsAnnotationComposer
    extends Composer<_$AppDb, VerseSegments> {
  $VerseSegmentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => column);

  GeneratedColumn<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => column);

  GeneratedColumn<int> get segmentIndex => $composableBuilder(
      column: $table.segmentIndex, builder: (column) => column);

  GeneratedColumn<int> get paragraphStart => $composableBuilder(
      column: $table.paragraphStart, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);
}

class $VerseSegmentsTableManager extends RootTableManager<
    _$AppDb,
    VerseSegments,
    VerseSegment,
    $VerseSegmentsFilterComposer,
    $VerseSegmentsOrderingComposer,
    $VerseSegmentsAnnotationComposer,
    $VerseSegmentsCreateCompanionBuilder,
    $VerseSegmentsUpdateCompanionBuilder,
    (VerseSegment, BaseReferences<_$AppDb, VerseSegments, VerseSegment>),
    VerseSegment,
    PrefetchHooks Function()> {
  $VerseSegmentsTableManager(_$AppDb db, VerseSegments table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VerseSegmentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VerseSegmentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VerseSegmentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> chapterNumber = const Value.absent(),
            Value<int> verseNumber = const Value.absent(),
            Value<int> segmentIndex = const Value.absent(),
            Value<int> paragraphStart = const Value.absent(),
            Value<String> textContent = const Value.absent(),
            Value<String?> subtitle = const Value.absent(),
          }) =>
              VerseSegmentsCompanion(
            id: id,
            bookId: bookId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            segmentIndex: segmentIndex,
            paragraphStart: paragraphStart,
            textContent: textContent,
            subtitle: subtitle,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bookId,
            required int chapterNumber,
            required int verseNumber,
            required int segmentIndex,
            Value<int> paragraphStart = const Value.absent(),
            required String textContent,
            Value<String?> subtitle = const Value.absent(),
          }) =>
              VerseSegmentsCompanion.insert(
            id: id,
            bookId: bookId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            segmentIndex: segmentIndex,
            paragraphStart: paragraphStart,
            textContent: textContent,
            subtitle: subtitle,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $VerseSegmentsProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    VerseSegments,
    VerseSegment,
    $VerseSegmentsFilterComposer,
    $VerseSegmentsOrderingComposer,
    $VerseSegmentsAnnotationComposer,
    $VerseSegmentsCreateCompanionBuilder,
    $VerseSegmentsUpdateCompanionBuilder,
    (VerseSegment, BaseReferences<_$AppDb, VerseSegments, VerseSegment>),
    VerseSegment,
    PrefetchHooks Function()>;
typedef $SegmentSpansCreateCompanionBuilder = SegmentSpansCompanion Function({
  Value<int> id,
  required int segmentId,
  required int startOffset,
  required int endOffset,
  required int spanType,
  Value<String?> payload,
});
typedef $SegmentSpansUpdateCompanionBuilder = SegmentSpansCompanion Function({
  Value<int> id,
  Value<int> segmentId,
  Value<int> startOffset,
  Value<int> endOffset,
  Value<int> spanType,
  Value<String?> payload,
});

class $SegmentSpansFilterComposer extends Composer<_$AppDb, SegmentSpans> {
  $SegmentSpansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get segmentId => $composableBuilder(
      column: $table.segmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startOffset => $composableBuilder(
      column: $table.startOffset, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endOffset => $composableBuilder(
      column: $table.endOffset, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get spanType => $composableBuilder(
      column: $table.spanType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));
}

class $SegmentSpansOrderingComposer extends Composer<_$AppDb, SegmentSpans> {
  $SegmentSpansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get segmentId => $composableBuilder(
      column: $table.segmentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startOffset => $composableBuilder(
      column: $table.startOffset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endOffset => $composableBuilder(
      column: $table.endOffset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get spanType => $composableBuilder(
      column: $table.spanType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));
}

class $SegmentSpansAnnotationComposer extends Composer<_$AppDb, SegmentSpans> {
  $SegmentSpansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get segmentId =>
      $composableBuilder(column: $table.segmentId, builder: (column) => column);

  GeneratedColumn<int> get startOffset => $composableBuilder(
      column: $table.startOffset, builder: (column) => column);

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<int> get spanType =>
      $composableBuilder(column: $table.spanType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $SegmentSpansTableManager extends RootTableManager<
    _$AppDb,
    SegmentSpans,
    SegmentSpan,
    $SegmentSpansFilterComposer,
    $SegmentSpansOrderingComposer,
    $SegmentSpansAnnotationComposer,
    $SegmentSpansCreateCompanionBuilder,
    $SegmentSpansUpdateCompanionBuilder,
    (SegmentSpan, BaseReferences<_$AppDb, SegmentSpans, SegmentSpan>),
    SegmentSpan,
    PrefetchHooks Function()> {
  $SegmentSpansTableManager(_$AppDb db, SegmentSpans table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SegmentSpansFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SegmentSpansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SegmentSpansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> segmentId = const Value.absent(),
            Value<int> startOffset = const Value.absent(),
            Value<int> endOffset = const Value.absent(),
            Value<int> spanType = const Value.absent(),
            Value<String?> payload = const Value.absent(),
          }) =>
              SegmentSpansCompanion(
            id: id,
            segmentId: segmentId,
            startOffset: startOffset,
            endOffset: endOffset,
            spanType: spanType,
            payload: payload,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int segmentId,
            required int startOffset,
            required int endOffset,
            required int spanType,
            Value<String?> payload = const Value.absent(),
          }) =>
              SegmentSpansCompanion.insert(
            id: id,
            segmentId: segmentId,
            startOffset: startOffset,
            endOffset: endOffset,
            spanType: spanType,
            payload: payload,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $SegmentSpansProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    SegmentSpans,
    SegmentSpan,
    $SegmentSpansFilterComposer,
    $SegmentSpansOrderingComposer,
    $SegmentSpansAnnotationComposer,
    $SegmentSpansCreateCompanionBuilder,
    $SegmentSpansUpdateCompanionBuilder,
    (SegmentSpan, BaseReferences<_$AppDb, SegmentSpans, SegmentSpan>),
    SegmentSpan,
    PrefetchHooks Function()>;
typedef $VerseTextCreateCompanionBuilder = VerseTextCompanion Function({
  Value<int> id,
  required int bibleId,
  required String bookUsfxId,
  required int bookId,
  required int chapterNumber,
  required int verseNumber,
  required String textContent,
});
typedef $VerseTextUpdateCompanionBuilder = VerseTextCompanion Function({
  Value<int> id,
  Value<int> bibleId,
  Value<String> bookUsfxId,
  Value<int> bookId,
  Value<int> chapterNumber,
  Value<int> verseNumber,
  Value<String> textContent,
});

class $VerseTextFilterComposer extends Composer<_$AppDb, VerseText> {
  $VerseTextFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookUsfxId => $composableBuilder(
      column: $table.bookUsfxId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));
}

class $VerseTextOrderingComposer extends Composer<_$AppDb, VerseText> {
  $VerseTextOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookUsfxId => $composableBuilder(
      column: $table.bookUsfxId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));
}

class $VerseTextAnnotationComposer extends Composer<_$AppDb, VerseText> {
  $VerseTextAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bibleId =>
      $composableBuilder(column: $table.bibleId, builder: (column) => column);

  GeneratedColumn<String> get bookUsfxId => $composableBuilder(
      column: $table.bookUsfxId, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => column);

  GeneratedColumn<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);
}

class $VerseTextTableManager extends RootTableManager<
    _$AppDb,
    VerseText,
    VerseTextData,
    $VerseTextFilterComposer,
    $VerseTextOrderingComposer,
    $VerseTextAnnotationComposer,
    $VerseTextCreateCompanionBuilder,
    $VerseTextUpdateCompanionBuilder,
    (VerseTextData, BaseReferences<_$AppDb, VerseText, VerseTextData>),
    VerseTextData,
    PrefetchHooks Function()> {
  $VerseTextTableManager(_$AppDb db, VerseText table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VerseTextFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VerseTextOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VerseTextAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bibleId = const Value.absent(),
            Value<String> bookUsfxId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> chapterNumber = const Value.absent(),
            Value<int> verseNumber = const Value.absent(),
            Value<String> textContent = const Value.absent(),
          }) =>
              VerseTextCompanion(
            id: id,
            bibleId: bibleId,
            bookUsfxId: bookUsfxId,
            bookId: bookId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            textContent: textContent,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bibleId,
            required String bookUsfxId,
            required int bookId,
            required int chapterNumber,
            required int verseNumber,
            required String textContent,
          }) =>
              VerseTextCompanion.insert(
            id: id,
            bibleId: bibleId,
            bookUsfxId: bookUsfxId,
            bookId: bookId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            textContent: textContent,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $VerseTextProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    VerseText,
    VerseTextData,
    $VerseTextFilterComposer,
    $VerseTextOrderingComposer,
    $VerseTextAnnotationComposer,
    $VerseTextCreateCompanionBuilder,
    $VerseTextUpdateCompanionBuilder,
    (VerseTextData, BaseReferences<_$AppDb, VerseText, VerseTextData>),
    VerseTextData,
    PrefetchHooks Function()>;
typedef $VerseTextFtsCreateCompanionBuilder = VerseTextFtsCompanion Function({
  required String textContent,
  required String bibleId,
  Value<int> rowid,
});
typedef $VerseTextFtsUpdateCompanionBuilder = VerseTextFtsCompanion Function({
  Value<String> textContent,
  Value<String> bibleId,
  Value<int> rowid,
});

class $VerseTextFtsFilterComposer extends Composer<_$AppDb, VerseTextFts> {
  $VerseTextFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnFilters(column));
}

class $VerseTextFtsOrderingComposer extends Composer<_$AppDb, VerseTextFts> {
  $VerseTextFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnOrderings(column));
}

class $VerseTextFtsAnnotationComposer extends Composer<_$AppDb, VerseTextFts> {
  $VerseTextFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<String> get bibleId =>
      $composableBuilder(column: $table.bibleId, builder: (column) => column);
}

class $VerseTextFtsTableManager extends RootTableManager<
    _$AppDb,
    VerseTextFts,
    VerseTextFt,
    $VerseTextFtsFilterComposer,
    $VerseTextFtsOrderingComposer,
    $VerseTextFtsAnnotationComposer,
    $VerseTextFtsCreateCompanionBuilder,
    $VerseTextFtsUpdateCompanionBuilder,
    (VerseTextFt, BaseReferences<_$AppDb, VerseTextFts, VerseTextFt>),
    VerseTextFt,
    PrefetchHooks Function()> {
  $VerseTextFtsTableManager(_$AppDb db, VerseTextFts table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VerseTextFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VerseTextFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VerseTextFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> textContent = const Value.absent(),
            Value<String> bibleId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VerseTextFtsCompanion(
            textContent: textContent,
            bibleId: bibleId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String textContent,
            required String bibleId,
            Value<int> rowid = const Value.absent(),
          }) =>
              VerseTextFtsCompanion.insert(
            textContent: textContent,
            bibleId: bibleId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $VerseTextFtsProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    VerseTextFts,
    VerseTextFt,
    $VerseTextFtsFilterComposer,
    $VerseTextFtsOrderingComposer,
    $VerseTextFtsAnnotationComposer,
    $VerseTextFtsCreateCompanionBuilder,
    $VerseTextFtsUpdateCompanionBuilder,
    (VerseTextFt, BaseReferences<_$AppDb, VerseTextFts, VerseTextFt>),
    VerseTextFt,
    PrefetchHooks Function()>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $LanguagesTableManager get languages =>
      $LanguagesTableManager(_db, _db.languages);
  $BiblesTableManager get bibles => $BiblesTableManager(_db, _db.bibles);
  $BooksTableManager get books => $BooksTableManager(_db, _db.books);
  $VerseSegmentsTableManager get verseSegments =>
      $VerseSegmentsTableManager(_db, _db.verseSegments);
  $SegmentSpansTableManager get segmentSpans =>
      $SegmentSpansTableManager(_db, _db.segmentSpans);
  $VerseTextTableManager get verseText =>
      $VerseTextTableManager(_db, _db.verseText);
  $VerseTextFtsTableManager get verseTextFts =>
      $VerseTextFtsTableManager(_db, _db.verseTextFts);
}

class GetBiblesResult {
  final int id;
  final String usfxId;
  final int? languageId;
  final String bibleName;
  final String bibleNameLocal;
  final String bibleNameAbbreviation;
  final String? originSource;
  final String langEngName;
  final String? langIsoCode;
  final String? langNativeName;
  GetBiblesResult({
    required this.id,
    required this.usfxId,
    this.languageId,
    required this.bibleName,
    required this.bibleNameLocal,
    required this.bibleNameAbbreviation,
    this.originSource,
    required this.langEngName,
    this.langIsoCode,
    this.langNativeName,
  });
}

class GetBibleResult {
  final int id;
  final String usfxId;
  final int? languageId;
  final String bibleName;
  final String bibleNameLocal;
  final String bibleNameAbbreviation;
  final String? originSource;
  final String langEngName;
  final String? langIsoCode;
  final String? langNativeName;
  GetBibleResult({
    required this.id,
    required this.usfxId,
    this.languageId,
    required this.bibleName,
    required this.bibleNameLocal,
    required this.bibleNameAbbreviation,
    this.originSource,
    required this.langEngName,
    this.langIsoCode,
    this.langNativeName,
  });
}

class GetVerseSegmentsForChapterResult {
  final int id;
  final int bookId;
  final int chapterNumber;
  final int verseNumber;
  final int segmentIndex;
  final int paragraphStart;
  final String textContent;
  final String? subtitle;
  final int id1;
  final int bibleId;
  final String usfxId;
  final String osisId;
  final int? bookOrder;
  final String? longName;
  final String shortName;
  GetVerseSegmentsForChapterResult({
    required this.id,
    required this.bookId,
    required this.chapterNumber,
    required this.verseNumber,
    required this.segmentIndex,
    required this.paragraphStart,
    required this.textContent,
    this.subtitle,
    required this.id1,
    required this.bibleId,
    required this.usfxId,
    required this.osisId,
    this.bookOrder,
    this.longName,
    required this.shortName,
  });
}

class GetSegmentsForChapterWithSpansResult {
  final int segmentId;
  final int bookId;
  final int chapterNumber;
  final int verseNumber;
  final int segmentIndex;
  final int paragraphStart;
  final String textContent;
  final String? subtitle;
  final String spansJson;
  GetSegmentsForChapterWithSpansResult({
    required this.segmentId,
    required this.bookId,
    required this.chapterNumber,
    required this.verseNumber,
    required this.segmentIndex,
    required this.paragraphStart,
    required this.textContent,
    this.subtitle,
    required this.spansJson,
  });
}

class GetSegmentsByBibleIdResult {
  final int id;
  final int bookId;
  final String bookUsfxId;
  final int chapterNumber;
  final int verseNumber;
  final int segmentIndex;
  GetSegmentsByBibleIdResult({
    required this.id,
    required this.bookId,
    required this.bookUsfxId,
    required this.chapterNumber,
    required this.verseNumber,
    required this.segmentIndex,
  });
}

class SearchVersesResult {
  final int bibleId;
  final String bookUsfxId;
  final int chapterNumber;
  final int verseNumber;
  SearchVersesResult({
    required this.bibleId,
    required this.bookUsfxId,
    required this.chapterNumber,
    required this.verseNumber,
  });
}

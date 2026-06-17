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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _isoCodeMeta =
      const VerificationMeta('isoCode');
  late final GeneratedColumn<String> isoCode = GeneratedColumn<String>(
      'isoCode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _engNameMeta =
      const VerificationMeta('engName');
  late final GeneratedColumn<String> engName = GeneratedColumn<String>(
      'engName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nativeNameMeta =
      const VerificationMeta('nativeName');
  late final GeneratedColumn<String> nativeName = GeneratedColumn<String>(
      'nativeName', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [id, isoCode, engName, nativeName];
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
    if (data.containsKey('isoCode')) {
      context.handle(_isoCodeMeta,
          isoCode.isAcceptableOrUnknown(data['isoCode']!, _isoCodeMeta));
    } else if (isInserting) {
      context.missing(_isoCodeMeta);
    }
    if (data.containsKey('engName')) {
      context.handle(_engNameMeta,
          engName.isAcceptableOrUnknown(data['engName']!, _engNameMeta));
    } else if (isInserting) {
      context.missing(_engNameMeta);
    }
    if (data.containsKey('nativeName')) {
      context.handle(
          _nativeNameMeta,
          nativeName.isAcceptableOrUnknown(
              data['nativeName']!, _nativeNameMeta));
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
      isoCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}isoCode'])!,
      engName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}engName'])!,
      nativeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nativeName']),
    );
  }

  @override
  Languages createAlias(String alias) {
    return Languages(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class Language extends DataClass implements Insertable<Language> {
  final int id;
  final String isoCode;
  final String engName;
  final String? nativeName;
  const Language(
      {required this.id,
      required this.isoCode,
      required this.engName,
      this.nativeName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['isoCode'] = Variable<String>(isoCode);
    map['engName'] = Variable<String>(engName);
    if (!nullToAbsent || nativeName != null) {
      map['nativeName'] = Variable<String>(nativeName);
    }
    return map;
  }

  LanguagesCompanion toCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      id: Value(id),
      isoCode: Value(isoCode),
      engName: Value(engName),
      nativeName: nativeName == null && nullToAbsent
          ? const Value.absent()
          : Value(nativeName),
    );
  }

  factory Language.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Language(
      id: serializer.fromJson<int>(json['id']),
      isoCode: serializer.fromJson<String>(json['isoCode']),
      engName: serializer.fromJson<String>(json['engName']),
      nativeName: serializer.fromJson<String?>(json['nativeName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isoCode': serializer.toJson<String>(isoCode),
      'engName': serializer.toJson<String>(engName),
      'nativeName': serializer.toJson<String?>(nativeName),
    };
  }

  Language copyWith(
          {int? id,
          String? isoCode,
          String? engName,
          Value<String?> nativeName = const Value.absent()}) =>
      Language(
        id: id ?? this.id,
        isoCode: isoCode ?? this.isoCode,
        engName: engName ?? this.engName,
        nativeName: nativeName.present ? nativeName.value : this.nativeName,
      );
  Language copyWithCompanion(LanguagesCompanion data) {
    return Language(
      id: data.id.present ? data.id.value : this.id,
      isoCode: data.isoCode.present ? data.isoCode.value : this.isoCode,
      engName: data.engName.present ? data.engName.value : this.engName,
      nativeName:
          data.nativeName.present ? data.nativeName.value : this.nativeName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Language(')
          ..write('id: $id, ')
          ..write('isoCode: $isoCode, ')
          ..write('engName: $engName, ')
          ..write('nativeName: $nativeName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isoCode, engName, nativeName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Language &&
          other.id == this.id &&
          other.isoCode == this.isoCode &&
          other.engName == this.engName &&
          other.nativeName == this.nativeName);
}

class LanguagesCompanion extends UpdateCompanion<Language> {
  final Value<int> id;
  final Value<String> isoCode;
  final Value<String> engName;
  final Value<String?> nativeName;
  const LanguagesCompanion({
    this.id = const Value.absent(),
    this.isoCode = const Value.absent(),
    this.engName = const Value.absent(),
    this.nativeName = const Value.absent(),
  });
  LanguagesCompanion.insert({
    this.id = const Value.absent(),
    required String isoCode,
    required String engName,
    this.nativeName = const Value.absent(),
  })  : isoCode = Value(isoCode),
        engName = Value(engName);
  static Insertable<Language> custom({
    Expression<int>? id,
    Expression<String>? isoCode,
    Expression<String>? engName,
    Expression<String>? nativeName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isoCode != null) 'isoCode': isoCode,
      if (engName != null) 'engName': engName,
      if (nativeName != null) 'nativeName': nativeName,
    });
  }

  LanguagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? isoCode,
      Value<String>? engName,
      Value<String?>? nativeName}) {
    return LanguagesCompanion(
      id: id ?? this.id,
      isoCode: isoCode ?? this.isoCode,
      engName: engName ?? this.engName,
      nativeName: nativeName ?? this.nativeName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isoCode.present) {
      map['isoCode'] = Variable<String>(isoCode.value);
    }
    if (engName.present) {
      map['engName'] = Variable<String>(engName.value);
    }
    if (nativeName.present) {
      map['nativeName'] = Variable<String>(nativeName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesCompanion(')
          ..write('id: $id, ')
          ..write('isoCode: $isoCode, ')
          ..write('engName: $engName, ')
          ..write('nativeName: $nativeName')
          ..write(')'))
        .toString();
  }
}

class CanonicalBooks extends Table
    with TableInfo<CanonicalBooks, CanonicalBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CanonicalBooks(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _bookTokenMeta =
      const VerificationMeta('bookToken');
  late final GeneratedColumn<String> bookToken = GeneratedColumn<String>(
      'bookToken', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _bookOrderMeta =
      const VerificationMeta('bookOrder');
  late final GeneratedColumn<int> bookOrder = GeneratedColumn<int>(
      'bookOrder', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, bookToken, bookOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'canonical_books';
  @override
  VerificationContext validateIntegrity(Insertable<CanonicalBook> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bookToken')) {
      context.handle(_bookTokenMeta,
          bookToken.isAcceptableOrUnknown(data['bookToken']!, _bookTokenMeta));
    } else if (isInserting) {
      context.missing(_bookTokenMeta);
    }
    if (data.containsKey('bookOrder')) {
      context.handle(_bookOrderMeta,
          bookOrder.isAcceptableOrUnknown(data['bookOrder']!, _bookOrderMeta));
    } else if (isInserting) {
      context.missing(_bookOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CanonicalBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CanonicalBook(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bookToken'])!,
      bookOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookOrder'])!,
    );
  }

  @override
  CanonicalBooks createAlias(String alias) {
    return CanonicalBooks(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class CanonicalBook extends DataClass implements Insertable<CanonicalBook> {
  final int id;
  final String bookToken;

  /// e.g., 'GEN', 'EXO'
  final int bookOrder;
  const CanonicalBook(
      {required this.id, required this.bookToken, required this.bookOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bookToken'] = Variable<String>(bookToken);
    map['bookOrder'] = Variable<int>(bookOrder);
    return map;
  }

  CanonicalBooksCompanion toCompanion(bool nullToAbsent) {
    return CanonicalBooksCompanion(
      id: Value(id),
      bookToken: Value(bookToken),
      bookOrder: Value(bookOrder),
    );
  }

  factory CanonicalBook.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CanonicalBook(
      id: serializer.fromJson<int>(json['id']),
      bookToken: serializer.fromJson<String>(json['bookToken']),
      bookOrder: serializer.fromJson<int>(json['bookOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookToken': serializer.toJson<String>(bookToken),
      'bookOrder': serializer.toJson<int>(bookOrder),
    };
  }

  CanonicalBook copyWith({int? id, String? bookToken, int? bookOrder}) =>
      CanonicalBook(
        id: id ?? this.id,
        bookToken: bookToken ?? this.bookToken,
        bookOrder: bookOrder ?? this.bookOrder,
      );
  CanonicalBook copyWithCompanion(CanonicalBooksCompanion data) {
    return CanonicalBook(
      id: data.id.present ? data.id.value : this.id,
      bookToken: data.bookToken.present ? data.bookToken.value : this.bookToken,
      bookOrder: data.bookOrder.present ? data.bookOrder.value : this.bookOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CanonicalBook(')
          ..write('id: $id, ')
          ..write('bookToken: $bookToken, ')
          ..write('bookOrder: $bookOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookToken, bookOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CanonicalBook &&
          other.id == this.id &&
          other.bookToken == this.bookToken &&
          other.bookOrder == this.bookOrder);
}

class CanonicalBooksCompanion extends UpdateCompanion<CanonicalBook> {
  final Value<int> id;
  final Value<String> bookToken;
  final Value<int> bookOrder;
  const CanonicalBooksCompanion({
    this.id = const Value.absent(),
    this.bookToken = const Value.absent(),
    this.bookOrder = const Value.absent(),
  });
  CanonicalBooksCompanion.insert({
    this.id = const Value.absent(),
    required String bookToken,
    required int bookOrder,
  })  : bookToken = Value(bookToken),
        bookOrder = Value(bookOrder);
  static Insertable<CanonicalBook> custom({
    Expression<int>? id,
    Expression<String>? bookToken,
    Expression<int>? bookOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookToken != null) 'bookToken': bookToken,
      if (bookOrder != null) 'bookOrder': bookOrder,
    });
  }

  CanonicalBooksCompanion copyWith(
      {Value<int>? id, Value<String>? bookToken, Value<int>? bookOrder}) {
    return CanonicalBooksCompanion(
      id: id ?? this.id,
      bookToken: bookToken ?? this.bookToken,
      bookOrder: bookOrder ?? this.bookOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookToken.present) {
      map['bookToken'] = Variable<String>(bookToken.value);
    }
    if (bookOrder.present) {
      map['bookOrder'] = Variable<int>(bookOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CanonicalBooksCompanion(')
          ..write('id: $id, ')
          ..write('bookToken: $bookToken, ')
          ..write('bookOrder: $bookOrder')
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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _extIdMeta = const VerificationMeta('extId');
  late final GeneratedColumn<String> extId = GeneratedColumn<String>(
      'extId', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _languageIdMeta =
      const VerificationMeta('languageId');
  late final GeneratedColumn<int> languageId = GeneratedColumn<int>(
      'languageId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _bNameMeta = const VerificationMeta('bName');
  late final GeneratedColumn<String> bName = GeneratedColumn<String>(
      'bName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nameLocalMeta =
      const VerificationMeta('nameLocal');
  late final GeneratedColumn<String> nameLocal = GeneratedColumn<String>(
      'nameLocal', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _abbreviationMeta =
      const VerificationMeta('abbreviation');
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
      'abbreviation', aliasedName, false,
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
  static const VerificationMeta _originFormatMeta =
      const VerificationMeta('originFormat');
  late final GeneratedColumn<String> originFormat = GeneratedColumn<String>(
      'originFormat', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _bDescriptionMeta =
      const VerificationMeta('bDescription');
  late final GeneratedColumn<String> bDescription = GeneratedColumn<String>(
      'bDescription', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _copyrightMeta =
      const VerificationMeta('copyright');
  late final GeneratedColumn<String> copyright = GeneratedColumn<String>(
      'copyright', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        extId,
        languageId,
        bName,
        nameLocal,
        abbreviation,
        originSource,
        originFormat,
        bDescription,
        copyright
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
    if (data.containsKey('extId')) {
      context.handle(
          _extIdMeta, extId.isAcceptableOrUnknown(data['extId']!, _extIdMeta));
    } else if (isInserting) {
      context.missing(_extIdMeta);
    }
    if (data.containsKey('languageId')) {
      context.handle(
          _languageIdMeta,
          languageId.isAcceptableOrUnknown(
              data['languageId']!, _languageIdMeta));
    } else if (isInserting) {
      context.missing(_languageIdMeta);
    }
    if (data.containsKey('bName')) {
      context.handle(
          _bNameMeta, bName.isAcceptableOrUnknown(data['bName']!, _bNameMeta));
    } else if (isInserting) {
      context.missing(_bNameMeta);
    }
    if (data.containsKey('nameLocal')) {
      context.handle(_nameLocalMeta,
          nameLocal.isAcceptableOrUnknown(data['nameLocal']!, _nameLocalMeta));
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
          _abbreviationMeta,
          abbreviation.isAcceptableOrUnknown(
              data['abbreviation']!, _abbreviationMeta));
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('originSource')) {
      context.handle(
          _originSourceMeta,
          originSource.isAcceptableOrUnknown(
              data['originSource']!, _originSourceMeta));
    }
    if (data.containsKey('originFormat')) {
      context.handle(
          _originFormatMeta,
          originFormat.isAcceptableOrUnknown(
              data['originFormat']!, _originFormatMeta));
    }
    if (data.containsKey('bDescription')) {
      context.handle(
          _bDescriptionMeta,
          bDescription.isAcceptableOrUnknown(
              data['bDescription']!, _bDescriptionMeta));
    }
    if (data.containsKey('copyright')) {
      context.handle(_copyrightMeta,
          copyright.isAcceptableOrUnknown(data['copyright']!, _copyrightMeta));
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
      extId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extId'])!,
      languageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}languageId'])!,
      bName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bName'])!,
      nameLocal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nameLocal']),
      abbreviation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abbreviation'])!,
      originSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}originSource']),
      originFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}originFormat']),
      bDescription: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bDescription']),
      copyright: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}copyright']),
    );
  }

  @override
  Bibles createAlias(String alias) {
    return Bibles(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY(languageId)REFERENCES languages(id)ON DELETE RESTRICT'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Bible extends DataClass implements Insertable<Bible> {
  final int id;
  final String extId;

  /// e.g., 'KJV', 'RVR1960'
  final int languageId;
  final String bName;
  final String? nameLocal;
  final String abbreviation;
  final String? originSource;
  final String? originFormat;
  final String? bDescription;
  final String? copyright;
  const Bible(
      {required this.id,
      required this.extId,
      required this.languageId,
      required this.bName,
      this.nameLocal,
      required this.abbreviation,
      this.originSource,
      this.originFormat,
      this.bDescription,
      this.copyright});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['extId'] = Variable<String>(extId);
    map['languageId'] = Variable<int>(languageId);
    map['bName'] = Variable<String>(bName);
    if (!nullToAbsent || nameLocal != null) {
      map['nameLocal'] = Variable<String>(nameLocal);
    }
    map['abbreviation'] = Variable<String>(abbreviation);
    if (!nullToAbsent || originSource != null) {
      map['originSource'] = Variable<String>(originSource);
    }
    if (!nullToAbsent || originFormat != null) {
      map['originFormat'] = Variable<String>(originFormat);
    }
    if (!nullToAbsent || bDescription != null) {
      map['bDescription'] = Variable<String>(bDescription);
    }
    if (!nullToAbsent || copyright != null) {
      map['copyright'] = Variable<String>(copyright);
    }
    return map;
  }

  BiblesCompanion toCompanion(bool nullToAbsent) {
    return BiblesCompanion(
      id: Value(id),
      extId: Value(extId),
      languageId: Value(languageId),
      bName: Value(bName),
      nameLocal: nameLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(nameLocal),
      abbreviation: Value(abbreviation),
      originSource: originSource == null && nullToAbsent
          ? const Value.absent()
          : Value(originSource),
      originFormat: originFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(originFormat),
      bDescription: bDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(bDescription),
      copyright: copyright == null && nullToAbsent
          ? const Value.absent()
          : Value(copyright),
    );
  }

  factory Bible.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bible(
      id: serializer.fromJson<int>(json['id']),
      extId: serializer.fromJson<String>(json['extId']),
      languageId: serializer.fromJson<int>(json['languageId']),
      bName: serializer.fromJson<String>(json['bName']),
      nameLocal: serializer.fromJson<String?>(json['nameLocal']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      originSource: serializer.fromJson<String?>(json['originSource']),
      originFormat: serializer.fromJson<String?>(json['originFormat']),
      bDescription: serializer.fromJson<String?>(json['bDescription']),
      copyright: serializer.fromJson<String?>(json['copyright']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'extId': serializer.toJson<String>(extId),
      'languageId': serializer.toJson<int>(languageId),
      'bName': serializer.toJson<String>(bName),
      'nameLocal': serializer.toJson<String?>(nameLocal),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'originSource': serializer.toJson<String?>(originSource),
      'originFormat': serializer.toJson<String?>(originFormat),
      'bDescription': serializer.toJson<String?>(bDescription),
      'copyright': serializer.toJson<String?>(copyright),
    };
  }

  Bible copyWith(
          {int? id,
          String? extId,
          int? languageId,
          String? bName,
          Value<String?> nameLocal = const Value.absent(),
          String? abbreviation,
          Value<String?> originSource = const Value.absent(),
          Value<String?> originFormat = const Value.absent(),
          Value<String?> bDescription = const Value.absent(),
          Value<String?> copyright = const Value.absent()}) =>
      Bible(
        id: id ?? this.id,
        extId: extId ?? this.extId,
        languageId: languageId ?? this.languageId,
        bName: bName ?? this.bName,
        nameLocal: nameLocal.present ? nameLocal.value : this.nameLocal,
        abbreviation: abbreviation ?? this.abbreviation,
        originSource:
            originSource.present ? originSource.value : this.originSource,
        originFormat:
            originFormat.present ? originFormat.value : this.originFormat,
        bDescription:
            bDescription.present ? bDescription.value : this.bDescription,
        copyright: copyright.present ? copyright.value : this.copyright,
      );
  Bible copyWithCompanion(BiblesCompanion data) {
    return Bible(
      id: data.id.present ? data.id.value : this.id,
      extId: data.extId.present ? data.extId.value : this.extId,
      languageId:
          data.languageId.present ? data.languageId.value : this.languageId,
      bName: data.bName.present ? data.bName.value : this.bName,
      nameLocal: data.nameLocal.present ? data.nameLocal.value : this.nameLocal,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      originSource: data.originSource.present
          ? data.originSource.value
          : this.originSource,
      originFormat: data.originFormat.present
          ? data.originFormat.value
          : this.originFormat,
      bDescription: data.bDescription.present
          ? data.bDescription.value
          : this.bDescription,
      copyright: data.copyright.present ? data.copyright.value : this.copyright,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bible(')
          ..write('id: $id, ')
          ..write('extId: $extId, ')
          ..write('languageId: $languageId, ')
          ..write('bName: $bName, ')
          ..write('nameLocal: $nameLocal, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('originSource: $originSource, ')
          ..write('originFormat: $originFormat, ')
          ..write('bDescription: $bDescription, ')
          ..write('copyright: $copyright')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, extId, languageId, bName, nameLocal,
      abbreviation, originSource, originFormat, bDescription, copyright);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bible &&
          other.id == this.id &&
          other.extId == this.extId &&
          other.languageId == this.languageId &&
          other.bName == this.bName &&
          other.nameLocal == this.nameLocal &&
          other.abbreviation == this.abbreviation &&
          other.originSource == this.originSource &&
          other.originFormat == this.originFormat &&
          other.bDescription == this.bDescription &&
          other.copyright == this.copyright);
}

class BiblesCompanion extends UpdateCompanion<Bible> {
  final Value<int> id;
  final Value<String> extId;
  final Value<int> languageId;
  final Value<String> bName;
  final Value<String?> nameLocal;
  final Value<String> abbreviation;
  final Value<String?> originSource;
  final Value<String?> originFormat;
  final Value<String?> bDescription;
  final Value<String?> copyright;
  const BiblesCompanion({
    this.id = const Value.absent(),
    this.extId = const Value.absent(),
    this.languageId = const Value.absent(),
    this.bName = const Value.absent(),
    this.nameLocal = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.originSource = const Value.absent(),
    this.originFormat = const Value.absent(),
    this.bDescription = const Value.absent(),
    this.copyright = const Value.absent(),
  });
  BiblesCompanion.insert({
    this.id = const Value.absent(),
    required String extId,
    required int languageId,
    required String bName,
    this.nameLocal = const Value.absent(),
    required String abbreviation,
    this.originSource = const Value.absent(),
    this.originFormat = const Value.absent(),
    this.bDescription = const Value.absent(),
    this.copyright = const Value.absent(),
  })  : extId = Value(extId),
        languageId = Value(languageId),
        bName = Value(bName),
        abbreviation = Value(abbreviation);
  static Insertable<Bible> custom({
    Expression<int>? id,
    Expression<String>? extId,
    Expression<int>? languageId,
    Expression<String>? bName,
    Expression<String>? nameLocal,
    Expression<String>? abbreviation,
    Expression<String>? originSource,
    Expression<String>? originFormat,
    Expression<String>? bDescription,
    Expression<String>? copyright,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (extId != null) 'extId': extId,
      if (languageId != null) 'languageId': languageId,
      if (bName != null) 'bName': bName,
      if (nameLocal != null) 'nameLocal': nameLocal,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (originSource != null) 'originSource': originSource,
      if (originFormat != null) 'originFormat': originFormat,
      if (bDescription != null) 'bDescription': bDescription,
      if (copyright != null) 'copyright': copyright,
    });
  }

  BiblesCompanion copyWith(
      {Value<int>? id,
      Value<String>? extId,
      Value<int>? languageId,
      Value<String>? bName,
      Value<String?>? nameLocal,
      Value<String>? abbreviation,
      Value<String?>? originSource,
      Value<String?>? originFormat,
      Value<String?>? bDescription,
      Value<String?>? copyright}) {
    return BiblesCompanion(
      id: id ?? this.id,
      extId: extId ?? this.extId,
      languageId: languageId ?? this.languageId,
      bName: bName ?? this.bName,
      nameLocal: nameLocal ?? this.nameLocal,
      abbreviation: abbreviation ?? this.abbreviation,
      originSource: originSource ?? this.originSource,
      originFormat: originFormat ?? this.originFormat,
      bDescription: bDescription ?? this.bDescription,
      copyright: copyright ?? this.copyright,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (extId.present) {
      map['extId'] = Variable<String>(extId.value);
    }
    if (languageId.present) {
      map['languageId'] = Variable<int>(languageId.value);
    }
    if (bName.present) {
      map['bName'] = Variable<String>(bName.value);
    }
    if (nameLocal.present) {
      map['nameLocal'] = Variable<String>(nameLocal.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (originSource.present) {
      map['originSource'] = Variable<String>(originSource.value);
    }
    if (originFormat.present) {
      map['originFormat'] = Variable<String>(originFormat.value);
    }
    if (bDescription.present) {
      map['bDescription'] = Variable<String>(bDescription.value);
    }
    if (copyright.present) {
      map['copyright'] = Variable<String>(copyright.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BiblesCompanion(')
          ..write('id: $id, ')
          ..write('extId: $extId, ')
          ..write('languageId: $languageId, ')
          ..write('bName: $bName, ')
          ..write('nameLocal: $nameLocal, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('originSource: $originSource, ')
          ..write('originFormat: $originFormat, ')
          ..write('bDescription: $bDescription, ')
          ..write('copyright: $copyright')
          ..write(')'))
        .toString();
  }
}

class LocalizedBookNames extends Table
    with TableInfo<LocalizedBookNames, LocalizedBookName> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LocalizedBookNames(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bibleIdMeta =
      const VerificationMeta('bibleId');
  late final GeneratedColumn<int> bibleId = GeneratedColumn<int>(
      'bibleId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'bookId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _longNameMeta =
      const VerificationMeta('longName');
  late final GeneratedColumn<String> longName = GeneratedColumn<String>(
      'longName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _shortNameMeta =
      const VerificationMeta('shortName');
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
      'shortName', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _abbrMeta = const VerificationMeta('abbr');
  late final GeneratedColumn<String> abbr = GeneratedColumn<String>(
      'abbr', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _aliasesMeta =
      const VerificationMeta('aliases');
  late final GeneratedColumn<String> aliases = GeneratedColumn<String>(
      'aliases', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [bibleId, bookId, longName, shortName, abbr, aliases];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'localized_book_names';
  @override
  VerificationContext validateIntegrity(Insertable<LocalizedBookName> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bibleId')) {
      context.handle(_bibleIdMeta,
          bibleId.isAcceptableOrUnknown(data['bibleId']!, _bibleIdMeta));
    } else if (isInserting) {
      context.missing(_bibleIdMeta);
    }
    if (data.containsKey('bookId')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['bookId']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('longName')) {
      context.handle(_longNameMeta,
          longName.isAcceptableOrUnknown(data['longName']!, _longNameMeta));
    } else if (isInserting) {
      context.missing(_longNameMeta);
    }
    if (data.containsKey('shortName')) {
      context.handle(_shortNameMeta,
          shortName.isAcceptableOrUnknown(data['shortName']!, _shortNameMeta));
    } else if (isInserting) {
      context.missing(_shortNameMeta);
    }
    if (data.containsKey('abbr')) {
      context.handle(
          _abbrMeta, abbr.isAcceptableOrUnknown(data['abbr']!, _abbrMeta));
    }
    if (data.containsKey('aliases')) {
      context.handle(_aliasesMeta,
          aliases.isAcceptableOrUnknown(data['aliases']!, _aliasesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bibleId, bookId};
  @override
  LocalizedBookName map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalizedBookName(
      bibleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bibleId'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookId'])!,
      longName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}longName'])!,
      shortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shortName'])!,
      abbr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abbr']),
      aliases: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aliases']),
    );
  }

  @override
  LocalizedBookNames createAlias(String alias) {
    return LocalizedBookNames(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
        'PRIMARY KEY(bibleId, bookId)',
        'FOREIGN KEY(bibleId)REFERENCES bibles(id)ON DELETE CASCADE',
        'FOREIGN KEY(bookId)REFERENCES canonical_books(id)ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class LocalizedBookName extends DataClass
    implements Insertable<LocalizedBookName> {
  final int bibleId;
  final int bookId;
  final String longName;
  final String shortName;
  final String? abbr;

  /// A comma-separated list of searchable aliases for this specific language
  /// e.g., 'sng, song, sos, canticles'
  final String? aliases;
  const LocalizedBookName(
      {required this.bibleId,
      required this.bookId,
      required this.longName,
      required this.shortName,
      this.abbr,
      this.aliases});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bibleId'] = Variable<int>(bibleId);
    map['bookId'] = Variable<int>(bookId);
    map['longName'] = Variable<String>(longName);
    map['shortName'] = Variable<String>(shortName);
    if (!nullToAbsent || abbr != null) {
      map['abbr'] = Variable<String>(abbr);
    }
    if (!nullToAbsent || aliases != null) {
      map['aliases'] = Variable<String>(aliases);
    }
    return map;
  }

  LocalizedBookNamesCompanion toCompanion(bool nullToAbsent) {
    return LocalizedBookNamesCompanion(
      bibleId: Value(bibleId),
      bookId: Value(bookId),
      longName: Value(longName),
      shortName: Value(shortName),
      abbr: abbr == null && nullToAbsent ? const Value.absent() : Value(abbr),
      aliases: aliases == null && nullToAbsent
          ? const Value.absent()
          : Value(aliases),
    );
  }

  factory LocalizedBookName.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalizedBookName(
      bibleId: serializer.fromJson<int>(json['bibleId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      longName: serializer.fromJson<String>(json['longName']),
      shortName: serializer.fromJson<String>(json['shortName']),
      abbr: serializer.fromJson<String?>(json['abbr']),
      aliases: serializer.fromJson<String?>(json['aliases']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bibleId': serializer.toJson<int>(bibleId),
      'bookId': serializer.toJson<int>(bookId),
      'longName': serializer.toJson<String>(longName),
      'shortName': serializer.toJson<String>(shortName),
      'abbr': serializer.toJson<String?>(abbr),
      'aliases': serializer.toJson<String?>(aliases),
    };
  }

  LocalizedBookName copyWith(
          {int? bibleId,
          int? bookId,
          String? longName,
          String? shortName,
          Value<String?> abbr = const Value.absent(),
          Value<String?> aliases = const Value.absent()}) =>
      LocalizedBookName(
        bibleId: bibleId ?? this.bibleId,
        bookId: bookId ?? this.bookId,
        longName: longName ?? this.longName,
        shortName: shortName ?? this.shortName,
        abbr: abbr.present ? abbr.value : this.abbr,
        aliases: aliases.present ? aliases.value : this.aliases,
      );
  LocalizedBookName copyWithCompanion(LocalizedBookNamesCompanion data) {
    return LocalizedBookName(
      bibleId: data.bibleId.present ? data.bibleId.value : this.bibleId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      longName: data.longName.present ? data.longName.value : this.longName,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
      abbr: data.abbr.present ? data.abbr.value : this.abbr,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalizedBookName(')
          ..write('bibleId: $bibleId, ')
          ..write('bookId: $bookId, ')
          ..write('longName: $longName, ')
          ..write('shortName: $shortName, ')
          ..write('abbr: $abbr, ')
          ..write('aliases: $aliases')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(bibleId, bookId, longName, shortName, abbr, aliases);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalizedBookName &&
          other.bibleId == this.bibleId &&
          other.bookId == this.bookId &&
          other.longName == this.longName &&
          other.shortName == this.shortName &&
          other.abbr == this.abbr &&
          other.aliases == this.aliases);
}

class LocalizedBookNamesCompanion extends UpdateCompanion<LocalizedBookName> {
  final Value<int> bibleId;
  final Value<int> bookId;
  final Value<String> longName;
  final Value<String> shortName;
  final Value<String?> abbr;
  final Value<String?> aliases;
  const LocalizedBookNamesCompanion({
    this.bibleId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.longName = const Value.absent(),
    this.shortName = const Value.absent(),
    this.abbr = const Value.absent(),
    this.aliases = const Value.absent(),
  });
  LocalizedBookNamesCompanion.insert({
    required int bibleId,
    required int bookId,
    required String longName,
    required String shortName,
    this.abbr = const Value.absent(),
    this.aliases = const Value.absent(),
  })  : bibleId = Value(bibleId),
        bookId = Value(bookId),
        longName = Value(longName),
        shortName = Value(shortName);
  static Insertable<LocalizedBookName> custom({
    Expression<int>? bibleId,
    Expression<int>? bookId,
    Expression<String>? longName,
    Expression<String>? shortName,
    Expression<String>? abbr,
    Expression<String>? aliases,
  }) {
    return RawValuesInsertable({
      if (bibleId != null) 'bibleId': bibleId,
      if (bookId != null) 'bookId': bookId,
      if (longName != null) 'longName': longName,
      if (shortName != null) 'shortName': shortName,
      if (abbr != null) 'abbr': abbr,
      if (aliases != null) 'aliases': aliases,
    });
  }

  LocalizedBookNamesCompanion copyWith(
      {Value<int>? bibleId,
      Value<int>? bookId,
      Value<String>? longName,
      Value<String>? shortName,
      Value<String?>? abbr,
      Value<String?>? aliases}) {
    return LocalizedBookNamesCompanion(
      bibleId: bibleId ?? this.bibleId,
      bookId: bookId ?? this.bookId,
      longName: longName ?? this.longName,
      shortName: shortName ?? this.shortName,
      abbr: abbr ?? this.abbr,
      aliases: aliases ?? this.aliases,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bibleId.present) {
      map['bibleId'] = Variable<int>(bibleId.value);
    }
    if (bookId.present) {
      map['bookId'] = Variable<int>(bookId.value);
    }
    if (longName.present) {
      map['longName'] = Variable<String>(longName.value);
    }
    if (shortName.present) {
      map['shortName'] = Variable<String>(shortName.value);
    }
    if (abbr.present) {
      map['abbr'] = Variable<String>(abbr.value);
    }
    if (aliases.present) {
      map['aliases'] = Variable<String>(aliases.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalizedBookNamesCompanion(')
          ..write('bibleId: $bibleId, ')
          ..write('bookId: $bookId, ')
          ..write('longName: $longName, ')
          ..write('shortName: $shortName, ')
          ..write('abbr: $abbr, ')
          ..write('aliases: $aliases')
          ..write(')'))
        .toString();
  }
}

class VerseSegments extends Table with TableInfo<VerseSegments, VerseSegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VerseSegments(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bibleIdMeta =
      const VerificationMeta('bibleId');
  late final GeneratedColumn<int> bibleId = GeneratedColumn<int>(
      'bibleId', aliasedName, false,
      type: DriftSqlType.int,
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
      $customConstraints: 'NOT NULL DEFAULT 0 CHECK (paragraphStart IN (0, 1))',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _headingMeta =
      const VerificationMeta('heading');
  late final GeneratedColumn<String> heading = GeneratedColumn<String>(
      'heading', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _spansJsonMeta =
      const VerificationMeta('spansJson');
  late final GeneratedColumn<String> spansJson = GeneratedColumn<String>(
      'spansJson', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (json_valid(spansJson))');
  @override
  List<GeneratedColumn> get $columns => [
        bibleId,
        bookId,
        chapterNumber,
        verseNumber,
        segmentIndex,
        paragraphStart,
        heading,
        spansJson
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
    if (data.containsKey('bibleId')) {
      context.handle(_bibleIdMeta,
          bibleId.isAcceptableOrUnknown(data['bibleId']!, _bibleIdMeta));
    } else if (isInserting) {
      context.missing(_bibleIdMeta);
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
    if (data.containsKey('heading')) {
      context.handle(_headingMeta,
          heading.isAcceptableOrUnknown(data['heading']!, _headingMeta));
    }
    if (data.containsKey('spansJson')) {
      context.handle(_spansJsonMeta,
          spansJson.isAcceptableOrUnknown(data['spansJson']!, _spansJsonMeta));
    } else if (isInserting) {
      context.missing(_spansJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {bibleId, bookId, chapterNumber, verseNumber, segmentIndex};
  @override
  VerseSegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseSegment(
      bibleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bibleId'])!,
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
      heading: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}heading']),
      spansJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}spansJson'])!,
    );
  }

  @override
  VerseSegments createAlias(String alias) {
    return VerseSegments(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
        'PRIMARY KEY(bibleId, bookId, chapterNumber, verseNumber, segmentIndex)',
        'FOREIGN KEY(bibleId)REFERENCES bibles(id)ON DELETE CASCADE',
        'FOREIGN KEY(bookId)REFERENCES canonical_books(id)ON DELETE RESTRICT'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class VerseSegment extends DataClass implements Insertable<VerseSegment> {
  final int bibleId;
  final int bookId;
  final int chapterNumber;
  final int verseNumber;
  final int segmentIndex;
  final int paragraphStart;
  final String? heading;
  final String spansJson;
  const VerseSegment(
      {required this.bibleId,
      required this.bookId,
      required this.chapterNumber,
      required this.verseNumber,
      required this.segmentIndex,
      required this.paragraphStart,
      this.heading,
      required this.spansJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bibleId'] = Variable<int>(bibleId);
    map['bookId'] = Variable<int>(bookId);
    map['chapterNumber'] = Variable<int>(chapterNumber);
    map['verseNumber'] = Variable<int>(verseNumber);
    map['segmentIndex'] = Variable<int>(segmentIndex);
    map['paragraphStart'] = Variable<int>(paragraphStart);
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<String>(heading);
    }
    map['spansJson'] = Variable<String>(spansJson);
    return map;
  }

  VerseSegmentsCompanion toCompanion(bool nullToAbsent) {
    return VerseSegmentsCompanion(
      bibleId: Value(bibleId),
      bookId: Value(bookId),
      chapterNumber: Value(chapterNumber),
      verseNumber: Value(verseNumber),
      segmentIndex: Value(segmentIndex),
      paragraphStart: Value(paragraphStart),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
      spansJson: Value(spansJson),
    );
  }

  factory VerseSegment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseSegment(
      bibleId: serializer.fromJson<int>(json['bibleId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapterNumber: serializer.fromJson<int>(json['chapterNumber']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      segmentIndex: serializer.fromJson<int>(json['segmentIndex']),
      paragraphStart: serializer.fromJson<int>(json['paragraphStart']),
      heading: serializer.fromJson<String?>(json['heading']),
      spansJson: serializer.fromJson<String>(json['spansJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bibleId': serializer.toJson<int>(bibleId),
      'bookId': serializer.toJson<int>(bookId),
      'chapterNumber': serializer.toJson<int>(chapterNumber),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'segmentIndex': serializer.toJson<int>(segmentIndex),
      'paragraphStart': serializer.toJson<int>(paragraphStart),
      'heading': serializer.toJson<String?>(heading),
      'spansJson': serializer.toJson<String>(spansJson),
    };
  }

  VerseSegment copyWith(
          {int? bibleId,
          int? bookId,
          int? chapterNumber,
          int? verseNumber,
          int? segmentIndex,
          int? paragraphStart,
          Value<String?> heading = const Value.absent(),
          String? spansJson}) =>
      VerseSegment(
        bibleId: bibleId ?? this.bibleId,
        bookId: bookId ?? this.bookId,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        verseNumber: verseNumber ?? this.verseNumber,
        segmentIndex: segmentIndex ?? this.segmentIndex,
        paragraphStart: paragraphStart ?? this.paragraphStart,
        heading: heading.present ? heading.value : this.heading,
        spansJson: spansJson ?? this.spansJson,
      );
  VerseSegment copyWithCompanion(VerseSegmentsCompanion data) {
    return VerseSegment(
      bibleId: data.bibleId.present ? data.bibleId.value : this.bibleId,
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
      heading: data.heading.present ? data.heading.value : this.heading,
      spansJson: data.spansJson.present ? data.spansJson.value : this.spansJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseSegment(')
          ..write('bibleId: $bibleId, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('paragraphStart: $paragraphStart, ')
          ..write('heading: $heading, ')
          ..write('spansJson: $spansJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bibleId, bookId, chapterNumber, verseNumber,
      segmentIndex, paragraphStart, heading, spansJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseSegment &&
          other.bibleId == this.bibleId &&
          other.bookId == this.bookId &&
          other.chapterNumber == this.chapterNumber &&
          other.verseNumber == this.verseNumber &&
          other.segmentIndex == this.segmentIndex &&
          other.paragraphStart == this.paragraphStart &&
          other.heading == this.heading &&
          other.spansJson == this.spansJson);
}

class VerseSegmentsCompanion extends UpdateCompanion<VerseSegment> {
  final Value<int> bibleId;
  final Value<int> bookId;
  final Value<int> chapterNumber;
  final Value<int> verseNumber;
  final Value<int> segmentIndex;
  final Value<int> paragraphStart;
  final Value<String?> heading;
  final Value<String> spansJson;
  const VerseSegmentsCompanion({
    this.bibleId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.segmentIndex = const Value.absent(),
    this.paragraphStart = const Value.absent(),
    this.heading = const Value.absent(),
    this.spansJson = const Value.absent(),
  });
  VerseSegmentsCompanion.insert({
    required int bibleId,
    required int bookId,
    required int chapterNumber,
    required int verseNumber,
    required int segmentIndex,
    this.paragraphStart = const Value.absent(),
    this.heading = const Value.absent(),
    required String spansJson,
  })  : bibleId = Value(bibleId),
        bookId = Value(bookId),
        chapterNumber = Value(chapterNumber),
        verseNumber = Value(verseNumber),
        segmentIndex = Value(segmentIndex),
        spansJson = Value(spansJson);
  static Insertable<VerseSegment> custom({
    Expression<int>? bibleId,
    Expression<int>? bookId,
    Expression<int>? chapterNumber,
    Expression<int>? verseNumber,
    Expression<int>? segmentIndex,
    Expression<int>? paragraphStart,
    Expression<String>? heading,
    Expression<String>? spansJson,
  }) {
    return RawValuesInsertable({
      if (bibleId != null) 'bibleId': bibleId,
      if (bookId != null) 'bookId': bookId,
      if (chapterNumber != null) 'chapterNumber': chapterNumber,
      if (verseNumber != null) 'verseNumber': verseNumber,
      if (segmentIndex != null) 'segmentIndex': segmentIndex,
      if (paragraphStart != null) 'paragraphStart': paragraphStart,
      if (heading != null) 'heading': heading,
      if (spansJson != null) 'spansJson': spansJson,
    });
  }

  VerseSegmentsCompanion copyWith(
      {Value<int>? bibleId,
      Value<int>? bookId,
      Value<int>? chapterNumber,
      Value<int>? verseNumber,
      Value<int>? segmentIndex,
      Value<int>? paragraphStart,
      Value<String?>? heading,
      Value<String>? spansJson}) {
    return VerseSegmentsCompanion(
      bibleId: bibleId ?? this.bibleId,
      bookId: bookId ?? this.bookId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      paragraphStart: paragraphStart ?? this.paragraphStart,
      heading: heading ?? this.heading,
      spansJson: spansJson ?? this.spansJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bibleId.present) {
      map['bibleId'] = Variable<int>(bibleId.value);
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
    if (heading.present) {
      map['heading'] = Variable<String>(heading.value);
    }
    if (spansJson.present) {
      map['spansJson'] = Variable<String>(spansJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseSegmentsCompanion(')
          ..write('bibleId: $bibleId, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('paragraphStart: $paragraphStart, ')
          ..write('heading: $heading, ')
          ..write('spansJson: $spansJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final Languages languages = Languages(this);
  late final CanonicalBooks canonicalBooks = CanonicalBooks(this);
  late final Bibles bibles = Bibles(this);
  late final LocalizedBookNames localizedBookNames = LocalizedBookNames(this);
  late final VerseSegments verseSegments = VerseSegments(this);
  late final Index ixCanonicalBooksOrder = Index('ix_canonical_books_order',
      'CREATE INDEX ix_canonical_books_order ON canonical_books (bookOrder)');
  late final BibleInstallationDao bibleInstallationDao =
      BibleInstallationDao(this as AppDb);
  late final BibleContentDao bibleContentDao = BibleContentDao(this as AppDb);
  late final InstalledBiblesDao installedBiblesDao =
      InstalledBiblesDao(this as AppDb);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        languages,
        canonicalBooks,
        bibles,
        localizedBookNames,
        verseSegments,
        ixCanonicalBooksOrder
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('bibles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('localized_book_names', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('canonical_books',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('localized_book_names', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('bibles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('verse_segments', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $LanguagesCreateCompanionBuilder = LanguagesCompanion Function({
  Value<int> id,
  required String isoCode,
  required String engName,
  Value<String?> nativeName,
});
typedef $LanguagesUpdateCompanionBuilder = LanguagesCompanion Function({
  Value<int> id,
  Value<String> isoCode,
  Value<String> engName,
  Value<String?> nativeName,
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

  ColumnFilters<String> get isoCode => $composableBuilder(
      column: $table.isoCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get engName => $composableBuilder(
      column: $table.engName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nativeName => $composableBuilder(
      column: $table.nativeName, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get isoCode => $composableBuilder(
      column: $table.isoCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get engName => $composableBuilder(
      column: $table.engName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nativeName => $composableBuilder(
      column: $table.nativeName, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get isoCode =>
      $composableBuilder(column: $table.isoCode, builder: (column) => column);

  GeneratedColumn<String> get engName =>
      $composableBuilder(column: $table.engName, builder: (column) => column);

  GeneratedColumn<String> get nativeName => $composableBuilder(
      column: $table.nativeName, builder: (column) => column);
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
            Value<String> isoCode = const Value.absent(),
            Value<String> engName = const Value.absent(),
            Value<String?> nativeName = const Value.absent(),
          }) =>
              LanguagesCompanion(
            id: id,
            isoCode: isoCode,
            engName: engName,
            nativeName: nativeName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String isoCode,
            required String engName,
            Value<String?> nativeName = const Value.absent(),
          }) =>
              LanguagesCompanion.insert(
            id: id,
            isoCode: isoCode,
            engName: engName,
            nativeName: nativeName,
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
typedef $CanonicalBooksCreateCompanionBuilder = CanonicalBooksCompanion
    Function({
  Value<int> id,
  required String bookToken,
  required int bookOrder,
});
typedef $CanonicalBooksUpdateCompanionBuilder = CanonicalBooksCompanion
    Function({
  Value<int> id,
  Value<String> bookToken,
  Value<int> bookOrder,
});

class $CanonicalBooksFilterComposer extends Composer<_$AppDb, CanonicalBooks> {
  $CanonicalBooksFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookToken => $composableBuilder(
      column: $table.bookToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookOrder => $composableBuilder(
      column: $table.bookOrder, builder: (column) => ColumnFilters(column));
}

class $CanonicalBooksOrderingComposer
    extends Composer<_$AppDb, CanonicalBooks> {
  $CanonicalBooksOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookToken => $composableBuilder(
      column: $table.bookToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookOrder => $composableBuilder(
      column: $table.bookOrder, builder: (column) => ColumnOrderings(column));
}

class $CanonicalBooksAnnotationComposer
    extends Composer<_$AppDb, CanonicalBooks> {
  $CanonicalBooksAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bookToken =>
      $composableBuilder(column: $table.bookToken, builder: (column) => column);

  GeneratedColumn<int> get bookOrder =>
      $composableBuilder(column: $table.bookOrder, builder: (column) => column);
}

class $CanonicalBooksTableManager extends RootTableManager<
    _$AppDb,
    CanonicalBooks,
    CanonicalBook,
    $CanonicalBooksFilterComposer,
    $CanonicalBooksOrderingComposer,
    $CanonicalBooksAnnotationComposer,
    $CanonicalBooksCreateCompanionBuilder,
    $CanonicalBooksUpdateCompanionBuilder,
    (CanonicalBook, BaseReferences<_$AppDb, CanonicalBooks, CanonicalBook>),
    CanonicalBook,
    PrefetchHooks Function()> {
  $CanonicalBooksTableManager(_$AppDb db, CanonicalBooks table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CanonicalBooksFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CanonicalBooksOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CanonicalBooksAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bookToken = const Value.absent(),
            Value<int> bookOrder = const Value.absent(),
          }) =>
              CanonicalBooksCompanion(
            id: id,
            bookToken: bookToken,
            bookOrder: bookOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bookToken,
            required int bookOrder,
          }) =>
              CanonicalBooksCompanion.insert(
            id: id,
            bookToken: bookToken,
            bookOrder: bookOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $CanonicalBooksProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    CanonicalBooks,
    CanonicalBook,
    $CanonicalBooksFilterComposer,
    $CanonicalBooksOrderingComposer,
    $CanonicalBooksAnnotationComposer,
    $CanonicalBooksCreateCompanionBuilder,
    $CanonicalBooksUpdateCompanionBuilder,
    (CanonicalBook, BaseReferences<_$AppDb, CanonicalBooks, CanonicalBook>),
    CanonicalBook,
    PrefetchHooks Function()>;
typedef $BiblesCreateCompanionBuilder = BiblesCompanion Function({
  Value<int> id,
  required String extId,
  required int languageId,
  required String bName,
  Value<String?> nameLocal,
  required String abbreviation,
  Value<String?> originSource,
  Value<String?> originFormat,
  Value<String?> bDescription,
  Value<String?> copyright,
});
typedef $BiblesUpdateCompanionBuilder = BiblesCompanion Function({
  Value<int> id,
  Value<String> extId,
  Value<int> languageId,
  Value<String> bName,
  Value<String?> nameLocal,
  Value<String> abbreviation,
  Value<String?> originSource,
  Value<String?> originFormat,
  Value<String?> bDescription,
  Value<String?> copyright,
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

  ColumnFilters<String> get extId => $composableBuilder(
      column: $table.extId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bName => $composableBuilder(
      column: $table.bName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameLocal => $composableBuilder(
      column: $table.nameLocal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originSource => $composableBuilder(
      column: $table.originSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originFormat => $composableBuilder(
      column: $table.originFormat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bDescription => $composableBuilder(
      column: $table.bDescription, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get copyright => $composableBuilder(
      column: $table.copyright, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get extId => $composableBuilder(
      column: $table.extId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bName => $composableBuilder(
      column: $table.bName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameLocal => $composableBuilder(
      column: $table.nameLocal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originSource => $composableBuilder(
      column: $table.originSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originFormat => $composableBuilder(
      column: $table.originFormat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bDescription => $composableBuilder(
      column: $table.bDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get copyright => $composableBuilder(
      column: $table.copyright, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get extId =>
      $composableBuilder(column: $table.extId, builder: (column) => column);

  GeneratedColumn<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => column);

  GeneratedColumn<String> get bName =>
      $composableBuilder(column: $table.bName, builder: (column) => column);

  GeneratedColumn<String> get nameLocal =>
      $composableBuilder(column: $table.nameLocal, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => column);

  GeneratedColumn<String> get originSource => $composableBuilder(
      column: $table.originSource, builder: (column) => column);

  GeneratedColumn<String> get originFormat => $composableBuilder(
      column: $table.originFormat, builder: (column) => column);

  GeneratedColumn<String> get bDescription => $composableBuilder(
      column: $table.bDescription, builder: (column) => column);

  GeneratedColumn<String> get copyright =>
      $composableBuilder(column: $table.copyright, builder: (column) => column);
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
            Value<String> extId = const Value.absent(),
            Value<int> languageId = const Value.absent(),
            Value<String> bName = const Value.absent(),
            Value<String?> nameLocal = const Value.absent(),
            Value<String> abbreviation = const Value.absent(),
            Value<String?> originSource = const Value.absent(),
            Value<String?> originFormat = const Value.absent(),
            Value<String?> bDescription = const Value.absent(),
            Value<String?> copyright = const Value.absent(),
          }) =>
              BiblesCompanion(
            id: id,
            extId: extId,
            languageId: languageId,
            bName: bName,
            nameLocal: nameLocal,
            abbreviation: abbreviation,
            originSource: originSource,
            originFormat: originFormat,
            bDescription: bDescription,
            copyright: copyright,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String extId,
            required int languageId,
            required String bName,
            Value<String?> nameLocal = const Value.absent(),
            required String abbreviation,
            Value<String?> originSource = const Value.absent(),
            Value<String?> originFormat = const Value.absent(),
            Value<String?> bDescription = const Value.absent(),
            Value<String?> copyright = const Value.absent(),
          }) =>
              BiblesCompanion.insert(
            id: id,
            extId: extId,
            languageId: languageId,
            bName: bName,
            nameLocal: nameLocal,
            abbreviation: abbreviation,
            originSource: originSource,
            originFormat: originFormat,
            bDescription: bDescription,
            copyright: copyright,
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
typedef $LocalizedBookNamesCreateCompanionBuilder = LocalizedBookNamesCompanion
    Function({
  required int bibleId,
  required int bookId,
  required String longName,
  required String shortName,
  Value<String?> abbr,
  Value<String?> aliases,
});
typedef $LocalizedBookNamesUpdateCompanionBuilder = LocalizedBookNamesCompanion
    Function({
  Value<int> bibleId,
  Value<int> bookId,
  Value<String> longName,
  Value<String> shortName,
  Value<String?> abbr,
  Value<String?> aliases,
});

class $LocalizedBookNamesFilterComposer
    extends Composer<_$AppDb, LocalizedBookNames> {
  $LocalizedBookNamesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get longName => $composableBuilder(
      column: $table.longName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abbr => $composableBuilder(
      column: $table.abbr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aliases => $composableBuilder(
      column: $table.aliases, builder: (column) => ColumnFilters(column));
}

class $LocalizedBookNamesOrderingComposer
    extends Composer<_$AppDb, LocalizedBookNames> {
  $LocalizedBookNamesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get longName => $composableBuilder(
      column: $table.longName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abbr => $composableBuilder(
      column: $table.abbr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aliases => $composableBuilder(
      column: $table.aliases, builder: (column) => ColumnOrderings(column));
}

class $LocalizedBookNamesAnnotationComposer
    extends Composer<_$AppDb, LocalizedBookNames> {
  $LocalizedBookNamesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get bibleId =>
      $composableBuilder(column: $table.bibleId, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get longName =>
      $composableBuilder(column: $table.longName, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  GeneratedColumn<String> get abbr =>
      $composableBuilder(column: $table.abbr, builder: (column) => column);

  GeneratedColumn<String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);
}

class $LocalizedBookNamesTableManager extends RootTableManager<
    _$AppDb,
    LocalizedBookNames,
    LocalizedBookName,
    $LocalizedBookNamesFilterComposer,
    $LocalizedBookNamesOrderingComposer,
    $LocalizedBookNamesAnnotationComposer,
    $LocalizedBookNamesCreateCompanionBuilder,
    $LocalizedBookNamesUpdateCompanionBuilder,
    (
      LocalizedBookName,
      BaseReferences<_$AppDb, LocalizedBookNames, LocalizedBookName>
    ),
    LocalizedBookName,
    PrefetchHooks Function()> {
  $LocalizedBookNamesTableManager(_$AppDb db, LocalizedBookNames table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $LocalizedBookNamesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $LocalizedBookNamesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $LocalizedBookNamesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> bibleId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<String> longName = const Value.absent(),
            Value<String> shortName = const Value.absent(),
            Value<String?> abbr = const Value.absent(),
            Value<String?> aliases = const Value.absent(),
          }) =>
              LocalizedBookNamesCompanion(
            bibleId: bibleId,
            bookId: bookId,
            longName: longName,
            shortName: shortName,
            abbr: abbr,
            aliases: aliases,
          ),
          createCompanionCallback: ({
            required int bibleId,
            required int bookId,
            required String longName,
            required String shortName,
            Value<String?> abbr = const Value.absent(),
            Value<String?> aliases = const Value.absent(),
          }) =>
              LocalizedBookNamesCompanion.insert(
            bibleId: bibleId,
            bookId: bookId,
            longName: longName,
            shortName: shortName,
            abbr: abbr,
            aliases: aliases,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $LocalizedBookNamesProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    LocalizedBookNames,
    LocalizedBookName,
    $LocalizedBookNamesFilterComposer,
    $LocalizedBookNamesOrderingComposer,
    $LocalizedBookNamesAnnotationComposer,
    $LocalizedBookNamesCreateCompanionBuilder,
    $LocalizedBookNamesUpdateCompanionBuilder,
    (
      LocalizedBookName,
      BaseReferences<_$AppDb, LocalizedBookNames, LocalizedBookName>
    ),
    LocalizedBookName,
    PrefetchHooks Function()>;
typedef $VerseSegmentsCreateCompanionBuilder = VerseSegmentsCompanion Function({
  required int bibleId,
  required int bookId,
  required int chapterNumber,
  required int verseNumber,
  required int segmentIndex,
  Value<int> paragraphStart,
  Value<String?> heading,
  required String spansJson,
});
typedef $VerseSegmentsUpdateCompanionBuilder = VerseSegmentsCompanion Function({
  Value<int> bibleId,
  Value<int> bookId,
  Value<int> chapterNumber,
  Value<int> verseNumber,
  Value<int> segmentIndex,
  Value<int> paragraphStart,
  Value<String?> heading,
  Value<String> spansJson,
});

class $VerseSegmentsFilterComposer extends Composer<_$AppDb, VerseSegments> {
  $VerseSegmentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<String> get heading => $composableBuilder(
      column: $table.heading, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spansJson => $composableBuilder(
      column: $table.spansJson, builder: (column) => ColumnFilters(column));
}

class $VerseSegmentsOrderingComposer extends Composer<_$AppDb, VerseSegments> {
  $VerseSegmentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get bibleId => $composableBuilder(
      column: $table.bibleId, builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<String> get heading => $composableBuilder(
      column: $table.heading, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spansJson => $composableBuilder(
      column: $table.spansJson, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<int> get bibleId =>
      $composableBuilder(column: $table.bibleId, builder: (column) => column);

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

  GeneratedColumn<String> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  GeneratedColumn<String> get spansJson =>
      $composableBuilder(column: $table.spansJson, builder: (column) => column);
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
            Value<int> bibleId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> chapterNumber = const Value.absent(),
            Value<int> verseNumber = const Value.absent(),
            Value<int> segmentIndex = const Value.absent(),
            Value<int> paragraphStart = const Value.absent(),
            Value<String?> heading = const Value.absent(),
            Value<String> spansJson = const Value.absent(),
          }) =>
              VerseSegmentsCompanion(
            bibleId: bibleId,
            bookId: bookId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            segmentIndex: segmentIndex,
            paragraphStart: paragraphStart,
            heading: heading,
            spansJson: spansJson,
          ),
          createCompanionCallback: ({
            required int bibleId,
            required int bookId,
            required int chapterNumber,
            required int verseNumber,
            required int segmentIndex,
            Value<int> paragraphStart = const Value.absent(),
            Value<String?> heading = const Value.absent(),
            required String spansJson,
          }) =>
              VerseSegmentsCompanion.insert(
            bibleId: bibleId,
            bookId: bookId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            segmentIndex: segmentIndex,
            paragraphStart: paragraphStart,
            heading: heading,
            spansJson: spansJson,
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

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $LanguagesTableManager get languages =>
      $LanguagesTableManager(_db, _db.languages);
  $CanonicalBooksTableManager get canonicalBooks =>
      $CanonicalBooksTableManager(_db, _db.canonicalBooks);
  $BiblesTableManager get bibles => $BiblesTableManager(_db, _db.bibles);
  $LocalizedBookNamesTableManager get localizedBookNames =>
      $LocalizedBookNamesTableManager(_db, _db.localizedBookNames);
  $VerseSegmentsTableManager get verseSegments =>
      $VerseSegmentsTableManager(_db, _db.verseSegments);
}

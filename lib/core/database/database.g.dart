// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _bibleNameAbbreviationMeta =
      const VerificationMeta('bibleNameAbbreviation');
  late final GeneratedColumn<String> bibleNameAbbreviation =
      GeneratedColumn<String>('bibleNameAbbreviation', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          $customConstraints: 'NOT NULL');
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
  static const VerificationMeta _langAbbreviationMeta =
      const VerificationMeta('langAbbreviation');
  late final GeneratedColumn<String> langAbbreviation = GeneratedColumn<String>(
      'langAbbreviation', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        languageId,
        bibleName,
        bibleNameAbbreviation,
        langEngName,
        langNativeName,
        langAbbreviation
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
    if (data.containsKey('bibleNameAbbreviation')) {
      context.handle(
          _bibleNameAbbreviationMeta,
          bibleNameAbbreviation.isAcceptableOrUnknown(
              data['bibleNameAbbreviation']!, _bibleNameAbbreviationMeta));
    } else if (isInserting) {
      context.missing(_bibleNameAbbreviationMeta);
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
    if (data.containsKey('langAbbreviation')) {
      context.handle(
          _langAbbreviationMeta,
          langAbbreviation.isAcceptableOrUnknown(
              data['langAbbreviation']!, _langAbbreviationMeta));
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
      languageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}languageId']),
      bibleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bibleName'])!,
      bibleNameAbbreviation: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}bibleNameAbbreviation'])!,
      langEngName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}langEngName'])!,
      langNativeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}langNativeName']),
      langAbbreviation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}langAbbreviation']),
    );
  }

  @override
  Bibles createAlias(String alias) {
    return Bibles(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Bible extends DataClass implements Insertable<Bible> {
  final int id;
  final int? languageId;
  final String bibleName;
  final String bibleNameAbbreviation;

  /// language specifications
  final String langEngName;
  final String? langNativeName;
  final String? langAbbreviation;
  const Bible(
      {required this.id,
      this.languageId,
      required this.bibleName,
      required this.bibleNameAbbreviation,
      required this.langEngName,
      this.langNativeName,
      this.langAbbreviation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || languageId != null) {
      map['languageId'] = Variable<int>(languageId);
    }
    map['bibleName'] = Variable<String>(bibleName);
    map['bibleNameAbbreviation'] = Variable<String>(bibleNameAbbreviation);
    map['langEngName'] = Variable<String>(langEngName);
    if (!nullToAbsent || langNativeName != null) {
      map['langNativeName'] = Variable<String>(langNativeName);
    }
    if (!nullToAbsent || langAbbreviation != null) {
      map['langAbbreviation'] = Variable<String>(langAbbreviation);
    }
    return map;
  }

  BiblesCompanion toCompanion(bool nullToAbsent) {
    return BiblesCompanion(
      id: Value(id),
      languageId: languageId == null && nullToAbsent
          ? const Value.absent()
          : Value(languageId),
      bibleName: Value(bibleName),
      bibleNameAbbreviation: Value(bibleNameAbbreviation),
      langEngName: Value(langEngName),
      langNativeName: langNativeName == null && nullToAbsent
          ? const Value.absent()
          : Value(langNativeName),
      langAbbreviation: langAbbreviation == null && nullToAbsent
          ? const Value.absent()
          : Value(langAbbreviation),
    );
  }

  factory Bible.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bible(
      id: serializer.fromJson<int>(json['id']),
      languageId: serializer.fromJson<int?>(json['languageId']),
      bibleName: serializer.fromJson<String>(json['bibleName']),
      bibleNameAbbreviation:
          serializer.fromJson<String>(json['bibleNameAbbreviation']),
      langEngName: serializer.fromJson<String>(json['langEngName']),
      langNativeName: serializer.fromJson<String?>(json['langNativeName']),
      langAbbreviation: serializer.fromJson<String?>(json['langAbbreviation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'languageId': serializer.toJson<int?>(languageId),
      'bibleName': serializer.toJson<String>(bibleName),
      'bibleNameAbbreviation': serializer.toJson<String>(bibleNameAbbreviation),
      'langEngName': serializer.toJson<String>(langEngName),
      'langNativeName': serializer.toJson<String?>(langNativeName),
      'langAbbreviation': serializer.toJson<String?>(langAbbreviation),
    };
  }

  Bible copyWith(
          {int? id,
          Value<int?> languageId = const Value.absent(),
          String? bibleName,
          String? bibleNameAbbreviation,
          String? langEngName,
          Value<String?> langNativeName = const Value.absent(),
          Value<String?> langAbbreviation = const Value.absent()}) =>
      Bible(
        id: id ?? this.id,
        languageId: languageId.present ? languageId.value : this.languageId,
        bibleName: bibleName ?? this.bibleName,
        bibleNameAbbreviation:
            bibleNameAbbreviation ?? this.bibleNameAbbreviation,
        langEngName: langEngName ?? this.langEngName,
        langNativeName:
            langNativeName.present ? langNativeName.value : this.langNativeName,
        langAbbreviation: langAbbreviation.present
            ? langAbbreviation.value
            : this.langAbbreviation,
      );
  Bible copyWithCompanion(BiblesCompanion data) {
    return Bible(
      id: data.id.present ? data.id.value : this.id,
      languageId:
          data.languageId.present ? data.languageId.value : this.languageId,
      bibleName: data.bibleName.present ? data.bibleName.value : this.bibleName,
      bibleNameAbbreviation: data.bibleNameAbbreviation.present
          ? data.bibleNameAbbreviation.value
          : this.bibleNameAbbreviation,
      langEngName:
          data.langEngName.present ? data.langEngName.value : this.langEngName,
      langNativeName: data.langNativeName.present
          ? data.langNativeName.value
          : this.langNativeName,
      langAbbreviation: data.langAbbreviation.present
          ? data.langAbbreviation.value
          : this.langAbbreviation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bible(')
          ..write('id: $id, ')
          ..write('languageId: $languageId, ')
          ..write('bibleName: $bibleName, ')
          ..write('bibleNameAbbreviation: $bibleNameAbbreviation, ')
          ..write('langEngName: $langEngName, ')
          ..write('langNativeName: $langNativeName, ')
          ..write('langAbbreviation: $langAbbreviation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, languageId, bibleName,
      bibleNameAbbreviation, langEngName, langNativeName, langAbbreviation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bible &&
          other.id == this.id &&
          other.languageId == this.languageId &&
          other.bibleName == this.bibleName &&
          other.bibleNameAbbreviation == this.bibleNameAbbreviation &&
          other.langEngName == this.langEngName &&
          other.langNativeName == this.langNativeName &&
          other.langAbbreviation == this.langAbbreviation);
}

class BiblesCompanion extends UpdateCompanion<Bible> {
  final Value<int> id;
  final Value<int?> languageId;
  final Value<String> bibleName;
  final Value<String> bibleNameAbbreviation;
  final Value<String> langEngName;
  final Value<String?> langNativeName;
  final Value<String?> langAbbreviation;
  const BiblesCompanion({
    this.id = const Value.absent(),
    this.languageId = const Value.absent(),
    this.bibleName = const Value.absent(),
    this.bibleNameAbbreviation = const Value.absent(),
    this.langEngName = const Value.absent(),
    this.langNativeName = const Value.absent(),
    this.langAbbreviation = const Value.absent(),
  });
  BiblesCompanion.insert({
    this.id = const Value.absent(),
    this.languageId = const Value.absent(),
    required String bibleName,
    required String bibleNameAbbreviation,
    required String langEngName,
    this.langNativeName = const Value.absent(),
    this.langAbbreviation = const Value.absent(),
  })  : bibleName = Value(bibleName),
        bibleNameAbbreviation = Value(bibleNameAbbreviation),
        langEngName = Value(langEngName);
  static Insertable<Bible> custom({
    Expression<int>? id,
    Expression<int>? languageId,
    Expression<String>? bibleName,
    Expression<String>? bibleNameAbbreviation,
    Expression<String>? langEngName,
    Expression<String>? langNativeName,
    Expression<String>? langAbbreviation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (languageId != null) 'languageId': languageId,
      if (bibleName != null) 'bibleName': bibleName,
      if (bibleNameAbbreviation != null)
        'bibleNameAbbreviation': bibleNameAbbreviation,
      if (langEngName != null) 'langEngName': langEngName,
      if (langNativeName != null) 'langNativeName': langNativeName,
      if (langAbbreviation != null) 'langAbbreviation': langAbbreviation,
    });
  }

  BiblesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? languageId,
      Value<String>? bibleName,
      Value<String>? bibleNameAbbreviation,
      Value<String>? langEngName,
      Value<String?>? langNativeName,
      Value<String?>? langAbbreviation}) {
    return BiblesCompanion(
      id: id ?? this.id,
      languageId: languageId ?? this.languageId,
      bibleName: bibleName ?? this.bibleName,
      bibleNameAbbreviation:
          bibleNameAbbreviation ?? this.bibleNameAbbreviation,
      langEngName: langEngName ?? this.langEngName,
      langNativeName: langNativeName ?? this.langNativeName,
      langAbbreviation: langAbbreviation ?? this.langAbbreviation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (languageId.present) {
      map['languageId'] = Variable<int>(languageId.value);
    }
    if (bibleName.present) {
      map['bibleName'] = Variable<String>(bibleName.value);
    }
    if (bibleNameAbbreviation.present) {
      map['bibleNameAbbreviation'] =
          Variable<String>(bibleNameAbbreviation.value);
    }
    if (langEngName.present) {
      map['langEngName'] = Variable<String>(langEngName.value);
    }
    if (langNativeName.present) {
      map['langNativeName'] = Variable<String>(langNativeName.value);
    }
    if (langAbbreviation.present) {
      map['langAbbreviation'] = Variable<String>(langAbbreviation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BiblesCompanion(')
          ..write('id: $id, ')
          ..write('languageId: $languageId, ')
          ..write('bibleName: $bibleName, ')
          ..write('bibleNameAbbreviation: $bibleNameAbbreviation, ')
          ..write('langEngName: $langEngName, ')
          ..write('langNativeName: $langNativeName, ')
          ..write('langAbbreviation: $langAbbreviation')
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
      [id, bibleId, bookOrder, longName, shortName];
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
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bibleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bibleId'])!,
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
  List<String> get customConstraints =>
      const ['FOREIGN KEY(bibleId)REFERENCES bibles(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final int bibleId;
  final int? bookOrder;
  final String? longName;
  final String shortName;
  const Book(
      {required this.id,
      required this.bibleId,
      this.bookOrder,
      this.longName,
      required this.shortName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bibleId'] = Variable<int>(bibleId);
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
      'bookOrder': serializer.toJson<int?>(bookOrder),
      'longName': serializer.toJson<String?>(longName),
      'shortName': serializer.toJson<String>(shortName),
    };
  }

  Book copyWith(
          {int? id,
          int? bibleId,
          Value<int?> bookOrder = const Value.absent(),
          Value<String?> longName = const Value.absent(),
          String? shortName}) =>
      Book(
        id: id ?? this.id,
        bibleId: bibleId ?? this.bibleId,
        bookOrder: bookOrder.present ? bookOrder.value : this.bookOrder,
        longName: longName.present ? longName.value : this.longName,
        shortName: shortName ?? this.shortName,
      );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      bibleId: data.bibleId.present ? data.bibleId.value : this.bibleId,
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
          ..write('bookOrder: $bookOrder, ')
          ..write('longName: $longName, ')
          ..write('shortName: $shortName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bibleId, bookOrder, longName, shortName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.bibleId == this.bibleId &&
          other.bookOrder == this.bookOrder &&
          other.longName == this.longName &&
          other.shortName == this.shortName);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<int> bibleId;
  final Value<int?> bookOrder;
  final Value<String?> longName;
  final Value<String> shortName;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.bibleId = const Value.absent(),
    this.bookOrder = const Value.absent(),
    this.longName = const Value.absent(),
    this.shortName = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required int bibleId,
    this.bookOrder = const Value.absent(),
    this.longName = const Value.absent(),
    required String shortName,
  })  : bibleId = Value(bibleId),
        shortName = Value(shortName);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<int>? bibleId,
    Expression<int>? bookOrder,
    Expression<String>? longName,
    Expression<String>? shortName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bibleId != null) 'bibleId': bibleId,
      if (bookOrder != null) 'bookOrder': bookOrder,
      if (longName != null) 'longName': longName,
      if (shortName != null) 'shortName': shortName,
    });
  }

  BooksCompanion copyWith(
      {Value<int>? id,
      Value<int>? bibleId,
      Value<int?>? bookOrder,
      Value<String?>? longName,
      Value<String>? shortName}) {
    return BooksCompanion(
      id: id ?? this.id,
      bibleId: bibleId ?? this.bibleId,
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
          ..write('bookOrder: $bookOrder, ')
          ..write('longName: $longName, ')
          ..write('shortName: $shortName')
          ..write(')'))
        .toString();
  }
}

class Paragraphs extends Table with TableInfo<Paragraphs, Paragraph> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Paragraphs(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _subtitleMeta =
      const VerificationMeta('subtitle');
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
      'subtitle', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _chapterNumberMeta =
      const VerificationMeta('chapterNumber');
  late final GeneratedColumn<int> chapterNumber = GeneratedColumn<int>(
      'chapterNumber', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _startVerseMeta =
      const VerificationMeta('startVerse');
  late final GeneratedColumn<int> startVerse = GeneratedColumn<int>(
      'startVerse', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _endVerseMeta =
      const VerificationMeta('endVerse');
  late final GeneratedColumn<int> endVerse = GeneratedColumn<int>(
      'endVerse', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookId, subtitle, chapterNumber, startVerse, endVerse];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paragraphs';
  @override
  VerificationContext validateIntegrity(Insertable<Paragraph> instance,
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
    if (data.containsKey('subtitle')) {
      context.handle(_subtitleMeta,
          subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta));
    }
    if (data.containsKey('chapterNumber')) {
      context.handle(
          _chapterNumberMeta,
          chapterNumber.isAcceptableOrUnknown(
              data['chapterNumber']!, _chapterNumberMeta));
    } else if (isInserting) {
      context.missing(_chapterNumberMeta);
    }
    if (data.containsKey('startVerse')) {
      context.handle(
          _startVerseMeta,
          startVerse.isAcceptableOrUnknown(
              data['startVerse']!, _startVerseMeta));
    } else if (isInserting) {
      context.missing(_startVerseMeta);
    }
    if (data.containsKey('endVerse')) {
      context.handle(_endVerseMeta,
          endVerse.isAcceptableOrUnknown(data['endVerse']!, _endVerseMeta));
    } else if (isInserting) {
      context.missing(_endVerseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Paragraph map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paragraph(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookId'])!,
      subtitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtitle']),
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapterNumber'])!,
      startVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}startVerse'])!,
      endVerse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}endVerse'])!,
    );
  }

  @override
  Paragraphs createAlias(String alias) {
    return Paragraphs(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['FOREIGN KEY(bookId)REFERENCES books(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class Paragraph extends DataClass implements Insertable<Paragraph> {
  final int id;
  final int bookId;
  final String? subtitle;
  final int chapterNumber;
  final int startVerse;
  final int endVerse;
  const Paragraph(
      {required this.id,
      required this.bookId,
      this.subtitle,
      required this.chapterNumber,
      required this.startVerse,
      required this.endVerse});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bookId'] = Variable<int>(bookId);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    map['chapterNumber'] = Variable<int>(chapterNumber);
    map['startVerse'] = Variable<int>(startVerse);
    map['endVerse'] = Variable<int>(endVerse);
    return map;
  }

  ParagraphsCompanion toCompanion(bool nullToAbsent) {
    return ParagraphsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      chapterNumber: Value(chapterNumber),
      startVerse: Value(startVerse),
      endVerse: Value(endVerse),
    );
  }

  factory Paragraph.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paragraph(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      chapterNumber: serializer.fromJson<int>(json['chapterNumber']),
      startVerse: serializer.fromJson<int>(json['startVerse']),
      endVerse: serializer.fromJson<int>(json['endVerse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'subtitle': serializer.toJson<String?>(subtitle),
      'chapterNumber': serializer.toJson<int>(chapterNumber),
      'startVerse': serializer.toJson<int>(startVerse),
      'endVerse': serializer.toJson<int>(endVerse),
    };
  }

  Paragraph copyWith(
          {int? id,
          int? bookId,
          Value<String?> subtitle = const Value.absent(),
          int? chapterNumber,
          int? startVerse,
          int? endVerse}) =>
      Paragraph(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        subtitle: subtitle.present ? subtitle.value : this.subtitle,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        startVerse: startVerse ?? this.startVerse,
        endVerse: endVerse ?? this.endVerse,
      );
  Paragraph copyWithCompanion(ParagraphsCompanion data) {
    return Paragraph(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      startVerse:
          data.startVerse.present ? data.startVerse.value : this.startVerse,
      endVerse: data.endVerse.present ? data.endVerse.value : this.endVerse,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paragraph(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('subtitle: $subtitle, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('startVerse: $startVerse, ')
          ..write('endVerse: $endVerse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, subtitle, chapterNumber, startVerse, endVerse);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paragraph &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.subtitle == this.subtitle &&
          other.chapterNumber == this.chapterNumber &&
          other.startVerse == this.startVerse &&
          other.endVerse == this.endVerse);
}

class ParagraphsCompanion extends UpdateCompanion<Paragraph> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<String?> subtitle;
  final Value<int> chapterNumber;
  final Value<int> startVerse;
  final Value<int> endVerse;
  const ParagraphsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.startVerse = const Value.absent(),
    this.endVerse = const Value.absent(),
  });
  ParagraphsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    this.subtitle = const Value.absent(),
    required int chapterNumber,
    required int startVerse,
    required int endVerse,
  })  : bookId = Value(bookId),
        chapterNumber = Value(chapterNumber),
        startVerse = Value(startVerse),
        endVerse = Value(endVerse);
  static Insertable<Paragraph> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<String>? subtitle,
    Expression<int>? chapterNumber,
    Expression<int>? startVerse,
    Expression<int>? endVerse,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'bookId': bookId,
      if (subtitle != null) 'subtitle': subtitle,
      if (chapterNumber != null) 'chapterNumber': chapterNumber,
      if (startVerse != null) 'startVerse': startVerse,
      if (endVerse != null) 'endVerse': endVerse,
    });
  }

  ParagraphsCompanion copyWith(
      {Value<int>? id,
      Value<int>? bookId,
      Value<String?>? subtitle,
      Value<int>? chapterNumber,
      Value<int>? startVerse,
      Value<int>? endVerse}) {
    return ParagraphsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      subtitle: subtitle ?? this.subtitle,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      startVerse: startVerse ?? this.startVerse,
      endVerse: endVerse ?? this.endVerse,
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
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (chapterNumber.present) {
      map['chapterNumber'] = Variable<int>(chapterNumber.value);
    }
    if (startVerse.present) {
      map['startVerse'] = Variable<int>(startVerse.value);
    }
    if (endVerse.present) {
      map['endVerse'] = Variable<int>(endVerse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParagraphsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('subtitle: $subtitle, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('startVerse: $startVerse, ')
          ..write('endVerse: $endVerse')
          ..write(')'))
        .toString();
  }
}

class Verses extends Table with TableInfo<Verses, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Verses(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _paragraphIdMeta =
      const VerificationMeta('paragraphId');
  late final GeneratedColumn<int> paragraphId = GeneratedColumn<int>(
      'paragraphId', aliasedName, false,
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
  static const VerificationMeta _verseTextMeta =
      const VerificationMeta('verseText');
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
      'verseText', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookId, paragraphId, chapterNumber, verseNumber, verseText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(Insertable<Verse> instance,
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
    if (data.containsKey('paragraphId')) {
      context.handle(
          _paragraphIdMeta,
          paragraphId.isAcceptableOrUnknown(
              data['paragraphId']!, _paragraphIdMeta));
    } else if (isInserting) {
      context.missing(_paragraphIdMeta);
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
    if (data.containsKey('verseText')) {
      context.handle(_verseTextMeta,
          verseText.isAcceptableOrUnknown(data['verseText']!, _verseTextMeta));
    } else if (isInserting) {
      context.missing(_verseTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookId'])!,
      paragraphId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paragraphId'])!,
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapterNumber'])!,
      verseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verseNumber'])!,
      verseText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verseText'])!,
    );
  }

  @override
  Verses createAlias(String alias) {
    return Verses(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY(paragraphId)REFERENCES paragraphs(id)',
        'FOREIGN KEY(bookId)REFERENCES books(id)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class Verse extends DataClass implements Insertable<Verse> {
  final int id;
  final int bookId;
  final int paragraphId;
  final int chapterNumber;
  final int verseNumber;
  final String verseText;
  const Verse(
      {required this.id,
      required this.bookId,
      required this.paragraphId,
      required this.chapterNumber,
      required this.verseNumber,
      required this.verseText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bookId'] = Variable<int>(bookId);
    map['paragraphId'] = Variable<int>(paragraphId);
    map['chapterNumber'] = Variable<int>(chapterNumber);
    map['verseNumber'] = Variable<int>(verseNumber);
    map['verseText'] = Variable<String>(verseText);
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      paragraphId: Value(paragraphId),
      chapterNumber: Value(chapterNumber),
      verseNumber: Value(verseNumber),
      verseText: Value(verseText),
    );
  }

  factory Verse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      paragraphId: serializer.fromJson<int>(json['paragraphId']),
      chapterNumber: serializer.fromJson<int>(json['chapterNumber']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      verseText: serializer.fromJson<String>(json['verseText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'paragraphId': serializer.toJson<int>(paragraphId),
      'chapterNumber': serializer.toJson<int>(chapterNumber),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'verseText': serializer.toJson<String>(verseText),
    };
  }

  Verse copyWith(
          {int? id,
          int? bookId,
          int? paragraphId,
          int? chapterNumber,
          int? verseNumber,
          String? verseText}) =>
      Verse(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        paragraphId: paragraphId ?? this.paragraphId,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        verseNumber: verseNumber ?? this.verseNumber,
        verseText: verseText ?? this.verseText,
      );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      paragraphId:
          data.paragraphId.present ? data.paragraphId.value : this.paragraphId,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      verseNumber:
          data.verseNumber.present ? data.verseNumber.value : this.verseNumber,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('paragraphId: $paragraphId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('verseText: $verseText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bookId, paragraphId, chapterNumber, verseNumber, verseText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.paragraphId == this.paragraphId &&
          other.chapterNumber == this.chapterNumber &&
          other.verseNumber == this.verseNumber &&
          other.verseText == this.verseText);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<int> paragraphId;
  final Value<int> chapterNumber;
  final Value<int> verseNumber;
  final Value<String> verseText;
  const VersesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.paragraphId = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.verseText = const Value.absent(),
  });
  VersesCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required int paragraphId,
    required int chapterNumber,
    required int verseNumber,
    required String verseText,
  })  : bookId = Value(bookId),
        paragraphId = Value(paragraphId),
        chapterNumber = Value(chapterNumber),
        verseNumber = Value(verseNumber),
        verseText = Value(verseText);
  static Insertable<Verse> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<int>? paragraphId,
    Expression<int>? chapterNumber,
    Expression<int>? verseNumber,
    Expression<String>? verseText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'bookId': bookId,
      if (paragraphId != null) 'paragraphId': paragraphId,
      if (chapterNumber != null) 'chapterNumber': chapterNumber,
      if (verseNumber != null) 'verseNumber': verseNumber,
      if (verseText != null) 'verseText': verseText,
    });
  }

  VersesCompanion copyWith(
      {Value<int>? id,
      Value<int>? bookId,
      Value<int>? paragraphId,
      Value<int>? chapterNumber,
      Value<int>? verseNumber,
      Value<String>? verseText}) {
    return VersesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      paragraphId: paragraphId ?? this.paragraphId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      verseText: verseText ?? this.verseText,
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
    if (paragraphId.present) {
      map['paragraphId'] = Variable<int>(paragraphId.value);
    }
    if (chapterNumber.present) {
      map['chapterNumber'] = Variable<int>(chapterNumber.value);
    }
    if (verseNumber.present) {
      map['verseNumber'] = Variable<int>(verseNumber.value);
    }
    if (verseText.present) {
      map['verseText'] = Variable<String>(verseText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('paragraphId: $paragraphId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('verseText: $verseText')
          ..write(')'))
        .toString();
  }
}

class VerseStyle extends Table with TableInfo<VerseStyle, VerseStyleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VerseStyle(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _verseIdMeta =
      const VerificationMeta('verseId');
  late final GeneratedColumn<int> verseId = GeneratedColumn<int>(
      'verseId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _startIndexMeta =
      const VerificationMeta('startIndex');
  late final GeneratedColumn<int> startIndex = GeneratedColumn<int>(
      'startIndex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _endIndexMeta =
      const VerificationMeta('endIndex');
  late final GeneratedColumn<int> endIndex = GeneratedColumn<int>(
      'endIndex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, verseId, startIndex, endIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_style';
  @override
  VerificationContext validateIntegrity(Insertable<VerseStyleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verseId')) {
      context.handle(_verseIdMeta,
          verseId.isAcceptableOrUnknown(data['verseId']!, _verseIdMeta));
    } else if (isInserting) {
      context.missing(_verseIdMeta);
    }
    if (data.containsKey('startIndex')) {
      context.handle(
          _startIndexMeta,
          startIndex.isAcceptableOrUnknown(
              data['startIndex']!, _startIndexMeta));
    } else if (isInserting) {
      context.missing(_startIndexMeta);
    }
    if (data.containsKey('endIndex')) {
      context.handle(_endIndexMeta,
          endIndex.isAcceptableOrUnknown(data['endIndex']!, _endIndexMeta));
    } else if (isInserting) {
      context.missing(_endIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerseStyleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseStyleData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      verseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verseId'])!,
      startIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}startIndex'])!,
      endIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}endIndex'])!,
    );
  }

  @override
  VerseStyle createAlias(String alias) {
    return VerseStyle(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['FOREIGN KEY(verseId)REFERENCES verses(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class VerseStyleData extends DataClass implements Insertable<VerseStyleData> {
  final int id;
  final int verseId;
  final int startIndex;
  final int endIndex;
  const VerseStyleData(
      {required this.id,
      required this.verseId,
      required this.startIndex,
      required this.endIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['verseId'] = Variable<int>(verseId);
    map['startIndex'] = Variable<int>(startIndex);
    map['endIndex'] = Variable<int>(endIndex);
    return map;
  }

  VerseStyleCompanion toCompanion(bool nullToAbsent) {
    return VerseStyleCompanion(
      id: Value(id),
      verseId: Value(verseId),
      startIndex: Value(startIndex),
      endIndex: Value(endIndex),
    );
  }

  factory VerseStyleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseStyleData(
      id: serializer.fromJson<int>(json['id']),
      verseId: serializer.fromJson<int>(json['verseId']),
      startIndex: serializer.fromJson<int>(json['startIndex']),
      endIndex: serializer.fromJson<int>(json['endIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verseId': serializer.toJson<int>(verseId),
      'startIndex': serializer.toJson<int>(startIndex),
      'endIndex': serializer.toJson<int>(endIndex),
    };
  }

  VerseStyleData copyWith(
          {int? id, int? verseId, int? startIndex, int? endIndex}) =>
      VerseStyleData(
        id: id ?? this.id,
        verseId: verseId ?? this.verseId,
        startIndex: startIndex ?? this.startIndex,
        endIndex: endIndex ?? this.endIndex,
      );
  VerseStyleData copyWithCompanion(VerseStyleCompanion data) {
    return VerseStyleData(
      id: data.id.present ? data.id.value : this.id,
      verseId: data.verseId.present ? data.verseId.value : this.verseId,
      startIndex:
          data.startIndex.present ? data.startIndex.value : this.startIndex,
      endIndex: data.endIndex.present ? data.endIndex.value : this.endIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseStyleData(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('startIndex: $startIndex, ')
          ..write('endIndex: $endIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, verseId, startIndex, endIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseStyleData &&
          other.id == this.id &&
          other.verseId == this.verseId &&
          other.startIndex == this.startIndex &&
          other.endIndex == this.endIndex);
}

class VerseStyleCompanion extends UpdateCompanion<VerseStyleData> {
  final Value<int> id;
  final Value<int> verseId;
  final Value<int> startIndex;
  final Value<int> endIndex;
  const VerseStyleCompanion({
    this.id = const Value.absent(),
    this.verseId = const Value.absent(),
    this.startIndex = const Value.absent(),
    this.endIndex = const Value.absent(),
  });
  VerseStyleCompanion.insert({
    this.id = const Value.absent(),
    required int verseId,
    required int startIndex,
    required int endIndex,
  })  : verseId = Value(verseId),
        startIndex = Value(startIndex),
        endIndex = Value(endIndex);
  static Insertable<VerseStyleData> custom({
    Expression<int>? id,
    Expression<int>? verseId,
    Expression<int>? startIndex,
    Expression<int>? endIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verseId != null) 'verseId': verseId,
      if (startIndex != null) 'startIndex': startIndex,
      if (endIndex != null) 'endIndex': endIndex,
    });
  }

  VerseStyleCompanion copyWith(
      {Value<int>? id,
      Value<int>? verseId,
      Value<int>? startIndex,
      Value<int>? endIndex}) {
    return VerseStyleCompanion(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verseId.present) {
      map['verseId'] = Variable<int>(verseId.value);
    }
    if (startIndex.present) {
      map['startIndex'] = Variable<int>(startIndex.value);
    }
    if (endIndex.present) {
      map['endIndex'] = Variable<int>(endIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseStyleCompanion(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('startIndex: $startIndex, ')
          ..write('endIndex: $endIndex')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final Bibles bibles = Bibles(this);
  late final Books books = Books(this);
  late final Paragraphs paragraphs = Paragraphs(this);
  late final Verses verses = Verses(this);
  late final VerseStyle verseStyle = VerseStyle(this);
  Selectable<GetVersesResult> getVerses(int bookNumber, int bibleId,
      int chapterNumber, int? verseStart, int? verseEnd) {
    return customSelect(
        'SELECT v.chapterNumber, v.verseText, v.verseNumber FROM verses AS v WHERE v.bookId = (SELECT id FROM books WHERE bookOrder = ?1 AND bibleId = ?2) AND v.chapterNumber = ?3 AND(verseNumber >= ?4 OR ?4 IS NULL)AND(verseNumber <= ?5 OR ?5 IS NULL)',
        variables: [
          Variable<int>(bookNumber),
          Variable<int>(bibleId),
          Variable<int>(chapterNumber),
          Variable<int>(verseStart),
          Variable<int>(verseEnd)
        ],
        readsFrom: {
          verses,
          books,
        }).map((QueryRow row) => GetVersesResult(
          chapterNumber: row.read<int>('chapterNumber'),
          verseText: row.read<String>('verseText'),
          verseNumber: row.read<int>('verseNumber'),
        ));
  }

  Selectable<GetBiblesResult> getBibles() {
    return customSelect(
        'SELECT id, languageId, bibleName, bibleNameAbbreviation FROM bibles',
        variables: [],
        readsFrom: {
          bibles,
        }).map((QueryRow row) => GetBiblesResult(
          id: row.read<int>('id'),
          languageId: row.readNullable<int>('languageId'),
          bibleName: row.read<String>('bibleName'),
          bibleNameAbbreviation: row.read<String>('bibleNameAbbreviation'),
        ));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [bibles, books, paragraphs, verses, verseStyle];
}

typedef $BiblesCreateCompanionBuilder = BiblesCompanion Function({
  Value<int> id,
  Value<int?> languageId,
  required String bibleName,
  required String bibleNameAbbreviation,
  required String langEngName,
  Value<String?> langNativeName,
  Value<String?> langAbbreviation,
});
typedef $BiblesUpdateCompanionBuilder = BiblesCompanion Function({
  Value<int> id,
  Value<int?> languageId,
  Value<String> bibleName,
  Value<String> bibleNameAbbreviation,
  Value<String> langEngName,
  Value<String?> langNativeName,
  Value<String?> langAbbreviation,
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

  ColumnFilters<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bibleName => $composableBuilder(
      column: $table.bibleName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bibleNameAbbreviation => $composableBuilder(
      column: $table.bibleNameAbbreviation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langEngName => $composableBuilder(
      column: $table.langEngName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langNativeName => $composableBuilder(
      column: $table.langNativeName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get langAbbreviation => $composableBuilder(
      column: $table.langAbbreviation,
      builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bibleName => $composableBuilder(
      column: $table.bibleName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bibleNameAbbreviation => $composableBuilder(
      column: $table.bibleNameAbbreviation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langEngName => $composableBuilder(
      column: $table.langEngName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langNativeName => $composableBuilder(
      column: $table.langNativeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get langAbbreviation => $composableBuilder(
      column: $table.langAbbreviation,
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

  GeneratedColumn<int> get languageId => $composableBuilder(
      column: $table.languageId, builder: (column) => column);

  GeneratedColumn<String> get bibleName =>
      $composableBuilder(column: $table.bibleName, builder: (column) => column);

  GeneratedColumn<String> get bibleNameAbbreviation => $composableBuilder(
      column: $table.bibleNameAbbreviation, builder: (column) => column);

  GeneratedColumn<String> get langEngName => $composableBuilder(
      column: $table.langEngName, builder: (column) => column);

  GeneratedColumn<String> get langNativeName => $composableBuilder(
      column: $table.langNativeName, builder: (column) => column);

  GeneratedColumn<String> get langAbbreviation => $composableBuilder(
      column: $table.langAbbreviation, builder: (column) => column);
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
            Value<int?> languageId = const Value.absent(),
            Value<String> bibleName = const Value.absent(),
            Value<String> bibleNameAbbreviation = const Value.absent(),
            Value<String> langEngName = const Value.absent(),
            Value<String?> langNativeName = const Value.absent(),
            Value<String?> langAbbreviation = const Value.absent(),
          }) =>
              BiblesCompanion(
            id: id,
            languageId: languageId,
            bibleName: bibleName,
            bibleNameAbbreviation: bibleNameAbbreviation,
            langEngName: langEngName,
            langNativeName: langNativeName,
            langAbbreviation: langAbbreviation,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> languageId = const Value.absent(),
            required String bibleName,
            required String bibleNameAbbreviation,
            required String langEngName,
            Value<String?> langNativeName = const Value.absent(),
            Value<String?> langAbbreviation = const Value.absent(),
          }) =>
              BiblesCompanion.insert(
            id: id,
            languageId: languageId,
            bibleName: bibleName,
            bibleNameAbbreviation: bibleNameAbbreviation,
            langEngName: langEngName,
            langNativeName: langNativeName,
            langAbbreviation: langAbbreviation,
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
  Value<int?> bookOrder,
  Value<String?> longName,
  required String shortName,
});
typedef $BooksUpdateCompanionBuilder = BooksCompanion Function({
  Value<int> id,
  Value<int> bibleId,
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
            Value<int?> bookOrder = const Value.absent(),
            Value<String?> longName = const Value.absent(),
            Value<String> shortName = const Value.absent(),
          }) =>
              BooksCompanion(
            id: id,
            bibleId: bibleId,
            bookOrder: bookOrder,
            longName: longName,
            shortName: shortName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bibleId,
            Value<int?> bookOrder = const Value.absent(),
            Value<String?> longName = const Value.absent(),
            required String shortName,
          }) =>
              BooksCompanion.insert(
            id: id,
            bibleId: bibleId,
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
typedef $ParagraphsCreateCompanionBuilder = ParagraphsCompanion Function({
  Value<int> id,
  required int bookId,
  Value<String?> subtitle,
  required int chapterNumber,
  required int startVerse,
  required int endVerse,
});
typedef $ParagraphsUpdateCompanionBuilder = ParagraphsCompanion Function({
  Value<int> id,
  Value<int> bookId,
  Value<String?> subtitle,
  Value<int> chapterNumber,
  Value<int> startVerse,
  Value<int> endVerse,
});

class $ParagraphsFilterComposer extends Composer<_$AppDb, Paragraphs> {
  $ParagraphsFilterComposer({
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

  ColumnFilters<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startVerse => $composableBuilder(
      column: $table.startVerse, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endVerse => $composableBuilder(
      column: $table.endVerse, builder: (column) => ColumnFilters(column));
}

class $ParagraphsOrderingComposer extends Composer<_$AppDb, Paragraphs> {
  $ParagraphsOrderingComposer({
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

  ColumnOrderings<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startVerse => $composableBuilder(
      column: $table.startVerse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endVerse => $composableBuilder(
      column: $table.endVerse, builder: (column) => ColumnOrderings(column));
}

class $ParagraphsAnnotationComposer extends Composer<_$AppDb, Paragraphs> {
  $ParagraphsAnnotationComposer({
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

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => column);

  GeneratedColumn<int> get startVerse => $composableBuilder(
      column: $table.startVerse, builder: (column) => column);

  GeneratedColumn<int> get endVerse =>
      $composableBuilder(column: $table.endVerse, builder: (column) => column);
}

class $ParagraphsTableManager extends RootTableManager<
    _$AppDb,
    Paragraphs,
    Paragraph,
    $ParagraphsFilterComposer,
    $ParagraphsOrderingComposer,
    $ParagraphsAnnotationComposer,
    $ParagraphsCreateCompanionBuilder,
    $ParagraphsUpdateCompanionBuilder,
    (Paragraph, BaseReferences<_$AppDb, Paragraphs, Paragraph>),
    Paragraph,
    PrefetchHooks Function()> {
  $ParagraphsTableManager(_$AppDb db, Paragraphs table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ParagraphsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ParagraphsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ParagraphsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<String?> subtitle = const Value.absent(),
            Value<int> chapterNumber = const Value.absent(),
            Value<int> startVerse = const Value.absent(),
            Value<int> endVerse = const Value.absent(),
          }) =>
              ParagraphsCompanion(
            id: id,
            bookId: bookId,
            subtitle: subtitle,
            chapterNumber: chapterNumber,
            startVerse: startVerse,
            endVerse: endVerse,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bookId,
            Value<String?> subtitle = const Value.absent(),
            required int chapterNumber,
            required int startVerse,
            required int endVerse,
          }) =>
              ParagraphsCompanion.insert(
            id: id,
            bookId: bookId,
            subtitle: subtitle,
            chapterNumber: chapterNumber,
            startVerse: startVerse,
            endVerse: endVerse,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ParagraphsProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Paragraphs,
    Paragraph,
    $ParagraphsFilterComposer,
    $ParagraphsOrderingComposer,
    $ParagraphsAnnotationComposer,
    $ParagraphsCreateCompanionBuilder,
    $ParagraphsUpdateCompanionBuilder,
    (Paragraph, BaseReferences<_$AppDb, Paragraphs, Paragraph>),
    Paragraph,
    PrefetchHooks Function()>;
typedef $VersesCreateCompanionBuilder = VersesCompanion Function({
  Value<int> id,
  required int bookId,
  required int paragraphId,
  required int chapterNumber,
  required int verseNumber,
  required String verseText,
});
typedef $VersesUpdateCompanionBuilder = VersesCompanion Function({
  Value<int> id,
  Value<int> bookId,
  Value<int> paragraphId,
  Value<int> chapterNumber,
  Value<int> verseNumber,
  Value<String> verseText,
});

class $VersesFilterComposer extends Composer<_$AppDb, Verses> {
  $VersesFilterComposer({
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

  ColumnFilters<int> get paragraphId => $composableBuilder(
      column: $table.paragraphId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnFilters(column));
}

class $VersesOrderingComposer extends Composer<_$AppDb, Verses> {
  $VersesOrderingComposer({
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

  ColumnOrderings<int> get paragraphId => $composableBuilder(
      column: $table.paragraphId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnOrderings(column));
}

class $VersesAnnotationComposer extends Composer<_$AppDb, Verses> {
  $VersesAnnotationComposer({
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

  GeneratedColumn<int> get paragraphId => $composableBuilder(
      column: $table.paragraphId, builder: (column) => column);

  GeneratedColumn<int> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => column);

  GeneratedColumn<int> get verseNumber => $composableBuilder(
      column: $table.verseNumber, builder: (column) => column);

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);
}

class $VersesTableManager extends RootTableManager<
    _$AppDb,
    Verses,
    Verse,
    $VersesFilterComposer,
    $VersesOrderingComposer,
    $VersesAnnotationComposer,
    $VersesCreateCompanionBuilder,
    $VersesUpdateCompanionBuilder,
    (Verse, BaseReferences<_$AppDb, Verses, Verse>),
    Verse,
    PrefetchHooks Function()> {
  $VersesTableManager(_$AppDb db, Verses table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VersesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VersesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VersesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<int> paragraphId = const Value.absent(),
            Value<int> chapterNumber = const Value.absent(),
            Value<int> verseNumber = const Value.absent(),
            Value<String> verseText = const Value.absent(),
          }) =>
              VersesCompanion(
            id: id,
            bookId: bookId,
            paragraphId: paragraphId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            verseText: verseText,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bookId,
            required int paragraphId,
            required int chapterNumber,
            required int verseNumber,
            required String verseText,
          }) =>
              VersesCompanion.insert(
            id: id,
            bookId: bookId,
            paragraphId: paragraphId,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            verseText: verseText,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $VersesProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Verses,
    Verse,
    $VersesFilterComposer,
    $VersesOrderingComposer,
    $VersesAnnotationComposer,
    $VersesCreateCompanionBuilder,
    $VersesUpdateCompanionBuilder,
    (Verse, BaseReferences<_$AppDb, Verses, Verse>),
    Verse,
    PrefetchHooks Function()>;
typedef $VerseStyleCreateCompanionBuilder = VerseStyleCompanion Function({
  Value<int> id,
  required int verseId,
  required int startIndex,
  required int endIndex,
});
typedef $VerseStyleUpdateCompanionBuilder = VerseStyleCompanion Function({
  Value<int> id,
  Value<int> verseId,
  Value<int> startIndex,
  Value<int> endIndex,
});

class $VerseStyleFilterComposer extends Composer<_$AppDb, VerseStyle> {
  $VerseStyleFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verseId => $composableBuilder(
      column: $table.verseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startIndex => $composableBuilder(
      column: $table.startIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endIndex => $composableBuilder(
      column: $table.endIndex, builder: (column) => ColumnFilters(column));
}

class $VerseStyleOrderingComposer extends Composer<_$AppDb, VerseStyle> {
  $VerseStyleOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verseId => $composableBuilder(
      column: $table.verseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startIndex => $composableBuilder(
      column: $table.startIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endIndex => $composableBuilder(
      column: $table.endIndex, builder: (column) => ColumnOrderings(column));
}

class $VerseStyleAnnotationComposer extends Composer<_$AppDb, VerseStyle> {
  $VerseStyleAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get verseId =>
      $composableBuilder(column: $table.verseId, builder: (column) => column);

  GeneratedColumn<int> get startIndex => $composableBuilder(
      column: $table.startIndex, builder: (column) => column);

  GeneratedColumn<int> get endIndex =>
      $composableBuilder(column: $table.endIndex, builder: (column) => column);
}

class $VerseStyleTableManager extends RootTableManager<
    _$AppDb,
    VerseStyle,
    VerseStyleData,
    $VerseStyleFilterComposer,
    $VerseStyleOrderingComposer,
    $VerseStyleAnnotationComposer,
    $VerseStyleCreateCompanionBuilder,
    $VerseStyleUpdateCompanionBuilder,
    (VerseStyleData, BaseReferences<_$AppDb, VerseStyle, VerseStyleData>),
    VerseStyleData,
    PrefetchHooks Function()> {
  $VerseStyleTableManager(_$AppDb db, VerseStyle table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VerseStyleFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VerseStyleOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VerseStyleAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> verseId = const Value.absent(),
            Value<int> startIndex = const Value.absent(),
            Value<int> endIndex = const Value.absent(),
          }) =>
              VerseStyleCompanion(
            id: id,
            verseId: verseId,
            startIndex: startIndex,
            endIndex: endIndex,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int verseId,
            required int startIndex,
            required int endIndex,
          }) =>
              VerseStyleCompanion.insert(
            id: id,
            verseId: verseId,
            startIndex: startIndex,
            endIndex: endIndex,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $VerseStyleProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    VerseStyle,
    VerseStyleData,
    $VerseStyleFilterComposer,
    $VerseStyleOrderingComposer,
    $VerseStyleAnnotationComposer,
    $VerseStyleCreateCompanionBuilder,
    $VerseStyleUpdateCompanionBuilder,
    (VerseStyleData, BaseReferences<_$AppDb, VerseStyle, VerseStyleData>),
    VerseStyleData,
    PrefetchHooks Function()>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $BiblesTableManager get bibles => $BiblesTableManager(_db, _db.bibles);
  $BooksTableManager get books => $BooksTableManager(_db, _db.books);
  $ParagraphsTableManager get paragraphs =>
      $ParagraphsTableManager(_db, _db.paragraphs);
  $VersesTableManager get verses => $VersesTableManager(_db, _db.verses);
  $VerseStyleTableManager get verseStyle =>
      $VerseStyleTableManager(_db, _db.verseStyle);
}

class GetVersesResult {
  final int chapterNumber;
  final String verseText;
  final int verseNumber;
  GetVersesResult({
    required this.chapterNumber,
    required this.verseText,
    required this.verseNumber,
  });
}

class GetBiblesResult {
  final int id;
  final int? languageId;
  final String bibleName;
  final String bibleNameAbbreviation;
  GetBiblesResult({
    required this.id,
    this.languageId,
    required this.bibleName,
    required this.bibleNameAbbreviation,
  });
}

// @dart=3.12

/// The major divisions of biblical texts.
enum Testament {
  oldTestament,
  newTestament,
  deuterocanon,
  additions,
  widerApocrypha,
}

enum BibleBook {
  // dart format off

  // =========================
  // Old Testament (1-39)
  // =========================
  genesis(osis: 'Gen', usfm: 'GEN', canonical: 'GEN', osisIndex: 1, testament: Testament.oldTestament, englishName: 'Genesis', englishAliases: ['gen', 'ge', 'gn']),
  exodus(osis: 'Exod', usfm: 'EXO', canonical: 'EXO', osisIndex: 2, testament: Testament.oldTestament, englishName: 'Exodus', englishAliases: ['exod', 'exo', 'ex']),
  leviticus(osis: 'Lev', usfm: 'LEV', canonical: 'LEV', osisIndex: 3, testament: Testament.oldTestament, englishName: 'Leviticus', englishAliases: ['lev', 'lv']),
  numbers(osis: 'Num', usfm: 'NUM', canonical: 'NUM', osisIndex: 4, testament: Testament.oldTestament, englishName: 'Numbers', englishAliases: ['num', 'nm', 'nb']),
  deuteronomy(osis: 'Deut', usfm: 'DEU', canonical: 'DEU', osisIndex: 5, testament: Testament.oldTestament, englishName: 'Deuteronomy', englishAliases: ['deut', 'deu', 'dt']),
  joshua(osis: 'Josh', usfm: 'JOS', canonical: 'JOS', osisIndex: 6, testament: Testament.oldTestament, englishName: 'Joshua', englishAliases: ['josh', 'jos']),
  judges(osis: 'Judg', usfm: 'JDG', canonical: 'JDG', osisIndex: 7, testament: Testament.oldTestament, englishName: 'Judges', englishAliases: ['judg', 'jdg', 'jud']),
  ruth(osis: 'Ruth', usfm: 'RUT', canonical: 'RUT', osisIndex: 8, testament: Testament.oldTestament, englishName: 'Ruth', englishAliases: ['rut', 'ru']),
  firstSamuel(osis: '1Sam', usfm: '1SA', canonical: '1SA', osisIndex: 9, testament: Testament.oldTestament, englishName: '1 Samuel', englishAliases: ['first samuel', '1samuel', '1 sam', '1sam', '1sa']),
  secondSamuel(osis: '2Sam', usfm: '2SA', canonical: '2SA', osisIndex: 10, testament: Testament.oldTestament, englishName: '2 Samuel', englishAliases: ['second samuel', '2samuel', '2 sam', '2sam', '2sa']),
  firstKings(osis: '1Kgs', usfm: '1KI', canonical: '1KI', osisIndex: 11, testament: Testament.oldTestament, englishName: '1 Kings', englishAliases: ['first kings', '1kings', '1 kgs', '1kgs', '1ki']),
  secondKings(osis: '2Kgs', usfm: '2KI', canonical: '2KI', osisIndex: 12, testament: Testament.oldTestament, englishName: '2 Kings', englishAliases: ['second kings', '2kings', '2 kgs', '2kgs', '2ki']),
  firstChronicles(osis: '1Chr', usfm: '1CH', canonical: '1CH', osisIndex: 13, testament: Testament.oldTestament, englishName: '1 Chronicles', englishAliases: ['first chronicles', '1chronicles', '1 chr', '1chr', '1ch']),
  secondChronicles(osis: '2Chr', usfm: '2CH', canonical: '2CH', osisIndex: 14, testament: Testament.oldTestament, englishName: '2 Chronicles', englishAliases: ['second chronicles', '2chronicles', '2 chr', '2chr', '2ch']),
  ezra(osis: 'Ezra', usfm: 'EZR', canonical: 'EZR', osisIndex: 15, testament: Testament.oldTestament, englishName: 'Ezra', englishAliases: ['ezr']),
  nehemiah(osis: 'Neh', usfm: 'NEH', canonical: 'NEH', osisIndex: 16, testament: Testament.oldTestament, englishName: 'Nehemiah', englishAliases: ['neh']),
  esther(osis: 'Esth', usfm: 'EST', canonical: 'EST', osisIndex: 17, testament: Testament.oldTestament, englishName: 'Esther', englishAliases: ['esth', 'est']),
  job(osis: 'Job', usfm: 'JOB', canonical: 'JOB', osisIndex: 18, testament: Testament.oldTestament, englishName: 'Job', englishAliases: []),
  psalms(osis: 'Ps', usfm: 'PSA', canonical: 'PSA', osisIndex: 19, testament: Testament.oldTestament, englishName: 'Psalms', englishAliases: ['psalm', 'ps', 'psa']),
  proverbs(osis: 'Prov', usfm: 'PRO', canonical: 'PRO', osisIndex: 20, testament: Testament.oldTestament, englishName: 'Proverbs', englishAliases: ['prov', 'pro', 'prv']),
  ecclesiastes(osis: 'Eccl', usfm: 'ECC', canonical: 'ECC', osisIndex: 21, testament: Testament.oldTestament, englishName: 'Ecclesiastes', englishAliases: ['eccl', 'ecc']),
  songOfSolomon(osis: 'Song', usfm: 'SNG', canonical: 'SNG', osisIndex: 22, testament: Testament.oldTestament, englishName: 'Song of solomon', englishAliases: ['song of songs', 'song', 'songs', 'sos', 'sng']),
  isaiah(osis: 'Isa', usfm: 'ISA', canonical: 'ISA', osisIndex: 23, testament: Testament.oldTestament, englishName: 'Isaiah', englishAliases: ['isa']),
  jeremiah(osis: 'Jer', usfm: 'JER', canonical: 'JER', osisIndex: 24, testament: Testament.oldTestament, englishName: 'Jeremiah', englishAliases: ['jer']),
  lamentations(osis: 'Lam', usfm: 'LAM', canonical: 'LAM', osisIndex: 25, testament: Testament.oldTestament, englishName: 'Lamentations', englishAliases: ['lam']),
  ezekiel(osis: 'Ezek', usfm: 'EZE', canonical: 'EZE', osisIndex: 26, testament: Testament.oldTestament, englishName: 'Ezekiel', englishAliases: ['ezek', 'eze']),
  daniel(osis: 'Dan', usfm: 'DAN', canonical: 'DAN', osisIndex: 27, testament: Testament.oldTestament, englishName: 'Daniel', englishAliases: ['dan']),
  hosea(osis: 'Hos', usfm: 'HOS', canonical: 'HOS', osisIndex: 28, testament: Testament.oldTestament, englishName: 'Hosea', englishAliases: ['hos']),
  joel(osis: 'Joel', usfm: 'JOL', canonical: 'JOL', osisIndex: 29, testament: Testament.oldTestament, englishName: 'Joel', englishAliases: ['jol']),
  amos(osis: 'Amos', usfm: 'AMO', canonical: 'AMO', osisIndex: 30, testament: Testament.oldTestament, englishName: 'Amos', englishAliases: ['amo']),
  obadiah(osis: 'Obad', usfm: 'OBA', canonical: 'OBA', osisIndex: 31, testament: Testament.oldTestament, englishName: 'Obadiah', englishAliases: ['obad', 'oba']),
  jonah(osis: 'Jonah', usfm: 'JON', canonical: 'JON', osisIndex: 32, testament: Testament.oldTestament, englishName: 'Jonah', englishAliases: ['jon']),
  micah(osis: 'Mic', usfm: 'MIC', canonical: 'MIC', osisIndex: 33, testament: Testament.oldTestament, englishName: 'Micah', englishAliases: ['mic']),
  nahum(osis: 'Nah', usfm: 'NAM', canonical: 'NAM', osisIndex: 34, testament: Testament.oldTestament, englishName: 'Nahum', englishAliases: ['nah', 'nam']),
  habakkuk(osis: 'Hab', usfm: 'HAB', canonical: 'HAB', osisIndex: 35, testament: Testament.oldTestament, englishName: 'Habakkuk', englishAliases: ['hab']),
  zephaniah(osis: 'Zeph', usfm: 'ZEP', canonical: 'ZEP', osisIndex: 36, testament: Testament.oldTestament, englishName: 'Zephaniah', englishAliases: ['zeph', 'zep']),
  haggai(osis: 'Hag', usfm: 'HAG', canonical: 'HAG', osisIndex: 37, testament: Testament.oldTestament, englishName: 'Haggai', englishAliases: ['hag']),
  zechariah(osis: 'Zech', usfm: 'ZEC', canonical: 'ZEC', osisIndex: 38, testament: Testament.oldTestament, englishName: 'Zechariah', englishAliases: ['zech', 'zec']),
  malachi(osis: 'Mal', usfm: 'MAL', canonical: 'MAL', osisIndex: 39, testament: Testament.oldTestament, englishName: 'Malachi', englishAliases: ['mal']),

  // =========================
  // New Testament (40-66)
  // =========================
  matthew(osis: 'Matt', usfm: 'MAT', canonical: 'MAT', osisIndex: 40, testament: Testament.newTestament, englishName: 'Matthew', englishAliases: ['matt', 'mat', 'mt']),
  mark(osis: 'Mark', usfm: 'MRK', canonical: 'MRK', osisIndex: 41, testament: Testament.newTestament, englishName: 'Mark', englishAliases: ['mrk', 'mk']),
  luke(osis: 'Luke', usfm: 'LUK', canonical: 'LUK', osisIndex: 42, testament: Testament.newTestament, englishName: 'Luke', englishAliases: ['luk', 'lk']),
  john(osis: 'John', usfm: 'JHN', canonical: 'JHN', osisIndex: 43, testament: Testament.newTestament, englishName: 'John', englishAliases: ['jhn', 'jn']),
  acts(osis: 'Acts', usfm: 'ACT', canonical: 'ACT', osisIndex: 44, testament: Testament.newTestament, englishName: 'Acts', englishAliases: ['act']),
  romans(osis: 'Rom', usfm: 'ROM', canonical: 'ROM', osisIndex: 45, testament: Testament.newTestament, englishName: 'Romans', englishAliases: ['rom', 'ro']),
  firstCorinthians(osis: '1Cor', usfm: '1CO', canonical: '1CO', osisIndex: 46, testament: Testament.newTestament, englishName: '1 Corinthians', englishAliases: ['first corinthians', '1corinthians', '1 cor', '1cor', '1co']),
  secondCorinthians(osis: '2Cor', usfm: '2CO', canonical: '2CO', osisIndex: 47, testament: Testament.newTestament, englishName: '2 Corinthians', englishAliases: ['second corinthians', '2corinthians', '2 cor', '2cor', '2co']),
  galatians(osis: 'Gal', usfm: 'GAL', canonical: 'GAL', osisIndex: 48, testament: Testament.newTestament, englishName: 'Galatians', englishAliases: ['gal']),
  ephesians(osis: 'Eph', usfm: 'EPH', canonical: 'EPH', osisIndex: 49, testament: Testament.newTestament, englishName: 'Ephesians', englishAliases: ['eph']),
  philippians(osis: 'Phil', usfm: 'PHP', canonical: 'PHP', osisIndex: 50, testament: Testament.newTestament, englishName: 'Philippians', englishAliases: ['phil', 'php']),
  colossians(osis: 'Col', usfm: 'COL', canonical: 'COL', osisIndex: 51, testament: Testament.newTestament, englishName: 'Colossians', englishAliases: ['col']),
  firstThessalonians(osis: '1Thess', usfm: '1TH', canonical: '1TH', osisIndex: 52, testament: Testament.newTestament, englishName: '1 Thessalonians', englishAliases: ['first thessalonians', '1thessalonians', '1 thess', '1thess', '1th']),
  secondThessalonians(osis: '2Thess', usfm: '2TH', canonical: '2TH', osisIndex: 53, testament: Testament.newTestament, englishName: '2 Thessalonians', englishAliases: ['second thessalonians', '2thessalonians', '2 thess', '2thess', '2th']),
  firstTimothy(osis: '1Tim', usfm: '1TI', canonical: '1TI', osisIndex: 54, testament: Testament.newTestament, englishName: '1 Timothy', englishAliases: ['first timothy', '1timothy', '1 tim', '1tim', '1ti']),
  secondTimothy(osis: '2Tim', usfm: '2TI', canonical: '2TI', osisIndex: 55, testament: Testament.newTestament, englishName: '2 Timothy', englishAliases: ['second timothy', '2timothy', '2 tim', '2tim', '2ti']),
  titus(osis: 'Titus', usfm: 'TIT', canonical: 'TIT', osisIndex: 56, testament: Testament.newTestament, englishName: 'Titus', englishAliases: ['tit']),
  philemon(osis: 'Phlm', usfm: 'PHM', canonical: 'PHM', osisIndex: 57, testament: Testament.newTestament, englishName: 'Philemon', englishAliases: ['phlm', 'phm']),
  hebrews(osis: 'Heb', usfm: 'HEB', canonical: 'HEB', osisIndex: 58, testament: Testament.newTestament, englishName: 'Hebrews', englishAliases: ['heb']),
  james(osis: 'Jas', usfm: 'JAS', canonical: 'JAS', osisIndex: 59, testament: Testament.newTestament, englishName: 'James', englishAliases: ['jas', 'jam']),
  firstPeter(osis: '1Pet', usfm: '1PE', canonical: '1PE', osisIndex: 60, testament: Testament.newTestament, englishName: '1 Peter', englishAliases: ['first peter', '1peter', '1 pet', '1pet', '1pe']),
  secondPeter(osis: '2Pet', usfm: '2PE', canonical: '2PE', osisIndex: 61, testament: Testament.newTestament, englishName: '2 Peter', englishAliases: ['second peter', '2peter', '2 pet', '2pet', '2pe']),
  firstJohn(osis: '1John', usfm: '1JN', canonical: '1JN', osisIndex: 62, testament: Testament.newTestament, englishName: '1 John', englishAliases: ['first john', '1john', '1 jn', '1jn']),
  secondJohn(osis: '2John', usfm: '2JN', canonical: '2JN', osisIndex: 63, testament: Testament.newTestament, englishName: '2 John', englishAliases: ['second john', '2john', '2 jn', '2jn']),
  thirdJohn(osis: '3John', usfm: '3JN', canonical: '3JN', osisIndex: 64, testament: Testament.newTestament, englishName: '3 John', englishAliases: ['third john', '3john', '3 jn', '3jn']),
  jude(osis: 'Jude', usfm: 'JUD', canonical: 'JUD', osisIndex: 65, testament: Testament.newTestament, englishName: 'Jude', englishAliases: ['jud']),
  revelation(osis: 'Rev', usfm: 'REV', canonical: 'REV', osisIndex: 66, testament: Testament.newTestament, englishName: 'Revelation', englishAliases: ['revelations', 'rev', 'apocalypse']),

  // =========================
  // Deuterocanon & Apocrypha (67+)
  // =========================
  tobit(osis: 'Tob', usfm: 'TOB', canonical: 'TOB', osisIndex: 67, testament: Testament.deuterocanon, englishName: 'Tobit', englishAliases: ['tob']),
  judith(osis: 'Jdt', usfm: 'JDT', canonical: 'JDT', osisIndex: 68, testament: Testament.deuterocanon, englishName: 'Judith', englishAliases: ['jdt']),
  addEsther(osis: 'EsthGr', usfm: 'ESG', canonical: 'ESG', osisIndex: 69, testament: Testament.additions, englishName: 'Additions to Esther', englishAliases: ['greek esther', 'esthgr', 'esg']),
  wisdom(osis: 'Wis', usfm: 'WIS', canonical: 'WIS', osisIndex: 70, testament: Testament.deuterocanon, englishName: 'Wisdom', englishAliases: ['wisdom of solomon', 'wis']),
  sirach(osis: 'Sir', usfm: 'SIR', canonical: 'SIR', osisIndex: 71, testament: Testament.deuterocanon, englishName: 'Sirach', englishAliases: ['ecclesiasticus', 'sir']),
  baruch(osis: 'Bar', usfm: 'BAR', canonical: 'BAR', osisIndex: 72, testament: Testament.deuterocanon, englishName: 'Baruch', englishAliases: ['bar']),
  letterOfJeremiah(osis: 'EpJer', usfm: 'LJE', canonical: 'LJE', osisIndex: 73, testament: Testament.additions, englishName: 'Letter of Jeremiah', englishAliases: ['epistle of jeremiah', 'epjer', 'lje']),
  songOfThreeYouths(osis: 'PrAzar', usfm: 'S3Y', canonical: 'S3Y', osisIndex: 74, testament: Testament.additions, englishName: 'Song of the three youths', englishAliases: ['song of three youths', 'prayer of azariah', 'prazar', 's3y']),
  susanna(osis: 'Sus', usfm: 'SUS', canonical: 'SUS', osisIndex: 75, testament: Testament.additions, englishName: 'Susanna', englishAliases: ['sus']),
  belAndDragon(osis: 'Bel', usfm: 'BEL', canonical: 'BEL', osisIndex: 76, testament: Testament.additions, englishName: 'Bel and the dragon', englishAliases: ['bel and dragon', 'bel']),
  firstMaccabees(osis: '1Macc', usfm: '1MA', canonical: '1MA', osisIndex: 77, testament: Testament.deuterocanon, englishName: '1 Maccabees', englishAliases: ['first maccabees', '1maccabees', '1 macc', '1macc', '1ma']),
  secondMaccabees(osis: '2Macc', usfm: '2MA', canonical: '2MA', osisIndex: 78, testament: Testament.deuterocanon, englishName: '2 Maccabees', englishAliases: ['second maccabees', '2maccabees', '2 macc', '2macc', '2ma']),
  thirdMaccabees(osis: '3Macc', usfm: '3MA', canonical: '3MA', osisIndex: 79, testament: Testament.widerApocrypha, englishName: '3 Maccabees', englishAliases: ['third maccabees', '3maccabees', '3 macc', '3macc', '3ma']),
  fourthMaccabees(osis: '4Macc', usfm: '4MA', canonical: '4MA', osisIndex: 80, testament: Testament.widerApocrypha, englishName: '4 Maccabees', englishAliases: ['fourth maccabees', '4maccabees', '4 macc', '4macc', '4ma']),
  firstEsdras(osis: '1Esd', usfm: '1ES', canonical: '1ES', osisIndex: 81, testament: Testament.widerApocrypha, englishName: '1 Esdras', englishAliases: ['first esdras', '1esdras', '1 esd', '1esd', '1es']),
  secondEsdras(osis: '2Esd', usfm: '2ES', canonical: '2ES', osisIndex: 82, testament: Testament.widerApocrypha, englishName: '2 Esdras', englishAliases: ['second esdras', '2esdras', '2 esd', '2esd', '2es']),
  prayerOfManasseh(osis: 'PrMan', usfm: 'MAN', canonical: 'MAN', osisIndex: 83, testament: Testament.widerApocrypha, englishName: 'Prayer of Manasseh', englishAliases: ['manasseh', 'prman', 'man']),
  psalm151(osis: 'Ps151', usfm: 'PS2', canonical: 'PS2', osisIndex: 84, testament: Testament.widerApocrypha, englishName: 'Psalm 151', englishAliases: ['ps151', 'psalm151', 'ps 151', 'ps2']);

  // dart format on

  const BibleBook({
    required this.osis,
    required this.usfm,
    required this.canonical,
    required this.osisIndex,
    required this.testament,
    required this.englishName,
    required this.englishAliases,
  });

  final String osis;
  final String usfm;

  /// The universal database identifier (bookToken)
  final String canonical;
  final int osisIndex;
  final Testament testament;

  final String englishName;

  /// Standard English names and common abbreviations
  final List<String> englishAliases;

  // The L1 Memory Cache
  static final Map<String, BibleBook> _englishAliasLookup = _buildAliasMap();

  static Map<String, BibleBook> _buildAliasMap() {
    final map = <String, BibleBook>{};
    for (final book in values) {
      for (final alias in book.englishAliases) {
        map[_norm(alias)] = book;
      }
    }
    return map;
  }

  /// Strict Programmatic ID Lookup (Highest Priority)
  static BibleBook? fromProgrammaticId(String id) {
    if (id.isEmpty) return null;
    final normalized = _norm(id);

    for (final book in values) {
      if (_norm(book.canonical) == normalized ||
          _norm(book.usfm) == normalized ||
          _norm(book.osis) == normalized) {
        return book;
      }
    }
    return null;
  }

  static BibleBook? resolveEnglishPrefix(String id) {
    if (id.isEmpty) return null;
    final normalized = _norm(id);

    for (final book in values) {
      if (_norm(book.englishName).startsWith(normalized)) {
        return book;
      }
    }
    return null;
  }

  /// English Alias Lookup (L1 Cache Fallback)
  static BibleBook? resolveEnglishAlias(String id) {
    if (id.isEmpty) return null;
    return _englishAliasLookup[_norm(id)];
  }

  static List<BibleBook> resolveEnglishPrefixCandidates(String id) {
    if (id.isEmpty) return [];
    final normalized = _norm(id);

    return values
        .where((b) => _norm(b.englishName).startsWith(normalized))
        .toList();
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

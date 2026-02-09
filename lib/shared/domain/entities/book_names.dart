// For now use this local mapping instead of the books metadata stored in sqllite
//
// Single source of truth for Bible book identifiers + fast prefix lookup.
// Supports multiple canon/“versification” book sets.
//
// How to use:
//   final r1 = BibleRefResolver.defaultResolver().resolveUsfxId("Gene"); // GEN
//   final r2 = BibleRefResolver.defaultResolver().resolveBook("1 sam");  // BibleBook.firstSamuel
//   final r3 = BibleRefResolver(versification: Versification.protestant66).resolveUsfxId("Tob"); // null
//
// Notes:
// - Prefix lookup is normalized (case/space/punct-insensitive).
// - Ambiguous prefixes return null (use resolveCandidates to offer UI suggestions).
// - Add more aliases in searchKeys for better UX.

enum BibleBook {
  // OT (Protestant 39)
  genesis,
  exodus,
  leviticus,
  numbers,
  deuteronomy,
  joshua,
  judges,
  ruth,
  firstSamuel,
  secondSamuel,
  firstKings,
  secondKings,
  firstChronicles,
  secondChronicles,
  ezra,
  nehemiah,
  esther,
  job,
  psalms,
  proverbs,
  ecclesiastes,
  songOfSongs,
  isaiah,
  jeremiah,
  lamentations,
  ezekiel,
  daniel,
  hosea,
  joel,
  amos,
  obadiah,
  jonah,
  micah,
  nahum,
  habakkuk,
  zephaniah,
  haggai,
  zechariah,
  malachi,

  // NT (27)
  matthew,
  mark,
  luke,
  john,
  acts,
  romans,
  firstCorinthians,
  secondCorinthians,
  galatians,
  ephesians,
  philippians,
  colossians,
  firstThessalonians,
  secondThessalonians,
  firstTimothy,
  secondTimothy,
  titus,
  philemon,
  hebrews,
  james,
  firstPeter,
  secondPeter,
  firstJohn,
  secondJohn,
  thirdJohn,
  jude,
  revelation,

  // Deuterocanon / Apocrypha (common)
  tobit,
  judith,
  wisdom,
  sirach, // Ecclesiasticus
  baruch,
  epJer,
  firstMaccabees,
  secondMaccabees,

  // OSIS treats these as separate “books” (Additions)
  addEsther, // AddEsth
  prayerOfAzariah, // PrAzar (addition to Daniel)
  susanna, // Sus (Daniel)
  belAndTheDragon, // Bel (Daniel)

  // Wider Orthodox / Apocrypha (varies by tradition)
  firstEsdras, // 1Esd (aka 3 Ezra in some traditions)
  secondEsdras, // 2Esd (aka 4 Ezra / Latin)
  thirdMaccabees,
  fourthMaccabees,
  prayerOfManasseh,
  psalm151,
}

extension BibleBookMeta on BibleBook {
  /// English display name
  String get fullName {
    switch (this) {
      case BibleBook.genesis:
        return 'Genesis';
      case BibleBook.exodus:
        return 'Exodus';
      case BibleBook.leviticus:
        return 'Leviticus';
      case BibleBook.numbers:
        return 'Numbers';
      case BibleBook.deuteronomy:
        return 'Deuteronomy';
      case BibleBook.joshua:
        return 'Joshua';
      case BibleBook.judges:
        return 'Judges';
      case BibleBook.ruth:
        return 'Ruth';
      case BibleBook.firstSamuel:
        return '1 Samuel';
      case BibleBook.secondSamuel:
        return '2 Samuel';
      case BibleBook.firstKings:
        return '1 Kings';
      case BibleBook.secondKings:
        return '2 Kings';
      case BibleBook.firstChronicles:
        return '1 Chronicles';
      case BibleBook.secondChronicles:
        return '2 Chronicles';
      case BibleBook.ezra:
        return 'Ezra';
      case BibleBook.nehemiah:
        return 'Nehemiah';
      case BibleBook.esther:
        return 'Esther';
      case BibleBook.job:
        return 'Job';
      case BibleBook.psalms:
        return 'Psalms';
      case BibleBook.proverbs:
        return 'Proverbs';
      case BibleBook.ecclesiastes:
        return 'Ecclesiastes';
      case BibleBook.songOfSongs:
        return 'Song of Songs';
      case BibleBook.isaiah:
        return 'Isaiah';
      case BibleBook.jeremiah:
        return 'Jeremiah';
      case BibleBook.lamentations:
        return 'Lamentations';
      case BibleBook.ezekiel:
        return 'Ezekiel';
      case BibleBook.daniel:
        return 'Daniel';
      case BibleBook.hosea:
        return 'Hosea';
      case BibleBook.joel:
        return 'Joel';
      case BibleBook.amos:
        return 'Amos';
      case BibleBook.obadiah:
        return 'Obadiah';
      case BibleBook.jonah:
        return 'Jonah';
      case BibleBook.micah:
        return 'Micah';
      case BibleBook.nahum:
        return 'Nahum';
      case BibleBook.habakkuk:
        return 'Habakkuk';
      case BibleBook.zephaniah:
        return 'Zephaniah';
      case BibleBook.haggai:
        return 'Haggai';
      case BibleBook.zechariah:
        return 'Zechariah';
      case BibleBook.malachi:
        return 'Malachi';

      case BibleBook.matthew:
        return 'Matthew';
      case BibleBook.mark:
        return 'Mark';
      case BibleBook.luke:
        return 'Luke';
      case BibleBook.john:
        return 'John';
      case BibleBook.acts:
        return 'Acts';
      case BibleBook.romans:
        return 'Romans';
      case BibleBook.firstCorinthians:
        return '1 Corinthians';
      case BibleBook.secondCorinthians:
        return '2 Corinthians';
      case BibleBook.galatians:
        return 'Galatians';
      case BibleBook.ephesians:
        return 'Ephesians';
      case BibleBook.philippians:
        return 'Philippians';
      case BibleBook.colossians:
        return 'Colossians';
      case BibleBook.firstThessalonians:
        return '1 Thessalonians';
      case BibleBook.secondThessalonians:
        return '2 Thessalonians';
      case BibleBook.firstTimothy:
        return '1 Timothy';
      case BibleBook.secondTimothy:
        return '2 Timothy';
      case BibleBook.titus:
        return 'Titus';
      case BibleBook.philemon:
        return 'Philemon';
      case BibleBook.hebrews:
        return 'Hebrews';
      case BibleBook.james:
        return 'James';
      case BibleBook.firstPeter:
        return '1 Peter';
      case BibleBook.secondPeter:
        return '2 Peter';
      case BibleBook.firstJohn:
        return '1 John';
      case BibleBook.secondJohn:
        return '2 John';
      case BibleBook.thirdJohn:
        return '3 John';
      case BibleBook.jude:
        return 'Jude';
      case BibleBook.revelation:
        return 'Revelation';

      case BibleBook.tobit:
        return 'Tobit';
      case BibleBook.judith:
        return 'Judith';
      case BibleBook.wisdom:
        return 'Wisdom';
      case BibleBook.sirach:
        return 'Sirach';
      case BibleBook.baruch:
        return 'Baruch';
      case BibleBook.epJer:
        return 'Letter of Jeremiah';
      case BibleBook.firstMaccabees:
        return '1 Maccabees';
      case BibleBook.secondMaccabees:
        return '2 Maccabees';

      case BibleBook.addEsther:
        return 'Additions to Esther';
      case BibleBook.prayerOfAzariah:
        return 'Prayer of Azariah';
      case BibleBook.susanna:
        return 'Susanna';
      case BibleBook.belAndTheDragon:
        return 'Bel and the Dragon';

      case BibleBook.firstEsdras:
        return '1 Esdras';
      case BibleBook.secondEsdras:
        return '2 Esdras';
      case BibleBook.thirdMaccabees:
        return '3 Maccabees';
      case BibleBook.fourthMaccabees:
        return '4 Maccabees';
      case BibleBook.prayerOfManasseh:
        return 'Prayer of Manasseh';
      case BibleBook.psalm151:
        return 'Psalm 151';
    }
  }

  /// OSIS book ID (standard OSIS identifiers)
  String get osisId {
    switch (this) {
      case BibleBook.genesis:
        return 'Gen';
      case BibleBook.exodus:
        return 'Exod';
      case BibleBook.leviticus:
        return 'Lev';
      case BibleBook.numbers:
        return 'Num';
      case BibleBook.deuteronomy:
        return 'Deut';
      case BibleBook.joshua:
        return 'Josh';
      case BibleBook.judges:
        return 'Judg';
      case BibleBook.ruth:
        return 'Ruth';
      case BibleBook.firstSamuel:
        return '1Sam';
      case BibleBook.secondSamuel:
        return '2Sam';
      case BibleBook.firstKings:
        return '1Kgs';
      case BibleBook.secondKings:
        return '2Kgs';
      case BibleBook.firstChronicles:
        return '1Chr';
      case BibleBook.secondChronicles:
        return '2Chr';
      case BibleBook.ezra:
        return 'Ezra';
      case BibleBook.nehemiah:
        return 'Neh';
      case BibleBook.esther:
        return 'Esth';
      case BibleBook.job:
        return 'Job';
      case BibleBook.psalms:
        return 'Ps';
      case BibleBook.proverbs:
        return 'Prov';
      case BibleBook.ecclesiastes:
        return 'Eccl';
      case BibleBook.songOfSongs:
        return 'Song';
      case BibleBook.isaiah:
        return 'Isa';
      case BibleBook.jeremiah:
        return 'Jer';
      case BibleBook.lamentations:
        return 'Lam';
      case BibleBook.ezekiel:
        return 'Ezek';
      case BibleBook.daniel:
        return 'Dan';
      case BibleBook.hosea:
        return 'Hos';
      case BibleBook.joel:
        return 'Joel';
      case BibleBook.amos:
        return 'Amos';
      case BibleBook.obadiah:
        return 'Obad';
      case BibleBook.jonah:
        return 'Jonah';
      case BibleBook.micah:
        return 'Mic';
      case BibleBook.nahum:
        return 'Nah';
      case BibleBook.habakkuk:
        return 'Hab';
      case BibleBook.zephaniah:
        return 'Zeph';
      case BibleBook.haggai:
        return 'Hag';
      case BibleBook.zechariah:
        return 'Zech';
      case BibleBook.malachi:
        return 'Mal';

      case BibleBook.matthew:
        return 'Matt';
      case BibleBook.mark:
        return 'Mark';
      case BibleBook.luke:
        return 'Luke';
      case BibleBook.john:
        return 'John';
      case BibleBook.acts:
        return 'Acts';
      case BibleBook.romans:
        return 'Rom';
      case BibleBook.firstCorinthians:
        return '1Cor';
      case BibleBook.secondCorinthians:
        return '2Cor';
      case BibleBook.galatians:
        return 'Gal';
      case BibleBook.ephesians:
        return 'Eph';
      case BibleBook.philippians:
        return 'Phil';
      case BibleBook.colossians:
        return 'Col';
      case BibleBook.firstThessalonians:
        return '1Thess';
      case BibleBook.secondThessalonians:
        return '2Thess';
      case BibleBook.firstTimothy:
        return '1Tim';
      case BibleBook.secondTimothy:
        return '2Tim';
      case BibleBook.titus:
        return 'Titus';
      case BibleBook.philemon:
        return 'Phlm';
      case BibleBook.hebrews:
        return 'Heb';
      case BibleBook.james:
        return 'Jas';
      case BibleBook.firstPeter:
        return '1Pet';
      case BibleBook.secondPeter:
        return '2Pet';
      case BibleBook.firstJohn:
        return '1John';
      case BibleBook.secondJohn:
        return '2John';
      case BibleBook.thirdJohn:
        return '3John';
      case BibleBook.jude:
        return 'Jude';
      case BibleBook.revelation:
        return 'Rev';

      case BibleBook.tobit:
        return 'Tob';
      case BibleBook.judith:
        return 'Jdt';
      case BibleBook.wisdom:
        return 'Wis';
      case BibleBook.sirach:
        return 'Sir';
      case BibleBook.baruch:
        return 'Bar';
      case BibleBook.epJer:
        return 'EpJer';
      case BibleBook.firstMaccabees:
        return '1Macc';
      case BibleBook.secondMaccabees:
        return '2Macc';

      case BibleBook.addEsther:
        return 'EsthGr';
      case BibleBook.prayerOfAzariah:
        return 'PrAzar';
      case BibleBook.susanna:
        return 'Sus';
      case BibleBook.belAndTheDragon:
        return 'Bel';

      case BibleBook.firstEsdras:
        return '1Esd';
      case BibleBook.secondEsdras:
        return '2Esd';
      case BibleBook.thirdMaccabees:
        return '3Macc';
      case BibleBook.fourthMaccabees:
        return '4Macc';
      case BibleBook.prayerOfManasseh:
        return 'PrMan';
      case BibleBook.psalm151:
        return 'Ps151';
    }
  }

  /// USFX 3-letter (or 3+digit) IDs as used in many USFM/USFX ecosystems.
  /// Matches your map where applicable.
  String get usfxId {
    switch (this) {
      case BibleBook.genesis:
        return 'GEN';
      case BibleBook.exodus:
        return 'EXO';
      case BibleBook.leviticus:
        return 'LEV';
      case BibleBook.numbers:
        return 'NUM';
      case BibleBook.deuteronomy:
        return 'DEU';
      case BibleBook.joshua:
        return 'JOS';
      case BibleBook.judges:
        return 'JDG';
      case BibleBook.ruth:
        return 'RUT';
      case BibleBook.firstSamuel:
        return '1SA';
      case BibleBook.secondSamuel:
        return '2SA';
      case BibleBook.firstKings:
        return '1KI';
      case BibleBook.secondKings:
        return '2KI';
      case BibleBook.firstChronicles:
        return '1CH';
      case BibleBook.secondChronicles:
        return '2CH';
      case BibleBook.ezra:
        return 'EZR';
      case BibleBook.nehemiah:
        return 'NEH';
      case BibleBook.esther:
        return 'EST';
      case BibleBook.job:
        return 'JOB';
      case BibleBook.psalms:
        return 'PSA';
      case BibleBook.proverbs:
        return 'PRO';
      case BibleBook.ecclesiastes:
        return 'ECC';
      case BibleBook.songOfSongs:
        return 'SNG';
      case BibleBook.isaiah:
        return 'ISA';
      case BibleBook.jeremiah:
        return 'JER';
      case BibleBook.lamentations:
        return 'LAM';
      case BibleBook.ezekiel:
        return 'EZK';
      case BibleBook.daniel:
        return 'DAN';
      case BibleBook.hosea:
        return 'HOS';
      case BibleBook.joel:
        return 'JOL';
      case BibleBook.amos:
        return 'AMO';
      case BibleBook.obadiah:
        return 'OBA';
      case BibleBook.jonah:
        return 'JON';
      case BibleBook.micah:
        return 'MIC';
      case BibleBook.nahum:
        return 'NAM';
      case BibleBook.habakkuk:
        return 'HAB';
      case BibleBook.zephaniah:
        return 'ZEP';
      case BibleBook.haggai:
        return 'HAG';
      case BibleBook.zechariah:
        return 'ZEC';
      case BibleBook.malachi:
        return 'MAL';

      case BibleBook.matthew:
        return 'MAT';
      case BibleBook.mark:
        return 'MRK';
      case BibleBook.luke:
        return 'LUK';
      case BibleBook.john:
        return 'JHN';
      case BibleBook.acts:
        return 'ACT';
      case BibleBook.romans:
        return 'ROM';
      case BibleBook.firstCorinthians:
        return '1CO';
      case BibleBook.secondCorinthians:
        return '2CO';
      case BibleBook.galatians:
        return 'GAL';
      case BibleBook.ephesians:
        return 'EPH';
      case BibleBook.philippians:
        return 'PHP';
      case BibleBook.colossians:
        return 'COL';
      case BibleBook.firstThessalonians:
        return '1TH';
      case BibleBook.secondThessalonians:
        return '2TH';
      case BibleBook.firstTimothy:
        return '1TI';
      case BibleBook.secondTimothy:
        return '2TI';
      case BibleBook.titus:
        return 'TIT';
      case BibleBook.philemon:
        return 'PHM';
      case BibleBook.hebrews:
        return 'HEB';
      case BibleBook.james:
        return 'JAS';
      case BibleBook.firstPeter:
        return '1PE';
      case BibleBook.secondPeter:
        return '2PE';
      case BibleBook.firstJohn:
        return '1JN';
      case BibleBook.secondJohn:
        return '2JN';
      case BibleBook.thirdJohn:
        return '3JN';
      case BibleBook.jude:
        return 'JUD';
      case BibleBook.revelation:
        return 'REV';

      // Deuterocanon/Apocrypha: IDs vary between corpora.
      // These are commonly seen
      case BibleBook.tobit:
        return 'TOB';
      case BibleBook.judith:
        return 'JDT';
      case BibleBook.wisdom:
        return 'WIS';
      case BibleBook.sirach:
        return 'SIR';
      case BibleBook.baruch:
        return 'BAR';
      case BibleBook.epJer:
        return 'LJE';
      case BibleBook.firstMaccabees:
        return '1MA';
      case BibleBook.secondMaccabees:
        return '2MA';

      // Additions: also vary across datasets.
      case BibleBook.addEsther:
        return 'ADE';
      case BibleBook.prayerOfAzariah:
        return 'AZA';
      case BibleBook.susanna:
        return 'SUS';
      case BibleBook.belAndTheDragon:
        return 'BEL';

      case BibleBook.firstEsdras:
        return '1ES';
      case BibleBook.secondEsdras:
        return '2ES';
      case BibleBook.thirdMaccabees:
        return '3MA';
      case BibleBook.fourthMaccabees:
        return '4MA';
      case BibleBook.prayerOfManasseh:
        return 'MAN';
      case BibleBook.psalm151:
        return 'PS1';
    }
  }

  /// Canonical search keys (normalized later). Add more to improve UX.
  List<String> get searchKeys {
    switch (this) {
      case BibleBook.songOfSongs:
        return [
          'song of songs',
          'song of solomon',
          'song',
          'songs',
          'canticles',
        ];
      case BibleBook.psalms:
        return ['psalms', 'psalm', 'ps', 'psa'];
      case BibleBook.firstSamuel:
        return ['1 samuel', '1 sam', 'first samuel', 'i samuel', '1sa'];
      case BibleBook.secondSamuel:
        return ['2 samuel', '2 sam', 'second samuel', 'ii samuel', '2sa'];
      case BibleBook.firstKings:
        return ['1 kings', '1 king', 'first kings', 'i kings', '1ki'];
      case BibleBook.secondKings:
        return ['2 kings', '2 king', 'second kings', 'ii kings', '2ki'];
      case BibleBook.firstChronicles:
        return [
          '1 chronicles',
          '1 chron',
          'first chronicles',
          'i chronicles',
          '1ch'
        ];
      case BibleBook.secondChronicles:
        return [
          '2 chronicles',
          '2 chron',
          'second chronicles',
          'ii chronicles',
          '2ch'
        ];
      case BibleBook.firstCorinthians:
        return [
          '1 corinthians',
          '1 cor',
          'first corinthians',
          'i corinthians',
          '1co'
        ];
      case BibleBook.secondCorinthians:
        return [
          '2 corinthians',
          '2 cor',
          'second corinthians',
          'ii corinthians',
          '2co'
        ];
      case BibleBook.firstThessalonians:
        return [
          '1 thessalonians',
          '1 thess',
          'first thessalonians',
          'i thessalonians',
          '1th'
        ];
      case BibleBook.secondThessalonians:
        return [
          '2 thessalonians',
          '2 thess',
          'second thessalonians',
          'ii thessalonians',
          '2th'
        ];
      case BibleBook.firstTimothy:
        return ['1 timothy', '1 tim', 'first timothy', 'i timothy', '1ti'];
      case BibleBook.secondTimothy:
        return ['2 timothy', '2 tim', 'second timothy', 'ii timothy', '2ti'];
      case BibleBook.firstPeter:
        return ['1 peter', '1 pet', 'first peter', 'i peter', '1pe'];
      case BibleBook.secondPeter:
        return ['2 peter', '2 pet', 'second peter', 'ii peter', '2pe'];
      case BibleBook.firstJohn:
        return ['1 john', 'first john', 'i john', '1jn'];
      case BibleBook.secondJohn:
        return ['2 john', 'second john', 'ii john', '2jn'];
      case BibleBook.thirdJohn:
        return ['3 john', 'third john', 'iii john', '3jn'];
      default:
        // Baseline: full name + OSIS + USFX
        return [fullName, osisId, usfxId];
    }
  }
}

/// Book-set (“canon”) selection. This is often what people loosely call "versification"
/// (i.e., which books exist + ordering).
///
/// True verse-level versification differences require separate datasets.
enum Versification {
  protestant66,
  catholic73,
  orthodoxWider,
  allSupported,
}

extension VersificationBooks on Versification {
  List<BibleBook> get books {
    switch (this) {
      case Versification.protestant66:
        return [
          // OT 39
          BibleBook.genesis, BibleBook.exodus, BibleBook.leviticus,
          BibleBook.numbers,
          BibleBook.deuteronomy, BibleBook.joshua, BibleBook.judges,
          BibleBook.ruth,
          BibleBook.firstSamuel, BibleBook.secondSamuel, BibleBook.firstKings,
          BibleBook.secondKings,
          BibleBook.firstChronicles, BibleBook.secondChronicles, BibleBook.ezra,
          BibleBook.nehemiah,
          BibleBook.esther, BibleBook.job, BibleBook.psalms, BibleBook.proverbs,
          BibleBook.ecclesiastes, BibleBook.songOfSongs, BibleBook.isaiah,
          BibleBook.jeremiah,
          BibleBook.lamentations, BibleBook.ezekiel, BibleBook.daniel,
          BibleBook.hosea,
          BibleBook.joel, BibleBook.amos, BibleBook.obadiah, BibleBook.jonah,
          BibleBook.micah,
          BibleBook.nahum, BibleBook.habakkuk, BibleBook.zephaniah,
          BibleBook.haggai,
          BibleBook.zechariah, BibleBook.malachi,
          // NT 27
          BibleBook.matthew, BibleBook.mark, BibleBook.luke, BibleBook.john,
          BibleBook.acts, BibleBook.romans, BibleBook.firstCorinthians,
          BibleBook.secondCorinthians,
          BibleBook.galatians, BibleBook.ephesians, BibleBook.philippians,
          BibleBook.colossians,
          BibleBook.firstThessalonians, BibleBook.secondThessalonians,
          BibleBook.firstTimothy,
          BibleBook.secondTimothy, BibleBook.titus, BibleBook.philemon,
          BibleBook.hebrews,
          BibleBook.james, BibleBook.firstPeter, BibleBook.secondPeter,
          BibleBook.firstJohn,
          BibleBook.secondJohn, BibleBook.thirdJohn, BibleBook.jude,
          BibleBook.revelation,
        ];

      case Versification.catholic73:
        // Catholic canon typically includes Tobit, Judith, Wisdom, Sirach, Baruch, 1-2 Maccabees
        // plus additions to Esther and Daniel (handled differently across editions).
        return [
          ...Versification.protestant66.books
              .where((b) => b != BibleBook.esther && b != BibleBook.daniel),
          // Reinsert Esther/Daniel as base books, plus additions as separate books
          BibleBook.esther,
          BibleBook.addEsther,
          BibleBook.job,
          BibleBook.psalms,
          BibleBook.proverbs,
          BibleBook.ecclesiastes,
          BibleBook.songOfSongs,
          BibleBook.wisdom,
          BibleBook.sirach,
          BibleBook.isaiah,
          BibleBook.jeremiah,
          BibleBook.lamentations,
          BibleBook.baruch,
          BibleBook.ezekiel,
          BibleBook.daniel,
          BibleBook.prayerOfAzariah,
          BibleBook.susanna,
          BibleBook.belAndTheDragon,
          BibleBook.hosea,
          BibleBook.joel,
          BibleBook.amos,
          BibleBook.obadiah,
          BibleBook.jonah,
          BibleBook.micah,
          BibleBook.nahum,
          BibleBook.habakkuk,
          BibleBook.zephaniah,
          BibleBook.haggai,
          BibleBook.zechariah,
          BibleBook.malachi,
          BibleBook.tobit,
          BibleBook.judith,
          BibleBook.firstMaccabees,
          BibleBook.secondMaccabees,
          // NT
          BibleBook.matthew, BibleBook.mark, BibleBook.luke, BibleBook.john,
          BibleBook.acts, BibleBook.romans, BibleBook.firstCorinthians,
          BibleBook.secondCorinthians,
          BibleBook.galatians, BibleBook.ephesians, BibleBook.philippians,
          BibleBook.colossians,
          BibleBook.firstThessalonians, BibleBook.secondThessalonians,
          BibleBook.firstTimothy,
          BibleBook.secondTimothy, BibleBook.titus, BibleBook.philemon,
          BibleBook.hebrews,
          BibleBook.james, BibleBook.firstPeter, BibleBook.secondPeter,
          BibleBook.firstJohn,
          BibleBook.secondJohn, BibleBook.thirdJohn, BibleBook.jude,
          BibleBook.revelation,
        ];

      case Versification.orthodoxWider:
        // "Wider" set (varies by jurisdiction/edition). Treat as a superset for apps.
        return [
          ...Versification.catholic73.books,
          BibleBook.firstEsdras,
          BibleBook.secondEsdras,
          BibleBook.thirdMaccabees,
          BibleBook.fourthMaccabees,
          BibleBook.prayerOfManasseh,
          BibleBook.psalm151,
        ];

      case Versification.allSupported:
        return BibleBook.values;
    }
  }
}

/// Resolver that can be configured by versification/canon.
/// Builds a prefix index once for fast resolution.
class BibleRefResolver {
  final Versification versification;

  late final Map<String, BibleBook?> _prefixIndex;
  late final Map<String, BibleBook> _byOsis;
  late final Map<String, BibleBook> _byUsfx;
  late final Map<String, BibleBook> _byName;

  BibleRefResolver({this.versification = Versification.allSupported}) {
    final books = versification.books;

    _byOsis = {for (final b in books) b.osisId.toLowerCase(): b};
    _byUsfx = {for (final b in books) b.usfxId.toLowerCase(): b};
    _byName = {for (final b in books) _norm(b.fullName): b};

    _prefixIndex = _buildPrefixIndex(books);
  }

  static BibleRefResolver defaultResolver() =>
      BibleRefResolver(versification: Versification.allSupported);

  /// Resolve to BibleBook using:
  /// 1) exact USFX match
  /// 2) exact OSIS match
  /// 3) exact normalized full name
  /// 4) prefix match across searchKeys
  BibleBook? resolveBook(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;

    final lowerRaw = raw.toLowerCase();
    print('trying to match ---> $lowerRaw');

    // Exact identifiers
    final byUsfx = _byUsfx[lowerRaw];
    if (byUsfx != null) return byUsfx;

    final byOsis = _byOsis[lowerRaw];
    if (byOsis != null) return byOsis;

    final n = _norm(raw);
    final byName = _byName[n];
    if (byName != null) return byName;

    // Prefix key (fast O(1))
    return _prefixIndex[n];
  }

  /// Convenience: resolve to USFX ID (e.g., "Gene" -> "GEN").
  /// Returns null if unknown or ambiguous.
  String? resolveUsfxId(String input) => resolveBook(input)?.usfxId;

  /// Convenience: resolve to OSIS ID (e.g., "Gene" -> "Gen").
  /// Returns null if unknown or ambiguous.
  String? resolveOsisId(String input) => resolveBook(input)?.osisId;

  /// If resolveBook is null, use this to present suggestions.
  List<BibleBook> resolveCandidates(String input, {int limit = 20}) {
    final n = _norm(input);
    if (n.isEmpty) return const [];

    final matches = <BibleBook>[];
    final seen = <BibleBook>{};

    for (final b in versification.books) {
      for (final k in b.searchKeys) {
        if (_norm(k).startsWith(n)) {
          if (seen.add(b)) matches.add(b);
          break;
        }
      }
      if (matches.length >= limit) break;
    }
    return matches;
  }

  // ----------------- internals -----------------

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  static Map<String, BibleBook?> _buildPrefixIndex(List<BibleBook> books) {
    final Map<String, BibleBook?> index = {};

    void markPrefix(String prefix, BibleBook book) {
      final existing = index[prefix];

      // If already ambiguous, keep it ambiguous.
      if (existing == null && index.containsKey(prefix)) return;

      // If no entry yet, assign.
      if (!index.containsKey(prefix)) {
        index[prefix] = book;
        return;
      }

      // If different book, mark ambiguous.
      if (existing != book) {
        index[prefix] = null;
      }
    }

    for (final book in books) {
      for (final key in book.searchKeys) {
        final normalized = _norm(key);
        if (normalized.isEmpty) continue;

        for (int i = 1; i <= normalized.length; i++) {
          markPrefix(normalized.substring(0, i), book);
        }
      }
    }

    return index;
  }
}

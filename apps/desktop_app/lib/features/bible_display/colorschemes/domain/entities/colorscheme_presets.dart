import 'dart:ui';

import 'bible_view_colorscheme.dart';

const kBibleViewColorschemePresets = [
  BibleViewColorscheme.defaultLight,
  BibleViewColorscheme.defaultDark,
  BibleViewColorscheme(
    name: 'midnight',
    label: 'Midnight',
    backgroundColor: Color(0xFF0B1220),
    verseColor: Color(0xFFC9D4E5),
    refColor: Color(0xFF7A8CA8),
    selectedRefColor: Color(0xFF6CB6FF),
    quoteColor: Color(0xFFFF7B72),
    addColor: Color(0xFF8B9BB4),
    strongWordsUnderlineColor: Color(0x666CB6FF),
    pericopeColor: Color(0xFFE6EDF7),
    verseDividerColor: Color(0xFF1E2A3F),
  ),
  // Warm paper look, like a printed Bible. Best for long reading in light mode.
  BibleViewColorscheme(
    name: 'parchment',
    label: 'Parchment',
    backgroundColor: Color(0xFFF4ECD8),
    verseColor: Color(0xFF3B2F25),
    refColor: Color(0xFF7A684E),
    selectedRefColor: Color(0xFF8B3A1D),
    quoteColor: Color(0xFFB3261E),
    addColor: Color(0xFF6F5F4B),
    strongWordsUnderlineColor: Color(0x558B3A1D),
    pericopeColor: Color(0xFF5A4636),
    verseDividerColor: Color(0xFFD9CBAE),
  ),

  // Pure black (OLED / projector friendly) with a warm amber accent.
  BibleViewColorscheme(
    name: 'ember',
    label: 'Ember',
    backgroundColor: Color(0xFF000000),
    verseColor: Color(0xFFD8D0C4),
    refColor: Color(0xFF8A7355),
    selectedRefColor: Color(0xFFFFB454),
    quoteColor: Color(0xFFFF6B5B),
    addColor: Color(0xFF9C9488),
    strongWordsUnderlineColor: Color(0x66FFB454),
    pericopeColor: Color(0xFFF2E6D0),
    verseDividerColor: Color(0xFF222222),
  ),

  // Dark forest green with soft mint highlights. Gentle and natural.
  BibleViewColorscheme(
    name: 'evergreen',
    label: 'Evergreen',
    backgroundColor: Color(0xFF0F1A15),
    verseColor: Color(0xFFCFDCD2),
    refColor: Color(0xFF6E8F7C),
    selectedRefColor: Color(0xFF7FD6A4),
    quoteColor: Color(0xFFF08A6C),
    addColor: Color(0xFF92A89A),
    strongWordsUnderlineColor: Color(0x667FD6A4),
    pericopeColor: Color(0xFFE4EFE7),
    verseDividerColor: Color(0xFF1F3329),
  ),

  // Clean, high-contrast light theme with a crisp blue accent.
  BibleViewColorscheme(
    name: 'daylight',
    label: 'Daylight',
    backgroundColor: Color(0xFFFAFAF7),
    verseColor: Color(0xFF1C1C1E),
    refColor: Color(0xFF6B7280),
    selectedRefColor: Color(0xFF2457D6),
    quoteColor: Color(0xFFC62828),
    addColor: Color(0xFF707070),
    strongWordsUnderlineColor: Color(0x552457D6),
    pericopeColor: Color(0xFF111111),
    verseDividerColor: Color(0xFFE2E2DC),
  ),

  // Arctic slate-blue with frosty cyan (Nord-inspired). Soft, low glare.
  BibleViewColorscheme(
    name: 'nordic',
    label: 'Nordic',
    backgroundColor: Color(0xFF2E3440),
    verseColor: Color(0xFFD8DEE9),
    refColor: Color(0xFF8A97AE),
    selectedRefColor: Color(0xFF88C0D0),
    quoteColor: Color(0xFFE5808A),
    addColor: Color(0xFFA0ABBF),
    strongWordsUnderlineColor: Color(0x6688C0D0),
    pericopeColor: Color(0xFFECEFF4),
    verseDividerColor: Color(0xFF434C5E),
  ),

  // Deep teal with aqua highlights and cream headings (Solarized-inspired).
  BibleViewColorscheme(
    name: 'lagoon',
    label: "Lagoon",
    backgroundColor: Color(0xFF002B36),
    verseColor: Color(0xFFA3B5B8),
    refColor: Color(0xFF75969D),
    selectedRefColor: Color(0xFF4FD1C5),
    quoteColor: Color(0xFFF08A6B),
    addColor: Color(0xFF7F9AA0),
    strongWordsUnderlineColor: Color(0x664FD1C5),
    pericopeColor: Color(0xFFEEE8D5),
    verseDividerColor: Color(0xFF0E4350),
  ),

  // Dark wine-tinted background with rose pink and peach accents.
  BibleViewColorscheme(
    name: 'rosewood',
    label: 'Rosewood',
    backgroundColor: Color(0xFF1A1216),
    verseColor: Color(0xFFE6D4DA),
    refColor: Color(0xFFA0808A),
    selectedRefColor: Color(0xFFF28BA8),
    quoteColor: Color(0xFFFFB88C),
    addColor: Color(0xFFB79AA3),
    strongWordsUnderlineColor: Color(0x66F28BA8),
    pericopeColor: Color(0xFFF8E8ED),
    verseDividerColor: Color(0xFF30202A),
  ),

  // Neutral charcoal, almost monochrome. For people who dislike color.
  BibleViewColorscheme(
    name: 'graphite',
    label: 'Graphite',
    backgroundColor: Color(0xFF1C1C1E),
    verseColor: Color(0xFFCFCFD2),
    refColor: Color(0xFF8E8E93),
    selectedRefColor: Color(0xFFFFFFFF),
    quoteColor: Color(0xFFE5736B),
    addColor: Color(0xFF9A9AA0),
    strongWordsUnderlineColor: Color(0x55FFFFFF),
    pericopeColor: Color(0xFFF2F2F7),
    verseDividerColor: Color(0xFF2C2C2E),
  ),

  // Deep violet-black with neon cyan and hot pink. The fun one.
  BibleViewColorscheme(
    name: 'synthwave',
    label: 'Synthwave',
    backgroundColor: Color(0xFF0D0221),
    verseColor: Color(0xFFE4E0FF),
    refColor: Color(0xFF8076B0),
    selectedRefColor: Color(0xFF00F5D4),
    quoteColor: Color(0xFFFF4FA3),
    addColor: Color(0xFF9D94C9),
    strongWordsUnderlineColor: Color(0x6600F5D4),
    pericopeColor: Color(0xFFFFFFFF),
    verseDividerColor: Color(0xFF241B3D),
  ),

  // Maximum contrast for projectors and big screens: white on black,
  // bright yellow highlight, slightly heavier verse text.
  BibleViewColorscheme(
    name: 'projector',
    label: 'Projector',
    backgroundColor: Color(0xFF000000),
    verseColor: Color(0xFFFFFFFF),
    refColor: Color(0xFFB3B3B3),
    selectedRefColor: Color(0xFFFFD60A),
    quoteColor: Color(0xFFFF6B6B),
    addColor: Color(0xFFD6D6D6),
    strongWordsUnderlineColor: Color(0x80FFD60A),
    pericopeColor: Color(0xFFFFFFFF),
    verseDividerColor: Color(0xFF4D4D4D),
  ),

  // Cool blue-gray paper with a deep teal accent.
  BibleViewColorscheme(
    name: 'mist',
    label: 'Mist',
    backgroundColor: Color(0xFFEEF2F6),
    verseColor: Color(0xFF243142),
    refColor: Color(0xFF5D6D84),
    selectedRefColor: Color(0xFF0F766E),
    quoteColor: Color(0xFFB42318),
    addColor: Color(0xFF5E6E82),
    strongWordsUnderlineColor: Color(0x550F766E),
    pericopeColor: Color(0xFF111C2B),
    verseDividerColor: Color(0xFFD5DDE6),
  ),

  // Pale green background with forest green accents. Fresh and quiet.
  BibleViewColorscheme(
    name: 'mint',
    label: 'Mint',
    backgroundColor: Color(0xFFECF6EF),
    verseColor: Color(0xFF1D3327),
    refColor: Color(0xFF557462),
    selectedRefColor: Color(0xFF15803D),
    quoteColor: Color(0xFFC0392B),
    addColor: Color(0xFF4F6B5A),
    strongWordsUnderlineColor: Color(0x5515803D),
    pericopeColor: Color(0xFF0F2419),
    verseDividerColor: Color(0xFFD3E6D9),
  ),

  // Soft pink paper with magenta highlights and burnt-orange quotes.
  BibleViewColorscheme(
    name: 'blush',
    label: 'Blush',
    backgroundColor: Color(0xFFFCEFF1),
    verseColor: Color(0xFF3B2229),
    refColor: Color(0xFF7E5A64),
    selectedRefColor: Color(0xFFC2185B),
    quoteColor: Color(0xFF9C4A1A),
    addColor: Color(0xFF7A5F66),
    strongWordsUnderlineColor: Color(0x55C2185B),
    pericopeColor: Color(0xFF2B161C),
    verseDividerColor: Color(0xFFF0D6DB),
  ),

  // Light lilac background with a rich purple accent.
  BibleViewColorscheme(
    name: 'lavender',
    label: 'Lavender',
    backgroundColor: Color(0xFFF3F0FA),
    verseColor: Color(0xFF2A2540),
    refColor: Color(0xFF6C6590),
    selectedRefColor: Color(0xFF6D3FD6),
    quoteColor: Color(0xFFB91C4F),
    addColor: Color(0xFF6A6485),
    strongWordsUnderlineColor: Color(0x556D3FD6),
    pericopeColor: Color(0xFF1E1A33),
    verseDividerColor: Color(0xFFE0DAF0),
  ),
];

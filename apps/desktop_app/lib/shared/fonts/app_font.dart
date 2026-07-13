enum FontCategory { serif, sansSerif }

class AppFont {
  final String family;
  final FontCategory category;
  final String? assetPath; // TODO: null = system font

  const AppFont({
    required this.family,
    required this.category,
    this.assetPath,
  });
}

const List<AppFont> kAppFonts = [
  AppFont(family: 'Gelasio', category: FontCategory.serif),
  AppFont(family: 'Merriweather', category: FontCategory.serif),
  AppFont(family: 'General Sans', category: FontCategory.sansSerif),
];

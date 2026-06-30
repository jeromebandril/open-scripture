import 'package:flutter/material.dart';
import '../../shared/fonts/app_font.dart';
import '../../shared/widgets/ui/inputs/app_input_option.dart';

class FontPicker extends StatelessWidget {
  final AppFont selected;
  final ValueChanged<AppFont> onChanged;

  const FontPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final serifs =
        kAppFonts.where((f) => f.category == FontCategory.serif).toList();
    final sansSerifs =
        kAppFonts.where((f) => f.category == FontCategory.sansSerif).toList();

    final dropdownItems = [
      const AppDropdownItem<AppFont>.header(label: 'Serif'),
      ...serifs.map((f) => AppDropdownItem<AppFont>(value: f, label: f.family)),
      const AppDropdownItem<AppFont>.header(label: 'Sans-serif'),
      ...sansSerifs
          .map((f) => AppDropdownItem<AppFont>(value: f, label: f.family)),
    ];

    return AppInputOption<AppFont>(
      value: selected,
      items: dropdownItems,
      onChanged: (font) => font != null ? onChanged(font) : null,
    );
  }
}

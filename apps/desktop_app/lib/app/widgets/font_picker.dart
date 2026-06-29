import 'package:flutter/material.dart';
import 'package:open_scripture/shared/design_system/tokens/tokens.dart';

import '../../shared/fonts/app_font.dart';

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

    return Row(
      spacing: AppSpacing.xs,
      children: [
        Icon(
          Icons.text_fields_rounded,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        Expanded(
          child: DropdownButton<AppFont>(
            value: selected,
            isExpanded: true,
            onChanged: (font) => font != null ? onChanged(font) : null,
            items: [
              ..._groupHeader('Serif'),
              ..._fontItems(serifs),
              ..._groupHeader('Sans-serif'),
              ..._fontItems(sansSerifs),
            ],
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<AppFont>> _groupHeader(String label) => [
        DropdownMenuItem(
          enabled: false,
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ];

  List<DropdownMenuItem<AppFont>> _fontItems(List<AppFont> fonts) => fonts
      .map((font) => DropdownMenuItem(
            value: font,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                font.family,
                style: TextStyle(
                  // fontFamily: font.family,
                  fontSize: 16,
                ),
              ),
            ),
          ))
      .toList();
}

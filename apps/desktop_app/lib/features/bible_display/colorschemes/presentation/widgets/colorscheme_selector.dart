import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../app/extensions/build_context_extensions.dart';
import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../settings/bible_view_settings.dart';
import '../../domain/entities/bible_view_colorscheme.dart';
import '../cubit/colorscheme_cubit.dart';
import 'colorscheme_editor.dart';

class BibleViewColorschemeSelector extends StatelessWidget {
  const BibleViewColorschemeSelector({super.key});

  void _onSelected(BibleViewColorscheme cs, BuildContext ctx) => ctx
      .read<SettingsCubit<BibleViewSettings>>()
      .update((c) => c.copyWith(colorschemeName: cs.name));

  void _onDeleteCustom(BibleViewColorscheme cs, BuildContext ctx) =>
      ctx.read<ColorschemesCubit>().delete(cs.name);

  void _openColorschemeEditor(
    BibleViewColorscheme? initialDraft,
    BuildContext ctx,
  ) =>
      ctx.pushStandardWindow(
        title: 'New custom colorscheme',
        maxSize: const Size(900, 600),
        builder: (_) => ColorschemeEditor(initialDraft: initialDraft),
      );

  @override
  Widget build(BuildContext context) {
    final colorschemes = context.select((ColorschemesCubit c) => c.state.all);

    return _ColorschemeSelector(
      colorschemes: colorschemes,
      selectedName: context.select(
        (SettingsCubit<BibleViewSettings> c) => c.state.colorschemeName,
      ),
      onSelected: (cs) => _onSelected(cs, context),
      onDeleteCustom: (cs) => _onDeleteCustom(cs, context),
      onEditCustom: (cs) => _openColorschemeEditor(cs, context),
      onAddCustom: () => _openColorschemeEditor(null, context),
    );
  }
}

/// Grid selector for [BibleViewColorscheme]s, grouped in Light / Dark / Custom.
///
/// Pass every available colorscheme (presets + the user's custom ones) in
/// [colorschemes]. Grouping is derived from the data:
///   - custom  -> `isCustom` (name starts with `custom_`)
///   - light / dark -> `isDark` (background luminance)
///
/// The Light and Dark sections are hidden when empty. The Custom section is
/// always visible and ends with a "+" placeholder cell that calls
/// [onAddCustom].
///
/// [selectedName] is `settings.colorschemeName`. If it matches nothing, the
/// default colorscheme is highlighted, because that is what is actually in use.
class _ColorschemeSelector extends StatelessWidget {
  static const double kCellWidth = 128;
  static const double kCellHeight = 52;
  static const double kSpacing = AppSpacing.md;
  static const double kSectionSpacing = AppSpacing.xl2;

  final List<BibleViewColorscheme> colorschemes;
  final String selectedName;
  final ValueChanged<BibleViewColorscheme> onSelected;
  final VoidCallback onAddCustom;
  final ValueChanged<BibleViewColorscheme> onDeleteCustom;
  final ValueChanged<BibleViewColorscheme> onEditCustom;

  const _ColorschemeSelector({
    required this.colorschemes,
    required this.selectedName,
    required this.onSelected,
    required this.onAddCustom,
    required this.onDeleteCustom,
    required this.onEditCustom,
  });

  Widget _buildSection(
    String title,
    List<BibleViewColorscheme> schemes,
    String activeName, {
    bool withAddCell = false,
  }) {
    return _Section(
      title: title,
      spacing: kSpacing,
      children: [
        for (final scheme in schemes)
          _ColorschemeCell(
            key: ValueKey(scheme.name),
            scheme: scheme,
            width: kCellWidth,
            isSelected: scheme.name == activeName,
            onTap: () => onSelected(scheme),
            onDeleteCustom: onDeleteCustom,
            onEditCustom: onEditCustom,
          ),
        if (withAddCell) _AddCustomCell(width: kCellWidth, onTap: onAddCustom),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeName =
        BibleViewColorscheme.resolve(selectedName, colorschemes).name;

    final light = colorschemes.where((s) => !s.isCustom && !s.isDark).toList();
    final dark = colorschemes.where((s) => !s.isCustom && s.isDark).toList();
    final custom = colorschemes.where((s) => s.isCustom).toList();

    final sections = <Widget>[
      if (light.isNotEmpty) _buildSection('Light', light, activeName),
      if (dark.isNotEmpty) _buildSection('Dark', dark, activeName),
      _buildSection('Custom', custom, activeName, withAddCell: true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) SizedBox(height: kSectionSpacing),
          sections[i],
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final double spacing;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.spacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children,
        ),
      ],
    );
  }
}

class _ColorschemeCell extends StatefulWidget {
  final BibleViewColorscheme scheme;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<BibleViewColorscheme>? onDeleteCustom;
  final ValueChanged<BibleViewColorscheme>? onEditCustom;

  const _ColorschemeCell({
    super.key,
    required this.scheme,
    required this.width,
    required this.isSelected,
    required this.onTap,
    this.onDeleteCustom,
    this.onEditCustom,
  });

  @override
  State<_ColorschemeCell> createState() => _ColorschemeCellState();
}

class _ColorschemeCellState extends State<_ColorschemeCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    // The colors that define the scheme
    final swatches = <Color>[
      widget.scheme.verseColor,
      widget.scheme.pericopeColor,
      widget.scheme.selectedRefColor,
      widget.scheme.refColor,
      widget.scheme.quoteColor,
      widget.scheme.addColor,
    ];

    return SizedBox(
      width: widget.width,
      child: Semantics(
        button: true,
        selected: widget.isSelected,
        label: widget.scheme.label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onHover: (isHovered) => setState(() => _isHovered = isHovered),
            borderRadius: BorderRadius.circular(AppRadius.lg + 2),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Preview: background color + color swatches
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: _ColorschemeSelector.kCellHeight,
                    decoration: BoxDecoration(
                      color: widget.scheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        width: 2,
                        color: widget.isSelected
                            ? accent
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 3,
                            children: [
                              for (var i = 0; i < swatches.length; i++)
                                _Swatch(color: swatches[i]),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 90,
                            height: 1.5,
                            color: widget.scheme.verseDividerColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!_isHovered || !widget.scheme.isCustom)
                    const SizedBox(height: 8),
                  // Label
                  AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    child: _isHovered && widget.scheme.isCustom
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    widget.onEditCustom?.call(widget.scheme),
                                icon: const Icon(LucideIcons.edit),
                              ),
                              IconButton(
                                onPressed: () =>
                                    widget.onDeleteCustom?.call(widget.scheme),
                                icon: const Icon(LucideIcons.trash),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.isSelected) ...[
                                Icon(Icons.check_rounded,
                                    size: 14, color: accent),
                                const SizedBox(width: 4),
                              ],
                              Flexible(
                                child: Text(
                                  widget.scheme.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: widget.isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: widget.isSelected ? accent : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddCustomCell extends StatelessWidget {
  final double width;
  final VoidCallback onTap;

  const _AddCustomCell({required this.width, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return SizedBox(
      width: width,
      child: Semantics(
        button: true,
        label: 'Add custom colorscheme',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: _ColorschemeSelector.kCellHeight,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withAlpha(10),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        width: 2,
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.add_rounded, size: 28, color: muted),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add custom',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;

  const _Swatch({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 24,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4)),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/ui/inputs/app_input_text.dart';

class _SettingsSurface extends StatelessWidget {
  const _SettingsSurface({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: padding,
      child: child,
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({this.title, this.addInfo, this.trailing});

  final String? title;
  final String? addInfo;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (title == null && addInfo == null && trailing == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding:
          const EdgeInsets.only(left: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            title ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          if (addInfo != null) ...[
            const SizedBox(width: AppSpacing.md),
            Tooltip(message: addInfo, child: Icon(Icons.info_outline))
          ],
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// The loading / error / empty / list-of-items body shared by every
/// lazily-built settings list.
///
/// [shrinkWrap] true sizes the list to its content (a card in a scrollable
/// page); false lets it fill whatever bounded height its parent gives it
/// (a panel meant to occupy the rest of the screen).
class _SettingsListBody extends StatelessWidget {
  const _SettingsListBody({
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.isLoading = false,
    this.isError = false,
    this.errorPlaceholder,
    this.emptyPlaceholder,
    this.shrinkWrap = true,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool isLoading;
  final bool isError;
  final Widget? errorPlaceholder;
  final Widget? emptyPlaceholder;
  final bool shrinkWrap;

  static Widget _defaultSeparator(BuildContext context, int index) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (isError) {
      return Center(child: errorPlaceholder ?? const Text('Error'));
    }
    if (itemCount == 0) {
      return Center(child: emptyPlaceholder ?? const Text('Empty'));
    }

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder ?? _defaultSeparator,
    );
  }
}

// ---------------------------------------------------------------------------
// SettingSection. It's a card sized to its content. Use inside a scrollable
// settings page.
// ---------------------------------------------------------------------------

class SettingSection extends StatelessWidget {
  /// A static list of [children], optionally next to a [sideChild]
  /// (e.g. a live preview of the setting being edited).
  const SettingSection({
    super.key,
    this.title,
    required this.children,
    this.sideChild,
    this.actions,
  })  : itemCount = null,
        itemBuilder = null,
        isLoading = false,
        isError = false,
        errorPlaceholder = null,
        emptyPlaceholder = null,
        child = null;

  /// A lazily built list, with loading / error / empty handling.
  const SettingSection.builder({
    super.key,
    this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.isLoading = false,
    this.isError = false,
    this.errorPlaceholder,
    this.emptyPlaceholder,
    this.actions,
  })  : children = null,
        sideChild = null,
        child = null;

  /// A single custom [child]
  const SettingSection.single({
    super.key,
    this.title,
    required this.child,
    this.actions,
  })  : children = null,
        sideChild = null,
        itemCount = null,
        itemBuilder = null,
        isLoading = false,
        isError = false,
        errorPlaceholder = null,
        emptyPlaceholder = null;

  final String? title;
  final List<Widget>? actions;

  // default constructor
  final List<Widget>? children;
  final Widget? sideChild;

  // .builder
  final int? itemCount;
  final NullableIndexedWidgetBuilder? itemBuilder;
  final bool isLoading;
  final bool isError;
  final Widget? errorPlaceholder;
  final Widget? emptyPlaceholder;

  // .single
  final Widget? child;

  List<Widget> _withDividers(List<Widget> items) {
    if (items.isEmpty) return const [];
    return [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(),
          ),
        items[i],
      ],
    ];
  }

  Widget _body() {
    if (child != null) return child!;

    if (itemBuilder != null) {
      return _SettingsListBody(
        itemCount: itemCount!,
        itemBuilder: itemBuilder!,
        isLoading: isLoading,
        isError: isError,
        errorPlaceholder: errorPlaceholder,
        emptyPlaceholder: emptyPlaceholder,
      );
    }

    final list = Column(children: _withDividers(children!));
    if (sideChild == null) return list;

    return Row(
      spacing: AppSpacing.xl,
      children: [
        Expanded(flex: 2, child: list),
        Expanded(child: sideChild!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || actions != null) ...[
          const SizedBox(height: AppSpacing.lg),
          _SettingsHeader(
            title: title,
            trailing: actions != null
                ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        _SettingsSurface(child: _body()),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// SettingListSection. It fills the remaining height of its
// parent. The caller must give it a bounded height (e.g. wrap it in
// `Expanded` inside an outer Column) since its list uses `Expanded`
// internally.
// ---------------------------------------------------------------------------

class SettingListSection extends StatelessWidget {
  const SettingListSection({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.subtitle,
    this.isLoading = false,
    this.isError = false,
    this.errorPlaceholder,
    this.emptyListPlaceholder,
    this.separatorBuilder,
    this.onFilter,
    this.filterInitValue,
  });

  final String title;
  final String? subtitle;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool isLoading;
  final bool isError;
  final Widget? emptyListPlaceholder;
  final Widget? errorPlaceholder;
  final ValueChanged<String>? onFilter;
  final String? filterInitValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        _SettingsHeader(
          title: title,
          addInfo: subtitle,
          trailing: onFilter != null
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: AppInputText(
                    hint: 'Filter',
                    prefixIcon: Icons.search,
                    value: filterInitValue,
                    debounce: const Duration(milliseconds: 500),
                    onChanged: onFilter,
                  ),
                )
              : null,
        ),
        Expanded(
          child: _SettingsSurface(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: _SettingsListBody(
                itemCount: itemCount,
                itemBuilder: itemBuilder,
                separatorBuilder: separatorBuilder,
                isLoading: isLoading,
                isError: isError,
                errorPlaceholder: errorPlaceholder,
                emptyPlaceholder: emptyListPlaceholder,
                shrinkWrap: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

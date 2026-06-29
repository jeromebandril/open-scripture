import 'package:flutter/material.dart';
import 'package:open_scripture/shared/design_system/design_system.dart';
import 'package:open_scripture/shared/widgets/dropdown_menu_anchor.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.leading,
    this.enabled = true,
  });

  const AppDropdownItem.header({
    required this.label,
  })  : value = null,
        leading = null,
        enabled = false;

  final T? value;
  final String label;
  final Widget? leading;
  final bool enabled;
}

class AppInputOption<T> extends StatefulWidget {
  const AppInputOption({
    super.key,
    required this.items,
    this.value,
    this.hint,
    this.onChanged,
    this.enabled = true,
    this.maxMenuHeight = 240,
    this.leading,
  });

  final List<AppDropdownItem<T>> items;
  final T? value;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final double maxMenuHeight;
  final Widget? leading;

  @override
  State<AppInputOption<T>> createState() => _AppInputOptionState<T>();
}

class _AppInputOptionState<T> extends State<AppInputOption<T>> {
  final _menuVisible = ValueNotifier<bool>(false);
  final _triggerKey = GlobalKey();

  @override
  void dispose() {
    _menuVisible.dispose();
    super.dispose();
  }

  AppDropdownItem<T>? get _selected =>
      widget.items.where((i) => i.value == widget.value).firstOrNull;

  double get _triggerWidth {
    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.size.width ?? 200;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _menuVisible,
      builder: (context, isOpen, _) {
        return DropdownMenuAnchor(
          menuColor: Theme.of(context).inputDecorationTheme.fillColor,
          menuVisible: _menuVisible,
          menuWidth: _triggerWidth,
          menuHeight: widget.maxMenuHeight,
          trigger: _DropdownTrigger(
            key: _triggerKey,
            leading: widget.leading,
            label: _selected?.label,
            hint: widget.hint,
            enabled: widget.enabled,
            isOpen: isOpen,
            onTap: widget.enabled
                ? () => _menuVisible.value = !_menuVisible.value
                : null,
          ),
          menuContent: _DropdownMenu<T>(
            items: widget.items,
            selected: widget.value,
            onSelect: (item) {
              widget.onChanged?.call(item.value);
              _menuVisible.value = false;
            },
          ),
        );
      },
    );
  }
}

class _DropdownTrigger extends StatelessWidget {
  const _DropdownTrigger({
    super.key,
    this.label,
    this.hint,
    required this.isOpen,
    required this.enabled,
    this.onTap,
    this.leading,
  });

  final String? label;
  final String? hint;
  final bool isOpen;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          isFocused: isOpen,
          isEmpty: label == null,
          decoration: InputDecoration(
            enabled: enabled,
            hintText: hint,
            prefix: leading,
            suffixIcon: AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 100),
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
          child: label != null
              ? Text(label!, style: theme.textTheme.bodyMedium)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _DropdownMenu<T> extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    this.selected,
    required this.onSelect,
  });

  final List<AppDropdownItem<T>> items;
  final T? selected;
  final ValueChanged<AppDropdownItem<T>> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        if (!item.enabled && item.value == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              item.label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
          );
        }

        final isSelected = item.value == selected;

        return ListTile(
          dense: true,
          selected: isSelected,
          leading: item.leading,
          title: Text(item.label),
          trailing: isSelected ? const Icon(Icons.check, size: 16) : null,
          onTap: item.enabled ? () => onSelect(item) : null,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../dropdown_menu_anchor.dart';

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

/// A single- or multi-select input dropdown.
///
/// Use the default constructor for single selection
/// and [AppInputOption.multiple] for multi selection.
class AppInputOption<T> extends StatefulWidget {
  /// Single-selection dropdown.
  const AppInputOption({
    super.key,
    required this.items,
    this.value,
    this.hint,
    this.onChanged,
    this.enabled = true,
    this.maxMenuHeight = 240,
    this.leading,
    this.validator,
    this.invalidSelectionMessage = "That selection isn't allowed.",
  })  : multiple = false,
        values = const [],
        onValuesChanged = null,
        valuesValidator = null,
        selectedLabelBuilder = null,
        numOfItemsInLabel = null,
        closeOnSelect = true;

  /// Multi-selection dropdown. The menu stays open after each tap by
  /// default so the user can pick several items in a row; set
  /// [closeOnSelect] to `true` to close it after every tap instead.
  const AppInputOption.multiple({
    super.key,
    required this.items,
    this.values = const [],
    this.hint,
    this.onValuesChanged,
    this.enabled = true,
    this.maxMenuHeight = 240,
    this.leading,
    this.selectedLabelBuilder,
    this.numOfItemsInLabel = 2,
    this.closeOnSelect = false,
    this.valuesValidator,
    this.invalidSelectionMessage = "That selection isn't allowed.",
  })  : multiple = true,
        value = null,
        onChanged = null,
        validator = null;

  final List<AppDropdownItem<T>> items;
  final String? hint;
  final bool enabled;
  final double maxMenuHeight;
  final Widget? leading;
  final bool multiple;

  // When Single-select
  final T? value;
  final ValueChanged<T?>? onChanged;

  // When Multi-select
  final List<T> values;
  final ValueChanged<List<T>>? onValuesChanged;
  final bool closeOnSelect;

  /// override for how the trigger summarizes the current
  /// selection when [multiple] is true. Defaults to a comma-separated
  /// list of labels, or "N selected" once more than [numOfItemsInLabel] are picked.
  final String Function(List<AppDropdownItem<T>> selectedItems)?
      selectedLabelBuilder;

  final int? numOfItemsInLabel;

  /// Gate for single-select. Called with the value the user just tapped,
  /// *before* it is committed. Return `true` to accept it and fire
  /// [onChanged], or `false` to reject the tap (nothing changes and
  /// [onChanged] never fires).
  final bool Function(T? candidate)? validator;

  /// Gate for multi-select. Called with what the full selection *would
  /// become* after the tapped item is added/removed, before it is
  /// committed. Return `true` to accept it and fire [onValuesChanged],
  /// or `false` to reject the tap and leave the selection as it was.
  final bool Function(List<T> candidate)? valuesValidator;

  /// Shown under the field, using the same error styling your theme
  /// already gives `InputDecoration.errorText`, whenever [validator] or
  /// [valuesValidator] rejects a tap. Pass `null` to reject silently
  /// with no visible message.
  final String? invalidSelectionMessage;

  @override
  State<AppInputOption<T>> createState() => _AppInputOptionState<T>();
}

class _AppInputOptionState<T> extends State<AppInputOption<T>> {
  final _menuVisible = ValueNotifier<bool>(false);
  final _triggerKey = GlobalKey();
  String? _error;

  @override
  void initState() {
    super.initState();
    _menuVisible.addListener(_clearErrorOnClose);
  }

  @override
  void dispose() {
    _menuVisible.removeListener(_clearErrorOnClose);
    _menuVisible.dispose();
    super.dispose();
  }

  void _clearErrorOnClose() {
    if (!_menuVisible.value) _clearError();
  }

  void _rejectSelection() {
    if (widget.invalidSelectionMessage == _error) return;
    setState(() => _error = widget.invalidSelectionMessage);
  }

  void _clearError() {
    if (_error != null) setState(() => _error = null);
  }

  AppDropdownItem<T>? get _selectedItem =>
      widget.items.where((i) => i.value == widget.value).firstOrNull;

  List<AppDropdownItem<T>> get _selectedItems => widget.items
      .where((i) => i.value != null && widget.values.contains(i.value))
      .toList();

  double get _triggerWidth {
    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.size.width ?? 200;
  }

  void _handleSelect(AppDropdownItem<T> item) {
    if (!widget.multiple) {
      final candidate = item.value;
      if (widget.validator != null && !widget.validator!(candidate)) {
        _rejectSelection();
        return;
      }
      _clearError();
      widget.onChanged?.call(candidate);
      _menuVisible.value = false;
      return;
    }

    final value = item.value;
    if (value == null) return;

    final updated = List<T>.from(widget.values);
    if (updated.contains(value)) {
      updated.remove(value);
    } else {
      updated.add(value);
    }

    if (widget.valuesValidator != null && !widget.valuesValidator!(updated)) {
      _rejectSelection();
      return;
    }
    _clearError();

    widget.onValuesChanged?.call(updated);

    if (widget.closeOnSelect) {
      _menuVisible.value = false;
    }
  }

  String? _triggerLabel(List<AppDropdownItem<T>> selected) {
    if (selected.isEmpty) return null;
    if (!widget.multiple) return selected.first.label;

    if (widget.selectedLabelBuilder != null) {
      return widget.selectedLabelBuilder!(selected);
    }
    if (selected.length <= widget.numOfItemsInLabel!) {
      return selected.map((e) => e.label).join(', ');
    }
    return '${selected.length} selected';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _menuVisible,
      builder: (context, isOpen, _) {
        final selected = widget.multiple
            ? _selectedItems
            : (_selectedItem != null
                ? [_selectedItem!]
                : <AppDropdownItem<T>>[]);

        return DropdownMenuAnchor(
          menuColor: Theme.of(context).inputDecorationTheme.fillColor,
          menuVisible: _menuVisible,
          menuWidth: _triggerWidth,
          menuHeight: widget.maxMenuHeight,
          trigger: _DropdownTrigger(
            key: _triggerKey,
            leading: widget.leading ??
                (selected.length == 1 ? selected.first.leading : null),
            label: _triggerLabel(selected),
            hint: widget.hint,
            enabled: widget.enabled,
            isOpen: isOpen,
            errorText: _error,
            onTap: widget.enabled
                ? () => _menuVisible.value = !_menuVisible.value
                : null,
          ),
          menuContent: _DropdownMenu<T>(
            items: widget.items,
            multiple: widget.multiple,
            selected: widget.value,
            selectedValues: widget.multiple ? widget.values.toSet() : const {},
            onSelect: _handleSelect,
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
    this.errorText,
  });

  final String? label;
  final String? hint;
  final bool isOpen;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? leading;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          isFocused: isOpen,
          isEmpty: false,
          decoration: InputDecoration(
            enabled: enabled,
            errorText: errorText,
            errorMaxLines: 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: label != null
                    ? Text(
                        label!,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        hint ?? '',
                        style: theme.inputDecorationTheme.hintStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              color: theme.disabledColor,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 100),
                child: const Icon(Icons.keyboard_arrow_down, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenu<T> extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    required this.multiple,
    this.selected,
    this.selectedValues = const {},
    required this.onSelect,
  });

  final List<AppDropdownItem<T>> items;
  final bool multiple;
  final T? selected;
  final Set<T> selectedValues;
  final ValueChanged<AppDropdownItem<T>> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding:
          const EdgeInsets.symmetric(vertical: AppSpacing.xs + AppSpacing.xs),
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

        final isSelected = multiple
            ? (item.value != null && selectedValues.contains(item.value))
            : item.value == selected;

        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs2, horizontal: AppSpacing.sm),
          selected: isSelected,
          leading: multiple
              ? _MultiSelectLeading(checked: isSelected, icon: item.leading)
              : item.leading,
          title: Text(item.label),
          trailing: !multiple && isSelected
              ? const Icon(Icons.check, size: 16)
              : null,
          onTap: item.enabled ? () => onSelect(item) : null,
        );
      },
    );
  }
}

class _MultiSelectLeading extends StatelessWidget {
  const _MultiSelectLeading({
    required this.checked,
    this.icon,
  });

  final bool checked;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: IgnorePointer(
            child: Checkbox(
              value: checked,
              onChanged: (_) {},
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        if (icon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          icon!,
        ],
      ],
    );
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../design_system/design_system.dart';
import '../../dropdown_menu_anchor.dart';

class PathInput extends StatefulWidget {
  final String? label;
  final String? initialPath;
  final String placeholder;
  final bool selectDirectory;
  final ValueChanged<String>? onPathChanged;
  final List<String>? allowedExtensions;

  const PathInput({
    super.key,
    this.label,
    this.initialPath,
    this.placeholder = 'No path selected',
    this.selectDirectory = true,
    this.onPathChanged,
    this.allowedExtensions,
  });

  @override
  State<PathInput> createState() => _PathInputState();
}

class _PathInputState extends State<PathInput> {
  late String _currentPath;
  final _menuVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _currentPath = widget.initialPath ?? '';
  }

  @override
  void dispose() {
    _menuVisible.dispose();
    super.dispose();
  }

  void _confirm(String path) {
    final trimmed = path.trim();
    if (!pathExists(trimmed)) return;
    setState(() => _currentPath = trimmed);
    widget.onPathChanged?.call(trimmed);
    _menuVisible.value = false;
  }

  Future<void> _browse() async {
    String? picked;

    if (widget.selectDirectory) {
      picked = await FilePicker.getDirectoryPath(
        initialDirectory: _currentPath.isNotEmpty && pathExists(_currentPath)
            ? _currentPath
            : null,
        lockParentWindow: true,
      );
    } else {
      final result = await FilePicker.pickFiles(
        initialDirectory: _currentPath.isNotEmpty && pathExists(_currentPath)
            ? _currentPath
            : null,
        lockParentWindow: true,
        type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: widget.allowedExtensions,
      );
      picked = result?.files.single.path;
    }

    if (picked != null) _confirm(picked);
  }

  bool pathExists(String path) =>
      FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;

  @override
  Widget build(BuildContext context) {
    return DropdownMenuAnchor(
      menuAlignment: Alignment.topRight,
      menuVisible: _menuVisible,
      menuWidth: 420,
      menuHeight: 230,
      menuGap: 6,
      trigger: _PathField(
        path: _currentPath,
        placeholder: widget.placeholder,
        selectDirectory: widget.selectDirectory,
        isOpen: _menuVisible.value,
        onTap: () => _menuVisible.value = !_menuVisible.value,
      ),
      menuContent: _PathPopup(
        initialValue: _currentPath,
        selectDirectory: widget.selectDirectory,
        onBrowse: _browse,
        onConfirm: _confirm,
        onCancel: () => _menuVisible.value = false,
      ),
    );
  }
}

class _PathField extends StatelessWidget {
  const _PathField({
    required this.path,
    required this.placeholder,
    required this.selectDirectory,
    required this.isOpen,
    this.onTap,
  });

  final String path;
  final String placeholder;
  final bool selectDirectory;
  final bool isOpen;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        isFocused: isOpen,
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: Icon(
            selectDirectory
                ? Icons.folder_outlined
                : Icons.insert_drive_file_outlined,
            size: 15,
          ),
          suffixIcon: const Icon(Icons.unfold_more, size: 14),
        ),
        child: path.isNotEmpty
            ? Text(
                path,
                style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _PathPopup extends StatefulWidget {
  final String initialValue;
  final bool selectDirectory;
  final VoidCallback onBrowse;
  final ValueChanged<String> onConfirm;
  final VoidCallback onCancel;

  const _PathPopup({
    required this.initialValue,
    required this.selectDirectory,
    required this.onBrowse,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_PathPopup> createState() => _PathPopupState();
}

class _PathPopupState extends State<_PathPopup> {
  late final TextEditingController _ctrl;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _ctrl.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _ctrl.text.length,
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          widget.onCancel();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.selectDirectory
                      ? Icons.folder_open_outlined
                      : Icons.file_open_outlined,
                  size: 15,
                  color: cs.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.selectDirectory
                      ? 'Set directory path'
                      : 'Set file path',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 15,
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    focusNode: _focusNode,
                    onSubmitted: widget.onConfirm,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: AppTypography.fontFamilyMono,
                      letterSpacing: 0,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.selectDirectory
                          ? r'e.g. C:\Users\me\Documents'
                          : r'e.g. C:\Users\me\file.txt',
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: AppTypography.fontFamilyMono,
                      ),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _ctrl,
                        builder: (_, val, __) => val.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 14),
                                onPressed: () => _ctrl.clear(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: widget.onBrowse,
                  icon:
                      const Icon(Icons.drive_folder_upload_outlined, size: 15),
                  label: const Text('Browse'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: () => widget.onConfirm(_ctrl.text),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_scripture/shared/widgets/dropdown_menu_anchor.dart';

/// Displays the current path in a compact field. On click it opens a
/// floating panel (overlay) anchored below the field where the user can
/// type a path manually or browse via the OS file/folder picker.
///
/// ## Dependencies
/// Add to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   file_picker: ^8.0.0
/// ```
///
/// ## Usage
/// ```dart
/// PathInput(
///   label: 'Output folder',
///   initialPath: r'C:\Users\me\Documents',
///   selectDirectory: true,
///   onPathChanged: (path) => print('New path: $path'),
/// )
/// ```
class PathInput extends StatefulWidget {
  /// Optional label rendered above the field.
  final String? label;

  /// The initial path value.
  final String? initialPath;

  /// Placeholder text shown when no path is set.
  final String placeholder;

  /// When `true` (default) the browse button opens a folder picker.
  /// When `false` it opens a file picker.
  final bool selectDirectory;

  /// Called whenever the path is confirmed (Enter, Confirm button, or browse).
  final ValueChanged<String>? onPathChanged;

  /// Optional file-type filters used when [selectDirectory] is `false`.
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

    if (picked != null) {
      _confirm(picked);
    }
  }

  bool pathExists(String path) {
    return FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
  }

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
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOpen ? cs.primary : cs.outline,
            width: isOpen ? 1.5 : 1.0,
          ),
          boxShadow: isOpen
              ? [
                  BoxShadow(
                      color: cs.primary.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 1))
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              selectDirectory
                  ? Icons.folder_outlined
                  : Icons.insert_drive_file_outlined,
              size: 15,
              color:
                  path.isNotEmpty ? cs.primary : cs.onSurface.withOpacity(0.35),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                path.isNotEmpty ? path : placeholder,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: path.isNotEmpty
                      ? cs.onSurface
                      : cs.onSurface.withOpacity(0.38),
                  letterSpacing: 0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.unfold_more,
                size: 14, color: cs.onSurface.withOpacity(0.35)),
          ],
        ),
      ),
    );
  }
}

// Popup panel

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
    // Auto-focus & select all text for quick editing
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
      child: Material(
        elevation: 6,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              // Header
              //
              Row(
                children: [
                  Icon(
                    widget.selectDirectory
                        ? Icons.folder_open_outlined
                        : Icons.file_open_outlined,
                    size: 15,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.selectDirectory
                        ? 'Set directory path'
                        : 'Set file path',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Subtle close button
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 15,
                      onPressed: widget.onCancel,
                      icon: const Icon(Icons.close),
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //
              // Text field + Browse
              //
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focusNode,
                      onSubmitted: widget.onConfirm,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.selectDirectory
                            ? r'e.g. C:\Users\me\Documents'
                            : r'e.g. C:\Users\me\file.txt',
                        hintStyle: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.35),
                          fontFamily: 'monospace',
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _ctrl,
                          builder: (_, val, __) => val.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 14),
                                  onPressed: () => _ctrl.clear(),
                                  color: cs.onSurface.withOpacity(0.4),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: widget.onBrowse,
                    icon: const Icon(Icons.drive_folder_upload_outlined,
                        size: 15),
                    label: const Text('Browse'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      textStyle: theme.textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              //
              // Actions
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => widget.onConfirm(_ctrl.text),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

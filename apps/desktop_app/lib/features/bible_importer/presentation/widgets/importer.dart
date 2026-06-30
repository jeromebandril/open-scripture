import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/enums/bible_repository_type.dart';
import '../state/bible_importer_cubit/bible_importer_cubit.dart';

class ImporterWidget extends StatelessWidget {
  const ImporterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleImporterCubit, BibleImporterState>(
      builder: (context, state) {
        return _XmlImportDropZoneUi(
          isDragOver: false,
          isLoading: state.status == BibleImporterStatus.running,
          errorText: state.errorMessage,
          onChoosePressed: () {
            context.read<BibleImporterCubit>().pickFile();
          },
        );
      },
    );
  }
}

class _XmlImportDropZoneUi extends StatelessWidget {
  const _XmlImportDropZoneUi({
    required this.isDragOver,
    required this.isLoading,
    this.fileName,
    this.errorText,
    this.hintText = 'Drop an a file here, or click to choose',
    this.height = 180,
    this.onChoosePressed,
    this.onTap,
    this.onDragEnter,
    this.onDragLeave,
    this.onDrop,
  });

  final bool isDragOver;
  final bool isLoading;
  final String? fileName;
  final String? errorText;

  final String hintText;
  final double height;

  final VoidCallback? onChoosePressed;
  final VoidCallback? onTap;
  final VoidCallback? onDragEnter;
  final VoidCallback? onDragLeave;

  final ValueChanged<Object?>? onDrop;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final borderColor =
        isDragOver ? cs.primary : Theme.of(context).dividerColor;
    final bg = isDragOver ? cs.primary.withValues(alpha: 0.06) : cs.surface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : (onTap ?? onChoosePressed),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Stack(
            children: [
              // Content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: 42,
                      color: isDragOver ? cs.primary : cs.onSurfaceVariant,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      hintText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    if (fileName != null) ...[
                      Text(
                        'Selected: $fileName',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (errorText != null) ...[
                      Text(
                        errorText!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.error),
                      ),
                      const SizedBox(height: 6),
                    ],
                    TextButton.icon(
                      onPressed: isLoading ? null : onChoosePressed,
                      icon: const Icon(Icons.folder_open),
                      label:
                          BlocBuilder<BibleImporterCubit, BibleImporterState>(
                        builder: (context, state) {
                          if (state.targetType == BibleRepositoryType.sword) {
                            return const Text(
                                'Choose a valid ZIP file from the official Crosswire Repository');
                          }
                          return const Text('Choose a ZIP or XML file');
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (isLoading)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

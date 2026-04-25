import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_importer/presentation/state/bible_importer_cubit.dart';

import '../../../../injection_container.dart';

class ImporterWidget extends StatelessWidget {
  const ImporterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BibleImporterCubit>(),
      child: Center(
        child: BlocBuilder<BibleImporterCubit, BibleImporterState>(
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
        ),
      ),
    );
  }
}

class _XmlImportDropZoneUi extends StatelessWidget {
  const _XmlImportDropZoneUi({
    super.key,
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

  /// Driven by BLoC (visual only)
  final bool isDragOver;
  final bool isLoading;
  final String? fileName;
  final String? errorText;

  final String hintText;
  final double height;

  /// UI callbacks (dispatch events to BLoC)
  final VoidCallback? onChoosePressed;
  final VoidCallback? onTap;
  final VoidCallback? onDragEnter;
  final VoidCallback? onDragLeave;

  /// "Drop happened" callback (you decide the payload type in your platform layer)
  /// e.g. pass bytes / path / html.File, etc.
  final ValueChanged<Object?>? onDrop;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final borderColor =
        isDragOver ? cs.primary : Theme.of(context).dividerColor;
    final bg = isDragOver ? cs.primary.withOpacity(0.06) : cs.surface;

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
                      label: const Text('Choose a ZIP or XML file'),
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (isLoading)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surface.withOpacity(0.65),
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

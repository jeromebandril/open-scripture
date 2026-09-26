import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/ui/inputs/app_input_text.dart';
import '../../domain/entities/slide_data.dart';
import '../cubit/presenter_cubit.dart';
import '../pages/presenter_settings_page.dart';

class SlidesEditor extends StatefulWidget {
  const SlidesEditor({
    super.key,
    this.initialSlides = const [],
    required this.onApply,
  });

  final List<SlideData> initialSlides;
  final ValueChanged<List<SlideData>> onApply;

  @override
  State<SlidesEditor> createState() => _SlidesEditorState();
}

class _SlidesEditorState extends State<SlidesEditor> {
  late List<SlideData> _slides;

  @override
  void initState() {
    super.initState();

    _slides = widget.initialSlides.isEmpty
        ? [_newSlide()]
        : List.of(widget.initialSlides);
  }

  SlideData _newSlide() {
    return SlideData(
      id: UniqueKey().toString(),
      title: '',
    );
  }

  void _addSlide() {
    if (_slides.length >= PresenterCubit.kLimitNumOfSlides) return;
    setState(() {
      _slides.add(_newSlide());
    });
  }

  void _removeSlide(int index) {
    setState(() {
      _slides.removeAt(index);
    });
  }

  void _updateSlide(
    int index, {
    String? title,
    String? subtitle,
  }) {
    setState(() {
      _slides[index] = _slides[index].copyWith(
        title: title,
        subtitle: () => subtitle,
      );
    });
  }

  void _reorderSlides(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      final slide = _slides.removeAt(oldIndex);
      _slides.insert(newIndex, slide);
    });
  }

  void _apply() => widget.onApply(List.unmodifiable(_slides));

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(
          flex: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xl,
            children: [
              SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () =>
                            context.read<PresenterCubit>().loadDemoData(),
                        child: Text('Load demo data'))
                  ],
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: _slides.length,
                  buildDefaultDragHandles: false,
                  onReorderItem: _reorderSlides,
                  footer: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xs),
                        OutlinedButton.icon(
                          onPressed: _addSlide,
                          icon: const Icon(Icons.add),
                          label: const Text('Add slide'),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];

                    return SlideInput(
                      key: ValueKey(slide.id),
                      index: index,
                      slide: slide,
                      dragHandle: ReorderableDragStartListener(
                        index: index,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(LucideIcons.gripHorizontal),
                        ),
                      ),
                      onChanged: ({String? title, String? subtitle}) {
                        _updateSlide(index, title: title, subtitle: subtitle);
                      },
                      onRemove: () => _removeSlide(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Expanded(child: PresenterSettingsPage()),
              ElevatedButton(
                onPressed: _apply,
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SlideInput extends StatefulWidget {
  const SlideInput({
    super.key,
    required this.index,
    required this.slide,
    required this.onChanged,
    required this.onRemove,
    required this.dragHandle,
  });

  final int index;
  final SlideData slide;

  final void Function({
    String title,
    String? subtitle,
  }) onChanged;

  final VoidCallback onRemove;
  final Widget dragHandle;

  @override
  State<SlideInput> createState() => _SlideInputState();
}

class _SlideInputState extends State<SlideInput> {
  bool isExtended = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  widget.dragHandle,
                  const SizedBox(width: 4),
                  Text(
                    'Slide ${widget.index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => setState(() => isExtended = !isExtended),
                    icon: isExtended
                        ? const Icon(LucideIcons.chevronUp)
                        : const Icon(LucideIcons.chevronDown),
                    tooltip: "Add more",
                  ),
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(LucideIcons.trash),
                    tooltip: "Remove",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppInputText(
                label: "Title",
                key: ValueKey('${widget.slide.id}-title'),
                value: widget.slide.title,
                onChanged: (value) => widget.onChanged(title: value),
              ),
              const SizedBox(height: 10),
              AppInputText(
                label: "Subtitle",
                key: ValueKey('${widget.slide.id}-subtitle'),
                value: widget.slide.subtitle,
                maxLines: 3,
                onChanged: (value) =>
                    widget.onChanged(subtitle: value.isEmpty ? null : value),
                // maxLines: 2,
              ),
              if (isExtended) ...[
                // const SizedBox(height: 10),
                // Row(
                //   spacing: 10,
                //   children: [
                //     Expanded(
                //       child: AppInputText(
                //         label: "Top Left",
                //         key: ValueKey('${widget.slide.id}-title'),
                //         value: _title,
                //         onChanged: (value) => widget.onChanged(title: value),
                //       ),
                //     ),
                //     Expanded(
                //       child: AppInputText(
                //         label: "Top Right",
                //         key: ValueKey('${widget.slide.id}-subtitle'),
                //         value: _subtitle,
                //         onChanged: (value) => widget.onChanged(
                //             subtitle: value.isEmpty ? null : value),
                //         // maxLines: 2,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   spacing: 10,
                //   children: [
                //     Expanded(
                //       child: AppInputText(
                //         label: "Bottom Left",
                //         key: ValueKey('${widget.slide.id}-title'),
                //         value: _title,
                //         onChanged: (value) => widget.onChanged(title: value),
                //       ),
                //     ),
                //     Expanded(
                //       child: AppInputText(
                //         label: "Bottom Right",
                //         key: ValueKey('${widget.slide.id}-subtitle'),
                //         value: _subtitle,
                //         onChanged: (value) => widget.onChanged(
                //             subtitle: value.isEmpty ? null : value),
                //         // maxLines: 2,
                //       ),
                //     ),
                //   ],
                // )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

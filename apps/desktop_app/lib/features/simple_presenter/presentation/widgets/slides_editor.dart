import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/ui/inputs/app_input_text.dart';
import '../../domain/entities/slide_data.dart';

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
    setState(() {
      _slides.add(_newSlide());
    });
  }

  void _removeSlide(int index) {
    if (_slides.length <= 1) return;

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
        subtitle: subtitle,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ReorderableListView.builder(
            itemCount: _slides.length,
            buildDefaultDragHandles: false,
            onReorderItem: _reorderSlides,
            itemBuilder: (context, index) {
              final slide = _slides[index];

              return SlideInput(
                key: ValueKey(slide.id),
                index: index,
                slide: slide,
                canRemove: _slides.length > 1,
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
        Row(
          spacing: 4,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _addSlide,
                icon: const Icon(Icons.add),
                label: const Text('Add slide'),
              ),
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: _apply, child: const Text('Apply'))),
          ],
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
    required this.canRemove,
    required this.dragHandle,
  });

  final int index;
  final SlideData slide;

  final void Function({
    String? title,
    String? subtitle,
  }) onChanged;

  final VoidCallback onRemove;
  final bool canRemove;
  final Widget dragHandle;

  @override
  State<SlideInput> createState() => _SlideInputState();
}

class _SlideInputState extends State<SlideInput> {
  String _title = '';
  String? _subtitle;

  @override
  void initState() {
    super.initState();
    _title = widget.slide.title;
    _subtitle = widget.slide.subtitle;
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
                  if (widget.canRemove)
                    IconButton(
                      onPressed: widget.onRemove,
                      icon: const Icon(LucideIcons.trash),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              AppInputText(
                key: ValueKey('${widget.slide.id}-title'),
                value: _title,
                onChanged: (value) => widget.onChanged(title: value),
              ),
              const SizedBox(height: 10),
              AppInputText(
                key: ValueKey('${widget.slide.id}-subtitle'),
                value: _subtitle,
                onChanged: (value) =>
                    widget.onChanged(subtitle: value.isEmpty ? null : value),
                // maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

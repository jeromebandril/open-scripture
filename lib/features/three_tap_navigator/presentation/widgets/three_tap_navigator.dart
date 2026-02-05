import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/cubit/three_tap_navigator_cubit.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../injection_container.dart';

class ThreeTapNavigatorTrigger extends StatefulWidget {
  const ThreeTapNavigatorTrigger({super.key});

  @override
  State<ThreeTapNavigatorTrigger> createState() =>
      _ThreeTapNavigatorTriggerState();
}

class _ThreeTapNavigatorTriggerState extends State<ThreeTapNavigatorTrigger> {
  final _controller = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final double _menuGap = 5;

  Widget _buildOverlay(BuildContext context, OverlayChildLayoutInfo info) {
    final screen = MediaQuery.of(context).size;
    final top = info.childSize.height + _menuGap;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _controller.hide();
            },
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, top), // place under anchor
          child: BlockSemantics(
            blocking: true,
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                    screen.width,
                    screen.height * .3,
                  )),
                  //
                  // Here the custom widget
                  //
                  child: _ThreeTapNavigatorOverlay(
                    onEnd: () => _controller.hide(),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ThreeTapNavigatorCubit>(),
      child: BlocBuilder<PaneManagerCubit, PaneManagerState>(
        builder: (context, state) {
          return BlocBuilder<BSearchbarBloc, BSearchbarState>(
            builder: (context, state) {
              return CompositedTransformTarget(
                link: _layerLink,
                child: OverlayPortal.overlayChildLayoutBuilder(
                  controller: _controller,
                  overlayChildBuilder: _buildOverlay,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    surfaceTintColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    child: InkWell(
                      onTap: () => _controller.show(),
                      mouseCursor: SystemMouseCursors.click,
                      child: SizedBox(
                        width: 100,
                        height: 48,
                        child: Center(
                          child: MouseRegion(
                            child: Text(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              state.referenceResult.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ThreeTapNavigatorOverlay extends StatefulWidget {
  const _ThreeTapNavigatorOverlay({this.onEnd});

  final void Function()? onEnd;

  @override
  State<_ThreeTapNavigatorOverlay> createState() =>
      _ThreeTapNavigatorOverlayState();
}

class _ThreeTapNavigatorOverlayState extends State<_ThreeTapNavigatorOverlay> {
  Book? book;
  int? chpt;

  int _turn() {
    if (book == null && chpt == null) return 0;
    if (book != null && chpt == null) return 1;
    return 2;
  }

  Color _highlightTurn(int currTurn, int turn) {
    if (currTurn == turn) {
      return Theme.of(context).colorScheme.primary;
    }

    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  @override
  void initState() {
    super.initState();

    final bibleId = context.read<PaneManagerCubit>().activeBloc().state.bibleId;
    context.read<ThreeTapNavigatorCubit>().loadBooks(bibleId);
  }

  @override
  Widget build(BuildContext context) {
    int turn = _turn();
    final bloc = context.read<ThreeTapNavigatorCubit>();

    return BlocBuilder<ThreeTapNavigatorCubit, ThreeTapNavigatorState>(
      builder: (context, state) {
        return Column(
          spacing: 14,
          children: [
            SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    TextButton(
                        onPressed: () => setState(() => book = null),
                        child: Text(
                          style: TextStyle(color: _highlightTurn(turn, 0)),
                          textAlign: TextAlign.center,
                          'Book',
                        )),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                    TextButton(
                        onPressed: () => setState(() => chpt = null),
                        child: Text(
                          style: TextStyle(color: _highlightTurn(turn, 1)),
                          textAlign: TextAlign.center,
                          'Chapter',
                        )),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          style: TextStyle(color: _highlightTurn(turn, 2)),
                          textAlign: TextAlign.center,
                          'Verse',
                        )),
                  ],
                )),
            Expanded(
              child: Stack(
                children: [
                  if (turn == 0)
                    _GridSelector<Book>(
                      items: state.books
                          .map((b) =>
                              _GridSelectorItem(value: b, text: b.usfxId!))
                          .toList(),
                      onSelect: (b) {
                        setState(() => book = b);
                        bloc.getMaxChapter(b.id!);
                      },
                    ),
                  if (turn == 1)
                    _GridSelector<int>(
                      items: List.generate(
                          state.maxChapter,
                          (i) => _GridSelectorItem(
                              value: i + 1, text: '${i + 1}')),
                      onSelect: (c) {
                        setState(() => chpt = c);
                        bloc.getMaxVerse(book!.id!, c);
                      },
                    ),
                  if (turn == 2)
                    _GridSelector<int>(
                      items: List.generate(
                          state.maxVerse,
                          (i) => _GridSelectorItem(
                              value: i + 1, text: '${i + 1}')),
                      onSelect: (v) {
                        context.read<BSearchbarBloc>().add(
                            BSearchbarParseIntent(
                                '${book!.shortName} $chpt:$v'));
                        widget.onEnd?.call();
                      },
                    )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GridSelectorItem<T> {
  final T value;
  final String text;

  _GridSelectorItem({required this.value, required this.text});
}

class _GridSelector<T> extends StatelessWidget {
  const _GridSelector({
    this.onSelect,
    required this.items,
  });

  final List<_GridSelectorItem<T>> items;
  final Function(T)? onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // number of columns
        childAspectRatio: 50 / 25,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GridTile(
          child: TextButton(
            onPressed: () => onSelect?.call(items[index].value),
            child: Text(
              items[index].text,
              style: TextStyle(),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/core/infrastructure/book_resolver/book_resolver.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/state/search_bloc.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';
import 'package:open_scripture/shared/theme/tokens.dart';
import 'package:open_scripture/shared/widgets/custom_icon_button.dart';

import '../../../../shared/entities/book.dart';
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
              context
                  .read<InterfaceVisibilityCubit>()
                  .setVisibility(threeTapNav: false);
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
                borderRadius: BorderRadius.circular(AppRadius.md),
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
                    onEnd: () => context
                        .read<InterfaceVisibilityCubit>()
                        .setVisibility(threeTapNav: false),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterfaceVisibilityCubit, InterfaceVisibilityState>(
      listenWhen: (prev, curr) =>
          prev.is3TapNavVisible != curr.is3TapNavVisible,
      listener: (context, state) {
        state.is3TapNavVisible ? _controller.show() : _controller.hide();
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: OverlayPortal.overlayChildLayoutBuilder(
          controller: _controller,
          overlayChildBuilder: _buildOverlay,
          child: CustomIconButton(
            Icons.navigation_rounded,
            onTap: () =>
                context.read<InterfaceVisibilityCubit>().toggle3TapNav(),
          ),
        ),
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
  late final int? bibleId;

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

    // here there is a temporary fix for parallel views where
    // I set the books from the first opened bible
    //TODO: Make an union of books from all bibles
    final openedBibles = context
        .read<MultiPaneManagerCubit>()
        .activePane()
        .bloc
        .state
        .openedBiblesIds;

    bibleId = openedBibles.isEmpty ? null : openedBibles.first;
    context.read<ThreeTapNavigatorCubit>().loadBooks(bibleId);
  }

  @override
  Widget build(BuildContext context) {
    int turn = _turn();
    final bloc = context.read<ThreeTapNavigatorCubit>();
    final resolver = sl<BibleRefResolver>();

    return bibleId == null
        ? Center(child: Text('Open a bible first'))
        : BlocBuilder<ThreeTapNavigatorCubit, ThreeTapNavigatorState>(
            builder: (context, state) {
              if (state.status == ThreeTapNavigatorStatus.error) {
                return Center(child: Text('Open a bible first'));
              }

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
                              onPressed: () => setState(() {
                                    book = null;
                                    chpt = null;
                                  }),
                              child: Text(
                                style:
                                    TextStyle(color: _highlightTurn(turn, 0)),
                                textAlign: TextAlign.center,
                                book?.shortName ?? 'Book',
                              )),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                          TextButton(
                              onPressed: () => setState(() => chpt = null),
                              child: Text(
                                style:
                                    TextStyle(color: _highlightTurn(turn, 1)),
                                textAlign: TextAlign.center,
                                'Chapter ${chpt ?? ''}',
                              )),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                style:
                                    TextStyle(color: _highlightTurn(turn, 2)),
                                textAlign: TextAlign.center,
                                'Verse ',
                              )),
                        ],
                      )),
                  Expanded(
                    child: Stack(
                      children: [
                        if (turn == 0)
                          _GridSelector<Book>(
                            items: state.books
                                .map((b) => _GridSelectorItem(
                                      value: b,
                                      text: b.usfxId!,
                                      color: () {
                                        final t = resolver.getGroup(b.usfxId!);

                                        if (t == 'OT') {
                                          return Theme.of(context)
                                              .colorScheme
                                              .tertiary;
                                        } else if (t == 'NT') {
                                          return Theme.of(context)
                                              .colorScheme
                                              .primary;
                                        } else {
                                          return Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant;
                                        }
                                      }.call(),
                                    ))
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
                              context.read<SearchBloc>().add(SearchParseIntent(
                                  '${book!.usfxId} $chpt:$v'));
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
  final Color? color;

  _GridSelectorItem({required this.value, required this.text, this.color});
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
            style: TextButton.styleFrom(
              foregroundColor:
                  items[index].color ?? Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.zero,
            ),
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

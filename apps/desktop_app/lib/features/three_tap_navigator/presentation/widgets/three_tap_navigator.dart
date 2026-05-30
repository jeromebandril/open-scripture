import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/state/search_bloc.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/localized_book.dart';
import 'package:open_scripture/shared/widgets/custom_icon_button.dart';
import 'package:open_scripture/shared/widgets/dropdown_menu_anchor.dart';

class ThreeTapNavigatorTrigger extends StatefulWidget {
  const ThreeTapNavigatorTrigger({super.key});

  @override
  State<ThreeTapNavigatorTrigger> createState() =>
      _ThreeTapNavigatorTriggerState();
}

class _ThreeTapNavigatorTriggerState extends State<ThreeTapNavigatorTrigger> {
  late final ValueNotifier<bool> _menuVisible;

  @override
  void initState() {
    super.initState();
    final v = context.read<InterfaceVisibilityCubit>().state.isToolMenuVisible;
    _menuVisible = ValueNotifier(v);
  }

  @override
  void dispose() {
    _menuVisible.dispose();
    super.dispose();
  }

  void _dismiss() {
    context.read<InterfaceVisibilityCubit>().setVisibility(threeTapNav: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterfaceVisibilityCubit, InterfaceVisibilityState>(
      listenWhen: (prev, curr) =>
          prev.is3TapNavVisible != curr.is3TapNavVisible,
      listener: (context, state) => _menuVisible.value = state.is3TapNavVisible,
      child: DropdownMenuAnchor(
        trigger: CustomIconButton(
          Icons.navigation_rounded,
          onTap: () => context.read<InterfaceVisibilityCubit>().toggle3TapNav(),
        ),
        onDismiss: _dismiss,
        menuWidth: 500,
        menuHeightFraction: .3,
        menuVisible: _menuVisible,
        menuContent: _ThreeTapNavigatorOverlay(
          onEnd: _dismiss,
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
  LocalizedBook? book;
  int? chpt;
  late final BibleId? bibleId;

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
                          _GridSelector<LocalizedBook>(
                            items: state.books
                                .map((b) => _GridSelectorItem(
                                      value: b,
                                      text: b.book.usfm,
                                      color: () {
                                        final t = b.book.testament;

                                        if (t == Testament.oldTestament) {
                                          return Theme.of(context)
                                              .colorScheme
                                              .tertiary;
                                        } else if (t ==
                                            Testament.newTestament) {
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
                              bloc.getChapterBoundary(b.book.usfm);
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
                              bloc.getVerseBoundary(book!.book.usfm, c);
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
                                  '${book!.book.usfm} $chpt:$v'));
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

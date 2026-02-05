import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/book_names.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';

import '../../../../injection_container.dart';

class ThreeTapNavigator extends StatefulWidget {
  const ThreeTapNavigator({super.key});

  @override
  State<ThreeTapNavigator> createState() => _ThreeTapNavigatorState();
}

class _ThreeTapNavigatorState extends State<ThreeTapNavigator> {
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
                  child: _ThreeTapNavigatora(
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
    return BlocBuilder<PaneManagerCubit, PaneManagerState>(
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
    );
  }
}

class _ThreeTapNavigatora extends StatefulWidget {
  const _ThreeTapNavigatora({this.onEnd});

  final void Function()? onEnd;

  @override
  State<_ThreeTapNavigatora> createState() => _ThreeTapNavigatoraState();
}

class _ThreeTapNavigatoraState extends State<_ThreeTapNavigatora> {
  String? book;
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
  Widget build(BuildContext context) {
    int turn = _turn();

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
                _BookGrid(onSelect: (b) => setState(() => book = b)),
              if (turn == 1)
                _ChapterGrid(onSelect: (c) => setState(() => chpt = c)),
              if (turn == 2)
                _ChapterGrid(onSelect: (v) {
                  context
                      .read<BSearchbarBloc>()
                      .add(BSearchbarParseIntent('$book $chpt:$v'));
                  widget.onEnd?.call();
                })
            ],
          ),
        ),
      ],
    );
  }
}

class _BookGrid extends StatelessWidget {
  const _BookGrid({super.key, this.onSelect});

  final Function(String bookOsisId)? onSelect;

  @override
  Widget build(BuildContext context) {
    final resolver = sl<BibleRefResolver>();

    final books = resolver.versification.books;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // number of columns
        childAspectRatio: 50 / 25,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final value = books.elementAt(index);
        return GridTile(
            child: TextButton(
          onPressed: () => onSelect?.call(value.usfxId),
          child: Text(
            value.usfxId,
            style: TextStyle(
              color: index <= 39
                  ? null
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ));
      },
    );
  }
}

class _ChapterGrid extends StatelessWidget {
  const _ChapterGrid({this.onSelect});

  final Function(int chapter)? onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // number of columns
        childAspectRatio: 50 / 25,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        return GridTile(
            child: TextButton(
          onPressed: () => onSelect?.call(index + 1),
          child: Text(
            (index + 1).toString(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ));
      },
    );
  }
}

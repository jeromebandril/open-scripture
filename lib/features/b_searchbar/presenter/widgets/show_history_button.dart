import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import '../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../bloc/b_searchbar_bloc.dart';
import '../models/history_data.dart';

class ShowHistoryButton extends StatelessWidget {
  ShowHistoryButton({super.key});

  final _controller = OverlayPortalController();
  final LayerLink layerLink = LayerLink();
  final double menuGap = 5;

  Widget _buildOverlay(Size screenSize) {
    return BlocBuilder<BSearchbarBloc, BSearchbarState>(
      buildWhen: (prev, curr) => prev.history != curr.history,
      builder: (context, state) {
        return BlockSemantics(
          blocking: true,
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(Size(
                screenSize.width,
                screenSize.height * .2,
              )),
              child: state.history.isEmpty
                  ? Center(child: Text('Empty'))
                  : ListView.builder(
                      itemCount: state.history.length,
                      itemBuilder: (_, i) {
                        return _HistoryItem(
                          index: i,
                          historyData: state.history[i],
                          onPressed: () => _controller.hide(),
                        );
                      }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: OverlayPortal.overlayChildLayoutBuilder(
        controller: _controller,
        overlayChildBuilder: (BuildContext context, info) {
          final screen = MediaQuery.of(context).size;
          final top = info.childSize.height + menuGap;

          return Stack(
            children: [
              // Full-screen barrier for outside taps
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _controller.hide();
                  },
                ),
              ),
              CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, top), // place under anchor
                child: _buildOverlay(screen),
              ),
            ],
          );
        },
        child: IconButton(
            onPressed: () =>
                _controller.isShowing ? _controller.hide() : _controller.show(),
            tooltip: 'History',
            icon: const Icon(Icons.history)),
      ),
    );
  }
}

class _HistoryItem extends StatefulWidget {
  const _HistoryItem({
    required this.index,
    required this.historyData,
    this.onPressed,
  });

  final int index;
  final HistoryData historyData;
  final Function()? onPressed;

  @override
  State<_HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<_HistoryItem> {
  bool _isDelBtnVisible = false;

  @override
  Widget build(BuildContext context) {
    String time = '${widget.historyData.time.hour.toString().padLeft(2, '0')}:'
        '${widget.historyData.time.minute.toString().padLeft(2, '0')}:'
        '${widget.historyData.time.second.toString().padLeft(2, '0')}';

    return MouseRegion(
      onEnter: (_) => setState(() => _isDelBtnVisible = true),
      onExit: (_) => setState(() => _isDelBtnVisible = false),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                context.read<PaneManagerCubit>().activeBloc().add(
                      BiblePaneDisplayChapter(ref: widget.historyData.ref),
                    );
                widget.onPressed?.call();
              },
              child: Row(
                spacing: 12,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'monospace'),
                  ),
                  Text(
                    widget.historyData.ref.toString(),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
            if (_isDelBtnVisible)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.remove_circle, size: 18),
                onPressed: () => context
                    .read<BSearchbarBloc>()
                    .add(DeleteHistoryItem(widget.index)),
              )
          ],
        ),
      ),
    );
  }
}

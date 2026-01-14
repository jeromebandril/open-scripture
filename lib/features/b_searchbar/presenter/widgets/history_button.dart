import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';

import '../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';

class HistoryButton extends StatefulWidget {
  const HistoryButton({super.key});

  @override
  State<HistoryButton> createState() => _HistoryButtonState();
}

class _HistoryButtonState extends State<HistoryButton> {
  OverlayEntry? entry;
  final LayerLink layerLink = LayerLink();
  final int menuGap = 5;

  void _showOverlay() {
    final screen = MediaQuery.of(context).size;
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    // final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
        // Capture *the app’s* inherited theme widgets from the button’s context.
        builder: (ctx) => InheritedTheme.captureAll(
              context,
              Stack(
                children: [
                  // Full-screen barrier for outside taps
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _hideOverlay();
                      },
                    ),
                  ),
                  CompositedTransformFollower(
                    link: layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0, size.height + menuGap),
                    child: _buildOverlay(screen),
                  ),
                ],
              ),
            ));
    overlay.insert(entry!);
  }

  void _hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  Widget _buildOverlay(Size screenSize) {
    final history = context.read<BSearchbarBloc>().state.history;

    return BlockSemantics(
      blocking: true,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[350],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(Size(
            screenSize.width,
            screenSize.height * .2,
          )),
          child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (_, i) {
                return TextButton(
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                  onPressed: () {
                    context.read<PaneManagerCubit>().activeBloc().add(
                          BiblePaneDisplayChapter(
                            ref: history[i],
                            withSpans: true,
                          ),
                        );
                    _hideOverlay();
                  },
                  child: Text(history[i].toString()),
                );
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: IconButton(
          onPressed: () {
            if (entry == null) {
              _showOverlay();
            } else {
              _hideOverlay();
            }
          },
          icon: const Icon(Icons.history)),
    );
  }
}

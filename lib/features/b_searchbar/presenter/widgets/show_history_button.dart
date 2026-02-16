import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/presentation/cubit/history_visibility_cubit.dart';
import 'package:open_scripture/features/b_searchbar/presenter/widgets/parts/history_list_overlay.dart';

class ShowHistoryButton extends StatelessWidget {
  ShowHistoryButton({super.key});

  final _controller = OverlayPortalController();
  final LayerLink layerLink = LayerLink();
  final double menuGap = 5;

  Widget _buildOverlay(Size screenSize) {
    return HistoryListOverlay(constraints: screenSize);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryVisibilityCubit, bool>(
      listener: (context, isVisible) {
        isVisible ? _controller.show() : _controller.hide();
      },
      child: CompositedTransformTarget(
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
                      context.read<HistoryVisibilityCubit>().toggle();
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
              onPressed: () => context.read<HistoryVisibilityCubit>().toggle(),
              tooltip: 'History',
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.history,
                size: 20,
              )),
        ),
      ),
    );
  }
}

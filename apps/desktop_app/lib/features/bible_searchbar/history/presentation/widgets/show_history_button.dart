import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/history/presentation/widgets/history_list_overlay.dart';

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
    return BlocListener<InterfaceVisibilityCubit, InterfaceVisibilityState>(
      listenWhen: (prev, curr) =>
          prev.isHistoryVisible != curr.isHistoryVisible,
      listener: (context, state) {
        state.isHistoryVisible ? _controller.show() : _controller.hide();
      },
      child: Builder(builder: (context) {
        final isVisible =
            context.read<InterfaceVisibilityCubit>().state.isHistoryVisible;

        WidgetsBinding.instance.addPostFrameCallback(
          (_) => isVisible ? _controller.show() : _controller.hide(),
        );

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
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        context
                            .read<InterfaceVisibilityCubit>()
                            .toggleHistory();
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
                    context.read<InterfaceVisibilityCubit>().toggleHistory(),
                // tooltip: 'History',
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.history,
                  size: 20,
                )),
          ),
        );
      }),
    );
  }
}

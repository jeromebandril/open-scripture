import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bible_pane/presentation/widgets/bible_pane_widget.dart';
import '../cubit/pane_manager_cubit.dart';

class MultipleBiblePanes extends StatelessWidget {
  const MultipleBiblePanes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaneManagerCubit, PaneManagerState>(
      builder: (context, state) {
        return Row(
          children: [
            for (final p in state.panes)
              Expanded(
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (_) =>
                      context.read<PaneManagerCubit>().setActive(p.id),
                  child: BiblePane(
                    uniqueId: p.id,
                    bloc: context.read<PaneManagerCubit>().blocFor(p.id),
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  // void moveFocusRight(context) {
  //   print("> Splitviewer: change focus to RIGHT");
  //   BlocProvider.of<SplitScreenBloc>(context).add(
  //     const SplitScreenMoveFocus(direction: 'RIGHT'),
  //   );
  // }

  // void moveFocusLeft(context) {
  //   print("> Splitviewer: change focus to LEFT");
  //   BlocProvider.of<SplitScreenBloc>(context).add(
  //     const SplitScreenMoveFocus(direction: 'LEFT'),
  //   );
  // }

  // void setFocus(id, context) {
  //   print("> Splitviewer: change focus to $id");
  //   BlocProvider.of<SplitScreenBloc>(context).add(
  //     SplitScreenMoveFocus(id: id),
  //   );
  // }
}

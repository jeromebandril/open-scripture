import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/bible_pane_theme.dart';

import '../../../../customizer/presentation/cubit/customizer_cubit.dart';
import '../../../bible_pane/presentation/widgets/bible_pane_widget.dart';
import '../cubit/pane_manager_cubit.dart';

class MultipleBiblePanes extends StatelessWidget {
  const MultipleBiblePanes({super.key});

  @override
  Widget build(BuildContext context) {
    final enableCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final biblePaneTheme = Theme.of(context).extension<BiblePaneTheme>()!;

    return BlocBuilder<PaneManagerCubit, PaneManagerState>(
      builder: (context, state) {
        return DefaultTextStyle.merge(
          style: TextStyle(fontFamily: biblePaneTheme.fontFamily),
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: enableCustom
                  ? biblePaneTheme.backgroundColor
                  : Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              spacing: 16,
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
            ),
          ),
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

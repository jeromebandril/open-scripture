import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/bloc/split_screen_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/widgets/bible_view.dart';

import '../../../searchbar/presenter/widgets/bible_searchbar.dart';

// TODO: layout with fibonacci ratio

class SplitScreenContainer extends StatelessWidget {
  final Widget child;

  const SplitScreenContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(
          LogicalKeyboardKey.arrowRight,
          control: true,
        ): () => moveFocusRight(context),
        const SingleActivator(
          LogicalKeyboardKey.arrowLeft,
          control: true,
        ): () => moveFocusLeft(context)
      },
      child: Focus(
        autofocus: true,
        child: BlocListener<BSearchbarBloc, BSearchbarState>(
          listenWhen: (prevState, newState) =>
              newState.status == BSearchbarStatus.success,
          listener: (context, state) {
            print("> Splitview: input received");
            print(
              "> Splitview: proceeding to forward input to view ${state.referenceResult}",
            );
            BlocProvider.of<SplitScreenBloc>(context).add(
              SplitScreenSendSignal(data: state.referenceResult),
            );
          },
          child: BlocBuilder<SplitScreenBloc, SplitScreenState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOPBAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BSearchbar(items: []),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<SplitScreenBloc>(context)
                              .add(const SplitScreenX());
                        },
                        child: Text("add X split ${state.conf.horizontal}"),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     BlocProvider.of<SplitScreenBloc>(context)
                      //         .add(const SplitScreenY());
                      //   },
                      //   child: Text("add Y split ${state.conf.vertical}"),
                      // ),
                      Text('focused id: ${state.focusedId}'),
                    ],
                  ),
                  // HORIZONTAL SPLITVIEW
                  Expanded(
                    child: Row(
                      children: [
                        for (int i = 0; i < state.conf.horizontal.length; i++)
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.deferToChild,
                              onTap: () {
                                print("> Widget: tapped $i");
                                setFocus(
                                  state.conf.horizontal[i],
                                  context,
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2)),
                                  color: state.conf.horizontal[i] ==
                                          state.focusedId
                                      ? const Color.fromRGBO(200, 200, 200, 0.5)
                                      : Colors.white30,
                                ),
                                child: BibleView(
                                  uniqueId: state.conf.horizontal[i],
                                  items: const [],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),

                  // VERTICAL
                  // for (int i = 0; i < state.conf.vertical.length; i++)
                  //   Expanded(
                  //     child: Container(
                  //       decoration: const BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(24)),
                  //         color: Colors.amber,
                  //       ),
                  //     ),
                  //   )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void moveFocusRight(context) {
    print("> Splitviewer: change focus to RIGHT");
    BlocProvider.of<SplitScreenBloc>(context).add(
      const SplitScreenMoveFocus(direction: 'RIGHT'),
    );
  }

  void moveFocusLeft(context) {
    print("> Splitviewer: change focus to LEFT");
    BlocProvider.of<SplitScreenBloc>(context).add(
      const SplitScreenMoveFocus(direction: 'LEFT'),
    );
  }

  void setFocus(id, context) {
    print("> Splitviewer: change focus to $id");
    BlocProvider.of<SplitScreenBloc>(context).add(
      SplitScreenMoveFocus(id: id),
    );
  }
}

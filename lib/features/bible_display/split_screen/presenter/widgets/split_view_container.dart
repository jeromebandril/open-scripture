// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../b_searchbar/presenter/widgets/bible_searchbar.dart';
// import '../../../bible_pane/presentation/widgets/bible_pane.dart';
// import '../bloc/split_screen_bloc.dart';

// // TODO: layout with fibonacci ratio

// class SplitScreenContainer extends StatelessWidget {
//   final Widget child;

//   const SplitScreenContainer({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return CallbackShortcuts(
//       bindings: <ShortcutActivator, VoidCallback>{
//         const SingleActivator(
//           LogicalKeyboardKey.arrowRight,
//           control: true,
//         ): () => moveFocusRight(context),
//         const SingleActivator(
//           LogicalKeyboardKey.arrowLeft,
//           control: true,
//         ): () => moveFocusLeft(context)
//       },
//       child: Focus(
//         autofocus: true,
//         child: BlocBuilder<SplitScreenBloc, SplitScreenState>(
//           // buildWhen: (_, state) {
//           //   print(state.status);
//           //   return state.status == SplitStatus.success;
//           // },
//           builder: (context, state) {
//             print(state.conf.horizontal.length);
//             return Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // TOPBAR
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const BSearchbar(items: []),
//                     TextButton(
//                       onPressed: () {
//                         BlocProvider.of<SplitScreenBloc>(context)
//                             .add(const SplitScreenX());
//                       },
//                       child: Text("add X split ${state.conf.horizontal}"),
//                     ),
//                     // TextButton(
//                     //   onPressed: () {
//                     //     BlocProvider.of<SplitScreenBloc>(context)
//                     //         .add(const SplitScreenY());
//                     //   },
//                     //   child: Text("add Y split ${state.conf.vertical}"),
//                     // ),
//                     Text('focused id: ${state.focusedId}'),
//                   ],
//                 ),
//                 //
//                 // HORIZONTAL SPLITVIEW
//                 //
//                 Expanded(
//                   child: Row(
//                     children: [
//                       for (int i = 0; i < state.conf.horizontal.length; i++)
//                         Expanded(
//                           key: ValueKey(i),
//                           child: GestureDetector(
//                             behavior: HitTestBehavior.deferToChild,
//                             onTap: () {
//                               print("> Widget: tapped $i");
//                               setFocus(
//                                 state.conf.horizontal[i],
//                                 context,
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(2)),
//                                 color: state.conf.horizontal[i] ==
//                                         state.focusedId
//                                     ? const Color.fromRGBO(200, 200, 200, 0.2)
//                                     : Colors.white30,
//                               ),
//                               child: BiblePane(
//                                 key: ValueKey(i),
//                                 uniqueId: state.conf.horizontal[i],
//                               ),
//                             ),
//                           ),
//                         )
//                     ],
//                   ),
//                 ),

//                 // VERTICAL
//                 // for (int i = 0; i < state.conf.vertical.length; i++)
//                 //   Expanded(
//                 //     child: Container(
//                 //       decoration: const BoxDecoration(
//                 //         borderRadius: BorderRadius.all(Radius.circular(24)),
//                 //         color: Colors.amber,
//                 //       ),
//                 //     ),
//                 //   )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void moveFocusRight(context) {
//     print("> Splitviewer: change focus to RIGHT");
//     BlocProvider.of<SplitScreenBloc>(context).add(
//       const SplitScreenMoveFocus(direction: 'RIGHT'),
//     );
//   }

//   void moveFocusLeft(context) {
//     print("> Splitviewer: change focus to LEFT");
//     BlocProvider.of<SplitScreenBloc>(context).add(
//       const SplitScreenMoveFocus(direction: 'LEFT'),
//     );
//   }

//   void setFocus(id, context) {
//     print("> Splitviewer: change focus to $id");
//     BlocProvider.of<SplitScreenBloc>(context).add(
//       SplitScreenMoveFocus(id: id),
//     );
//   }
// }

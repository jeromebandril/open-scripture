// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:open_scripture/shared/domain/entities/bible_book.dart';
// import 'package:open_scripture/features/bible_display/bible_pane/domain/display_mode.dart';
// import 'package:open_scripture/features/customizer/presentation/models/bible_view_presentation_theme.dart';

// import '../../../../shared/domain/entities/bible_ref.dart';
// import '../../../../core/di/injection_container.dart';
// import '../../../bible_display/bible_pane/presentation/rendering/verse_richtext_builder.dart';
// import '../../../bible_display/bible_pane/presentation/widgets/verse_divider.dart';
// import '../../data/models/preview_data.dart';
// import '../state/customizer_cubit.dart';
// import '../models/bible_pane_general_theme.dart';
// import '../models/bible_view_list_theme.dart';

// class BiblePanePreview extends StatelessWidget {
//   const BiblePanePreview({super.key, required this.mode});

//   final DisplayMode mode;

//   @override
//   Widget build(BuildContext context) {
//     final useCustom = context.select(
//       (CustomizerCubit c) => c.state.pane.enableCustomTheme,
//     );
//     final biblePaneTheme =
//         Theme.of(context).extension<BiblePaneGeneralTheme>()!;

//     return Column(
//       spacing: 4,
//       children: [
//         // Text(
//         //   'Preview',
//         //   style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12),
//         // ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: !useCustom
//                 ? Theme.of(context).colorScheme.surface
//                 : biblePaneTheme.backgroundColor,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: useCustom
//                       ? biblePaneTheme.backgroundColor
//                       : Theme.of(context).colorScheme.surface,
//                 ),
//                 padding: EdgeInsets.all(8),
//                 child: DefaultTextStyle.merge(
//                   style: TextStyle(fontFamily: biblePaneTheme.textFont),
//                   child: mode == DisplayMode.list
//                       ? ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: previewData.length,
//                           itemBuilder: (_, i) {
//                             return _VerseWidgetPreview(
//                               verseNumber: previewData[i].verseNumber,
//                               segments: previewData[i].segments,
//                               spans: previewData[i].spans,
//                               isHighlighted: i == 0,
//                             );
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return VerseDivider();
//                           },
//                         )
//                       : _BibleViewPresentationPreview(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _VerseWidgetPreview extends StatelessWidget {
//   final int verseNumber;
//   final List<VerseSegment> segments;
//   final List<VerseSpan>? spans;
//   final bool isHighlighted;

//   const _VerseWidgetPreview({
//     required this.verseNumber,
//     required this.segments,
//     this.spans,
//     this.isHighlighted = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final String content = segments.map((e) => e.text).join();
//     final BibleRef ref = segments.first.ref;

//     final useCustom = context.select(
//       (CustomizerCubit c) => c.state.pane.enableCustomTheme,
//     );
//     final bTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
//     final listTheme = Theme.of(context).extension<BibleViewListTheme>()!;

//     final refStyle = TextStyle(
//       decoration: listTheme.underlineRef,
//       decorationColor: isHighlighted
//           ? bTheme.accentColor
//           : useCustom
//               ? bTheme.refColor
//               : Theme.of(context).colorScheme.onSurface,
//       height: 1.25,
//       fontFamily: bTheme.referenceFont,
//       fontWeight:
//           isHighlighted ? bTheme.selectedRefFontWeight : bTheme.refFontWeight,
//       color: isHighlighted
//           ? bTheme.accentColor
//           : useCustom
//               ? bTheme.refColor
//               : Theme.of(context).colorScheme.onSurface,
//     );

//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: 8,
//         left: bTheme.widthAdjustmentOffset / 5 + bTheme.xPadding / 5,
//         right: bTheme.widthAdjustmentOffset / 5 + bTheme.xPadding / 5,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: SelectableText.rich(TextSpan(
//                 style: TextStyle(
//                   height: 1.2,
//                   fontWeight: bTheme.textFontWeight,
//                   color: useCustom
//                       ? bTheme.textColor
//                       : Theme.of(context).colorScheme.onSurface,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: isHighlighted || listTheme.showFullRefAlways
//                         ? ref.toString()
//                         : '$verseNumber',
//                     style: refStyle,
//                   ),
//                   TextSpan(text: '  '),
//                   VerseSpanBuilder.build(
//                     context: context,
//                     text: content,
//                     spans: spans!,
//                     onWordTap: (VerseSpan span, String slice) {},
//                   ),
//                 ])),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // note that this might suck because it is hardcoded for preview data only
// class _BibleViewPresentationPreview extends StatelessWidget {
//   _BibleViewPresentationPreview();

//   final List<List<VerseSegment>> verses = [
//     previewData.first.segments,
//     previewData[1].segments,
//     previewData[2].segments,
//   ];
//   final List<List<VerseSpan>> spans = [
//     previewData.first.spans,
//     previewData[1].spans,
//     previewData[2].spans,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final resolver = sl<BibleRefResolver>();
//     final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
//     final presentTheme =
//         Theme.of(context).extension<BibleViewPresentationTheme>()!;
//     final ref = verses.first.first.ref.copyWith(verseEnd: 39);

//     final useCustom = context.select(
//       (CustomizerCubit c) => c.state.pane.enableCustomTheme,
//     );

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             ref.toString().replaceFirst(
//                   ref.book,
//                   resolver.resolveBook(ref.book)?.fullName ?? 'error',
//                 ),
//             textAlign: presentTheme.titleAlignment,
//             style: TextStyle(
//               fontWeight: paneTheme.selectedRefFontWeight,
//               fontFamily: paneTheme.referenceFont,
//               color: paneTheme.accentColor,
//             ),
//           ),
//           Builder(builder: (context) {
//             List<InlineSpan> inlineSpans = [];
//             for (int i = 0; i < verses.length; i++) {
//               String content = verses[i].map((e) => e.text).join();

//               inlineSpans.add(VerseSpanBuilder.build(
//                 context: context,
//                 text: content,
//                 spans: spans[i],
//                 onWordTap: (VerseSpan span, String slice) {},
//               ));
//             }

//             // add verse number before each verse
//             List<InlineSpan> build() {
//               return [
//                 for (int i = 0; i < verses.length; i++) ...[
//                   TextSpan(text: '   '),
//                   TextSpan(
//                     text: '${i + ref.verseStart!}',
//                     style: TextStyle(
//                         fontSize: 8,
//                         fontWeight: FontWeight.bold,
//                         color: paneTheme.accentColor,
//                         decoration: TextDecoration.underline),
//                   ),
//                   TextSpan(text: ' '),
//                   inlineSpans[i],
//                 ],
//               ];
//             }

//             return Text.rich(
//               TextSpan(
//                 style: TextStyle(
//                   fontWeight: paneTheme.textFontWeight,
//                   color: useCustom
//                       ? paneTheme.textColor
//                       : Theme.of(context).colorScheme.onSurface,
//                 ),
//                 children: build(),
//               ),
//               textAlign: presentTheme.textAlignment,
//             );
//           })
//         ],
//       ),
//     );
//   }
// }

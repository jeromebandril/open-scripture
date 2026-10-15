import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/presentation/models/display_option_flutter.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../../settings/bible_view_settings.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';
import '../rendering/inline_verse_number_builder.dart';
import '../rendering/verse_richtext_builder.dart';
import '../state/bible_pane_bloc.dart';

typedef _TranslationBlock = ({String subtitle, Widget content});

class BibleViewPresentation extends StatelessWidget {
  const BibleViewPresentation({super.key, required this.uniqueId});

  final int uniqueId;

  @override
  Widget build(BuildContext context) {
    final viewSettings = BibleViewSettingsScope.of(context);
    final screen = MediaQuery.sizeOf(context);
    final panes = context.read<MultiPaneManagerCubit>().state.panes;

    final thisPaneIndex = panes.indexWhere((e) => e.id == uniqueId);
    final isFirst = thisPaneIndex == 0;
    final isLast = thisPaneIndex == panes.length - 1;

    return BlocBuilder<BiblePaneBloc, BiblePaneState>(
      buildWhen: (prev, curr) =>
          prev.reference != curr.reference || prev.content != curr.content,
      builder: (context, state) {
        final ref = state.reference;
        if (ref == null) return const SizedBox.shrink();

        final rangeToDisplay = state.content.getRefsInRange(ref);
        final isParallel = state.parallelOrder.length > 1;
        final translations = _buildTranslationBlocks(
          context: context,
          state: state,
          rangeToDisplay: rangeToDisplay,
          viewSettings: viewSettings,
        );

        return Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: isFirst ? screen.width * viewSettings.xPadding : 0,
                right: isLast ? screen.width * viewSettings.xPadding : 0,
              ),
              child: Column(
                verticalDirection: VerticalDirection.up,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 32,
                children: [
                  _buildTitle(ref, viewSettings),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: viewSettings.presentationParallelSpacing,
                    children: [
                      for (final block in translations)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isParallel)
                              _buildTranslationSubtitle(
                                context,
                                block.subtitle,
                                viewSettings,
                              ),
                            block.content,
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildTitle(
    BibleRef ref,
    BibleViewSettings viewSettings,
  ) {
    // TODO: make english name be the fallback, prioritize the localized name
    final title = '${ref.book.englishName} ${ref.toStringChapterAndVerse()}';

    return Text(
      title,
      textAlign: viewSettings.presentationTitleTextAlign.toFlutter(),
      style: TextStyle(
        fontWeight: viewSettings.selectedRefFontWeight.toFlutter(),
        fontFamily: viewSettings.refFontFamily,
        color: viewSettings.selectedRefColor,
        fontSize: 16,
      ),
    );
  }

  static Widget _buildTranslationSubtitle(
    BuildContext context,
    String subtitle,
    BibleViewSettings viewSettings,
  ) {
    return Text(
      subtitle,
      textAlign: viewSettings.presentationTitleTextAlign.toFlutter(),
      style: TextStyle(
        color: viewSettings.useAppTheme
            ? Theme.of(context).colorScheme.primary
            : viewSettings.refColor,
        fontWeight: viewSettings.subtitleFontWeight.toFlutter(),
        fontSize: 8,
      ),
    );
  }

  /// Builds one block per translation that has data for this reference.
  /// Verses are looked up by [BibleRef], not positional index, so a
  /// translation missing a verse mid-range can't shift every verse number
  /// after it out of alignment with the wrong text.
  static List<_TranslationBlock> _buildTranslationBlocks({
    required BuildContext context,
    required BiblePaneState state,
    required List<BibleRef> rangeToDisplay,
    required BibleViewSettings viewSettings,
  }) {
    final blocks = <_TranslationBlock>[];

    for (final id in state.parallelOrder) {
      final data = state.content.getParallelDataByBibleId(id);
      if (data == null || data.verses == null) continue;
      final verses = data.verses!;

      final spansByRef = <BibleRef, List<InlineSpan>>{
        for (final ref in rangeToDisplay)
          if (verses[ref] != null)
            ref: VerseSpanBuilder.build(
              context: context,
              spans: verses[ref]!.segments.expand((s) => s.spans).toList(),
            ),
      };

      final children = rangeToDisplay.length > 1
          ? _interleaveVerseNumbers(rangeToDisplay, spansByRef, viewSettings)
          : spansByRef.values.isEmpty
              ? const <InlineSpan>[]
              : spansByRef.values.first;

      final langNativeName = data.meta.langNativeName;
      final subtitle = '${langNativeName ?? ''}  ';

      blocks.add((
        subtitle: subtitle,
        content: Text.rich(
          TextSpan(children: children),
          textAlign: viewSettings.presentationSubtitleTextAlign.toFlutter(),
        ),
      ));
    }

    return blocks;
  }

  /// Interleaves each verse's spans with a leading verse-number marker.
  /// Only called when the range spans more than one verse — a single
  /// selected verse is shown without a number, since the title already
  /// states the full reference.
  static List<InlineSpan> _interleaveVerseNumbers(
    List<BibleRef> range,
    Map<BibleRef, List<InlineSpan>> spansByRef,
    BibleViewSettings viewSettings,
  ) {
    final result = <InlineSpan>[];

    for (final ref in range) {
      final spans = spansByRef[ref];
      if (spans == null) continue;

      result.addAll([
        const TextSpan(text: '   '),
        InlineVerseNumberBuilder.build(
          settings: viewSettings,
          number: ref.verseStart!,
          style: viewSettings.inlineVerseNumberStyle,
        ),
        const TextSpan(text: ' '),
        ...spans,
      ]);
    }

    return result;
  }
}

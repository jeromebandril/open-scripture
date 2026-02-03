import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/bible_view_list.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/parts/pane_info.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/bible_view_presentation.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/presenter/widget/bible_selector.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/bible_pane_theme.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/cubit/customizer_cubit.dart';

import '../../../../../core/presentation/widgets/adjustable_text_size.dart';
import '../bloc/bible_pane_bloc.dart';
import '../models/display_mode.dart';

class BiblePane extends StatelessWidget {
  final int uniqueId;
  final BiblePaneBloc bloc;

  const BiblePane({
    required this.uniqueId,
    required this.bloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final paneTheme = Theme.of(context).extension<BiblePaneTheme>()!;

    return DefaultTextStyle(
      style: TextStyle(
        // background color is set on SplitscreenContainer widget
        color: isCustom
            ? paneTheme.textColor
            : Theme.of(context).colorScheme.onSurface,
        fontFamily: isCustom ? paneTheme.textFont : null,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: bloc),
          BlocProvider(create: (_) => SelectedWordCubit()),
        ],
        child: BlocBuilder<BiblePaneBloc, BiblePaneState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.errorMessage != curr.errorMessage ||
              prev.segments != curr.segments,
          builder: (context, state) {
            switch (state.status) {
              //
              // INITIAL
              //
              case BiblePaneStatus.initial:
                if (state.bibleId == null) {
                  return BibleSelector(
                    onConfirm: (bibleId) {
                      bloc.add(BiblePaneOpen(bibleId));
                    },
                  );
                }
                return SizedBox();
              //
              // LOADING SCREEN
              //
              case BiblePaneStatus.loading:
                return Center(child: CircularProgressIndicator());
              //
              // ERROR SCREEN
              //
              case BiblePaneStatus.error:
                return Center(child: Text(state.errorMessage ?? 'Error'));
              //
              // READY SCREEN
              //
              case BiblePaneStatus.ready:
                if (state.segments.isEmpty) {
                  return Center(child: Text("Ready :)"));
                }

                return Stack(
                  children: [
                    //
                    // MAIN VIEW
                    //
                    Positioned.fill(
                      child: AdjustableTextSize(
                        initialiSize: 14,
                        child: BlocSelector<BiblePaneBloc, BiblePaneState,
                            DisplayMode>(
                          selector: (s) => s.dMode,
                          builder: (context, dMode) {
                            return dMode == DisplayMode.presentation
                                //
                                // Presentation mode
                                //
                                ? BibleViewPresentation(
                                    uniqueId: uniqueId,
                                    segments: state.segments,
                                  )
                                //
                                // Normal mode
                                //
                                : BibleViewList(
                                    uniqueId: uniqueId,
                                    segments: state.segments,
                                  );
                          },
                        ),
                      ),
                    ),
                    //
                    // PANE STATUS INFO
                    //
                    DefaultTextStyle(
                      style: TextStyle(inherit: false),
                      child: Positioned(
                        bottom: 0,
                        right: 0,
                        child: PaneInfo(),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

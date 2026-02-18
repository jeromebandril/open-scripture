import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/bible_view_list.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/parts/pane_info.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/bible_view_presentation.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presenter/widget/bible_selector.dart';
import 'package:open_scripture/features/customizer/presentation/cubit/customizer_cubit.dart';
import 'package:open_scripture/features/text_scaler/cubit/text_scaler_cubit.dart';

import '../../../../../injection_container.dart';
import '../../../../text_scaler/presentation/widgets/text_scaler_host.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
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
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return DefaultTextStyle(
      style: TextStyle(
        // background color is set on SplitscreenContainer widget
        color: isCustom
            ? paneTheme.textColor
            : Theme.of(context).colorScheme.onSurface,
        fontFamily: isCustom ? paneTheme.textFont : null,
        height: kTextHeightNone,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: bloc),
          BlocProvider(create: (_) => SelectedWordCubit()),
          BlocProvider(create: (_) => sl<TextScalerCubit>()),
        ],
        child: BlocConsumer<BiblePaneBloc, BiblePaneState>(
          listenWhen: (prev, curr) =>
              prev.bibleId != curr.bibleId && curr.reference != null,
          listener: (BuildContext context, BiblePaneState state) {
            bloc.add(BiblePaneDisplayChapter(ref: state.reference!));
          },
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
                      child: TextScalerHost(
                        textScalerCubit: context.read<TextScalerCubit>(),
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

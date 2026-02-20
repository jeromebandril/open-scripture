import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/bible_view_list.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/parts/pane_info.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/bible_view_presentation.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/models/split_pane_data.dart';
import 'package:open_scripture/features/customizer/presentation/cubit/customizer_cubit.dart';

import '../../../../text_scaler/presentation/widgets/text_scaler_host.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../bible_selector/presenter/widget/bible_selector.dart';
import '../bloc/bible_pane_bloc.dart';
import '../models/display_mode.dart';

class BiblePane extends StatelessWidget {
  final int uniqueId;
  final PaneBlocComponents blocComponents;

  const BiblePane({
    required this.uniqueId,
    required this.blocComponents,
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
          BlocProvider.value(value: blocComponents.bloc),
          BlocProvider.value(value: blocComponents.textScalerCubit),
          BlocProvider.value(value: blocComponents.bibleSelectorCubit),
          BlocProvider(create: (_) => SelectedWordCubit()),
        ],
        child: BlocConsumer<BiblePaneBloc, BiblePaneState>(
          listenWhen: (prev, curr) =>
              prev.bibleId != curr.bibleId && curr.reference != null,
          listener: (BuildContext context, BiblePaneState state) {
            blocComponents.bloc
                .add(BiblePaneDisplayChapter(ref: state.reference!));
          },
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.errorMessage != curr.errorMessage ||
              prev.segments != curr.segments,
          builder: (context, state) {
            final Widget widget = switch (state.status) {
              //
              // INITIAL
              BiblePaneStatus.initial => BibleSelector(
                  bloc: blocComponents.bibleSelectorCubit,
                  onConfirm: (bibleId) {
                    blocComponents.bloc.add(BiblePaneOpen(bibleId));
                  },
                ),
              //
              // LOADING SCREEN
              BiblePaneStatus.loading =>
                Center(child: CircularProgressIndicator()),
              //
              // ERROR SCREEN
              BiblePaneStatus.error =>
                Center(child: Text(state.errorMessage ?? 'Error')),
              //
              // READY SCREEN
              BiblePaneStatus.ready => state.segments.isEmpty
                  ? Center(child: Text("Ready :)"))
                  : TextScalerHost(
                      textScalerCubit: blocComponents.textScalerCubit,
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
            };

            return Stack(
              children: [
                Positioned.fill(child: widget),
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
          },
        ),
      ),
    );
  }
}

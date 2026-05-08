import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/bible_view_list.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/pane_info.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/widgets/bible_view_presentation.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/models/multi_pane_data.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_shortcuts.dart';
import 'package:open_scripture/features/shortcuts/presentation/widgets/shortcut_view.dart';

import '../../../../shortcuts/domain/models/app_command.dart';
import '../../../../text_scaler/presentation/widgets/text_scaler_host.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../bible_selector/presentation/widgets/bible_selector.dart';
import '../state/bible_pane_bloc.dart';
import '../../domain/display_mode.dart';

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
    final isCustom =
        context.select((CustomizerCubit c) => c.state.pane.enableCustomTheme);
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    //
    // A BiblePane is self dependent. The bloc components are injected
    // externally, for instance by a splitscreen manager
    //
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: blocComponents.bloc),
        BlocProvider.value(value: blocComponents.textScalerCubit),
        BlocProvider.value(value: blocComponents.bibleSelectorCubit),
        BlocProvider(create: (_) => SelectedWordCubit()),
      ],
      //
      // Its theming can be indipendent from the app's theme
      // because it has its own customization settings.
      // MaterialApp theming is used to inject these settings.
      //
      // Styling for specific parts of the ui are injected
      // near the widget that need it.
      //
      // (to avoid unnecessary painting background color is
      // set on SplitscreenContainer, which is the parent widget)
      //
      child: DefaultTextStyle(
        style: TextStyle(
          color: isCustom
              ? paneTheme.textColor
              : Theme.of(context).colorScheme.onSurface,
          fontFamily: isCustom ? paneTheme.textFont : null,
          height: kTextHeightNone,
        ),
        child: BlocBuilder<BiblePaneBloc, BiblePaneState>(
          //
          // Rebuild only when "macro" state changes.
          // Actual rebuilds from content changes happen
          // lower in the widget tree, which is in [BibleView].
          //
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.errorMessage != curr.errorMessage ||
              prev.content.isContentEmpty != curr.content.isContentEmpty,
          builder: (context, state) {
            final Widget widget = switch (state.status) {
              //
              // INITIAL
              //
              BiblePaneStatus.selectBibles => BibleSelector(
                  bloc: blocComponents.bibleSelectorCubit,
                  onConfirm: (bibleIds) {
                    blocComponents.bloc.add(BiblePaneOpen(bibleIds));
                  },
                ),
              //
              // LOADING SCREEN
              //
              BiblePaneStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              //
              // ERROR SCREEN
              //
              BiblePaneStatus.error =>
                Center(child: Text(state.errorMessage ?? 'Unknown Error')),
              //
              // READY SCREEN
              //
              BiblePaneStatus.ready => state.content.isContentEmpty
                  ? const _InitalEmptyContentScreen()
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
                              ? BibleViewPresentation(uniqueId: uniqueId)
                              //
                              // Normal mode
                              //
                              : BibleViewList(uniqueId: uniqueId);
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
                  style: const TextStyle(inherit: false),
                  child: Positioned(
                    bottom: 0,
                    right: 0,
                    child: const PaneInfo(),
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

class _InitalEmptyContentScreen extends StatelessWidget {
  const _InitalEmptyContentScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        Text("Ready :)", style: TextStyle(fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text('Press '),
            ShortcutView(
                activator: appCommandShortcuts[AppCommand.changeBible]),
            Text('to change bible '),
          ],
        ),
        Text('( Go to <Help> for the essential shortcuts list )'),
      ],
    );
  }
}

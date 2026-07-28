import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../text_scaler/presentation/widgets/text_scaler_host.dart';
import '../../../bible_selector/presentation/widgets/bible_selector.dart';
import '../../../multi_pane_manager/presentation/models/multi_pane_data.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';
import '../../domain/display_mode.dart';
import '../state/bible_pane_bloc.dart';
import 'bible_view_list.dart';
import 'bible_view_presentation.dart';
import 'bible_view_prose.dart';
import 'initial_screen.dart';
import 'pane_info.dart';

class BiblePane extends StatelessWidget {
  final int uniqueId;
  final PaneBlocComponents blocComponents;

  const BiblePane({
    required this.uniqueId,
    required this.blocComponents,
    super.key,
  });

  void _onVerseTap(BuildContext context, BibleRef ref) {
    context.read<BiblePaneBloc>().add(BiblePaneJustChangeRef(ref: ref));
  }

  Widget _buildDisplay(BuildContext context, DisplayMode dMode) {
    return switch (dMode) {
      DisplayMode.presentation => BibleViewPresentation(
          uniqueId: uniqueId,
        ),
      DisplayMode.list => BibleViewList(
          uniqueId: uniqueId,
          onVerseTap: (ref) => _onVerseTap(context, ref),
        ),
      DisplayMode.prose => BibleViewProse(
          uniqueId: uniqueId,
          onVerseTap: (ref) => _onVerseTap(context, ref),
        ),
    };
  }

  Widget _buildReadyContent(BuildContext context, BiblePaneState state) {
    if (state.content.isContentEmpty) {
      return const InitalEmptyContentScreen();
    }

    return TextScalerHost(
      textScalerCubit: blocComponents.textScalerCubit,
      initialiSize: 14,
      child: BlocSelector<BiblePaneBloc, BiblePaneState, DisplayMode>(
        selector: (s) => s.dMode,
        builder: _buildDisplay,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewSettings = BibleViewSettingsScope.of(context);
    final appTheme = Theme.of(context);

    // A BiblePane is self dependent. The bloc components are injected
    // externally, for instance by a splitscreen manager
    //
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: blocComponents.bloc),
        BlocProvider.value(value: blocComponents.textScalerCubit),
      ],
      //
      // Its theming can be indipendent from the app's theme
      // because it has its own customization settings.
      // MaterialApp theming is used to inject these settings.
      //
      // Styling for specific parts of the ui are injected
      // near the widget that need it.
      //
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: viewSettings.useAppTheme
              ? appTheme.colorScheme.surface
              : viewSettings.backgroundColor,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: viewSettings.useAppTheme
                ? appTheme.colorScheme.onSurfaceVariant
                : viewSettings.verseColor,
            fontFamily: viewSettings.verseFontFamily,
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
              final Widget content = switch (state.status) {
                //
                // INITIAL
                //
                BiblePaneStatus.selectBibles => BibleSelector(),
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
                BiblePaneStatus.ready => _buildReadyContent(context, state),
              };

              return Stack(
                children: [
                  Positioned.fill(child: content),
                  //
                  // PANE STATUS INFO
                  //
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: DefaultTextStyle(
                      style: const TextStyle(inherit: false),
                      child: const PaneInfo(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

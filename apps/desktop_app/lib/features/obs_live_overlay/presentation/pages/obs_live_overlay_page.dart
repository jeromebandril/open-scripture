import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/dot.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../settings_window/presentation/pages/not_available_page.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../settings/overlay_settings.dart';
import '../state/obs_live_overlay_cubit.dart';

class ObsLiveOverlayPage extends StatelessWidget {
  const ObsLiveOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    const featureDescription =
        'Hosts a customizable local web page, which can be used by the OBS program to display in real time an overlay with the last selected verse (in a parallel view, only the first opened bible will be used to display verses).';

    return kIsWeb
        ? const FeatureNotAvailablePage(featureDescription: featureDescription)
        : BlocProvider.value(
            value: context.read<SettingsCubit<OverlaySettings>>(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
              child: BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
                buildWhen: (curr, prev) =>
                    curr.isRunning != prev.isRunning || curr.busy != prev.busy,
                builder: (ctx, state) {
                  final enableFeature = ctx.select(
                      (SettingsCubit<OverlaySettings> c) =>
                          c.state.enableFeature);
                  return Column(
                    children: [
                      SettingSection(
                        title: 'OBS Live Overlay',
                        children: [
                          Text(featureDescription),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Dot(
                                glowing: state.isRunning,
                                overrideColor: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                overrideGlowingColor: Colors.green,
                              ),
                              TextButton(
                                onPressed: state.busy || !enableFeature
                                    ? null
                                    : () => state.isRunning
                                        ? ctx
                                            .read<ObsLiveOverlayCubit>()
                                            .stopServer()
                                        : ctx
                                            .read<ObsLiveOverlayCubit>()
                                            .startServer(),
                                child: state.isRunning
                                    ? const Text('Turn OBS Live Overlay Off')
                                    : const Text('Turn OBS Live Overlay On'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SettingSection(title: 'Setup', children: [
                        Setting(
                            label: 'URL',
                            description:
                                'Copy this URL and paste it into an OBS Browser Source. You can also open it in your web browser to preview the overlay',
                            settingWidth: 300,
                            child: Builder(builder: (context) {
                              final url = context.select(
                                  (SettingsCubit<OverlaySettings> c) =>
                                      c.state.url);

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    tooltip: 'Copy',
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: url));
                                    },
                                    icon: Icon(Icons.copy_rounded),
                                  ),
                                  Text(url)
                                ],
                              );
                            }))
                      ]),
                      SettingSection(
                        title: 'Preferences',
                        children: [
                          Setting(
                              label: 'Enable OBS Live Overlay',
                              description:
                                  'Enable/Disable obs live overlay feature',
                              child: AppInputBool(
                                enabled: !(state.isRunning || state.busy),
                                value: enableFeature,
                                onChanged: (val) {
                                  ctx
                                      .read<SettingsCubit<OverlaySettings>>()
                                      .update((settings) => settings.copyWith(
                                          enableFeature: val));
                                },
                              )),
                          Setting(
                              // Not implemented yet, just a placeholder for now
                              label: 'Enable auto start',
                              description:
                                  'Automatically start this feature when the app launches (Not yet available)',
                              child: AppInputBool(
                                enabled: false, //state.isRunning || state.busy,
                                value: false,
                                // ctx.select((SettingsCubit<OverlaySettings> c) =>
                                //     c.state.settings.enableAutoStart),
                                onChanged: (val) {
                                  // ctx
                                  //     .read<SettingsCubit<OverlaySettings>>()
                                  //     .updateSettings((settings) =>
                                  //         settings.copyWith(enableAutoStart: val));
                                },
                              )),
                          Setting(
                              label: 'Enable manual control',
                              description:
                                  'When enabled, selecting a reference will no longer automatically signal the overlay. Press Ctrl+U whenever you want to trigger it',
                              child: AppInputBool(
                                enabled: !(state.isRunning || state.busy),
                                value: ctx.select(
                                    (SettingsCubit<OverlaySettings> c) =>
                                        c.state.enableManualControl),
                                onChanged: (val) {
                                  ctx
                                      .read<SettingsCubit<OverlaySettings>>()
                                      .update((settings) => settings.copyWith(
                                          enableManualControl: val));
                                },
                              )),
                          Setting(
                              label: 'Port',
                              description:
                                  'Preferred port for the web page host',
                              child: AppInputNumber(
                                enabled: !(state.isRunning || state.busy),
                                min: 49152,
                                max: 65535,
                                value: ctx.select(
                                    (SettingsCubit<OverlaySettings> c) =>
                                        c.state.port),
                                onSubmitted: (p) {
                                  ctx
                                      .read<SettingsCubit<OverlaySettings>>()
                                      .update((settings) =>
                                          settings.copyWith(port: p.toInt()));
                                },
                              )),
                          Setting(
                              label: 'Visibility time',
                              description:
                                  'The number of seconds before the overlay automatically hides',
                              child: AppInputNumber(
                                enabled: !(state.isRunning || state.busy),
                                min: 5,
                                max: 480,
                                value: ctx.select(
                                    (SettingsCubit<OverlaySettings> c) =>
                                        c.state.hideDebounceSeconds),
                                onSubmitted: (p) {
                                  ctx
                                      .read<SettingsCubit<OverlaySettings>>()
                                      .update((settings) => settings.copyWith(
                                          hideDebounceSeconds: p.toInt()));
                                },
                              )),
                        ],
                      ),
                      SettingSection(
                        title: 'Assets & Customization',
                        children: [
                          Setting(
                            label:
                                'Start editing assets for overlay customization',
                            description:
                                'The customization is for advanced users that knows how to work with HTML and CSS files',
                            child: TextButton.icon(
                                onPressed: () async => await context
                                    .read<ObsLiveOverlayCubit>()
                                    .openAssetsFolder(),
                                icon: const Icon(LucideIcons.folderOpen),
                                label: const Text('Open assets folder')),
                          ),
                          const ResetAssetsAction(),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
  }
}

class ResetAssetsAction extends StatefulWidget {
  const ResetAssetsAction({super.key});

  @override
  State<ResetAssetsAction> createState() => _ResetAssetsActionState();
}

class _ResetAssetsActionState extends State<ResetAssetsAction> {
  // removed this because if nothing wrong happens,
  // it is pratically instantenous
  // bool _isExec = false;
  bool _showFeedback = false;
  Timer? _feedbackTimer;

  Future<void> _resetAssets() async {
    setState(() {
      // _isExec = true;
      _showFeedback = false;
    });
    await context.read<ObsLiveOverlayCubit>().resetAssetsToDefaults();
    setState(() {
      // _isExec = false;
      _showFeedback = true;
    });
    _feedbackTimer = Timer(const Duration(seconds: 2), () {
      setState(() => _showFeedback = false);
      _feedbackTimer = null;
    });
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final successColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.success
        : AppColors.successDark;

    return Setting(
      label: 'Reset assets to defaults',
      description:
          'Restore the default asset files, replacing any customizations',
      child: TextButton.icon(
          onPressed: _showFeedback ? null : () async => await _resetAssets(),
          icon: _showFeedback
              ? Icon(LucideIcons.circleCheckBig, color: successColor)
              : const Icon(LucideIcons.rotateCcw),
          label: _showFeedback
              ? Text('Assets restored', style: TextStyle(color: successColor))
              : const Text('Execute asset reset')),
    );
  }
}

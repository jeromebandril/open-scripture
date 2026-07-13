import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/dot.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../state/obs_overlay/obs_live_overlay_cubit.dart';
import '../state/obs_overlay_settinsg/obs_live_overlay_settings_cubit.dart';

class ObsLiveOverlayPage extends StatelessWidget {
  const ObsLiveOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ObsLiveOverlaySettingsCubit>(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
        child: BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
          buildWhen: (curr, prev) =>
              curr.isRunning != prev.isRunning || curr.busy != prev.busy,
          builder: (ctx, state) {
            final enableFeature = ctx.select((ObsLiveOverlaySettingsCubit c) =>
                c.state.settings.enableFeature);
            return Column(
              children: [
                SettingSection(
                  title: 'OBS Live Overlay',
                  children: [
                    Text(
                        'Hosts a customizable local web page, which can be used by the OBS program to display in real time an overlay with the last selected verse (in a parallel view, only the first opened bible will be used to display verses).'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Dot(
                          glowing: state.isRunning,
                          overrideColor:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          overrideGlowingColor: Colors.red,
                        ),
                        TextButton(
                          onPressed: state.busy || !enableFeature
                              ? null
                              : () => state.isRunning
                                  ? ctx.read<ObsLiveOverlayCubit>().stopServer()
                                  : ctx.read<ObsLiveOverlayCubit>().startServer(
                                      port: ctx
                                          .read<ObsLiveOverlaySettingsCubit>()
                                          .state
                                          .settings
                                          .port,
                                      hideDebounceTimeSeconds: ctx
                                          .read<ObsLiveOverlaySettingsCubit>()
                                          .state
                                          .settings
                                          .hideDebounceSeconds),
                          child: state.isRunning
                              ? const Text('Turn OBS Live Overlay Off')
                              : const Text('Turn OBS Live Overlay On'),
                        ),
                      ],
                    ),
                  ],
                ),
                SettingSection(
                  title: 'Preferences',
                  children: [
                    Setting(
                        label: 'Enable OBS Live Overlay',
                        description: 'Enable/Disable obs live overlay feature',
                        child: AppInputBool(
                          enabled: !(state.isRunning || state.busy),
                          value: enableFeature,
                          onChanged: (val) {
                            ctx
                                .read<ObsLiveOverlaySettingsCubit>()
                                .updateSettings((settings) =>
                                    settings.copyWith(enableFeature: val));
                          },
                        )),
                    Setting(
                        // Not implemented yet, just a placeholder for now
                        label: 'Enable auto start',
                        description:
                            'Automatically start this feature at app startup (not available yet)',
                        child: AppInputBool(
                          enabled: false, //state.isRunning || state.busy,
                          value: false,
                          // ctx.select((ObsLiveOverlaySettingsCubit c) =>
                          //     c.state.settings.enableAutoStart),
                          onChanged: (val) {
                            // ctx
                            //     .read<ObsLiveOverlaySettingsCubit>()
                            //     .updateSettings((settings) =>
                            //         settings.copyWith(enableAutoStart: val));
                          },
                        )),
                    Setting(
                        label: 'Enable manual control',
                        description:
                            'Decide if to pass the selected verse to the overlay manually (not available yet)',
                        child: AppInputBool(
                          enabled: false,
                          value: false,
                          // enabled: !(state.isRunning || state.busy),
                          // value: ctx.select((ObsLiveOverlaySettingsCubit c) =>
                          //     c.state.settings.enableManualControl),
                          onChanged: (val) {
                            ctx
                                .read<ObsLiveOverlaySettingsCubit>()
                                .updateSettings((settings) => settings.copyWith(
                                    enableManualControl: val));
                          },
                        )),
                    Setting(
                        label: 'Port',
                        description: 'Preffered port for the web page host',
                        child: AppInputNumber(
                          enabled: !(state.isRunning || state.busy),
                          min: 49152,
                          max: 65535,
                          value: ctx.select((ObsLiveOverlaySettingsCubit c) =>
                              c.state.settings.port),
                          onSubmitted: (p) {
                            ctx
                                .read<ObsLiveOverlaySettingsCubit>()
                                .updateSettings((settings) =>
                                    settings.copyWith(port: p.toInt()));
                          },
                        )),
                    Setting(
                        label: 'Visibility time',
                        description:
                            'How many seconds the overaly is visible before disappearing',
                        child: AppInputNumber(
                          enabled: !(state.isRunning || state.busy),
                          min: 5,
                          max: 480,
                          value: ctx.select((ObsLiveOverlaySettingsCubit c) =>
                              c.state.settings.hideDebounceSeconds),
                          onSubmitted: (p) {
                            ctx
                                .read<ObsLiveOverlaySettingsCubit>()
                                .updateSettings((settings) => settings.copyWith(
                                    hideDebounceSeconds: p.toInt()));
                          },
                        )),
                    Setting(
                        label: 'URL',
                        description:
                            'Copy this link and paste it into OBS Web source scene. You can also preview it by pasting it in a browser searchbar',
                        settingWidth: 300,
                        child: Builder(builder: (context) {
                          final url = context.select(
                              (ObsLiveOverlaySettingsCubit c) => c.state.url);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: 'Copy',
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: url));
                                },
                                icon: Icon(Icons.copy_rounded),
                              ),
                              Text(url)
                            ],
                          );
                        }))
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

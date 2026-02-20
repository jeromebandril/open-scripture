import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/cubit/obs_overlay/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

import '../cubit/obs_overlay_settinsg/obs_live_overlay_settings_cubit.dart';

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
                  title: 'OBS Live Overlay (beta) $enableFeature',
                  children: [
                    Text(
                        'When activated, a red circle will appear on the upper-right corner of the app'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ObsLiveOverlayIndicator(),
                        TextButton(
                          onPressed: state.busy || !enableFeature
                              ? null
                              : () => state.isRunning
                                  ? ctx.read<ObsLiveOverlayCubit>().stopServer()
                                  : ctx.read<ObsLiveOverlayCubit>().startServer(
                                      ctx
                                          .read<ObsLiveOverlaySettingsCubit>()
                                          .state
                                          .settings
                                          .port),
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
                        description:
                            'Host a web page that OBS can listen to display as overlay graphic',
                        child: SettingInputBool(
                          isDisabled: state.isRunning || state.busy,
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
                            'Automatically start the OBS Live Overlay when the app starts',
                        child: SettingInputBool(
                          isDisabled: false, //state.isRunning || state.busy,
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
                            'Decide if to pass the selected verse to the overlay manually',
                        child: SettingInputBool(
                          isDisabled: state.isRunning || state.busy,
                          value: ctx.select((ObsLiveOverlaySettingsCubit c) =>
                              c.state.settings.enableManualControl),
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
                        child: SettingInputNumber(
                          isDisabled: state.isRunning || state.busy,
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
                        label: 'URL',
                        description:
                            'Copy this link and paste it into OBS Web source scene or preview in a browser',
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/cubit/obs_overlay/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

import '../cubit/cubit/obs_live_overlay_settings_cubit.dart';

class ObsLiveOverlayPage extends StatelessWidget {
  const ObsLiveOverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
        buildWhen: (curr, prev) =>
            curr.isRunning != prev.isRunning || curr.busy != prev.busy,
        builder: (context, state) {
          return Column(
            children: [
              SettingSection(
                title: 'OBS Live Overlay preferences (beta)',
                children: [
                  Setting(
                      label: 'Enable OBS Live Overlay',
                      description:
                          'Host a web page that OBS can listen to display as overlay graphic',
                      child: SettingInputBool(
                        isDisabled: state.isRunning || state.busy,
                        value: context.select((ObsLiveOverlaySettingsCubit c) =>
                            c.state.enableFeature),
                        onChanged: (val) {
                          context
                              .read<ObsLiveOverlaySettingsCubit>()
                              .setEnabled(val);
                        },
                      )),
                  Setting(
                      label: 'Port',
                      description: 'Preffered port for the web page host',
                      child: SettingInputNumber(
                        isDisabled: state.isRunning || state.busy,
                        min: 49152,
                        max: 65535,
                        value: context.select(
                            (ObsLiveOverlaySettingsCubit c) => c.state.port),
                        onSubmitted: (p) {
                          context
                              .read<ObsLiveOverlaySettingsCubit>()
                              .setPort(p.toInt());
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
              SettingSection(
                title: '',
                children: [
                  Text(
                      'When activated, a red circle will appear on the upper-right corner of the app'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ObsLiveOverlayIndicator(),
                      TextButton(
                        onPressed: () => state.busy
                            ? null
                            : state.isRunning
                                ? context
                                    .read<ObsLiveOverlayCubit>()
                                    .stopServer()
                                : context
                                    .read<ObsLiveOverlayCubit>()
                                    .startServer(context
                                        .read<ObsLiveOverlaySettingsCubit>()
                                        .state
                                        .port),
                        child: state.isRunning
                            ? const Text('Turn OBS Live Overlay Off')
                            : const Text('Turn OBS Live Overlay On'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

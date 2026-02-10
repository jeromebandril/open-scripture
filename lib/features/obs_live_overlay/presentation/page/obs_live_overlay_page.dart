import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/cubit/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

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
                title: 'OBS Live Overlay preferences',
                children: [
                  Setting(
                      label: 'Enable OBS Live Overlay',
                      description:
                          'Host a web page that OBS can listen to display as overlay graphic',
                      child: SettingInputBool(value: true)),
                  Setting(
                      label: 'Port',
                      description: 'Preffered port for the web page host',
                      child: SettingInputNumber()),
                  Setting(
                      label: 'URL',
                      description:
                          'Copy this link and paste it into OBS Web source',
                      settingWidth: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'Copy',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: 'http://127.0.0.1:17890/overlay'));
                            },
                            icon: Icon(Icons.copy_rounded),
                          ),
                          Text('http://127.0.0.1:17890/overlay')
                        ],
                      ))
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
                                    .startServer(),
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

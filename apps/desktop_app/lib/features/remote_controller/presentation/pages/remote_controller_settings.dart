import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings_window/presentation/widgets/setting_input_bool.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_input_number.dart';
import '../cubit/remote_controller/remote_controller_cubit.dart';
import '../cubit/remote_controller_settings/remote_controller_settings_cubit.dart';
import '../widgets/remote_controller_indicator.dart';

class RemoteControllerPage extends StatelessWidget {
  const RemoteControllerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<RemoteControllerCubit>(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
        child: BlocBuilder<RemoteControllerCubit, RemoteControllerState>(
          builder: (context, state) {
            final enableFeature = context.select(
                (RemoteControllerSettingsCubit c) =>
                    c.state.settings.enableFeature);
            return Column(
              children: [
                SettingSection(
                  title: 'Remote Controller (beta)',
                  children: [
                    Text(
                        'This feature allows you to control the app remotely from another device. To use it, open the following URL on your phone:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const RemoteControllerIndicator(),
                        TextButton(
                          onPressed: state.isBusy || !enableFeature
                              ? null
                              : () => state.isRunning
                                  ? context.read<RemoteControllerCubit>().stop()
                                  : context.read<RemoteControllerCubit>().start(
                                      context
                                          .read<RemoteControllerSettingsCubit>()
                                          .state
                                          .settings
                                          .port),
                          child: state.isRunning
                              ? const Text('Turn Remote Controller Server Off')
                              : const Text('Turn Remote Controller Server On'),
                        ),
                      ],
                    ),
                  ],
                ),
                SettingSection(
                  title: 'Preferences',
                  children: [
                    Setting(
                        label: 'Enable Remote Controller',
                        description:
                            'Control the app from another device on the same network. When enabled, a web server will be hosted on your machine.',
                        child: SettingInputBool(
                          isDisabled: state.isRunning || state.isBusy,
                          value: context.select(
                              (RemoteControllerSettingsCubit c) =>
                                  c.state.settings.enableFeature),
                          onChanged: (val) {
                            context
                                .read<RemoteControllerSettingsCubit>()
                                .updateSettings((settings) =>
                                    settings.copyWith(enableFeature: val));
                          },
                        )),
                    Setting(
                        label: 'Port',
                        description: 'Preferred port for the web page host',
                        child: SettingInputNumber(
                          isDisabled: state.isRunning || state.isBusy,
                          min: 49152,
                          max: 65535,
                          value: context.select(
                              (RemoteControllerSettingsCubit c) =>
                                  c.state.settings.port),
                          onSubmitted: (p) {
                            context
                                .read<RemoteControllerSettingsCubit>()
                                .updateSettings((settings) =>
                                    settings.copyWith(port: p.toInt()));
                          },
                        )),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

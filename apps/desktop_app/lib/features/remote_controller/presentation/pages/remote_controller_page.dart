import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/utils/network_utils.dart';
import '../../../../shared/widgets/dot.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../settings_window/presentation/pages/not_available_page.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../../window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../../domain/entities/client_info.dart';
import '../state/remote_controller_cubit.dart';
import '../../settings/remote_controller_settings_cubit.dart';

class RemoteControllerPage extends StatefulWidget {
  const RemoteControllerPage({super.key});

  @override
  State<RemoteControllerPage> createState() => _RemoteControllerPageState();
}

class _RemoteControllerPageState extends State<RemoteControllerPage> {
  @override
  Widget build(BuildContext context) {
    const featureDescription =
        'Allows you to control this app remotely from your phone. To use it, make sure to be connected in the same network.';

    final plat = TargetPlatform.windows;

    return kIsWeb
        ? const FeatureNotAvailablePage(featureDescription: featureDescription)
        : BlocProvider.value(
            value: context.read<RemoteControllerCubit>(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
              child: BlocBuilder<RemoteControllerCubit, RemoteControllerState>(
                builder: (context, state) {
                  final enableFeature = context.select(
                      (RemoteControllerSettingsCubit c) =>
                          c.state.settings.enableFeature);

                  final port = context.select(
                      (RemoteControllerSettingsCubit c) =>
                          c.state.settings.port);

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.md,
                        children: [
                          Expanded(
                            child: SettingSection(
                              title: 'Remote Controller (beta)',
                              children: [
                                Text(featureDescription),
                                Column(
                                  spacing: AppSpacing.lg,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Dot(
                                          glowing: state.isRunning,
                                          overrideColor: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                          overrideGlowingColor: Colors.red,
                                        ),
                                        TextButton(
                                          onPressed: state.isBusy ||
                                                  !enableFeature
                                              ? null
                                              : () => state.isRunning
                                                  ? context
                                                      .read<
                                                          RemoteControllerCubit>()
                                                      .stop()
                                                  : context
                                                      .read<
                                                          RemoteControllerCubit>()
                                                      .start(context
                                                          .read<
                                                              RemoteControllerSettingsCubit>()
                                                          .state
                                                          .settings
                                                          .port),
                                          child: state.isRunning
                                              ? const Text(
                                                  'Turn Remote Controller Server Off')
                                              : const Text(
                                                  'Turn Remote Controller Server On'),
                                        ),
                                      ],
                                    ),
                                    if (state.isRunning)
                                      TextButton(
                                          onPressed: () {
                                            context
                                                .read<WindowStackManagerBloc>()
                                                .add(WindowStackManagerOpen(
                                                    title: 'Connected Devices',
                                                    widget:
                                                        const _ConnectedClientsList(),
                                                    size: Size(400, 400)));
                                          },
                                          child:
                                              Text('Manage connected devices')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (state.isRunning)
                            Expanded(
                              child: const _ConnectionDetails(),
                            ),
                        ],
                      ),
                      SettingSection(
                        title: 'Preferences',
                        children: [
                          Setting(
                              label: 'Enable Remote Controller',
                              description:
                                  'Enable/Disable remote controller feature',
                              child: AppInputBool(
                                enabled: !(state.isRunning || state.isBusy),
                                value: context.select(
                                    (RemoteControllerSettingsCubit c) =>
                                        c.state.settings.enableFeature),
                                onChanged: (val) {
                                  context
                                      .read<RemoteControllerSettingsCubit>()
                                      .updateSettings((settings) => settings
                                          .copyWith(enableFeature: val));
                                },
                              )),
                          Setting(
                              label: 'Port',
                              description: 'Preferred connection port',
                              child: AppInputNumber(
                                enabled: !(state.isRunning || state.isBusy),
                                min: 49152,
                                max: 65535,
                                value: port,
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

class _ConnectionDetails extends StatefulWidget {
  const _ConnectionDetails();

  @override
  State<_ConnectionDetails> createState() => __ConnectionDetailsState();
}

class __ConnectionDetailsState extends State<_ConnectionDetails> {
  bool _showQrCode = false;

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: 'Connection Details',
      children: [
        FutureBuilder(
          future: NetworkUtils.getLocalIp().catchError((_) => 'Unknown'),
          builder: (context, asyncSnapshot) {
            return BlocSelector<RemoteControllerSettingsCubit,
                    RemoteControllerSettingsState, int>(
                selector: (state) => state.settings.port,
                builder: (context, port) {
                  final serverUrl = 'http://${asyncSnapshot.data}:$port';

                  return Column(
                    children: [
                      const Text('Scan this QR Code'),
                      const Text('or copy this URL using the mobile app:'),
                      const SizedBox(height: AppSpacing.sm),
                      SelectableText(serverUrl),
                      const SizedBox(height: AppSpacing.md),
                      if (_showQrCode)
                        QrImageView(
                          data: serverUrl,
                          size: 200,
                          backgroundColor: Colors.white,
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton.icon(
                          onPressed: () =>
                              setState(() => _showQrCode = !_showQrCode),
                          icon: _showQrCode
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.qr_code_rounded),
                          label: _showQrCode
                              ? const Text('Hide QR Code')
                              : const Text('Show QR Code'))
                    ],
                  );
                });
          },
        )
      ],
    );
  }
}

class _ConnectedClientsList extends StatelessWidget {
  const _ConnectedClientsList();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RemoteControllerCubit, RemoteControllerState,
        List<ClientInfo>>(
      selector: (s) => s.connectedClients,
      builder: (context, connectedClients) {
        return ListView.builder(
          itemCount: connectedClients.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(connectedClients[index].deviceName),
                subtitle: Text(connectedClients[index].id),
                trailing: IconButton(
                    tooltip: 'Disconnect',
                    onPressed: () => context
                        .read<RemoteControllerCubit>()
                        .disconnectClient(connectedClients[index].id),
                    icon: const Icon(Icons.remove_circle_outline_rounded)));
          },
        );
      },
    );
  }
}

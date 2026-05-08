import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/widgets/custom_icon_button.dart';

// import 'help_widget.dart';
// import '../../shared/theme/tokens.dart';
import '../../features/settings_window/presentation/models/settings_route.dart';
import '../../features/settings_window/presentation/pages/settings_window.dart';
import '../../features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      child: Row(children: [
        // if (screenWidth > AppBreakpoints.compact)
        // ToolbarOption(
        //   'Bible',
        //   onTap: () {
        //     context.read<WindowStackManagerBloc>().add(
        //           WindowStackManagerOpen.selfManaged(
        //             widget: SettingsWindow(
        //                 initialRoute: SettingsSection.bibleManager),
        //           ),
        //         );
        //   },
        // ),
        // if (screenWidth > AppBreakpoints.small)
        CustomIconButton(
          Icons.settings_rounded,
          onTap: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen.selfManaged(
                    widget: SettingsWindow(
                      initialRoute: SettingsSection.appearance,
                    ),
                  ),
                );
          },
        ),
        // if (screenWidth > AppBreakpoints.medium)
        //   ToolbarOption(
        //     'Shortcuts',
        //     onTap: () {
        //       context.read<WindowStackManagerBloc>().add(
        //             WindowStackManagerOpen.selfManaged(
        //               widget: SettingsWindow(
        //                 initialRoute: SettingsSection.shortcuts,
        //               ),
        //             ),
        //           );
        //     },
        //   ),
        // if (screenWidth > AppBreakpoints.large)
        //   ToolbarOption(
        //     'Help',
        //     onTap: () {
        //       context.read<WindowStackManagerBloc>().add(WindowStackManagerOpen(
        //             title: 'Quick Overview',
        //             widget: HelpScreen(),
        //             size: Size(530, 615),
        //           ));
        //     },
        //   ),
        // if (screenWidth > AppBreakpoints.xlarge)
        //   ToolbarOption(
        //     'About',
        //     onTap: () {
        //       context.read<WindowStackManagerBloc>().add(
        //             WindowStackManagerOpen.selfManaged(
        //               widget: SettingsWindow(
        //                 initialRoute: SettingsSection.about,
        //               ),
        //             ),
        //           );
        //     },
        //   ),
      ]),
    );
  }
}

// class ToolbarOption extends StatefulWidget {
//   final String text;
//   final List<ToolbarOption>? subOptions;
//   final Function()? onTap;

//   const ToolbarOption(
//     this.text, {
//     this.onTap,
//     this.subOptions,
//     super.key,
//   });

//   @override
//   State<ToolbarOption> createState() => _ToolbarOptionState();
// }

// class _ToolbarOptionState extends State<ToolbarOption> {
//   Color hoverColor = Colors.transparent;
//   Color? color;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         widget.onTap?.call();
//       },
//       onHover: _onHover,
//       child: Container(
//         color: color,
//         padding: const EdgeInsets.symmetric(
//           horizontal: 6,
//           vertical: 3,
//         ),
//         child: Text(widget.text),
//       ),
//     );
//   }

//   void _onHover(isHovered) {
//     setState(() {
//       color = isHovered ? hoverColor : null;
//     });
//   }
// }

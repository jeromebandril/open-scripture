import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/bloc/settings_bloc.dart';

import '../../../../injection_container.dart';
import '../../../bible_installer_manager/presentation/widgets/translation_manager_widget.dart';
import '../../../window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

class SettingsFactory {
  static SettingsWindow createSettingsWidget(context, defaultWindow) {
    return SettingsWindow(
      pages: const {
        'Appearance': SizedBox(),
        'Bibles Manager': BibleDownloadManagerWidget(),
        'About': Text(
          'Application in early access, currently in development by @Jerome',
        ),
      },
      onClose: () => BlocProvider.of<WindowStackManagerBloc>(context)
          .add(const WindowStackManagerClose()),
      defaultWindow: defaultWindow,
    );
  }
}

class SettingsWindow extends StatelessWidget {
  final Map<String, Widget> pages;
  final Function()? onClose;
  final String? defaultWindow;
  // final Widget? open;

  const SettingsWindow({
    required this.pages,
    this.onClose,
    this.defaultWindow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SettingsBloc>()..add(SettingsGotoPage(defaultWindow ?? '')),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1270,
            maxHeight: 800,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Row(
                children: [
                  //
                  // window contents
                  //
                  _SidebarNavigator(
                      pages: pages, width: 300, activePage: state.currentPage),
                  const Gap(18),
                  _MainSettingContent(
                    pages: pages,
                    pageContent: pages[state.currentPage] ?? const SizedBox(),
                    onClose: onClose,
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

class _SidebarNavigator extends StatelessWidget {
  final double width;
  final Map<String, Widget> pages;
  final String? activePage;

  const _SidebarNavigator({
    required this.pages,
    required this.width,
    required this.activePage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: Colors.black12,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            const Gap(12),
            //
            // All navigation buttons
            //
            ...pages.entries.map(
              (page) => _NavigationButton(
                page.key,
                page.value,
                isActive: page.key == activePage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String text;
  final Widget mappedWidget;
  final bool isActive;

  const _NavigationButton(
    this.text,
    this.mappedWidget, {
    this.isActive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: isActive ? Colors.black12 : Colors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(4),
        onTap: () => dispatch(context, text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          height: 40,
          child: Text(text),
        ),
      ),
    );
  }

  void dispatch(context, text) {
    BlocProvider.of<SettingsBloc>(context).add(SettingsGotoPage(text));
  }
}

class _MainSettingContent extends StatelessWidget {
  final Function()? onClose;
  final Map<String, Widget> pages;
  final Widget pageContent;

  const _MainSettingContent({
    required this.pages,
    required this.pageContent,
    this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            _HeaderSettings(
              height: 40,
              onClose: onClose,
            ),
            Expanded(child: pageContent),
          ],
        ),
      ),
    );
  }
}

class _HeaderSettings extends StatelessWidget {
  final String? title;
  final double height;
  final Function()? onClose;

  const _HeaderSettings({
    this.title,
    required this.height,
    this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? ''),
          IconButton(
              onPressed: () {
                if (onClose != null) onClose!();
              },
              icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}

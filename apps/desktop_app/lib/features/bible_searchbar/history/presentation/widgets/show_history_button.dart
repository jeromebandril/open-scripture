import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../app/state/interface_visibility_cubit.dart';
import '../../../../../shared/widgets/dropdown_menu_anchor.dart';
import 'history_list.dart';

class ShowHistoryButton extends StatefulWidget {
  const ShowHistoryButton({super.key});

  @override
  State<ShowHistoryButton> createState() => _ShowHistoryButtonState();
}

class _ShowHistoryButtonState extends State<ShowHistoryButton> {
  late final ValueNotifier<bool> _menuVisible;
  final _historyFocusNode = FocusNode(debugLabel: 'HistoryDropdown');

  @override
  void initState() {
    super.initState();
    final v = context.read<InterfaceVisibilityCubit>().state.isToolMenuVisible;
    _menuVisible = ValueNotifier(v)..addListener(_onVisibilityChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isVisible =
          context.read<InterfaceVisibilityCubit>().state.isHistoryVisible;
      _menuVisible.value = isVisible;
    });
  }

  void _onVisibilityChanged() {
    if (!_menuVisible.value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _historyFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _menuVisible.removeListener(_onVisibilityChanged);
    _menuVisible.dispose();
    _historyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterfaceVisibilityCubit, InterfaceVisibilityState>(
      listenWhen: (prev, curr) =>
          prev.isHistoryVisible != curr.isHistoryVisible,
      listener: (context, state) => _menuVisible.value = state.isHistoryVisible,
      child: DropdownMenuAnchor(
        menuWidth: 250,
        menuHeight: 220,
        menuContent: HistoryList(),
        onDismiss: () => context
            .read<InterfaceVisibilityCubit>()
            .setVisibility(history: false),
        trigger: IconButton(
          onPressed: () =>
              context.read<InterfaceVisibilityCubit>().toggleHistory(),
          visualDensity: VisualDensity.compact,
          icon: const Icon(LucideIcons.history, size: 16),
        ),
        menuVisible: _menuVisible,
      ),
    );
  }
}

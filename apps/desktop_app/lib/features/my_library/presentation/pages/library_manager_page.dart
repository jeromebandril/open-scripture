import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/core/di/injection_container.dart' as di;
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:open_scripture/features/my_library/presentation/widgets/library_view.dart';
import 'package:open_scripture/shared/widgets/ui/b_container_tab_bar.dart';

class LibrariesPage extends StatefulWidget {
  const LibrariesPage({super.key});

  @override
  State<LibrariesPage> createState() => _LibrariesPageState();
}

class _LibrariesPageState extends State<LibrariesPage> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BlocProvider.value(
        value: di.sl.get<MyLibraryCubit>(instanceName: 'local_drift'),
        child: const LibraryManagerPage(title: 'Installed'),
      ),
      BlocProvider.value(
        value: di.sl.get<MyLibraryCubit>(instanceName: 'local_sword'),
        child: const LibraryManagerPage(title: 'Sword modules'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child:
          BContainerTabBar(tabs: ['Installed', 'Sword Modules'], views: _pages),
    );
  }
}

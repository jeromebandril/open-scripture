import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';

import '../widgets/bible_selector_sheet.dart';
import '../widgets/command_grid.dart';
import '../injection_container.dart' as di;
import '../services/client_ws.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  StreamSubscription<ConnectionStatus>? _statusSub;

  @override
  void initState() {
    super.initState();
    _statusSub = di.sl<RemoteWsClient>().connectionStream.listen((status) {
      if (!status.connected) {
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacementNamed('/disconnected', arguments: status.message);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _statusSub?.cancel();
    super.dispose();
  }

  void _openBibleSelectorSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (context) => BibleSelectorSheet(),
    );
  }

  void _sendQuery() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    di.sl<RemoteWsClient>().sendCommand(
      RemoteCommand(
        name: 'query',
        target: 'search_bar',
        type: RemoteCommandType.custom,
        payload: {'query': query},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Open Scripture RC'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.book_rounded),
            onPressed: _openBibleSelectorSheet,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 24,
          top: 48,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              //
              // Searchbar to send commands to the desktop app
              //
              SearchBar(
                controller: _controller,
                hintText: 'Type a reference',
                leading: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.search,
                    size: 32,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: [
                  ElevatedButton(
                    onPressed: _sendQuery,
                    child: const Icon(Icons.send_rounded, size: 24),
                  ),
                ],
              ),
              const CommandGrid(),
              TextButton.icon(
                onPressed: () => di.sl<RemoteWsClient>().disconnect(),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                icon: const Icon(Icons.link_off_rounded),
                label: const Text('Disconnect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

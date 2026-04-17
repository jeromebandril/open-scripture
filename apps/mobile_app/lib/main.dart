import 'package:flutter/material.dart';
import 'package:open_scripture_rc/components/command_grid.dart';
import 'package:shared/models/remote_command.dart';
import 'package:shared/models/remote_command_type.dart';

import 'injection_container.dart' as di;
import 'pages/connection_setup_page.dart';
import 'service/client_ws.dart';

void main() async {
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Scripture Mobile RC',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18),
          bodySmall: TextStyle(fontSize: 16),

          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontSize: 20),

          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ), // buttons
        ),

        iconTheme: const IconThemeData(size: 44),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(82, 72),
            textStyle: const TextStyle(fontSize: 18),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(140, 60),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: const Size(120, 56),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),

        searchBarTheme: const SearchBarThemeData(
          constraints: BoxConstraints(minHeight: 64),
          textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20)),
          hintStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 20, color: Colors.grey),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          hintStyle: TextStyle(fontSize: 18),
        ),

        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          titleTextStyle: TextStyle(fontSize: 20),
          subtitleTextStyle: TextStyle(fontSize: 16),
        ),

        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/setup',
      routes: {
        '/setup': (context) => const ConnectionSetupPage(),
        '/main': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 24,
          top: 48,
        ),
        child: SafeArea(
          child: StreamBuilder<bool>(
            stream: di.sl<RemoteWsClient>().connectionStream,
            builder: (context, snapshot) {
              final connected = snapshot.data ?? true;

              return connected
                  ? Column(
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
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: [
                            ElevatedButton(
                              onPressed: () {
                                if (_controller.text.isEmpty) return;
                                di.sl<RemoteWsClient>().sendCommand(
                                  RemoteCommand(
                                    id: 'mobile-test',
                                    name: 'query',
                                    target: "search_bar",
                                    type: RemoteCommandType.custom,
                                    payload: {"query": _controller.text},
                                  ),
                                );
                                _controller.clear();
                              },
                              child: const Icon(Icons.send_rounded, size: 24),
                            ),
                          ],
                        ),
                        const CommandGrid(),
                      ],
                    )
                  : const _ReconnectActions();
            },
          ),
        ),
      ),
    );
  }
}

class _ReconnectActions extends StatelessWidget {
  const _ReconnectActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.signal_wifi_connected_no_internet_4_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.error,
        ),
        Text(
          'Not connected',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/setup');
              },
              icon: const Icon(Icons.connected_tv_rounded),
              label: const Text('New'),
            ),
          ],
        ),
      ],
    );
  }
}

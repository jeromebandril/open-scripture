import 'package:flutter/material.dart';
import 'package:open_scripture_rc/pages/disconnected_page.dart';

import 'pages/connection_setup_page.dart';
import 'pages/home_page.dart';

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

          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
        '/home': (context) => const MyHomePage(),
        '/disconnected': (context) => DisconnectedPage(
          initialMessage:
              ModalRoute.of(context)!.settings.arguments as String? ??
              'You are disconnected.',
        ),
      },
    );
  }
}

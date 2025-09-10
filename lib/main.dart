import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/route.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ColorScheme defaultColors = ColorScheme.light(
      primary: Colors.blue,
      onPrimary: Colors.blueGrey,
      primaryContainer: Colors.blue,
      onPrimaryContainer: Colors.blueGrey,
      secondary: Colors.cyanAccent,
      onSecondary: Colors.cyan,
      error: Colors.redAccent,
    );
    return MaterialApp.router(
      title: 'PisHouseApp',
      themeMode: ThemeMode.light,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: defaultColors,
        useMaterial3: true,
        fontFamily: 'Lato',
      ),
    );
  }
}

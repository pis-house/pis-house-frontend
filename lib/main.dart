import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/infrastructures/firebase_init.dart';
import 'package:pis_house_frontend/infrastructures/storage.dart';
import 'package:pis_house_frontend/route.dart';
import 'package:pis_house_frontend/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  final container = ProviderContainer();
  final authService = container.read(authServiceProvider);
  await authService.authChanged(FirebaseAuth.instance.currentUser);
  final themeDataColorSchemeNotifier = container.read(
    themeDataColorSchemeProvider.notifier,
  );
  final brightness = await StorageService.instance.read(key: 'brightness');
  final seedColor = await StorageService.instance.read(key: 'seedColor');
  if (brightness == 'Brightness.dark') {
    themeDataColorSchemeNotifier.darkMode();
  } else {
    themeDataColorSchemeNotifier.lightMode();
  }
  if (seedColor != null) {
    final color = seedColor.toColor();
    if (color != null) {
      themeDataColorSchemeNotifier.changeSeedColor(color);
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
        themeDataColorSchemeProvider.overrideWith(
          (ref) => themeDataColorSchemeNotifier,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeDataColorScheme = ref.watch(themeDataColorSchemeProvider);

    ColorScheme defaultColors = ColorScheme.fromSeed(
      seedColor: themeDataColorScheme.seedColor,
      brightness: themeDataColorScheme.brightness,
    );

    return MaterialApp.router(
      title: 'PisHouseApp',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: defaultColors,
        useMaterial3: true,
        fontFamily: 'Lato',
      ),
    );
  }
}

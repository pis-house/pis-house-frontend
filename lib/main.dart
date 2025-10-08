import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/infrastructures/firebase_init.dart';
import 'package:pis_house_frontend/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  final container = ProviderContainer();
  final authService = container.read(authServiceProvider);
  await authService.authChanged(FirebaseAuth.instance.currentUser);
  runApp(
    ProviderScope(
      overrides: [authServiceProvider.overrideWithValue(authService)],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    ColorScheme defaultColors = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
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

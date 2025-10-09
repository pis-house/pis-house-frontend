import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThemeDataColorScheme {
  final Brightness brightness;
  final Color seedColor;

  const ThemeDataColorScheme({
    required this.brightness,
    required this.seedColor,
  });

  ThemeDataColorScheme copyWith({Brightness? brightness, Color? seedColor}) {
    return ThemeDataColorScheme(
      brightness: brightness ?? this.brightness,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}

class ThemeDataColorSchemeProvider extends StateNotifier<ThemeDataColorScheme> {
  ThemeDataColorSchemeProvider()
    : super(
        const ThemeDataColorScheme(
          brightness: Brightness.light,
          seedColor: Colors.blue,
        ),
      );

  void darkMode() {
    state = state.copyWith(brightness: Brightness.dark);
  }

  void lightMode() {
    state = state.copyWith(brightness: Brightness.light);
  }

  void changeSeedColor(Color color) {
    state = state.copyWith(seedColor: color);
  }

  ThemeDataColorScheme get colorSchema => state;
}

final themeDataColorSchemeProvider =
    StateNotifierProvider<ThemeDataColorSchemeProvider, ThemeDataColorScheme>((
      ref,
    ) {
      return ThemeDataColorSchemeProvider();
    });

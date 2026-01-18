import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/provider/theme_provider.dart';
import 'package:weather_forecast/theme/theme.dart';

import 'package:weather_forecast/view/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme,
      darkTheme: DarkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}

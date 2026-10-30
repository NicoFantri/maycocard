import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  final bool startAtHome;

  const MyApp({super.key, this.startAtHome = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) => MaterialApp(
        title: 'MaycoCard',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: startAtHome ? const HomeScreen() : const SplashScreen(),
      ),
    );
  }
}
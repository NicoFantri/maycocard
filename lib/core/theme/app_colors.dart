import 'package:flutter/material.dart';

class AppColors {
  final bool dark;
  const AppColors(this.dark);

  factory AppColors.of(BuildContext context) =>
      AppColors(Theme.of(context).brightness == Brightness.dark);

  Color get bg => dark ? const Color(0xFF0D0D0D) : const Color(0xFFF4F4F6);
  Color get panel => dark ? const Color(0xFF18181A) : Colors.white;
  Color get panelSecondary => dark ? const Color(0xFF222226) : const Color(0xFFECECEF);
  Color get iconCircle => dark ? const Color(0xFF26262A) : const Color(0xFFEBEBEF);
  Color get headerBtn => dark ? const Color(0xFF222226) : Colors.white;
  Color get text => dark ? Colors.white : const Color(0xFF111111);
  Color get sub => dark ? const Color(0xFF9E9EA4) : const Color(0xFF75757D);
  Color get border => dark ? const Color(0xFF2A2A2E) : const Color(0xFFE5E5EA);
  Color get addBtn => dark ? const Color(0xFF1E1E22) : const Color(0xFF161616);
  Color get addPlus => dark ? const Color(0xFF35353A) : Colors.white;
  Color get addPlusIcon => dark ? Colors.white : Colors.black;
  Color get navCircle => dark ? const Color(0xFF242428) : const Color(0xFFBDBDBD);
  Color get navIcon => dark ? Colors.white : Colors.black;

  // Signature Colors
  static const Color yellow = Color(0xFFFFD25F);
  static const Color purple = Color(0xFFA032DC);
  static const Color emerald = Color(0xFF00E676);
  static const Color blue = Color(0xFF2979FF);
  static const Color coral = Color(0xFFFF5252);

  // Premium Gradients
  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFFFDF77), Color(0xFFFFB82E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFB545F2), Color(0xFF7B16BE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2C2C32), Color(0xFF151518)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGlowGradient = LinearGradient(
    colors: [Color(0xFFA032DC), Color(0xFFFFD25F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

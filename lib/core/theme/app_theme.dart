import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notifier global untuk beralih antara Light dan Dark theme.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

/// Notifier global untuk kustomisasi gambar latar belakang kartu Mandiri:
/// Nilai default: 'purple' (Gradien ungu default),
/// atau 'gold_wayang' (assets/images/mandiri_gold_card.png),
/// atau 'custom_image' (memakai cardCustomImageBytesNotifier),
/// atau 'custom_color' (memakai cardCustomColorsNotifier).
final ValueNotifier<String> cardBackgroundNotifier = ValueNotifier('purple');

/// Notifier global untuk menyimpan byte gambar hasil upload dari galeri perangkat.
final ValueNotifier<Uint8List?> cardCustomImageBytesNotifier = ValueNotifier<Uint8List?>(null);

/// Notifier global untuk menyimpan warna gradien custom pilihan pengguna (Mandiri).
final ValueNotifier<List<Color>> cardCustomColorsNotifier = ValueNotifier<List<Color>>([
  const Color(0xFF6C5CE7),
  const Color(0xFF3B2A82),
]);

/// Notifier global untuk kustomisasi kartu BRI BritAma Prioritas:
/// Nilai default: 'yellow_prioritas' (Gradien emas BRI),
/// atau 'gold_wayang', 'custom_image', 'custom_color', dsb.
final ValueNotifier<String> briCardBackgroundNotifier = ValueNotifier('yellow_prioritas');

/// Notifier global untuk menyimpan byte gambar hasil upload galeri khusus kartu BRI.
final ValueNotifier<Uint8List?> briCardCustomImageBytesNotifier = ValueNotifier<Uint8List?>(null);

/// Notifier global untuk menyimpan warna gradien custom khusus kartu BRI.
final ValueNotifier<List<Color>> briCardCustomColorsNotifier = ValueNotifier<List<Color>>([
  const Color(0xFFFFB300),
  const Color(0xFFF57C00),
]);

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      );
}

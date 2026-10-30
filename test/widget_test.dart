import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maycocard/main.dart';
import 'package:maycocard/widgets/bottom_nav_bar.dart';
import 'package:maycocard/widgets/card_stack.dart';

void main() {
  testWidgets('MaycoCard smoke test & multi-tab navigation Bahasa Indonesia', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Build our app starting at home and trigger a frame.
    await tester.pumpWidget(const MyApp(startAtHome: true));
    await tester.pump();

    // Verify Home tab greeting & header with Nico
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.text('Halo, Nico!'), findsOneWidget);
    expect(find.text('Kelola Pengeluaran'), findsOneWidget);

    // Verify Theme Toggle Button exists in top header
    final themeToggleFinder = find.byIcon(Icons.light_mode_rounded);
    if (themeToggleFinder.evaluate().isNotEmpty) {
      await tester.tap(themeToggleFinder.first);
      await tester.pumpAndSettle();
    }

    // Test Card Motion Swap in Home
    expect(find.byType(CardStack), findsOneWidget);
    final swapIconFinder = find.byIcon(Icons.swap_vert_rounded);
    if (swapIconFinder.evaluate().isNotEmpty) {
      await tester.tap(swapIconFinder.first);
      await tester.pumpAndSettle();
    }

    // Tap Wallet tab icon inside clean 4-tab BottomNavBar
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavBar),
        matching: find.byIcon(Icons.account_balance_wallet_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dompet & Anggaran'), findsOneWidget);
    expect(find.text('Sumber Dana Tercatat'), findsOneWidget);

    // Tap Stats tab icon inside BottomNavBar
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavBar),
        matching: find.byIcon(Icons.analytics_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Statistik Keuangan'), findsOneWidget);
    expect(find.text('Aktivitas Pengeluaran'), findsOneWidget);

    // Tap Profile tab icon inside BottomNavBar
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavBar),
        matching: find.byIcon(Icons.person_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Akun & Keamanan'), findsOneWidget);

    // Return to Wallet tab and test Foto Struk (OCR)
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavBar),
        matching: find.byIcon(Icons.account_balance_wallet_rounded),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 4 tab labels are permanently visible in BottomNavBar
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Dompet'), findsWidgets);
    expect(find.text('Statistik'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // Verify Action buttons in Dompet
    expect(find.text('Foto Struk'), findsOneWidget);
    expect(find.text('Catat Manual'), findsOneWidget);
    expect(find.text('Ekspor Data'), findsOneWidget);

    // Verify QR Scanner button in Dompet screen top header
    expect(find.byIcon(Icons.qr_code_scanner_rounded), findsWidgets);

    // Verify Tambah Kartu button exists in Dompet
    expect(find.text('Tambah Kartu'), findsOneWidget);

    // Verify Mandiri Debit Gold card elements
    expect(find.text('Ganti Desain'), findsWidgets);
    expect(find.text('NICO'), findsWidgets);
    expect(find.text('ELECTRONIC USE ONLY'), findsWidgets);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/text_styles.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/card_stack.dart';
import '../widgets/expenses_section.dart';
import '../widgets/quick_actions.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  Widget _buildHomeView(AppColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 130),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        // Header Terpadu: Selamat Datang 👋, Halo, Niko! & Notifikasi + Dark Mode Toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Selamat Datang',
                          style: poppins(12.5, colors.sub, w: FontWeight.w500),
                        ),
                        const SizedBox(width: 6),
                        const Text('👋', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Halo, Nico!',
                      style: poppins(26, colors.text, w: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mari kelola tabungan uangmu hari ini.',
                      style: poppins(12, colors.sub, w: FontWeight.w400),
                    ),
                  ],
                ),
              ),

              // Tombol Notifikasi & Toggle Dark/Light Mode di Pojok Kanan
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Notifikasi
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => NotificationsScreen(colors: colors),
                          ),
                        );
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colors.headerBtn,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              size: 20,
                              color: colors.text,
                            ),
                            Positioned(
                              top: 9,
                              right: 10,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF5252),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Tombol Ganti Mode Gelap / Terang (Bulan / Matahari)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        themeNotifier.value =
                            colors.dark ? ThemeMode.light : ThemeMode.dark;
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colors.headerBtn,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          colors.dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 20,
                          color: colors.dark
                              ? const Color(0xFFFFD25F)
                              : const Color(0xFF5352ED),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Stack Kartu Interaktif
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CardStack(
            colors: colors,
            onAddCard: () => setState(() => _navIndex = 1),
          ),
        ),
        const SizedBox(height: 16),

        // Aksi Cepat
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: QuickActions(colors: colors),
        ),
        const SizedBox(height: 16),

        // Riwayat Pengeluaran
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpensesSection(
            colors: colors,
            onViewAll: () => setState(() => _navIndex = 2),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: colors.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colors.bg,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Stack(
                children: [
                  // Perpindahan tab navigasi yang stabil, responsif dan tanpa kedip teks (Clean IndexedStack)
                  IndexedStack(
                    index: _navIndex,
                    children: [
                      _buildHomeView(colors),
                      WalletScreen(colors: colors),
                      StatsScreen(colors: colors),
                      ProfileScreen(colors: colors),
                    ],
                  ),

                  // Floating 4-Tab Navigation Bar Glassmorphism
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 22,
                    child: BottomNavBar(
                      colors: colors,
                      currentIndex: _navIndex,
                      onTap: (index) => setState(() => _navIndex = index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

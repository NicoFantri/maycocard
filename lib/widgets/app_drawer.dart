import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/text_styles.dart';

class AppDrawer extends StatelessWidget {
  final AppColors colors;
  final VoidCallback? onNavigateWallet;
  final VoidCallback? onNavigateStats;
  final VoidCallback? onNavigateProfile;

  const AppDrawer({
    super.key,
    required this.colors,
    this.onNavigateWallet,
    this.onNavigateStats,
    this.onNavigateProfile,
  });

  @override
  Widget build(BuildContext context) {
    final c = colors;

    return Drawer(
      backgroundColor: c.panel,
      child: SafeArea(
        child: Column(
          children: [
            // Header Drawer Profil
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFF3B2A22),
                      child: Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Nico',
                              style: poppins(15, c.text, w: FontWeight.w600),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF00E676),
                              size: 15,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'nico@maycocard.id',
                          style: poppins(11.5, c.sub, w: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: c.border.withValues(alpha: 0.7), height: 1),

            // Daftar Menu Navigasi
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                children: [
                  _drawerItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Kelola Rekening & Kartu',
                    subtitle: 'BRI Prioritas & Mandiri Livin',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateWallet?.call();
                    },
                    c: c,
                  ),
                  _drawerItem(
                    icon: Icons.pie_chart_outline_rounded,
                    title: 'Laporan Finansial',
                    subtitle: 'Statistik pengeluaran bulanan',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateStats?.call();
                    },
                    c: c,
                  ),
                  _drawerItem(
                    icon: Icons.savings_outlined,
                    title: 'Kantong & Tabungan',
                    subtitle: '3 target tabungan aktif',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: c.panel,
                          content: Text('Fitur Kantong Tabungan segera hadir', style: poppins(12, c.text)),
                        ),
                      );
                    },
                    c: c,
                  ),
                  _drawerItem(
                    icon: Icons.security_rounded,
                    title: 'Keamanan & Limit',
                    subtitle: 'PIN, Biometrik, & Batas Transaksi',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateProfile?.call();
                    },
                    c: c,
                  ),
                  _drawerItem(
                    icon: Icons.qr_code_scanner_rounded,
                    title: 'QRIS Pembayaran',
                    subtitle: 'Scan cepat di semua merchant',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: c.panel,
                          content: Text('Kamera pemindai QRIS diaktifkan', style: poppins(12, c.text)),
                        ),
                      );
                    },
                    c: c,
                  ),
                  _drawerItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Bantuan & Layanan 24/7',
                    subtitle: 'Hubungi Customer Care',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: c.panel,
                          content: Text('Menghubungkan ke layanan bantuan...', style: poppins(12, c.text)),
                        ),
                      );
                    },
                    c: c,
                  ),
                ],
              ),
            ),

            Divider(color: c.border.withValues(alpha: 0.7), height: 1),

            // Bagian Bawah: Toggle Tema & Versi
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        c.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: c.text,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        c.dark ? 'Mode Gelap' : 'Mode Terang',
                        style: poppins(12.5, c.text, w: FontWeight.w500),
                      ),
                    ],
                  ),
                  Switch(
                    activeThumbColor: AppColors.purple,
                    value: c.dark,
                    onChanged: (val) {
                      themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required AppColors c,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: c.iconCircle,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 19, color: c.text),
          ),
          title: Text(title, style: poppins(13, c.text, w: FontWeight.w500)),
          subtitle: Text(subtitle, style: poppins(10.5, c.sub)),
          trailing: Icon(Icons.chevron_right_rounded, size: 18, color: c.sub.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}

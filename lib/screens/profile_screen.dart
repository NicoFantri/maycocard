import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/text_styles.dart';

class ProfileScreen extends StatefulWidget {
  final AppColors colors;

  const ProfileScreen({super.key, required this.colors});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _biometricEnabled = true;
  bool _notificationsEnabled = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.colors.panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Keluar Akun?', style: poppins(16, widget.colors.text, w: FontWeight.w600)),
        content: Text(
          'Anda harus memasukkan PIN atau biometrik untuk masuk kembali.',
          style: poppins(12.5, widget.colors.sub),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: poppins(13, widget.colors.sub)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: widget.colors.panel,
                  content: Text('Sesi akun berhasil diakhiri.', style: poppins(12, widget.colors.text)),
                ),
              );
            },
            child: Text('Keluar', style: poppins(13, Colors.white, w: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        // Header Profil
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil Saya',
              style: poppins(23, c.text, w: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              'Pengaturan akun keuangan & preferensi aplikasi',
              style: poppins(11, c.sub, w: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Kartu Identitas Profil Bersih & Elegan
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.border.withValues(alpha: 0.7), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: c.dark ? 0.3 : 0.03),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar Inisial N
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.purpleGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'N',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nico',
                      style: poppins(17, c.text, w: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'nico@maycocard.id',
                      style: poppins(12, c.sub, w: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),


        // Grup 1: Akun & Keamanan
        Text('Akun & Keamanan', style: poppins(13.5, c.text, w: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Column(
            children: [
              _settingTile(
                Icons.person_outline_rounded,
                'Informasi Pribadi & Kontak',
                'NIK, Nomor Telepon & Email terverifikasi',
                c,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: c.panel,
                      content: Text('Membuka data diri nasabah terverifikasi', style: poppins(12, c.text)),
                    ),
                  );
                },
              ),
              Divider(color: c.border.withValues(alpha: 0.6), height: 1, indent: 56),
              _settingTile(
                Icons.pin_outlined,
                'PIN & Sandi Transaksi',
                'Ganti 6-digit PIN keamanan',
                c,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: c.panel,
                      content: Text('Menu Ubah PIN Transaksi dibuka', style: poppins(12, c.text)),
                    ),
                  );
                },
              ),
              Divider(color: c.border.withValues(alpha: 0.6), height: 1, indent: 56),
              _settingTile(
                Icons.tune_rounded,
                'Limit Transaksi Harian',
                'Maksimal Rp 50.000.000 / hari',
                c,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: c.panel,
                      content: Text('Pengaturan Limit Harian dibuka', style: poppins(12, c.text)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Grup 2: Preferensi Aplikasi
        Text('Preferensi Aplikasi', style: poppins(13.5, c.text, w: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Column(
            children: [
              SwitchListTile(
                activeThumbColor: AppColors.purple,
                value: c.dark,
                onChanged: (val) {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                },
                title: Text('Mode Gelap', style: poppins(12.5, c.text, w: FontWeight.w500)),
                subtitle: Text('Ganti tampilan tema malam / siang', style: poppins(10, c.sub, w: FontWeight.w400)),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: c.iconCircle, shape: BoxShape.circle),
                  child: Icon(c.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, size: 18, color: c.text),
                ),
              ),
              Divider(color: c.border.withValues(alpha: 0.6), height: 1, indent: 56),
              SwitchListTile(
                activeThumbColor: AppColors.purple,
                value: _biometricEnabled,
                onChanged: (val) {
                  setState(() => _biometricEnabled = val);
                },
                title: Text('Biometrik & Face ID', style: poppins(12.5, c.text, w: FontWeight.w500)),
                subtitle: Text('Masuk cepat tanpa mengetik PIN', style: poppins(10, c.sub, w: FontWeight.w400)),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: c.iconCircle, shape: BoxShape.circle),
                  child: Icon(Icons.fingerprint_rounded, size: 18, color: c.text),
                ),
              ),
              Divider(color: c.border.withValues(alpha: 0.6), height: 1, indent: 56),
              SwitchListTile(
                activeThumbColor: AppColors.purple,
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() => _notificationsEnabled = val);
                },
                title: Text('Notifikasi Transaksi', style: poppins(12.5, c.text, w: FontWeight.w500)),
                subtitle: Text('Pemberitahuan instan mutasi saldo', style: poppins(10, c.sub, w: FontWeight.w400)),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: c.iconCircle, shape: BoxShape.circle),
                  child: Icon(Icons.notifications_active_outlined, size: 18, color: c.text),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Grup 3: Layanan & Keluar
        Text('Layanan & Sesi', style: poppins(13.5, c.text, w: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Column(
            children: [
              _settingTile(Icons.headset_mic_outlined, 'Bantuan Nasabah 24/7', 'Hubungi Relationship Manager', c, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: c.panel,
                    content: Text('Menghubungkan ke RM MaycoCard...', style: poppins(12, c.text)),
                  ),
                );
              }),
              Divider(color: c.border.withValues(alpha: 0.6), height: 1, indent: 56),
              _settingTile(Icons.shield_outlined, 'Kebijakan Privasi & OJK', 'Kerahasiaan data terenkripsi bank', c, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: c.panel,
                    content: Text('MaycoCard berlisensi & diawasi BI & OJK', style: poppins(12, c.text)),
                  ),
                );
              }),
              Divider(color: c.border.withValues(alpha: 0.6), height: 1, indent: 56),
              _settingTile(Icons.logout_rounded, 'Keluar Akun', 'Akhiri sesi aplikasi dengan aman', c, () => _showLogoutDialog(context), isDestructive: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle, AppColors c, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? const Color(0xFFFF5252).withValues(alpha: 0.12) : c.iconCircle,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: isDestructive ? const Color(0xFFFF5252) : c.text),
      ),
      title: Text(
        title,
        style: poppins(12.5, isDestructive ? const Color(0xFFFF5252) : c.text, w: FontWeight.w500),
      ),
      subtitle: Text(subtitle, style: poppins(10, c.sub, w: FontWeight.w400)),
      trailing: Icon(Icons.chevron_right_rounded, size: 18, color: c.sub.withValues(alpha: 0.6)),
    );
  }
}


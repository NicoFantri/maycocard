import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  final AppColors colors;

  const NotificationsScreen({super.key, required this.colors});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Transaksi', 'Keamanan', 'Promo'];

  final List<Map<String, dynamic>> _allNotifs = [
    {
      'title': 'Transfer Masuk Berhasil',
      'desc': 'Dana sebesar Rp 15.000.000 dari Bank Mandiri telah masuk ke rekening utama Anda.',
      'time': '10 menit yang lalu',
      'type': 'Transaksi',
      'icon': Icons.arrow_downward_rounded,
      'color': const Color(0xFF00E676),
      'isUnread': true,
    },
    {
      'title': 'Pembayaran Berhasil: Sewa Properti',
      'desc': 'Pembayaran otomatis sebesar Rp 3.500.000 untuk sewa hunian telah selesai diproses.',
      'time': '2 jam yang lalu',
      'type': 'Transaksi',
      'icon': Icons.check_circle_outline_rounded,
      'color': const Color(0xFF7C4DFF),
      'isUnread': true,
    },
    {
      'title': 'Login Perangkat Terdeteksi',
      'desc': 'Perangkat Anda (Chrome Web) berhasil diautentikasi dengan verifikasi biometrik.',
      'time': '5 jam yang lalu',
      'type': 'Keamanan',
      'icon': Icons.security_rounded,
      'color': const Color(0xFFFFB82E),
      'isUnread': false,
    },
    {
      'title': 'Cashback 5% Merchant Restoran',
      'desc': 'Gunakan kartu BRI Prioritas Anda di merchant rekanan dan nikmati diskon eksklusif.',
      'time': '1 hari yang lalu',
      'type': 'Promo',
      'icon': Icons.local_offer_outlined,
      'color': const Color(0xFFFF5252),
      'isUnread': false,
    },
    {
      'title': 'Tagihan Listrik PLN Tersedia',
      'desc': 'Tagihan listrik bulan September sebesar Rp 300.000 telah jatuh tempo pada 20 September.',
      'time': '2 hari yang lalu',
      'type': 'Transaksi',
      'icon': Icons.receipt_long_outlined,
      'color': const Color(0xFF00B0FF),
      'isUnread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final filteredList = _selectedFilter == 0
        ? _allNotifs
        : _allNotifs.where((n) => n['type'] == _filters[_selectedFilter]).toList();

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.panel,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifikasi',
          style: poppins(18, c.text, w: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _allNotifs) {
                  n['isUnread'] = false;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: c.panel,
                  content: Text('Semua notifikasi ditandai dibaca', style: poppins(12, c.text)),
                ),
              );
            },
            child: Text(
              'Tandai Dibaca',
              style: poppins(12, const Color(0xFF00B0FF), w: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: c.panel,
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final isSel = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSel ? c.text : c.iconCircle,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filters[i],
                        style: poppins(
                          12,
                          isSel ? (c.dark ? Colors.black : Colors.white) : c.sub,
                          w: isSel ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Divider(color: c.border.withValues(alpha: 0.6), height: 1),

            // Daftar Notifikasi Penuh
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none_rounded, size: 54, color: c.sub.withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          Text('Belum ada notifikasi', style: poppins(14, c.sub)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final n = filteredList[index];
                        final isUnread = n['isUnread'] as bool;
                        final color = n['color'] as Color;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: c.panel,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isUnread
                                  ? color.withValues(alpha: 0.4)
                                  : c.border.withValues(alpha: 0.6),
                              width: isUnread ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: c.dark ? 0.2 : 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: c.dark ? 0.2 : 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(n['icon'] as IconData, size: 20, color: color),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            n['title'] as String,
                                            style: poppins(13.5, c.text, w: FontWeight.w600),
                                          ),
                                        ),
                                        if (isUnread)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFF5252),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      n['desc'] as String,
                                      style: poppins(12, c.sub, height: 1.4),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      n['time'] as String,
                                      style: poppins(10, c.sub.withValues(alpha: 0.7)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

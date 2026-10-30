import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/text_styles.dart';

class StatsScreen extends StatefulWidget {
  final AppColors colors;

  const StatsScreen({super.key, required this.colors});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedPeriod = 0;
  final List<String> _periods = ['Mingguan', 'Bulanan', 'Tahunan'];
  int _selectedDayIndex = 5; // Sabtu

  final List<Map<String, dynamic>> _chartData = [
    {'day': 'Sen', 'val': 45.0, 'amount': 'Rp 65.000'},
    {'day': 'Sel', 'val': 80.0, 'amount': 'Rp 120.000'},
    {'day': 'Rab', 'val': 35.0, 'amount': 'Rp 45.000'},
    {'day': 'Kam', 'val': 110.0, 'amount': 'Rp 185.000'},
    {'day': 'Jum', 'val': 95.0, 'amount': 'Rp 150.000'},
    {'day': 'Sab', 'val': 140.0, 'amount': 'Rp 245.000'},
    {'day': 'Min', 'val': 60.0, 'amount': 'Rp 90.000'},
  ];

  // Kategori terstruktur rapi tanpa warna neon mencolok (anti AI-slop)
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Belanja Kebutuhan & Retail',
      'detail': 'Indomaret, Alfamart, Pasar',
      'amount': 'Rp 1.150.000',
      'percent': 0.40,
      'color': const Color(0xFF6C5CE7),
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'title': 'Restoran, Kuliner & Kafe',
      'detail': 'Starbucks, GoFood, Resto Lokal',
      'amount': 'Rp 680.000',
      'percent': 0.24,
      'color': const Color(0xFFE17055),
      'icon': Icons.restaurant_outlined,
    },
    {
      'title': 'Tagihan Listrik, Air & Internet',
      'detail': 'PLN Pascabayar, PDAM, Indihome',
      'amount': 'Rp 420.000',
      'percent': 0.15,
      'color': const Color(0xFF00B894),
      'icon': Icons.receipt_long_outlined,
    },
    {
      'title': 'Bensin & Transportasi Publik',
      'detail': 'SPBU Pertamina, Shell, MRT Jakarta',
      'amount': 'Rp 350.000',
      'percent': 0.12,
      'color': const Color(0xFF0984E3),
      'icon': Icons.local_gas_station_outlined,
    },
    {
      'title': 'Hiburan & Langganan Digital',
      'detail': 'Netflix, Spotify, Bioskop XXI',
      'amount': 'Rp 250.000',
      'percent': 0.09,
      'color': const Color(0xFF636E72),
      'icon': Icons.movie_outlined,
    },
  ];

  // Merchant otentik dengan brand emblem khas perbankan nyata
  final List<Map<String, dynamic>> _topMerchants = [
    {
      'tag': 'IDM',
      'name': 'Indomaret Point & Retail',
      'method': '14x Transaksi • QRIS Mandiri',
      'amount': 'Rp 350.000',
      'icon': Icons.storefront_outlined,
      'accent': const Color(0xFF0984E3),
    },
    {
      'tag': 'PLN',
      'name': 'PT PLN (Persero)',
      'method': 'Tagihan Bulanan • Virtual Account BRI',
      'amount': 'Rp 280.000',
      'icon': Icons.bolt_outlined,
      'accent': const Color(0xFFF39C12),
    },
    {
      'tag': 'SBX',
      'name': 'Starbucks Reserve Coffee',
      'method': '4x Transaksi • Debit Mandiri Gold',
      'amount': 'Rp 145.000',
      'icon': Icons.coffee_outlined,
      'accent': const Color(0xFF00B894),
    },
    {
      'tag': 'PERT',
      'name': 'SPBU Pertamina Shell',
      'method': '3x Transaksi • QRIS MaycoCard',
      'amount': 'Rp 180.000',
      'icon': Icons.local_gas_station_outlined,
      'accent': const Color(0xFFD63031),
    },
    {
      'tag': 'TKP',
      'name': 'Tokopedia Official Store',
      'method': '2x Transaksi • VA Bank Mandiri',
      'amount': 'Rp 320.000',
      'icon': Icons.shopping_cart_outlined,
      'accent': const Color(0xFF00B894),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        // Judul Atas
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistik Keuangan',
              style: poppins(23, c.text, w: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              'Analitik & arus kas terperinci akun Anda',
              style: poppins(11, c.sub, w: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Segmented Control Filter Periode Rapi & Proporsional
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Row(
            children: List.generate(_periods.length, (i) {
              final isSel = _selectedPeriod == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPeriod = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? c.text : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _periods[i],
                      style: poppins(
                        11.5,
                        isSel ? (c.dark ? Colors.black : Colors.white) : c.sub,
                        w: isSel ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 18),

        // Kartu Ringkasan Total Pengeluaran
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: c.border.withValues(alpha: 0.7), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: c.dark ? 0.35 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Total Pengeluaran Bulan Ini', style: poppins(12, c.sub, w: FontWeight.w400)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Hemat 12%',
                      style: poppins(10.5, const Color(0xFF00E676), w: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Rp 2.850.000',
                style: poppins(26, c.text, w: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Rata-rata Rp 95.000 / hari • 26 transaksi tercatat',
                style: poppins(11, c.sub, w: FontWeight.w400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Kartu Pemasukan & Pengeluaran
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.panel,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_downward_rounded, color: Color(0xFF00E676), size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text('Pemasukan', style: poppins(11, c.sub, w: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Rp 5.500.000', style: poppins(15, c.text, w: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.panel,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5252).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_upward_rounded, color: Color(0xFFFF5252), size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text('Pengeluaran', style: poppins(11, c.sub, w: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Rp 2.850.000', style: poppins(15, c.text, w: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Kartu Grafik Aktivitas Mingguan (Bebas Bloom Ungu)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: c.dark ? 0.35 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aktivitas Pengeluaran',
                          style: poppins(14, c.text, w: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hari ${_chartData[_selectedDayIndex]['day']}: ${_chartData[_selectedDayIndex]['amount']}',
                          style: poppins(11.5, AppColors.purple, w: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.iconCircle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Puncak: Sabtu',
                      style: poppins(10, c.text, w: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // Interactive Bar Chart
              SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_chartData.length, (i) {
                    final item = _chartData[i];
                    final val = item['val'] as double;
                    final isSelected = _selectedDayIndex == i;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDayIndex = i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            width: 28,
                            height: (val / 140) * 105,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.purple : c.iconCircle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['day'] as String,
                            style: poppins(
                              10.5,
                              isSelected ? c.text : c.sub,
                              w: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Kategori Pengeluaran Teratas (Clean & Authentic Fintech)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Kategori Pengeluaran Teratas',
                style: poppins(14.5, c.text, w: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text('Persentase', style: poppins(11, c.sub, w: FontWeight.w400)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Column(
            children: List.generate(_categories.length, (i) {
              final cat = _categories[i];
              final isLast = i == _categories.length - 1;
              final percentTxt = '${((cat['percent'] as double) * 100).toInt()}%';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: c.iconCircle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: c.border.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Icon(cat['icon'] as IconData, size: 18, color: c.text),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat['title'] as String,
                                style: poppins(12.5, c.text, w: FontWeight.w500),
                              ),
                              Text(
                                cat['detail'] as String,
                                style: poppins(10, c.sub, w: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              cat['amount'] as String,
                              style: poppins(12.5, c.text, w: FontWeight.w600),
                            ),
                            Text(
                              percentTxt,
                              style: poppins(10, c.sub, w: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: cat['percent'] as double,
                        minHeight: 5,
                        backgroundColor: c.iconCircle,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          c.dark ? Colors.white70 : AppColors.purple,
                        ),
                      ),
                    ),
                    if (!isLast) ...[
                      const SizedBox(height: 8),
                      Divider(color: c.border.withValues(alpha: 0.5), height: 1),
                    ],
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),

        // Merchant & Transaksi Terbanyak (Otentik & Rapi)
        Text('Merchant & Transaksi Terbanyak', style: poppins(14.5, c.text, w: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Column(
            children: List.generate(_topMerchants.length, (i) {
              final m = _topMerchants[i];
              final isLast = i == _topMerchants.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      children: [
                        // Brand Badge Initial khas perbankan nyata
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: c.iconCircle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: c.border.withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            m['tag'] as String,
                            style: poppins(10.5, c.text, w: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['name'] as String, style: poppins(12.5, c.text, w: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Text(m['method'] as String, style: poppins(10, c.sub, w: FontWeight.w400)),
                            ],
                          ),
                        ),
                        Text(m['amount'] as String, style: poppins(12.5, c.text, w: FontWeight.w600)),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(color: c.border.withValues(alpha: 0.5), height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

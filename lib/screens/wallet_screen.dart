import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/text_styles.dart';
import '../core/utils/image_file_picker.dart';
import '../models/card_item.dart';
import '../widgets/batik_pattern_painter.dart';
import '../widgets/card_customizer_modal.dart';
import '../widgets/card_stack.dart';
import '../widgets/qr_scan_modal.dart';
import '../widgets/visa_logo.dart';

class WalletScreen extends StatefulWidget {
  final AppColors colors;

  const WalletScreen({super.key, required this.colors});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _hideBalance = false;
  bool _localLockEnabled = true;
  int _selectedCardIndex = 0;
  late final PageController _cardPageController;

  // Pos Anggaran Bulanan Wajar (~Rp 2.85 Juta pengeluaran, target Rp 3.5 Juta)
  final List<Map<String, dynamic>> _budgetEnvelopes = [
    {
      'category': 'Kebutuhan Pokok & Dapur',
      'spent': 'Rp 1.250.000',
      'limit': 'Rp 1.500.000',
      'percent': 0.83,
      'remaining': 'Sisa Rp 250.000',
      'status': 'Aman',
      'color': const Color(0xFF6C5CE7),
      'icon': Icons.shopping_basket_outlined,
    },
    {
      'category': 'Restoran, Kafe & Kuliner',
      'spent': 'Rp 680.000',
      'limit': 'Rp 900.000',
      'percent': 0.75,
      'remaining': 'Sisa Rp 220.000',
      'status': 'Terkendali',
      'color': const Color(0xFFE17055),
      'icon': Icons.restaurant_outlined,
    },
    {
      'category': 'Tagihan Listrik & Internet',
      'spent': 'Rp 420.000',
      'limit': 'Rp 500.000',
      'percent': 0.84,
      'remaining': 'Sisa Rp 80.000',
      'status': 'Mendekati Limit',
      'color': const Color(0xFFD63031),
      'icon': Icons.receipt_long_outlined,
    },
    {
      'category': 'Tabungan & Dana Darurat',
      'spent': 'Rp 500.000',
      'limit': 'Rp 600.000',
      'percent': 0.83,
      'remaining': 'Sisa Rp 100.000',
      'status': 'Target Berjalan',
      'color': const Color(0xFF00B894),
      'icon': Icons.savings_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _cardPageController = PageController(viewportFraction: 0.90);
  }

  @override
  void dispose() {
    _cardPageController.dispose();
    super.dispose();
  }

  void _scrollToCard(int index) {
    final count = cardsRegistryNotifier.value.length;
    if (index >= 0 && index <= count) {
      _cardPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _showManualInputDialog(BuildContext context) {
    final c = widget.colors;
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: c.border, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.sub.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Catat Transaksi Manual (Offline)',
                style: poppins(17, c.text, w: FontWeight.w600),
              ),
              Text(
                'Tersimpan aman di database memori lokal',
                style: poppins(11, c.sub, w: FontWeight.w400),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: titleController,
                style: poppins(13, c.text),
                decoration: InputDecoration(
                  labelText: 'Keterangan Pengeluaran',
                  labelStyle: poppins(12, c.sub),
                  filled: true,
                  fillColor: c.iconCircle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: c.border),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: poppins(13, c.text),
                decoration: InputDecoration(
                  labelText: 'Nominal (Rp)',
                  labelStyle: poppins(12, c.sub),
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: c.iconCircle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: c.border),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: c.panel,
                        content: Text('Transaksi pengeluaran berhasil disimpan offline!', style: poppins(12, c.text)),
                      ),
                    );
                  },
                  child: Text('Simpan Pengeluaran', style: poppins(13, Colors.white, w: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;

    return ValueListenableBuilder<List<CardItem>>(
      valueListenable: cardsRegistryNotifier,
      builder: (context, cards, _) {
        final totalBalance = cards.fold<double>(0, (sum, item) => sum + item.balance);
        final totalFormatted = 'Rp ${totalBalance.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            // Top Bar dengan Tombol QR Pindai di Pojok Kanan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dompet & Anggaran',
                        style: poppins(23, c.text, w: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pelacak pos dana & keuangan offline',
                        style: poppins(11, c.sub, w: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                // Tombol Logo QR di pojok kanan atas menggantikan tombol Catat
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => QrScanModal.show(context, colors: widget.colors),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c.headerBtn,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.border.withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 21,
                        color: c.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Kartu Ringkasan Total Saldo Terlacak Offline
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E676).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.cloud_off_rounded, size: 12, color: Color(0xFF00E676)),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Total Saldo Terpantau (Offline)',
                            style: poppins(11.5, c.sub, w: FontWeight.w400),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _hideBalance = !_hideBalance),
                        child: Icon(
                          _hideBalance ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          size: 19,
                          color: c.sub,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _hideBalance ? '••••••••••••' : totalFormatted,
                            style: poppins(24, c.text, w: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Tercatat',
                          style: poppins(10, const Color(0xFF00E676), w: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: c.border, height: 1),
                  const SizedBox(height: 14),

                  // Aksi Pelacak Keuangan Terpadu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _trackerActionBtn(
                          icon: Icons.edit_note_rounded,
                          label: 'Catat Manual',
                          onTap: () => _showManualInputDialog(context),
                        ),
                      ),
                      Expanded(
                        child: _trackerActionBtn(
                          icon: Icons.receipt_long_rounded,
                          label: 'Foto Struk',
                          onTap: () => QrScanModal.show(context, colors: widget.colors),
                        ),
                      ),
                      Expanded(
                        child: _trackerActionBtn(
                          icon: Icons.file_download_outlined,
                          label: 'Ekspor Data',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: c.panel,
                                content: Text('Data transaksi diekspor ke format CSV lokal', style: poppins(12, c.text)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Header Carousel Sumber Dana Tercatat & Tombol Tambah Kartu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Sumber Dana Tercatat',
                          style: poppins(14, c.text, w: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${cards.isEmpty ? 0 : (_selectedCardIndex < cards.length ? _selectedCardIndex + 1 : cards.length)}/${cards.length})',
                        style: poppins(11.5, c.sub, w: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Tambah Sumber Dana / Kartu Baru
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: () => _showAddAccountModal(context),
                      icon: const Icon(Icons.add_rounded, size: 14),
                      label: Text('Tambah Kartu', style: poppins(11, Colors.white, w: FontWeight.w600)),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: _selectedCardIndex > 0 ? () => _scrollToCard(_selectedCardIndex - 1) : null,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: c.iconCircle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 18,
                          color: _selectedCardIndex > 0 ? c.text : c.sub.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _selectedCardIndex < cards.length ? () => _scrollToCard(_selectedCardIndex + 1) : null,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: c.iconCircle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: _selectedCardIndex < cards.length ? c.text : c.sub.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Carousel Kartu Mewah Sesuai Desain Mandiri Debit Gold, BRI Prioritas, Cash, & Kartu Kustom
            ListenableBuilder(
              listenable: Listenable.merge([cardBackgroundNotifier, briCardBackgroundNotifier]),
              builder: (context, _) {
                final cardBg = cardBackgroundNotifier.value;
                final briBg = briCardBackgroundNotifier.value;
                return SizedBox(
                  height: 202,
                  child: ScrollConfiguration(
                    behavior: const MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: PageView.builder(
                      itemCount: cards.length + 1,
                      controller: _cardPageController,
                      onPageChanged: (i) => setState(() => _selectedCardIndex = i),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        if (i == cards.length) {
                          return _buildAddCardSlot(c);
                        }

                        final card = cards[i];
                        final isMandiri = card.isMandiri;
                        final isBri = card.isBri;
                        final isCash = card.isCash;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.22),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              children: [
                                // Background Kartu
                                Positioned.fill(
                                  child: isMandiri
                                      ? _buildMandiriBg(cardBg)
                                      : isBri
                                          ? _buildBriBg(briBg)
                                          : card.customImageBytes != null
                                              ? Image.memory(
                                                  card.customImageBytes!,
                                                  fit: BoxFit.cover,
                                                )
                                              : card.gradientColors != null
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: card.gradientColors!,
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                      ),
                                                      child: const CustomPaint(
                                                        painter: BatikPatternPainter(color: Colors.white),
                                                      ),
                                                    )
                                                  : Container(
                                                      decoration: const BoxDecoration(
                                                        gradient: AppColors.darkCardGradient,
                                                      ),
                                                      child: const CustomPaint(
                                                        painter: BatikPatternPainter(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                ),

                                // Konten Kartu
                                if (isMandiri)
                                  _buildMandiriCardContent(card, cardBg)
                                else if (isBri)
                                  _buildBriCardContent(card, briBg)
                                else if (isCash)
                                  _buildCashCardContent(card)
                                else
                                  _buildCustomCardContent(card),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // Indikator Titik Carousel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cards.length + 1, (idx) {
                final isCurrent = _selectedCardIndex == idx;
                return GestureDetector(
                  onTap: () => _scrollToCard(idx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isCurrent ? 24 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isCurrent ? c.text : c.sub.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Pos Anggaran Bulanan (Dashboard Bersih & Mewah)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pos Anggaran Bulanan', style: poppins(14.5, c.text, w: FontWeight.w600)),
                Text('81% Terpakai', style: poppins(11, c.sub, w: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),

            // Ringkasan Alokasi Anggaran Bulanan
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: c.panel,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
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
                            Text('Sisa Kuota Anggaran', style: poppins(10.5, c.sub, w: FontWeight.w400)),
                            const SizedBox(height: 2),
                            Text('Rp 650.000', style: poppins(19, c.text, w: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total Target Belanja', style: poppins(10.5, c.sub, w: FontWeight.w400)),
                          const SizedBox(height: 2),
                          Text('Rp 3.500.000', style: poppins(13.5, c.text, w: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Bar Alokasi Terpadu Multi-Segmen
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 36,
                            child: Container(color: const Color(0xFF6C5CE7)),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: 19,
                            child: Container(color: const Color(0xFFE17055)),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: 12,
                            child: Container(color: const Color(0xFFD63031)),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: 14,
                            child: Container(color: const Color(0xFF00B894)),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            flex: 19,
                            child: Container(color: c.iconCircle),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Batas belanja aman: ~Rp 45.000 / hari untuk sisa bulan ini.',
                    style: poppins(10.5, c.sub, w: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

        // Rincian Pos Anggaran per Kategori
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Column(
            children: List.generate(_budgetEnvelopes.length, (i) {
              final b = _budgetEnvelopes[i];
              final isLast = i == _budgetEnvelopes.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
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
                          child: Icon(b['icon'] as IconData, size: 18, color: c.text),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b['category'] as String,
                                style: poppins(12.5, c.text, w: FontWeight.w500),
                              ),
                              Text(
                                b['remaining'] as String,
                                style: poppins(10, c.sub, w: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              b['spent'] as String,
                              style: poppins(12.5, c.text, w: FontWeight.w600),
                            ),
                            Text(
                              'dari ${b['limit']}',
                              style: poppins(10, c.sub, w: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(color: c.border.withValues(alpha: 0.5), height: 1),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 24),

        // Pengaturan Penyimpanan Data Offline
        Text('Penyimpanan & Keamanan Lokal', style: poppins(14.5, c.text, w: FontWeight.w600)),
        const SizedBox(height: 12),
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
                value: _localLockEnabled,
                onChanged: (val) {
                  setState(() => _localLockEnabled = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: c.panel,
                      content: Text(
                        val ? 'Kunci aplikasi offline aktif' : 'Kunci aplikasi dinonaktifkan',
                        style: poppins(12, c.text),
                      ),
                    ),
                  );
                },
                title: Text('Kunci Catatan Keuangan', style: poppins(12.5, c.text, w: FontWeight.w500)),
                subtitle: Text('Gunakan PIN/Biometrik saat membuka', style: poppins(10, c.sub, w: FontWeight.w400)),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: c.iconCircle, shape: BoxShape.circle),
                  child: Icon(Icons.lock_outline_rounded, size: 18, color: c.text),
                ),
              ),
              Divider(color: c.border.withValues(alpha: 0.6), height: 1, indent: 56),
              ListTile(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: c.panel,
                      content: Text('Semua catatan tersimpan di database lokal (SQLite)', style: poppins(12, c.text)),
                    ),
                  );
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: c.iconCircle, shape: BoxShape.circle),
                  child: Icon(Icons.storage_rounded, size: 18, color: c.text),
                ),
                title: Text('Database Penyimpanan Offline', style: poppins(12.5, c.text, w: FontWeight.w500)),
                subtitle: Text('100% data tersimpan di memori perangkat lokal', style: poppins(10, c.sub, w: FontWeight.w400)),
                trailing: Icon(Icons.chevron_right_rounded, size: 18, color: c.sub),
              ),
            ],
          ),
        ),
      ],
    );
  },
);
}

  Widget _buildMandiriBg(String cardBg) {
    if (cardBg == 'custom_image' && cardCustomImageBytesNotifier.value != null) {
      return Image.memory(
        cardCustomImageBytesNotifier.value!,
        fit: BoxFit.cover,
      );
    } else if (cardBg == 'gold_wayang') {
      return Image.asset(
        'assets/images/mandiri_gold_card.png',
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => Container(
          decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        ),
      );
    } else if (cardBg == 'custom_color' || cardBg.startsWith('theme_')) {
      final colors = cardCustomColorsNotifier.value;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const CustomPaint(
          painter: BatikPatternPainter(color: Colors.white),
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        child: const CustomPaint(
          painter: BatikPatternPainter(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildBriBg(String briBg) {
    if (briBg == 'custom_image' && briCardCustomImageBytesNotifier.value != null) {
      return Image.memory(
        briCardCustomImageBytesNotifier.value!,
        fit: BoxFit.cover,
      );
    } else if (briBg == 'gold_wayang') {
      return Image.asset(
        'assets/images/mandiri_gold_card.png',
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => Container(
          decoration: const BoxDecoration(gradient: AppColors.yellowGradient),
        ),
      );
    } else if (briBg == 'custom_color' || briBg.startsWith('theme_') || briBg == 'purple') {
      final colors = briBg == 'purple'
          ? const [Color(0xFF6C5CE7), Color(0xFF3B2A82)]
          : briCardCustomColorsNotifier.value;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const CustomPaint(
          painter: BatikPatternPainter(color: Colors.white),
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(gradient: AppColors.yellowGradient),
        child: CustomPaint(
          painter: BatikPatternPainter(color: Colors.black.withValues(alpha: 0.08)),
        ),
      );
    }
  }

  Widget _buildMandiriCardContent(CardItem card, String cardBg) {
    final isGoldCard = cardBg == 'gold_wayang';
    final textColor = isGoldCard ? const Color(0xFF1B2A4A) : Colors.white;
    final subColor = isGoldCard
        ? const Color(0xFF1B2A4A).withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.85);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const EmvGoldenChip(),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => CardCustomizerModal.show(context, colors: widget.colors),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.palette_outlined, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Ganti Desain',
                            style: poppins(9, Colors.white, w: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              MandiriOfficialLogo(isGoldBg: isGoldCard),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              card.number,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 15,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w800,
                color: textColor,
                shadows: [
                  Shadow(
                    color: isGoldCard
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.black.withValues(alpha: 0.6),
                    blurRadius: 2,
                    offset: const Offset(0.8, 0.8),
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                card.prefix,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: subColor,
                ),
              ),
              const SizedBox(width: 22),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('VALID', style: poppins(5.5, subColor, w: FontWeight.w700, height: 1.0)),
                      Text('THRU', style: poppins(5.5, subColor, w: FontWeight.w700, height: 1.0)),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('MONTH/YEAR', style: poppins(5.5, subColor, w: FontWeight.w600, height: 1.0)),
                      const SizedBox(height: 1),
                      Text(
                        card.exp,
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  card.holder,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    'ELECTRONIC USE ONLY',
                    style: poppins(6.5, subColor, w: FontWeight.w600, letterSpacing: 0.6),
                    maxLines: 1,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VisaLogo(isDarkText: isGoldCard, height: 12),
                      const SizedBox(height: 1),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          card.formattedBalance,
                          style: poppins(12.5, textColor, w: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBriCardContent(CardItem card, String briBg) {
    final isYellowDefault = briBg == 'yellow_prioritas';
    final isGoldCard = briBg == 'gold_wayang';
    final isDark = !isYellowDefault && !isGoldCard;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white70 : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const EmvGoldenChip(),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => CardCustomizerModal.show(context, colors: widget.colors, initialCard: 'bri'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.palette_outlined, size: 12, color: textColor),
                          const SizedBox(width: 4),
                          Text(
                            'Ganti Desain',
                            style: poppins(9, textColor, w: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const BriCardLogo(),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              card.number,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 15,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                card.prefix,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: subColor,
                ),
              ),
              const SizedBox(width: 22),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('VALID', style: poppins(5.5, subColor, w: FontWeight.w700, height: 1.0)),
                      Text('THRU', style: poppins(5.5, subColor, w: FontWeight.w700, height: 1.0)),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('MONTH/YEAR', style: poppins(5.5, subColor, w: FontWeight.w600, height: 1.0)),
                      const SizedBox(height: 1),
                      Text(
                        card.exp,
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  card.holder,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    'ELECTRONIC USE ONLY',
                    style: poppins(6.5, subColor, w: FontWeight.w600, letterSpacing: 0.6),
                    maxLines: 1,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VisaLogo(isDarkText: !isDark, height: 12),
                      const SizedBox(height: 1),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          card.formattedBalance,
                          style: poppins(12.5, textColor, w: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCardContent(CardItem card) {
    const textColor = Colors.white;
    const subColor = Colors.white70;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const EmvGoldenChip(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 0.8),
                ),
                child: Text(
                  card.bankName,
                  style: poppins(10, Colors.white, w: FontWeight.w600),
                ),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              card.number,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 15,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                card.prefix,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: subColor,
                ),
              ),
              const SizedBox(width: 22),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('VALID', style: poppins(5.5, subColor, w: FontWeight.w700, height: 1.0)),
                      Text('THRU', style: poppins(5.5, subColor, w: FontWeight.w700, height: 1.0)),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('MONTH/YEAR', style: poppins(5.5, subColor, w: FontWeight.w600, height: 1.0)),
                      const SizedBox(height: 1),
                      Text(
                        card.exp,
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  card.holder,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    'ELECTRONIC USE ONLY',
                    style: poppins(6.5, subColor, w: FontWeight.w600, letterSpacing: 0.6),
                    maxLines: 1,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const VisaLogo(isDarkText: false, height: 12),
                      const SizedBox(height: 1),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          card.formattedBalance,
                          style: poppins(12.5, textColor, w: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCashCardContent(CardItem card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.payments_outlined, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Kas Dompet Fisik', style: poppins(12.5, Colors.white, w: FontWeight.w600)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('TUNAI', style: poppins(8, Colors.white, w: FontWeight.w700)),
              ),
            ],
          ),
          Text('Dana Tunai Siap Pakai', style: poppins(12.5, Colors.white70, w: FontWeight.w400)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tersimpan di Dompet', style: poppins(8.5, Colors.white60, w: FontWeight.w400)),
                    Text('Nico', style: poppins(11, Colors.white, w: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Text(
                  card.formattedBalance,
                  style: poppins(15, Colors.white, w: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Slot Kartu Tambah Sumber Dana Baru di Carousel
  Widget _buildAddCardSlot(AppColors c) {
    return GestureDetector(
      onTap: () => _showAddAccountModal(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: c.iconCircle.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: c.border.withValues(alpha: 0.8),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_card_rounded, size: 24, color: AppColors.purple),
              ),
              const SizedBox(height: 10),
              Text(
                'Tambah Rekening / Kartu Baru',
                style: poppins(13.5, c.text, w: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                'Kustom tema warna atau unggah foto kartu',
                style: poppins(11, c.sub, w: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modal Tambah Sumber Dana / Kartu Baru
  void _showAddAccountModal(BuildContext context) {
    final c = widget.colors;
    final bankCtrl = TextEditingController(text: 'BCA Prioritas Platinum');
    final numberCtrl = TextEditingController(text: '4128 8891 0021 3492');
    final holderCtrl = TextEditingController(text: 'NICO');
    final expCtrl = TextEditingController(text: '12/29');
    final balanceCtrl = TextEditingController(text: 'Rp 1.500.000');
    String selectedType = 'Kartu Debit';
    Uint8List? uploadedImageBytes;
    int selectedColorIndex = 0;

    final colorGradients = [
      [const Color(0xFF1A2980), const Color(0xFF26D0CE)], // BCA Navy Cyan
      [const Color(0xFF6C5CE7), const Color(0xFF3B2A82)], // Royal Purple
      [const Color(0xFF0F9B0F), const Color(0xFF004D40)], // Emerald
      [const Color(0xFFD4AC0D), const Color(0xFF9A7D0A)], // Gold
      [const Color(0xFFB71C1C), const Color(0xFF880E4F)], // Crimson
      [const Color(0xFF232526), const Color(0xFF414345)], // Obsidian
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.88),
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
              decoration: BoxDecoration(
                color: c.panel,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: c.border, width: 1),
              ),
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: c.sub.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tambah Sumber Dana / Kartu', style: poppins(17.5, c.text, w: FontWeight.w600)),
                          Text('Tambahkan rekening atau kartu perbankan baru', style: poppins(11, c.sub, w: FontWeight.w400)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: c.iconCircle, shape: BoxShape.circle),
                          child: Icon(Icons.close_rounded, size: 18, color: c.text),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Jenis Sumber Dana
                  Text('JENIS SUMBER DANA', style: poppins(10.5, c.sub, w: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Kartu Debit', 'Rekening Bank', 'E-Wallet', 'Kas Tunai'].map((type) {
                      final isSel = selectedType == type;
                      return ChoiceChip(
                        selected: isSel,
                        label: Text(type, style: poppins(11, isSel ? Colors.white : c.text, w: FontWeight.w500)),
                        selectedColor: AppColors.purple,
                        backgroundColor: c.iconCircle,
                        onSelected: (val) {
                          if (val) setModalState(() => selectedType = type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Nama Bank / Kartu
                  Text('NAMA BANK / LAYANAN', style: poppins(10.5, c.sub, w: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: bankCtrl,
                    style: poppins(12.5, c.text),
                    decoration: InputDecoration(
                      hintText: 'Contoh: BCA Prioritas, Mandiri Payroll, GoPay',
                      filled: true,
                      fillColor: c.iconCircle,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Nomor Kartu / Akun
                  Text('NOMOR KARTU / REKENING', style: poppins(10.5, c.sub, w: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: numberCtrl,
                    style: TextStyle(fontFamily: 'Courier', fontSize: 13, fontWeight: FontWeight.w600, color: c.text),
                    decoration: InputDecoration(
                      hintText: 'xxxx xxxx xxxx xxxx',
                      filled: true,
                      fillColor: c.iconCircle,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Row: Masa Berlaku & Saldo Awal
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MASA BERLAKU', style: poppins(10.5, c.sub, w: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: expCtrl,
                              style: TextStyle(fontFamily: 'Courier', fontSize: 13, fontWeight: FontWeight.w600, color: c.text),
                              decoration: InputDecoration(
                                hintText: 'BB/TT (Contoh: 12/29)',
                                filled: true,
                                fillColor: c.iconCircle,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SALDO AWAL', style: poppins(10.5, c.sub, w: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: balanceCtrl,
                              style: poppins(12.5, c.text, w: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Rp 0',
                                filled: true,
                                fillColor: c.iconCircle,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Kustom Desain Kartu (Warna / Gambar Galeri)
                  Text('DESAIN & WARNA KARTU', style: poppins(10.5, c.sub, w: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(colorGradients.length, (idx) {
                        final isSel = uploadedImageBytes == null && selectedColorIndex == idx;
                        return GestureDetector(
                          onTap: () => setModalState(() {
                            selectedColorIndex = idx;
                            uploadedImageBytes = null;
                          }),
                          child: Container(
                            width: 34,
                            height: 34,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: colorGradients[idx]),
                              border: Border.all(
                                color: isSel ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSel
                                  ? [
                                      BoxShadow(
                                        color: colorGradients[idx].first.withValues(alpha: 0.5),
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSel ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                          ),
                        );
                      }),
                      // Tombol Upload dari Galeri
                      GestureDetector(
                        onTap: () async {
                          final bytes = await pickCustomCardImage();
                          if (bytes != null) {
                            setModalState(() {
                              uploadedImageBytes = bytes;
                            });
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: c.iconCircle,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: uploadedImageBytes != null ? AppColors.purple : c.border,
                              width: uploadedImageBytes != null ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            uploadedImageBytes != null ? Icons.photo_library_rounded : Icons.add_photo_alternate_outlined,
                            size: 18,
                            color: uploadedImageBytes != null ? AppColors.purple : c.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (uploadedImageBytes != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF00E676)),
                        const SizedBox(width: 4),
                        Text('Foto galeri dipilih', style: poppins(10, const Color(0xFF00E676), w: FontWeight.w500)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setModalState(() => uploadedImageBytes = null),
                          child: Text('Hapus Foto', style: poppins(10, Colors.redAccent, w: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 22),

                  // Tombol Simpan
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final bankName = bankCtrl.text.trim();
                      if (bankName.isEmpty) return;

                      final numText = numberCtrl.text.trim();
                      final prefixText = numText.length >= 4 ? numText.substring(0, 4) : 'CARD';
                      final numDigitsOnly = balanceCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
                      final parsedBalance = double.tryParse(numDigitsOnly) ?? 1500000.0;

                      final newCard = CardItem(
                        id: 'card_${DateTime.now().millisecondsSinceEpoch}',
                        bankName: bankName,
                        type: selectedType,
                        number: numText.isNotEmpty ? numText : '4000 1234 5678 9010',
                        prefix: prefixText,
                        holder: holderCtrl.text.trim().isNotEmpty ? holderCtrl.text.trim().toUpperCase() : 'NICO',
                        exp: expCtrl.text.trim().isNotEmpty ? expCtrl.text.trim() : '12/29',
                        balance: parsedBalance,
                        bgType: uploadedImageBytes != null ? 'custom_image' : 'custom_color',
                        customImageBytes: uploadedImageBytes,
                        gradientColors: uploadedImageBytes == null ? colorGradients[selectedColorIndex] : null,
                      );

                      cardsRegistryNotifier.value = [...cardsRegistryNotifier.value, newCard];
                      setState(() {
                        _selectedCardIndex = cardsRegistryNotifier.value.length - 1;
                      });

                      Navigator.pop(ctx);
                      _scrollToCard(cardsRegistryNotifier.value.length - 1);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: widget.colors.panel,
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Sumber dana "$bankName" berhasil ditambahkan & tersinkronisasi!',
                                  style: poppins(12.5, widget.colors.text, w: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text('Simpan Sumber Dana', style: poppins(13, Colors.white, w: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _trackerActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final c = widget.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.iconCircle,
                shape: BoxShape.circle,
                border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
              ),
              child: Icon(icon, size: 19, color: c.text),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: poppins(11, c.text, w: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}

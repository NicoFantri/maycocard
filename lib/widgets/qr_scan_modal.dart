import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/text_styles.dart';

/// Modal dialog untuk Pindai QRIS dan Foto Struk Belanja Otomatis (OCR)
class QrScanModal extends StatefulWidget {
  final AppColors colors;
  final void Function(String merchant, String amount)? onReceiptScanned;

  const QrScanModal({
    super.key,
    required this.colors,
    this.onReceiptScanned,
  });

  static Future<void> show(
    BuildContext context, {
    required AppColors colors,
    void Function(String merchant, String amount)? onReceiptScanned,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => QrScanModal(
        colors: colors,
        onReceiptScanned: onReceiptScanned,
      ),
    );
  }

  @override
  State<QrScanModal> createState() => _QrScanModalState();
}

class _QrScanModalState extends State<QrScanModal> with SingleTickerProviderStateMixin {
  int _activeTab = 0; // 0 = Pindai QRIS, 1 = Foto Struk
  bool _flashOn = false;
  bool _isProcessing = false;
  late final AnimationController _scanAnimController;

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
    super.dispose();
  }

  void _simulateCaptureReceipt() {
    setState(() => _isProcessing = true);
    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      Navigator.pop(context);

      const detectedMerchant = 'Indomaret Point FX Sudirman';
      const detectedAmount = 'Rp 64.500';

      widget.onReceiptScanned?.call(detectedMerchant, detectedAmount);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: const Color(0xFF1E1E28),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF00E676),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Struk Belanja Terdeteksi!',
                      style: poppins(12.5, Colors.white, w: FontWeight.w600),
                    ),
                    Text(
                      '$detectedMerchant • $detectedAmount',
                      style: poppins(11, Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void _simulateScanQris() {
    setState(() => _isProcessing = true);
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: const Color(0xFF1E1E28),
          content: Row(
            children: [
              const Icon(Icons.qr_code_2_rounded, color: AppColors.purple, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'QRIS Merchant Nasional terverifikasi: Kopi Kenangan Mall',
                  style: poppins(12, Colors.white, w: FontWeight.w500),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.82,
      decoration: BoxDecoration(
        color: c.dark ? const Color(0xFF121218) : const Color(0xFFF9F9FC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: c.dark ? Colors.white12 : Colors.black12,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: c.sub.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activeTab == 0 ? 'Pindai QRIS' : 'Foto Struk Belanja',
                      style: poppins(18, c.text, w: FontWeight.w600),
                    ),
                    Text(
                      _activeTab == 0
                          ? 'Bayar instan di merchant QRIS'
                          : 'Pencatatan otomatis pengeluaran via OCR',
                      style: poppins(11, c.sub, w: FontWeight.w400),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.iconCircle,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 20, color: c.text),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab Selector: QRIS vs Foto Struk
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: c.panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _activeTab == 0 ? c.text : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 16,
                            color: _activeTab == 0
                                ? (c.dark ? Colors.black : Colors.white)
                                : c.sub,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Pindai QRIS',
                            style: poppins(
                              12,
                              _activeTab == 0
                                  ? (c.dark ? Colors.black : Colors.white)
                                  : c.sub,
                              w: _activeTab == 0 ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _activeTab == 1 ? c.text : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 16,
                            color: _activeTab == 1
                                ? (c.dark ? Colors.black : Colors.white)
                                : c.sub,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Foto Struk Belanja',
                            style: poppins(
                              12,
                              _activeTab == 1
                                  ? (c.dark ? Colors.black : Colors.white)
                                  : c.sub,
                              w: _activeTab == 1 ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Camera Viewfinder Box
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Camera Simulation Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background Grid Line subtle pattern
                          Opacity(
                            opacity: 0.12,
                            child: GridPaper(
                              color: Colors.white,
                              divisions: 2,
                              subdivisions: 1,
                            ),
                          ),

                          // Scanner Viewfinder Cutout
                          Center(
                            child: Container(
                              width: _activeTab == 0 ? 210 : 230,
                              height: _activeTab == 0 ? 210 : 270,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.purple.withValues(alpha: 0.8),
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Corner accent brackets
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: _cornerBracket(true, true),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: _cornerBracket(true, false),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: _cornerBracket(false, true),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: _cornerBracket(false, false),
                                  ),

                                  // Animated Laser Line
                                  AnimatedBuilder(
                                    animation: _scanAnimController,
                                    builder: (context, child) {
                                      final travelHeight = _activeTab == 0 ? 190.0 : 250.0;
                                      return Positioned(
                                        top: 10 + (_scanAnimController.value * travelHeight),
                                        left: 10,
                                        right: 10,
                                        child: Container(
                                          height: 2.5,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00E676),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF00E676).withValues(alpha: 0.8),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  // Watermark Hint Inside Viewfinder
                                  Center(
                                    child: Text(
                                      _activeTab == 0
                                          ? 'Arahkan ke Kode QRIS'
                                          : 'Posisikan Struk Belanja\ndi dalam Kotak Ini',
                                      textAlign: TextAlign.center,
                                      style: poppins(
                                        11,
                                        Colors.white.withValues(alpha: 0.65),
                                        w: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Flashlight button top right of camera
                          Positioned(
                            top: 16,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => setState(() => _flashOn = !_flashOn),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _flashOn ? Colors.white : Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                                  size: 18,
                                  color: _flashOn ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // Loading Overlay when processing
                          if (_isProcessing)
                            Container(
                              color: Colors.black.withValues(alpha: 0.75),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      _activeTab == 0
                                          ? 'Membaca QRIS Merchant...'
                                          : 'Membaca OCR Teks Struk...',
                                      style: poppins(12.5, Colors.white, w: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Bottom Action Bar: Shutter button or Gallery upload
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: c.panel,
                        content: Text('Pilih foto struk dari galeri perangkat', style: poppins(12, c.text)),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.iconCircle,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
                        ),
                        child: Icon(Icons.photo_library_outlined, size: 20, color: c.text),
                      ),
                      const SizedBox(height: 4),
                      Text('Galeri', style: poppins(10.5, c.sub, w: FontWeight.w400)),
                    ],
                  ),
                ),

                // Main Shutter / Action Button
                GestureDetector(
                  onTap: _isProcessing
                      ? null
                      : () {
                          if (_activeTab == 0) {
                            _simulateScanQris();
                          } else {
                            _simulateCaptureReceipt();
                          }
                        },
                  child: Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.purpleGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: Icon(
                        _activeTab == 0 ? Icons.qr_code_scanner_rounded : Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),

                // Input Kode Merchant Manual
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: c.panel,
                        content: Text('Masukkan kode pembayaran manual', style: poppins(12, c.text)),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.iconCircle,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
                        ),
                        child: Icon(Icons.dialpad_rounded, size: 20, color: c.text),
                      ),
                      const SizedBox(height: 4),
                      Text('Kode', style: poppins(10.5, c.sub, w: FontWeight.w400)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerBracket(bool top, bool left) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          bottom: !top ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          left: left ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          right: !left ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/text_styles.dart';
import '../models/card_item.dart';
import 'batik_pattern_painter.dart';
import 'card_customizer_modal.dart';
import 'notch_clipper.dart';
import 'visa_logo.dart';

/// Komponen CardStack Dinamis di Beranda:
/// Tersinkronisasi otomatis dengan seluruh kartu yang ditambahkan dari halaman Dompet
class CardStack extends StatefulWidget {
  final AppColors colors;
  final VoidCallback? onAddCard;

  const CardStack({
    super.key,
    required this.colors,
    this.onAddCard,
  });

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> with SingleTickerProviderStateMixin {
  static const double _yellowPeek = 54;
  static const double _cardH = 192;
  static const double _notchW = 128;
  static const double _notchH = 52;

  late final AnimationController _cycleController;
  late final Animation<double> _cycleCurve;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _cycleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _cycleCurve = CurvedAnimation(
      parent: _cycleController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _cycleController.dispose();
    super.dispose();
  }

  void _cycleCard() {
    if (_cycleController.isAnimating) return;
    _cycleController.forward(from: 0.0);
    setState(() {
      final total = cardsRegistryNotifier.value.length;
      if (total > 0) {
        _currentIndex = (_currentIndex + 1) % total;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _yellowPeek + _cardH,
      child: ValueListenableBuilder<List<CardItem>>(
        valueListenable: cardsRegistryNotifier,
        builder: (context, cardList, _) {
          if (cardList.isEmpty) {
            return const SizedBox.shrink();
          }

          final total = cardList.length;
          final safeIndex = _currentIndex % total;

          return AnimatedBuilder(
            animation: _cycleCurve,
            builder: (context, child) {
              final t = _cycleCurve.value;

              // Susun lapisan kartu dari belakang ke depan
              List<Widget> layers = [];

              if (total >= 3) {
                final backCard = cardList[(safeIndex + 2) % total];
                layers.add(
                  Positioned(
                    key: ValueKey('back_card_${backCard.id}'),
                    top: 0,
                    left: 0,
                    right: 0,
                    height: _cardH,
                    child: Transform.scale(
                      scale: 0.90,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: _cycleCard,
                        child: _buildCardView(backCard, isFront: false, shadowOpacity: 0.08),
                      ),
                    ),
                  ),
                );
              }

              if (total >= 2) {
                final midCard = cardList[(safeIndex + 1) % total];
                final midTop = total >= 3 ? 27.0 : 0.0;
                final midScale = total >= 3 ? 0.95 : 0.94;
                layers.add(
                  Positioned(
                    key: ValueKey('mid_card_${midCard.id}'),
                    top: midTop,
                    left: 0,
                    right: 0,
                    height: _cardH,
                    child: Transform.scale(
                      scale: midScale,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: _cycleCard,
                        child: _buildCardView(midCard, isFront: false, shadowOpacity: 0.12),
                      ),
                    ),
                  ),
                );
              }

              // Kartu paling depan (Front Card) dengan transisi slide halus saat berganti
              final frontCard = cardList[safeIndex];
              final slideArc = math.sin(t * math.pi) * 12;

              layers.add(
                Positioned(
                  key: ValueKey('front_card_${frontCard.id}'),
                  top: _yellowPeek - slideArc,
                  left: 0,
                  right: 0,
                  height: _cardH,
                  child: Transform.scale(
                    scale: 0.96 + (0.04 * t),
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: total > 1 ? _cycleCard : null,
                      child: _buildCardView(frontCard, isFront: true, shadowOpacity: 0.24),
                    ),
                  ),
                ),
              );

              // Tombol Tambah Kartu di sudut notch depan
              layers.add(
                Positioned(
                  right: 0,
                  bottom: 0,
                  width: _notchW,
                  height: _notchH - 2,
                  child: _buildAddButton(),
                ),
              );

              return Stack(
                clipBehavior: Clip.none,
                children: layers,
              );
            },
          );
        },
      ),
    );
  }

  /// Membangun Tampilan Kartu Terpadu
  Widget _buildCardView(
    CardItem card, {
    required bool isFront,
    required double shadowOpacity,
  }) {
    final isGoldCard = card.bgType == 'gold_wayang';
    final isYellowPrioritas = card.bgType == 'yellow_prioritas';
    final isLight = isGoldCard || isYellowPrioritas;

    final textColor = isLight ? Colors.black87 : Colors.white;
    final subColor = isLight ? Colors.black54 : Colors.white.withValues(alpha: 0.82);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowOpacity),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipPath(
        clipper: const NotchClipper(
          radius: 26,
          notchW: _notchW,
          notchH: _notchH,
          inner: 16,
        ),
        child: Stack(
          children: [
            // Background Kartu
            Positioned.fill(
              child: _buildCardBackground(card),
            ),

            // Konten Kartu
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Baris Atas: Chip/Logo & Tombol Ganti Desain / Swap
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (card.isCash)
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded, size: 18, color: Colors.white),
                            )
                          else
                            const EmvGoldenChip(),
                          const SizedBox(width: 8),
                          if (isFront)
                            GestureDetector(
                              onTap: () => CardCustomizerModal.show(
                                context,
                                colors: widget.colors,
                                initialCard: card.isMandiri
                                    ? 'mandiri'
                                    : card.isBri
                                        ? 'bri'
                                        : card.id,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: isLight ? 0.12 : 0.25),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: (isLight ? Colors.black : Colors.white).withValues(alpha: 0.2),
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
                      Row(
                        children: [
                          if (card.isMandiri)
                            MandiriOfficialLogo(isGoldBg: isGoldCard)
                          else if (card.isBri)
                            const BriCardLogo()
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                card.bankName,
                                style: poppins(10, textColor, w: FontWeight.w700),
                              ),
                            ),
                          if (!isFront) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.swap_vert_rounded,
                                size: 13,
                                color: textColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  // Nomor Kartu Embossed
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      card.number,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 16,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: isLight
                                ? Colors.white.withValues(alpha: 0.8)
                                : Colors.black.withValues(alpha: 0.6),
                            blurRadius: 2,
                            offset: const Offset(0.8, 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Baris Tengah-Bawah: Prefix & VALID THRU
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        card.prefix,
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: subColor,
                        ),
                      ),
                      const SizedBox(width: 24),
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
                          const SizedBox(width: 5),
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
                                  fontSize: 12.5,
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

                  // Baris Bawah: Nama NICO, ELECTRONIC USE ONLY, Logo VISA & Saldo Realistis
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
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
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
                              VisaLogo(isDarkText: isLight, height: 13),
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
            ),
          ],
        ),
      ),
    );
  }

  /// Latar Belakang Kartu Dinamis
  Widget _buildCardBackground(CardItem card) {
    if (card.bgType == 'custom_image' && card.customImageBytes != null) {
      return Image.memory(
        card.customImageBytes!,
        fit: BoxFit.cover,
      );
    } else if (card.bgType == 'gold_wayang') {
      return Image.asset(
        'assets/images/mandiri_gold_card.png',
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => Container(
          decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        ),
      );
    } else if (card.bgType == 'yellow_prioritas') {
      return Container(
        decoration: const BoxDecoration(gradient: AppColors.yellowGradient),
        child: CustomPaint(
          painter: BatikPatternPainter(color: Colors.black.withValues(alpha: 0.08)),
        ),
      );
    } else if (card.gradientColors != null) {
      return Container(
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
      );
    } else if (card.bgType == 'custom_color') {
      final colors = card.isBri
          ? briCardCustomColorsNotifier.value
          : cardCustomColorsNotifier.value;
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
      // Default Royal Purple Gradient
      return Container(
        decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        child: const CustomPaint(
          painter: BatikPatternPainter(color: Colors.white),
        ),
      );
    }
  }

  /// Tombol Tambah Kartu di sudut notch
  Widget _buildAddButton() {
    final colors = widget.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: widget.onAddCard,
        child: Container(
          decoration: BoxDecoration(
            color: colors.addBtn,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: colors.dark ? Colors.white12 : Colors.black12,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.addPlus,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 19,
                  color: colors.addPlusIcon,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tambah',
                    style: poppins(
                      12,
                      Colors.white,
                      w: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip EMV Emas Realistis Khas Kartu Perbankan
class EmvGoldenChip extends StatelessWidget {
  const EmvGoldenChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFDF79),
            Color(0xFFD4AF37),
            Color(0xFFECC250),
            Color(0xFFB8860B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
        border: Border.all(color: const Color(0xFF8A6D1C), width: 0.7),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 14,
              height: 11,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6B5412), width: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 12.5,
            child: Container(height: 0.5, color: const Color(0xFF6B5412)),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 10,
            child: Container(width: 0.5, color: const Color(0xFF6B5412)),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 10,
            child: Container(width: 0.5, color: const Color(0xFF6B5412)),
          ),
        ],
      ),
    );
  }
}

/// Logo Resmi Bank Mandiri dengan Garis Gelombang Kuning Khas
class MandiriOfficialLogo extends StatelessWidget {
  final bool isGoldBg;

  const MandiriOfficialLogo({super.key, this.isGoldBg = false});

  @override
  Widget build(BuildContext context) {
    final textColor = isGoldBg ? const Color(0xFF003D79) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 34,
          height: 8,
          child: CustomPaint(
            painter: _MandiriYellowWavePainter(),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          'mandiri',
          style: TextStyle(
            fontFamily: 'sans-serif',
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: textColor,
          ),
        ),
        Text(
          isGoldBg ? 'mandiri debit gold' : 'mandiri prioritas',
          style: TextStyle(
            fontFamily: 'sans-serif',
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: textColor.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _MandiriYellowWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB800)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.25, -2, size.width * 0.5, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.75, size.height + 2, size.width, size.height * 0.35)
      ..lineTo(size.width, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.75, size.height + 4, size.width * 0.5, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.25, 2, 0, size.height * 0.95)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Logo Bank BRI
class BriCardLogo extends StatelessWidget {
  const BriCardLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'BRI',
        style: poppins(
          12,
          Colors.white,
          w: FontWeight.w800,
        ),
      ),
    );
  }
}

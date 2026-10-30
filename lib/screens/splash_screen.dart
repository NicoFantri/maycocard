// Onboarding & Splash Screen Track Money - MaycoCard
// Animasi terpadu berbasis 1 AnimationController (12 detik loop mulus).
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'home_screen.dart';

class C {
  static const purple = Color(0xFF6C3CE0);
  static const deep = Color(0xFF2A1470);
  static const lilac = Color(0xFFB79CFF);
  static const soft = Color(0xFFD9CCFA);
  static const key = Color(0xFFE4DAFB);
  static const ink = Color(0xFF1B1035);
  static const muted = Color(0xFF6F6A85);
  static const gold = Color(0xFFF5C542);
  static const gold2 = Color(0xFFE0A82A);
}

/// Fase 0..1 dari controller (12 dtk). Gunakan period 3, 4, 6, atau 12 agar loop mulus.
double ph(double t, double period, [double delay = 0]) =>
    (t * 12 / period + delay) % 1;
double bob(double t, [double d = 0]) => -9 * math.sin(math.pi * ph(t, 4, d));

// ───────────────────────── Halaman Utama Splash / Onboarding ─────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// Alias kompatibel jika diakses via Onboarding
typedef Onboarding = SplashScreen;

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _page = PageController();
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 12))
        ..repeat();
  int _i = 0;

  static const _data = [
    (
      'Hubungkan semua kartu ATM-mu',
      'Satu tempat untuk semua rekening dan kartu, saldo selalu terpantau.',
    ),
    (
      'Catat setiap uang masuk dan keluar',
      'Tarik tunai, transfer, dan belanja tercatat otomatis tanpa ribet.',
    ),
    (
      'Capai target tabunganmu',
      'Pantau progres dan raih pencapaian finansial di satu halaman.',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hormati pengaturan "kurangi animasi" di perangkat
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    _page.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, anim, secondaryAnim) => const HomeScreen(),
        transitionsBuilder: (_, anim, secondaryAnim, child) {
          final curved =
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _next() {
    if (_isLoading) return;
    if (_i < 2) {
      _page.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    } else {
      _startEnteringHome();
    }
  }

  void _startEnteringHome() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Animasi jeda loading transisi halus sebelum beralih ke HomeScreen
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0E17) : Colors.white;
    final textColor = isDark ? Colors.white : C.ink;
    final subColor = isDark ? const Color(0xFFABA7BF) : C.muted;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Brand: Logo Geometris Minimalis & Tipografi Modern MaycoCard Finance (Tanpa Gradien)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BrandMark(isDark: isDark),
                  const SizedBox(width: 11),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: -0.3,
                            color: textColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'MaycoCard ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Finance',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: isDark
                                    ? const Color(0xFFB79CFF)
                                    : C.purple,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Smart Card & Financial Hub',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w400,
                          color: subColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Slider Ilustrasi dan Deskripsi
            Expanded(
              child: PageView.builder(
                controller: _page,
                physics: _isLoading
                    ? const NeverScrollableScrollPhysics()
                    : const PageScrollPhysics(),
                itemCount: _data.length,
                onPageChanged: (i) => setState(() => _i = i),
                itemBuilder: (_, i) => _Slide(
                  i: i,
                  c: _c,
                  title: _data[i].$1,
                  sub: _data[i].$2,
                  titleColor: textColor,
                  subColor: subColor,
                ),
              ),
            ),
            // Indikator Titik Halaman
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (k) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: k == _i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: k == _i
                        ? C.purple
                        : (isDark
                            ? const Color(0xFF2E2748)
                            : const Color(0xFFDCD3F5)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Tombol Navigasi Lanjut / Animasi Loading Masuk Beranda
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: _isLoading
                  ? const _LoadingEnteringHomeButton(
                      key: ValueKey('loading_button'),
                    )
                  : _NextButton(
                      key: const ValueKey('next_button'),
                      c: _c,
                      color: _i == 2 ? C.purple : (isDark ? C.lilac : C.deep),
                      isLast: _i == 2,
                      onTap: _next,
                    ),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.i,
    required this.c,
    required this.title,
    required this.sub,
    required this.titleColor,
    required this.subColor,
  });

  final int i;
  final Animation<double> c;
  final String title, sub;
  final Color titleColor;
  final Color subColor;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: c,
              builder: (_, child) => _Art(i: i, t: c.value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                height: 1.15,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: subColor,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      );
}

// ───────────────────────── Tombol Next / Mulai ─────────────────────────
class _NextButton extends StatelessWidget {
  const _NextButton({
    super.key,
    required this.c,
    required this.color,
    required this.isLast,
    required this.onTap,
  });

  final Animation<double> c;
  final Color color;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: isLast ? 'Mulai Sekarang' : 'Lanjut',
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: c,
                  builder: (_, child) => Transform.rotate(
                    angle: 2 * math.pi * ((c.value * 2) % 1),
                    child: CustomPaint(
                      size: const Size(58, 58),
                      painter: _Ring(),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    isLast
                        ? Icons.arrow_forward_rounded
                        : Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

// ───────────────────────── Animasi Loading Masuk Beranda ─────────────────────────
class _LoadingEnteringHomeButton extends StatelessWidget {
  const _LoadingEnteringHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: C.deep,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE4DAFB).withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332A1470),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 11),
          Text(
            'Menyiapkan MaycoCard...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Logo Brand Geometris (Tanpa Gradien & Non-AI) ─────────────────────────
class _BrandMark extends StatelessWidget {
  final bool isDark;
  const _BrandMark({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF221644) : C.deep,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDark ? const Color(0xFF3B2E6E) : const Color(0xFFE5DEFB),
          width: 1.2,
        ),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(20, 20),
          painter: _BrandMarkPainter(
            color: isDark ? const Color(0xFFD9CCFA) : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  final Color color;
  const _BrandMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Geometric architectural monogram (Modern M facet fold)
    final path = Path()
      ..moveTo(w * 0.16, h * 0.82)
      ..lineTo(w * 0.16, h * 0.22)
      ..lineTo(w * 0.50, h * 0.56)
      ..lineTo(w * 0.84, h * 0.22)
      ..lineTo(w * 0.84, h * 0.82);

    canvas.drawPath(path, stroke);

    // Accent node at top apex
    final dot = Paint()..color = color;
    canvas.drawCircle(Offset(w * 0.50, h * 0.22), 1.8, dot);
  }

  @override
  bool shouldRepaint(covariant _BrandMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _Ring extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = C.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final r = (Offset.zero & s).deflate(2);
    canvas.drawArc(r, math.pi - .9, 1.8, false, p);
    canvas.drawArc(r, -.9, 1.8, false, p);
  }

  @override
  bool shouldRepaint(_Ring o) => false;
}

// ───────────────────────── Ilustrasi ─────────────────────────
class _Art extends StatelessWidget {
  const _Art({required this.i, required this.t});
  final int i;
  final double t;

  @override
  Widget build(BuildContext context) {
    final scene = switch (i) { 0 => _s1(), 1 => _s2(), _ => _s3() };
    return Center(
      child: FittedBox(
        child: SizedBox(
          width: 260,
          height: 310,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(painter: _Swoosh(i)),
              ...scene,
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    Bank b,
    double x,
    double y,
    double deg,
    double d, {
    double top = 155,
  }) =>
      Positioned(
        left: 130 - 75 + x,
        top: top - 47.5 + y,
        child: Transform.rotate(
          angle: deg * math.pi / 180,
          child: Transform.translate(
            offset: Offset(0, bob(t, d)),
            child: BankCard(b, shine: ph(t, 4, d)),
          ),
        ),
      );

  // Layar 1: tiga kartu mengipas
  List<Widget> _s1() => [
        Positioned(left: 14, top: 118 + bob(t), child: const _Mol()),
        Positioned(
          right: 16,
          top: 34 + bob(t, .25),
          child: const _Bubble('+Rp 2.400.000'),
        ),
        _card(Bank.mandiri, -40, 26, -20, 0),
        _card(Bank.bca, -6, 6, -6, .25),
        _card(Bank.bri, 30, -16, 10, .5),
      ];

  // Layar 2: mesin ATM
  List<Widget> _s2() {
    final p = ph(t, 4);
    final dx = p < .15
        ? 70.0
        : p < .5
            ? 70 - 104 * ((p - .15) / .35)
            : p < .7
                ? -34.0
                : -34 + 104 * ((p - .7) / .3);
    return [
      Positioned(left: 20, top: 44 + bob(t), child: const _Planet()),
      Positioned(right: 20, top: 60, child: _Coin(ph(t, 3))),
      // kartu masuk ke slot (digambar sebelum ATM, jadi tertutup badan ATM)
      Positioned(
        left: 170 + dx,
        top: 106,
        child: Transform.scale(
          scale: .45,
          alignment: Alignment.centerLeft,
          child:
              Transform.rotate(angle: .14, child: const BankCard(Bank.mandiri)),
        ),
      ),
      Positioned(left: 64, top: 40, child: _Atm(t)),
    ];
  }

  // Layar 3: tumpukan koin, grafik, target
  List<Widget> _s3() {
    const towers = [(62.0, 5, 0.0), (112.0, 7, .07), (162.0, 9, .14)];
    return [
      CustomPaint(
        size: const Size(260, 310),
        painter: _Chart((ph(t, 4) / .6).clamp(0.0, 1.0)),
      ),
      for (final (x, n, d) in towers)
        Positioned(left: x, bottom: 12, child: _Tower(n, ph(t, 6, d))),
      _card(Bank.bri, 4, 0, -12, .2, top: 112),
      Positioned(left: 20, top: 96, child: _Coin(ph(t, 3))),
      Positioned(right: 18, top: 22 + bob(t, .3), child: const _Target()),
      Positioned(
        right: 42,
        top: 38,
        child: Transform.rotate(
          angle: -.56,
          alignment: Alignment.centerRight,
          child: Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: C.deep,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
      for (final (x, y, d) in const [
        (34.0, 60.0, 0.0),
        (196.0, 150.0, .25),
        (120.0, 36.0, .5)
      ])
        Positioned(
          left: x,
          top: y,
          child: Transform.scale(
            scale: .8 + .9 * math.sin(math.pi * ph(t, 3, d)).abs(),
            child: const Icon(Icons.auto_awesome, size: 12, color: C.purple),
          ),
        ),
    ];
  }
}

class _Swoosh extends CustomPainter {
  _Swoosh(this.i);
  final int i;

  @override
  void paint(Canvas c, Size s) {
    // x dilebarkan (-400..670) supaya swoosh memenuhi lebar layar
    final p = switch (i) {
      0 => Path()
        ..moveTo(-400, 150)
        ..quadraticBezierTo(120, 72, 670, 160)
        ..lineTo(670, 258)
        ..quadraticBezierTo(130, 176, -400, 252)
        ..close(),
      1 => Path()
        ..moveTo(-400, 175)
        ..quadraticBezierTo(130, 105, 670, 140)
        ..lineTo(670, 235)
        ..quadraticBezierTo(130, 195, -400, 262)
        ..close(),
      _ => Path()
        ..moveTo(-400, 250)
        ..quadraticBezierTo(90, 215, 170, 130)
        ..lineTo(670, 70)
        ..lineTo(670, 150)
        ..quadraticBezierTo(160, 215, -400, 300)
        ..close(),
    };
    c.drawPath(p, Paint()..color = C.purple);
  }

  @override
  bool shouldRepaint(_Swoosh o) => o.i != i;
}

// ───────────────────────── Kartu Bank + Motif Batik Kawung ─────────────────────────
enum Bank { mandiri, bca, bri }

class BankCard extends StatelessWidget {
  const BankCard(this.bank, {super.key, this.shine = -1});
  final Bank bank;
  final double shine; // 0..1 = posisi kilau, <0 = tanpa kilau

  @override
  Widget build(BuildContext context) {
    final (bg, fg, line, name) = switch (bank) {
      Bank.mandiri => (C.deep, Colors.white, const Color(0x3DFFFFFF), 'mandiri'),
      Bank.bca => (Colors.white, C.purple, const Color(0x4D6C3CE0), 'BCA'),
      Bank.bri => (C.lilac, C.deep, const Color(0x4D6C3CE0), 'BRI'),
    };
    final band =
        bank == Bank.bca ? const Color(0x1F6C3CE0) : const Color(0x26FFFFFF);
    final small = TextStyle(color: fg, fontSize: 9, letterSpacing: 1.5);

    return Container(
      width: 150,
      height: 95,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(13),
        border:
            bank == Bank.bca ? Border.all(color: const Color(0xFFE4DAF9)) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x332A1470),
            blurRadius: 18,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _Batik(line))),
            Positioned(
              left: 13,
              top: 28,
              child: Container(
                width: 24,
                height: 18,
                decoration: BoxDecoration(
                  color: C.gold,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              right: 11,
              top: 10,
              child: Text(
                name,
                style: TextStyle(
                  color: fg,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .5,
                ),
              ),
            ),
            Positioned(
              left: 13,
              bottom: 10,
              child: Text('•••• 4568', style: small),
            ),
            Positioned(
              right: 11,
              bottom: 10,
              child: Text('DEBIT', style: small.copyWith(fontSize: 8)),
            ),
            if (shine >= 0)
              Positioned(
                left: -50 + shine * 250,
                top: -10,
                bottom: -10,
                child: Transform(
                  transform: Matrix4.skewX(-.3),
                  child: Container(width: 38, color: band),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Motif kawung: 4 elips per kotak 24x24 yang diulang.
class _Batik extends CustomPainter {
  _Batik(this.color);
  final Color color;

  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final dot = Paint()..color = color;
    for (double y = 0; y < s.height; y += 24) {
      for (double x = 0; x < s.width; x += 24) {
        c.drawOval(
          Rect.fromCenter(center: Offset(x + 12, y + 6), width: 10, height: 12),
          p,
        );
        c.drawOval(
          Rect.fromCenter(center: Offset(x + 12, y + 18), width: 10, height: 12),
          p,
        );
        c.drawOval(
          Rect.fromCenter(center: Offset(x + 6, y + 12), width: 12, height: 10),
          p,
        );
        c.drawOval(
          Rect.fromCenter(center: Offset(x + 18, y + 12), width: 12, height: 10),
          p,
        );
        c.drawCircle(Offset(x + 12, y + 12), 1.4, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_Batik o) => o.color != color;
}

// ───────────────────────── Elemen Layar 1 ─────────────────────────
class _Mol extends StatelessWidget {
  const _Mol();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: const Size(72, 58), painter: _MolPainter());
}

class _MolPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    const pts = [
      Offset(8, 42),
      Offset(28, 22),
      Offset(52, 36),
      Offset(64, 12)
    ];
    final line = Paint()
      ..color = C.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    c.drawPath(
      Path()
        ..moveTo(pts[0].dx, pts[0].dy)
        ..lineTo(pts[1].dx, pts[1].dy)
        ..lineTo(pts[2].dx, pts[2].dy)
        ..lineTo(pts[3].dx, pts[3].dy),
      line,
    );
    const r = [6.0, 5.0, 6.0, 5.0];
    for (var k = 0; k < 4; k++) {
      c.drawCircle(pts[k], r[k], Paint()..color = C.deep);
    }
  }

  @override
  bool shouldRepaint(_MolPainter o) => false;
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Stack(clipBehavior: Clip.none, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: C.deep,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Positioned(
          left: 14,
          bottom: -4,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(width: 8, height: 8, color: C.deep),
          ),
        ),
      ]);
}

// ───────────────────────── Elemen Layar 2 ─────────────────────────
class _Atm extends StatelessWidget {
  const _Atm(this.t);
  final double t;

  @override
  Widget build(BuildContext context) {
    const hs = [.8, .45, .65, .9];
    return Container(
      width: 132,
      height: 214,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.soft, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332A1470),
            blurRadius: 22,
            offset: Offset(0, 14),
          )
        ],
      ),
      child: Stack(
        children: [
          // Layar grafik transaksi
          Positioned(
            left: 10,
            right: 10,
            top: 12,
            height: 66,
            child: Container(
              padding: const EdgeInsets.fromLTRB(9, 10, 9, 10),
              decoration: BoxDecoration(
                color: C.deep,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  for (var k = 0; k < 4; k++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.5),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: hs[k] *
                                (.3 +
                                    .7 *
                                        (1 -
                                            math.cos(2 *
                                                math.pi *
                                                ph(t, 4, k * .1))) /
                                        2),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: C.lilac,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Keypad PIN
          Positioned(
            left: 12,
            top: 94,
            width: 54,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var k = 0; k < 9; k++)
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: k == 8 ? C.purple : C.key,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
          // Slot Kartu ATM
          Positioned(
            right: 10,
            top: 98,
            child: Container(
              width: 36,
              height: 7,
              decoration: BoxDecoration(
                color: C.deep,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Tray Pengeluaran Uang
          Positioned(
            left: 12,
            top: 148,
            width: 104,
            height: 64,
            child: ClipRect(
              child: Stack(
                children: [
                  for (final d in const [0.0, .5])
                    Positioned(
                      left: 14,
                      top: () {
                        final p = ph(t, 4, d);
                        return p < .6 ? -30 + 64 * (p / .6) : 34.0;
                      }(),
                      child: Container(
                        width: 76,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: C.soft,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Rp',
                          style: TextStyle(
                            color: C.deep,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: C.deep,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Planet extends StatelessWidget {
  const _Planet();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 34,
        height: 34,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: C.lilac,
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              left: -10,
              top: 12,
              width: 54,
              height: 10,
              child: Transform.rotate(
                angle: -.24,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: C.purple, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _Coin extends StatelessWidget {
  const _Coin(this.phase);
  final double phase;

  @override
  Widget build(BuildContext context) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, .005)
          ..rotateY(2 * math.pi * phase),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: C.gold,
            shape: BoxShape.circle,
            border: Border.all(color: C.gold2, width: 3),
          ),
          child: const Text(
            '\$',
            style: TextStyle(
              color: Color(0xFF9A6200),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      );
}

// ───────────────────────── Elemen Layar 3 ─────────────────────────
class _Tower extends StatelessWidget {
  const _Tower(this.n, this.p);
  final int n;
  final double p;

  @override
  Widget build(BuildContext context) {
    final out = p > .9 ? 1 - (p - .9) / .1 : 1.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var k = n - 1; k >= 0; k--)
          () {
            final a = ((p - k * .06) / .06).clamp(0.0, 1.0);
            return Opacity(
              opacity: a * out,
              child: Transform.translate(
                offset: Offset(0, (1 - a) * -22),
                child: Container(
                  width: 36,
                  height: 8,
                  decoration: BoxDecoration(
                    color: C.gold2,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: C.gold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            );
          }(),
      ],
    );
  }
}

class _Chart extends CustomPainter {
  _Chart(this.progress);
  final double progress;

  @override
  void paint(Canvas c, Size s) {
    final path = Path()
      ..moveTo(20, 262)
      ..lineTo(70, 222)
      ..lineTo(112, 236)
      ..lineTo(160, 168)
      ..lineTo(222, 104);
    final m = path.computeMetrics().first;
    c.drawPath(
      m.extractPath(0, m.length * progress),
      Paint()
        ..color = C.deep
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_Chart o) => o.progress != progress;
}

class _Target extends StatelessWidget {
  const _Target();

  @override
  Widget build(BuildContext context) {
    Widget ring(double d, Color col) => Container(
          width: d,
          height: d,
          decoration: BoxDecoration(color: col, shape: BoxShape.circle),
        );
    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ring(54, C.purple),
          ring(40, Colors.white),
          ring(26, C.purple),
          ring(12, C.deep),
        ],
      ),
    );
  }
}

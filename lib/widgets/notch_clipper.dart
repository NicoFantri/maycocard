import 'package:flutter/material.dart';

/// Rounded-rect dengan "potongan" rounded di pojok kanan-bawah untuk tombol Add Card.
class NotchClipper extends CustomClipper<Path> {
  final double radius; // radius sudut kartu
  final double notchW;
  final double notchH;
  final double inner; // radius lengkung notch

  const NotchClipper({
    required this.radius,
    required this.notchW,
    required this.notchH,
    required this.inner,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final r = radius;

    final p = Path()
      ..moveTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..lineTo(w, h - notchH - r)
      ..quadraticBezierTo(w, h - notchH, w - r, h - notchH)
      ..lineTo(w - notchW + inner, h - notchH)
      ..quadraticBezierTo(
          w - notchW, h - notchH, w - notchW, h - notchH + inner)
      ..lineTo(w - notchW, h - r)
      ..quadraticBezierTo(w - notchW, h, w - notchW - r, h)
      ..lineTo(r, h)
      ..quadraticBezierTo(0, h, 0, h - r)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

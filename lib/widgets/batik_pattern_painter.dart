import 'package:flutter/material.dart';

/// Pelukis Watermark Motif Batik Tradisional Indonesia (Kawung & Parang Elegan)
class BatikPatternPainter extends CustomPainter {
  final Color color;

  const BatikPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    const spacing = 36.0;
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        // Lingkaran motif Kawung
        canvas.drawCircle(Offset(x, y), 16, linePaint);
        canvas.drawCircle(Offset(x + spacing / 2, y + spacing / 2), 16, linePaint);
        canvas.drawCircle(Offset(x + spacing / 2, y + spacing / 2), 3, dotPaint);

        // Garis Parang diagonal halus
        canvas.drawLine(
          Offset(x, y + spacing),
          Offset(x + spacing, y),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BatikPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}

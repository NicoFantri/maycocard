import 'package:flutter/material.dart';

/// Logo resmi VISA dengan tipografi khas italic tebal
class VisaLogo extends StatelessWidget {
  final bool isDarkText;
  final double height;

  const VisaLogo({
    super.key,
    this.isDarkText = false,
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: isDarkText
            ? Colors.black.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'VISA',
        style: TextStyle(
          fontFamily: 'sans-serif',
          fontSize: height,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.2,
          color: isDarkText ? const Color(0xFF1A1F71) : Colors.white,
        ),
      ),
    );
  }
}

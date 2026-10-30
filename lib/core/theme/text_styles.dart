import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle poppins(
  double size,
  Color color, {
  FontWeight w = FontWeight.w400,
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.poppins(
    fontSize: size,
    color: color,
    fontWeight: w,
    height: height,
    letterSpacing: letterSpacing,
  );
}


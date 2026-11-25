import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const ink = Color(0xFF232323);
  static const accent = Color(0xFFE8583A);
  static const soft = Color(0xFFF3E4DF);
  static const mute = Color(0xFF8A8A8A);
  static const hairline = Color(0xFFD9D9D9);
  static const panel = Color(0xFFE9E9E9);
}

/// Heavy Archivo style used for every headline.
TextStyle displayStyle(double size, {Color color = AppColors.ink}) =>
    GoogleFonts.archivo(
        fontSize: size, fontWeight: FontWeight.w800, height: .95, color: color);

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
      scaffoldBackgroundColor: AppColors.soft,
      textTheme: GoogleFonts.interTextTheme().apply(bodyColor: AppColors.ink),
    );

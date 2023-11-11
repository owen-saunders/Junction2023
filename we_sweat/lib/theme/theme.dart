import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { LIGHT, DARK }

String enumName(AppTheme anyEnum) {
  return anyEnum.toString();
}

final appThemeData = {
  AppTheme.LIGHT: ThemeData(
    textTheme: TextTheme(
      titleLarge: GoogleFonts.geologica(
        textStyle: const TextStyle(
          fontSize: 32,
          color: Color(0xffFFF1D5),
          fontWeight: FontWeight.w600,
        ),
      ),
      titleMedium: GoogleFonts.geologica(
        textStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xff232331),
          fontWeight: FontWeight.w400,
        ),
      ),
      titleSmall: GoogleFonts.geologica(
        textStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xffFFF1D5),
          fontWeight: FontWeight.w600,
        ),
      ),
      bodyLarge: GoogleFonts.geologica(
        textStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xffFFF1D5),
          fontWeight: FontWeight.w400,
        ),
      ),
      bodyMedium: GoogleFonts.geologica(
        textStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xffFFF1D5),
          fontWeight: FontWeight.w400,
        ),
      ),
      bodySmall: GoogleFonts.geologica(
        textStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xffFFF1D5),
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ),
  AppTheme.DARK: ThemeData()
};

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1B1F26);
  static const Color primaryBlue = Color(0xFF1F4FD8);
  static const Color primaryLight = Color(0xFFE8EEFF);
  static const Color primaryText = Color(0xFF111827);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: primary,
          surface: surface,
          error: error,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: primaryText),
          titleTextStyle: GoogleFonts.poppins(
            color: primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        textTheme: TextTheme(
          displaySmall: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: primaryText),
          headlineMedium: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: primaryText),
          titleLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: primaryText),
          titleMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
          bodyLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: primaryText),
          bodyMedium: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: primaryText),
          bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: secondaryText),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryBlue)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: error)),
          labelStyle: GoogleFonts.poppins(color: secondaryText, fontSize: 14),
          hintStyle: GoogleFonts.poppins(color: secondaryText, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: border),
            textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        cardTheme: CardTheme(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: border),
          ),
          margin: EdgeInsets.zero,
        ),
      );
}

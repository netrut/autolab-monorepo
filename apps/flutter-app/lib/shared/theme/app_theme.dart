import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors (from old app)
  static const Color primary = Color(0xFF1B1F26);
  static const Color primaryText = Color(0xFF14181B);
  static const Color secondaryText = Color(0xFF57636C);
  static const Color background = Color(0xFFF3F3F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEAEAEA);
  static const Color error = Color(0xFFFF5963);
  static const Color success = Color(0xFF249689);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: primary,
          surface: surface,
          error: error,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF3E3E3E)),
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFF232323),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        textTheme: TextTheme(
          displaySmall: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.w700, color: primaryText),
          headlineMedium: GoogleFonts.interTight(
              fontSize: 28, fontWeight: FontWeight.w600, color: primaryText),
          headlineSmall: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.w700, color: primaryText),
          titleLarge: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: primaryText),
          titleMedium: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: primaryText),
          titleSmall: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
          bodyLarge: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, color: primaryText),
          bodyMedium: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w400, color: primaryText),
          bodySmall: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w400, color: secondaryText),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: error),
          ),
          labelStyle: GoogleFonts.poppins(color: secondaryText, fontSize: 14),
          hintStyle: GoogleFonts.poppins(color: secondaryText, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
      );
}

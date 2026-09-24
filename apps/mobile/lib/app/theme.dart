import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens from CLAUDE.md "Design tokens".
class AppColors {
  static const background = Color(0xFF0A0A18);
  static const card = Color(0xC716142C); // rgba(22,20,44,0.78)
  static const cardBorder = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const textSecondary = Color(0xFFC9C5DD);
  static const textMuted = Color(0xFFD4D0E6);
  static const hint = Color(0xFF8E8AA8);
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFE11D48);
  static const pink = Color(0xFFEC4899);
  static const pinkSoft = Color(0xFFF472B6);
  static const lilac = Color(0xFFC084FC);
  static const navInactive = Color(0xFFA8A4C4);

  // Light screens (Language)
  static const lightText = Color(0xFF14122B);
  static const lightTextSecondary = Color(0xFF4B4868);
  static const lightDisabled = Color(0xFFE9E4F5);

  static const brand = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFDB2777), Color(0xFFEA580C)],
    stops: [0, 0.55, 1],
  );
  static const brandLogo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFDB2777), Color(0xFFF97316)],
    stops: [0, 0.55, 1],
  );
  static const headline = LinearGradient(
    colors: [Color(0xFFFB923C), Color(0xFFF472B6), Color(0xFFC084FC)],
    stops: [0, 0.5, 1],
  );
  static const instantMatch = LinearGradient(
    begin: Alignment(-1, -0.6),
    end: Alignment(1, 0.6),
    colors: [Color(0xFF6D28D9), Color(0xFFC026D3), Color(0xFFEA580C)],
    stops: [0, 0.55, 1],
  );
}

class AppText {
  static TextStyle heading(
    double size, {
    Color color = Colors.white,
    FontWeight weight = FontWeight.w800,
    double? spacing,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: spacing,
    height: 1.12,
  );

  static TextStyle body(
    double size, {
    Color color = Colors.white,
    FontWeight weight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.figtree(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  static TextStyle hand(double size, {Color color = const Color(0xFFE9D5FF)}) =>
      GoogleFonts.caveat(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w600,
      );
}

ThemeData buildTheme() {
  final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.pink,
      secondary: AppColors.lilac,
      surface: AppColors.background,
    ),
    textTheme: GoogleFonts.figtreeTextTheme(base.textTheme),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF2A1B4E),
      contentTextStyle: AppText.body(14.5, weight: FontWeight.w600),
      actionTextColor: AppColors.pinkSoft,
      elevation: 8,
      insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x66C084FC)),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class LifeGachaTheme {
  // Stitch palette
  static const _primary = Color(0xFF92552C);
  static const _onPrimary = Colors.white;
  static const _primaryContainer = Color(0xFFFDAF7E);
  static const _onPrimaryContainer = Color(0xFF612F07);

  static const _secondary = Color(0xFF546A59);
  static const _onSecondary = Colors.white;
  static const _secondaryContainer = Color(0xFFDEF7E2);
  static const _onSecondaryContainer = Color(0xFF4A5F4F);

  static const _tertiary = Color(0xFF7D600D);
  static const _onTertiary = Colors.white;
  static const _tertiaryContainer = Color(0xFFF9D377);
  static const _onTertiaryContainer = Color(0xFF5F4800);

  static const _error = Color(0xFFB23D21);
  static const _background = Color(0xFFFFFCF7);
  static const _surface = Color(0xFFFFFCF7);
  static const _onSurface = Color(0xFF373831);
  static const _onSurfaceVariant = Color(0xFF64655C);
  static const _outline = Color(0xFF818178);
  static const _outlineVariant = Color(0xFFBABAB0);

  static TextTheme _textTheme() {
    final base = GoogleFonts.beVietnamProTextTheme();
    return base.copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800, color: _onSurface),
      displayMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800, color: _onSurface),
      displaySmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700, color: _onSurface),
      headlineLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700, color: _onSurface),
      headlineMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700, color: _onSurface),
      headlineSmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700, color: _onSurface),
      titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700, color: _onSurface),
      titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600, color: _onSurface),
      titleSmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600, color: _onSurface),
    );
  }

  static ThemeData light() {
    final colorScheme = const ColorScheme.light(
      primary: _primary,
      onPrimary: _onPrimary,
      primaryContainer: _primaryContainer,
      onPrimaryContainer: _onPrimaryContainer,
      secondary: _secondary,
      onSecondary: _onSecondary,
      secondaryContainer: _secondaryContainer,
      onSecondaryContainer: _onSecondaryContainer,
      tertiary: _tertiary,
      onTertiary: _onTertiary,
      tertiaryContainer: _tertiaryContainer,
      onTertiaryContainer: _onTertiaryContainer,
      error: _error,
      surface: _surface,
      onSurface: _onSurface,
      surfaceContainerHighest: Color(0xFFEAE9DD),
      surfaceContainerHigh: Color(0xFFF0EEE4),
      surfaceContainer: Color(0xFFF6F4EC),
      surfaceContainerLow: Color(0xFFFCF9F3),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      onSurfaceVariant: _onSurfaceVariant,
      outline: _outline,
      outlineVariant: _outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _background,
      textTheme: _textTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: _primary,
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        color: const Color(0xFFFCF9F3),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          textStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          textStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _background.withValues(alpha: 0.92),
        indicatorColor: _primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? _primary : _onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? _primary : _onSurfaceVariant,
            size: 24,
          );
        }),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF92552C),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _textTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colorScheme.primary,
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          textStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          textStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.92),
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
    );
  }
}

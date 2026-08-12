import 'package:flutter/material.dart';

class AppColors {
  /// Toggle for dark / light mode.
  ///
  /// Kept as a static compatibility bridge because the current presentation
  /// layer reads AppColors directly. ThemeCubit updates it before emitting.
  static bool isDarkMode = false;

  static const Color _primaryLight = Color(0xFF0A192F);
  static const Color _primaryDark = Color(0xFF8EA4C7);
  static const Color _secondaryLight = Color(0xFF14B8A6);
  static const Color _secondaryDark = Color(0xFF2DD4BF);
  static const Color _tertiaryLight = Color(0xFF64748B);
  static const Color _tertiaryDark = Color(0xFFCBD5E1);
  static const Color _neutralLight = Color(0xFFF8FAFC);
  static const Color _neutralDark = Color(0xFF0F172A);

  static Color _shade(Color base, double amount) =>
      Color.lerp(Colors.white, base, amount)!;

  static Color _darkShade(Color base, double amount) =>
      Color.lerp(_neutralDark, base, amount)!;

  // --- Primary ---
  static Color get primaryColor1 =>
      isDarkMode ? _darkShade(_primaryDark, 0.16) : _shade(_primaryLight, 0.08);
  static Color get primaryColor2 =>
      isDarkMode ? _darkShade(_primaryDark, 0.24) : _shade(_primaryLight, 0.18);
  static Color get primaryColor3 =>
      isDarkMode ? _darkShade(_primaryDark, 0.32) : _shade(_primaryLight, 0.3);
  static Color get primaryColor4 =>
      isDarkMode ? _darkShade(_primaryDark, 0.42) : _shade(_primaryLight, 0.42);
  static Color get primaryColor5 =>
      isDarkMode ? _darkShade(_primaryDark, 0.52) : _shade(_primaryLight, 0.55);
  static Color get primaryColor6 => isDarkMode ? _primaryDark : _primaryLight;
  static Color get primaryColor7 =>
      isDarkMode ? const Color(0xFFC4D2EA) : const Color(0xFF071225);
  static Color get primaryColor8 =>
      isDarkMode ? const Color(0xFFD8E2F2) : const Color(0xFF06101F);
  static Color get primaryColor9 =>
      isDarkMode ? const Color(0xFFF1F5F9) : const Color(0xFF030A14);
  static Color get primaryColor10 =>
      isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF020617);

  // --- Secondary ---
  static Color get secondaryColor1 => isDarkMode
      ? _darkShade(_secondaryDark, 0.14)
      : _shade(_secondaryLight, 0.08);
  static Color get secondaryColor2 => isDarkMode
      ? _darkShade(_secondaryDark, 0.22)
      : _shade(_secondaryLight, 0.18);
  static Color get secondaryColor3 => isDarkMode
      ? _darkShade(_secondaryDark, 0.34)
      : _shade(_secondaryLight, 0.34);
  static Color get secondaryColor4 => isDarkMode
      ? _darkShade(_secondaryDark, 0.46)
      : _shade(_secondaryLight, 0.5);
  static Color get secondaryColor5 => isDarkMode
      ? _darkShade(_secondaryDark, 0.58)
      : _shade(_secondaryLight, 0.66);
  static Color get secondaryColor6 =>
      isDarkMode ? _secondaryDark : _secondaryLight;
  static Color get secondaryColor7 =>
      isDarkMode ? const Color(0xFF5EEAD4) : const Color(0xFF0F766E);
  static Color get secondaryColor8 =>
      isDarkMode ? const Color(0xFF99F6E4) : const Color(0xFF0F5F59);
  static Color get secondaryColor9 =>
      isDarkMode ? const Color(0xFFCCFBF1) : const Color(0xFF134E4A);
  static Color get secondaryColor10 =>
      isDarkMode ? const Color(0xFFE6FFFB) : const Color(0xFF042F2E);

  // --- Tertiary / muted ---
  static Color get tertiaryColor1 =>
      isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  static Color get tertiaryColor2 =>
      isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  static Color get tertiaryColor3 =>
      isDarkMode ? const Color(0xFF475569) : const Color(0xFFCBD5E1);
  static Color get tertiaryColor4 =>
      isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
  static Color get tertiaryColor5 =>
      isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  static Color get tertiaryColor6 =>
      isDarkMode ? _tertiaryDark : _tertiaryLight;
  static Color get tertiaryColor7 =>
      isDarkMode ? const Color(0xFFD8E0EC) : const Color(0xFF475569);
  static Color get tertiaryColor8 =>
      isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF334155);
  static Color get tertiaryColor9 =>
      isDarkMode ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B);
  static Color get tertiaryColor10 =>
      isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

  // --- Neutral / surfaces ---
  static Color get neutralColor1 =>
      isDarkMode ? const Color(0xFF111827) : const Color(0xFFFFFFFF);
  static Color get neutralColor2 =>
      isDarkMode ? const Color(0xFF172033) : const Color(0xFFFCFDFF);
  static Color get neutralColor3 =>
      isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFAFBFD);
  static Color get neutralColor4 =>
      isDarkMode ? const Color(0xFF243044) : const Color(0xFFF8FAFC);
  static Color get neutralColor5 =>
      isDarkMode ? const Color(0xFF2B3A50) : const Color(0xFFF3F6FA);
  static Color get neutralColor6 =>
      isDarkMode ? const Color(0xFF111827) : _neutralLight;
  static Color get neutralColor7 =>
      isDarkMode ? const Color(0xFF0B1120) : const Color(0xFFE2E8F0);
  static Color get neutralColor8 =>
      isDarkMode ? const Color(0xFF020617) : const Color(0xFFCBD5E1);
  static Color get neutralColor9 =>
      isDarkMode ? const Color(0xFF010409) : const Color(0xFF94A3B8);
  static Color get neutralColor10 =>
      isDarkMode ? const Color(0xFF000000) : const Color(0xFF64748B);

  static Color get primaryColor => isDarkMode ? _primaryDark : _primaryLight;
  static Color get secondaryColor =>
      isDarkMode ? _secondaryDark : _secondaryLight;
  static Color get tertiaryColor => isDarkMode ? _tertiaryDark : _tertiaryLight;
  static Color get neutralColor => isDarkMode ? _neutralDark : _neutralLight;

  // Semantic colors used by new and legacy UI.
  static Color get background => isDarkMode ? _neutralDark : _neutralLight;
  static Color get surface => isDarkMode ? neutralColor6 : Colors.white;
  static Color get surfaceSoft => neutralColor4;
  static Color get surfaceElevated =>
      isDarkMode ? const Color(0xFF1E293B) : Colors.white;
  static Color get inputBackground => isDarkMode ? neutralColor3 : Colors.white;
  static Color get primary => primaryColor;
  static Color get whiteColor => surface;
  static Color get darkGreyColor => textPrimary;
  static Color get greyColor => textSecondary;
  static Color get border => tertiaryColor2;
  static Color get divider => tertiaryColor2;
  static Color get disabled => tertiaryColor4;
  static Color get shadow =>
      isDarkMode ? Colors.black.withValues(alpha: 0.38) : Colors.black12;
  static Color get backGroundAppBar =>
      isDarkMode ? const Color(0xFF0B1120) : primaryColor;
  static Color get textPrimary =>
      isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF111827);
  static Color get textSecondary =>
      isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF64748B);

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final previousMode = isDarkMode;
    isDarkMode = isDark;
    final scheme = ColorScheme.fromSeed(
      seedColor: _secondaryLight,
      brightness: brightness,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surface,
    );

    final theme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme.copyWith(
        surface: surface,
        error: redWarring,
        outline: border,
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: surface,
      dividerColor: divider,
      disabledColor: disabled,
      appBarTheme: AppBarTheme(
        backgroundColor: backGroundAppBar,
        foregroundColor: isDark ? textPrimary : white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: secondaryColor7,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: secondaryColor2,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (_) => TextStyle(color: textPrimary),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevated,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(color: textSecondary, fontSize: 14),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceElevated,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surfaceElevated,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackground,
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textSecondary),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondaryColor7, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor7,
          foregroundColor: isDark ? const Color(0xFF042F2E) : white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: secondaryColor7,
          foregroundColor: isDark ? const Color(0xFF042F2E) : white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? secondaryColor6
              : tertiaryColor5,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? secondaryColor3
              : tertiaryColor2,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? surfaceElevated : primaryColor,
        contentTextStyle: TextStyle(color: isDark ? textPrimary : white),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: ThemeData(
        brightness: brightness,
      ).textTheme.apply(bodyColor: textPrimary, displayColor: textPrimary),
    );
    isDarkMode = previousMode;
    return theme;
  }

  // Legacy constants still used across the codebase.
  static const Color white = Color(0xFFFFFFFF);
  static Color get whiteLaight => white;
  static const Color redWarring = Color(0xffBF0000);
  static const Color orangeLowInStock = Color(0xffA64200);
  static const Color greenGood = Color(0xff007C27);
}

import 'package:flutter/material.dart';
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

/// StripCard themes — light is the default, dark mirrors with AppColorsDark.
///
/// Theme is intentionally minimal. Most styling is applied directly inside
/// design-system widgets (SCSurfaceCard, SCButton, etc.) using the raw color
/// tokens. The theme only handles:
///   1. Backgrounds (scaffold, dialogs)
///   2. Default text style on Text(...) without explicit style
///   3. Material defaults (input decoration, snackbar, divider)
///   4. Color scheme so showAboutDialog and stock Material widgets look ok
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(brightness: Brightness.light);
  static ThemeData dark()  => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final dark = brightness == Brightness.dark;

    final bg        = dark ? AppColorsDark.bg        : AppColors.bg;
    final surface   = dark ? AppColorsDark.surface   : AppColors.surface;
    final surface2  = dark ? AppColorsDark.surface2  : AppColors.surface2;
    final line      = dark ? AppColorsDark.line      : AppColors.line;
    final line2     = dark ? AppColorsDark.line2     : AppColors.line2;
    final text      = dark ? AppColorsDark.text      : AppColors.text;
    final text2     = dark ? AppColorsDark.text2     : AppColors.text2;
    final text3     = dark ? AppColorsDark.text3     : AppColors.text3;
    final accent    = dark ? AppColorsDark.accent    : AppColors.accent;
    final accentInk = dark ? AppColorsDark.accentInk : AppColors.accentInk;
    final danger    = dark ? AppColorsDark.danger    : AppColors.danger;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: accentInk,
      secondary: accent,
      onSecondary: accentInk,
      surface: surface,
      onSurface: text,
      error: danger,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      canvasColor: surface,
      dividerColor: line,
      fontFamily: 'Inter',

      // ─ Text theme: every category falls back to AppTextStyles, with
      //   color resolved to the active text token.
      textTheme: TextTheme(
        displayLarge:  AppTextStyles.display.copyWith(color: text),
        displayMedium: AppTextStyles.h1.copyWith(color: text),
        displaySmall:  AppTextStyles.h1.copyWith(color: text),
        headlineLarge: AppTextStyles.h1.copyWith(color: text),
        headlineMedium:AppTextStyles.h1.copyWith(color: text),
        headlineSmall: AppTextStyles.h2.copyWith(color: text),
        titleLarge:    AppTextStyles.h2.copyWith(color: text),
        titleMedium:   AppTextStyles.bodyMed.copyWith(color: text),
        titleSmall:    AppTextStyles.label.copyWith(color: text),
        bodyLarge:     AppTextStyles.body.copyWith(color: text),
        bodyMedium:    AppTextStyles.body.copyWith(color: text),
        bodySmall:     AppTextStyles.caption.copyWith(color: text2),
        labelLarge:    AppTextStyles.bodyMed.copyWith(color: text),
        labelMedium:   AppTextStyles.label.copyWith(color: text),
        labelSmall:    AppTextStyles.caption.copyWith(color: text3),
      ),

      // ─ AppBar: flat, transparent, dense.
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(color: text, size: 22),
        titleTextStyle: AppTextStyles.h2.copyWith(color: text),
      ),

      // ─ Input fields. The actual SCTextField widget overrides most of
      //   this — these defaults exist only so stray Material TextFields
      //   don't look wildly out of place.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: line2, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: line2, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: danger, width: 1.5),
        ),
        hintStyle: AppTextStyles.body.copyWith(color: text3),
        labelStyle: AppTextStyles.label.copyWith(color: text2),
      ),

      // ─ ElevatedButton — used as fallback only. Most CTAs go through
      //   SCButton (primary/secondary/ghost/danger).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: accentInk,
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.bodyMed.copyWith(letterSpacing: -0.1),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
          side: BorderSide(color: line, width: 1),
          textStyle: AppTextStyles.bodyMed.copyWith(letterSpacing: -0.1),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: AppTextStyles.bodyMed,
        ),
      ),

      // ─ Cards: hairline border, no shadow (we add shadow only when needed
      //   inside SCSurfaceCard for the dashboard balance card etc.)
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: line2, width: 1),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: line2,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        selectedColor: accent,
        secondarySelectedColor: accent,
        labelStyle: AppTextStyles.label.copyWith(color: text),
        secondaryLabelStyle: AppTextStyles.label.copyWith(color: accentInk),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        showDragHandle: true,
        dragHandleColor: line,
        dragHandleSize: const Size(36, 4),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: text,
        contentTextStyle: AppTextStyles.body.copyWith(color: bg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        elevation: 0,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
      ),

      iconTheme: IconThemeData(color: text, size: 22),

      splashFactory: InkRipple.splashFactory,
    );
  }
}

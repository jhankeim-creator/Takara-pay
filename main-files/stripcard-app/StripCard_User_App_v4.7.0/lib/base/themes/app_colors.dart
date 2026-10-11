import 'package:flutter/material.dart';

/// StripCard color tokens — exact values from v0 prototype tokens.jsx.
/// Light + dark variants. The naming intentionally matches the JS tokens
/// (bg / surface / surface2 / line / line2 / text / text2 / text3) so that
/// drift between prototype and Flutter implementation stays trivial to spot.
class AppColors {
  AppColors._();

  // ─── Light theme (default) ──────────────────────────────────────
  static const bg        = Color(0xFFFAFAF7);  // warm off-white canvas
  static const surface   = Color(0xFFFFFFFF);  // cards, sheets
  static const surface2  = Color(0xFFF4F2EC);  // recessed: inputs, table rows
  static const line      = Color(0x140F1720);  // rgba(15,23,32,0.08) hairline
  static const line2     = Color(0x0D0F1720);  // rgba(15,23,32,0.05) subtler
  static const text      = Color(0xFF0F1720);  // primary
  static const text2     = Color(0xFF5A6573);  // secondary
  static const text3     = Color(0xFF8B95A1);  // tertiary / metadata

  // accent — oklch(0.78 0.14 165) converted to sRGB ≈ #36D999 mint
  static const accent    = Color(0xFF36D999);
  static const accentInk = Color(0xFF02261B);  // text on accent

  // semantic — oklch values converted to sRGB
  static const danger    = Color(0xFFDC3232);  // oklch(0.62 0.18 25)
  static const warn      = Color(0xFFD89438);  // oklch(0.78 0.13 75)
  static const skeleton  = Color(0x0F0F1720);  // rgba(15,23,32,0.06)

  // virtual card body color — always dark in both themes
  static const cardInk   = Color(0xFF0A0E1A);

  // soft tone backgrounds (for pills) — matches Pill component logic in components.jsx
  static const accentSoft  = Color(0x2936D999);  // rgba(54,217,153,0.16)
  static const dangerSoft  = Color(0x1ADC3232);  // rgba(220,50,50,0.10)
  static const warnSoft    = Color(0x1FDC961E);  // rgba(220,150,30,0.12)
  static const neutralSoft = Color(0x0D0F1720);  // rgba(15,23,32,0.05)

  // ─── Dark theme variants (use AppColorsDark.x) ──────────────────
  // (Theme switching reads these via AppTheme — never mix light + dark
  //  values manually inside a widget.)
}

class AppColorsDark {
  AppColorsDark._();

  static const bg        = Color(0xFF070A12);
  static const surface   = Color(0xFF0E131D);
  static const surface2  = Color(0xFF141A26);
  static const line      = Color(0x12FFFFFF);  // rgba(255,255,255,0.07)
  static const line2     = Color(0x0AFFFFFF);  // rgba(255,255,255,0.04)
  static const text      = Color(0xFFF2F4F8);
  static const text2     = Color(0xFF9099A8);
  static const text3     = Color(0xFF5C6573);

  static const accent    = Color(0xFF4DE0A6);  // oklch(0.82 0.14 165) lighter
  static const accentInk = Color(0xFF02261B);

  static const danger    = Color(0xFFE65A5F);  // oklch(0.70 0.18 25)
  static const warn      = Color(0xFFE8A847);  // oklch(0.82 0.13 75)
  static const skeleton  = Color(0x0DFFFFFF);

  static const cardInk   = Color(0xFF0A0E1A);

  static const accentSoft  = Color(0x2436D999);  // rgba(54,217,153,0.14)
  static const dangerSoft  = Color(0x24FF5A5F);  // rgba(255,90,95,0.14)
  static const warnSoft    = Color(0x24F0B43C);  // rgba(240,180,60,0.14)
  static const neutralSoft = Color(0x0FFFFFFF);  // rgba(255,255,255,0.06)
}

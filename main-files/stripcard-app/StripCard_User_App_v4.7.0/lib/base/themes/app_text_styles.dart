import 'package:flutter/material.dart';

/// StripCard typography — exact values from v0 prototype tokens.jsx.
///
/// Design rule from the prototype:
///   - UI text uses Inter
///   - Numbers (balances, amounts, card numbers, OTP codes, expiry, CVV)
///     use JetBrains Mono with tabular-nums
///
/// In the JS prototype this is enforced by a `mono` prop and the .sc-num class.
/// In Flutter, it's enforced by using AppTextStyles.numXX styles for any text
/// that displays a number, vs the regular variants for prose.
class AppTextStyles {
  AppTextStyles._();

  static const String _ui   = 'Inter';
  static const String _mono = 'JetBrainsMono';

  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  // ─── UI text (Inter) ─────────────────────────────────────────────
  // Names match TOKENS.type.* keys: display / h1 / h2 / body / bodyMed /
  // label / caption / micro

  static const TextStyle display = TextStyle(
    fontFamily: _ui,
    fontSize: 34,
    fontWeight: FontWeight.w600,
    height: 1.05,
    letterSpacing: -0.8,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: _ui,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.4,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _ui,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _ui,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.1,
  );

  static const TextStyle bodyMed = TextStyle(
    fontFamily: _ui,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: -0.1,
  );

  static const TextStyle label = TextStyle(
    fontFamily: _ui,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _ui,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.1,
  );

  /// Uppercase microcopy — section headers like "RECENT ACTIVITY".
  /// Apply .toUpperCase() on the string when using this — Flutter has no
  /// textTransform property like CSS.
  static const TextStyle micro = TextStyle(
    fontFamily: _ui,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.4,
  );

  // ─── Number text (JetBrains Mono, tabular-nums) ──────────────────
  // Use these ANY time you display a number to the user. Prefix `num`
  // = "numeric", not "amount" — applies to balances, OTP digits, card
  // numbers, expiry, CVV, transaction IDs, percentages, timers.

  /// Hero balance / amount preview — 34px display, mono.
  static const TextStyle numDisplay = TextStyle(
    fontFamily: _mono,
    fontSize: 34,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: -1.36,  // -0.04em on 34px
    fontFeatures: _tabular,
  );

  /// Card balance, transaction amounts, withdraw preview total.
  static const TextStyle numLg = TextStyle(
    fontFamily: _mono,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.3,
    fontFeatures: _tabular,
  );

  /// Inline transaction-row amounts, secondary numbers.
  static const TextStyle numMd = TextStyle(
    fontFamily: _mono,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.1,
    fontFeatures: _tabular,
  );

  /// Card number masked, expiry, CVV, OTP digits.
  static const TextStyle numSm = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.4,
    fontFeatures: _tabular,
  );

  /// Tiny labels with numerical content (BALANCE / EXPIRES on the card).
  static const TextStyle numCaption = TextStyle(
    fontFamily: _mono,
    fontSize: 9,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.6,
    fontFeatures: _tabular,
  );
}

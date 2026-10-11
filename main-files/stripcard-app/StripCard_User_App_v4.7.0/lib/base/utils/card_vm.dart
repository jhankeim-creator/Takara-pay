import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:stripcard/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:stripcard/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:stripcard/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";
import "package:stripcard/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/routes/routes.dart";
import "package:stripcard/base/widgets/design_system/sc_virtual_card.dart";

/// A provider-agnostic view-model for a single virtual card.
///
/// The dashboard / my-cards UI renders these instead of reaching into the
/// per-provider models directly. [ActiveCards.resolve] builds the list from
/// whichever provider is currently active and is the only thing that knows
/// the per-provider field mapping.
class CardVm {
  final String cardName;
  final String last4;
  final String? balance;
  final String expiry;
  final bool frozen;
  // A freshly-created card the provider is still issuing (card_status
  // 'processing'/'pending'). It is NOT frozen — distinguishing the two stops
  // new cards from being mislabelled "Frozen".
  final bool processing;
  final SCCardNetwork network;
  final VoidCallback? onTap;

  const CardVm({
    required this.cardName,
    required this.last4,
    this.balance,
    this.expiry = '••/••',
    this.frozen = false,
    this.processing = false,
    this.network = SCCardNetwork.visa,
    this.onTap,
  });
}

/// Resolves the active provider's real cards into a list of [CardVm].
///
/// HARD RULE: this must NEVER throw and must NEVER fabricate card data. Any
/// missing field, uninitialised model, or unmapped provider results in either
/// a safe fallback ('••••', etc. for a single field) or an empty list (for a
/// provider we cannot confidently map). The whole body is wrapped in try/catch
/// so a `LateInitializationError` (model not yet fetched) yields `[]`.
class ActiveCards {
  ActiveCards._();

  static List<CardVm> resolve() {
    try {
      final dash = Get.find<DashBoardController>();
      final provider = dash.activeVirtualSystem.value.toLowerCase();

      switch (provider) {
        case 'sudo':
          return _resolveSudo(dash);
        case 'strowallet':
          return _resolveStrowallet(dash);
        case 'cardyfie':
          return _resolveCardyfie(dash);
        case 'stripe':
          return _resolveStripe(dash);
        case 'flutterwave':
          return _resolveFlutterwave(dash);
        default:
          return const [];
      }
    } catch (_) {
      // Model not loaded / unexpected shape — never crash the UI.
      return const [];
    }
  }

  /// The active provider's card-creation limit (`card_create_limit`), or null
  /// when it can't be resolved (model not loaded / provider unmapped). Never
  /// throws — same hard rule as [resolve].
  static int? resolveLimit() {
    try {
      final dash = Get.find<DashBoardController>();
      final provider = dash.activeVirtualSystem.value.toLowerCase();
      switch (provider) {
        case 'sudo':
          return Get.find<VirtualSudoCardController>()
              .sudoMyCardModel
              .data
              .cardBasicInfo
              .cardCreateLimit;
        case 'strowallet':
          return Get.find<VirtualStrowalletCardController>()
              .strowalletCardModel
              .data
              .cardBasicInfo
              .cardCreateLimit;
        case 'cardyfie':
          return Get.find<VirtualCardyfieCardController>()
              .cardyfieCardModel
              .data
              .cardBasicInfo
              .cardCreateLimit;
        case 'stripe':
          return Get.find<StripeTwoController>()
              .stripeCardModel
              .data
              .cardBasicInfo
              .cardCreateLimit;
        case 'flutterwave':
          return Get.find<FlutterWaveCardController>()
              .myCardModel
              ?.data
              .cardBasicInfo
              .cardCreateLimit;
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  // ── Sudo ────────────────────────────────────────────────────────────────
  static List<CardVm> _resolveSudo(DashBoardController dash) {
    final controller = Get.find<VirtualSudoCardController>();
    final cards = controller.sudoMyCardModel.data.myCard;
    final result = <CardVm>[];
    for (var i = 0; i < cards.length; i++) {
      final c = cards[i];
      final last4 = _last4(c.cardPan);
      result.add(
        CardVm(
          cardName: c.cardHolder.isNotEmpty ? c.cardHolder : 'Card ${i + 1}',
          last4: last4,
          balance: _balanceStr(c.amount, c.currency),
          expiry: _expiry(c.expiryMonth, c.expiryYear),
          // MyCard.status is a bool: true = active, false = blocked/frozen.
          frozen: c.status == false,
          network: _network(c.brand),
          onTap: () {
            controller.cardId.value = c.cardId;
            dash.current.value = i;
            Get.toNamed(Routes.sudoCardDetailsScreen);
          },
        ),
      );
    }
    return result;
  }

  // ── Strowallet ────────────────────────────────────────────────────────────
  static List<CardVm> _resolveStrowallet(DashBoardController dash) {
    final controller = Get.find<VirtualStrowalletCardController>();
    final cards = controller.strowalletCardModel.data.myCards;
    final result = <CardVm>[];
    for (var i = 0; i < cards.length; i++) {
      final c = cards[i];
      result.add(
        CardVm(
          cardName: c.name.isNotEmpty ? c.name : 'Card ${i + 1}',
          last4: _last4(c.cardNumber),
          // Strowallet card carries no currency code on the card itself; show
          // the bare numeric balance.
          balance: _balanceStr(c.balance, ''),
          expiry: _normalizeExpiry(c.expiry),
          // card_status is the source of truth: 'active' → live, 'processing'/
          // 'pending' → still being issued (NOT frozen), anything else with a
          // false status bool → genuinely blocked/frozen. Using status==false
          // alone wrongly flagged brand-new "processing" cards as Frozen.
          processing: _isProcessing(c.cardStatus),
          frozen: c.status == false && !_isProcessing(c.cardStatus),
          // No brand field on the Strowallet card — default network.
          onTap: () {
            controller.strowalletCardId.value = c.cardId;
            dash.current.value = i;
            Get.toNamed(Routes.strowalletCardDetailsScreen);
          },
        ),
      );
    }
    return result;
  }

  // ── Cardyfie ────────────────────────────────────────────────────────────
  static List<CardVm> _resolveCardyfie(DashBoardController dash) {
    final controller = Get.find<VirtualCardyfieCardController>();
    final cards = controller.cardyfieCardModel.data.myCards ?? const [];
    final result = <CardVm>[];
    for (var i = 0; i < cards.length; i++) {
      final c = cards[i];
      result.add(
        CardVm(
          cardName: c.cardName.isNotEmpty ? c.cardName : 'Card ${i + 1}',
          last4: _last4(c.maskedPan),
          balance: _balanceStr(c.amount, c.currency),
          expiry: _normalizeExpiry(c.cardExpTime),
          // status is a String (e.g. ENABLED / FREEZE / CLOSED / PROCESSING).
          frozen: c.status.toUpperCase() != 'ENABLED',
          network: _network(c.cardType),
          onTap: () {
            controller.cardyfieCardUIId.value = c.ulid;
            dash.current.value = i;
            Get.toNamed(Routes.cardyfieDetailsScreen);
          },
        ),
      );
    }
    return result;
  }

  // ── Stripe ────────────────────────────────────────────────────────────────
  static List<CardVm> _resolveStripe(DashBoardController dash) {
    final controller = Get.find<StripeTwoController>();
    final cards = controller.stripeCardModel.data.myCard;
    final result = <CardVm>[];
    for (var i = 0; i < cards.length; i++) {
      final c = cards[i];
      result.add(
        CardVm(
          cardName: c.cardHolder.isNotEmpty ? c.cardHolder : 'Card ${i + 1}',
          last4: _last4(c.cardPan),
          // Stripe MyCard has no balance field — leave null.
          expiry: _expiry(c.expiryMonth, c.expiryYear),
          frozen: c.status == false,
          network: _network(c.brand),
          onTap: () {
            controller.cardId.value = c.cardId;
            dash.current.value = i;
            Get.toNamed(Routes.stripeCardDetailsScreen);
          },
        ),
      );
    }
    return result;
  }

  // ── FlutterWave ──────────────────────────────────────────────────────────
  // FlutterMyCardModel.data.myCards is an untyped List<dynamic> of raw JSON
  // maps. We read it best-effort via the known snake_case keys (mirrored from
  // the typed card-details model: name / card_pan / masked_card / expiration /
  // amount / card_type / card_id / status). Any non-map item or missing field
  // is skipped/fallback — never fabricated, never throws (outer try/catch).
  static List<CardVm> _resolveFlutterwave(DashBoardController dash) {
    final controller = Get.find<FlutterWaveCardController>();
    final model = controller.myCardModel;
    if (model == null) return const [];
    final baseCurr = model.data.baseCurr;
    final cards = model.data.myCards;
    final result = <CardVm>[];
    for (var i = 0; i < cards.length; i++) {
      final raw = cards[i];
      if (raw is! Map) continue;
      String? key(String k) => raw[k]?.toString();
      final name = key('name') ?? '';
      final cardIdVal = key('card_id') ?? key('id') ?? '';
      result.add(
        CardVm(
          cardName: name.isNotEmpty ? name : 'Card ${i + 1}',
          last4: _last4(key('masked_card') ?? key('card_pan')),
          balance: _balanceStr(raw['amount'], baseCurr),
          expiry: _normalizeExpiry(key('expiration')),
          frozen: _statusFrozen(raw['status']),
          network: _network(key('card_type')),
          onTap: cardIdVal.isEmpty
              ? null
              : () {
                  controller.cardId.value = cardIdVal;
                  dash.current.value = i;
                  Get.toNamed(Routes.cardDetailsScreen);
                },
        ),
      );
    }
    return result;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Frozen check for providers whose status may be a bool or a string.
  static bool _statusFrozen(dynamic status) {
    if (status is bool) return status == false;
    final s = status?.toString().toLowerCase().trim() ?? '';
    if (s.isEmpty) return false;
    return !(s == 'active' || s == 'enabled' || s == 'true' || s == '1');
  }

  static String _last4(String? pan) {
    final digits = (pan ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 4) return digits.substring(digits.length - 4);
    return digits.isEmpty ? '••••' : digits;
  }

  // A card the provider is still issuing — not yet active, but not blocked.
  static bool _isProcessing(String? cardStatus) {
    final s = (cardStatus ?? '').toLowerCase();
    return s == 'processing' || s == 'pending';
  }

  static SCCardNetwork _network(String? brand) {
    final b = (brand ?? '').toLowerCase();
    if (b.contains('master')) return SCCardNetwork.mastercard;
    return SCCardNetwork.visa;
  }

  /// Builds a 'MM/YY' string from separate month + (2- or 4-digit) year.
  static String _expiry(String? month, String? year) {
    final m = (month ?? '').trim();
    final y = (year ?? '').trim();
    if (m.isEmpty || y.isEmpty) return '••/••';
    final mm = m.padLeft(2, '0');
    final yy = y.length > 2 ? y.substring(y.length - 2) : y.padLeft(2, '0');
    return '$mm/$yy';
  }

  /// Normalises a single expiry string into 'MM/YY' best-effort. Accepts
  /// 'MM/YY', 'MM/YYYY', or a full date — falls back to the raw value (or the
  /// placeholder) when it can't be parsed.
  static String _normalizeExpiry(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return '••/••';
    final slash = v.split('/');
    if (slash.length == 2) {
      return _expiry(slash[0], slash[1]);
    }
    // Try an ISO/date-ish value: take year + month if present.
    final parsed = DateTime.tryParse(v);
    if (parsed != null) {
      return _expiry(parsed.month.toString(), parsed.year.toString());
    }
    return v;
  }

  /// Formats a numeric balance (int/double/string/dynamic) with an optional
  /// currency suffix. Returns null when there is no usable value so the card
  /// simply omits the balance row.
  static String? _balanceStr(dynamic amount, String currency) {
    if (amount == null) return null;
    final str = amount.toString().trim();
    if (str.isEmpty) return null;
    final num = double.tryParse(str.replaceAll(RegExp(r'[^0-9.]'), ''));
    final shown = num != null ? num.toStringAsFixed(2) : str;
    return currency.isNotEmpty ? '$shown $currency' : shown;
  }
}

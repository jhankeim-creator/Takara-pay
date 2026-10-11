import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_spacing.dart";
import "package:TAKARA PAY/routes/routes.dart";

/// Maps the backend's `active_virtual_system` string to the correct
/// create-card route, and exposes a single `openCreateCard` entry point
/// that every "+ New card" tap site uses.
///
/// Returns null when the provider string doesn't match a known provider
/// or when the provider's create screen isn't currently registered in
/// `route_pages.dart`. Callers (or `openCreateCard`) show the
/// "Card creation unavailable" snackbar on null.
///
/// Stripe currently returns null because `Routes.stripeCreateCardScreen`
/// has no `GetPage` entry — to be enabled in a follow-up batch.
class CardProviderRouter {
  CardProviderRouter._();

  static String? resolveCreateRoute(String provider) {
    switch (provider.toLowerCase()) {
      case 'flutterwave':
        return Routes.createNewScreen;
      case 'sudo':
        return Routes.sudoCreateNewScreen;
      case 'strowallet':
        // Note: 'crate' typo preserved — matches the actual constant name.
        return Routes.crateStrowalletScreen;
      case 'cardyfie':
        // Note: 'crate' typo preserved — matches the actual constant name.
        return Routes.crateCardyfieScreen;
      case 'stripe':
        // Stripe create screen not registered in route_pages.dart yet.
        return null;
      default:
        return null;
    }
  }

  /// Single tap handler shared by every "+ New card" site.
  ///
  /// Reads the active provider from `DashBoardController.activeVirtualSystem`
  /// (RxString that defaults to '' — safer than the `late` model accessor
  /// which can throw `LateInitializationError` if the dashboard fetch
  /// hasn't completed).
  static void openCreateCard() {
    final controller = Get.find<DashBoardController>();
    final provider = controller.activeVirtualSystem.value;
    final route = resolveCreateRoute(provider);

    if (route == null) {
      Get.snackbar(
        'Card creation unavailable',
        'Card services are not configured for your account. Please contact support.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.text,
        colorText: AppColors.bg,
        margin: const EdgeInsets.all(AppSpacing.md),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    Get.toNamed(route);
  }
}

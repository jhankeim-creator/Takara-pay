import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

/// Forces the user to update when a newer build is live on the store.
///
/// Android: uses Google Play in-app updates. When an update is available we
/// trigger the **immediate** (forced) flow — Play takes over full-screen and
/// the user cannot use the app until it is updated (or they leave). Falls back
/// to a flexible update if the store doesn't allow immediate for this release.
///
/// iOS: not wired yet (app isn't on the App Store). When it is, add an
/// iTunes-lookup version compare here behind `Platform.isIOS` + the App Store
/// numeric ID, then open the store page.
///
/// Safe to call on every launch: failures (debug builds, sideloaded APKs,
/// no Play services, no network) are caught and ignored so they never block
/// the app.
class ForceUpdateService {
  ForceUpdateService._();

  static Future<void> check() async {
    // kIsWeb guard keeps this no-op on web; Play Core is Android-only.
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      if (info.immediateUpdateAllowed) {
        // Blocking, forced update — the desired "force fully update" behaviour.
        await InAppUpdate.performImmediateUpdate();
      } else if (info.flexibleUpdateAllowed) {
        // Store didn't permit immediate for this release; do a flexible
        // download then apply it as soon as it's ready.
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (e) {
      debugPrint('In-app update check skipped: $e');
    }
  }
}

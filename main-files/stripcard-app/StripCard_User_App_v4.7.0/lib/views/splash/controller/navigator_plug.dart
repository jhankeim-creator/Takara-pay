import 'dart:async';
import "package:TAKARA PAY/base/maintenance/maintanance_dialoge.dart";
import "package:TAKARA PAY/base/utils/basic_widget_import.dart";

/// Gates splash → next-route navigation on maintenance status only.
///
/// This intentionally does NOT wait on LanguageController.isLoadingValue.
/// Usable language data (last-cached response, or the bundled English map)
/// is guaranteed to already be in memory synchronously by the time
/// LanguageController.onInit() returns — before this class is even
/// constructed — so gating navigation on the language API's background
/// refresh added nothing but risk: on a slow or dead network it held the
/// splash screen for up to the fetch's full timeout on every cold start.
/// The API keeps refreshing in the background regardless and the UI updates
/// reactively via getTranslation() once/if it lands.
class NavigatorPlug {
  StreamSubscription<bool>? _maintenanceSubscription;
  bool _timerStarted = false;

  void startListening({
    required int seconds,
    required VoidCallback onChanged,
  }) {
    _maintenanceSubscription =
        Get.find<SystemMaintenanceController>().maintenanceStatus.listen(
      (inMaintenance) {
        _checkStatus(seconds, onChanged);
      },
    );
    // maintenanceStatus starts false and, on most launches, never changes —
    // a stream listener alone would never fire in that case (no replay of
    // the current value to a new subscriber), so check once immediately too.
    _checkStatus(seconds, onChanged);
  }

  void _checkStatus(int seconds, VoidCallback onChanged) {
    if (!_timerStarted &&
        Get.find<SystemMaintenanceController>().maintenanceStatus.value ==
            false) {
      _timerStarted = true;

      Timer(
        Duration(seconds: seconds),
        () {
          if (Get.find<SystemMaintenanceController>().maintenanceStatus.value ==
              false) {
            _maintenanceSubscription?.cancel();
            onChanged();
          } else {
            _timerStarted = false;
          }
        },
      );
    }
  }

  void stopListening() {
    _maintenanceSubscription?.cancel();
  }
}
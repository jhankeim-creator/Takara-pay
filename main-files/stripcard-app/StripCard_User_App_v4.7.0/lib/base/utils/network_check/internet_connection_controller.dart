import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult connectivityResult;
  late StreamSubscription<ConnectivityResult> _streamSubscription;

  @override
  void onInit() async {
    super.onInit();
    _initConnectivity();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    connectivityResult = await _connectivity.checkConnectivity();
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (kDebugMode) print("STATUS : $connectivityResult");

    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(
          barrierDismissible: false,
          barrierColor: AppColors.bg,
          PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didpop, pop) => false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: mainCenter,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.warnSoft,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.wifi_off,
                        color: AppColors.warn,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'PLEASE CONNECT TO THE INTERNET',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h2.copyWith(color: AppColors.text),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Waiting for a network connection. This will close automatically once you are back online.',
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.body.copyWith(color: AppColors.text2),
                    ),
                  ],
                ),
              ),
            ),
          ));
    } else {
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}

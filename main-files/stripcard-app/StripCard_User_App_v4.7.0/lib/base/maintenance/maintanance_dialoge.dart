import 'package:restart_app/restart_app.dart';

import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";
import "package:stripcard/base/api/model/maintainance/maintanance_model.dart";

class SystemMaintenanceController extends GetxController {
  RxBool maintenanceStatus = false.obs;
}

class MaintenanceDialog {
  show({required MaintenanceModel maintenanceModel}) {
    Get.dialog(
      // ignore: deprecated_member_use
      WillPopScope(
        onWillPop: () async {
          Restart.restartApp();
          return false;
        },
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: AppColors.bg,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.bg,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeHorizontalSize * 0.8,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          Icons.build_circle_outlined,
                          color: AppColors.warn,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        maintenanceModel.data.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h2.copyWith(color: AppColors.text),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        maintenanceModel.data.details,
                        textAlign: TextAlign.center,
                        style:
                            AppTextStyles.body.copyWith(color: AppColors.text2),
                      ),
                      const SizedBox(height: 24),
                      SCPrimaryButton(
                        label: Strings.restart,
                        onPressed: () {
                          Restart.restartApp();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

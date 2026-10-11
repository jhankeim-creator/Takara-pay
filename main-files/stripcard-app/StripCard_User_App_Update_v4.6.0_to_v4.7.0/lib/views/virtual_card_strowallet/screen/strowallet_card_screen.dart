import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/error_state_widget.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/strowallet_slider.dart";

class StrowalletCardScreen extends StatelessWidget {
  const StrowalletCardScreen({super.key, required this.controller});
  final VirtualStrowalletCardController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? const CustomLoadingAPI()
          // hasCardData is false when the fetch failed (network error, bad
          // response, or a parse error) — _bodyWidget reads the controller's
          // `late` model directly, which would otherwise throw
          // LateInitializationError instead of showing a retry state.
          : controller.hasCardData
              ? _bodyWidget(context)
              : _errorState(),
    );
  }

  Widget _errorState() {
    return ErrorStateWidget(
      title: Strings.couldntLoadCards,
      message: Strings.checkConnectionAndRetry,
      retryLabel: Strings.retry,
      onRetry: controller.getStrowalletCardData,
    );
  }

  _stroWalletCardWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: AppColors.surface,
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Column(
            mainAxisAlignment: mainCenter,
            mainAxisSize: mainMin,
            children: [
              StrowalletSlider(),
              Visibility(
                visible: controller.strowalletCardModel.data.myCards.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.credit_card_outlined,
                          label: Strings.details,
                          onTap: () {
                            controller.getStrowalletCardData();
                            if (controller
                                .strowalletCardModel.data.myCards.isNotEmpty) {
                              Get.toNamed(Routes.strowalletCardDetailsScreen);
                            } else {
                              CustomSnackBar.error(Strings.youDonNotBuyCard);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.add_card_outlined,
                          label: Strings.fund,
                          onTap: () {
                            controller.getStrowalletCardData();
                            if (controller
                                .strowalletCardModel.data.myCards.isNotEmpty) {
                              Get.toNamed(Routes.strowalletAddFundScreen);
                            } else {
                              CustomSnackBar.error(
                                Strings.youDonNotBuyCard,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.account_balance_wallet_outlined,
                          label: Strings.withdraw,
                          onTap: () {
                            controller.getStrowalletCardData();
                            if (controller
                                .strowalletCardModel.data.myCards.isNotEmpty) {
                              Get.toNamed(Routes.strowalletWithdrawScreen);
                            } else {
                              CustomSnackBar.error(
                                Strings.youDonNotBuyCard,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(
                          () => controller.isMakeDefaultLoading
                              ? const _ActionTileLoading()
                              : _ActionTile(
                                  icon: Icons.star_outline_rounded,
                                  label: controller
                                          .strowalletCardModel
                                          .data
                                          .myCards[controller.dashboardController
                                              .current.value]
                                          .isDefault
                                      ? Strings.removeDefault
                                      : Strings.makeDefault,
                                  onTap: () {
                                    controller.makeCardDefaultProcess(
                                      controller
                                          .strowalletCardModel
                                          .data
                                          .myCards[controller.dashboardController
                                              .current.value]
                                          .cardId,
                                    );
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.receipt_long_outlined,
                          label: Strings.transactions,
                          onTap: () {
                            controller.getStrowalletCardData();
                            if (controller
                                .strowalletCardModel.data.myCards.isNotEmpty) {
                              Get.toNamed(
                                  Routes.strowalletTransactionHistoryScreen);
                            } else {
                              CustomSnackBar.error(
                                Strings.youDonNotBuyCard,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (controller.strowalletCardModel.data.cardCreateAction) ...[
          _buttonWidget(context),
        ]
      ],
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return _stroWalletCardWidget(context);
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SCPrimaryButton(
        label: Strings.createANewCard,
        onPressed: () {
          Get.toNamed(Routes.crateStrowalletScreen);
        },
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 20, color: AppColors.text),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _ActionTileLoading extends StatelessWidget {
  const _ActionTileLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '...',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

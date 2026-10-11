import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/bottom_navbar/sudo_slider_card.dart";

class SudoVirtualCardScreen extends StatelessWidget {
  SudoVirtualCardScreen({super.key, required this.controller});

  final VirtualSudoCardController controller;
  final dashboardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              )
            : _bodyWidget(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final hasCard = controller.sudoMyCardModel.data.myCard.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: hasCard ? mainStart : mainCenter,
        children: [
          const SizedBox(height: 12),
          _card(context),
          _cardCategories(context),
          if (controller.sudoMyCardModel.data.cardCreateAction) ...[
            _createCard(context),
          ]
        ],
      ),
    );
  }

  Widget _card(BuildContext context) {
    return Visibility(
      visible: controller.sudoMyCardModel.data.myCard.isNotEmpty,
      child: SudoDashboardSlider(),
    );
  }

  Widget _cardCategories(BuildContext context) {
    final data = controller.sudoMyCardModel.data.myCard;
    return Visibility(
      visible: controller.sudoMyCardModel.data.myCard.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: _ActionTile(
                icon: Icons.credit_card_outlined,
                label: Strings.details,
                onTap: () {
                  if (controller.sudoMyCardModel.data.myCard.isNotEmpty) {
                    Get.toNamed(Routes.sudoCardDetailsScreen);
                  } else {
                    CustomSnackBar.error(Strings.youDonNotBuyCard);
                  }
                  ;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                return controller.isDefaultLoading
                    ? const _ActionTileLoading()
                    : _ActionTile(
                        icon: data[dashboardController.current.value]
                                    .isDefault ==
                                true
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        label: data[dashboardController.current.value]
                                    .isDefault ==
                                true
                            ? Strings.removeDefault
                            : Strings.makeDefault,
                        onTap: () {
                          controller.defaultProcess();
                        },
                      );
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionTile(
                icon: Icons.receipt_long_outlined,
                label: Strings.transactions,
                onTap: () {
                  if (controller.sudoMyCardModel.data.myCard.isNotEmpty) {
                    Get.toNamed(Routes.sudoTransactionHistoryScreen);
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
    );
  }

  Widget _createCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.sudoCreateNewScreen);
        },
        child: Container(
          alignment: Alignment.center,
          height: 56,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            Strings.createANewCard,
            style: AppTextStyles.bodyMed.copyWith(
              color: AppColors.accentInk,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.line2, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(borderRadius: radius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, size: 20, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTileLoading extends StatelessWidget {
  const _ActionTileLoading();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.line2, width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: SizedBox(
          height: 64,
          child: Center(
            child: CustomLoadingAPI(color: AppColors.accent),
          ),
        ),
      ),
    );
  }
}

part of '../cardyfie_card_screen.dart';

class CardyfieCategoryWidget extends StatelessWidget {
  CardyfieCategoryWidget({super.key});
  final controller = Get.put(VirtualCardyfieCardController());
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.cardyfieCardList.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.82,
          shrinkWrap: true,
          children: [
            _CardyfieActionTile(
              icon: Icons.info_outline_rounded,
              text: Strings.details,
              onTap: () {
                // controller.getCardyfieCardData();
                if (controller.cardyfieCardModel.data.myCards!.isNotEmpty) {
                  Get.toNamed(Routes.cardyfieDetailsScreen);
                } else {
                  CustomSnackBar.error(Strings.youDonNotBuyCard);
                }
              },
            ),
            _CardyfieActionTile(
              icon: Icons.add_card_outlined,
              text: Strings.fund,
              onTap: () {
                controller.getCardyfieCardData();
                if (controller.cardyfieCardModel.data.myCards!.isNotEmpty) {
                  Get.toNamed(Routes.cardyfieAddFundScreen);
                } else {
                  CustomSnackBar.error(Strings.youDonNotBuyCard);
                }
              },
            ),
            _CardyfieActionTile(
              icon: Icons.account_balance_outlined,
              text: Strings.withdraw,
              onTap: () {
                // controller.getCardyfieCardData();
                if (controller.cardyfieCardModel.data.myCards!.isNotEmpty) {
                  Get.toNamed(Routes.cardyfieWithdrawScreen);
                } else {
                  CustomSnackBar.error(Strings.youDonNotBuyCard);
                }
              },
            ),
            Obx(
              () => _CardyfieActionTile(
                icon: Icons.star_outline_rounded,
                text: Strings.removeDefault,
                loading: controller.isMakeDefaultLoading,
                onTap: () {
                  controller.makeCardDefaultProcess(
                    controller
                        .cardyfieCardModel
                        .data
                        .myCards![controller
                            .dashboardController
                            .current
                            .value]
                        .ulid,
                  );
                },
              ),
            ),
            _CardyfieActionTile(
              icon: Icons.receipt_long_outlined,
              text: Strings.transactions,
              onTap: () {
                // controller.getCardyfieCardData();
                if (controller.cardyfieCardModel.data.myCards!.isNotEmpty) {
                  Get.toNamed(Routes.cardyfieTransactionHistoryScreen);
                } else {
                  CustomSnackBar.error(Strings.youDonNotBuyCard);
                }
              },
            ),
            _CardyfieActionTile(
              icon: Icons.cancel_outlined,
              text: Strings.close,
              danger: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.xl),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        20 + MediaQuery.of(context).padding.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                                color: AppColors.line,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            Get.find<LanguageController>().getTranslation(Strings.closeCard),
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Get.find<LanguageController>().getTranslation(Strings.closeSubTitle),
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Obx(
                            () => SCDangerButton(
                              label: Strings.close,
                              loading: controller.isCloseLoading,
                              onPressed: () {
                                controller.closeProcess().then((value) {
                                  Get.toNamed(Routes.bottomNavBarScreen);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          SCSecondaryButton(
                            label: Strings.cancel,
                            onPressed: () {
                              Get.close(1);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _openDialogueForCloseAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossCenter,
              children: [
                Text(
                  Get.find<LanguageController>().getTranslation(Strings.closeCard),
                  style: AppTextStyles.h2.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>().getTranslation(Strings.closeSubTitle),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SCSecondaryButton(
                        label: Get.find<LanguageController>().getTranslation(Strings.cancel),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => SCDangerButton(
                          label: Get.find<LanguageController>().getTranslation(Strings.okay),
                          loading: controller.isCloseLoading,
                          onPressed: () {
                            controller.closeProcess();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardyfieActionTile extends StatelessWidget {
  const _CardyfieActionTile({
    required this.icon,
    required this.text,
    required this.onTap,
    this.loading = false,
    this.danger = false,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool loading;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final Color fg = danger ? AppColors.danger : AppColors.text;
    final Color iconBg = danger ? AppColors.dangerSoft : AppColors.surface2;
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Column(
        mainAxisSize: mainMin,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.line2, width: 1),
            ),
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  )
                : Icon(icon, size: 22, color: fg),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

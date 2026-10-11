part of "../cardyfie_create_card_screen.dart";

class CardyfiePendingWidget extends StatelessWidget {
  const CardyfiePendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisAlignment: mainCenter,
              crossAxisAlignment: crossCenter,
              children: [
                const SizedBox(height: 48),
                // Status badge
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.warnSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.warn,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Status of the customer you created: ",
                    style: AppTextStyles.h2.copyWith(color: AppColors.text),
                    children: [
                      TextSpan(
                        text: "PENDING",
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.warn,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Please wait until your customer status is APPROVED. Once it is APPROVED, you can continue with the card creation.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ),
        _PinnedFooter(
          child: SCPrimaryButton(
            label: Strings.updateCustomer,
            icon: Icons.edit_outlined,
            onPressed: () {
              Get.toNamed(Routes.cardyfieUpdateCustomerScreen);
            },
          ),
        ),
      ],
    );
  }
}

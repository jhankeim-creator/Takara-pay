import "package:stripcard/base/widgets/bottom_navbar/flutter_card.dart";
import "package:stripcard/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:stripcard/base/utils/data/flutter_wave_data.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";

class FlutterWaveVirtualCardScreen extends StatelessWidget {
  FlutterWaveVirtualCardScreen({super.key, required this.controller});

  final FlutterWaveCardController controller;

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

  _bodyWidget(BuildContext context) {
    // myCardModel is now nullable on the controller — when the user is on
    // a different active virtual system (e.g. Sudo) and the FlutterWave
    // myCard fetch was never triggered, the field stays null. Treat null
    // as "no cards" for layout purposes.
    final hasCards = controller.myCardModel?.data.myCards.isNotEmpty ?? false;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: hasCards ? mainStart : mainCenter,
          children: [
            _card(context),
            _cardCategories(context),
            const SizedBox(height: 24),
            _createCard(context),
          ],
        ),
      ),
    );
  }

  _card(BuildContext context) {
    return FlutterWaveSlider();
  }

  _cardCategories(BuildContext context) {
    final hasCards = controller.myCardModel?.data.myCards.isNotEmpty ?? false;
    return Visibility(
      visible: hasCards,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            for (int index = 0; index < flutterCategoriesData.length; index++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 6,
                    right: index == flutterCategoriesData.length - 1 ? 0 : 6,
                  ),
                  child: _ActionTile(
                    icon: _iconFor(flutterCategoriesData[index].text),
                    label: flutterCategoriesData[index].text,
                    onTap: flutterCategoriesData[index].onTap,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String text) {
    if (text == Strings.details) return Icons.credit_card_outlined;
    if (text == Strings.fund) return Icons.add_rounded;
    if (text == Strings.transactions) return Icons.receipt_long_outlined;
    return Icons.more_horiz_rounded;
  }

  _createCard(BuildContext context) {
    return SCSecondaryButton(
      label: Strings.createANewCard,
      icon: Icons.add_rounded,
      onPressed: () {
        Get.toNamed(Routes.createNewScreen);
      },
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
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.line2, width: 1),
          ),
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
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

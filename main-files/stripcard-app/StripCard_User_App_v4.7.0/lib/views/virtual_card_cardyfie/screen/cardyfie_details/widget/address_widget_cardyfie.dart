part of '../cardyfie_details_screen.dart';

class AddressWidgetCardyfie extends StatelessWidget {
  AddressWidgetCardyfie({super.key});
  final controller = Get.put(CardyfieDetailsController());
  @override
  Widget build(BuildContext context) {
    var myCards = controller.cardDetailsModelCardyfie.data.myCard;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              Strings.address.toUpperCase(),
              textAlign: TextAlign.left,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          const Divider(height: 1, thickness: 0.5, color: AppColors.line2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                Text(
                  Strings.billingAddress,
                  style: AppTextStyles.label.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 6),
                Text(
                  myCards.address,
                  style: AppTextStyles.body.copyWith(color: AppColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

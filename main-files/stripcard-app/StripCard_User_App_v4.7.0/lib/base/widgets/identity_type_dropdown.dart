import "package:TAKARA PAY/base/api/model/virtual_card/sudo_models/sudo_card_model.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

class IdentityTypeDropDown extends StatelessWidget {
  final RxString selectMethod;
  final List<Option> itemsList;
  final void Function(Option?)? onChanged;

  const IdentityTypeDropDown({
    required this.itemsList,
    Key? key,
    required this.selectMethod,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
    final textColor = dark ? AppColorsDark.text : AppColors.text;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return Obx(() {
      final hasValue = selectMethod.value.trim().isNotEmpty;
      return Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: line2, width: 1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Option>(
            hint: Text(
              selectMethod.value,
              style: AppTextStyles.bodyMed
                  .copyWith(color: hasValue ? textColor : text3),
              overflow: TextOverflow.ellipsis,
            ),
            menuMaxHeight: 350.h,
            icon: Icon(Icons.expand_more, size: 20, color: text3),
            isExpanded: true,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            dropdownColor: dark ? AppColorsDark.surface : AppColors.surface,
            style: AppTextStyles.bodyMed.copyWith(color: textColor),
            items: itemsList.map<DropdownMenuItem<Option>>((value) {
              return DropdownMenuItem<Option>(
                value: value,
                child: Text(
                  value.name,
                  style: AppTextStyles.bodyMed.copyWith(color: textColor),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      );
    });
  }
}

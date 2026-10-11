import "package:stripcard/base/api/model/virtual_card/stripe_models/stripe_card_info_model.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

class StripSupportedCurrency extends StatelessWidget {
  final RxString selectMethod;
  final List<SupportedCurrency> itemsList;
  final void Function(SupportedCurrency?)? onChanged;

  const StripSupportedCurrency({
    required this.itemsList,
    Key? key,
    required this.selectMethod,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: Dimensions.inputBoxHeight * 0.72,
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomColor.primaryBGLightColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
          ),
          child: DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 20),
              child: DropdownButton(

                hint: Padding(
                  padding: EdgeInsets.only(left: Dimensions.paddingSize * 0.7),
                  child: TitleHeading2Widget(
                    fontSize: Dimensions.headingTextSize4,
                    text: selectMethod.value,
                    color: Get.isDarkMode
                        ? CustomColor.primaryLightTextColor
                        : CustomColor.primaryDarkTextColor,
                  ),
                ),
                menuMaxHeight: 350.h,
                icon: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: CustomColor.primaryBGLightColor,
                  ),
                ),
                onTap: () {},
                isExpanded: true,
                underline: Container(),
                borderRadius: BorderRadius.circular(Dimensions.radius),
                items:
                    itemsList.map<DropdownMenuItem<SupportedCurrency>>((value) {
                  return DropdownMenuItem<SupportedCurrency>(
                    value: value,
                    child: TitleHeading4Widget(
                      text:
                      value.currencyCode,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ));
  }
}

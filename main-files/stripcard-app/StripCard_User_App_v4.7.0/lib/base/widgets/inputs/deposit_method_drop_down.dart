import 'package:google_fonts/google_fonts.dart';
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/api/model/add_money/add_money_info_model.dart";

class DepositMethodDropDown extends StatelessWidget {
  final RxString selectMethod;
  final List<Currency> itemsList;
  final void Function(Currency?)? onChanged;

  const DepositMethodDropDown({
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
                  child: Text(
                    selectMethod.value,
                    style: GoogleFonts.inter(
                      fontSize: Dimensions.headingTextSize4,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode
                    ? CustomColor.primaryLightTextColor
                        : CustomColor.primaryDarkTextColor,
                    ),
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
                items: itemsList.map<DropdownMenuItem<Currency>>((value) {
                  return DropdownMenuItem<Currency>(
                    value: value,
                    child: TitleHeading4Widget(
                      text:
                      value.name,
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

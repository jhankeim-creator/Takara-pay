import 'package:google_fonts/google_fonts.dart';
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/base/utils/language/language_controller.dart";

class InputWithText extends StatefulWidget {
  final String hint, icon, label, suffixText;
  final int maxLines;
  final bool isValidator;
  final EdgeInsetsGeometry? paddings;
  final TextEditingController controller;

  final Function(String)? onChanged;

  InputWithText({
    Key? key,
    required this.controller,
    required this.hint,
    this.icon = "",
    this.isValidator = true,
    this.maxLines = 1,
    this.paddings,
    required this.label,
    required this.suffixText,
    this.onChanged,
  }) : super(key: key);

  @override
  State<InputWithText> createState() => _PrimaryInputWidgetState();
}

class _PrimaryInputWidgetState extends State<InputWithText> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeading4Widget(
          padding: EdgeInsets.only(top: Dimensions.marginSizeVertical * 0.2),
          text: widget.label,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode
              ? CustomColor.grayColor
              : CustomColor.primaryDarkTextColor,
        ),
        verticalSpace(7),
        Row(
          children: [
            Expanded(
              flex: 9,
              child: TextFormField(
                validator: widget.isValidator == false
                    ? null
                    : (String? value) {
                        if (value!.isEmpty) {
                          return Strings.pleaseFillOutTheField;
                        } else {
                          return null;
                        }
                      },
                textInputAction: TextInputAction.next,
                controller: widget.controller,
                onTap: () {
                  setState(() {
                    focusNode!.requestFocus();
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    focusNode!.unfocus();
                  });
                },
                focusNode: focusNode,
                textAlign: TextAlign.left,
                style: CustomStyle.darkHeading3TextStyle.copyWith(
                  color: Get.isDarkMode
                      ? CustomColor.primaryLightTextColor
                      : CustomColor.primaryDarkTextColor,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLines: widget.maxLines,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  hintText: Get.find<LanguageController>()
                      .getTranslation(widget.hint),
                  hintStyle: GoogleFonts.inter(
                    fontSize: Dimensions.headingTextSize3,
                    fontWeight: FontWeight.w500,
                    color: Get.isDarkMode
                        ? CustomColor.grayColor
                        : CustomColor.primaryDarkTextColor.withAlpha(77),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.5),
                    borderSide: BorderSide(
                      width: 1,
                      color: CustomColor.primaryLightColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.5),
                    borderSide: BorderSide(
                        width: 2, color: CustomColor.primaryLightColor),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

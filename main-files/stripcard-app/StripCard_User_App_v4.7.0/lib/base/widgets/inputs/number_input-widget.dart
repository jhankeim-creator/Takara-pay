import 'package:google_fonts/google_fonts.dart';

import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class PhoneNumberInputWidget extends StatefulWidget {
  final String hint, label;
  final RxString countryCode;
  final int maxLines;
  final bool isValidator;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;

  final EdgeInsetsGeometry? paddings;
  final TextEditingController controller;
  final String optionalLabel;
  const PhoneNumberInputWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.isValidator = true,
    this.maxLines = 1,
    this.paddings,
    required this.label,
    this.readOnly = false,
    required this.countryCode,
    this.keyBoardType,
    this.textInputAction,
    this.optionalLabel = '',
  });

  @override
  State<PhoneNumberInputWidget> createState() => _PrimaryInputWidgetState();
}

class _PrimaryInputWidgetState extends State<PhoneNumberInputWidget> {
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

  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TitleHeading4Widget(
              text: widget.label,
              fontWeight: FontWeight.w600,
            ),
            horizontalSpace(Dimensions.widthSize * 0.5),
            TitleHeading4Widget(
              text: widget.optionalLabel,
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.headingTextSize5,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: .8)
                  : CustomColor.primaryTextColor.withValues(alpha: .8),

              // CustomColor.primaryLightColor.withValues(alpha:.8),
            ),
          ],
        ),
        verticalSpace(7),
        TextFormField(
          keyboardType: widget.keyBoardType,
          textInputAction: widget.textInputAction,
          validator: widget.isValidator == false
              ? null
              : (String? value) {
                  if (value!.isEmpty) {
                    return Strings.pleaseFillOutTheField;
                  } else {
                    return null;
                  }
                },
          controller: widget.controller,
          onTap: () {
            setState(
              () {
                focusNode!.requestFocus();
              },
            );
          },
          onFieldSubmitted: (value) {
            setState(() {
              focusNode!.unfocus();
            });
          },
          focusNode: focusNode,
          textAlign: TextAlign.left,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            color: Get.isDarkMode
                ? CustomColor.primaryTextColor
                : CustomColor.primaryDarkTextColor,
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.headingTextSize3,
          ),
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: languageController.getTranslation(widget.hint),
            hintStyle: GoogleFonts.inter(
              fontSize: Dimensions.headingTextSize3,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode
                  ? CustomColor.primaryTextColor.withValues(alpha: 0.1)
                  : CustomColor.primaryDarkTextColor.withValues(alpha: 0.1),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
                borderSide: BorderSide(
                  color: Get.isDarkMode
                      ? CustomColor.whiteColor
                      : CustomColor.kDarkBlue,
                )),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
              borderSide: BorderSide(
                width: 2,
                color: CustomColor.primaryLightColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
              borderSide: BorderSide(
                  width: 2,
                  color: Get.isDarkMode
                      ? CustomColor.whiteColor
                      : CustomColor.kDarkBlue),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.widthSize * 1.7,
              vertical: Dimensions.heightSize,
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.marginSizeHorizontal * 0.5),
                  child: Obx(
                    () => TitleHeading3Widget(
                      text: widget.countryCode.value,
                      color: Get.isDarkMode
                          ? CustomColor.primaryLightTextColor
                          : CustomColor.primaryDarkTextColor,
                    ),
                  ),
                ),
                Container(
                  width: 1.6,
                  height: Dimensions.heightSize * 2,
                  color: Get.isDarkMode
                      ? CustomColor.primaryLightTextColor
                      : CustomColor.primaryDarkTextColor,
                ),
                horizontalSpace(Dimensions.widthSize)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

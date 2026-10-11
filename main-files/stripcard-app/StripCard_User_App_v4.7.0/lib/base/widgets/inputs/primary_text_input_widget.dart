

import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

class PrimaryTextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText, optional, hint;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Color? color;
  final int maxLine;
  final double focusedBorderWidth;
  final double enabledBorderWidth;
  final Widget? suffixIcon, prefixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
   final String? optionalLabel;

  const PrimaryTextInputWidget({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.readOnly = false,
    this.focusedBorderWidth = 1.2,
    this.enabledBorderWidth = 1,
    this.maxLine = 1,
    this.color = Colors.transparent,
    this.suffixIcon,
    this.onTap,
    this.optional = "",
    this.hint = "",
    this.prefixIcon,
    this.optionalLabel,
    this.onChanged,
  }); 
    
    
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final borderColor = dark ? AppColorsDark.line2 : AppColors.line2;
    final accentColor = dark ? AppColorsDark.accent : AppColors.accent;
    final dangerColor = dark ? AppColorsDark.danger : AppColors.danger;
    final textColor = dark ? AppColorsDark.text : AppColors.text;
    final text2Color = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3Color = dark ? AppColorsDark.text3 : AppColors.text3;

    OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: c, width: w),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: AppTextStyles.label.copyWith(color: text2Color),
            ),
            if (optional.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                optional,
                style: AppTextStyles.label.copyWith(color: text3Color),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          cursorColor: accentColor,
          maxLines: maxLine,
          style: AppTextStyles.bodyMed.copyWith(color: textColor),
          readOnly: readOnly!,
          controller: controller,
          keyboardType: keyboardType,
          validator: (String? value) {
            if (value!.isEmpty && maxLine == 1) {
              return Get.find<LanguageController>()
                  .getTranslation(Strings.pleaseFillOutTheField);
            } else {
              return null;
            }
          },
          onFieldSubmitted: onChanged,
          decoration: InputDecoration(
            enabledBorder: border(borderColor, enabledBorderWidth),
            border: border(borderColor, enabledBorderWidth),
            focusedBorder: border(accentColor, 1.5),
            errorBorder: border(dangerColor, 1),
            focusedErrorBorder: border(dangerColor, 1.5),
            filled: true,
            fillColor: color == Colors.transparent ? fillColor : color,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            hintText:
                "${Get.find<LanguageController>().getTranslation(Strings.enter)} ${Get.find<LanguageController>().getTranslation(labelText)}",
            hintStyle: AppTextStyles.body.copyWith(color: text3Color),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        )
      ],
    );
  }
}

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:stripcard/base/utils/basic_screen_import.dart";

import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class PrimaryInputWidget extends StatefulWidget {
  final String hint, icon, label;
  final int maxLines;
  final bool isValidator;
    final bool? readonly;
  final Widget? prefixIcon;
   final Widget? suffixIcon;
  final EdgeInsetsGeometry? paddings;
  final TextEditingController controller;
  final TextInputType? keyboardInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? optionalLabel;
  final void Function(String)? onChanged; // Optional onChanged callback

  const PrimaryInputWidget({
    Key? key,
    required this.controller,
    this.readonly,
    required this.hint,
    this.icon = "",
    this.isValidator = true,
    this.prefixIcon,
      this.suffixIcon,
    this.maxLines = 1,
    this.paddings,
    required this.label,
    this.keyboardInputType,
    this.inputFormatters,
    this.optionalLabel,
    this.onChanged, // Optional parameter
  }) : super(key: key);

  @override
  State<PrimaryInputWidget> createState() => _PrimaryInputWidgetState();
}

class _PrimaryInputWidgetState extends State<PrimaryInputWidget> {
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final borderColor = dark ? AppColorsDark.line2 : AppColors.line2;
    final accentColor = dark ? AppColorsDark.accent : AppColors.accent;
    final dangerColor = dark ? AppColorsDark.danger : AppColors.danger;
    final textColor = dark ? AppColorsDark.text : AppColors.text;
    final text2Color = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3Color = dark ? AppColorsDark.text3 : AppColors.text3;

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: color, width: width),
        );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: AppTextStyles.label.copyWith(color: text2Color),
            ),
            if ((widget.optionalLabel ?? "").isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                widget.optionalLabel!,
                style: AppTextStyles.label.copyWith(color: accentColor),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: widget.readonly ?? false,
          inputFormatters: widget.inputFormatters,
          validator: widget.isValidator == false
              ? null
              : (String? value) {
                  if (value!.isEmpty) {
                    return Get.find<LanguageController>().getTranslation(
                      Strings.pleaseFillOutTheField,
                    );
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
          onChanged: widget.onChanged,
          // Execute onChanged if it's passed
          onFieldSubmitted: (value) {
            setState(() {
              focusNode!.unfocus();
            });
          },
          focusNode: focusNode,
          textAlign: TextAlign.left,
          cursorColor: accentColor,
          style: GoogleFonts.inter(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: widget.keyboardInputType,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            filled: true,
            fillColor: fillColor,
            hintText: Get.find<LanguageController>().getTranslation(
              widget.hint,
            ),
            hintStyle: AppTextStyles.body.copyWith(color: text3Color),
            enabledBorder: border(borderColor, 1),
            border: border(borderColor, 1),
            focusedBorder: border(accentColor, 1.5),
            errorBorder: border(dangerColor, 1),
            focusedErrorBorder: border(dangerColor, 1.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

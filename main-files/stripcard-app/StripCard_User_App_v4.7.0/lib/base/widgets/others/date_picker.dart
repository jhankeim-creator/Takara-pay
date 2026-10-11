import "package:stripcard/base/utils/basic_widget_import.dart";

import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/utils/language/strings.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class CustomDatePicker extends StatefulWidget {
  final RxString selectedDate; // Observable date string
  final bool showBorder;

  final String label;
  final String subtitle;
  final Decoration? decoration;
  final Color? labelColor;
  final double? inputBoxHeight;
  final Color? calendarIconColor;
  final Widget? leading;
  final EdgeInsets? fieldPadding;
  final double? labelFontSize;
  final double? hintFontSize;
  final Widget? labelSpacing;

  const CustomDatePicker({
    required this.selectedDate,
    this.label = '',
    this.subtitle = '',
    this.decoration,
    this.labelColor,
    this.inputBoxHeight,
    this.calendarIconColor,
    this.leading,
    this.fieldPadding,
    Key? key,
    this.labelFontSize,
    this.hintFontSize,
    this.labelSpacing,
    required this.showBorder,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker>
    with SingleTickerProviderStateMixin {
  bool isDatePickerOpened = false;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: CustomColor.whiteColor,
            colorScheme: ColorScheme.light(
              primary: CustomColor.primaryLightColor,
              onPrimary: Colors.white,
              surface: CustomColor.whiteColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    CustomColor.primaryLightColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        widget.selectedDate.value = _formatDate(pickedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildDatePickerButton(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Column(
              children: [
                TitleHeading4Widget(
                    text: widget.label,
                    fontSize: widget.labelFontSize ??
                        Dimensions.headingTextSize3 * 0.9,
                    color: Color(0xfff1D1D1D)),
                widget.labelSpacing ??
                    verticalSpace(Dimensions.marginSizeVertical),
              ],
            ),
          Builder(builder: (context) {
            final dark = Theme.of(context).brightness == Brightness.dark;
            final fill = dark ? AppColorsDark.surface2 : AppColors.surface2;
            final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
            final accent = dark ? AppColorsDark.accent : AppColors.accent;
            final textColor = dark ? AppColorsDark.text : AppColors.text;
            final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
            final text3 = dark ? AppColorsDark.text3 : AppColors.text3;
            final hasValue = widget.selectedDate.value.isNotEmpty;
            return Container(
              height: widget.inputBoxHeight ?? 52,
              decoration: widget.decoration ??
                  BoxDecoration(
                    color: fill,
                    border: widget.showBorder == true
                        ? Border.all(
                            color: isDatePickerOpened ? accent : line2,
                            width: isDatePickerOpened ? 1.5 : 1,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
              child: Padding(
                padding: widget.fieldPadding ??
                    const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (widget.leading != null) ...[
                            widget.leading!,
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.selectedDate.value.isEmpty
                                      ? Get.find<LanguageController>()
                                          .getTranslation(Strings.dateOfBirth)
                                      : widget.selectedDate.value,
                                  style: AppTextStyles.bodyMed.copyWith(
                                    color: hasValue ? textColor : text3,
                                  ),
                                ),
                                if (widget.subtitle != '')
                                  Text(
                                    widget.subtitle,
                                    style: AppTextStyles.caption
                                        .copyWith(color: text2),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: widget.calendarIconColor ??
                          (isDatePickerOpened ? accent : text3),
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDatePickerButton(context);
  }
}

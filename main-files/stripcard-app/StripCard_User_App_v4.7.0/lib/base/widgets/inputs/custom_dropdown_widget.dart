import 'package:dropdown_button2/dropdown_button2.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";


abstract class DropdownModel {
  String get id;
  String get title;
  String get img;
  String get mcode;
  String get type;
  String get currencyCode;
  String get currencySymbol;
  double get max;
  double get min;
  double get pCharge;
  double get fCharge;
  double get rate;
}

class CustomDropDown<T extends DropdownModel> extends StatefulWidget {
  final String hint;
  final String title;
  final String customTitle;
  final Color? borderColor;
  final List<T> items;
  final void Function(T?) onChanged;
  final BoxBorder? border;
  final double? fieldBorderRadius;
  final Color? dropDownIconColor;
  final Color? titleTextColor;
  final Color dropDownFieldColor;
  final Color? dropDownColor;
  final bool isExpanded;
  final bool borderEnable;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? titleStyle;
  final BorderRadiusGeometry? customBorderRadius;
  final bool? isCurrencyDropDown;

  const CustomDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    this.border,
    this.fieldBorderRadius,
    this.dropDownIconColor,
    this.titleTextColor,
    this.dropDownFieldColor = Colors.transparent,
    this.isExpanded = true,
    this.padding,
    this.margin,
    this.titleStyle,
    this.borderColor,
    this.dropDownColor,
    required this.hint,
    this.borderEnable = true,
    this.title = '',
    this.customBorderRadius,
    this.isCurrencyDropDown = false, this.customTitle = "",
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomDropDownState<T> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T extends DropdownModel>
    extends State<CustomDropDown<T>> {
  T? _selectedItem;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    return widget.title != ''
        ? Visibility(
        visible: widget.title != '',
        child: Column(
          crossAxisAlignment: crossStart,
          mainAxisSize: mainMin,
          children: [
            Text(
              widget.title,
              style: AppTextStyles.label.copyWith(color: text2),
            ).paddingOnly(bottom: 6),
            _dropDown()
          ],
        ))
        : _dropDown();
  }

  _dropDown() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final lineColor = dark ? AppColorsDark.line2 : AppColors.line2;
    final accentColor = dark ? AppColorsDark.accent : AppColors.accent;
    final textColor = dark ? AppColorsDark.text : AppColors.text;
    final text3Color = dark ? AppColorsDark.text3 : AppColors.text3;
    final surfaceColor = dark ? AppColorsDark.surface : AppColors.surface;

    final itemColor =
        widget.isCurrencyDropDown! ? CustomColor.whiteColor : textColor;
    final hintColor =
        widget.isCurrencyDropDown! ? CustomColor.whiteColor : text3Color;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: widget.dropDownFieldColor == Colors.transparent
            ? fillColor
            : widget.dropDownFieldColor,
        border: widget.borderEnable
            ? widget.border ??
                Border.all(
                  color: widget.borderColor ??
                      (_selectedItem != null ? accentColor : lineColor),
                  width: 1,
                )
            : null,
        borderRadius: widget.customBorderRadius ??
            BorderRadius.circular(widget.fieldBorderRadius ?? AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          hint: Text(
            widget.hint,
            style: AppTextStyles.body.copyWith(color: hintColor),
            overflow: TextOverflow.ellipsis,
          ),
          value: _selectedItem,
          style: AppTextStyles.bodyMed.copyWith(color: itemColor),
          iconStyleData: IconStyleData(
            icon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.expand_more,
                size: 20,
                color: widget.dropDownIconColor ?? text3Color,
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: MediaQuery.sizeOf(context).height * .3,
            decoration: BoxDecoration(
              color: widget.dropDownColor ?? surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: lineColor, width: 1),
            ),
          ),
          isExpanded: widget.isExpanded,
          underline: Container(),
          onChanged: (T? newValue) {
            setState(() {
              _selectedItem = newValue;
              widget.onChanged(_selectedItem);
            });
          },
          items: widget.items.map<DropdownMenuItem<T>>(
                (T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(
                  value.title == "" ? widget.customTitle : value.title,
                  style: AppTextStyles.bodyMed.copyWith(color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
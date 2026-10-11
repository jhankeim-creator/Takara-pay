import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

abstract class DropdownModel {
  String get title;
}

class StringDropdownModel implements DropdownModel {
  @override
  final String title;
  final String? slug;

  StringDropdownModel({required this.title, this.slug});
}

class CustomDropDown<T extends DropdownModel> extends StatefulWidget {
  final String? hint;
  final String title;
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
  final double? dropDownHeight;

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
    this.hint,
    this.dropDownHeight,
    this.borderEnable = true,
    this.title = '',
    this.customBorderRadius,
    this.isCurrencyDropDown = false,
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
    return widget.title != ''
        ? Visibility(
            visible: widget.title != '',
            child: Column(
              crossAxisAlignment: crossStart,
              mainAxisSize: mainMin,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.label.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 6),
                _dropDown(),
              ],
            ),
          )
        : _dropDown();
  }

  Container _dropDown() {
    return Container(
      height: widget.dropDownHeight ?? 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: widget.borderEnable
            ? widget.border ??
                  Border.all(
                    color: widget.borderColor ?? AppColors.line2,
                    width: 1,
                  )
            : null,
        borderRadius:
            widget.customBorderRadius ?? BorderRadius.circular(AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text(
            widget.hint ?? '',
            style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
          ),
          value: _selectedItem,
          icon: const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(Icons.expand_more, color: AppColors.text3, size: 20),
          ),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
          dropdownColor: widget.dropDownColor ?? AppColors.surface,
          isExpanded: widget.isExpanded,
          menuMaxHeight: MediaQuery.sizeOf(context).height * .4,
          underline: Container(),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onChanged: (T? newValue) {
            setState(() {
              _selectedItem = newValue;
              widget.onChanged(_selectedItem);
            });
          },
          items: widget.items.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                value.title,
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_spacing.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class SCTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helper;
  final String? error;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool readOnly;

  const SCTextField({
    super.key,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.controller,
    this.keyboardType,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
    this.autofillHints,
    this.textInputAction,
    this.focusNode,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<SCTextField> createState() => _SCTextFieldState();
}

class _SCTextFieldState extends State<SCTextField> {
  late bool _obscured;
  late FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final fillColor    = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final borderColor  = dark ? AppColorsDark.line2    : AppColors.line2;
    final accentColor  = dark ? AppColorsDark.accent   : AppColors.accent;
    final dangerColor  = dark ? AppColorsDark.danger   : AppColors.danger;
    final textColor    = dark ? AppColorsDark.text     : AppColors.text;
    final text2Color   = dark ? AppColorsDark.text2    : AppColors.text2;
    final text3Color   = dark ? AppColorsDark.text3    : AppColors.text3;

    final hasError = widget.error != null;
    final activeBorder = hasError
        ? dangerColor
        : _focused
            ? accentColor
            : borderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label.copyWith(color: text2Color),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: activeBorder, width: 1),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                IconTheme(
                  data: IconThemeData(color: text3Color, size: 18),
                  child: widget.prefixIcon!,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  obscureText: _obscured,
                  onChanged: widget.onChanged,
                  enabled: widget.enabled,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  autofillHints: widget.autofillHints,
                  textInputAction: widget.textInputAction,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly,
                  style: AppTextStyles.bodyMed.copyWith(color: textColor),
                  cursorColor: accentColor,
                  cursorWidth: 1.5,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: AppTextStyles.body.copyWith(color: text3Color),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    counterText: '',
                  ),
                ),
              ),
              if (widget.obscure)
                GestureDetector(
                  onTap: () => setState(() => _obscured = !_obscured),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: text3Color,
                    ),
                  ),
                )
              else if (widget.suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconTheme(
                    data: IconThemeData(color: text3Color, size: 18),
                    child: widget.suffixIcon!,
                  ),
                ),
            ],
          ),
        ),
        if (widget.helper != null && widget.error == null) ...[
          const SizedBox(height: 6),
          Text(
            widget.helper!,
            style: AppTextStyles.caption.copyWith(color: text3Color),
          ),
        ],
        if (widget.error != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.error!,
            style: AppTextStyles.caption.copyWith(color: dangerColor),
          ),
        ],
      ],
    );
  }
}

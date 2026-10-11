import 'package:flutter/material.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

class SCAmountInput extends StatefulWidget {
  const SCAmountInput({
    super.key,
    required this.controller,
    this.currencySymbol = r'$',
    this.maxAmount,
    this.onChanged,
  });

  final TextEditingController controller;
  final String currencySymbol;
  final double? maxAmount;
  final ValueChanged<String>? onChanged;

  @override
  State<SCAmountInput> createState() => _SCAmountInputState();
}

class _SCAmountInputState extends State<SCAmountInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    _blink.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) setState(() {});
    widget.onChanged?.call(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;

    final raw = widget.controller.text;
    final display = raw.isEmpty ? '0' : raw;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 4),
          child: Text(
            widget.currencySymbol,
            style: AppTextStyles.h2.copyWith(color: text2),
          ),
        ),
        Text(
          display,
          style: AppTextStyles.numDisplay.copyWith(color: text),
        ),
        const SizedBox(width: 4),
        AnimatedBuilder(
          animation: _blink,
          builder: (_, __) {
            final opacity = _blink.value < 0.5 ? 1.0 : 0.0;
            return Opacity(
              opacity: opacity,
              child: Container(
                width: 2,
                height: 36,
                color: accent,
              ),
            );
          },
        ),
      ],
    );
  }
}

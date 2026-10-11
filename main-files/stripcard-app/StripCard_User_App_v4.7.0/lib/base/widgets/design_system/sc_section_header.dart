import 'package:flutter/material.dart';

import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class SCSectionHeader extends StatelessWidget {
  const SCSectionHeader({
    super.key,
    required this.label,
    this.trailing,
  });

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppTextStyles.micro.copyWith(color: text2),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

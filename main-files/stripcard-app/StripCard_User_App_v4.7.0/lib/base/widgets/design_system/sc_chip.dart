import 'package:flutter/material.dart';

import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class SCChip extends StatelessWidget {
  const SCChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;
    final accentInk =
        dark ? AppColorsDark.accentInk : AppColors.accentInk;
    final surface2 = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;

    final Color background = selected ? accent : surface2;
    final Color foreground = selected ? accentInk : text2;
    const shape = StadiumBorder();

    return Material(
      color: background,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

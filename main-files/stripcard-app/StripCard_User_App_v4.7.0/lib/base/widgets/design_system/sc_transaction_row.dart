import 'package:flutter/material.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

class SCTransactionRow extends StatelessWidget {
  const SCTransactionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amountText,
    required this.isCredit,
    this.onTap,
  });

  final String title;
  final String subtitle;
  // The amount string as it should be rendered (caller controls sign + symbol).
  final String amountText;
  final bool isCredit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(isCredit: isCredit, title: title),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(color: text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              amountText,
              style: AppTextStyles.numMd.copyWith(
                color: isCredit ? accent : text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.isCredit, required this.title});

  final bool isCredit;
  final String title;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;
    final accentSoft =
        dark ? AppColorsDark.accentSoft : AppColors.accentSoft;
    final surface2 = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final text = dark ? AppColorsDark.text : AppColors.text;

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCredit ? accentSoft : surface2,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: isCredit
          ? Icon(Icons.arrow_downward, size: 18, color: accent)
          : Text(
              title.isEmpty ? '?' : title.characters.first.toUpperCase(),
              style: AppTextStyles.label.copyWith(color: text),
            ),
    );
  }
}

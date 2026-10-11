import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";

class SCSurfaceCard extends StatelessWidget {
  const SCSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.radius,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;

    final double effectiveRadius = radius ?? AppRadius.card;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(effectiveRadius),
      side: BorderSide(color: line2, width: 1),
    );
    final inner = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    return Material(
      color: color ?? surface,
      shape: shape,
      child: onTap == null
          ? inner
          : InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap!();
              },
              customBorder: shape,
              child: inner,
            ),
    );
  }
}

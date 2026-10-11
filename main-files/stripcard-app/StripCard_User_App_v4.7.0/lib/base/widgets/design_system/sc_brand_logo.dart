import 'package:flutter/material.dart';

import "package:stripcard/custom_assets/assets.gen.dart";

/// The real StripCard wordmark logo. Picks the colored logo on light
/// backgrounds and the white logo on dark backgrounds automatically.
class ScBrandLogo extends StatelessWidget {
  const ScBrandLogo({super.key, this.height = 28, this.alignment});

  final double height;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark ? Assets.logo.basicLogoLight.path : Assets.logo.basicLogoDark.path,
      height: height,
      alignment: alignment ?? Alignment.centerLeft,
      fit: BoxFit.contain,
    );
  }
}

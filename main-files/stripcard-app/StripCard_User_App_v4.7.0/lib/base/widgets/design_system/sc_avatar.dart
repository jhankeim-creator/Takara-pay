import 'package:flutter/material.dart';

import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";

class SCAvatar extends StatelessWidget {
  const SCAvatar({
    super.key,
    this.imageUrl,
    required this.fallbackInitials,
    this.size = 36, // v0 default
    this.backgroundColor,
  });

  final String? imageUrl;
  final String fallbackInitials;
  final double size;
  final Color? backgroundColor;

  static const List<Color> _palette = <Color>[
    Color(0xFFFCE7F3), // pink
    Color(0xFFFEF3C7), // amber
    Color(0xFFDBEAFE), // blue
    Color(0xFFD1FAE5), // mint
    Color(0xFFE9D5FF), // purple
    Color(0xFFFED7AA), // orange
  ];

  Color _backgroundFor(String seed) {
    int hash = 0;
    for (final code in seed.codeUnits) {
      hash = (hash + code) & 0x7fffffff;
    }
    return _palette[hash % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = fallbackInitials.isEmpty ? '?' : fallbackInitials;
    final bg = backgroundColor ?? _backgroundFor(initials);
    final fallback = _InitialsCircle(
      initials: initials,
      size: size,
      background: bg,
    );

    final provider = scImageProvider(imageUrl);
    if (provider == null) {
      return fallback;
    }

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image(
          image: provider,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        ),
      ),
    );
  }
}

class _InitialsCircle extends StatelessWidget {
  const _InitialsCircle({
    required this.initials,
    required this.size,
    required this.background,
  });

  final String initials;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        initials,
        style: AppTextStyles.bodyMed.copyWith(
          fontSize: size * 0.4,
          // Pastel palette is brightness-agnostic — initials always render
          // dark for contrast, regardless of the active theme.
          color: AppColors.text,
        ),
      ),
    );
  }
}

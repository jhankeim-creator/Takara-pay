import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";

/// Lazy-loading network image used app-wide. Streams + caches via
/// [CachedNetworkImage], shows a consistent [SCShimmer] placeholder while
/// loading, and a graceful icon fallback on error / empty URL.
///
/// Use this in place of `Image.network(...)`. For `DecorationImage` (e.g. a
/// background image inside a `BoxDecoration`), use [scImageProvider] instead.
class SCNetworkImage extends StatelessWidget {
  const SCNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
    this.errorIcon = Icons.image_not_supported_outlined,
    this.color,
    this.colorBlendMode,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// Optional tint (e.g. white-tinting a monochrome logo on a dark card).
  final Color? color;
  final BlendMode? colorBlendMode;

  /// Corner radius (ignored when [shape] is circle). Defaults to none.
  final double? radius;
  final BoxShape shape;
  final Color? backgroundColor;
  final IconData errorIcon;

  BorderRadius? get _borderRadius =>
      shape == BoxShape.circle || radius == null
          ? null
          : BorderRadius.circular(radius!);

  @override
  Widget build(BuildContext context) {
    // Bound the decoded bitmap to the widget's actual display size (in
    // physical pixels) instead of decoding the source image at its native
    // resolution — otherwise a large photo shown in e.g. a 40x40 avatar
    // still holds its full-resolution decode in memory for as long as it's
    // cached. Left unset when width/height aren't given (nothing safe to
    // bound to).
    final dpr = MediaQuery.of(context).devicePixelRatio;
    // Guard against double.infinity/NaN (e.g. a caller sizing this to fill
    // an unbounded parent) — (value * dpr).round() throws on a non-finite
    // double. Only the cache-size math is guarded; width/height below still
    // pass through untouched for layout.
    final memCacheWidth = (width != null && width!.isFinite && width! > 0)
        ? (width! * dpr).round()
        : null;
    final memCacheHeight = (height != null && height!.isFinite && height! > 0)
        ? (height! * dpr).round()
        : null;

    final Widget content = (url == null || url!.trim().isEmpty)
        ? _fallback(context)
        : CachedNetworkImage(
            imageUrl: url!,
            width: width,
            height: height,
            fit: fit,
            color: color,
            colorBlendMode: colorBlendMode,
            memCacheWidth: memCacheWidth,
            memCacheHeight: memCacheHeight,
            fadeInDuration: const Duration(milliseconds: 250),
            placeholder: (_, __) => _placeholder(context),
            errorWidget: (_, __, ___) => _fallback(context),
          );

    if (shape == BoxShape.circle) {
      return ClipOval(
        child: SizedBox(width: width, height: height, child: content),
      );
    }
    if (_borderRadius != null) {
      return ClipRRect(borderRadius: _borderRadius!, child: content);
    }
    return content;
  }

  Widget _placeholder(BuildContext context) {
    return SCShimmer(
      child: Container(
        width: width,
        height: height,
        color: SCShimmer.baseColor(context),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (dark ? AppColorsDark.surface2 : AppColors.surface2);
    final iconColor = dark ? AppColorsDark.text3 : AppColors.text3;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : (radius != null ? BorderRadius.circular(radius!) : null),
      ),
      child: Icon(errorIcon, size: 18, color: iconColor),
    );
  }
}

/// Cached image provider for `DecorationImage` / `CircleAvatar.backgroundImage`
/// use sites — keeps the same lazy caching as [SCNetworkImage]. Returns null
/// for an empty URL so callers can fall back to a placeholder decoration.
ImageProvider? scImageProvider(String? url) {
  if (url == null || url.trim().isEmpty) return null;
  return CachedNetworkImageProvider(url);
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";

/// StripCard shimmer system — ONE consistent shimmer look used app-wide for
/// API loading states. Wrap any tree of [SCSkeletonBox]es in a single
/// [SCShimmer] so the sweep animates uniformly.
///
/// Base/highlight tones are derived from the design tokens and resolve for
/// light/dark so every skeleton in the app matches.
class SCShimmer extends StatelessWidget {
  const SCShimmer({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  static Color baseColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A2230)
          : const Color(0xFFE9E7E0);

  static Color highlightColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF26303F)
          : const Color(0xFFF7F6F2);

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Shimmer.fromColors(
      baseColor: baseColor(context),
      highlightColor: highlightColor(context),
      period: const Duration(milliseconds: 1300),
      child: child,
    );
  }
}

/// A single shimmer placeholder block. Fill it with the base tone so the
/// [SCShimmer] sweep is visible over it. Use inside an [SCShimmer].
class SCSkeletonBox extends StatelessWidget {
  const SCSkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double height;
  final double? radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: SCShimmer.baseColor(context),
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(radius ?? AppRadius.sm),
      ),
    );
  }
}

/// List skeleton — mirrors an [SCTransactionRow]/list-tile layout (leading
/// circle + two text lines + trailing amount). Use as a loading body for any
/// list-style screen (transactions, wallet activity, gift cards, etc.).
class SCListSkeleton extends StatelessWidget {
  const SCListSkeleton({
    super.key,
    this.itemCount = 7,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 24),
  });

  final int itemCount;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SCShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 22),
        itemBuilder: (_, __) => Row(
          children: [
            const SCSkeletonBox(width: 40, height: 40, shape: BoxShape.circle),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SCSkeletonBox(width: 140, height: 12),
                  SizedBox(height: 8),
                  SCSkeletonBox(width: 90, height: 10),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const SCSkeletonBox(width: 56, height: 14),
          ],
        ),
      ),
    );
  }
}

/// Detail / card skeleton — a hero card block followed by a list of label↔value
/// rows. Use for card-details, previews, and money-operation screens.
class SCDetailSkeleton extends StatelessWidget {
  const SCDetailSkeleton({
    super.key,
    this.showHero = true,
    this.rowCount = 5,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 24),
  });

  final bool showHero;
  final int rowCount;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SCShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHero) ...[
              AspectRatio(
                aspectRatio: 1.586,
                child: SCSkeletonBox(
                  width: double.infinity,
                  height: double.infinity,
                  radius: AppRadius.lg,
                ),
              ),
              const SizedBox(height: 24),
            ],
            const SCSkeletonBox(width: 120, height: 12),
            const SizedBox(height: 16),
            for (int i = 0; i < rowCount; i++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SCSkeletonBox(width: 90, height: 12),
                  SCSkeletonBox(width: 70, height: 12),
                ],
              ),
              if (i != rowCount - 1) const SizedBox(height: 22),
            ],
          ],
        ),
      ),
    );
  }
}

/// Form skeleton — a stack of label + field placeholders, optionally preceded
/// by a hero card. Use for create/edit form screens.
class SCFormSkeleton extends StatelessWidget {
  const SCFormSkeleton({
    super.key,
    this.fieldCount = 4,
    this.showHero = false,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 24),
  });

  final int fieldCount;
  final bool showHero;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SCShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHero) ...[
              AspectRatio(
                aspectRatio: 1.586,
                child: SCSkeletonBox(
                  width: double.infinity,
                  height: double.infinity,
                  radius: AppRadius.lg,
                ),
              ),
              const SizedBox(height: 24),
            ],
            for (int i = 0; i < fieldCount; i++) ...[
              const SCSkeletonBox(width: 80, height: 11),
              const SizedBox(height: 8),
              SCSkeletonBox(
                width: double.infinity,
                height: 52,
                radius: AppRadius.lg,
              ),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_spacing.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/routes/routes.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";

/// A single row in the SCSuccessScreen breakdown card.
class SCSuccessDetail {
  final String label;
  final String value;

  /// If true, value uses tabular monospace digits.
  final bool isMono;

  /// Optional copy-to-clipboard support.
  final bool copyable;

  const SCSuccessDetail({
    required this.label,
    required this.value,
    this.isMono = false,
    this.copyable = false,
  });
}

/// Shared success screen used by all money operation flows.
///
/// Used by: Withdraw, Add Money, Send Money, Card Fund, Card Withdraw,
/// Gift Card Order, etc. Each caller passes the relevant context.
///
/// Behavior:
///   - Animated check mark fade-in on mount
///   - Primary action: "Done" → returns to dashboard
///     (Get.offAllNamed(bottomNavBarScreen))
///   - Secondary action: "View activity" → navigates to transaction log
///   - Top-left close (✕) does the same as Done for consistency
///
/// Example:
/// ```dart
/// Get.offAll(() => SCSuccessScreen(
///   title: 'Withdrawal sent',
///   subtitle: '\$50.00 to TAKARA PAY(Manual) USD',
///   details: [
///     SCSuccessDetail(label: 'Reference', value: 'WFiNY4vds146jxqK',
///                     isMono: true, copyable: true),
///     SCSuccessDetail(label: 'Arrives', value: '1-3 business days'),
///     SCSuccessDetail(label: 'Amount', value: '\$50.00', isMono: true),
///     SCSuccessDetail(label: 'Fee', value: '\$1.50', isMono: true),
///     SCSuccessDetail(label: 'Receive', value: '\$48.50', isMono: true),
///   ],
///   activityRoute: Routes.transactionLogScreen,
/// ));
/// ```
class SCSuccessScreen extends StatefulWidget {
  /// Big H1 line (e.g. 'Withdrawal sent', 'Money added', 'Sent to John')
  final String title;

  /// Optional subtitle below title (e.g. '\$50.00 to TAKARA PAY(Manual) USD')
  final String? subtitle;

  /// Breakdown rows shown inside the surface card. Empty list = no card.
  final List<SCSuccessDetail> details;

  /// Route to push when "View activity" tapped. If null, the secondary
  /// action is hidden.
  final String? activityRoute;

  /// Called when user taps Done / close. Defaults to
  /// Get.offAllNamed(Routes.bottomNavBarScreen).
  final VoidCallback? onDone;

  const SCSuccessScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.details = const [],
    this.activityRoute,
    this.onDone,
  });

  @override
  State<SCSuccessScreen> createState() => _SCSuccessScreenState();
}

class _SCSuccessScreenState extends State<SCSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _checkScale;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleDone() {
    if (widget.onDone != null) {
      widget.onDone!();
    } else {
      Get.offAllNamed(Routes.bottomNavBarScreen);
    }
  }

  void _handleViewActivity() {
    if (widget.activityRoute != null) {
      Get.offAllNamed(widget.activityRoute!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    _buildCheckMark(),
                    const SizedBox(height: AppSpacing.xl),
                    FadeTransition(
                      opacity: _fadeIn,
                      child: _buildTitleBlock(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (widget.details.isNotEmpty)
                      FadeTransition(
                        opacity: _fadeIn,
                        child: _buildDetailsCard(context),
                      ),
                  ],
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeIn,
              child: _buildBottomActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.text),
            onPressed: _handleDone,
            splashRadius: 22,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCheckMark() {
    return Center(
      child: ScaleTransition(
        scale: _checkScale,
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent,
              width: 2.5,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 48,
              color: AppColors.accentInk,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBlock(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(color: AppColors.text),
        ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.subtitle!,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: List.generate(widget.details.length, (i) {
          final detail = widget.details[i];
          final isLast = i == widget.details.length - 1;
          return Container(
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: AppColors.line2, width: 1),
                    ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    detail.label,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          detail.value,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: detail.isMono
                              ? AppTextStyles.numSm.copyWith(
                                  color: AppColors.text,
                                )
                              : AppTextStyles.bodyMed.copyWith(
                                  color: AppColors.text,
                                ),
                        ),
                      ),
                      if (detail.copyable) ...[
                        const SizedBox(width: AppSpacing.xs),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: detail.value),
                            );
                            Get.snackbar(
                              '',
                              'Copied to clipboard',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.text,
                              colorText: AppColors.bg,
                              margin: const EdgeInsets.all(AppSpacing.md),
                              borderRadius: 12,
                              titleText: const SizedBox.shrink(),
                              duration: const Duration(seconds: 2),
                            );
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(color: AppColors.line2, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SCPrimaryButton(
            label: 'Done',
            onPressed: _handleDone,
          ),
          if (widget.activityRoute != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: _handleViewActivity,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.text2,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
              ),
              child: Text(
                'View activity',
                style: AppTextStyles.bodyMed.copyWith(
                  color: AppColors.text2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";

/// Shared "this screen couldn't load — retry" state.
///
/// Only meant for screens that truly cannot proceed without the failed
/// request (the body would otherwise read an uninitialised model / crash).
/// Recoverable background refreshes — like the language API — must NOT use
/// this; they fall back to cached/bundled data instead so the app stays
/// fully usable while retrying silently.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.loading = false,
    this.icon = Icons.cloud_off_rounded,
    this.iconSize = 40,
    this.primaryButton = false,
    this.scrollable = false,
    this.topSpacing = 0,
  });

  final String title;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  final bool loading;
  final IconData icon;
  final double iconSize;

  /// false (default) = SCSecondaryButton, not full-width — matches most
  /// inline error states. true = SCPrimaryButton, full-width — for
  /// full-screen/tab-root error states (e.g. the dashboard).
  final bool primaryButton;

  /// false (default) = centered column. true = a scrollable ListView (so
  /// RefreshIndicator / pull-to-refresh keeps working on a full-screen tab).
  final bool scrollable;

  /// Extra space above the icon when [scrollable] is true.
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface2 = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (scrollable)
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: surface2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 30, color: text3),
            )
          else
            Icon(icon, size: iconSize, color: text3),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(color: text),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: text3),
          ),
          const SizedBox(height: 24),
          if (primaryButton)
            SCPrimaryButton(label: retryLabel, loading: loading, onPressed: onRetry)
          else
            SCSecondaryButton(label: retryLabel, fullWidth: false, onPressed: onRetry),
        ],
      ),
    );

    if (!scrollable) {
      return Center(child: content);
    }
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        SizedBox(height: topSpacing),
        content,
      ],
    );
  }
}

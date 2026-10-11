import 'package:flutter/services.dart';

import "package:stripcard/views/auth/controller/log_out/log_out.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final dashBoardController = Get.put(DashBoardController());
  final logOutController = Get.put(LogOutController());

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? AppColorsDark.bg : AppColors.bg,
      body: SafeArea(
        child: Obx(() {
          if (dashBoardController.isLoading &&
              !dashBoardController.hasLoadedOnce.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          return _buildBody(context, dark);
        }),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool dark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            Get.find<LanguageController>().getTranslation(Strings.settings),
            style: AppTextStyles.h1.copyWith(
              color: dark ? AppColorsDark.text : AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          _buildProfileCard(dark),
          const SizedBox(height: 24),
          const SCSectionHeader(label: 'ACCOUNT'),
          _buildAccountSection(),
          const SizedBox(height: 20),
          const SCSectionHeader(label: 'SUPPORT'),
          _buildSupportSection(),
          const SizedBox(height: 32),
          _buildSignOutCard(),
          const SizedBox(height: 100), // floating bottom-nav clearance
        ],
      ),
    );
  }

  // ── Profile card ──────────────────────────────────────────────────────
  Widget _buildProfileCard(bool dark) {
    String fullName = '';
    String email = '';
    int kycVerified = 0;
    String imageUrl = '';
    String memberSince = '';
    try {
      final user = dashBoardController.dashBoardModel.data.user;
      fullName = '${user.firstname} ${user.lastname}'.trim();
      email = user.email;
      kycVerified = user.kycVerified;
      imageUrl = user.userImage;
      memberSince = 'Member since ${user.createdAt.year}';
    } catch (_) {
      // Model not loaded yet — fall through with empty defaults.
    }

    final initials = fullName.isEmpty
        ? '?'
        : fullName
            .split(' ')
            .map((s) => s.isNotEmpty ? s[0] : '')
            .take(2)
            .join()
            .toUpperCase();
    final isVerified = kycVerified > 0;

    return SCSurfaceCard(
      padding: const EdgeInsets.all(16),
      onTap: () => Get.toNamed(Routes.updateProfileScreen),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dark ? AppColorsDark.surface2 : AppColors.surface2,
              shape: BoxShape.circle,
              border: Border.all(
                color: dark ? AppColorsDark.line2 : AppColors.line2,
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl.trim().isNotEmpty
                ? SCNetworkImage(
                    url: imageUrl,
                    width: 56,
                    height: 56,
                    shape: BoxShape.circle,
                    errorIcon: Icons.person_outline,
                  )
                : Text(
                    initials,
                    style: AppTextStyles.h2.copyWith(
                      color: dark ? AppColorsDark.text : AppColors.text,
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fullName.isEmpty ? 'Your account' : fullName,
                  style: AppTextStyles.bodyMed.copyWith(
                    color: dark ? AppColorsDark.text : AppColors.text,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppTextStyles.caption.copyWith(
                      color: dark ? AppColorsDark.text3 : AppColors.text3,
                    ),
                  ),
                ],
                if (memberSince.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    memberSince,
                    style: AppTextStyles.caption.copyWith(
                      color: dark ? AppColorsDark.text3 : AppColors.text3,
                    ),
                  ),
                ],
                if (isVerified) ...[
                  const SizedBox(height: 8),
                  _verifiedPill(dark),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: dark ? AppColorsDark.text3 : AppColors.text3,
          ),
        ],
      ),
    );
  }

  Widget _verifiedPill(bool dark) {
    final accent = dark ? AppColorsDark.accent : AppColors.accent;
    final accentSoft =
        dark ? AppColorsDark.accentSoft : AppColors.accentSoft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 12, color: accent),
          const SizedBox(width: 4),
          Text(
            Get.find<LanguageController>().getTranslation(Strings.verified),
            style: AppTextStyles.caption.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Account section ───────────────────────────────────────────────────
  Widget _buildAccountSection() {
    int kycVerified = 0;
    try {
      kycVerified = dashBoardController.dashBoardModel.data.user.kycVerified;
    } catch (_) {}
    final kycSubtitle = kycVerified > 0
        ? Get.find<LanguageController>().getTranslation(Strings.verified)
        : Get.find<LanguageController>().getTranslation(Strings.required);

    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.verified_user_outlined,
            title: 'Identity verification',
            subtitle: kycSubtitle,
            onTap: () => Get.toNamed(Routes.kycScreen),
          ),
          const _SettingsDivider(),
          _SettingsRow(
            icon: Icons.shield_outlined,
            title: 'Security & privacy',
            // No dedicated security route; closest existing destination is
            // the 2FA enable screen.
            onTap: () => Get.toNamed(Routes.enable2FaScreen),
          ),
          const _SettingsDivider(),
          _SettingsRow(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            onTap: () => Get.toNamed(Routes.notificationScreen),
          ),
          // 'Edit profile' row removed — the tappable account card at the top
          // already opens the profile editor (it was a duplicate destination).
        ],
      ),
    );
  }

  // ── Support section ───────────────────────────────────────────────────
  Widget _buildSupportSection() {
    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.help_outline_rounded,
            title: 'Help center',
            onTap: () => Get.toNamed(Routes.helpCenter),
          ),
          const _SettingsDivider(),
          _SettingsRow(
            icon: Icons.lock_outline,
            title: 'Change password',
            onTap: () => Get.toNamed(Routes.changePasswordScreen),
          ),
          const _SettingsDivider(),
          _SettingsRow(
            icon: Icons.receipt_long_outlined,
            title: 'Transaction log',
            onTap: () => Get.toNamed(Routes.transactionLogScreen),
          ),
        ],
      ),
    );
  }

  // ── Sign out (destructive) ────────────────────────────────────────────
  Widget _buildSignOutCard() {
    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: _SettingsRow(
        icon: Icons.logout_rounded,
        title: 'Sign out',
        danger: true,
        onTap: () => logOutController.logOutProcess(),
      ),
    );
  }
}

// ── Reusable row + divider for the settings list ────────────────────────

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool danger;

  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = danger
        ? (dark ? AppColorsDark.danger : AppColors.danger)
        : (dark ? AppColorsDark.text2 : AppColors.text2);
    final titleColor = danger
        ? (dark ? AppColorsDark.danger : AppColors.danger)
        : (dark ? AppColorsDark.text : AppColors.text);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMed.copyWith(color: titleColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: dark ? AppColorsDark.text3 : AppColors.text3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!danger) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: dark ? AppColorsDark.text3 : AppColors.text3,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Divider(
        height: 1,
        thickness: 1,
        color: dark ? AppColorsDark.line2 : AppColors.line2,
      ),
    );
  }
}

import 'dart:math' as math;

import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/api/model/onboard/app_settings_model.dart";
import "package:TAKARA PAY/views/app_settings/controller/app_settings_controller.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_network_image.dart";
import "package:TAKARA PAY/views/onboard/controller/onboard_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";

class _OnboardPage {
  const _OnboardPage({
    required this.title,
    required this.subtitle,
    this.cardName = '',
    this.balance = '',
    this.variant = SCCardVariant.midnight,
    this.imageUrl = '',
  });

  final String title;
  final String subtitle;
  final String cardName;
  final String balance;
  final SCCardVariant variant;
  // Non-empty for API-driven slides — rendered as a network image hero
  // instead of the illustrative virtual card.
  final String imageUrl;
}

const List<_OnboardPage> _pages = [
  _OnboardPage(
    title: 'Pay anything online, risk-free.',
    subtitle:
        'Spin up a virtual card in seconds. Use it once or for one merchant — your real card stays private.',
    cardName: 'Subscriptions',
    balance: r'$1,284.50',
    variant: SCCardVariant.midnight,
  ),
  _OnboardPage(
    title: 'One card per merchant. One tap to freeze.',
    subtitle:
        'Limit each merchant to its own card. If one leaks, freeze it in a tap. Your other cards stay live.',
    cardName: 'Ads',
    balance: r'$840.00',
    variant: SCCardVariant.plum,
  ),
  _OnboardPage(
    title: 'Move money in seconds. Across currencies.',
    subtitle:
        'Add money from any linked bank, send to anyone on TAKARA PAY, and hold USD, EUR and GBP side by side.',
    cardName: 'Travel',
    balance: r'$2,150.00',
    variant: SCCardVariant.forest,
  ),
];

class OnboardScreen extends StatelessWidget {
  OnboardScreen({super.key});

  final controller = Get.put(OnBoardController());
  final appSettings = Get.put(AppSettingsController());

  // API-driven slides (admin panel "Onboard Screen" settings) when available;
  // the polished static pages otherwise (first launch before the fetch lands,
  // or when the backend has no enabled slides).
  List<_OnboardPage> get _resolvedPages {
    final remote = appSettings.onboardScreen;
    if (remote.isEmpty) return _pages;
    return remote
        .map((s) => _OnboardPage(
              title: s.title,
              subtitle: s.subTitle,
              imageUrl: s.image,
            ))
        .toList();
  }

  void _skip() {
    LocalStorage.saveOnboardDoneOrNot(isOnBoardDone: true);
    Get.toNamed(Routes.signInScreen);
  }

  void _continue(int pageCount) {
    // Last page → finish onboarding; otherwise advance one slide. (The old
    // controller logic counted a legacy 2-item list against 3 rendered pages,
    // which left the final "Get started" button doing nothing.)
    if (controller.selectedIndex.value >= pageCount - 1) {
      _skip();
    } else {
      controller.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top row — back (page 2+) on left, skip on right.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Obx(() {
                final showBack = controller.selectedIndex.value > 0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showBack)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: controller.backPage,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.text,
                          ),
                          splashRadius: 22,
                        ),
                      )
                    else
                      const SizedBox(width: 40, height: 40),
                    SCGhostButton(
                      label: 'Skip',
                      onPressed: _skip,
                      fullWidth: false,
                    ),
                  ],
                );
              }),
            ),

            // Pages — API-driven when available, static fallback otherwise.
            Expanded(
              child: Obx(() {
                final pages = _resolvedPages;
                return PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: controller.selectedIndex,
                  itemCount: pages.length,
                  itemBuilder: (context, index) => _buildPage(pages[index]),
                );
              }),
            ),

            // Bottom block — indicator + primary button.
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Obx(() => _buildIndicator(
                      controller.selectedIndex.value, _resolvedPages.length)),
                  const SizedBox(height: 24),
                  Obx(() {
                    final count = _resolvedPages.length;
                    final isFinal =
                        controller.selectedIndex.value >= count - 1;
                    return SCPrimaryButton(
                      label: isFinal ? 'Get started' : 'Continue',
                      onPressed: () => _continue(count),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          if (page.imageUrl.isNotEmpty)
            SizedBox(
              height: 280,
              child: Center(
                child: SCNetworkImage(
                  url: page.imageUrl,
                  height: 260,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.transparent,
                ),
              ),
            )
          else
          SizedBox(
            height: 280,
            child: Center(
              child: Transform.rotate(
                angle: -4 * math.pi / 180,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 32,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: SCVirtualCard(
                    cardName: page.cardName,
                    last4: '7755',
                    balance: page.balance,
                    variant: page.variant,
                    width: 240,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            page.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            page.subtitle,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildIndicator(int activeIndex, int count) {
    final children = <Widget>[];
    for (int i = 0; i < count; i++) {
      final isActive = i == activeIndex;
      children.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 6,
          width: isActive ? 24 : 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.line,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );
      if (i != count - 1) {
        children.add(const SizedBox(width: 6));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

import 'dart:math' as math;

import "package:TAKARA PAY/views/app_settings/controller/app_settings_controller.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_network_image.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_spacing.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_brand_logo.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();

    // Preserve original controller wiring — AppSettingsController.onInit()
    // is what kicks off the splash → next-route navigation. LanguageController
    // is registered globally in main.dart's initialBinding and is just
    // retrieved here to match the previous behaviour.
    Get.put(AppSettingsController());
    Get.find<LanguageController>();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  // Admin-configured splash image: the live URL once /app-settings responds,
  // else the cached one from the previous launch. Empty on true first launch.
  String _splashImageUrl() {
    final live = Get.find<AppSettingsController>().splashImagePath.value;
    if (live.trim().isNotEmpty) return live;
    return LocalStorage.getSplashImage().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() {
        final url = _splashImageUrl();
        if (url.isNotEmpty) {
          // Admin-configured splash artwork is a full-screen image — render it
          // edge-to-edge (no SafeArea, cover fit), exactly like a native splash.
          return SizedBox.expand(
            child: SCNetworkImage(
              url: url,
              fit: BoxFit.cover,
              backgroundColor: Colors.transparent,
            ),
          );
        }
        // Fallback (first launch, no cache yet): the built-in branded splash.
        return SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogoBlock(),
                const SizedBox(height: 32),
                const ScBrandLogo(height: 34, alignment: Alignment.center),
                const SizedBox(height: 6),
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.payAnythingOnlineRiskFree),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    Get.find<LanguageController>()
                        .getTranslation(Strings.fundsHeldByFdicPartnerBank),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLogoBlock() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        final entryScale = 0.85 + (1.0 - 0.85) * t;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(scale: entryScale, child: child),
        );
      },
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final pulseScale = 0.98 + 0.04 * _pulse.value;
          return Transform.scale(scale: pulseScale, child: child);
        },
        child: SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Transform.translate(
                offset: const Offset(-12, -8),
                child: Transform.rotate(
                  angle: -8 * math.pi / 180,
                  child: const SCVirtualCard(
                    cardName: 'Ads',
                    last4: '7755',
                    balance: r'$840.00',
                    variant: SCCardVariant.plum,
                    width: 220,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(12, 8),
                child: Transform.rotate(
                  angle: 6 * math.pi / 180,
                  child: const SCVirtualCard(
                    cardName: 'Subscriptions',
                    last4: '7755',
                    balance: r'$1,284.50',
                    variant: SCCardVariant.midnight,
                    width: 220,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

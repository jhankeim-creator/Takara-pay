import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

class SCNavItem {
  final String id;
  final String label;
  final IconData iconOutlined;
  final IconData iconFilled;

  const SCNavItem({
    required this.id,
    required this.label,
    required this.iconOutlined,
    required this.iconFilled,
  });
}

class SCBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<SCNavItem> items;

  const SCBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    this.items = defaultItems,
  });

  static const List<SCNavItem> defaultItems = [
    SCNavItem(
      id: 'home',
      label: 'Home',
      iconOutlined: Icons.home_outlined,
      iconFilled: Icons.home_rounded,
    ),
    SCNavItem(
      id: 'cards',
      label: 'Cards',
      iconOutlined: Icons.credit_card_outlined,
      iconFilled: Icons.credit_card,
    ),
    SCNavItem(
      id: 'activity',
      label: 'Activity',
      iconOutlined: Icons.history,
      iconFilled: Icons.history_rounded,
    ),
    SCNavItem(
      id: 'you',
      label: 'You',
      iconOutlined: Icons.person_outline,
      iconFilled: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg      = dark ? AppColorsDark.bg      : AppColors.bg;
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final line    = dark ? AppColorsDark.line    : AppColors.line;
    final text    = dark ? AppColorsDark.text    : AppColors.text;
    final text2   = dark ? AppColorsDark.text2   : AppColors.text2;

    return Container(
      // Fade gradient from transparent to bg — softens the content fade-out
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bg.withOpacity(0.0),
            bg.withOpacity(0.95),
          ],
          stops: const [0.0, 0.4],
        ),
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: 12 + MediaQuery.of(context).padding.bottom * 0.5,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: line, width: 1),
            ),
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final item = items[i];
                final active = i == currentIndex;
                return Expanded(
                  child: _SCNavButton(
                    item: item,
                    active: active,
                    activeColor: text,
                    inactiveColor: text2,
                    activeBg: text.withOpacity(0.06),
                    onTap: () {
                      if (!active) {
                        HapticFeedback.selectionClick();
                        onChanged(i);
                      }
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _SCNavButton extends StatelessWidget {
  final SCNavItem item;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBg;
  final VoidCallback onTap;

  const _SCNavButton({
    required this.item,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 44,
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                active ? item.iconFilled : item.iconOutlined,
                size: 20,
                color: active ? activeColor : inactiveColor,
              ),
              if (active) ...[
                const SizedBox(width: 6),
                Text(
                  item.label,
                  style: AppTextStyles.label.copyWith(
                    color: activeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

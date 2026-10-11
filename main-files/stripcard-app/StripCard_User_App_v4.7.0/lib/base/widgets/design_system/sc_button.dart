import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

enum SCButtonSize { sm, md, lg }

class SCPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final SCButtonSize size;

  const SCPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
    this.size = SCButtonSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent    = dark ? AppColorsDark.accent    : AppColors.accent;
    final accentInk = dark ? AppColorsDark.accentInk : AppColors.accentInk;
    return _SCButton(
      label: label,
      onPressed: onPressed,
      loading: loading,
      icon: icon,
      fullWidth: fullWidth,
      size: size,
      backgroundColor: accent,
      foregroundColor: accentInk,
      borderColor: Colors.transparent,
    );
  }
}

class SCSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final SCButtonSize size;

  const SCSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
    this.size = SCButtonSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final text    = dark ? AppColorsDark.text    : AppColors.text;
    final line    = dark ? AppColorsDark.line    : AppColors.line;
    return _SCButton(
      label: label,
      onPressed: onPressed,
      loading: loading,
      icon: icon,
      fullWidth: fullWidth,
      size: size,
      backgroundColor: surface,
      foregroundColor: text,
      borderColor: line,
    );
  }
}

class SCGhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final SCButtonSize size;
  final Color? color;

  const SCGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = false,
    this.size = SCButtonSize.md,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fg = color ?? (dark ? AppColorsDark.text : AppColors.text);
    return _SCButton(
      label: label,
      onPressed: onPressed,
      loading: loading,
      icon: icon,
      fullWidth: fullWidth,
      size: size,
      backgroundColor: Colors.transparent,
      foregroundColor: fg,
      borderColor: Colors.transparent,
    );
  }
}

class SCDangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final SCButtonSize size;

  const SCDangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
    this.size = SCButtonSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final danger = dark ? AppColorsDark.danger : AppColors.danger;
    return _SCButton(
      label: label,
      onPressed: onPressed,
      loading: loading,
      icon: icon,
      fullWidth: fullWidth,
      size: size,
      backgroundColor: danger,
      foregroundColor: Colors.white,
      borderColor: Colors.transparent,
    );
  }
}

class _SCButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final SCButtonSize size;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const _SCButton({
    required this.label,
    required this.onPressed,
    required this.loading,
    required this.icon,
    required this.fullWidth,
    required this.size,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  @override
  State<_SCButton> createState() => _SCButtonState();
}

class _SCButtonState extends State<_SCButton> {
  bool _pressed = false;

  ({double height, double px, double fontSize, double gap}) _sizing() {
    switch (widget.size) {
      case SCButtonSize.sm:
        return (height: 36, px: 14, fontSize: 14, gap: 6);
      case SCButtonSize.md:
        return (height: 48, px: 18, fontSize: 15, gap: 8);
      case SCButtonSize.lg:
        return (height: 56, px: 22, fontSize: 16, gap: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _sizing();
    final disabled = widget.onPressed == null || widget.loading;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: disabled ? 0.55 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          height: s.height,
          child: Material(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: disabled
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      widget.onPressed?.call();
                    },
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: s.px),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: widget.borderColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.loading)
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            widget.foregroundColor,
                          ),
                        ),
                      )
                    else if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: 18,
                        color: widget.foregroundColor,
                      ),
                      SizedBox(width: s.gap),
                    ],
                    if (!widget.loading)
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: s.fontSize,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.1,
                          color: widget.foregroundColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

enum SCCardNetwork { visa, mastercard }

enum SCCardVariant {
  midnight,
  plum,
  slate,
  forest,
  ocean,
  violet,
  sunset,
  rose,
  teal,
}

/// Vibrant, distinct backgrounds cycled across a user's cards so each card has
/// its own colour (like the colourful gift-card set) instead of every card
/// looking the same. Index a card's position into this list.
const List<SCCardVariant> kCardVariants = [
  SCCardVariant.ocean,
  SCCardVariant.violet,
  SCCardVariant.sunset,
  SCCardVariant.teal,
  SCCardVariant.rose,
  SCCardVariant.forest,
];

/// Public accessor so other screens (card list thumbnails, etc.) can paint the
/// same gradient as the full card for a given variant.
List<Color> cardGradientFor(SCCardVariant variant) => _gradientFor(variant);

List<Color> _gradientFor(SCCardVariant variant) {
  switch (variant) {
    case SCCardVariant.midnight:
      return const [Color(0xFF1E293B), Color(0xFF0F172A)];
    case SCCardVariant.plum:
      return const [Color(0xFF3B1E5C), Color(0xFF1E1144)];
    case SCCardVariant.slate:
      return const [Color(0xFF374151), Color(0xFF1F2937)];
    case SCCardVariant.forest:
      return const [Color(0xFF0F766E), Color(0xFF064E3B)];
    case SCCardVariant.ocean:
      return const [Color(0xFF2563EB), Color(0xFF1E3A8A)];
    case SCCardVariant.violet:
      return const [Color(0xFF7C3AED), Color(0xFF4C1D95)];
    case SCCardVariant.sunset:
      return const [Color(0xFFF97316), Color(0xFFB45309)];
    case SCCardVariant.rose:
      return const [Color(0xFFE11D48), Color(0xFF881337)];
    case SCCardVariant.teal:
      return const [Color(0xFF0891B2), Color(0xFF155E75)];
  }
}

class SCVirtualCard extends StatelessWidget {
  const SCVirtualCard({
    super.key,
    required this.cardName,
    required this.last4,
    this.balance,
    this.expiry = '••/••',
    this.network = SCCardNetwork.visa,
    this.variant = SCCardVariant.midnight,
    this.frozen = false,
    this.width = double.infinity,
    this.aspectRatio = 1.586,
  });

  final String cardName;
  final String last4;
  final String? balance;
  final String expiry;
  final SCCardNetwork network;
  final SCCardVariant variant;
  final bool frozen;
  final double width;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _CardSurface(
                variant: variant,
                cardName: cardName,
                last4: last4,
                balance: balance,
                expiry: expiry,
                network: network,
              ),
              if (frozen) const _FrostedOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({
    required this.variant,
    required this.cardName,
    required this.last4,
    required this.balance,
    required this.expiry,
    required this.network,
  });

  final SCCardVariant variant;
  final String cardName;
  final String last4;
  final String? balance;
  final String expiry;
  final SCCardNetwork network;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientFor(variant),
            ),
          ),
        ),
        // Subtle glossy highlight for depth/realism.
        Positioned(
          top: -50,
          right: -30,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        // Content — laid out at a fixed design size and scaled to fit the
        // actual card box (same aspect ratio → no distortion). This keeps the
        // layout identical and overflow-free whether the card is large
        // (dashboard) or small (onboarding/splash).
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: 340,
              height: 214,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
              // Brand + chip
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'TAKARA PAY · VIRTUAL',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cardName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMed.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const _EmvChip(),
                ],
              ),
              // Card number
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '••••  ••••  ••••  $last4',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 16,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
              // Balance | expires | network
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (balance != null)
                    Expanded(
                      child: _Stat(
                        label: 'BALANCE',
                        value: balance!,
                        valueStyle: AppTextStyles.numLg,
                      ),
                    )
                  else
                    const Spacer(),
                  _Stat(
                    label: 'EXPIRES',
                    value: expiry,
                    valueStyle: AppTextStyles.numMd,
                  ),
                  const SizedBox(width: 16),
                  _NetworkLogo(network: network),
                ],
              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: valueStyle.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _EmvChip extends StatelessWidget {
  const _EmvChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _NetworkLogo extends StatelessWidget {
  const _NetworkLogo({required this.network});

  final SCCardNetwork network;

  @override
  Widget build(BuildContext context) {
    switch (network) {
      case SCCardNetwork.mastercard:
        return const SizedBox(
          width: 36,
          height: 22,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: _NetworkCircle(color: Color(0xFFEB001B)),
              ),
              Positioned(
                left: 14,
                child: _NetworkCircle(color: Color(0xFFF79E1B)),
              ),
            ],
          ),
        );
      case SCCardNetwork.visa:
        return const Text(
          'VISA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            fontSize: 18,
            letterSpacing: 1,
          ),
        );
    }
  }
}

class _NetworkCircle extends StatelessWidget {
  const _NetworkCircle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _FrostedOverlay extends StatelessWidget {
  const _FrostedOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          color: Colors.white.withOpacity(0.15),
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: -15 * math.pi / 180,
            child: Text(
              'FROZEN',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 28,
                letterSpacing: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SCMiniVirtualCard extends StatelessWidget {
  const SCMiniVirtualCard({
    super.key,
    required this.cardName,
    required this.last4,
    this.network = SCCardNetwork.visa,
    this.variant = SCCardVariant.midnight,
  });

  final String cardName;
  final String last4;
  final SCCardNetwork network;
  final SCCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60 * 1.586,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientFor(variant),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cardName,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '•• $last4',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
              _MiniNetworkLogo(network: network),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniNetworkLogo extends StatelessWidget {
  const _MiniNetworkLogo({required this.network});

  final SCCardNetwork network;

  @override
  Widget build(BuildContext context) {
    switch (network) {
      case SCCardNetwork.mastercard:
        return const SizedBox(
          width: 18,
          height: 12,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFEB001B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 6,
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFF79E1B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case SCCardNetwork.visa:
        return const Text(
          'VISA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            fontSize: 9,
            letterSpacing: 0.5,
          ),
        );
    }
  }
}

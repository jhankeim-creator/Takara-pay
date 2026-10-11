import 'package:flip_card/flip_card.dart';

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class CardWidget extends StatelessWidget {
  final String cardNumber, expiryDate, balance, validAt, cvv, logo;
  final String? availableBalance;
  final String? cardBgNetwork;
  final String? cardType;
  final bool isNetworkImage;

  const CardWidget({
    super.key,
    required this.cardNumber,
    this.cardType,
    this.availableBalance,
    required this.expiryDate,
    required this.balance,
    required this.validAt,
    required this.cvv,
    required this.logo,
    this.isNetworkImage = true,
    this.cardBgNetwork = '',
  });

  String get _last4 {
    final digits = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 4) return digits.substring(digits.length - 4);
    return cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return FlipCard(
      fill: Fill.fillFront,
      direction: FlipDirection.HORIZONTAL,
      front: ClipRRect(
        borderRadius: radius,
        child: Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
            borderRadius: radius,
          ),
          child: Column(
            crossAxisAlignment: crossStart,
            mainAxisAlignment: mainSpaceBet,
            children: [
              Row(
                mainAxisAlignment: mainSpaceBet,
                crossAxisAlignment: crossStart,
                children: [
                  Column(
                    crossAxisAlignment: crossStart,
                    mainAxisSize: mainMin,
                    children: [
                      Text(
                        'TAKARA PAY · VIRTUAL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'VISA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 28,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              Text(
                '•••• •••• •••• $_last4',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: mainSpaceBet,
                crossAxisAlignment: crossEnd,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: crossStart,
                      mainAxisSize: mainMin,
                      children: [
                        Text(
                          (availableBalance ?? Strings.availabeBlance)
                              .toUpperCase(),
                          style: AppTextStyles.micro.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          balance,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.numLg.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: crossEnd,
                    mainAxisSize: mainMin,
                    children: [
                      Text(
                        Strings.expiryDate.toUpperCase(),
                        style: AppTextStyles.micro.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        expiryDate,
                        style: AppTextStyles.numMd.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      back: ClipRRect(
        borderRadius: radius,
        child: Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
            borderRadius: radius,
          ),
          child: Column(
            crossAxisAlignment: crossStart,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 40,
                width: double.infinity,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              Text(
                'CVV',
                style: AppTextStyles.micro.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  cvv,
                  style: AppTextStyles.numSm.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Valid: $validAt',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

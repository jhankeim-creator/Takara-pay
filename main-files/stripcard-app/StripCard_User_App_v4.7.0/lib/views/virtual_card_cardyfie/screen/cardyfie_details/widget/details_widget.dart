part of '../cardyfie_details_screen.dart';

class CardyfieDetailsWidget extends StatelessWidget {
  CardyfieDetailsWidget({super.key});
  final controller = Get.put(CardyfieDetailsController());
  @override
  Widget build(BuildContext context) {
    var myCards = controller.cardDetailsModelCardyfie.data.myCard;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              Strings.cardInformation.toUpperCase(),
              textAlign: TextAlign.left,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          const Divider(height: 1, thickness: 0.5, color: AppColors.line2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              // crossAxisAlignment: crossEnd,
              children: [
                DetailsRowWidget(
                  variable: Strings.cardHolderSName,
                  value: myCards.cardName,
                ),
                DetailsRowWidget(
                  variable: Strings.cardId,
                  value: myCards.ulid,
                  mono: true,
                ),
                DetailsRowWidget(
                  variable: Strings.amount,
                  value: myCards.amount.toString(),
                  mono: true,
                ),

                DetailsRowWidget(
                  variable: Strings.cardType,
                  value: myCards.cardType,
                ),

                DetailsRowWidget(
                  variable: Strings.cardTier,
                  value: myCards.cardTier,
                ),
                DetailsRowWidget(
                  variable: Strings.customerId,
                  value: myCards.customerUlid,
                  mono: true,
                ),
                DetailsRowWidget(
                  variable: Strings.cardNumber,
                  value: myCards.realPan,
                  mono: true,
                ),
                DetailsRowWidget(
                  variable: Strings.walletOtp,
                  value: myCards.walletOtp.toString(),
                  mono: true,
                ),
                if (myCards.walletExpiry != null)
                  DetailsCountdownRowWidget(
                    variable: Strings.walletOtpExpiry,
                    expiry: myCards.walletExpiry!,
                  ),
                DetailsRowWidget(
                  variable: Strings.paymentOtp,
                  value: myCards.paymentOtp.toString(),
                  mono: true,
                ),
                if (myCards.paymentExpiry != null)
                  DetailsCountdownRowWidget(
                    variable: Strings.paymentOtpExpiry,
                    expiry: myCards.paymentExpiry!,
                  ),

                ///>>>>>>>> card cvc
                DetailsRowWidget(
                  variable: Strings.cvc,
                  value: myCards.cvv,
                  mono: true,
                ),

                DetailsRowWidget(
                  variable: Strings.expiration,
                  value: myCards.cardExpTime,
                  mono: true,
                ),
                DetailsRowWidget(
                  variable: Strings.cardEnvironment,
                  value: myCards.env,
                ),
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.line2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      Expanded(
                        child: Text(
                          Strings.freezeCard,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.isCardStatusLoading
                            ? const CustomSwitchLoading(
                                color: AppColors.accent,
                              )
                            : Switch(
                                activeColor: AppColors.accent,
                                value: controller.isSelected.value,
                                onChanged: (value) {
                                  controller.cardToggle(); // ✅ clean call
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsRowWidget extends StatelessWidget {
  DetailsRowWidget({
    super.key,
    required this.variable,
    required this.value,
    this.mono = false,
  });
  final String variable, value;
  final bool mono;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: mainSpaceBet,
        crossAxisAlignment: crossStart,
        children: [
          Expanded(
            child: Text(
              variable,
              style: AppTextStyles.body.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: mono
                  ? AppTextStyles.numSm.copyWith(color: AppColors.text)
                  : AppTextStyles.bodyMed.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsCountdownRowWidget extends StatefulWidget {
  final String variable;
  final DateTime expiry;
  const DetailsCountdownRowWidget({
    Key? key,
    required this.variable,
    required this.expiry,
  }) : super(key: key);

  @override
  State<DetailsCountdownRowWidget> createState() =>
      _DetailsCountdownRowWidgetState();
}

class _DetailsCountdownRowWidgetState extends State<DetailsCountdownRowWidget> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateTime();
        if (_timeLeft == Duration.zero) {
          timer.cancel();
        }
        setState(() {});
      }
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    if (widget.expiry.isAfter(now)) {
      _timeLeft = widget.expiry.difference(now);
    } else {
      _timeLeft = Duration.zero;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return "Expired";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    bool isExpired = _timeLeft == Duration.zero;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: mainSpaceBet,
        crossAxisAlignment: crossStart,
        children: [
          Expanded(
            child: Text(
              widget.variable,
              style: AppTextStyles.body.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _formatDuration(_timeLeft),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.numSm.copyWith(
                color: isExpired ? AppColors.danger : AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

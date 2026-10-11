part of '../cardyfie_transaction_screen.dart';

class CardyfieExpandableWidget extends StatefulWidget {
  const CardyfieExpandableWidget({
    super.key,
    required this.amount,
    required this.title,
    required this.dateText,
    required this.transaction,
    required this.monthText,
    required this.status,
    required this.amountType,
  });

  final String title,
      monthText,
      dateText,
      amount,
      transaction,
      status,
      amountType;

  @override
  State<CardyfieExpandableWidget> createState() =>
      _CardyfieExpandableWidgetState();
}

class _CardyfieExpandableWidgetState extends State<CardyfieExpandableWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // Top Row (Status, Title, Amount + Date)
              Row(
                crossAxisAlignment: crossCenter,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: crossStart,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMed.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.status,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.amount,
                        style: AppTextStyles.numMd.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.dateText,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expanded section
              if (isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 0.5, color: AppColors.line2),
                const SizedBox(height: 12),

                _rowItem(Icons.receipt_long, Strings.trxID, widget.transaction),
                const SizedBox(height: 10),
                _rowItem(
                  Icons.account_balance_wallet,
                  Strings.amountType,
                  widget.amountType,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.text3),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.numSm.copyWith(color: AppColors.text),
        ),
      ],
    );
  }
}

part of "../cardyfie_create_card_screen.dart";

class CardyfieCreateCardWidget extends StatefulWidget {
  const CardyfieCreateCardWidget({super.key});

  @override
  State<CardyfieCreateCardWidget> createState() =>
      _CardyfieCreateCardWidgetState();
}

class _CardyfieCreateCardWidgetState extends State<CardyfieCreateCardWidget> {
  final controller = Get.put(VirtualCardyfieCardController());

  @override
  void initState() {
    super.initState();
    // Live preview: rebuild the hero card as the holder name is typed.
    controller.cardHolderNameController.addListener(_rebuild);
  }

  @override
  void dispose() {
    controller.cardHolderNameController.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _introHeader(),
              const SizedBox(height: 24),
              _cardPreview(),
              const SizedBox(height: 28),
              const SCSectionHeader(label: 'Card details'),
              _inputWidget(context),
              const SizedBox(height: 12),
              const SCSectionHeader(label: 'Currency & funding'),
              _walletWidget(context),
              const SizedBox(height: 16),
              const SCSectionHeader(label: 'Charges'),
              _chargeWidget(context),
            ],
          ),
        ),
        _footer(context),
      ],
    );
  }

  // ─── Intro headline ──────────────────────────────────────────────────
  Widget _introHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.createCard,
          style: AppTextStyles.h1.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 8),
        Text(
          Strings.cardHolder,
          style: AppTextStyles.body.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }

  // ─── Live preview hero ───────────────────────────────────────────────
  Widget _cardPreview() {
    final holder = controller.cardHolderNameController.text.trim();
    return Obx(() {
      final network =
          controller.selectCardTypeName.value.toLowerCase().contains('master')
          ? SCCardNetwork.mastercard
          : SCCardNetwork.visa;
      final currency = controller.supportedCurrencyCode.value.isEmpty
          ? controller.baseCurrency.value
          : controller.supportedCurrencyCode.value;
      final charge = controller.totalCharge.value;
      return SCVirtualCard(
        cardName: holder.isEmpty ? Strings.cardHolder : holder,
        last4: '••••',
        balance: '${charge.toStringAsFixed(2)} $currency',
        network: network,
        variant: SCCardVariant.midnight,
      );
    });
  }

  _walletWidget(BuildContext context) {
    return Column(
      children: [
        // card currency also support wallet are same
        Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: Dimensions.heightSize),
            child: CustomDropDown<SupportedCurrency>(
              dropDownHeight: Dimensions.inputBoxHeight * 0.75,
              items: controller.supportedCurrencyList,
              title: Strings.cardCurrency,
              hint: controller.supportedCurrencyCode.value,
              onChanged: (value) {
                controller.selectSupportedCurrency.value = value!;
                controller.supportedCurrencyCode.value = value.currencyCode
                    .toString();
                print(controller.fromCurrency.value);
              },
              dropDownColor: Get.isDarkMode
                  ? CustomColor.primaryBGDarkColor
                  : CustomColor.whiteColor,
              padding: EdgeInsets.only(
                left: Dimensions.paddingSize * 0.5,
                right: Dimensions.paddingSize * 0.4,
              ),
              titleTextColor: Get.isDarkMode
                  ? CustomColor.whiteColor
                  : CustomColor.blackColor,
              borderEnable: true,
              dropDownFieldColor: Colors.transparent,
              dropDownIconColor: CustomColor.blackColor,
            ),
          ),
        ),

        // from currency come to user wallet
        Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: Dimensions.heightSize),
            child: CustomDropDown<UserWallet>(
              dropDownColor: Get.isDarkMode
                  ? CustomColor.primaryBGDarkColor
                  : CustomColor.whiteColor,
              dropDownHeight: Dimensions.inputBoxHeight * 0.75,
              items: controller.walletsList,
              title: Strings.fromWallet,
              hint: controller.selectMainWallet.value!.title,
              onChanged: (value) {
                controller.selectMainWallet.value = value!;
                controller.fromCurrency.value = value.currency.code.toString();
                print(controller.fromCurrency.value);
              },
              padding: EdgeInsets.only(
                left: Dimensions.paddingSize * 0.5,
                right: Dimensions.paddingSize * 0.4,
              ),
              titleTextColor: Get.isDarkMode
                  ? CustomColor.whiteColor
                  : CustomColor.blackColor,
              borderEnable: true,
              dropDownFieldColor: Colors.transparent,
              dropDownIconColor: CustomColor.blackColor,
            ),
          ),
        ),
      ],
    );
  }

  _inputWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        PrimaryInputWidget(
          controller: controller.cardHolderNameController,
          hint: Strings.cardHolder,
          label: Strings.cardHolder,
        ),
        verticalSpace(Dimensions.heightSize),
        Obx(
          () => CustomDropDown<StringDropdownModel>(
            padding: EdgeInsets.only(
              left: Dimensions.paddingSize * 0.5,
              right: Dimensions.paddingSize * 0.4,
            ),
            titleTextColor: Get.isDarkMode
                ? CustomColor.whiteColor
                : CustomColor.blackColor,
            dropDownColor: Get.isDarkMode
                ? CustomColor.primaryBGDarkColor
                : CustomColor.whiteColor,
            dropDownHeight: Dimensions.inputBoxHeight * 0.75,
            title: Strings.cardTier,
            hint: controller.selectTierName.value,
            items: controller.cardTierList
                .map(
                  (e) =>
                      StringDropdownModel(title: e['name']!, slug: e['slug']!),
                )
                .toList(),
            onChanged: (value) {
              controller.selectTierName.value = value!.title;
              if (controller.selectTierName.value == "Universal") {
                controller.totalCharge.value = double.parse(
                  controller
                      .cardyfieCardModel
                      .data
                      .cardCharge
                      .universalCardIssuesFee
                      .toString(),
                );

                print(controller.totalCharge);
              } else {
                controller.totalCharge.value = double.parse(
                  controller
                      .cardyfieCardModel
                      .data
                      .cardCharge
                      .platinumCardIssuesFee
                      .toString(),
                );
              }

              controller.selectTierSlug.value = value.slug!;
            },
          ),
        ),
        verticalSpace(Dimensions.heightSize),
        Obx(
          () => CustomDropDown<StringDropdownModel>(
            padding: EdgeInsets.only(
              left: Dimensions.paddingSize * 0.5,
              right: Dimensions.paddingSize * 0.4,
            ),
            titleTextColor: Get.isDarkMode
                ? CustomColor.whiteColor
                : CustomColor.blackColor,
            dropDownColor: Get.isDarkMode
                ? CustomColor.primaryBGDarkColor
                : CustomColor.whiteColor,
            dropDownHeight: Dimensions.inputBoxHeight * 0.75,
            title: Strings.cardType,
            hint: controller.selectCardTypeName.value,
            items: controller.cardTypeList
                .map(
                  (e) =>
                      StringDropdownModel(title: e['name']!, slug: e['slug']!),
                )
                .toList(),
            onChanged: (value) {
              controller.selectCardTypeName.value = value!.title;
              controller.selectCardTypeSlug.value = value.slug!;
            },
          ),
        ),
      ],
    );
  }

  _chargeWidget(BuildContext context) {
    var userData = controller.cardyfieCardModel.data;
    return SCSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: mainSpaceBet,
              children: [
                Text(
                  Strings.totalCharge,
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
                Obx(
                  () => Text(
                    "${controller.totalCharge.value} ${userData.baseCurr}",
                    style: AppTextStyles.numMd.copyWith(color: AppColors.text),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, color: AppColors.line2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: mainSpaceBet,
              children: [
                Text(
                  Strings.totalPay,
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                ),
                Obx(
                  () => Text(
                    "${controller.totalCharge.value} ${userData.baseCurr}",
                    style: AppTextStyles.numLg.copyWith(color: AppColors.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sticky footer: confirm + update customer ────────────────────────
  Widget _footer(BuildContext context) {
    return _PinnedFooter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => SCPrimaryButton(
              label: Strings.confirm,
              icon: Icons.check_rounded,
              loading: controller.isBuyCardLoading,
              onPressed: () {
                controller.issueCardProcess(context);
              },
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => SCSecondaryButton(
              label: Strings.updateCustomer,
              loading: controller.isCustomerCreateLoading,
              onPressed: () {
                print(controller.listFieldName);
                print(controller.listImagePath);

                Get.toNamed(Routes.cardyfieUpdateCustomerScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}

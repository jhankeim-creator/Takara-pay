import 'package:flutter/services.dart';
import "package:TAKARA PAY/base/utils/language/language_controller.dart";

import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/error_state_widget.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";

// Static (not routed through Strings/.tr): the backend language dictionary
// doesn't carry this key. Matches update_customer_screen.dart's identical
// title literal for the same read-only screen.
const String _customerDetailsLabel = 'Customer Details';

class CrateStrowalletScreen extends StatefulWidget {
  const CrateStrowalletScreen({super.key});

  @override
  State<CrateStrowalletScreen> createState() => _CrateStrowalletScreenState();
}

class _CrateStrowalletScreenState extends State<CrateStrowalletScreen> {
  final controller = Get.put(VirtualStrowalletCardController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Drive the live card preview as the holder name / amount change.
    controller.cardHolderNameController.addListener(_rebuild);
    controller.fundAmountController.addListener(_rebuild);
  }

  @override
  void dispose() {
    controller.cardHolderNameController.removeListener(_rebuild);
    controller.fundAmountController.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: Get.back,
          ),
          title: Text(
            controller.appBarTitle.value,
            style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
          ),
        ),
        body: SafeArea(
          child:
              controller.isLoading ||
                  controller.isBuyCardLoading ||
                  controller.isCreateCardInfoLoading
              ? const CustomLoadingAPI()
              : controller.isCreateInfoLoaded
                  ? _bodyWidget(context)
                  : _errorState(),
        ),
      ),
    );
  }

  // Recoverable error instead of a red LateInitializationError crash when the
  // strowallet create-info API fails.
  Widget _errorState() {
    return ErrorStateWidget(
      title: Get.find<LanguageController>()
          .getTranslation(Strings.couldntLoadCardSetup),
      message: Get.find<LanguageController>()
          .getTranslation(Strings.checkConnectionAndRetryShort),
      retryLabel: Get.find<LanguageController>().getTranslation(Strings.retry),
      onRetry: controller.getStrowalletCardCreateInfo,
    );
  }

  Widget _bodyWidget(BuildContext context) {
    // A card-holder is REQUIRED before a card can be bought — the buy-card API
    // derives the country from it (without one it rejects with "selected
    // country is invalid"). This mirrors the web, which shows "A cardholder is
    // required before creating a card" when none exists. So: card-holder present
    // → Create Card form; otherwise → the card-holder form first.
    // `hasCardData`/`strowalletCustomerInfo` are reactive via the Obx in build().
    final hasCardHolder = controller.hasCardData &&
        controller.strowalletCardModel.data.strowalletCustomerInfo;
    if (hasCardHolder) {
      return _cardCreate(context);
    }
    return _customerUpdate(context);
  }

  // ─── BRANCH (a) — Customer create form ───────────────────────────────
  Widget _customerCreate(BuildContext context) {
    final visible =
        controller.strowalletCardModel.data.user.strowalletCustomer == "" ||
        controller.strowalletCardModel.data.user.strowalletCustomer == null;

    return Visibility(
      visible: visible,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    Get.find<LanguageController>().getTranslation(Strings.createCardCustomer),
                    style: AppTextStyles.h1.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Get.find<LanguageController>().getTranslation(Strings.statusOfTheCustomer),
                    style: AppTextStyles.body.copyWith(color: AppColors.text2),
                  ),
                  const SizedBox(height: 24),
                  SCSurfaceCard(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: crossStart,
                      children: [
                        // Field widgets are built BY THE CONTROLLER — render as-is.
                        ...controller.inputFields.map((element) => element),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _PinnedFooter(
              child: Obx(
                () => SCPrimaryButton(
                  label: Get.find<LanguageController>().getTranslation(Strings.submit),
                  loading: controller.isCustomerCreateLoading,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.customerCreateProcess().then((v) {
                        Get.offAllNamed(Routes.bottomNavBarScreen);
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── BRANCH (b) — Customer update (KYC) prompt ───────────────────────
  Widget _customerUpdate(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          Get.find<LanguageController>().getTranslation(Strings.createCard),
          style: AppTextStyles.h1.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 24),
        SCSurfaceCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: crossStart,
            children: [
              Text(
                Get.find<LanguageController>()
                    .getTranslation(Strings.cardHolderRequired),
                style: AppTextStyles.h2.copyWith(color: AppColors.text),
              ),
              const SizedBox(height: 8),
              Text(
                Get.find<LanguageController>()
                    .getTranslation(Strings.cardHolderRequiredMessage),
                style: AppTextStyles.body.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: 24),
              SCPrimaryButton(
                label: Get.find<LanguageController>()
                    .getTranslation(Strings.createCardHolder),
                icon: Icons.arrow_forward_rounded,
                onPressed: () async {
                  await Get.toNamed(Routes.updateCustomerKycScreen);
                  // Refresh both create-info and my-cards so the screen advances
                  // to the Create Card form once the card-holder is stored
                  // (the gate reads strowallet_customer_status from my-cards).
                  controller.getStrowalletCardCreateInfo();
                  controller.getStrowalletCardData();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── BRANCH (c) — Card creation ──────────────────────────────────────
  Widget _cardCreate(BuildContext context) {
    var baseCur = controller.dashboardController.dashBoardModel.data.baseCurr;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                Get.find<LanguageController>().getTranslation(Strings.createCard),
                style: AppTextStyles.h1.copyWith(color: AppColors.text),
              ),
              const SizedBox(height: 8),
              Builder(builder: (_) {
                final u = controller.strowalletCardModel.data.user;
                final holder = '${u.firstname} ${u.lastname}'.trim();
                return Text(
                  holder.isEmpty
                      ? Get.find<LanguageController>()
                          .getTranslation(Strings.cardHolderSName)
                      : '${Get.find<LanguageController>().getTranslation(Strings.cardHolder)}: $holder',
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                );
              }),
              const SizedBox(height: 24),
              _cardPreview(baseCur),
              const SizedBox(height: 24),
              _amountFields(context),
              _limitCard(baseCur: baseCur),
              const SizedBox(height: 16),
              _chargeWidget(context),
              const SizedBox(height: 16),
              // Separate, optional card-holder step (mirrors the web's
              // "Create Card Holder" button shown alongside card creation).
              // This branch only renders once a card-holder already exists
              // (see hasCardHolder above), so the card-holder form that
              // opens from here is always view-only ("Customer Details") —
              // editing an existing card-holder is no longer allowed.
              SCSecondaryButton(
                label: controller.strowalletCardModel.data.strowalletCustomerInfo
                    ? _customerDetailsLabel
                    : Get.find<LanguageController>()
                        .getTranslation(Strings.updateCustomer),
                icon: controller.strowalletCardModel.data.strowalletCustomerInfo
                    ? Icons.person_outline_rounded
                    : Icons.badge_outlined,
                onPressed: () async {
                  await Get.toNamed(Routes.updateCustomerKycScreen);
                  controller.getStrowalletCardCreateInfo();
                  controller.getStrowalletCardData();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        _PinnedFooter(
          child: Obx(
            () => SCPrimaryButton(
              label: Get.find<LanguageController>().getTranslation(Strings.confirm),
              icon: Icons.check_rounded,
              loading: controller.isBuyCardLoading,
              onPressed: () {
                controller.buyCardProcess(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  // Live preview hero — shows the existing card-holder's name + entered amount.
  Widget _cardPreview(String baseCur) {
    final u = controller.strowalletCardModel.data.user;
    final name = '${u.firstname} ${u.lastname}'.trim();
    final amount = controller.fundAmountController.text.trim();
    return SCVirtualCard(
      cardName: name.isEmpty ? Get.find<LanguageController>().getTranslation(Strings.cardHolder) : name,
      last4: '0000',
      balance: amount.isEmpty ? '0 $baseCur' : '$amount $baseCur',
      network: SCCardNetwork.visa,
      variant: SCCardVariant.midnight,
    );
  }

  Widget _amountFields(BuildContext context) {
    // The card-holder name already exists on the card-holder record and the
    // buy-card API only needs the amount (matching the web) — so there's no
    // "Card Holder's Name" input here anymore.
    return Column(
      children: [
        SCTextField(
          controller: controller.fundAmountController,
          label: Get.find<LanguageController>().getTranslation(Strings.amount),
          hint: Get.find<LanguageController>().getTranslation(Strings.zero00),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          suffixIcon: Text(
            controller.strowalletCardModel.data.baseCurr,
            style: AppTextStyles.numSm.copyWith(color: AppColors.text2),
          ),
          onChanged: (value) {
            controller.getStrowalletCardInfo();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Tier limits / fees as a clean card.
  Widget _limitCard({required String baseCur}) {
    final dash = controller.dashboardController;
    return SCSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Text(
            Get.find<LanguageController>().getTranslation(Strings.limitInformation).toUpperCase(),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 12),
          Obx(
            () => _limitRow(
              label: Get.find<LanguageController>().getTranslation(Strings.transferFee),
              value:
                  "${dash.fixedCharge.value} $baseCur + ${dash.percentCharge.value} %",
            ),
          ),
          const Divider(height: 20, thickness: 0.5, color: AppColors.line2),
          Obx(
            () => _limitRow(
              label: Get.find<LanguageController>().getTranslation(Strings.limit),
              value:
                  "${dash.limitMin.value} $baseCur - ${dash.limitMax.value} $baseCur",
            ),
          ),
        ],
      ),
    );
  }

  Widget _limitRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: mainSpaceBet,
      crossAxisAlignment: crossStart,
      children: [
        Text(
          label.tr,
          style: AppTextStyles.body.copyWith(color: AppColors.text2),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
          ),
        ),
      ],
    );
  }

  Widget _chargeWidget(BuildContext context) {
    var userData = controller.strowalletCardModel.data;
    return SCSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Row(
            mainAxisAlignment: mainSpaceBet,
            children: [
              Text(
                Get.find<LanguageController>().getTranslation(Strings.totalCharge),
                style: AppTextStyles.body.copyWith(color: AppColors.text2),
              ),
              Obx(
                () => Text(
                  "${controller.totalCharge.value.toStringAsFixed(2)} ${userData.baseCurr}",
                  style: AppTextStyles.numMd.copyWith(color: AppColors.text),
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.5, color: AppColors.line2),
          Row(
            mainAxisAlignment: mainSpaceBet,
            children: [
              Text(
                Get.find<LanguageController>().getTranslation(Strings.totalPay),
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
              ),
              Obx(
                () => Text(
                  "${controller.totalPay.value.toStringAsFixed(2)} ${userData.baseCurr}",
                  style: AppTextStyles.numLg.copyWith(color: AppColors.text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Pinned bottom CTA with a top hairline + safe-area inset so it stays
// visible when the keyboard opens. Mirrors the gold-standard footer.
class _PinnedFooter extends StatelessWidget {
  final Widget child;
  const _PinnedFooter({required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line2, width: 1)),
      ),
      child: child,
    );
  }
}

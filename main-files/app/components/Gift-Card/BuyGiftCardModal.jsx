"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { getRemainingLimits, submitGiftCardOrder } from "../../utils/api";
import { useTranslations } from "next-intl";

const BuyGiftCardModal = ({
  isOpen,
  onClose,
  purchaseDetails,
  card,
  apiData,
}) => {
  const [loading, setLoading] = useState(false);
  const [remainingDaily, setRemainingDaily] = useState(0);
  const [remainingMonthly, setRemainingMonthly] = useState(0);

  const router = useRouter();
  const t = useTranslations("BuyGiftCardModal");

  // ==========================================
  // EXTRACT DYNAMIC DATA FROM CARD
  // ==========================================
  const recipientCurrency = card?.currency || "N/A";

  // Wallet — first entry from userWallet array
  const userWallet = apiData?.userWallet?.[0] || {};
  const walletCurrency = userWallet.currency_code || "USD";
  const walletSymbol = userWallet.currency_symbol || "$";
  const walletBalance = Number(userWallet.balance) || 0;

  // Exchange rate — derived from recipientCurrencyRate and wallet rate
  // Formula: 1 recipientCurrency = (walletRate / recipientCurrencyRate) senderCurrency
  const recipientCurrencyRate =
    Number(apiData?.product?.recipientCurrencyRate) || 1;
  const walletRate = Number(userWallet.rate) || 1;
  const exchangeRate =
    recipientCurrencyRate > 0 ? walletRate / recipientCurrencyRate : walletRate;

  // Charges — from cardCharge
  const cardCharge = apiData?.cardCharge || {};
  const fixedFee = Number(cardCharge.fixed_charge) || 0;
  const percentFee = Number(cardCharge.percent_charge) || 0;
  const dailyLimit = Number(cardCharge.daily_limit) || 0;
  const monthlyLimit = Number(cardCharge.monthly_limit) || 0;

  // ==========================================
  // CALCULATIONS (ALL IN WALLET CURRENCY)
  // ==========================================
  const totalRecipientAmount =
    (purchaseDetails?.amount ?? 0) * (purchaseDetails?.quantity ?? 0);
  const convertedAmount = (totalRecipientAmount * exchangeRate).toFixed(4);
  const percentFeeAmount = (
    parseFloat(convertedAmount) *
    (percentFee / 100)
  ).toFixed(4);
  const totalFees = (
    parseFloat(fixedFee) + parseFloat(percentFeeAmount)
  ).toFixed(4);
  const totalPayable = (
    parseFloat(convertedAmount) + parseFloat(totalFees)
  ).toFixed(4);

  const hasSufficientBalance = parseFloat(totalPayable) <= walletBalance;

  // ==========================================
  // FETCH REMAINING LIMITS
  // ==========================================
  useEffect(() => {
    if (!isOpen || !apiData?.cardCharge?.id) {
      setRemainingDaily(dailyLimit);
      setRemainingMonthly(monthlyLimit);
      return;
    }

    const fetchRemainingLimits = async () => {
      const params = {
        transaction_type: "GIFT-CARD",
        attribute: "SEND",
        charge_id: apiData.cardCharge.id,
        sender_amount: totalPayable,
        currency_code: walletCurrency,
      };

      try {
        const response = await getRemainingLimits(params);
        const result = response?.data || response || {};
        setRemainingDaily(Number(result.remainingDaily) || 0);
        setRemainingMonthly(Number(result.remainingMonthly) || 0);
      } catch (error) {
        console.log("Failed to fetch remaining limits:", error);
        setRemainingDaily(dailyLimit);
        setRemainingMonthly(monthlyLimit);
      }
    };

    fetchRemainingLimits();
  }, [isOpen, apiData, totalPayable, walletCurrency, dailyLimit, monthlyLimit]);

  // ==========================================
  // ✅ SINGLE EARLY RETURN — after ALL hooks
  // ==========================================
  if (!isOpen) return null;

  // ==========================================
  // ORDER SUBMISSION HANDLER
  // ==========================================
  const handleConfirmOrder = async () => {
    setLoading(true);

    const selectedWalletCurrency =
      purchaseDetails.wallet?.split("(")?.[1]?.replace(")", "")?.trim() ||
      walletCurrency;

    const payload = {
      product_id: purchaseDetails.productId,
      amount: purchaseDetails.amount,
      quantity: purchaseDetails.quantity,
      receiver_email: purchaseDetails.receiverEmail,
      receiver_country: purchaseDetails.countryIso || "",
      receiver_phone_code:
        purchaseDetails.phone?.split(" ")?.[0]?.replace("+", "") || "",
      receiver_phone: purchaseDetails.phone?.replace(/^\+\d+\s*/, "") || "",
      from_name: purchaseDetails.fromName || "",
      wallet_currency: selectedWalletCurrency,
    };

    try {
      const response = await submitGiftCardOrder(payload);

      if (response?.message?.success) {
        toast.success(
          response.message.success[0] || t("toast.success"),
        );
        onClose();
        router.push("/dashboard/gift-card");
      } else {
        const errorMsg = response?.message?.error?.[0] || t("toast.orderFailed");
        toast.error(errorMsg);
        router.push("/dashboard/gift-card");
      }
    } catch (error) {
      const errorMsg =
        error.response?.data?.message?.error?.[0] ||
        error.message ||
        t("toast.failedToPlaceOrder");
      toast.error(errorMsg);
    } finally {
      setLoading(false);
    }
  };

  // ==========================================
  // RENDER MODAL
  // ==========================================
  return (
    <div className="fixed inset-0 bg-black/45 backdrop-blur-none flex items-center justify-center z-50 p-4">
      <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-2xl max-w-lg w-full p-6 relative max-h-screen overflow-y-auto border border-gray-200 dark:border-gray-700">
        {/* CLOSE BUTTON */}
        <button
          onClick={onClose}
          disabled={loading}
          className="absolute top-4 right-4 text-gray-400 dark:text-gray-500 hover:text-gray-600 dark:hover:text-gray-300 transition-colors disabled:opacity-50 cursor-pointer"
        >
          <svg
            className="w-6 h-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>

        {/* MODAL TITLE */}
        <h3 className="text-2xl font-bold text-gray-900 dark:text-gray-100 mb-6">
          {t("title")}
        </h3>

        {/* PURCHASE SUMMARY SECTION */}
        <div className="space-y-4 mb-6">
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("summary.productName")}
            </span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {purchaseDetails.productName}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("summary.receiverEmail")}
            </span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {purchaseDetails.receiverEmail || t("na")}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("summary.receiverCountry")}
            </span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {purchaseDetails.country || t("na")}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("summary.receiverPhone")}
            </span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {purchaseDetails.phone || t("na")}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">{t("summary.fromName")}</span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {purchaseDetails.fromName || t("na")}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("summary.unitPrice")}
            </span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {purchaseDetails.amount.toFixed(4)} {recipientCurrency}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">{t("summary.quantity")}</span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {purchaseDetails.quantity}
            </span>
          </div>
          <div className="flex justify-between text-lg font-bold border-t pt-3 border-gray-200 dark:border-gray-700">
            <span className="text-gray-800 dark:text-gray-200">
              {t("summary.totalPrice")}
            </span>
            <span className="text-blue-600 dark:text-blue-400">
              {totalRecipientAmount.toFixed(4)} {recipientCurrency}
            </span>
          </div>
        </div>

        {/* CONVERSION & FEES + LIMITS SECTION */}
        <div className="bg-gray-50 dark:bg-gray-800/50 rounded-xl p-4 space-y-3 mb-6 border border-gray-200 dark:border-gray-700">
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("feesAndLimits.exchangeRate")}
            </span>
            <span className="font-medium text-gray-900 dark:text-gray-100">
              1 {recipientCurrency} = {exchangeRate.toFixed(4)} {walletCurrency}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("feesAndLimits.conversionAmount")}
            </span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {walletSymbol}
              {convertedAmount} {walletCurrency}
            </span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-300">
              {t("feesAndLimits.totalFees")}
            </span>
            <span className="font-semibold text-gray-900 dark:text-gray-100">
              {walletSymbol}
              {fixedFee.toFixed(4)} + {percentFee.toFixed(4)}% = {walletSymbol}
              {totalFees} {walletCurrency}
            </span>
          </div>

          {/* LIMITS SUBSECTION */}
          <div className="border-t pt-3 space-y-2 text-sm border-gray-200 dark:border-gray-700">
            <div className="flex justify-between">
              <span className="text-gray-600 dark:text-gray-300">
                {t("feesAndLimits.dailyLimit")}
              </span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {walletSymbol}
                {dailyLimit.toFixed(4)} {walletCurrency}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600 dark:text-gray-300">
                {t("feesAndLimits.remainingDailyLimit")}
              </span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {walletSymbol}
                {remainingDaily.toFixed(4)} {walletCurrency}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600 dark:text-gray-300">
                {t("feesAndLimits.monthlyLimit")}
              </span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {walletSymbol}
                {monthlyLimit.toFixed(4)} {walletCurrency}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600 dark:text-gray-300">
                {t("feesAndLimits.remainingMonthlyLimit")}
              </span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {walletSymbol}
                {remainingMonthly.toFixed(4)} {walletCurrency}
              </span>
            </div>
          </div>

          {/* TOTAL PAYABLE */}
          <div className="flex justify-between text-lg font-bold pt-3 border-t border-gray-200 dark:border-gray-700">
            <span className="text-gray-800 dark:text-gray-200">
              {t("feesAndLimits.totalPayableAmount")}
            </span>
            <span className="text-blue-600 dark:text-blue-400">
              {walletSymbol}
              {totalPayable} {walletCurrency}
            </span>
          </div>
        </div>

        {/* ACTION BUTTONS */}
        <div className="flex gap-3">
          <button
            onClick={onClose}
            disabled={loading}
            className="flex-1 px-4 py-3 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 font-semibold rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors disabled:opacity-50 cursor-pointer"
          >
            {t("buttons.cancel")}
          </button>
          <button
            onClick={handleConfirmOrder}
            disabled={loading || !hasSufficientBalance}
            className={`cursor-pointer flex-1 px-4 py-3 text-white font-semibold rounded-lg transition-all shadow-md hover:shadow-lg ${
              loading || !hasSufficientBalance
                ? "bg-gray-400 cursor-not-allowed"
                : "bg-gradient-to-r from-blue-600 to-blue-700 dark:from-blue-700 dark:to-blue-800 hover:from-blue-700 hover:to-blue-800 dark:hover:from-blue-800 dark:hover:to-blue-900"
            }`}
          >
            {loading ? (
              <span className="flex items-center justify-center gap-2">
                <svg
                  className="animate-spin h-5 w-5 text-white"
                  viewBox="0 0 24 24"
                >
                  <circle
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    strokeWidth="4"
                    fill="none"
                  />
                </svg>
                {t("buttons.processing")}
              </span>
            ) : !hasSufficientBalance ? (
              t("buttons.insufficientBalance")
            ) : (
              t("buttons.confirm")
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default BuyGiftCardModal;
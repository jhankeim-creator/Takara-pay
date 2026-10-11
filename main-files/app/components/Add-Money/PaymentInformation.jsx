import toast from "react-hot-toast";
import { useTranslations } from "next-intl"; // ← adjust to your i18n import if different

export default function PaymentInformation({
  paymentInformations,
  gatewayCurrencyName = "Manual Gateway",
  trx = "—",
  className = "",
}) {
  const t = useTranslations("paymentInformation"); // ← namespace: "paymentInformation"

  if (!paymentInformations || Object.keys(paymentInformations).length === 0) {
    return (
      <div
        className={`bg-gray-50 dark:bg-gray-800/60 p-5 rounded-xl border border-gray-200 dark:border-gray-700 ${className}`}
      >
        <p className="text-gray-500 dark:text-gray-300 text-center">
          {t("empty")}
        </p>
      </div>
    );
  }

  const {
    request_amount = "—",
    exchange_rate = "—",
    total_charge = "—",
    payable_amount = "—",
    will_get = "—",
  } = paymentInformations;

  // ────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────
  const formatAmount = (value, decimals = 4) => {
    if (!value) return "—";
    const num = parseFloat(String(value).replace(/[^0-9.]/g, ""));
    if (isNaN(num)) return "—";
    return num.toFixed(decimals);
  };

  const extractCurrency = (value) => {
    const match = String(value).match(/[A-Z]{3}/);
    return match ? match[0] : "";
  };

  // ────────────────────────────────────────────────
  // Conversion calculation
  // ────────────────────────────────────────────────
  let conversionAmount = "—";
  let conversionCurrency = "—";

  try {
    const requestValue = parseFloat(
      String(request_amount).replace(/[^0-9.]/g, ""),
    );

    let rate = 1;

    if (exchange_rate && exchange_rate.includes("=")) {
      const rightSide = exchange_rate.split("=")[1]?.trim();
      if (rightSide) {
        const rateValue = parseFloat(rightSide);
        if (!isNaN(rateValue)) rate = rateValue;

        const currencyMatch = rightSide.match(/[A-Z]{3}/);
        if (currencyMatch) conversionCurrency = currencyMatch[0];
      }
    }

    if (!isNaN(requestValue)) {
      conversionAmount = (requestValue * rate).toFixed(4);
    }
  } catch (error) {
    toast.error(t("errors.conversionFailed"));
  }

  // ────────────────────────────────────────────────
  // UI
  // ────────────────────────────────────────────────
  return (
  <div
    className={`bg-gray-50 dark:bg-gray-800/60 p-6 rounded-2xl border border-gray-200 dark:border-gray-700 shadow-sm ${className}`}
  >
    <h3 className="text-xl md:text-2xl font-semibold text-center text-gray-800 dark:text-gray-100 mb-5 border-b border-gray-200 dark:border-gray-700 pb-3">
      {t("title")}
    </h3>

    <div className="space-y-4 text-sm">
      <div className="flex justify-between">
        <span className="text-gray-600 dark:text-gray-300">
          {t("rows.enteredAmount")}
        </span>
        <span className="font-medium text-gray-900 dark:text-gray-100">
          {formatAmount(request_amount)} {extractCurrency(request_amount)}
        </span>
      </div>

      <div className="flex justify-between">
        <span className="text-gray-600 dark:text-gray-300">
          {t("rows.exchangeRate")}
        </span>
        <span className="font-medium text-gray-900 dark:text-gray-100">
          {exchange_rate}
        </span>
      </div>

      <div className="flex justify-between">
        <span className="text-gray-600 dark:text-gray-300">
          {t("rows.feesCharges")}
        </span>
        <span className="font-medium text-gray-900 dark:text-gray-100">
          {formatAmount(total_charge)} {extractCurrency(total_charge)}
        </span>
      </div>

      <div className="flex justify-between">
        <span className="text-gray-700 dark:text-gray-200 font-medium">
          {t("rows.conversionAmount")}
        </span>
        <span className="font-medium text-gray-900 dark:text-gray-100">
          {conversionAmount} {conversionCurrency}
        </span>
      </div>

      <div className="flex justify-between">
        <span className="text-gray-700 dark:text-gray-200 font-medium">
          {t("rows.willGet")}
        </span>
        <span className=" text-gray-900 dark:text-gray-100">
          {formatAmount(will_get)} {extractCurrency(will_get)}
        </span>
      </div>

      <div className="flex justify-between pt-3 border-t border-gray-200 dark:border-gray-700">
        <span className="text-gray-700 dark:text-gray-200 font-medium">
          {t("rows.totalPayable")}
        </span>
        <span className=" text-gray-700 dark:text-gray-100">
          {formatAmount(payable_amount)} {extractCurrency(payable_amount)}
        </span>
      </div>
    </div>
  </div>
);
}
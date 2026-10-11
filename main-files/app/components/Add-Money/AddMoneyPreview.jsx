"use client";

import { useTranslations } from "next-intl";

const AddMoneyPreview = ({
  amount = "",
  walletCurrency = "",
  selectedGateway = null,
  fixedCharge = 0,
  percentCharge = 0,
  chargeCurrency = "",
  rate = 1,
}) => {
  const t = useTranslations("addMoneyPreview");

  const enteredAmount = Number(amount) || 0;

  // Exchange rate
  const exchangeRate = Number(rate) || 0;

  // 🔹 Detect loading state
  const isLoading =
    !walletCurrency || !chargeCurrency || !selectedGateway || !exchangeRate;

  // Step 1: Convert entered amount to gateway currency
  const convertedAmount = enteredAmount * exchangeRate;

  // Step 2: Fees
  const percentFee = convertedAmount * (percentCharge / 100);
  const totalFee = fixedCharge + percentFee;

  // Step 3: Total payable
  const totalPayable = convertedAmount + totalFee;

  // Will get
  const willGet = enteredAmount;

  // 🔹 Helper for display
  const show = (value, currency) =>
    isLoading ? (
      <span className="animate-pulse text-gray-400 dark:text-gray-500">--</span>
    ) : (
      `${value.toFixed(4)} ${currency}`
    );

  return (
    <div className="w-full rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
      <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 backdrop-blur px-6 py-5">
        <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-100 text-center tracking-tight">
          {t("title")}
        </h2>
      </div>

      <div className="p-6 space-y-4 min-h-[400px] flex flex-col">
        {/* Enter Amount */}
        <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
          <span className="text-sm text-gray-600 dark:text-gray-300">
            {t("rows.enterAmount")}
          </span>

          <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
            {isLoading ? (
              <span className="animate-pulse text-gray-400 dark:text-gray-500">
                --
              </span>
            ) : (
              `${enteredAmount.toFixed(4)} ${walletCurrency}`
            )}
          </span>
        </div>

        {/* Exchange Rate */}
        <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
          <span className="text-sm text-gray-600 dark:text-gray-300">
            {t("rows.exchangeRate")}
          </span>

          <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
            {isLoading ? (
              <span className="animate-pulse text-gray-400 dark:text-gray-500">
                --
              </span>
            ) : (
              `1 ${walletCurrency} = ${exchangeRate.toFixed(4)} ${chargeCurrency}`
            )}
          </span>
        </div>

        {/* Fees */}
        <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
          <span className="text-sm text-gray-600 dark:text-gray-300">
            {t("rows.feesCharges")}
          </span>

          <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
            {show(totalFee, chargeCurrency)}
          </span>
        </div>

        {/* Conversion Amount */}
        <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
          <span className="text-sm text-gray-600 dark:text-gray-300">
            {t("rows.conversionAmount")}
          </span>

          <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
            {show(convertedAmount, chargeCurrency)}
          </span>
        </div>

        <div className="flex-1" />

        {/* Will Get */}
        <div className="flex items-center justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
          <span className="text-sm text-gray-600 dark:text-gray-300">
            {t("rows.willGet")}
          </span>

          <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
            {isLoading ? (
              <span className="animate-pulse text-gray-400 dark:text-gray-500">
                --
              </span>
            ) : (
              `${willGet.toFixed(4)} ${walletCurrency}`
            )}
          </span>
        </div>

        {/* Total Payable (emphasized) */}
        <div className="flex items-center justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
          <span className="text-sm text-gray-600 dark:text-gray-300">
            {t("rows.totalPayable")}
          </span>

          <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
            {show(totalPayable, chargeCurrency)}
          </span>
        </div>
      </div>
    </div>
  );
};

export default AddMoneyPreview;

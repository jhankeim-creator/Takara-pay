"use client";

import { useTranslations } from "next-intl"; 

const TransferMoneyPreview = ({
  amount,
  fixedCharge,
  percentCharge,
  currency,
}) => {
  const t = useTranslations("transferMoneyPreview"); 

  // =======================
  // SAFE NUMBERS
  // =======================
  const numericAmount = Number(amount);
  const safeAmount = Number.isFinite(numericAmount) ? numericAmount : 0;

  const safeFixed = Number(fixedCharge) || 0;
  const safePercent = Number(percentCharge) || 0;

  // =======================
  // READY STATE
  // =======================
  const isReady =
    typeof currency === "string" && currency.trim() !== "" && currency !== "--";

  // =======================
  // CALCULATIONS
  // =======================
  const hasAmount = safeAmount > 0;

  const fee = hasAmount ? safeAmount * (safePercent / 100) + safeFixed : 0;

  const payable = hasAmount ? safeAmount + fee : 0;

  // =======================
  // FORMATTER
  // =======================
  const format = (value) =>
    isReady ? `${value.toFixed(4)} ${currency}` : "--";

  // =======================
  // ROWS
  // =======================
  const rows = [
    {
      label: t("rows.enterAmount"),
      value: format(safeAmount),
    },
    {
      label: t("rows.transferFee"),
      value: format(fee),
    },
    {
      label: t("rows.recipientReceived"),
      value: format(safeAmount),
    },
    {
      label: t("rows.totalPayable"),
      value: format(payable),
    },
  ];

  return (
    <div className="w-full rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
      {/* Form Header */}
        <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 backdrop-blur px-6 py-5">
          <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-100 text-center tracking-tight">
            {t("title")}
          </h2>
        </div>

      {/* Body */}
      <div className="p-6">
        <div className="space-y-7">
          {rows.map((item, index) => (
            <div
              key={index}
              className="flex items-center justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3"
            >
              <span className="text-sm text-gray-600 dark:text-gray-200">{item.label}</span>
              <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
                {item.value}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default TransferMoneyPreview;
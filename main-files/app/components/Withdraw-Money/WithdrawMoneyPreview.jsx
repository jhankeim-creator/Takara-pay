"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { getWithdrawInfo } from "../../utils/api";

const WithdrawMoneyPreview = ({ amount = 0 }) => {
  const t = useTranslations("withdrawMoneyPreview");

  // ============================================================================
  // STATE MANAGEMENT
  // ============================================================================
  const [withdrawData, setWithdrawData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // ============================================================================
  // DATA FETCHING
  // ============================================================================
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await getWithdrawInfo();

        if (response?.data) {
          setWithdrawData(response.data);
        } else if (response?.message?.error) {
          setError(response.message.error[0] || t("errors.loadDataFailed"));
        }
      } catch (err) {
        setError(t("errors.loadGeneric"));
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // ============================================================================
  // ERROR HANDLING
  // ============================================================================
  if (error) {
    return (
      <div className="w-full max-w-3xl rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm p-6 min-h-[400px] flex items-center justify-center">
        <p className="text-red-600 dark:text-red-400">{error}</p>
      </div>
    );
  }

  // ============================================================================
  // DATA EXTRACTION
  // ============================================================================
  const inputAmount = Number(amount) || 0;
  const gatewayCurrency = withdrawData?.gateways?.[0]?.currencies?.[0];
  const baseCurr = withdrawData?.base_curr || "USD";
  const gatewayCurr = gatewayCurrency?.currency_code || "USD";
  const rate = gatewayCurrency?.rate || 1;
  const fixedCharge = gatewayCurrency?.fixed_charge || 0;
  const percentCharge = gatewayCurrency?.percent_charge || 0;

  // ============================================================================
  // CALCULATIONS
  // ============================================================================
  const fixedChargeInBase = fixedCharge / rate;
  const chargePercentageInBase = (inputAmount * percentCharge) / 100;

  const totalFeesInBase = fixedChargeInBase + chargePercentageInBase;
  const payableAmountInBase = inputAmount + totalFeesInBase;
  const willGetAmountInGateway = inputAmount * rate;

  const exchangeRateText = `1 ${baseCurr} = ${rate.toFixed(4)} ${gatewayCurr}`;

  // ============================================================================
  // LOADING STATE CHECK
  // ============================================================================
  const isLoading = loading || !withdrawData;

  // ============================================================================
  // RENDER
  // ============================================================================
  return (
    <div className="w-full rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
      {/* Form Header */}
        <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 backdrop-blur px-6 py-5">
          <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-100 text-center tracking-tight">
            {t("title")}
          </h2>
        </div>

      {/* Body */}
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
        `${inputAmount.toFixed(4)} ${baseCurr}`
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
        exchangeRateText
      )}
    </span>
  </div>

  {/* Fees & Charges */}
  <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
    <span className="text-sm text-gray-600 dark:text-gray-300">
      {t("rows.feesCharges")}
    </span>
    <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
      {isLoading ? (
        <span className="animate-pulse text-gray-400 dark:text-gray-500">
          --
        </span>
      ) : (
        `${totalFeesInBase.toFixed(4)} ${baseCurr}`
      )}
    </span>
  </div>

  {/* Conversion Amount */}
  <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
    <span className="text-sm text-gray-600 dark:text-gray-300">
      {t("rows.conversionAmount")}
    </span>
    <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
      {isLoading ? (
        <span className="animate-pulse text-gray-400 dark:text-gray-500">
          --
        </span>
      ) : (
        `${willGetAmountInGateway.toFixed(4)} ${gatewayCurr}`
      )}
    </span>
  </div>

  {/* Spacer */}
  <div className="flex-1" />

  {/* Will Get */}
  <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
    <span className="text-sm text-gray-600 dark:text-gray-300">
      {t("rows.willGet")}
    </span>
    <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
      {isLoading ? (
        <span className="animate-pulse text-gray-400 dark:text-gray-500">
          --
        </span>
      ) : (
        `${willGetAmountInGateway.toFixed(4)} ${gatewayCurr}`
      )}
    </span>
  </div>

  {/* Total Payable */}
  <div className="flex justify-between rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3">
    <span className="text-sm text-gray-600 dark:text-gray-300">
      {t("rows.totalPayable")}
    </span>
    <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
      {isLoading ? (
        <span className="animate-pulse text-gray-400 dark:text-gray-500">
          --
        </span>
      ) : (
        `${payableAmountInBase.toFixed(4)} ${baseCurr}`
      )}
    </span>
  </div>
</div>
    </div>
  );
};

export default WithdrawMoneyPreview;

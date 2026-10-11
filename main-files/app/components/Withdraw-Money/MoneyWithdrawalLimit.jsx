"use client";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl"; // ← adjust to your i18n import if different
import { getRemainingLimits, getWithdrawInfo } from "../../utils/api";

const MoneyWithdrawalLimit = () => {
  const t = useTranslations("moneyWithdrawalLimit"); // ← namespace: "moneyWithdrawalLimit"

  const [limitInfo, setLimitInfo] = useState(null);
  const [currency, setCurrency] = useState("");
  const [remainingDaily, setRemainingDaily] = useState(null);
  const [remainingMonthly, setRemainingMonthly] = useState(null);
  const [dailyLimit, setDailyLimit] = useState(null);
  const [monthlyLimit, setMonthlyLimit] = useState(null);
  const [minLimit, setMinLimit] = useState(null);
  const [maxLimit, setMaxLimit] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchAll = async () => {
      setLoading(true);
      try {
        // Get base withdraw info (limits, currency, fields)
        const withdrawRes = await getWithdrawInfo();
        if (!withdrawRes?.data?.gateways?.[0]?.currencies?.[0]) {
          return null;
        }

        const currencyData = withdrawRes.data.gateways[0].currencies[0];
        setLimitInfo(currencyData);
        setCurrency(
          withdrawRes.data.base_curr || currencyData.currency_code || "USD",
        );

        // Get current remaining (use sender_amount=0)
        const fields = withdrawRes.data.get_remaining_fields || {};

        const params = {
          transaction_type: fields.transaction_type || "WITHDRAW-MONEY",
          attribute: fields.attribute || "SEND",
          currency_code: withdrawRes.data.base_curr || "",
          charge_id: String(currencyData.id || ""),
          sender_amount: "0", // Always 0 for current remaining
        };

        const remainingRes = await getRemainingLimits(params);

        if (remainingRes?.data?.status === true) {
          setRemainingDaily(remainingRes.data.remainingDaily ?? null);
          setRemainingMonthly(remainingRes.data.remainingMonthly ?? null);
          setDailyLimit(remainingRes.data.dailyLimit ?? null);
          setMonthlyLimit(remainingRes.data.monthlyLimit ?? null);
          setMinLimit(remainingRes.data.minLimit ?? null);
          setMaxLimit(remainingRes.data.maxLimit ?? null);
        } else {
          toast.error(
            t("errors.unavailable"),
            remainingRes,
          );
        }
      } catch (err) {
        toast.error(t("errors.unavailable"));
      } finally {
        setLoading(false);
      }
    };

    fetchAll();
  }, []); // only once on mount (remaining doesn't depend on form amount anymore)

  const rate = Number(limitInfo?.rate) || 1;

  // Always prefer the precise values returned by getRemainingLimits.
  // If those are null, use remainingDaily/remainingMonthly as proxies for
  // dailyLimit/monthlyLimit (they are equal when sender_amount = 0).
  // Only fall back to local division as a last resort (may be slightly imprecise
  // due to the rate being returned with only 4 decimal places).
  const displayMin = minLimit !== null
    ? Number(minLimit)
    : Number(limitInfo?.min_limit || 0) / rate;

  const displayMax = maxLimit !== null
    ? Number(maxLimit)
    : Number(limitInfo?.max_limit || 0) / rate;

  const displayDaily = dailyLimit !== null
    ? Number(dailyLimit)
    : remainingDaily !== null
      ? Number(remainingDaily)
      : Number(limitInfo?.daily_limit || 0) / rate;

  const displayMonthly = monthlyLimit !== null
    ? Number(monthlyLimit)
    : remainingMonthly !== null
      ? Number(remainingMonthly)
      : Number(limitInfo?.monthly_limit || 0) / rate;

  const data = [
    {
      label: t("rows.transactionLimit"),
      value: limitInfo
        ? `${displayMin.toFixed(4)} ${currency} – ${displayMax.toFixed(4)} ${currency}`
        : "--",
    },
    {
      label: t("rows.dailyLimit"),
      value: limitInfo
        ? `${displayDaily.toFixed(4)} ${currency}`
        : "--",
    },
    {
      label: t("rows.remainingDaily"),
      value: loading
        ? "--"
        : remainingDaily !== null
          ? `${Number(remainingDaily).toFixed(4)} ${currency}`
          : "--",
    },
    {
      label: t("rows.monthlyLimit"),
      value: limitInfo
        ? `${displayMonthly.toFixed(4)} ${currency}`
        : "--",
    },
    {
      label: t("rows.remainingMonthly"),
      value: loading
        ? "--"
        : remainingMonthly !== null
          ? `${Number(remainingMonthly).toFixed(4)} ${currency}`
          : "--",
    },
  ];

  return (
    <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
      {/* Form Header */}
        <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 backdrop-blur px-6 py-5">
          <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-100 text-center tracking-tight">
            {t("title")}
          </h2>
        </div>

      {/* Content */}
      <div className="p-6 space-y-4">
        {data.map((item, index) => (
          <div key={index} className="flex items-start justify-between gap-4">
            <span className="text-sm text-gray-500 dark:text-gray-200">
              {item.label}
            </span>
            <span className="text-sm font-medium text-right text-gray-800 dark:text-gray-200">
              {item.value}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default MoneyWithdrawalLimit;
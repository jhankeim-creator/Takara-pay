"use client";

import { useEffect, useMemo, useState } from "react";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl"; 
import { getAddMoneyInformation, getRemainingLimits } from "../../utils/api";

const LimitInformation = ({ selectedGateway = null, walletCurrency }) => {
  const t = useTranslations("limitInformation"); // ← namespace: "limitInformation"

  const [remainingDaily, setRemainingDaily] = useState(null);
  const [remainingMonthly, setRemainingMonthly] = useState(null);
  const [loadingRemaining, setLoadingRemaining] = useState(false);
  const [error, setError] = useState(null);

  
  const [remainingFields, setRemainingFields] = useState(null);

  useEffect(() => {
    // Load once
    const loadFields = async () => {
      try {
        const res = await getAddMoneyInformation();
        const fields = res?.data?.get_remaining_fields;
        if (fields?.transaction_type && fields?.attribute) {
          setRemainingFields(fields);
        }
      } catch (e) {
        console.warn("Could not load remaining fields", e);
      }
    };
    loadFields();
  }, []);

  // Base limits (adjusted by rate → shown in wallet currency)
  const isLoadingBase = !selectedGateway || !selectedGateway.rate;

  const { minLimit, maxLimit, dailyLimit, monthlyLimit } = useMemo(() => {
    if (isLoadingBase) {
      return {
        minLimit: "--",
        maxLimit: "--",
        dailyLimit: "--",
        monthlyLimit: "--",
      };
    }
    const rate = Number(selectedGateway.rate) || 1;
    return {
      minLimit: (Number(selectedGateway.min_limit || 0) / rate).toFixed(4),
      maxLimit: (Number(selectedGateway.max_limit || 0) / rate).toFixed(4),
      dailyLimit: (Number(selectedGateway.daily_limit || 0) / rate).toFixed(4),
      monthlyLimit: (Number(selectedGateway.monthly_limit || 0) / rate).toFixed(
        4,
      ),
    };
  }, [selectedGateway, isLoadingBase]);

  // Fetch remaining
  useEffect(() => {
    if (!selectedGateway?.id) {
      setRemainingDaily(null);
      setRemainingMonthly(null);
      setError(null);
      return;
    }

    const fetchRemaining = async () => {
      setLoadingRemaining(true);
      setError(null);

      try {
        const fields = remainingFields || {
          transaction_type: "ADD-MONEY",
          attribute: "SEND",
        };

        const params = {
          transaction_type: fields.transaction_type,
          attribute: fields.attribute,
          currency_code: walletCurrency || selectedGateway.currency_code,
          charge_id: String(selectedGateway.id),
          sender_amount: "0",
        };

        const res = await getRemainingLimits(params);

        if (res?.data?.status === true) {
          setRemainingDaily(res.data.remainingDaily ?? null);
          setRemainingMonthly(res.data.remainingMonthly ?? null);
        } else {
          toast.error(
            res?.message?.error?.[0] || t("errors.loadRemainingFailed"),
          );
        }
      } catch (err) {
        // console.error("[AddMoney Limits] Error:", err);
        setError(err.message || t("errors.loadRemainingFailed"));
        setRemainingDaily(null);
        setRemainingMonthly(null);
      } finally {
        setLoadingRemaining(false);
      }
    };

    fetchRemaining();
  }, [selectedGateway?.id, walletCurrency, remainingFields]);

  const formatValue = (val) =>
    val !== null && !isNaN(val)
      ? Number(val).toFixed(4) + " " + walletCurrency
      : "--";

  const show = (value, fallback = "--") =>
    loadingRemaining
      ? "--"
      : error
        ? t("errors.errorShort")
        : value !== null
          ? formatValue(value)
          : fallback;

  const limits = [
    {
      label: t("rows.transactionLimit"),
      value: isLoadingBase
        ? "--"
        : `${minLimit} ${walletCurrency} – ${maxLimit} ${walletCurrency}`,
    },
    {
      label: t("rows.dailyLimit"),
      value: show(dailyLimit),
    },
    {
      label: t("rows.remainingDaily"),
      value: show(remainingDaily, "--"),
      highlight: "info",
    },
    {
      label: t("rows.monthlyLimit"),
      value: show(monthlyLimit),
    },
    {
      label: t("rows.remainingMonthly"),
      value: show(remainingMonthly, "--"),
      highlight: "success",
    },
  ];

  return (
  <div>
    <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
      <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 backdrop-blur px-6 py-5">
          <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-100 text-center tracking-tight">
            {t("title")}
          </h2>
        </div>

      <div className="p-6 space-y-4">
        {limits.map((item, index) => (
          <div key={index} className="flex items-start justify-between gap-4">
            <span className="text-sm text-gray-500 dark:text-gray-300">
              {item.label}
            </span>
            <span
              className={`text-sm font-medium text-right ${
                item.highlight === "success"
                  ? "text-gray-700 dark:text-gray-100"
                  : item.highlight === "info"
                  ? "text-gray-700 dark:text-gray-100"
                  : error
                  ? "text-red-600 dark:text-red-400"
                  : "text-gray-800 dark:text-gray-200"
              }`}
            >
              {item.value}
            </span>
          </div>
        ))}
      </div>
    </div>
  </div>
);
};

export default LimitInformation;
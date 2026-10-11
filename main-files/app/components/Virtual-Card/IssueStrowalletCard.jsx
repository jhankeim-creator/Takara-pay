"use client";

import { useRouter } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import toast from "react-hot-toast";
import Select from "react-select";
import {
  createStrowalletCard,
  getRemainingLimits,
  getStrowalletCharges,
  getStrowalletCards,
} from "../../utils/api";
import Loader from "../Loader";

/* ── Backend contract: POST /user/strowallet-card/create ────────────────────
   card_amount     required|numeric|gt:0
   currency        required|string
   from_currency   required|string
   brand           required|string|in:MasterCard,Visa
─────────────────────────────────────────────────────────────────────────── */

// Values must match backend: MasterCard, Visa.
const CARD_BRANDS = [
  { value: "MasterCard", label: "MasterCard" },
  { value: "Visa", label: "Visa" },
];

const IssueStrowalletCard = () => {
  const router = useRouter();

  const [cardsData, setCardsData] = useState(null);
  // Virtual Card Charges — data.cardCharge from /user/strowallet-card/charges
  const [chargeInfo, setChargeInfo] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  const [amount, setAmount] = useState("");
  const [selectedCurrency, setSelectedCurrency] = useState(null);
  const [selectedWallet, setSelectedWallet] = useState(null);
  // The brand picker was removed from the UI, but the endpoint still requires
  // `brand` — keep sending the previous default so card creation succeeds.
  const selectedBrand = CARD_BRANDS[0];

  const [remainingDaily, setRemainingDaily] = useState(null);
  const [remainingMonthly, setRemainingMonthly] = useState(null);

  const [isDark, setIsDark] = useState(false);

  /* Fetch charges / currencies / wallets */
  useEffect(() => {
    let mounted = true;

    const fetchData = async () => {
      try {
        const [res, chargesRes] = await Promise.all([
          getStrowalletCards(),
          getStrowalletCharges(),
        ]);
        if (!mounted) return;

        if (res?.message?.error) {
          setError(res.message.error[0] || "Failed to load card information");
          return;
        }
        if (!res?.data) return;

        const data = res.data;
        setCardsData(data);
        setChargeInfo(chargesRes?.data?.cardCharge || null);

        const defaultCurrency = data.supported_currency?.find(
          (c) => c.currency_code === data.base_curr,
        );
        if (defaultCurrency) {
          setSelectedCurrency({
            value: defaultCurrency.currency_code,
            label: defaultCurrency.currency_code,
            rate: defaultCurrency.rate,
            symbol: defaultCurrency.currency_symbol,
          });
        }

        if (data.userWallet?.length > 0) {
          const w = data.userWallet[0];
          setSelectedWallet({
            value: w.currency.code,
            label: `${w.currency.name} ( ${w.balance.toFixed(4)} ${w.currency.code} )`,
            balance: w.balance,
            code: w.currency.code,
          });
        }
      } catch (err) {
        setError("Something went wrong. Please try again later.");
        toast.error("Something went wrong. Please try again later");
      } finally {
        if (mounted) setLoading(false);
      }
    };

    fetchData();
    return () => {
      mounted = false;
    };
  }, []);

  /* Fetch remaining limits (base currency) — against this page's charge */
  useEffect(() => {
    const activeCharge = chargeInfo || cardsData?.cardCharge;
    if (!activeCharge?.id || !cardsData) return;

    let mounted = true;
    const fetchRemaining = async () => {
      const fields = cardsData.get_remaining_fields || {};
      const params = {
        transaction_type: fields.transaction_type || "VIRTUAL-CARD",
        attribute: fields.attribute || "RECEIVED",
        charge_id: activeCharge.id,
        sender_amount: 0,
        currency_code: cardsData.base_curr,
      };

      try {
        const res = await getRemainingLimits(params);
        if (!mounted) return;
        const result = res?.data || res || {};
        setRemainingDaily(Number(result.remainingDaily) || 0);
        setRemainingMonthly(Number(result.remainingMonthly) || 0);
      } catch (err) {
        if (!mounted) return;
        setRemainingDaily(activeCharge.daily_limit);
        setRemainingMonthly(activeCharge.monthly_limit);
      }
    };

    fetchRemaining();
    return () => {
      mounted = false;
    };
  }, [cardsData, chargeInfo]);

  /* react-select is styled inline, so it needs to know the active theme */
  useEffect(() => {
    const root = document.documentElement;
    const read = () => setIsDark(root.classList.contains("dark"));
    read();

    const observer = new MutationObserver(read);
    observer.observe(root, { attributes: true, attributeFilter: ["class"] });
    return () => observer.disconnect();
  }, []);

  /* react-select styles (app indigo theme, light + dark) */
  const selectStyles = useMemo(
    () => ({
      control: (base, state) => ({
        ...base,
        background: isDark ? "#374151" : "#ffffff",
        minHeight: "48px",
        borderColor: state.isFocused
          ? "#6366f1"
          : isDark
            ? "#4b5563"
            : "#d1d5db",
        borderWidth: "1.5px",
        borderRadius: "10px",
        padding: "2px 4px",
        boxShadow: state.isFocused
          ? "0 0 0 3px rgba(99, 102, 241, 0.15)"
          : "none",
        "&:hover": { borderColor: "#6366f1" },
      }),
      option: (base, state) => ({
        ...base,
        backgroundColor: state.isSelected
          ? "#4f46e5"
          : state.isFocused
            ? isDark
              ? "#374151"
              : "#eef2ff"
            : isDark
              ? "#1f2937"
              : "#ffffff",
        color: state.isSelected ? "#ffffff" : isDark ? "#f3f4f6" : "#111827",
        padding: "10px 14px",
        cursor: "pointer",
      }),
      menu: (base) => ({
        ...base,
        background: isDark ? "#1f2937" : "#ffffff",
        borderRadius: "10px",
        border: `1px solid ${isDark ? "#4b5563" : "#d1d5db"}`,
        boxShadow: "0 10px 25px -5px rgba(0,0,0,0.12)",
        overflow: "hidden",
      }),
      singleValue: (base) => ({
        ...base,
        color: isDark ? "#f3f4f6" : "#111827",
      }),
      input: (base) => ({ ...base, color: isDark ? "#f3f4f6" : "#111827" }),
      placeholder: (base) => ({ ...base, color: "#9ca3af" }),
      menuPortal: (base) => ({ ...base, zIndex: 9999 }),
    }),
    [isDark],
  );

  const currencySelectStyles = useMemo(
    () => ({
      container: (base) => ({ ...base, height: "100%" }),
      control: (base, state) => ({
        ...base,
        height: "100%",
        minHeight: 0,
        background: state.isFocused ? "#4338ca" : "#4f46e5",
        border: "none",
        borderRadius: 0,
        boxShadow: "none",
        cursor: "pointer",
        "&:hover": { background: "#4338ca" },
      }),
      valueContainer: (base) => ({ ...base, padding: "0 4px 0 14px" }),
      singleValue: (base) => ({ ...base, color: "#ffffff", fontWeight: 600 }),
      dropdownIndicator: (base) => ({
        ...base,
        color: "#ffffff",
        padding: "0 10px 0 0",
      }),
      indicatorSeparator: () => ({ display: "none" }),
      option: (base, state) => ({
        ...base,
        backgroundColor: state.isSelected
          ? "#4f46e5"
          : state.isFocused
            ? isDark
              ? "#374151"
              : "#eef2ff"
            : isDark
              ? "#1f2937"
              : "#ffffff",
        color: state.isSelected ? "#ffffff" : isDark ? "#f3f4f6" : "#111827",
        padding: "10px 14px",
        cursor: "pointer",
      }),
      menu: (base) => ({
        ...base,
        background: isDark ? "#1f2937" : "#ffffff",
        border: `1px solid ${isDark ? "#4b5563" : "#d1d5db"}`,
        borderRadius: "10px",
        minWidth: "140px",
        overflow: "hidden",
        boxShadow: "0 10px 25px -5px rgba(0,0,0,0.15)",
      }),
      menuPortal: (base) => ({ ...base, zIndex: 9999 }),
    }),
    [isDark],
  );

  const menuPortalTarget =
    typeof document !== "undefined" ? document.body : undefined;

  const baseCurrency = cardsData?.base_curr;
  // Virtual Card Charges; falls back to cardCharge only if /charges failed to load.
  const charge = chargeInfo || cardsData?.cardCharge || {};
  const rate = selectedCurrency?.rate || 1;
  const selectedCode = selectedCurrency?.value || baseCurrency;

  const amountNum = Number(amount) || 0;
  const amountInBase = amountNum / rate;
  const feeBase =
    (charge.fixed_charge || 0) +
    (amountInBase * (charge.percent_charge || 0)) / 100;
  const previewCharge = amountNum > 0 ? feeBase : 0;
  const totalPayableBase = amountNum > 0 ? amountInBase + feeBase : 0;

  /* Limits — the API reports them in base currency, shown in the selected one */
  const dailyBase = charge.daily_limit || 0;
  const monthlyBase = charge.monthly_limit || 0;
  const minBase = charge.min_limit || 0;
  const maxBase = charge.max_limit || 0;

  const dailyLimitDisp = dailyBase * rate;
  const monthlyLimitDisp = monthlyBase * rate;
  const minLimitDisp = minBase * rate;
  const maxLimitDisp = maxBase * rate;
  const remainingDailyDisp = (remainingDaily ?? dailyBase) * rate;
  const remainingMonthlyDisp = (remainingMonthly ?? monthlyBase) * rate;

  /* The wallet holds its own currency, so convert the payable into it */
  const walletRate =
    cardsData?.supported_currency?.find(
      (c) => c.currency_code === selectedWallet?.code,
    )?.rate ?? 1;
  const payableInWallet = totalPayableBase * walletRate;

  /* Submit — create the card */
  const handleSubmit = async () => {
    if (submitting) return;

    if (!amountNum || amountNum <= 0) {
      toast.error("Please enter a valid amount");
      return;
    }
    if (minBase > 0 && amountNum < minLimitDisp) {
      toast.error(
        `Minimum card amount is ${minLimitDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (maxBase > 0 && amountNum > maxLimitDisp) {
      toast.error(
        `Maximum card amount is ${maxLimitDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (!selectedWallet?.code) {
      toast.error("Please select a wallet");
      return;
    }
    if (remainingDaily != null && amountInBase > remainingDaily) {
      toast.error(
        `Daily limit exceeded. Remaining ${remainingDailyDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (remainingMonthly != null && amountInBase > remainingMonthly) {
      toast.error(
        `Monthly limit exceeded. Remaining ${remainingMonthlyDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (payableInWallet > (selectedWallet.balance ?? 0) + 1e-9) {
      toast.error(
        `Insufficient balance. You need ${payableInWallet.toFixed(4)} ${selectedWallet.code}`,
      );
      return;
    }

    const payload = new FormData();
    payload.append("card_amount", amount);
    payload.append("currency", selectedCode);
    payload.append("from_currency", selectedWallet.code);
    payload.append("brand", selectedBrand.value);

    try {
      setSubmitting(true);
      const res = await createStrowalletCard(payload);

      if (res?.message?.success) {
        toast.success(res.message.success[0] || "Virtual card created");
        router.push("/dashboard/Virtual-Card");
      } else if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to create card");
      } else {
        toast.error("Unexpected response. Please try again.");
      }
    } catch (err) {
      toast.error("Failed to create card. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-[50vh]">
        <Loader />
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12 px-4">
        <div className="max-w-md mx-auto bg-red-50 dark:bg-red-500/10 border border-red-200 dark:border-red-500/30 rounded-xl p-6 text-red-700 dark:text-red-300">
          {error}
        </div>
      </div>
    );
  }

  const row = (label, value, highlight = false) => (
    <div className="flex items-center justify-between gap-3 py-3 border-b border-gray-100 dark:border-gray-700/60 last:border-0">
      <span className="text-gray-500 dark:text-gray-400">{label}</span>
      <span
        className={
          highlight
            ? "text-base font-bold text-indigo-600 dark:text-indigo-400 text-right"
            : "font-semibold text-gray-900 dark:text-gray-100 text-right"
        }
      >
        {value}
      </span>
    </div>
  );

  const labelCls =
    "block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-1.5";

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 lg:gap-8">
      {/* ── LEFT: Form ──────────────────────────────────────── */}
      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 md:p-8 h-fit">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-gray-100 text-center mb-8">
          Create Virtual Card
        </h2>

        {/* Card Amount */}
        <div className="mb-3">
          <label className={labelCls}>
            Card Amount <span className="text-red-600">*</span>
          </label>
          <div className="flex items-stretch h-12 border border-gray-300 dark:border-gray-600 rounded-lg focus-within:border-indigo-500 focus-within:ring-1 focus-within:ring-indigo-500 transition-all overflow-hidden">
            <input
              type="number"
              min="0"
              step="0.01"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="Enter Amount"
              disabled={submitting}
              className="flex-1 px-4 h-full text-gray-900 dark:text-gray-100 bg-white dark:bg-gray-700 focus:outline-none text-base no-spinner"
            />
            <div className="w-24 h-full shrink-0">
              <Select
                value={selectedCurrency}
                onChange={(v) => setSelectedCurrency(v)}
                options={cardsData?.supported_currency?.map((c) => ({
                  value: c.currency_code,
                  label: c.currency_code,
                  rate: c.rate,
                  symbol: c.currency_symbol,
                }))}
                styles={currencySelectStyles}
                menuPortalTarget={menuPortalTarget}
                isSearchable={false}
                isDisabled={submitting}
              />
            </div>
          </div>
        </div>

        {/* Transaction limit + fees */}
        <div className="flex flex-wrap justify-between gap-2 text-sm font-medium text-amber-600 dark:text-amber-500 mb-6">
          <span>
            {minLimitDisp.toFixed(4)} {selectedCode} – {maxLimitDisp.toFixed(4)}{" "}
            {selectedCode}
          </span>
          <span>
            Fees: {(charge.fixed_charge || 0).toFixed(4)} {baseCurrency} +{" "}
            {(charge.percent_charge || 0).toFixed(4)}% = {feeBase.toFixed(4)}{" "}
            {baseCurrency}
          </span>
        </div>

        {/* From Wallet */}
        <div className="mb-3">
          <label className={labelCls}>
            From Wallet <span className="text-red-600">*</span>
          </label>
          <Select
            value={selectedWallet}
            onChange={(v) => setSelectedWallet(v)}
            options={cardsData?.userWallet?.map((w) => ({
              value: w.currency.code,
              label: `${w.currency.name} ( ${w.balance.toFixed(4)} ${w.currency.code} )`,
              balance: w.balance,
              code: w.currency.code,
            }))}
            styles={selectStyles}
            menuPortalTarget={menuPortalTarget}
            isDisabled={submitting}
          />
        </div>

        {/* Available balance */}
        <div className="flex flex-wrap justify-end gap-2 text-sm font-medium text-amber-600 dark:text-amber-500 mb-8">
          <span>
            Available Balance {selectedWallet?.balance?.toFixed(4) ?? "0.0000"}{" "}
            {selectedWallet?.code ?? baseCurrency}
          </span>
        </div>

        {/* Confirm */}
        <button
          onClick={handleSubmit}
          disabled={submitting}
          className="w-full py-3.5 btn-primary text-white font-semibold text-base rounded-xl shadow-sm disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
        >
          {submitting ? "Processing..." : "Confirm"}
        </button>
      </div>

      {/* ── RIGHT: Preview + Limit Information ───────────────── */}
      <div className="space-y-6 lg:space-y-8 h-fit lg:sticky lg:top-6 self-start">
        {/* Preview */}
        <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 md:p-8">
          <h3 className="text-2xl font-bold text-gray-900 dark:text-gray-100 text-center mb-6">
            Preview
          </h3>
          <div className="text-sm">
            {row("Card Amount", `${amountNum.toFixed(4)} ${selectedCode}`)}
            {row(
              "Exchange Rate",
              `1 ${selectedCode} = ${(1 / rate).toFixed(8)} ${baseCurrency}`,
            )}
            {row("Total Charge", `${previewCharge.toFixed(4)} ${baseCurrency}`)}
            {row(
              "Total Payable Amount",
              `${totalPayableBase.toFixed(4)} ${baseCurrency}`,
              true,
            )}
          </div>
        </div>

        {/* Limit Information */}
        <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 md:p-8">
          <h3 className="text-2xl font-bold text-gray-900 dark:text-gray-100 text-center mb-6">
            Limit Information
          </h3>
          <div className="text-sm">
            {row(
              "Transaction Limit",
              `${minLimitDisp.toFixed(4)} ${selectedCode} – ${maxLimitDisp.toFixed(4)} ${selectedCode}`,
            )}
            {row("Daily Limit", `${dailyLimitDisp.toFixed(4)} ${selectedCode}`)}
            {row(
              "Remaining Daily Limit",
              `${remainingDailyDisp.toFixed(4)} ${selectedCode}`,
              true,
            )}
            {row(
              "Monthly Limit",
              `${monthlyLimitDisp.toFixed(4)} ${selectedCode}`,
            )}
            {row(
              "Remaining Monthly Limit",
              `${remainingMonthlyDisp.toFixed(4)} ${selectedCode}`,
              true,
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default IssueStrowalletCard;

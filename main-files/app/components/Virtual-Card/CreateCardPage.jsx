"use client";

import { Listbox } from "@headlessui/react";
import { ChevronDown } from "lucide-react";
import { useRouter } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";

import {
  createStrowalletCard,
  getStrowalletCharges,
  getStrowalletCreateInfo,
  getUserDashboard,
  getRemainingLimits,
} from "../../utils/api";
import CreateCardSkeleton from "./CreateCardSkeleton";

export default function CreateCardPage() {
  const t = useTranslations("CreateCardPage");

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  // ── Form & API data states ────────────────────────────────
  const [remainingDaily, setRemainingDaily] = useState(0);
  const [remainingMonthly, setRemainingMonthly] = useState(0);

  const [chargesData, setChargesData] = useState(null);
  const [dashboardData, setDashboardData] = useState(null);

  const [cardCreateFields, setCardCreateFields] = useState([]);

  const [fixedCharge, setFixedCharge] = useState(2);
  const [percentCharge, setPercentCharge] = useState(1);
  const [minLimit, setMinLimit] = useState(1);
  const [maxLimit, setMaxLimit] = useState(1000);
  const [dailyLimit, setDailyLimit] = useState(0);
  const [monthlyLimit, setMonthlyLimit] = useState(0);

  const [walletOptions, setWalletOptions] = useState([]);
  const [selectedWallet, setSelectedWallet] = useState(null);

  const [formValues, setFormValues] = useState({});
  const [selectedCurrency, setSelectedCurrency] = useState("");
  const router = useRouter();

  // ============================================================================
  // DATA FETCHING EFFECT
  // ============================================================================
  useEffect(() => {
    const loadData = async () => {
      try {
        setLoading(true);

        const [chargesRes, dashRes] = await Promise.all([
          getStrowalletCharges(),
          getUserDashboard(),
        ]);

        setChargesData(chargesRes?.data || null);
        setDashboardData(dashRes?.data || null);
      } catch (err) {
        toast.error(t("failedToLoadData"));
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, [t]);

  // ============================================================================
  // COMPUTED VALUES
  // ============================================================================
  const baseCurrency = useMemo(
    () => chargesData?.base_curr || dashboardData?.base_curr || "USD",
    [chargesData, dashboardData]
  );

  const charge = useMemo(() => chargesData?.cardCharge || {}, [chargesData]);

  const cardAmount = Number(formValues.card_amount || 0);

  // Fees display logic (form)
  const feeDisplayedInForm =
    cardAmount === 0
      ? fixedCharge
      : fixedCharge + (cardAmount * percentCharge) / 100;

  const feeText = `${fixedCharge.toFixed(4)} ${baseCurrency} + ${percentCharge.toFixed(
    4
  )}% = ${feeDisplayedInForm.toFixed(4)} ${baseCurrency}`;

  // Preview logic
  const previewTotalCharge =
    cardAmount > 0 ? fixedCharge + (cardAmount * percentCharge) / 100 : 0;

  // ============================================================================
  // FETCH REMAINING LIMITS
  // ============================================================================
  useEffect(() => {
    const fetchRemainingLimits = async () => {
      if (!chargesData?.cardCharge?.id || !baseCurrency) return;

      const params = {
        transaction_type: "VIRTUAL-CARD",
        attribute: "RECEIVED",
        charge_id: chargesData?.cardCharge?.id || 2,
        sender_amount: 0,
        currency_code: baseCurrency,
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
  }, [chargesData, baseCurrency, dailyLimit, monthlyLimit]);

  useEffect(() => {
    let mounted = true;

    const fetchData = async () => {
      setLoading(true);
      setError(null);

      try {
        // 1. Card creation fields
        const createRes = await getStrowalletCreateInfo();

        if (createRes?.data?.card_create_fields) {
          const fields = createRes.data.card_create_fields;
          setCardCreateFields(fields);

          const initialValues = {};

          fields.forEach((f) => {
            if (f.field_name !== "currency") {
              initialValues[f.field_name] = "";
            }
          });

          setFormValues(initialValues);
        }

        // 2. Charges (fees + limits + currency)
        const chargesRes = await getStrowalletCharges();

        if (chargesRes?.data) {
          const { base_curr, cardCharge } = chargesRes.data;

          if (base_curr) {
            setSelectedCurrency(base_curr);
          }

          if (cardCharge) {
            setFixedCharge(Number(cardCharge.fixed_charge) || 0);
            setPercentCharge(Number(cardCharge.percent_charge) || 0);
            setMinLimit(Number(cardCharge.min_limit) || 1);
            setMaxLimit(Number(cardCharge.max_limit) || 1000);
            setDailyLimit(Number(cardCharge.daily_limit) || 0);
            setMonthlyLimit(Number(cardCharge.monthly_limit) || 0);
          }
        }

        // 3. User dashboard (wallets + real balance)
        const dashboardRes = await getUserDashboard();

        if (dashboardRes?.data?.userWallet?.length > 0) {
          const wallets = dashboardRes.data.userWallet.map((w) => ({
            value: w.currency.code.toLowerCase(),
            label: `${w.currency.name} (${Number(w.balance).toFixed(4)} ${
              w.currency.code
            })`,
            balance: Number(w.balance),
            currencyCode: w.currency.code,
          }));

          setWalletOptions(wallets);
          setSelectedWallet(wallets[0]); // auto-select first/default
        }
      } catch (err) {
        // console.error(err);
        toast.error(t("somethingWentWrong"));
        setError(t("failedToLoadRequiredData"));
      } finally {
        if (mounted) setLoading(false);
      }
    };

    fetchData();

    return () => {
      mounted = false;
    };
  }, [t]);

  const handleInputChange = (fieldName, value) => {
    setFormValues((prev) => ({ ...prev, [fieldName]: value }));
  };

  const handleConfirm = async () => {
    if (submitting) return;

    // Basic validation
    if (!formValues.name_on_card?.trim()) {
      toast.error(t("validation.enterCardHolderName"));
      return;
    }

    if (!cardAmount || cardAmount <= 0) {
      toast.error(t("validation.enterValidCardAmount"));
      return;
    }

    if (cardAmount < minLimit || cardAmount > maxLimit) {
      toast.error(
        t("validation.amountRange", {
          min: minLimit,
          max: maxLimit,
          currency: baseCurrency,
        })
      );
      return;
    }

    if (!selectedWallet) {
      toast.error(t("validation.selectWallet"));
      return;
    }

    if (cardAmount > selectedWallet.balance) {
      toast.error(t("validation.insufficientBalance"));
      return;
    }

    setSubmitting(true);

    try {
      const payload = {
        name_on_card: formValues.name_on_card.trim(),
        card_amount: cardAmount,
        currency: baseCurrency || "USD",
        from_currency: selectedWallet?.currencyCode || "USD",
      };

      const response = await createStrowalletCard(payload);

      // Show ONLY real server message via toast
      if (response?.message?.success?.length > 0) {
        toast.success(response.message.success[0]);
        router.push("/dashboard/Virtual-Card");
      } else if (response?.message?.error?.length > 0) {
        toast.error(response.message.error[0]);
      } else {
        toast.error(t("unexpectedServerResponse"));
      }
    } catch (err) {
      // console.error("Card creation error:", err);
      toast.error(t("failedToCreateVirtualCard"));
      const errMsg =
        err?.response?.data?.message?.error?.[0] ||
        err?.message ||
        t("failedToCreateVirtualCard");

      toast.error(errMsg);
    } finally {
      setSubmitting(false);
    }
  };

  const renderField = (field) => {
    if (field.field_name === "currency") {
      const amountField = cardCreateFields.find(
        (f) => f.field_name === "card_amount",
      );

      const amountLabel = amountField
        ? amountField.label_name
        : t("fields.amount");

      return (
        <div key="amount-currency-group">
          <label
            htmlFor="amount"
            className="mb-2 block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            {amountLabel} <span className="text-red-500">*</span>
          </label>

          <div className="relative flex rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 focus-within:border-primary-500 dark:focus-within:border-primary-400 focus-within:ring-1 focus-within:ring-primary-200 dark:focus-within:ring-primary-700 focus-within:ring-opacity-50">
            <input
              type="number"
              id="amount"
              placeholder={t("placeholders.enterAmount", {
                field: amountLabel.toLowerCase(),
              })}
              min={minLimit}
              max={maxLimit}
              step="0.01"
              value={formValues.card_amount ?? ""}
              onChange={(e) =>
                handleInputChange("card_amount", e.target.value)
              }
              className="block w-full flex-1 border-none bg-transparent px-4 py-3 text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 focus:outline-none [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
            />

            <Listbox
              value={selectedCurrency}
              onChange={setSelectedCurrency}
            >
              {({ open }) => (
                <div className="relative min-w-20">
                  <Listbox.Button className="flex h-full w-full items-center justify-center px-3 text-gray-700 dark:text-gray-300 focus:outline-none cursor-pointer">
                    <span className="font-medium">
                      {selectedCurrency || baseCurrency}
                    </span>

                    <ChevronDown
                      className={`ml-1.5 h-5 w-5 text-gray-500 dark:text-gray-400 transition-transform duration-200 ${
                        open ? "rotate-180" : ""
                      }`}
                    />
                  </Listbox.Button>

                  <Listbox.Options className="absolute right-0 top-full z-30 mt-1 w-28 rounded-lg border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 py-1 shadow-lg">
                    <Listbox.Option
                      value={baseCurrency}
                      className={({ active }) =>
                        `cursor-pointer px-4 py-2.5 text-sm ${
                          active
                            ? "bg-emerald-50 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-300"
                            : "text-gray-900 dark:text-gray-100"
                        }`
                      }
                    >
                      <span className="block font-medium">
                        {baseCurrency}
                      </span>
                    </Listbox.Option>
                  </Listbox.Options>
                </div>
              )}
            </Listbox>
          </div>
        </div>
      );
    }

    if (field.field_name === "card_amount") return null;

    return (
      <div key={field.id}>
        <label
          htmlFor={field.field_name}
          className="mb-2 block text-sm font-medium text-gray-700 dark:text-gray-300"
        >
          {field.label_name} <span className="text-red-500">*</span>
        </label>

        <input
          type={field.type}
          id={field.field_name}
          placeholder={t("placeholders.enterField", {
            field: field.label_name,
          })}
          value={formValues[field.field_name] || ""}
          onChange={(e) =>
            handleInputChange(field.field_name, e.target.value)
          }
          className="block w-full rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 px-4 py-3 text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 focus:border-primary-500 dark:focus:border-primary-400 focus:ring-1 focus:ring-primary-200 dark:focus:ring-primary-700 focus:outline-none transition"
        />
      </div>
    );
  };

  if (loading) {
    return <CreateCardSkeleton />;
  }

  if (error) {
    return (
      <div className="p-10 text-center text-red-600 dark:text-red-400">
        {error}
      </div>
    );
  }

  return (
    <>
      <div className="grid grid-cols-1 gap-8 lg:grid-cols-2 lg:gap-10">
        {/* ================================================================
            Left: Create Virtual Card Form
        ================================================================ */}
        <div className="overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl">
          <div className="p-6 sm:p-8 lg:p-10">
            <h1 className="text-center mb-6 text-xl font-bold text-gray-900 dark:text-gray-100 sm:text-2xl">
              {t("title")}
            </h1>

            <form className="space-y-7">
              {cardCreateFields.map(renderField)}

              {/* From Wallet Selector */}
              <div>
                <label
                  htmlFor="wallet"
                  className="mb-2 block text-sm font-medium text-gray-700 dark:text-gray-300"
                >
                  {t("fromWallet")} <span className="text-red-500">*</span>
                </label>

                <Listbox value={selectedWallet} onChange={setSelectedWallet}>
                  {({ open }) => (
                    <div className="relative">
                      <Listbox.Button className="relative block w-full rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 px-4 py-3 text-gray-900 dark:text-gray-100 focus:border-primary-500 dark:focus:border-primary-400 focus:ring-1 focus:ring-primary-200 dark:focus:ring-primary-700 focus:outline-none text-left cursor-pointer">
                        <span className="block truncate pr-8">
                          {selectedWallet?.label || t("selectWallet")}
                        </span>
                        <ChevronDown
                          className={`absolute right-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400 dark:text-gray-500 transition-transform duration-200 ${
                            open ? "rotate-180" : ""
                          }`}
                        />
                      </Listbox.Button>

                      <Listbox.Options className="absolute z-30 mt-1 w-full rounded-lg border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 py-1 shadow-lg max-h-60 overflow-auto">
                        {walletOptions.map((wallet) => (
                          <Listbox.Option
                            key={wallet.value}
                            value={wallet}
                            className={({ active }) =>
                              `cursor-pointer px-4 py-2.5 text-sm ${
                                active
                                  ? "bg-primary-50 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300"
                                  : "text-gray-900 dark:text-gray-100"
                              }`
                            }
                          >
                            <span className="block font-medium">{wallet.label}</span>
                          </Listbox.Option>
                        ))}
                      </Listbox.Options>
                    </div>
                  )}
                </Listbox>
              </div>

              {/* Fees & Balance */}
              <div className="rounded-lg bg-gray-50 dark:bg-gray-700/50 border border-gray-200 dark:border-gray-600 p-5 text-sm">
                <p className="text-gray-700 dark:text-gray-300">
                  {t("fees")}:{" "}
                  <span className="font-medium text-gray-900 dark:text-gray-100">
                    {feeText}
                  </span>
                </p>
                <p className="mt-1.5 text-gray-700 dark:text-gray-300">
                  {t("availableBalance")}:{" "}
                  <span className="font-medium text-gray-900 dark:text-gray-100">
                    {selectedWallet
                      ? `${selectedWallet.balance.toFixed(4)} ${baseCurrency || "USD"}`
                      : `0.0000 USD`}
                  </span>
                </p>
              </div>

              {/* Submit Button */}
              <button
                type="button"
                disabled={submitting}
                onClick={handleConfirm}
                className={`cursor-pointer mt-4 w-full rounded-lg btn-primary px-6 py-3.5 font-medium text-white transition-opacity ${
                  submitting ? "opacity-50 cursor-not-allowed" : ""
                }`}
              >
                {submitting ? t("processing") : t("confirm")}
              </button>
            </form>
          </div>
        </div>

        {/* ================================================================
            Right: Preview
        ================================================================ */}
        <div className="overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl h-fit">
          <div className="p-6 sm:p-8 lg:p-10">
            <h2 className="text-center mb-6 text-xl font-bold text-gray-900 dark:text-gray-100 sm:text-2xl">
              {t("preview")}
            </h2>

            <div className="space-y-5 text-sm">
              <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
                <span className="text-gray-600 dark:text-gray-400">{t("cardAmount")}</span>
                <span className="font-medium text-gray-900 dark:text-gray-100">
                  {cardAmount.toFixed(4)} {baseCurrency || "USD"}
                </span>
              </div>

              <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
                <span className="text-gray-600 dark:text-gray-400">{t("exchangeRate")}</span>
                <span className="font-medium text-gray-900 dark:text-gray-100">
                  1 USD = 1.00000000 USD
                </span>
              </div>

              <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
                <span className="text-gray-600 dark:text-gray-400">{t("totalCharge")}</span>
                <span className="font-medium text-gray-900 dark:text-gray-100">
                  {previewTotalCharge.toFixed(4)} {baseCurrency || "USD"}
                </span>
              </div>

              <div className="flex items-center justify-between py-2">
                <span className="text-gray-600 dark:text-gray-400 font-medium">
                  {t("totalPayableAmount")}
                </span>
                <span className="text-lg font-semibold text-primary-600 dark:text-primary-400">
                  {(cardAmount + previewTotalCharge).toFixed(4)}{" "}
                  {baseCurrency || "USD"}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* ================================================================
          Limit Information
      ================================================================ */}
      <div className="mt-10 overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl">
        <div className="p-8">
          <h2 className="text-center mb-8 text-2xl font-bold text-gray-900 dark:text-gray-100">
            {t("limitInformation")}
          </h2>

          <div className="space-y-6 text-sm">
            <div className="flex justify-between items-center py-3 border-b border-gray-200 dark:border-gray-700">
              <span className="text-gray-600 dark:text-gray-400">{t("dailyLimit")}</span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {dailyLimit.toFixed(4)} {baseCurrency}
              </span>
            </div>

            <div className="flex justify-between items-center py-3 border-b border-gray-200 dark:border-gray-700">
              <span className="text-gray-600 dark:text-gray-400">{t("remainingDailyLimit")}</span>
              <span className="font-medium text-primary-600 dark:text-primary-400">
                {remainingDaily.toFixed(4)} {baseCurrency}
              </span>
            </div>

            <div className="flex justify-between items-center py-3 border-b border-gray-200 dark:border-gray-700">
              <span className="text-gray-600 dark:text-gray-400">{t("monthlyLimit")}</span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {monthlyLimit.toFixed(4)} {baseCurrency}
              </span>
            </div>

            <div className="flex justify-between items-center py-3">
              <span className="text-gray-600 dark:text-gray-400">{t("remainingMonthlyLimit")}</span>
              <span className="font-medium text-primary-600 dark:text-primary-400">
                {remainingMonthly.toFixed(4)} {baseCurrency}
              </span>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
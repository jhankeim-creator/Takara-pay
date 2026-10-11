"use client";

import { Listbox } from "@headlessui/react";
import { ChevronDown } from "lucide-react";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import { useTranslations } from "next-intl";
import toast from "react-hot-toast";
import {
  fundStrowalletCard,
  getRemainingLimits,
  getStrowalletCardDetails,
  getStrowalletCards,
  getStrowalletCharges,
  getUserDashboard,
} from "../../utils/api";
import FundVirtualCardSkeleton from "./FundVirtualCardSkeleton";

export default function FundVirtualCard() {
  const t = useTranslations("fundVirtualCard"); 

  // ============================================================================
  // ROUTER & PARAMS
  // ============================================================================
  const router = useRouter();
  const searchParams = useSearchParams();
  const cardId = searchParams.get("card_id");

  // ============================================================================
  // FORM STATE
  // ============================================================================
  const [fundAmount, setFundAmount] = useState("");
  const [currency, setCurrency] = useState("USD");
  const [fromWallet, setFromWallet] = useState("USD");

  // ============================================================================
  // DATA STATE
  // ============================================================================
  const [loading, setLoading] = useState(true);
  const [fetchError, setFetchError] = useState(null);
  const [chargesData, setChargesData] = useState(null);
  const [cardData, setCardData] = useState(null);
  const [dashboardData, setDashboardData] = useState(null);
  const [supportedCurrencies, setSupportedCurrencies] = useState([]);

  // Remaining Limits State
  const [remainingDaily, setRemainingDaily] = useState(null);
  const [remainingMonthly, setRemainingMonthly] = useState(null);

  // ============================================================================
  // SUBMIT STATE
  // ============================================================================
  const [submitting, setSubmitting] = useState(false);

  // ============================================================================
  // DATA FETCHING EFFECT
  // ============================================================================
  useEffect(() => {
    if (!cardId) {
      setFetchError(t("errors.noCard"));
      setLoading(false);
      return;
    }

    let isMounted = true;

    const loadData = async () => {
      try {
        setLoading(true);
        setFetchError(null);

        const [chargesRes, cardRes, dashRes, strowalletRes] = await Promise.all([
          getStrowalletCharges(),
          getStrowalletCardDetails(cardId),
          getUserDashboard(),
          getStrowalletCards(),
        ]);

        if (!isMounted) return;

        setChargesData(chargesRes?.data || null);
        setCardData(cardRes?.data?.myCards || null);
        setDashboardData(dashRes?.data || null);
        setSupportedCurrencies(strowalletRes?.data?.supported_currency || []);

        const base =
         chargesRes?.data?.base_curr || dashRes?.data?.base_curr || "USD";
        const supported = strowalletRes?.data?.supported_currency || [];
        const isBaseSupported = supported.some(c => c.currency_code === base);

        setCurrency(isBaseSupported ? base : (supported[0]?.currency_code || base));
        setFromWallet(base);
      } catch (err) {
        if (isMounted) setFetchError(err.message || t("errors.loadFailed"));
      } finally {
        if (isMounted) setLoading(false);
      }
    };

    loadData();
    return () => { isMounted = false; };
  }, [cardId]);

  // ============================================================================
  // COMPUTED VALUES
  // ============================================================================
  const baseCurrency = useMemo(
    () => chargesData?.base_curr || dashboardData?.base_curr || "USD",
    [chargesData, dashboardData],
  );

  const selectedCurrencyObj = useMemo(() => {
    return supportedCurrencies.find((c) => c.currency_code === currency) || null;
  }, [supportedCurrencies, currency]);

  const currencyRate = useMemo(() => {
    return Number(selectedCurrencyObj?.rate || 1);
  }, [selectedCurrencyObj]);

  const charge = useMemo(() => chargesData?.cardCharge || {}, [chargesData]);

  const availableBalance = useMemo(() => {
    const wallet = dashboardData?.userWallet?.find(
      (w) => w.currency?.code === baseCurrency,
    );
    return Number(wallet?.balance || 0);
  }, [dashboardData, baseCurrency]);

  const walletDisplayName = useMemo(() => {
    const wallet = dashboardData?.userWallet?.find(
      (w) => w.currency?.code === baseCurrency,
    );
    if (!wallet) return t("mainWallet");
    let name = wallet.currency?.name || "United States dollar";
    return name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();
  }, [dashboardData, baseCurrency]);

  // ============================================================================
  // CHARGE CALCULATIONS
  // ============================================================================
  const numericAmount = Number(fundAmount) || 0;
  const hasAmount = numericAmount > 0;

  const fixedCharge = Number(charge.fixed_charge) || 2;
  const percentCharge = Number(charge.percent_charge) || 1;

  // Convert the user-entered amount from selected currency → wallet base currency
  // currencyRate = rate of 1 base currency unit in selected currency
  // e.g. currencyRate = 0.008109 means 1 BDT = 0.008109 USD, so 1 USD = 1/0.008109 BDT
  const amountInBase = currencyRate > 0 ? numericAmount / currencyRate : 0;

  // fixed_charge is defined in the selected card currency → convert to wallet currency
  const fixedChargeInWallet = currencyRate > 0 ? fixedCharge / currencyRate : fixedCharge;

  // percent fee applied on the base-currency equivalent of the entered amount
  const percentFeeInWallet = hasAmount ? (amountInBase * percentCharge) / 100 : 0;

  const feeDisplayedInForm = fixedChargeInWallet + percentFeeInWallet;

  const feeText = `${fixedChargeInWallet.toFixed(4)} ${baseCurrency} + ${percentCharge.toFixed(4)}% = ${feeDisplayedInForm.toFixed(4)} ${baseCurrency}`;

  const previewTotalCharge = hasAmount ? feeDisplayedInForm : 0;

  const totalPayable = amountInBase + previewTotalCharge;

  // ============================================================================
  // TRANSACTION LIMITS
  // ============================================================================
  // Static limits: cardCharge values are in base currency → multiply by currencyRate
  // to convert to the selected card currency. Always use raw frontend calc for these
  // so they stay consistent with the charge configuration regardless of API responses.
  const transactionMin = (Number(charge.min_limit) || 1) * currencyRate;
  const transactionMax = (Number(charge.max_limit) || 1000) * currencyRate;
  const dailyLimit = (Number(charge.daily_limit) || 10000) * currencyRate;
  const monthlyLimit = (Number(charge.monthly_limit) || 50000) * currencyRate;

  // Remaining limits come from getRemainingLimits API (in base currency)
  // → convert to selected currency the same way.
  const displayRemainingDaily = remainingDaily !== null
    ? remainingDaily * currencyRate
    : dailyLimit;
  const displayRemainingMonthly = remainingMonthly !== null
    ? remainingMonthly * currencyRate
    : monthlyLimit;

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
        sender_amount: totalPayable,
        currency_code: baseCurrency,
      };

      try {
        const response = await getRemainingLimits(params);

        const result = response?.data || response || {};

        if (result.remainingDaily !== undefined) setRemainingDaily(Number(result.remainingDaily));
        if (result.remainingMonthly !== undefined) setRemainingMonthly(Number(result.remainingMonthly));
      } catch (error) {
        console.log("Failed to fetch remaining limits:", error);
        setRemainingDaily(dailyLimit);
        setRemainingMonthly(monthlyLimit);
      }
    };

    fetchRemainingLimits();
  }, [chargesData, baseCurrency, totalPayable]);

  // ============================================================================
  // FORM VALIDATION
  // ============================================================================
  const isFormValid =
    hasAmount &&
    !isNaN(numericAmount) &&
    numericAmount >= transactionMin &&
    numericAmount <= transactionMax &&
    totalPayable <= availableBalance;

  // ============================================================================
  // FORM SUBMISSION HANDLER
  // ============================================================================
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!isFormValid) {
      toast.error(t("errors.invalidAmount"));
      return;
    }

    setSubmitting(true);
    const payload = {
      card_id: cardId,
      fund_amount: numericAmount,
      currency: currency,
      from_currency: fromWallet,
    };

    try {
      const response = await fundStrowalletCard(payload);
      if (response?.message?.success?.length > 0) {
        toast.success(response.message.success[0]);
        setTimeout(() => {
          setFundAmount("");
          router.push("/dashboard/Virtual-Card");
        }, 1800);
      } else if (response?.message?.error?.length > 0) {
        toast.error(response.message.error[0]);
      } else {
        toast.error(t("errors.generic"));
      }
    } catch (err) {
      toast.error(t("errors.network"));
    } finally {
      setSubmitting(false);
    }
  };

  // ============================================================================
  // LOADING STATE
  // ============================================================================
  if (loading) return <FundVirtualCardSkeleton />;

  // ============================================================================
  // ERROR STATE
  // ============================================================================
  if (fetchError || !cardData) {
    return (
      <div className="rounded-2xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 p-8 text-center text-red-700 dark:text-red-400">
        <p>{fetchError || t("errors.loadCardFailed")}</p>
        <button
          onClick={() => router.push("/dashboard/Virtual-Card")}
          className="mt-4 cursor-pointer rounded-lg bg-red-600 hover:bg-red-700 dark:bg-red-700 dark:hover:bg-red-600 px-6 py-2.5 text-white"
        >
          {t("backButton")}
        </button>
      </div>
    );
  }

  // ============================================================================
  // MAIN RENDER
  // ============================================================================
  return (
    <>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-10">
        {/* ====================================================================
            FUND FORM
        ==================================================================== */}
        <div className="overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl">
          <div className="p-6 sm:p-8 lg:p-10">
            <h2 className="text-center mb-6 text-xl font-bold text-gray-900 dark:text-gray-100 sm:text-2xl">
              {t("form.title")}
            </h2>

            <form onSubmit={handleSubmit} className="space-y-7">
              {/* Amount + Currency Input */}
              <div>
                <label className="mb-2 block text-sm font-medium text-gray-700 dark:text-gray-300">
                  {t("form.amountLabel")} <span className="text-red-500">*</span>
                </label>
                <div className="relative flex rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 focus-within:border-primary-500 dark:focus-within:border-primary-400 focus-within:ring-1 focus-within:ring-primary-200 dark:focus-within:ring-primary-700">
                  <input
                    type="number"
                    step="0.01"
                    value={fundAmount}
                    onChange={(e) => setFundAmount(e.target.value)}
                    placeholder={t("form.amountPlaceholder")}
                    className="block w-full flex-1 border-none bg-transparent px-4 py-3 text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 focus:outline-none [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                    required
                    disabled={submitting}
                  />
                  <Listbox value={currency} onChange={setCurrency} disabled={submitting}>
                    {({ open }) => (
                      <div className="relative min-w-20">
                        <Listbox.Button className="flex h-full w-full cursor-pointer items-center justify-center px-3 text-gray-700 dark:text-gray-300">
                          <span className="font-medium">{currency}</span>
                          <ChevronDown
                            className={`ml-1.5 h-5 w-5 text-gray-500 dark:text-gray-400 transition-transform ${open ? "rotate-180" : ""}`}
                          />
                        </Listbox.Button>
                        <Listbox.Options className="absolute right-0 top-full z-30 mt-1 w-28 rounded-lg border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 py-1 shadow-lg">
                          {supportedCurrencies.length > 0 ? (
                            supportedCurrencies.map((curr) => (
                              <Listbox.Option
                                key={curr.id}
                                value={curr.currency_code}
                                className={({ active }) =>
                                  `cursor-pointer px-4 py-2.5 text-sm ${
                                    active
                                      ? "bg-primary-50 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300"
                                      : "text-gray-900 dark:text-gray-100"
                                  }`
                                }
                              >
                                {curr.currency_code}
                              </Listbox.Option>
                            ))
                          ) : (
                            <Listbox.Option
                              value={baseCurrency}
                              className={({ active }) =>
                                `cursor-pointer px-4 py-2.5 text-sm ${
                                  active
                                    ? "bg-primary-50 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300"
                                    : "text-gray-900 dark:text-gray-100"
                                }`
                              }
                            >
                              {baseCurrency}
                            </Listbox.Option>
                          )}
                        </Listbox.Options>
                      </div>
                    )}
                  </Listbox>
                </div>
              </div>

              {/* From Wallet Selector */}
              <div>
                <label className="mb-2 block text-sm font-medium text-gray-700 dark:text-gray-300">
                  {t("form.fromWalletLabel")} <span className="text-red-500">*</span>
                </label>
                <Listbox value={fromWallet} onChange={setFromWallet} disabled={submitting}>
                  {({ open }) => (
                    <div className="relative">
                      <Listbox.Button className="relative w-full cursor-pointer rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 py-3 pl-4 pr-10 text-left text-gray-900 dark:text-gray-100 sm:text-sm">
                        <span className="block truncate">
                          {walletDisplayName} ({availableBalance.toFixed(4)} {baseCurrency})
                        </span>
                        <span className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                          <ChevronDown
                            className={`h-5 w-5 text-gray-400 dark:text-gray-500 transition-transform ${open ? "rotate-180" : ""}`}
                          />
                        </span>
                      </Listbox.Button>
                      <Listbox.Options className="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700 py-1 shadow-lg">
                        <Listbox.Option
                          value={baseCurrency}
                          className={({ active }) =>
                            `relative cursor-pointer select-none py-2 pl-10 pr-4 ${
                              active
                                ? "bg-primary-50 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300"
                                : "text-gray-900 dark:text-gray-100"
                            }`
                          }
                        >
                          {walletDisplayName} ({availableBalance.toFixed(4)} {baseCurrency})
                        </Listbox.Option>
                      </Listbox.Options>
                    </div>
                  )}
                </Listbox>
              </div>

              {/* Fees & Balance Display */}
              <div className="rounded-lg bg-gray-50 dark:bg-gray-700/50 border border-gray-200 dark:border-gray-600 p-5 text-sm">
                <p className="text-gray-700 dark:text-gray-300">
                  {t("form.fees")}{" "}
                  <span className="font-medium text-gray-900 dark:text-gray-100">{feeText}</span>
                </p>
                <p className="mt-1.5 text-gray-700 dark:text-gray-300">
                  {t("form.availableBalance")}{" "}
                  <span className="font-medium text-gray-900 dark:text-gray-100">
                    {availableBalance.toFixed(4)} {baseCurrency}
                  </span>
                </p>
              </div>

              {/* Submit Button */}
              <button
                type="submit"
                disabled={submitting || !isFormValid}
                className="mt-4 w-full rounded-lg py-3.5 font-medium text-white flex items-center justify-center gap-2 transition-colors btn-primary cursor-pointer disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {submitting ? t("form.button.processing") : t("form.button.submit")}
              </button>
            </form>
          </div>
        </div>

        {/* ====================================================================
            PREVIEW SECTION
        ==================================================================== */}
        <div className="overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl h-fit">
          <div className="p-6 sm:p-8 lg:p-10">
            <h2 className="text-center mb-6 text-xl font-bold text-gray-900 dark:text-gray-100 sm:text-2xl">
              {t("preview.title")}
            </h2>

            <div className="space-y-5 text-sm">
              {/* Fund Amount */}
              <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
                <span className="text-gray-600 dark:text-gray-400">{t("preview.fundAmount")}</span>
                <span className="font-medium text-gray-900 dark:text-gray-100">
                  {numericAmount.toFixed(4)} {currency}
                </span>
              </div>

              {/* Exchange Rate */}
              <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
                <span className="text-gray-600 dark:text-gray-400">{t("preview.exchangeRate")}</span>
                <span className="font-medium text-gray-900 dark:text-gray-100">
                  1 {currency} = {(1 / currencyRate).toFixed(4)} {baseCurrency}
                </span>
              </div>

              {/* Total Charge */}
              <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
                <span className="text-gray-600 dark:text-gray-400">{t("preview.totalCharge")}</span>
                <span className="font-medium text-gray-900 dark:text-gray-100">
                  {previewTotalCharge.toFixed(4)} {baseCurrency}
                </span>
              </div>

              {/* Total Payable Amount */}
              <div className="flex items-center justify-between py-2">
                <span className="text-gray-600 dark:text-gray-400 font-medium">
                  {t("preview.totalPayable")}
                </span>
                <span className="text-lg font-semibold text-primary-600 dark:text-primary-400">
                  {totalPayable.toFixed(4)} {baseCurrency}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* ======================================================================
          LIMIT INFORMATION SECTION
      ====================================================================== */}
      <div className="mt-10 overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl">
        <div className="p-6 sm:p-8 lg:p-10">
          <h2 className="text-center mb-6 text-xl font-bold text-gray-900 dark:text-gray-100 sm:text-2xl">
            {t("limits.title")}
          </h2>

          <div className="space-y-5 text-sm">
            {/* Transaction Limit */}
            <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
              <span className="text-gray-600 dark:text-gray-400">{t("limits.transactionLimit")}</span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {transactionMin.toFixed(4)} {currency} – {transactionMax.toFixed(4)} {currency}
              </span>
            </div>

            {/* Daily Limit */}
            <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
              <span className="text-gray-600 dark:text-gray-400">{t("limits.dailyLimit")}</span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {dailyLimit.toFixed(4)} {currency}
              </span>
            </div>

            {/* Remaining Daily Limit */}
            <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
              <span className="text-gray-600 dark:text-gray-400">{t("limits.remainingDaily")}</span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {displayRemainingDaily.toFixed(4)} {currency}
              </span>
            </div>

            {/* Monthly Limit */}
            <div className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700">
              <span className="text-gray-600 dark:text-gray-400">{t("limits.monthlyLimit")}</span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {monthlyLimit.toFixed(4)} {currency}
              </span>
            </div>

            {/* Remaining Monthly Limit */}
            <div className="flex items-center justify-between py-2">
              <span className="text-gray-600 dark:text-gray-400">{t("limits.remainingMonthly")}</span>
              <span className="font-medium text-gray-900 dark:text-gray-100">
                {displayRemainingMonthly.toFixed(4)} {currency}
              </span>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
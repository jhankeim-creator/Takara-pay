"use client";

import { Listbox } from "@headlessui/react";
import { ChevronDown } from "lucide-react";
import { useTranslations } from "next-intl";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { getWithdrawInfo, submitWithdrawInsert } from "../../utils/api";

export default function WithdrawMoney({
  amount,
  setAmount,
  selectedGatewayCurrency,
  setSelectedGatewayCurrency,
}) {
  // ============================================================================
  // HOOKS & ROUTER
  // ============================================================================
  const router = useRouter();
  const t = useTranslations("withdrawMoney");

  // ============================================================================
  // STATE MANAGEMENT
  // ============================================================================
  const [loading, setLoading] = useState(true);
  const [submitLoading, setSubmitLoading] = useState(false);
  const [withdrawData, setWithdrawData] = useState(null);
  const [selectedCurrencyCode, setSelectedCurrencyCode] = useState("");

  // ============================================================================
  // DERIVED DATA
  // ============================================================================
  const gateways = withdrawData?.gateways || [];
  const currencies =
    withdrawData?.gateways?.flatMap((g) => g.currencies || []) || [];
  const userBalance = withdrawData?.userWallet?.balance?.toFixed(4) || "--";
  const baseCurrency = withdrawData?.base_curr || "";

  const chargeText = selectedGatewayCurrency
    ? (() => {
        const fixed = Number(selectedGatewayCurrency.fixed_charge) || 0;
        const rate = Number(selectedGatewayCurrency.rate) || 1;
        const convertedFixed = rate > 0 ? fixed / rate : 0;
        const percent = Number(selectedGatewayCurrency.percent_charge) || 0;
        return `${convertedFixed.toFixed(4)} ${baseCurrency} + ${percent.toFixed(4)}%`;
      })()
    : "--";

  // ============================================================================
  // DATA FETCHING
  // ============================================================================
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        const response = await getWithdrawInfo();

        if (response?.data) {
          setWithdrawData(response.data);

          // Auto-select first available currency only if nothing is selected yet
          if (
            !selectedGatewayCurrency &&
            response.data.gateways?.[0]?.currencies?.[0]
          ) {
            const first = response.data.gateways[0].currencies[0];
            setSelectedGatewayCurrency(first);
            setSelectedCurrencyCode(first.currency_code);
          }
        } else if (response?.message?.error) {
          const errorMsg =
            response.message.error[0] || t("errors.loadDataFailed");
          toast.error(errorMsg);
        }
      } catch (err) {
        toast.error(t("errors.loadInfoFailed"));
        // console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [selectedGatewayCurrency, setSelectedGatewayCurrency]);

  // ============================================================================
  // SYNC CURRENCY CODE WITH SELECTED GATEWAY
  // ============================================================================
  useEffect(() => {
    if (selectedGatewayCurrency?.currency_code) {
      setSelectedCurrencyCode(selectedGatewayCurrency.currency_code);
    }
  }, [selectedGatewayCurrency]);

  // ============================================================================
  // FORM SUBMISSION
  // ============================================================================
  const handleConfirm = async () => {
    // Validation
    if (!amount || Number(amount) <= 0) {
      return toast.error(t("errors.invalidAmount"));
    }

    if (!selectedGatewayCurrency) {
      return toast.error(t("errors.selectGateway"));
    }

    setSubmitLoading(true);

    const payload = {
      gateway: selectedGatewayCurrency.alias,
      amount: amount.trim(),
    };

    try {
      const response = await submitWithdrawInsert(payload);

      if (response?.message?.success) {
        const successMsg =
          response.message.success[0] || t("success.initiated");
        toast.success(successMsg);

        // Store data for next step
        sessionStorage.setItem(
          "pendingWithdrawData",
          JSON.stringify({
            trx: response.data.payment_informations?.trx,
            gateway_currency_name: response.data.gateway_currency_name,
            request_amount: response.data.payment_informations?.request_amount,
            exchange_rate: response.data.payment_informations?.exchange_rate,
            conversion_amount:
              response.data.payment_informations?.conversion_amount,
            total_charge: response.data.payment_informations?.total_charge,
            payable: response.data.payment_informations?.payable,
            will_get: response.data.payment_informations?.will_get,
            input_fields: response.data.input_fields || [],
            confirmation_url: response.data.url,
            method: response.data.method,
            details: response.data.details || "",
            currency_alias: selectedGatewayCurrency.alias,
          }),
        );

        router.push("/dashboard/ManualWithdraw");
      } else if (response?.message?.error) {
        const errorMsg =
          response.message.error[0] || t("errors.withdrawFailed");
        toast.error(errorMsg);
      }
    } catch (err) {
      toast.error(t("errors.genericError"));
      // console.error("Withdraw insert error:", err);
    } finally {
      setSubmitLoading(false);
    }
  };

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
      <div className="p-6 space-y-7 flex flex-col min-h-[400px]">
        {/* Payment Gateway */}
        <div>
          <label className="mb-2 block text-sm font-medium text-gray-600 dark:text-gray-400">
            {t("fields.gateway.label")} <span className="text-red-500">*</span>
          </label>

          <Listbox
            value={selectedGatewayCurrency}
            onChange={setSelectedGatewayCurrency}
          >
            {({ open }) => (
              <div className="relative">
                <Listbox.Button className="relative w-full rounded-xl border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-800 px-4 py-2.5 text-left text-sm text-gray-900 dark:text-gray-100 hover:bg-gray-100 dark:hover:bg-gray-700 focus:border-primary-500 focus:outline-none focus:ring-primary-200 dark:focus:ring-primary-500/30 cursor-pointer">
                  <span className="block truncate">
                    {selectedGatewayCurrency?.name ||
                      t("fields.gateway.placeholder")}
                  </span>
                  <span className="pointer-events-none absolute inset-y-0 right-3 flex items-center">
                    <ChevronDown
                      className={`h-5 w-5 text-gray-400 dark:text-gray-500 transition-transform ${
                        open ? "rotate-180" : ""
                      }`}
                    />
                  </span>
                </Listbox.Button>

                <Listbox.Options className="absolute z-10 mt-2 w-full rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-lg max-h-60 overflow-auto">
                  {currencies.map((currency) => (
                    <Listbox.Option
                      key={currency.id}
                      value={currency}
                      className={({ active, selected }) =>
                        `cursor-pointer px-4 py-2.5 text-sm ${
                          active
                            ? "bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400"
                            : selected
                              ? "bg-gray-100 dark:bg-gray-700 font-medium text-gray-900 dark:text-gray-100"
                              : "text-gray-700 dark:text-gray-300"
                        }`
                      }
                    >
                      {currency.name}
                    </Listbox.Option>
                  ))}
                </Listbox.Options>
              </div>
            )}
          </Listbox>
        </div>

        {/* Amount */}
        <div>
          <label className="mb-2 block text-sm font-medium text-gray-600 dark:text-gray-400">
            {t("fields.amount.label")} <span className="text-red-500">*</span>
          </label>

          <div className="relative rounded-xl border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-800 focus-within:border-primary-500 focus-within:ring-primary-200 dark:focus-within:ring-primary-500/30">
            <div className="flex overflow-visible">
              <input
                type="number"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                placeholder={t("fields.amount.placeholder")}
                className="flex-1 bg-transparent px-4 py-2.5 text-sm text-gray-900 dark:text-gray-100 focus:outline-none no-spinner"
              />

              <Listbox
                value={selectedCurrencyCode}
                onChange={setSelectedCurrencyCode}
              >
                {({ open }) => (
                  <div className="relative min-w-24">
                    <Listbox.Button className="flex h-full w-full items-center justify-center px-4 py-2.5 text-sm text-gray-900 dark:text-gray-100 focus:outline-none cursor-pointer">
                      <span className="mr-2 font-medium">
                        {baseCurrency}
                      </span>
                      <ChevronDown
                        className={`h-5 w-5 text-gray-400 dark:text-gray-500 transition-transform duration-200 ${
                          open ? "rotate-180" : ""
                        }`}
                      />
                    </Listbox.Button>

                    <Listbox.Options className="absolute right-0 top-full z-30 mt-1 w-32 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 py-1 shadow-lg">
                      {currencies.map((curr) => (
                        <Listbox.Option
                          key={curr.id}
                          value={curr.currency_code}
                          className={({ active }) =>
                            `relative cursor-pointer select-none px-4 py-2 text-sm ${
                              active
                                ? "bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400"
                                : "text-gray-900 dark:text-gray-100"
                            }`
                          }
                        >
                          <span className="block font-medium">
                            {baseCurrency}
                          </span>
                        </Listbox.Option>
                      ))}
                    </Listbox.Options>
                  </div>
                )}
              </Listbox>
            </div>
          </div>
        </div>

        {/* Info Box */}
        <div className="rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3 text-sm space-y-2">
          <p className="flex justify-between text-gray-600 dark:text-gray-400">
            <span>{t("info.availableBalance")}</span>
            <span className="font-medium text-gray-800 dark:text-gray-200">
              {userBalance} {baseCurrency}
            </span>
          </p>

          <p className="flex justify-between text-gray-600 dark:text-gray-400">
            <span>{t("info.charge")}</span>
            <span className="font-medium text-gray-800 dark:text-gray-200">
              {chargeText}
            </span>
          </p>
        </div>

        {/* Spacer */}
        <div className="flex-1" />

        {/* Divider */}
        <div className="border-t border-dashed border-gray-200 dark:border-gray-700" />

        {/* Action Button */}
        <div className="space-y-3">
          <button
            onClick={handleConfirm}
            disabled={submitLoading}
            className={`
            w-full rounded-xl px-4 py-4 text-base font-bold text-white transition cursor-pointer
            btn-primary
            hover:opacity-90
            ${submitLoading ? "opacity-70 cursor-wait" : ""}
            disabled:opacity-50 disabled:cursor-not-allowed
            focus:outline-none focus:ring-2 focus:ring-primary-400 dark:focus:ring-primary-500 focus:ring-offset-2 dark:focus:ring-offset-gray-900`}
          >
            {submitLoading ? t("button.processing") : t("button.confirm")}
          </button>
        </div>
      </div>
    </div>
  );
}

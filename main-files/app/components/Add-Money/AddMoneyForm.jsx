/* eslint-disable react-hooks/exhaustive-deps */
"use client";

import { Listbox } from "@headlessui/react";
import { ChevronDown } from "lucide-react";
import { useTranslations } from "next-intl";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { getAddMoneyInformation, submitAddMoney } from "../../utils/api";

// ============================================================================
// MAIN COMPONENT
// ============================================================================
export default function AddMoneyForm({ onFormUpdate }) {
  const router = useRouter();
  const t = useTranslations("addMoney"); // ← namespace: "addMoney"

  // --------------------------------------------------------------------------
  // State Management
  // --------------------------------------------------------------------------
  const [loading, setLoading] = useState(true);
  const [submitLoading, setSubmitLoading] = useState(false);

  // Gateway & Form Data
  const [gatewayOptions, setGatewayOptions] = useState([]);
  const [selectedGateway, setSelectedGateway] = useState(null);
  const [amount, setAmount] = useState("");

  // Wallet Information
  const [walletCurrency, setWalletCurrency] = useState("USD");
  const [balance, setBalance] = useState(null);

  // Charge Information
  const [fixedCharge, setFixedCharge] = useState(null);
  const [percentCharge, setPercentCharge] = useState(null);
  const [chargeCurrency, setChargeCurrency] = useState("");

  // --------------------------------------------------------------------------
  // Notify Parent Component (Preview Update)
  // --------------------------------------------------------------------------
  const notifyParent = () => {
    if (onFormUpdate) {
      onFormUpdate({
        amount,
        walletCurrency,
        selectedGateway,
        fixedCharge,
        percentCharge,
        chargeCurrency,
        rate: selectedGateway?.rate || 1,
      });
    }
  };

  // Update parent when form data changes
  useEffect(() => {
    notifyParent();
  }, [
    amount,
    selectedGateway,
    walletCurrency,
    fixedCharge,
    percentCharge,
    chargeCurrency,
  ]);

  // Update parent after initial data load
  useEffect(() => {
    if (!loading && selectedGateway) {
      notifyParent();
    }
  }, [loading, selectedGateway]);

  // --------------------------------------------------------------------------
  // Fetch Payment Gateway Information
  // --------------------------------------------------------------------------
  useEffect(() => {
    async function loadAddMoneyInfo() {
      try {
        setLoading(true);
        const response = await getAddMoneyInformation();

        if (response?.message?.error) {
          const errorMsg = response.message.error[0] || t("errors.loadFailed");
          toast.error(errorMsg);
          setLoading(false);
          return;
        }

        const data = response.data || response;

        // Flatten gateways into options
        const options = [];
        (data.gateways || []).forEach((gw) => {
          (gw.currencies || []).forEach((curr) => {
            options.push({
              id: curr.id,
              name: curr.name,
              alias: curr.alias,
              fixed_charge: Number(curr.fixed_charge) || 0,
              percent_charge: Number(curr.percent_charge) || 0,
              min_limit: Number(curr.min_limit) || 0,
              max_limit: Number(curr.max_limit) || 0,
              daily_limit: Number(curr.daily_limit) || 0,
              monthly_limit: Number(curr.monthly_limit) || 0,
              currency_code: curr.currency_code || "N/A",
              currency_symbol: curr.currency_symbol || "N/A",
              rate: Number(curr.rate) || 1,
            });
          });
        });

        setGatewayOptions(options);

        // Set default gateway (prefer matching wallet currency)
        if (options.length > 0) {
          const defaultGateway =
            options.find(
              (opt) => opt.currency_code === data.userWallet?.currency,
            ) || options[0];

          setSelectedGateway(defaultGateway);
          setFixedCharge(defaultGateway.fixed_charge);
          setPercentCharge(defaultGateway.percent_charge);
          setChargeCurrency(defaultGateway.currency_code);
        }

        // Set wallet currency & balance
        setWalletCurrency(data.userWallet?.currency || "USD");
        setBalance(data.userWallet?.balance || 0);

        setLoading(false);
      } catch (err) {
        const errorMsg = err.message || t("errors.loadGeneric");
        toast.error(errorMsg);
        setLoading(false);
      }
    }

    loadAddMoneyInfo();
  }, []);

  // --------------------------------------------------------------------------
  // Update Charges When Gateway Changes
  // --------------------------------------------------------------------------
  useEffect(() => {
    if (selectedGateway) {
      setFixedCharge(selectedGateway.fixed_charge);
      setPercentCharge(selectedGateway.percent_charge);
      setChargeCurrency(selectedGateway.currency_code || "N/A");
    }
  }, [selectedGateway]);

  // --------------------------------------------------------------------------
  // Helper Functions
  // --------------------------------------------------------------------------
  const formatCharge = () => {
    if (!selectedGateway || fixedCharge === null || percentCharge === null) {
      return "--";
    }
    const fixed = fixedCharge.toFixed(4);
    const percent = percentCharge.toFixed(4);
    return `${fixed} ${chargeCurrency} + ${percent}%`;
  };

  // --------------------------------------------------------------------------
  // Form Validation & Submit Handler
  // --------------------------------------------------------------------------
  const handleConfirm = async () => {
    // Validate gateway selection
    if (!selectedGateway) {
      toast.error(t("errors.selectGateway"));
      return;
    }

    // Validate amount
    if (!amount || Number(amount) <= 0) {
      toast.error(t("errors.invalidAmount"));
      return;
    }

    // Validate gateway alias
    if (!selectedGateway.alias) {
      toast.error(t("errors.selectGateway"));
      return;
    }

    setSubmitLoading(true);

    try {
      const payload = {
        amount: amount,
        currency: selectedGateway.alias,
      };

      const response = await submitAddMoney(payload);

      // Handle error response
      if (response?.message?.error) {
        toast.error(response.message.error[0] || t("errors.submitFailed"));
        return;
      }

      // Show success message
      toast.success(response.message?.success?.[0] || t("success.submitted"));

      // Handle Automatic Gateway Redirect
      if (response.data?.gateway_type === "AUTOMATIC") {
        if (Array.isArray(response.data?.url)) {
          // PayPal-style HATEOAS links
          const approveLink = response.data.url.find(
            (link) => link.rel === "approve",
          );

          if (approveLink?.href) {
            window.location.href = approveLink.href;
          } else {
            toast.error(t("errors.approvalLinkUnavailable"));
          }
        } else if (
          typeof response.data?.url === "string" &&
          response.data.url
        ) {
          // Standard automatic gateway with plain URL
          window.location.href = response.data.url;
        } else {
          toast.error(t("errors.invalidGatewayResponse"));
        }
      }
      // Handle Manual Gateway - Redirect to Manual Payment Page
      else {
        // Prepare manual payment data
        const manualPaymentData = {
          trx: response.data?.payment_informations?.trx || "",
          gateway_currency_name: response.data?.gateway_currency_name || "",
          details: response.data?.details || "",
          input_fields: response.data?.input_fields || [],
          payment_informations: response.data?.payment_informations || {},
          submit_url: response.data?.url || "",
          method: response.data?.method?.toUpperCase() || "POST",
        };

        // Save to sessionStorage for manual payment page
        sessionStorage.setItem(
          "pendingManualPayment",
          JSON.stringify(manualPaymentData),
        );

        // Navigate to manual payment form
        router.push("/dashboard/ManualPayment");
      }
    } catch (err) {
      const errorMsg = err.message || t("errors.processGeneric");
      toast.error(errorMsg);
    } finally {
      setSubmitLoading(false);
    }
  };

  // --------------------------------------------------------------------------
  // Main Render
  // --------------------------------------------------------------------------
  return (
    <div>
      <div className="w-full rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
        {/* Form Header */}
        <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 backdrop-blur px-6 py-5">
          <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-100 text-center tracking-tight">
            {t("title")}
          </h2>
        </div>

        {/* Form Body */}
        <div className="flex flex-col space-y-7 p-6">
          {/* Payment Gateway Selection */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-600 dark:text-gray-300">
              {t("fields.gateway.label")}{" "}
              <span className="text-red-500">*</span>
            </label>

            <Listbox
              value={selectedGateway}
              onChange={setSelectedGateway}
              disabled={loading || gatewayOptions.length === 0}
            >
              {({ open }) => (
                <div className="relative">
                  <Listbox.Button className="cursor-pointer relative w-full rounded-xl border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-800 px-4 py-2.5 text-left text-sm text-gray-900 dark:text-gray-100 hover:bg-white dark:hover:bg-gray-700 focus:border-blue-500 dark:focus:border-blue-500 focus:outline-none focus:ring-blue-200 dark:focus:ring-blue-500/30 disabled:opacity-50 disabled:cursor-not-allowed">
                    <span className="block truncate">
                      {selectedGateway
                        ? selectedGateway.name
                        : t("fields.gateway.placeholder")}
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
                    {gatewayOptions.map((item) => (
                      <Listbox.Option
                        key={item.id}
                        value={item}
                        className={({ active, selected }) =>
                          `cursor-pointer px-4 py-2.5 text-sm ${
                            active
                              ? "bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400"
                              : selected
                                ? "bg-gray-100 dark:bg-gray-700 font-medium text-gray-900 dark:text-gray-100"
                                : "text-gray-700 dark:text-gray-300"
                          }`
                        }
                      >
                        {item.name}
                      </Listbox.Option>
                    ))}
                  </Listbox.Options>
                </div>
              )}
            </Listbox>
          </div>

          {/* Amount Input with Currency Selector */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-600 dark:text-gray-300">
              {t("fields.amount.label")} <span className="text-red-500">*</span>
            </label>

            <div className="relative rounded-xl border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-800 focus-within:border-blue-500 dark:focus-within:border-blue-500 focus-within:ring-blue-200 dark:focus-within:ring-blue-500/30">
              <div className="flex overflow-visible">
                <input
                  type="number"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                  placeholder={t("fields.amount.placeholder")}
                  className="flex-1 bg-transparent px-4 py-2.5 text-sm text-gray-900 dark:text-gray-100 focus:outline-none no-spinner"
                />

                <Listbox value={walletCurrency} onChange={() => {}}>
                  {({ open }) => (
                    <div className="relative min-w-24">
                      <Listbox.Button className="cursor-pointer flex h-full w-full items-center justify-center px-4 py-2.5 text-sm text-gray-900 dark:text-gray-100 focus:outline-none">
                        <span className="mr-2 font-medium">
                          {walletCurrency}
                        </span>
                        <ChevronDown
                          className={`h-5 w-5 text-gray-400 dark:text-gray-500 transition-transform ${
                            open ? "rotate-180" : ""
                          }`}
                        />
                      </Listbox.Button>

                      <Listbox.Options className="absolute right-0 top-full z-30 mt-1 w-32 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 py-1 shadow-lg">
                        <Listbox.Option
                          value={walletCurrency}
                          className={({ active }) =>
                            `relative cursor-pointer select-none px-4 py-2 text-sm ${
                              active
                                ? "bg-blue-50 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400"
                                : "text-gray-900 dark:text-gray-100"
                            }`
                          }
                        >
                          <span className="block font-medium">
                            {walletCurrency}
                          </span>
                        </Listbox.Option>
                      </Listbox.Options>
                    </div>
                  )}
                </Listbox>
              </div>
            </div>
          </div>

          {/* Information Box */}
          <div className="space-y-2 rounded-xl bg-gray-50 dark:bg-gray-800/60 px-4 py-3 text-sm">
            <p className="flex justify-between text-gray-600 dark:text-gray-300">
              <span>{t("info.availableBalance")}</span>
              <span className="font-medium text-gray-800 dark:text-gray-200">
                {balance !== null
                  ? `${Number(balance).toFixed(4)} ${walletCurrency}`
                  : "--"}
              </span>
            </p>
            <p className="flex justify-between text-gray-600 dark:text-gray-300">
              <span>{t("info.charge")}</span>
              <span className="font-medium text-gray-800 dark:text-gray-200">
                {formatCharge()}
              </span>
            </p>
          </div>

          {/* Spacer */}
          <div className="flex-1" />

          {/* Divider */}
          <div className="border-t border-dashed border-gray-200 dark:border-gray-700" />

          {/* Submit Button */}
          <button
            onClick={handleConfirm}
            disabled={submitLoading}
            className="cursor-pointer w-full rounded-xl px-4 py-4 text-base font-bold text-white transition bg-[linear-gradient(76.84deg,#2563EB_-2.66%,#3B82F6_105.87%)] dark:bg-[linear-gradient(76.84deg,#1D4ED8_-2.66%,#2563EB_105.87%)] hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-blue-400 dark:focus:ring-blue-500 focus:ring-offset-2 dark:focus:ring-offset-gray-900 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {submitLoading ? t("button.processing") : t("button.confirm")}
          </button>
        </div>
      </div>
    </div>
  );
}

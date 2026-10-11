"use client";

import { useEffect, useMemo, useState } from "react";
import Select from "react-select";
import { getSudoCards } from "../../utils/api";

export default function CreateVirtualCard() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [amount, setAmount] = useState("");
  const [selectedCurrency, setSelectedCurrency] = useState(null);
  const [selectedWallet, setSelectedWallet] = useState(null);
  const [extraValues, setExtraValues] = useState({});

  useEffect(() => {
    let mounted = true;

    async function load() {
      try {
        const res = await getSudoCards();
        if (!mounted) return;

        const apiData = res.data;
        setData(apiData);

        // Default currency
        const defaultCurrency = apiData.supported_currency.find(
          (c) => c.currency_code === apiData.base_curr,
        );
        if (defaultCurrency) {
          setSelectedCurrency({
            value: defaultCurrency.currency_code,
            label: defaultCurrency.currency_code,
            rate: defaultCurrency.rate,
            symbol: defaultCurrency.currency_symbol,
          });
        }

        // Default wallet
        if (apiData.userWallet?.length > 0) {
          const w = apiData.userWallet[0];
          setSelectedWallet({
            value: w.currency.code,
            label: `${w.currency.name} (${w.balance.toFixed(4)} ${w.currency.code})`,
            balance: w.balance,
            code: w.currency.code,
          });
        }

        // Init extra fields
        const init = {};
        apiData.card_extra_fields.forEach((f) => {
          init[f.field_name] = f.value || "";
        });
        setExtraValues(init);
      } catch (err) {
        if (mounted) setError("Failed to load card creation data");
      } finally {
        if (mounted) setLoading(false);
      }
    }

    load();

    return () => {
      mounted = false;
    };
  }, []);

  const charge = useMemo(() => {
    if (!data?.cardCharge) return { fee: 0, total: 0 };
    const num = Number(amount) || 0;
    const fixed = data.cardCharge.fixed_charge;
    const percent = data.cardCharge.percent_charge;
    const fee = fixed + (num * percent) / 100;
    return { fee, total: num + fee };
  }, [amount, data?.cardCharge]);

  const selectStyles = useMemo(
    () => ({
      control: (base, state) => ({
        ...base,
        background: "#ffffff",
        borderColor: state.isFocused ? "#10b981" : "#d1d5db",
        borderWidth: "1.5px",
        borderRadius: "10px",
        padding: "4px 2px",
        boxShadow: state.isFocused
          ? "0 0 0 3px rgba(16, 185, 129, 0.15)"
          : "none",
        "&:hover": { borderColor: "#10b981" },
      }),
      option: (base, state) => ({
        ...base,
        backgroundColor: state.isFocused ? "#ecfdf5" : "#ffffff",
        color: "#111827", // darker text in dropdown
        padding: "10px 14px",
        "&:active": { backgroundColor: "#d1fae5" },
      }),
      menu: (base) => ({
        ...base,
        borderRadius: "10px",
        border: "1px solid #d1d5db",
        boxShadow: "0 10px 25px -5px rgba(0,0,0,0.12)",
      }),
      singleValue: (base) => ({
        ...base,
        color: "#111827", 
      }),
      menuPortal: (base) => ({
        ...base,
        zIndex: 9999,
      }),
    }),
    [],
  );

  // Portal the dropdown menu to <body> so it isn't clipped/hidden by
  // parent containers (overflow / stacking context).
  const menuPortalTarget =
    typeof document !== "undefined" ? document.body : undefined;

  if (loading) {
    return (
      <div className="min-h-[60vh] flex items-center justify-center">
        <div className="text-gray-600 font-medium animate-pulse">
          Loading card creation form...
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="min-h-[60vh] flex items-center justify-center text-red-700 font-medium">
        {error || "Failed to load data"}
      </div>
    );
  }

  const baseCurrency = data.base_curr;
  const hasExtraFields = data.card_extra_fields?.length > 0;

  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
      {/* ── LEFT ── Form ──────────────────────────────────────── */}
      <div className="lg:col-span-6 bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
        <h2 className="text-2xl font-bold text-gray-900 text-center mb-8">
          Create Virtual Card
        </h2>

        {/* 1. Dynamic extra fields – first – in responsive grid */}
        {hasExtraFields && (
          <div
            className={`grid gap-6 mb-8 ${data.card_extra_fields.length >= 2 ? "md:grid-cols-2" : "grid-cols-1"}`}
          >
            {data.card_extra_fields.map((field) => (
              <div key={field.id}>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">
                  {field.label_name}
                  {field.value === "" && (
                    <span className="text-red-600 ml-1">*</span>
                  )}
                </label>

                {field.type === "select" ? (
                  <Select
                    value={(() => {
                      const sel = field.options?.find(
                        (o) => o.value === extraValues[field.field_name],
                      );
                      return sel
                        ? { value: sel.value, label: sel.name }
                        : null;
                    })()}
                    onChange={(opt) =>
                      setExtraValues((prev) => ({
                        ...prev,
                        [field.field_name]: opt ? opt.value : "",
                      }))
                    }
                    options={field.options?.map((o) => ({
                      value: o.value,
                      label: o.name,
                    }))}
                    placeholder={field.place_holder}
                    styles={selectStyles}
                    menuPortalTarget={menuPortalTarget}
                    isSearchable={false}
                  />
                ) : (
                  <input
                    type={field.type}
                    value={extraValues[field.field_name] ?? ""}
                    onChange={(e) =>
                      setExtraValues((prev) => ({
                        ...prev,
                        [field.field_name]: e.target.value,
                      }))
                    }
                    placeholder={field.place_holder}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-emerald-400 text-gray-900 placeholder-gray-400 no-spinner"
                  />
                )}
              </div>
            ))}
          </div>
        )}

        {/* 2. Card Amount – full width */}
        <div className="mb-6">
          <label className="block text-sm font-semibold text-gray-800 mb-1.5">
            Card Amount <span className="text-red-600">*</span>
          </label>
          <div className="flex border border-gray-300 rounded-lg focus-within:border-emerald-400 focus-within:ring-1 focus-within:ring-emerald-400 transition-all">
            <input
              type="number"
              min="0"
              step="0.01"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="Enter Amount"
              className="flex-1 px-4 py-2.5 text-gray-900 bg-transparent focus:outline-none text-base no-spinner"
            />
            <div className="w-28 border-gray-200">
              <Select
                value={selectedCurrency}
                onChange={(v) => setSelectedCurrency(v)}
                options={data.supported_currency.map((c) => ({
                  value: c.currency_code,
                  label: c.currency_code,
                  rate: c.rate,
                  symbol: c.currency_symbol,
                }))}
                styles={selectStyles}
                menuPortalTarget={menuPortalTarget}
                isSearchable={false}
              />
            </div>
          </div>
        </div>

        {/* 3. From Wallet – full width */}
        <div className="mb-7">
          <label className="block text-sm font-semibold text-gray-800 mb-1.5">
            From Wallet <span className="text-red-600">*</span>
          </label>
          <Select
            value={selectedWallet}
            onChange={(v) => setSelectedWallet(v)}
            options={data.userWallet.map((w) => ({
              value: w.currency.code,
              label: `${w.currency.name} (${w.balance.toFixed(4)} ${w.currency.code})`,
              balance: w.balance,
              code: w.currency.code,
            }))}
            styles={selectStyles}
            menuPortalTarget={menuPortalTarget}
          />
        </div>

        {/* 4. Fee + Available info */}
        <div className="bg-emerald-50/70 border border-emerald-100 rounded-lg p-5 text-sm mb-8">
          <div className="flex justify-between mb-2 text-gray-700 font-medium">
            <span>Fees:</span>
            <span className="text-gray-800">
              {data.cardCharge.fixed_charge.toFixed(4)} {baseCurrency} +{" "}
              {data.cardCharge.percent_charge.toFixed(4)}% ={" "}
              {charge.fee.toFixed(4)} {baseCurrency}
            </span>
          </div>
          <div className="flex justify-between text-gray-800 font-semibold">
            <span>Available Balance:</span>
            <span>
              {selectedWallet?.balance.toFixed(4) ?? "—"}{" "}
              {selectedWallet?.code ?? baseCurrency}
            </span>
          </div>
        </div>

        {/* 5. Confirm button */}
        <button className="w-full py-3.5 btn-primary text-white font-semibold text-base rounded-xl transition-colors shadow-sm">
          Confirm
        </button>
      </div>

      {/* ── RIGHT ── Preview + Limits ─────────────────────────── */}
      <div className="lg:col-span-6 space-y-6">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
          <h3 className="text-2xl font-bold text-gray-900 text-center mb-5">
            Preview
          </h3>
          <div className="space-y-3.5 text-sm">
            <div className="flex justify-between text-gray-700">
              <span>Card Amount</span>
              <span className="font-semibold text-gray-900">
                {amount || "0.0000"} {selectedCurrency?.label ?? baseCurrency}
              </span>
            </div>
            <div className="flex justify-between text-gray-700">
              <span>Exchange Rate</span>
              <span className="text-gray-800">
                1 {baseCurrency} = {(selectedCurrency?.rate ?? 1).toFixed(6)}{" "}
                {selectedCurrency?.label ?? baseCurrency}
              </span>
            </div>
            <div className="flex justify-between text-gray-700">
              <span>Total Charge</span>
              <span className="text-gray-800">
                {charge.fee.toFixed(4)} {baseCurrency}
              </span>
            </div>
            <div className="pt-4 border-t border-gray-200 font-semibold flex justify-between text-base">
              <span className="text-gray-800">Total Payable Amount</span>
              <span className="text-emerald-700">
                {charge.total.toFixed(4)} {baseCurrency}
              </span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
          <h3 className="text-2xl font-bold text-gray-900 text-center mb-5">
            Limit Information
          </h3>
          <div className="space-y-3.5 text-sm">
            <div className="flex justify-between text-gray-700">
              <span>Transaction Limit</span>
              <span className="font-medium text-gray-800">
                {data.cardCharge.min_limit.toFixed(4)} {baseCurrency} –{" "}
                {data.cardCharge.max_limit.toFixed(4)} {baseCurrency}
              </span>
            </div>
            <div className="flex justify-between text-gray-700">
              <span>Daily</span>
              <span className="font-medium text-gray-800">
                {data.cardCharge.daily_limit.toFixed(4)} {baseCurrency}
              </span>
            </div>
            <div className="flex justify-between text-emerald-700 font-semibold">
              <span>Remaining Daily</span>
              <span>
                {data.cardCharge.daily_limit.toFixed(4)} {baseCurrency}
              </span>
            </div>
            <div className="flex justify-between text-gray-700">
              <span>Monthly</span>
              <span className="font-medium text-gray-800">
                {data.cardCharge.monthly_limit.toFixed(4)} {baseCurrency}
              </span>
            </div>
            <div className="pt-4 border-t border-gray-200 font-semibold flex justify-between text-emerald-700">
              <span>Remaining Monthly</span>
              <span>
                {data.cardCharge.monthly_limit.toFixed(4)} {baseCurrency}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

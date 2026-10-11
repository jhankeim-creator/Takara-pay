"use client";

import { useEffect, useState } from "react";
import Select from "react-select";
import { getStripeCards } from "../../utils/api";

export default function CreateVirtualCard() {
  const [loading, setLoading] = useState(true);
  const [apiData, setApiData] = useState(null);
  const [error, setError] = useState(null);

  const [amount, setAmount] = useState("");
  const [currency, setCurrency] = useState({ value: "USD", label: "USD" });
  const [wallet, setWallet] = useState(null);

  const [currencyOptions, setCurrencyOptions] = useState([]);
  const [walletOptions, setWalletOptions] = useState([]);

  const selectStyles = {
    control: (base, state) => ({
      ...base,
      background: "#ffffff",
      borderColor: state.isFocused ? "#34d399" : "#e5e7eb",
      borderWidth: "1.5px",
      borderRadius: "10px",
      padding: "6px 4px",
      cursor: "pointer",
      boxShadow: state.isFocused ? "0 0 0 3px rgba(37, 99, 235, 0.1)" : "none",
      transition: "all 0.2s ease",
      "&:hover": {
        borderColor: "#34d399",
      },
    }),
    option: (base, state) => ({
      ...base,
      backgroundColor: state.isFocused ? "#ecfdf5" : "#ffffff",
      color: "#1f2937",
      padding: "12px 16px",
      cursor: "pointer",
      transition: "all 0.15s ease",
      "&:active": {
        backgroundColor: "#ecfdf5",
      },
    }),
    menu: (base) => ({
      ...base,
      borderRadius: "10px",
      overflow: "hidden",
      boxShadow:
        "0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)",
      border: "1.5px solid #e5e7eb",
    }),
    placeholder: (base) => ({
      ...base,
      color: "#9ca3af",
      fontSize: "15px",
    }),
    singleValue: (base) => ({
      ...base,
      color: "#1f2937",
      fontSize: "15px",
    }),
  };

  // Fetch API Data
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      const result = await getStripeCards();

      if (result?.data) {
        setApiData(result.data);

        // Currency Options
        const currOptions = result.data.supported_currency.map((curr) => ({
          value: curr.currency_code,
          label: curr.currency_code,
        }));
        setCurrencyOptions(currOptions);

        if (currOptions.length > 0) {
          setCurrency(currOptions[0]);
        }

        // Wallet Options
        const wallOptions = result.data.userWallet.map((w) => ({
          value: `${w.currency.code.toLowerCase()}_wallet`,
          label: `${w.currency.name} (${parseFloat(w.balance).toFixed(4)} ${w.currency.code})`,
        }));
        setWalletOptions(wallOptions);

        if (wallOptions.length > 0) {
          setWallet(wallOptions[0]);
        }
      } else {
        setError(result?.message?.error?.[0] || "Failed to load data");
      }

      setLoading(false);
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <div className="text-center py-10 text-gray-600">
        Loading Virtual Card Data...
      </div>
    );
  }

  if (error || !apiData) {
    return (
      <div className="text-red-500 text-center py-10">
        {error || "Something went wrong"}
      </div>
    );
  }

  const cardCharge = apiData.cardCharge;
  const userWallet = apiData.userWallet[0];

  const fixedCharge = parseFloat(cardCharge?.fixed_charge) || 2;
  const percentCharge = parseFloat(cardCharge?.percent_charge) || 1;
  const enteredAmount = parseFloat(amount) || 0;
  const calculatedFee = enteredAmount * (percentCharge / 100) + fixedCharge;
  const totalPayable = enteredAmount + calculatedFee;

  return (
    <>
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Section */}
        <div className="lg:col-span-6 bg-white rounded-2xl shadow-md p-6">
          <h2 className="text-2xl text-gray-700 font-semibold text-center mb-6">
            Create Virtual Card
          </h2>

          {/* Card Amount */}
          <div className="mb-5">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Card Amount <span className="text-red-500">*</span>
            </label>

            <div className="flex rounded-lg border border-gray-300 focus-within:border-emerald-400 transition-colors">
              <input
                type="number"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                placeholder="Enter Amount"
                className="text-gray-700 w-full px-4 py-2.5 focus:outline-none text-sm no-spinner"
              />

              <div className="min-w-[100px] flex-1 border-gray-300">
                <Select
                  value={currency}
                  onChange={setCurrency}
                  options={currencyOptions}
                  styles={selectStyles}
                  isSearchable={false}
                />
              </div>
            </div>
          </div>

          {/* From Wallet */}
          <div className="mb-5">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              From Wallet <span className="text-red-500">*</span>
            </label>

            <Select
              value={wallet}
              onChange={setWallet}
              options={walletOptions}
              styles={selectStyles}
            />
          </div>

          {/* Info Box */}
          <div className="bg-emerald-50 border border-emerald-200 rounded-lg p-4 text-sm text-gray-700 mb-6">
            <p>
              Fees: {fixedCharge.toFixed(4)} USD + {percentCharge.toFixed(4)}% ={" "}
              {calculatedFee.toFixed(4)} USD
            </p>
            <p className="mt-1">
              Available Balance:{" "}
              {parseFloat(userWallet?.balance || 0).toFixed(4)}{" "}
              {userWallet?.currency.code}
            </p>
          </div>

          {/* Confirm Button */}
          <button
            onClick={() => {
              if (!amount || parseFloat(amount) <= 0) {
                alert("Please enter a valid amount");
                return;
              }
              // Todo: will call the POST API here later
              console.log("Creating Stripe Virtual Card:", {
                amount: parseFloat(amount),
                currency: currency.value,
                wallet: wallet?.value,
              });
              alert(
                "Confirm clicked! will call the POST API here later",
              );
            }}
            disabled={!amount || parseFloat(amount) <= 0}
            className="mt-24 w-full btn-primary text-white py-3 rounded-lg font-medium hover:bg-emerald-700 transition disabled:opacity-50"
          >
            Confirm
          </button>
        </div>

        {/* Right Section - Preview + Limits */}
        <div className="lg:col-span-6 flex flex-col gap-6">
          {/* Preview */}
          <div className="bg-white rounded-2xl shadow-md p-6">
            <h3 className="text-2xl text-center text-gray-700 font-semibold mb-5">
              Preview
            </h3>

            <div className="space-y-4 text-sm">
              {/* Card Amount - 4 decimal places */}
              <div className="flex justify-between">
                <span className="text-gray-600">Card Amount</span>
                <span className="font-medium text-gray-700">
                  {(parseFloat(amount) || 0).toFixed(4)}{" "}
                  {currency?.label || "USD"}
                </span>
              </div>

              {/* Exchange Rate - Dynamic from API */}
              <div className="flex justify-between">
                <span className="text-gray-600">Exchange Rate</span>
                <span className="text-gray-700">
                  1 {apiData?.base_curr || "USD"} ={" "}
                  {(apiData?.base_curr_rate || 1).toFixed(8)}{" "}
                  {apiData?.base_curr || "USD"}
                </span>
              </div>

              {/* Total Charge */}
              <div className="flex justify-between">
                <span className="text-gray-600">Total Charge</span>
                <span className="text-gray-700">
                  {amount && parseFloat(amount) > 0
                    ? (
                        parseFloat(amount) *
                          (parseFloat(
                            apiData?.cardCharge?.percent_charge || 1,
                          ) /
                            100) +
                        parseFloat(apiData?.cardCharge?.fixed_charge || 2)
                      ).toFixed(4)
                    : "0.0000"}{" "}
                  USD
                </span>
              </div>

              {/* Total Payable Amount */}
              <div className="flex justify-between pt-4  font-semibold text-base">
                <span className="text-gray-700">Total Payable Amount</span>
                <span className="text-emerald-600">
                  {amount && parseFloat(amount) > 0
                    ? (
                        parseFloat(amount) +
                        (parseFloat(amount) *
                          (parseFloat(
                            apiData?.cardCharge?.percent_charge || 1,
                          ) /
                            100) +
                          parseFloat(apiData?.cardCharge?.fixed_charge || 2))
                      ).toFixed(4)
                    : "0.0000"}{" "}
                  USD
                </span>
              </div>
            </div>
          </div>

          {/* Limit Information */}
          <div className="bg-white rounded-2xl shadow-md p-6">
            <h3 className="text-2xl text-center text-gray-700 font-semibold mb-5">
              Limit Information
            </h3>

            <div className="space-y-4 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-600">Transaction Limit</span>
                <span className="text-gray-700">
                  {cardCharge?.min_limit || 1}.0000 USD -{" "}
                  {parseFloat(cardCharge?.max_limit || 1000).toFixed(4)} USD
                </span>
              </div>

              <div className="flex justify-between">
                <span className="text-gray-600">Daily Limit</span>
                <span className="text-gray-700">
                  {cardCharge?.daily_limit || 10000}.0000 USD
                </span>
              </div>

              <div className="flex justify-between">
                <span className="text-gray-600">Remaining Daily Limit</span>
                <span className="text-green-600">10000.0000 USD</span>
              </div>

              <div className="flex justify-between">
                <span className="text-gray-600">Monthly Limit</span>
                <span className="text-gray-700">
                  {cardCharge?.monthly_limit || 50000}.0000 USD
                </span>
              </div>

              <div className="flex justify-between pt-3  font-semibold text-base">
                <span className="text-gray-700">Remaining Monthly Limit</span>
                <span className="text-green-600">50000.0000 USD</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

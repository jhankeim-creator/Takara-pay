"use client";

import { Listbox } from "@headlessui/react";
import { ChevronDown } from "lucide-react";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import toast from "react-hot-toast";
import {
  DepositCardyFie,
  getCardyFieCards,
  getUserDashboard,
} from "../../utils/api";
import FundVirtualCardSkeleton from "../Virtual-Card/FundVirtualCardSkeleton";

export default function CardyFieDeposit() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const cardId = searchParams.get("card_id");

  const [fundAmount, setFundAmount] = useState("");
  const [currency, setCurrency] = useState("USD");
  const [fromWallet, setFromWallet] = useState("USD");

  const [loading, setLoading] = useState(true);
  const [fetchError, setFetchError] = useState(null);
  const [chargesData, setChargesData] = useState(null);
  const [dashboardData, setDashboardData] = useState(null);

  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (!cardId) {
      setFetchError("No card selected");
      setLoading(false);
      return;
    }

    let isMounted = true;

    const loadData = async () => {
      try {
        setLoading(true);
        setFetchError(null);

        const [chargesRes, dashRes] = await Promise.all([
          getCardyFieCards(cardId),
          getUserDashboard(),
        ]);

        if (!isMounted) return;

        setChargesData(chargesRes?.data || null);
        setDashboardData(dashRes?.data || null);

        const base =
          chargesRes?.data?.base_curr || dashRes?.data?.base_curr || "USD";
        setCurrency(base);
        setFromWallet(base);
      } catch (err) {
        if (isMounted) {
          setFetchError(err.message || "Failed to load data");
        }
      } finally {
        if (isMounted) setLoading(false);
      }
    };

    loadData();

    return () => {
      isMounted = false;
    };
  }, [cardId]);

  const baseCurrency = useMemo(
    () => chargesData?.base_curr || dashboardData?.base_curr || "USD",
    [chargesData, dashboardData],
  );

  const cardCharge = useMemo(
    () => chargesData?.cardCharge || {},
    [chargesData],
  );

  const fixedCharge = Number(cardCharge.card_deposit_fixed_fee) || 1;
  const percentCharge = Number(cardCharge.card_deposit_percent_fee) || 1;

  const transactionMin = Number(cardCharge.min_limit) || 5;
  const transactionMax = Number(cardCharge.max_limit) || 100;
  const dailyLimit = Number(cardCharge.daily_limit) || 1000;
  const monthlyLimit = Number(cardCharge.monthly_limit) || 5000;

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
    if (!wallet) return "Main Wallet";
    let name = wallet.currency?.name || "United States dollar";
    name = name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();
    return name;
  }, [dashboardData, baseCurrency]);

  const numericAmount = Number(fundAmount) || 0;
  const hasAmount = numericAmount > 0;

  const feeDisplayedInForm = hasAmount
    ? fixedCharge + (numericAmount * percentCharge) / 100
    : fixedCharge;

  const feeText = `${fixedCharge.toFixed(4)} ${baseCurrency} + ${percentCharge.toFixed(
    4,
  )}% = ${feeDisplayedInForm.toFixed(4)} ${baseCurrency}`;

  const previewTotalCharge = hasAmount
    ? (numericAmount * percentCharge) / 100 + fixedCharge
    : 0;

  const totalPayable = numericAmount + previewTotalCharge;

  const isFormValid =
    hasAmount &&
    !isNaN(numericAmount) &&
    numericAmount >= transactionMin &&
    numericAmount <= transactionMax &&
    totalPayable <= availableBalance;

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!isFormValid) {
      toast.error("Invalid amount or insufficient balance");
      return;
    }

    setSubmitting(true);

    const payload = {
      card_id: cardId,
      deposit_amount: numericAmount,
      currency: currency,
      from_currency: fromWallet,
    };

    try {
      const response = await DepositCardyFie(payload);

      if (response?.message?.success?.length > 0) {
        toast.success(response.message.success[0]);

        setTimeout(() => {
          setFundAmount("");
          router.push("/dashboard/Virtual-Card");
        }, 1800);
      } else if (response?.message?.error?.length > 0) {
        toast.error(response.message.error[0]);
      } else {
        toast.error("Something went wrong. Please try again");
      }
    } catch (err) {
      toast.error("Network error. Try again.");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return <FundVirtualCardSkeleton />;
  }

  if (fetchError || !chargesData) {
    return (
      <div className="rounded-2xl bg-red-50 p-8 text-center text-red-700">
        <p>{fetchError || "Failed to load card details"}</p>
        <button
          onClick={() => router.push("/dashboard/Virtual-Card")}
          className="mt-4 cursor-pointer rounded-lg bg-red-600 px-6 py-2.5 text-white hover:bg-red-700"
        >
          Back
        </button>
      </div>
    );
  }

  return (
    <>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-10">
        <div className="overflow-hidden rounded-2xl bg-white shadow-xl">
          <div className="p-6 sm:p-8 lg:p-10">
            <h2 className="text-center mb-6 text-xl font-bold text-gray-900 sm:text-2xl">
              Deposit to Virtual Card
            </h2>

            <form onSubmit={handleSubmit} className="space-y-7">
              <div>
                <label className="mb-2 block text-sm font-medium text-gray-700">
                  Deposit Amount <span className="text-red-500">*</span>
                </label>
                <div className="relative flex rounded-lg border border-gray-300 focus-within:border-emerald-500 focus-within:ring-1 focus-within:ring-emerald-200">
                  <input
                    type="number"
                    step="0.01"
                    value={fundAmount}
                    onChange={(e) => setFundAmount(e.target.value)}
                    placeholder="Enter Amount"
                    className="block w-full flex-1 border-none bg-transparent px-4 py-3 text-gray-900 placeholder-gray-400 focus:outline-none [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                    required
                    disabled={submitting}
                  />
                  <Listbox
                    value={currency}
                    onChange={setCurrency}
                    disabled={submitting}
                  >
                    {({ open }) => (
                      <div className="relative min-w-20">
                        <Listbox.Button className="flex h-full w-full cursor-pointer items-center justify-center px-3 text-gray-700">
                          <span className="font-medium">{currency}</span>
                          <ChevronDown
                            className={`ml-1.5 h-5 w-5 text-gray-500 transition-transform ${
                              open ? "rotate-180" : ""
                            }`}
                          />
                        </Listbox.Button>
                        <Listbox.Options className="absolute right-0 top-full z-30 mt-1 w-28 rounded-lg border border-gray-200 bg-white py-1 shadow-lg">
                          <Listbox.Option
                            value={baseCurrency}
                            className={({ active }) =>
                              `cursor-pointer px-4 py-2.5 text-sm ${
                                active
                                  ? "bg-emerald-50 text-emerald-700"
                                  : "text-gray-900"
                              }`
                            }
                          >
                            {baseCurrency}
                          </Listbox.Option>
                        </Listbox.Options>
                      </div>
                    )}
                  </Listbox>
                </div>
              </div>

              <div>
                <label className="mb-2 block text-sm font-medium text-gray-700">
                  From Wallet <span className="text-red-500">*</span>
                </label>
                <Listbox
                  value={fromWallet}
                  onChange={setFromWallet}
                  disabled={submitting}
                >
                  {({ open }) => (
                    <div className="relative">
                      <Listbox.Button className="relative w-full cursor-pointer rounded-lg border text-black border-gray-300 bg-white py-3 pl-4 pr-10 text-left sm:text-sm">
                        <span className="block truncate">
                          {walletDisplayName} ({availableBalance.toFixed(4)}{" "}
                          {baseCurrency})
                        </span>
                        <span className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                          <ChevronDown
                            className={`h-5 w-5 text-gray-400 transition-transform ${
                              open ? "rotate-180" : ""
                            }`}
                          />
                        </span>
                      </Listbox.Button>
                      <Listbox.Options className="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 shadow-lg">
                        <Listbox.Option
                          value={baseCurrency}
                          className={({ active }) =>
                            `relative cursor-pointer select-none py-2 pl-10 pr-4 ${
                              active
                                ? "bg-emerald-50 text-emerald-700"
                                : "text-gray-900"
                            }`
                          }
                        >
                          {walletDisplayName} ({availableBalance.toFixed(4)}{" "}
                          {baseCurrency})
                        </Listbox.Option>
                      </Listbox.Options>
                    </div>
                  )}
                </Listbox>
              </div>

              <div className="rounded-lg bg-gray-50 p-5 text-sm">
                <p className="text-gray-700">
                  Fees:{" "}
                  <span className="font-medium text-gray-900">{feeText}</span>
                </p>
                <p className="mt-1.5 text-gray-700">
                  Available Balance:{" "}
                  <span className="font-medium text-gray-900">
                    {availableBalance.toFixed(4)} {baseCurrency}
                  </span>
                </p>
              </div>

              <button
                type="submit"
                className={`mt-4 w-full rounded-lg py-3.5 font-medium text-white flex items-center justify-center gap-2 transition-colors btn-primary cursor-pointer`}
              >
                {submitting ? "Processing..." : "Deposit Card"}
              </button>
            </form>
          </div>
        </div>

        <div className="overflow-hidden rounded-2xl bg-white shadow-xl h-fit">
          <div className="p-6 sm:p-8 lg:p-10">
            <h2 className="text-center mb-6 text-xl font-bold text-gray-900 sm:text-2xl">
              Preview
            </h2>

            <div className="space-y-5 text-sm">
              <div className="flex items-center justify-between py-2 border-b border-gray-100">
                <span className="text-gray-600">Deposit Amount</span>
                <span className="font-medium text-gray-900">
                  {numericAmount.toFixed(4)} {baseCurrency}
                </span>
              </div>

              <div className="flex items-center justify-between py-2 border-b border-gray-100">
                <span className="text-gray-600">Exchange Rate</span>
                <span className="font-medium text-gray-900">
                  1 {baseCurrency} = 1.0000 {baseCurrency}
                </span>
              </div>

              <div className="flex items-center justify-between py-2 border-b border-gray-100">
                <span className="text-gray-600">Total Charge</span>
                <span className="font-medium text-gray-900">
                  {previewTotalCharge.toFixed(4)} {baseCurrency}
                </span>
              </div>

              <div className="flex items-center justify-between py-2">
                <span className="text-gray-600 font-medium">
                  Total Payable Amount
                </span>
                <span className="text-lg font-semibold text-emerald-600">
                  {totalPayable.toFixed(4)} {baseCurrency}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="mt-10 overflow-hidden rounded-2xl bg-white shadow-xl">
        <div className="p-6 sm:p-8 lg:p-10">
          <h2 className="text-center mb-6 text-xl font-bold text-gray-900 sm:text-2xl">
            Limit Information
          </h2>

          <div className="space-y-5 text-sm">
            <div className="flex items-center justify-between py-2 border-b border-gray-100">
              <span className="text-gray-600">Transaction Limit</span>
              <span className="font-medium text-gray-900">
                {transactionMin.toFixed(4)} {baseCurrency} -{" "}
                {transactionMax.toFixed(4)} {baseCurrency}
              </span>
            </div>

            <div className="flex items-center justify-between py-2 border-b border-gray-100">
              <span className="text-gray-600">Daily Limit</span>
              <span className="font-medium text-gray-900">
                {dailyLimit.toFixed(4)} {baseCurrency}
              </span>
            </div>

            <div className="flex items-center justify-between py-2 border-b border-gray-100">
              <span className="text-gray-600">Monthly Limit</span>
              <span className="font-medium text-gray-900">
                {monthlyLimit.toFixed(4)} {baseCurrency}
              </span>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

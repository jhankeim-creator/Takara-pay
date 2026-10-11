/* eslint-disable @next/next/no-img-element */
"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { toast } from "react-hot-toast";
import { getUserGiftCards } from "../../utils/api";
import GiftCardTableSkeleton from "./GiftCardTableSkeleton";
import { useTranslations } from "next-intl";

const GiftCardTable = () => {
  const t = useTranslations("GiftCardTable");

  // ============================================
  // State Management
  // ============================================
  const [giftCards, setGiftCards] = useState([]);
  const [loading, setLoading] = useState(true);

  // ============================================
  // Data Fetching
  // ============================================
  useEffect(() => {
    const fetchGiftCards = async () => {
      setLoading(true);
      try {
        const response = await getUserGiftCards();

        if (response?.message?.success) {
          setGiftCards(response.data?.gift_cards || []);
        } else {
          const errorMsg =
            response?.message?.error?.[0] ||
            response?.message?.error ||
            t("errors.loadFailed");
          toast.error(errorMsg);
        }
      } catch (err) {
        const serverError =
          err?.response?.data?.message?.error?.[0] ||
          err?.response?.data?.message ||
          t("errors.genericError");
        toast.error(serverError);
      } finally {
        setLoading(false);
      }
    };

    fetchGiftCards();
  }, []);

  // ============================================
  // Loading State
  // ============================================
  if (loading) {
    return <GiftCardTableSkeleton />;
  }

  // ============================================
  // Empty State
  // ============================================
  if (giftCards.length === 0) {
    return (
      <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm p-8 text-center">
        <p className="text-gray-600 dark:text-gray-300 mb-4">
          {t("emptyState.message")}
        </p>
        <Link
          href="/dashboard/gift-card/list"
          className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 text-white font-semibold transition-colors cursor-pointer"
        >
          <svg
            className="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M12 4v16m8-8H4"
            />
          </svg>
          {t("emptyState.button")}
        </Link>
      </div>
    );
  }

  // ============================================
  // Main Render
  // ============================================
  return (
    <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
      {/* ============================================ */}
      {/* Header Section */}
      {/* ============================================ */}
      <div className="rounded-t-2xl bg-gray-100/50 dark:bg-gray-800/60 px-6 py-5 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-100 text-center lg:text-left tracking-tight">
          {t("header.title")}
        </h2>

        <Link
          href="/dashboard/gift-card/list"
          className="flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 text-white text-sm font-bold transition-colors cursor-pointer w-full lg:w-auto"
        >
          <svg
            className="w-4 h-4"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M12 4v16m8-8H4"
            />
          </svg>
          {t("header.button")}
        </Link>
      </div>

      {/* ============================================ */}
      {/* Desktop Table View */}
      {/* ============================================ */}
      <div className="overflow-x-auto hidden lg:block">
        <table className="w-full">
          <thead>
            <tr className="bg-gray-100 dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700">
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 dark:text-gray-300">
                {t("table.headers.cardDetails")}
              </th>
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 dark:text-gray-300">
                {t("table.headers.receiverInfo")}
              </th>
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 dark:text-gray-300">
                {t("table.headers.cardPricing")}
              </th>
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 dark:text-gray-300">
                {t("table.headers.paymentDetails")}
              </th>
              <th className="px-6 py-4 text-center text-sm font-semibold text-gray-700 dark:text-gray-300">
                {t("table.headers.status")}
              </th>
            </tr>
          </thead>
          <tbody>
            {giftCards.map((card, index) => (
              <tr
                key={card.trx_id || index}
                className="border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-900/40 transition-colors"
              >
                {/* Card Details Column */}
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <img
                      src={card.card_image}
                      alt={card.card_name}
                      className="w-16 h-10 object-cover rounded border border-gray-200 dark:border-gray-600"
                      onError={(e) =>
                        (e.target.src = "/images/placeholder-giftcard.png")
                      }
                    />
                    <div>
                      <div className="text-sm">
                        <span className="text-gray-600 dark:text-gray-300">
                          {t("table.labels.trxId")}:
                        </span>{" "}
                        <span className="text-gray-900 dark:text-gray-100">
                          {card.trx_id}
                        </span>
                      </div>
                      <div className="text-sm">
                        <span className="text-gray-600 dark:text-gray-300">
                          {t("table.labels.cardName")}:
                        </span>{" "}
                        <span className="font-medium text-gray-900 dark:text-gray-100">
                          {card.card_name}
                        </span>
                      </div>
                    </div>
                  </div>
                </td>

                {/* Receiver Info Column */}
                <td className="px-6 py-4">
                  <div className="text-sm">
                    <div className="mb-1">
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.receiverEmail")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100 break-all">
                        {card.receiver_email}
                      </span>
                    </div>
                    <div>
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.receiverPhone")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100">
                        {card.receiver_phone}
                      </span>
                    </div>
                  </div>
                </td>

                {/* Card Pricing Column */}
                <td className="px-6 py-4">
                  <div className="text-sm">
                    <div className="mb-1">
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.unitPrice")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100">
                        {card.card_init_price} {card.card_currency}
                      </span>
                    </div>
                    <div className="mb-1">
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.quantity")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100">
                        {card.quantity}
                      </span>
                    </div>
                    <div>
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.totalPrice")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100 font-medium">
                        {card.card_total_price} {card.card_currency}
                      </span>
                    </div>
                  </div>
                </td>

                {/* Payment Details Column */}
                <td className="px-6 py-4">
                  <div className="text-sm">
                    <div className="mb-1">
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.exchangeRate")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100">
                        1 {card.card_currency} = {card.wallet_currency_rate}{" "}
                        {card.wallet_currency}
                      </span>
                    </div>
                    <div className="mb-1">
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.payableUnit")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100">
                        {card.payable_unit_price} {card.wallet_currency}
                      </span>
                    </div>
                    <div className="mb-1">
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.charge")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100">
                        {card.payable_charge} {card.wallet_currency}
                      </span>
                    </div>
                    <div>
                      <span className="text-gray-600 dark:text-gray-300">
                        {t("table.labels.totalPayable")}:
                      </span>{" "}
                      <span className="text-gray-900 dark:text-gray-100 font-semibold">
                        {card.total_payable} {card.wallet_currency}
                      </span>
                    </div>
                  </div>
                </td>

                {/* Status Column */}
                <td className="px-6 py-4 text-center">
                  <span
                    className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${
                      card.status === "1"
                        ? "bg-green-100 text-green-800 dark:bg-green-900/60 dark:text-green-300"
                        : card.status === "0"
                          ? "bg-yellow-100 text-yellow-700 dark:bg-yellow-900/50 dark:text-yellow-300"
                          : "bg-red-100 text-red-700 dark:bg-red-900/50 dark:text-red-300"
                    }`}
                  >
                    {card.status === "1"
                      ? t("status.success")
                      : card.status === "0"
                        ? t("status.pending")
                        : t("status.failed")}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* ============================================ */}
      {/* Mobile Card View */}
      {/* ============================================ */}
      <div className="lg:hidden divide-y divide-gray-200 dark:divide-gray-700">
        {giftCards.map((card, index) => (
          <div key={card.trx_id || index} className="px-6 py-4 space-y-3">
            {/* Transaction ID */}
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-gray-600 dark:text-gray-300">
                {t("table.labels.trxId")}
              </span>
              <span className="text-sm font-medium text-gray-900 dark:text-gray-100">
                {card.trx_id}
              </span>
            </div>

            {/* Card Image and Name */}
            <div className="flex items-center gap-3 pb-3 border-b border-gray-100 dark:border-gray-700">
              <img
                src={card.card_image}
                alt={card.card_name}
                className="w-12 h-12 rounded-lg object-cover border border-gray-200 dark:border-gray-600"
                onError={(e) =>
                  (e.target.src = "/images/placeholder-giftcard.png")
                }
              />
              <div>
                <div className="font-medium text-gray-900 dark:text-gray-100">
                  {card.card_name}
                </div>
                <div className="text-xs text-gray-600 dark:text-gray-300">
                  {t("table.labels.quantity")}: {card.quantity}
                </div>
              </div>
            </div>

            {/* Card Information Grid */}
            <div className="grid grid-cols-2 gap-2 text-sm">
              <div>
                <div className="text-xs text-gray-600 dark:text-gray-300">
                  {t("table.labels.receiverEmail")}
                </div>
                <div className="text-gray-900 dark:text-gray-100 text-xs break-all">
                  {card.receiver_email}
                </div>
              </div>
              <div>
                <div className="text-xs text-gray-600 dark:text-gray-300">
                  {t("table.labels.receiverPhone")}
                </div>
                <div className="text-gray-900 dark:text-gray-100 text-xs">
                  {card.receiver_phone}
                </div>
              </div>
              <div>
                <div className="text-xs text-gray-600 dark:text-gray-300">
                  {t("table.labels.totalPrice")}
                </div>
                <div className="text-gray-900 dark:text-gray-100 font-medium">
                  {card.card_total_price} {card.card_currency}
                </div>
              </div>
              <div>
                <div className="text-xs text-gray-600 dark:text-gray-300">
                  {t("table.labels.totalPayable")}
                </div>
                <div className="text-gray-900 dark:text-gray-100 font-semibold">
                  {card.total_payable} {card.wallet_currency}
                </div>
              </div>
              <div>
                <div className="text-xs text-gray-600 dark:text-gray-300">
                  {t("table.labels.exchangeRate")}
                </div>
                <div className="text-gray-900 dark:text-gray-100 text-xs">
                  1 {card.card_currency} ≈ {card.wallet_currency_rate}{" "}
                  {card.wallet_currency}
                </div>
              </div>
              <div>
                <div className="text-xs text-gray-600 dark:text-gray-300">
                  {t("table.labels.charge")}
                </div>
                <div className="text-gray-900 dark:text-gray-100">
                  {card.payable_charge} {card.wallet_currency}
                </div>
              </div>
            </div>

            {/* Status Badge */}
            <div className="pt-2">
              <span
                className={`inline-flex rounded-full px-3 py-1 text-xs font-medium ${
                  card.status === "1"
                    ? "bg-blue-100 text-blue-800 dark:bg-blue-900/60 dark:text-blue-300"
                    : card.status === "0"
                      ? "bg-yellow-100 text-yellow-700 dark:bg-yellow-900/50 dark:text-yellow-300"
                      : "bg-red-100 text-red-700 dark:bg-red-900/50 dark:text-red-300"
                }`}
              >
                {card.status === "1"
                  ? t("status.success")
                  : card.status === "0"
                    ? t("status.pending")
                    : t("status.failed")}
              </span>
            </div>
          </div>
        ))}
      </div>


    </div>
  );
};

export default GiftCardTable;
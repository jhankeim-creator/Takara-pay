"use client";

import { ArrowDownLeft, ArrowUpRight } from "lucide-react";
import { useTranslations } from "next-intl";
import Link from "next/link";
import { useEffect, useState } from "react";
import { getUserDashboard } from "../../utils/api";
import TransactionHistorySkeleton from "./TransactionHistorySkeleton";

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================
function formatDateTime(dateString) {
  if (!dateString) return "—";

  try {
    const date = new Date(dateString);

    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = String(date.getFullYear()).slice(-2);

    let hours = date.getHours();
    const minutes = String(date.getMinutes()).padStart(2, "0");
    const seconds = String(date.getSeconds()).padStart(2, "0");

    const ampm = hours >= 12 ? "PM" : "AM";
    hours = hours % 12 || 12;
    hours = String(hours).padStart(2, "0");

    return `${day}-${month}-${year} ${hours}:${minutes}:${seconds} ${ampm}`;
  } catch {
    return dateString;
  }
}

// ============================================================================
// TRANSACTION ROW COMPONENT
// ============================================================================
function TransactionRow({ transaction }) {
  const t = useTranslations("TransactionHistory");
  const {
    trx,
    payable,
    request_amount,
    type,
    remark,
    transaction_type,
    status,
    status_label,
    date_time,
  } = transaction;

  const isReceived = (type || "").toUpperCase().includes("RECEIVED");
  const displayDirection = isReceived ? "in" : "out";

  return (
    <tr className="border-b border-gray-100 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors bg-white dark:bg-gray-800">
      {/* Transaction ID with Icon */}
      <td className="px-6 py-5 whitespace-nowrap">
        <div className="flex items-center gap-3">
          <div
            className={`w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 ${
              displayDirection === "in"
                ? "bg-green-100/40 dark:bg-green-900/30"
                : "bg-red-100/40 dark:bg-red-900/30"
            }`}
          >
            {displayDirection === "in" ? (
              <ArrowUpRight className="h-5 w-5 text-green-600 dark:text-green-400" />
            ) : (
              <ArrowDownLeft className="h-5 w-5 text-red-600 dark:text-red-400" />
            )}
          </div>
          <div className="min-w-0">
            <p className="font-medium text-gray-900 dark:text-gray-100 truncate">
              {trx || "—"}
            </p>
          </div>
        </div>
      </td>

      {/* Payable Amount */}
      <td className="px-6 py-5 text-right whitespace-nowrap">
        <span
          className={`font-semibold text-lg ${
            displayDirection === "in"
              ? "text-green-600 dark:text-green-400"
              : "text-red-600 dark:text-red-400"
          }`}
        >
          {payable || "—"}
        </span>
      </td>

      {/* Request Amount */}
      <td className="px-6 py-5 text-right whitespace-nowrap text-gray-900 dark:text-gray-100">
        {request_amount || "—"}
      </td>

      {/* Type */}
      <td className="px-6 py-5 whitespace-nowrap">
        <span className="font-medium text-gray-900 dark:text-gray-100">
          {type || "—"}
        </span>
      </td>

      {/* Remark - Improved responsive handling */}
      <td className="px-6 py-5 text-gray-600 dark:text-gray-300 max-w-[180px] md:max-w-xs">
        <div className="line-clamp-2 md:line-clamp-1">
          {remark || "—"}
        </div>
      </td>

      {/* Transaction Type Badge */}
      <td className="px-6 py-5 whitespace-nowrap">
        <span className="px-3 py-1 bg-blue-100 dark:bg-blue-900/40 text-blue-700 dark:text-blue-300 rounded-full text-sm font-medium">
          {transaction_type || "—"}
        </span>
      </td>

      {/* Status Badge */}
      <td className="px-6 py-5 whitespace-nowrap">
        <span className="inline-flex items-center gap-2 text-sm font-medium">
          <span
            className={`h-2.5 w-2.5 rounded-full ${
              ["success", "éxito", "exitoso", "completado", "succès", "réussi", "نجاح", "ناجح", "सफलता", "सफल", "1"].includes(String(status).toLowerCase().trim())
                ? "bg-green-500"
                : ["pending", "pendiente", "en attente", "قيد الانتظار", "लंबित", "4", "2"].includes(String(status).toLowerCase().trim())
                  ? "bg-yellow-500"
                  : "bg-red-500"
            }`}
          />
          <span
            className={
              ["success", "éxito", "exitoso", "completado", "succès", "réussi", "نجاح", "ناجح", "सफलता", "सफल", "1"].includes(String(status).toLowerCase().trim())
                ? "text-green-600 dark:text-green-400"
                : ["pending", "pendiente", "en attente", "قيد الانتظار", "लंबित", "4", "2"].includes(String(status).toLowerCase().trim())
                  ? "text-yellow-600 dark:text-yellow-400"
                  : "text-red-600 dark:text-red-400"
            }
          >
            {status_label || status || "—"}
          </span>
        </span>
      </td>

      {/* Date & Time */}
      <td className="px-6 py-5 whitespace-nowrap">
        <p className="text-sm text-gray-600 dark:text-gray-300">
          {formatDateTime(date_time)}
        </p>
      </td>
    </tr>
  );
}

// ============================================================================
// TRANSACTION TABLE COMPONENT
// ============================================================================
function TransactionTable({ transactions = [], loading }) {
  const t = useTranslations("TransactionHistory");

  if (loading) {
    return <TransactionHistorySkeleton rows={6} />;
  }

  if (transactions.length === 0) {
    return (
      <div className="py-12 text-center text-gray-500 dark:text-gray-300">
        {t("noTransactionsFound")}
      </div>
    );
  }

  return (
    <div className="overflow-x-auto scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600">
      <div className="inline-block min-w-full align-middle">
        <div className="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800">
          <table className="min-w-[1200px] w-full divide-y divide-gray-100 dark:divide-gray-700">
            <thead className="bg-gray-50 dark:bg-gray-900/40 sticky top-0 z-10">
              <tr>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("transactionId")}
                </th>
                <th className="px-6 py-4 text-right text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("payable")}
                </th>
                <th className="px-6 py-4 text-right text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("requestAmount")}
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("type")}
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("remark")}
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("transactionType")}
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("status")}
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                  {t("dateTime")}
                </th>
              </tr>
            </thead>

            <tbody className="divide-y divide-gray-100 dark:divide-gray-700 bg-white dark:bg-gray-800">
              {transactions.map((tx) => (
                <TransactionRow key={tx.id} transaction={tx} />
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

// ============================================================================
// MAIN COMPONENT
// ============================================================================
export default function TransactionHistory() {
  const t = useTranslations("TransactionHistory");
  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;

    async function fetchData() {
      try {
        const res = await getUserDashboard();
        const data = res?.data || res || {};

        if (mounted && Array.isArray(data.transactions)) {
          const sorted = [...data.transactions].sort(
            (a, b) => new Date(b.date_time) - new Date(a.date_time)
          );
          setTransactions(sorted);
        }
      } catch (err) {
        // Error handled by API utility
      } finally {
        if (mounted) setLoading(false);
      }
    }

    fetchData();

    return () => {
      mounted = false;
    };
  }, []);

  return (
    <div className="rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
      {/* Header Section */}
      <div className="p-5 border-b border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800">
        {loading ? (
          <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between animate-pulse">
            <div className="h-7 w-48 bg-gray-200 dark:bg-gray-700 rounded mx-auto md:mx-0" />
            <div className="flex flex-col gap-2 sm:flex-row">
              <div className="h-10 w-full sm:w-48 md:w-60 bg-gray-200 dark:bg-gray-700 rounded-lg" />
            </div>
          </div>
        ) : (
          <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white text-center md:text-left">
              {t("latestTransactions")}
            </h2>

            <Link
              href="/dashboard/transactions"
              className="cursor-pointer flex items-center justify-center gap-2 px-5 py-2.5 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 rounded-lg transition-colors w-full sm:w-auto font-medium"
            >
              {t("viewMore")}
            </Link>
          </div>
        )}
      </div>

      <TransactionTable transactions={transactions} loading={loading} />
    </div>
  );
}
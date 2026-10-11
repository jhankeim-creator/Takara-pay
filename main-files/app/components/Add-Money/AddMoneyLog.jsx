"use client";

import { useTranslations } from "next-intl";
import Link from "next/link";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { getAddMoneyInformation } from "../../utils/api";
import AddMoneyLogSkeleton from "./AddMoneyLogSkeleton";

const AddMoneyLog = () => {
  const t = useTranslations("addMoneyLog");

  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);

  // Fetch transactions from the API
  useEffect(() => {
    async function fetchLogs() {
      try {
        setLoading(true);
        const response = await getAddMoneyInformation();

        if (response?.message?.error) {
          toast.error(response.message.error[0] || t("errors.loadFailed"));
          return;
        }

        const data = response.data || response;

        // Use real transactions array
        const transactions = data.transactions || [];

        // Map to match existing UI structure
        const formattedLogs = transactions.map((tx) => ({
          gateway: tx.gateway_name || "Unknown Gateway",
          status: tx.status || "Unknown",
          status_label: tx.status_label,
          trxId: tx.trx || "N/A",
          exchangeRate: tx.exchange_rate || "N/A",
          fees: tx.total_charge || "0.0000 USD",
          requestAmount: tx.request_amount || "0.0000 USD",
          payable: tx.payable || "0.0000 USD",
          currentBalance: tx.current_balance || "0.0000 USD",
          date: new Date(tx.date_time)
            .toLocaleString("en-GB", {
              day: "2-digit",
              month: "2-digit",
              year: "2-digit",
              hour: "2-digit",
              minute: "2-digit",
              second: "2-digit",
              hour12: true,
            })
            .replace(",", "")
            .replace(/\//g, "-")
            .replace(/\bam\b/, "AM")
            .replace(/\bpm\b/, "PM"), // Format like "17-01-26 12:55:31 PM"
        }));

        setLogs(formattedLogs);
      } catch (err) {
        toast.error(t("errors.loadGeneric"));
      } finally {
        setLoading(false);
      }
    }

    fetchLogs();
  }, [t]);

  if (loading) {
    return <AddMoneyLogSkeleton />;
  }

  return (
    <div className="mt-6">
      <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm overflow-hidden">
        {/* Header */}
        <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 backdrop-blur px-6 py-5 flex flex-col gap-3 md:flex-row md:items-center md:justify-between md:relative">
          {/* Title - center on mobile, centered on md+ */}
          <h2 className="text-xl md:text-2xl font-semibold text-gray-800 dark:text-gray-100 tracking-tight text-center md:text-left md:absolute md:left-1/2 md:-translate-x-1/2">
            {t("title")}
          </h2>

          {/* Spacer - only visible on md+ to push button right */}
          <div className="hidden md:block" />

          {/* Button - full width on mobile, right on md+ */}
          <div className="w-full md:w-auto">
            <Link
              href="/dashboard/transactions"
              className="flex md:inline-flex justify-center items-center gap-2 px-5 py-2.5 rounded-xl border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700/70 transition-colors font-medium w-full md:w-auto"
            >
              {t("viewMore")}
            </Link>
          </div>
        </div>

        {/* Table Container with Horizontal Scroll */}
        <div className="overflow-x-auto scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600">
          <div className="inline-block min-w-full align-middle">
            <table className="min-w-[1300px] w-full divide-y divide-gray-200 dark:divide-gray-700">
              {/* Table Header */}
              <thead className="bg-gray-50 dark:bg-gray-900 sticky top-0 z-10">
                <tr>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.addBalanceVia")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.status")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.transactionId")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.requestAmount")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.payableAmount")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.exchangeRate")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.feesCharges")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.currentBalance")}
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-semibold text-gray-600 dark:text-gray-300 whitespace-nowrap">
                    {t("columns.timeDate")}
                  </th>
                </tr>
              </thead>

              {/* Table Body */}
              <tbody className="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
                {logs.length === 0 ? (
                  <tr>
                    <td
                      colSpan={9}
                      className="px-6 py-12 text-center text-gray-500 dark:text-gray-400"
                    >
                      {t("empty")}
                    </td>
                  </tr>
                ) : (
                  logs.map((log, index) => (
                    <tr
                      key={index}
                      className="hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
                    >
                      {/* Add Balance Via */}
                      <td className="px-6 py-5 text-sm font-medium text-gray-900 dark:text-gray-100">
                        {t("rows.addBalanceVia", { gateway: log.gateway })}
                      </td>

                      {/* Status */}
                      <td className="px-6 py-5 whitespace-nowrap">
                        <span className="inline-flex items-center gap-2 text-sm font-medium">
                          <span
                            className={`h-2.5 w-2.5 rounded-full ${
                              ["success", "éxito", "exitoso", "completado", "succès", "réussi", "نجاح", "ناجح", "सफलता", "सफल", "1"].includes(String(log.status).toLowerCase().trim())
                                ? "bg-green-500"
                                : ["pending", "pendiente", "en attente", "قيد الانتظار", "लंबित", "4", "2"].includes(String(log.status).toLowerCase().trim())
                                  ? "bg-yellow-500"
                                  : "bg-red-500"
                            }`}
                          />
                          <span
                            className={
                              ["success", "éxito", "exitoso", "completado", "succès", "réussi", "نجاح", "ناجح", "सफलता", "सफल", "1"].includes(String(log.status).toLowerCase().trim())
                                ? "text-green-600 dark:text-green-400"
                                : ["pending", "pendiente", "en attente", "قيد الانتظار", "लंबित", "4", "2"].includes(String(log.status).toLowerCase().trim())
                                  ? "text-yellow-600 dark:text-yellow-400"
                                  : "text-red-600 dark:text-red-400"
                            }
                          >
                            {log.status_label || log.status}
                          </span>
                        </span>
                      </td>

                      {/* Transaction ID */}
                      <td className="px-6 py-5 text-sm text-gray-600 dark:text-gray-200 font-mono">
                        {log.trxId}
                      </td>

                      {/* Request Amount */}
                      <td className="px-6 py-5 text-sm text-gray-600 dark:text-gray-200 font-medium">
                        {log.requestAmount}
                      </td>

                      {/* Payable Amount */}
                      <td className="px-6 py-5 text-sm text-gray-600 dark:text-gray-200 font-medium">
                        {log.payable}
                      </td>

                      {/* Exchange Rate */}
                      <td className="px-6 py-5 text-sm text-gray-600 dark:text-gray-200">
                        {log.exchangeRate}
                      </td>

                      {/* Fees & Charges */}
                      <td className="px-6 py-5 text-sm text-gray-600 dark:text-gray-200">
                        {log.fees}
                      </td>

                      {/* Current Balance */}
                      <td className="px-6 py-5 text-sm text-gray-600 dark:text-gray-200 font-medium">
                        {log.currentBalance}
                      </td>

                      {/* Date & Time */}
                      <td className="px-6 py-5 text-sm text-gray-600 dark:text-gray-200 whitespace-nowrap">
                        {log.date}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AddMoneyLog;
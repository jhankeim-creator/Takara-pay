"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useTranslations } from "next-intl"; 
import { getWithdrawInfo } from "../../utils/api";
import WithdrawMoneyLogSkeleton from "./WithdrawMoneyLogSkeleton";

const WithdrawMoneyLog = () => {
  const t = useTranslations("withdrawMoneyLog"); 

  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch withdrawal transactions
  useEffect(() => {
    const fetchWithdrawLogs = async () => {
      try {
        setLoading(true);
        const response = await getWithdrawInfo();

        if (response?.data?.transactions) {
          // Map API response to component-friendly format
          const formattedLogs = response.data.transactions.map((tx) => ({
            trxId: tx.trx,
            withdrawBy: tx.gateway_name,
            gatewayCurrency: tx.gateway_currency_name,
            exchangeRate: tx.exchange_rate,
            fees: tx.total_charge,
            willGet: tx.will_get,
            requestAmount: tx.request_amount,
            payable: tx.payable,
            currentBalance: tx.current_balance,
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
            status: tx.status,
            status_label: tx.status_label,
          }));

          setLogs(formattedLogs);
        } else {
          setError(t("errors.noData"));
        }
      } catch (err) {
        setError(t("errors.loadFailed"));
      } finally {
        setLoading(false);
      }
    };

    fetchWithdrawLogs();
  }, [t]);   // Added t as dependency 

  if (loading) {
    return <WithdrawMoneyLogSkeleton />;
  }

  if (error) {
    return (
      <div className="mt-6 rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm min-h-[300px] flex items-center justify-center">
        <p className="text-red-600 dark:text-red-400">{error}</p>
      </div>
    );
  }

  return (
    <div className="mt-6">
      <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm">
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

        {/* Scrollable Table Wrapper */}
        <div className="overflow-x-auto scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600">
          {/* Table Header */}
          <div className="grid min-w-[1450px] grid-cols-10 gap-4 px-6 py-3 bg-gray-50 dark:bg-gray-900 text-sm font-semibold text-gray-600 dark:text-gray-300">
            <span>{t("columns.withdrawBy")}</span>
            <span>{t("columns.status")}</span>
            <span>{t("columns.transactionId")}</span>
            <span>{t("columns.requestAmount")}</span>
            <span>{t("columns.payableAmount")}</span>
            <span>{t("columns.exchangeRate")}</span>
            <span>{t("columns.feesCharges")}</span>
            <span>{t("columns.willGet")}</span>
            <span>{t("columns.currentBalance")}</span>
            <span>{t("columns.timeDate")}</span>
          </div>

          {/* Rows */}
          <div className="divide-y divide-gray-200 dark:divide-gray-700 min-w-[1450px]">
            {logs.length === 0 ? (
              <div className="px-6 py-10 text-center text-gray-500 dark:text-gray-400">
                {t("empty")}
              </div>
            ) : (
              logs.map((log, index) => (
                <div
                  key={log.trxId || index}
                  className="grid grid-cols-10 gap-4 px-6 py-4 text-sm"
                >
                  {/* 1. Withdraw Money by */}
                  <span className="font-medium text-gray-900 dark:text-gray-100">
                    {log.withdrawBy}
                  </span>

                  {/* 2. Status */}
                  <span className="inline-flex items-center gap-2 text-xs font-medium">
                    <span
                      className={`h-2 w-2 rounded-full
                        ${
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

                  {/* 3. Transaction ID */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.trxId}
                  </span>

                  {/* 4. Request Amount */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.requestAmount || "0.0000"}
                  </span>

                  {/* 5. Payable Amount */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.payable || "0.0000"}
                  </span>

                  {/* 6. Exchange Rate */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.exchangeRate}
                  </span>

                  {/* 7. Fees & Charges */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.fees}
                  </span>

                  {/* 8. Will Get */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.willGet}
                  </span>

                  {/* 9. Current Balance */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.currentBalance}
                  </span>

                  {/* 10. Time & Date */}
                  <span className="text-gray-600 dark:text-gray-300">
                    {log.date}
                  </span>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default WithdrawMoneyLog;
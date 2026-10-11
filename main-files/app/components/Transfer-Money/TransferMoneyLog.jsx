"use client";
import Link from "next/link";
import { useEffect, useState } from "react";
import { getTransferMoneyInfo } from "../../utils/api";
import TransferLogSkeleton from "./TransferLogSkeleton";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";

const TransferMoneyLog = () => {
  const t = useTranslations("transferMoneyLog");
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchLogs = async () => {
      try {
        setLoading(true);
        const response = await getTransferMoneyInfo();

        if (response?.data?.transactions) {
          setLogs(response.data.transactions);
        } else if (response?.message?.error) {
          toast.error(response.message.error[0] || t("errors.loadFailed"));
        }
      } catch (error) {
        toast.error(t("errors.loadFailed"));
      } finally {
        setLoading(false);
      }
    };

    fetchLogs();
  }, [t]);

  // Helper function for desired date format: 05-01-26 12:37:13 PM
  const formatDate = (dateString) => {
    const date = new Date(dateString);
    const day = date.getDate().toString().padStart(2, "0");
    const month = (date.getMonth() + 1).toString().padStart(2, "0");
    const year = date.getFullYear().toString().slice(-2);
    const hours = date.getHours();
    const minutes = date.getMinutes().toString().padStart(2, "0");
    const seconds = date.getSeconds().toString().padStart(2, "0");
    const ampm = hours >= 12 ? "PM" : "AM";
    const displayHours = (hours % 12 || 12).toString().padStart(2, "0");

    return `${day}-${month}-${year} ${displayHours}:${minutes}:${seconds} ${ampm}`;
  };

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

        {/* Scrollable Area - More Space */}
        <div className="overflow-x-auto scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600">
          {loading ? (
            <TransferLogSkeleton />
          ) : logs.length > 0 ? (
            <>
              {/* Table Header */}
              <div className="grid min-w-[1600px] grid-cols-9 gap-x-8 px-6 py-4 bg-gray-50 dark:bg-gray-900 text-sm font-semibold text-gray-600 dark:text-gray-200 border-b border-gray-200 dark:border-gray-700">
                <span>{t("columns.transferTo")}</span>
                <span>{t("columns.status")}</span>
                <span>{t("columns.transactionId")}</span>
                <span>{t("columns.requestAmount")}</span>
                <span>{t("columns.payableAmount")}</span>
                <span>{t("columns.feesCharges")}</span>
                <span>{t("columns.recipientReceived")}</span>
                <span>{t("columns.currentBalance")}</span>
                <span className="text-right">{t("columns.timeDate")}</span>
              </div>

              {/* Table Body */}
              <div className="divide-y divide-gray-200 dark:divide-gray-700 min-w-[1600px]">
                {logs.map((log, index) => (
                  <div
                    key={index}
                    className="grid grid-cols-9 gap-x-8 px-6 py-5 text-sm hover:bg-gray-50 dark:hover:bg-gray-950/50 transition-colors"
                  >
                    {/* Transfer To */}
                    <span className="font-medium text-gray-900 dark:text-gray-100">
                      {log.transaction_heading}
                    </span>

                    {/* Status */}
                    <span className="inline-flex items-center gap-2 text-xs font-medium">
                      <span
                        className={`h-2.5 w-2.5 rounded-full flex-shrink-0 ${
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

                    {/* Transaction ID */}
                    <span className="text-gray-600 dark:text-gray-200 font-mono text-xs break-all">
                      {log.trx}
                    </span>

                    {/* Request Amount */}
                    <span className="text-gray-600 dark:text-gray-200">
                      {log.request_amount || "N/A"}
                    </span>

                    {/* Payable Amount */}
                    <span className="text-gray-600 dark:text-gray-200">
                      {log.payable || "N/A"}
                    </span>

                    {/* Fees & Charges */}
                    <span className="text-gray-600 dark:text-gray-200">
                      {log.total_charge}
                    </span>

                    {/* Recipient Received */}
                    <span className="text-gray-600 dark:text-gray-200">
                      {log.recipient_received}
                    </span>

                    {/* Current Balance */}
                    <span className="text-gray-600 dark:text-gray-200">
                      {log.current_balance}
                    </span>

                    {/* Date & Time */}
                    <span className="text-gray-600 dark:text-gray-200 text-right whitespace-nowrap">
                      {formatDate(log.date_time)}
                    </span>
                  </div>
                ))}
              </div>
            </>
          ) : (
            <div className="px-6 py-20 text-center text-gray-500 dark:text-gray-400 min-h-[260px] flex flex-col items-center justify-center">
              <p className="text-lg font-medium">{t("empty.title")}</p>
              <p className="mt-2 text-sm max-w-md">{t("empty.subtitle")}</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default TransferMoneyLog;
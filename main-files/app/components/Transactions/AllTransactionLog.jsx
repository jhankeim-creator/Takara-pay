"use client";

import { ChevronLeft, ChevronRight, X } from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { getUserTransactions } from "../../utils/api";
import TransactionLogSkeleton from "./TransactionLogSkeleton";

// ============================================================================
// TRANSACTION ROW COMPONENT
// ============================================================================

function TransactionRow({ log, onClick }) {
  return (
    <tr
      onClick={onClick}
      className="border-b border-gray-100 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors bg-white dark:bg-gray-800 cursor-pointer"
    >
      {/* Transaction / Via */}
      <td className="px-6 py-5 whitespace-nowrap">
        <p className="text-sm text-gray-900 dark:text-gray-100 truncate">
          {log.displayVia}
        </p>
        <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
          {log.displayType}
        </p>
      </td>

      {/* Status */}
      <td className="px-6 py-5 whitespace-nowrap">
        <span
          className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-sm font-medium ${
            ["success", "éxito", "exitoso", "completado", "succès", "réussi", "نجاح", "ناجح", "सफलता", "सफल", "1"].includes(String(log.status).toLowerCase().trim())
              ? "bg-green-100 dark:bg-green-900/40 text-green-700 dark:text-green-300"
              : ["pending", "pendiente", "en attente", "قيد الانتظار", "लंबित", "4", "2"].includes(String(log.status).toLowerCase().trim())
              ? "bg-yellow-100 dark:bg-yellow-900/40 text-yellow-700 dark:text-yellow-300"
              : "bg-red-100 dark:bg-red-900/40 text-red-700 dark:text-red-300"
          }`}
        >
          <span
            className={`h-2 w-2 rounded-full ${
              ["success", "éxito", "exitoso", "completado", "succès", "réussi", "نجاح", "ناجح", "सफलता", "सफल", "1"].includes(String(log.status).toLowerCase().trim())
                ? "bg-green-500"
                : ["pending", "pendiente", "en attente", "قيد الانتظار", "लंबित", "4", "2"].includes(String(log.status).toLowerCase().trim())
                ? "bg-yellow-500"
                : "bg-red-500"
            }`}
          />
          {log.status_label || log.status || "—"}
        </span>
      </td>

      {/* Transaction ID */}
      <td className="px-6 py-5 whitespace-nowrap">
        <p className="font-mono text-sm text-gray-600 dark:text-gray-300 truncate max-w-[140px]">
          {log.trx || "—"}
        </p>
      </td>

      {/* Amount */}
      <td className="px-6 py-5 whitespace-nowrap text-right">
        <span className="text-sm text-gray-700 dark:text-gray-300">
          {log.displayAmount}
        </span>
      </td>

      {/* Payable */}
      <td className="px-6 py-5 whitespace-nowrap text-right">
        <span className="text-sm text-gray-700 dark:text-gray-300">
          {log.displayPayable}
        </span>
      </td>

      {/* Fees & Charges */}
      <td className="px-6 py-5 whitespace-nowrap">
        <span className="text-sm text-gray-600 dark:text-gray-300">
          {log.displayFees}
        </span>
      </td>

      {/* Current Balance */}
      <td className="px-6 py-5 whitespace-nowrap">
        <span className="text-sm text-gray-600 dark:text-gray-300">
          {log.displayBalance}
        </span>
      </td>

      {/* Date & Time */}
      <td className="px-6 py-5 whitespace-nowrap">
        <p className="text-sm text-gray-600 dark:text-gray-300">
          {formatDate(log.date_time)}
        </p>
      </td>
    </tr>
  );
}

function formatDate(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  return d.toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
    hour12: true,
  });
}

// ============================================================================
// MAIN COMPONENT
// ============================================================================

const AllTransactionLog = () => {
  const t = useTranslations("allTransactionLog");

  // --------------------------------------------------------------------------
  // State Management
  // --------------------------------------------------------------------------
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [allTransactions, setAllTransactions] = useState([]);
  const [filteredTransactions, setFilteredTransactions] = useState([]);
  const [paginatedTx, setPaginatedTx] = useState([]); // current page slice
  const [totalPages, setTotalPages] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedTx, setSelectedTx] = useState(null);

  const pageSize = 12;

  // --------------------------------------------------------------------------
  // Fetch Transactions (large batch once – client handles pagination & search)
  // --------------------------------------------------------------------------
  useEffect(() => {
    const fetchTransactions = async () => {
      setLoading(true);
      setError(null);

      try {
        // Fetch many at once (adjust number if backend has strict limit)
        const data = await getUserTransactions(1, 500);

        if (!data?.data?.transactions) {
          toast.error(t("errors.invalidResponse"));
        }

        const categories = data.data.transactions || {};
        const allTx = [];

        // Flatten and normalize Add Money
        (categories.add_money || []).forEach((tx) => {
          allTx.push({
            ...tx,
            normalizedType: "ADD-MONEY",
            displayVia: tx.gateway_name || "Unknown",
            displayType: t("types.addMoney"),
            displayAmount: tx.request_amount || "—",
            displayPayable: tx.payable || "—",
            displayFees: tx.total_charge || "—",
            displayBalance: tx.current_balance || "—",
          });
        });

        // Flatten and normalize Transfer Money
        (categories.send_money || []).forEach((tx) => {
          allTx.push({
            ...tx,
            normalizedType: "TRANSFER-MONEY",
            displayVia: tx.transaction_heading || "Transfer",
            displayType: t("types.transferMoney"),
            displayAmount: tx.request_amount || "—",
            displayPayable: tx.payable || "—",
            displayFees: tx.total_charge || "—",
            displayBalance: tx.current_balance || "—",
          });
        });

        // Flatten and normalize Virtual Card
        (categories.virtual_card || []).forEach((tx) => {
          allTx.push({
            ...tx,
            normalizedType: "VIRTUAL-CARD",
            displayVia: tx.transaction_type || "Virtual Card",
            displayType: t("types.virtualCard"),
            displayAmount: tx.request_amount || tx.card_amount || tx.payable || "—",
            displayPayable: tx.payable || "—",
            displayFees: tx.total_charge || "—",
            displayBalance: tx.current_balance || "—",
          });
        });

        // Flatten and normalize Withdraw Money
        (categories.withdraw_money || []).forEach((tx) => {
          allTx.push({
            ...tx,
            normalizedType: "WITHDRAW-MONEY",
            displayVia: tx.gateway_name || "Manual",
            displayType: t("types.withdrawMoney"),
            displayAmount: tx.request_amount || "—",
            displayPayable: tx.payable || "—",
            displayFees: tx.total_charge || "—",
            displayBalance: tx.current_balance || "—",
          });
        });

        // Flatten and normalize Gift Cards
        (categories.gift_cards || []).forEach((tx) => {
          allTx.push({
            ...tx,
            normalizedType: "GIFT-CARD",
            displayVia: tx.card_name || "Gift Card",
            displayType: t("types.giftCard"),
            displayAmount: tx.request_amount || "—",
            displayPayable: tx.payable || "—",
            displayFees: tx.total_charge || "—",
            displayBalance: tx.current_balance || "—",
          });
        });

        // Sort newest first
        allTx.sort((a, b) => new Date(b.date_time) - new Date(a.date_time));

        setAllTransactions(allTx);
        setFilteredTransactions(allTx);
      } catch (err) {
        // console.error("Fetch error:", err);
        setError(err.message || t("errors.loadFailed"));
      } finally {
        setLoading(false);
      }
    };

    fetchTransactions();
  }, []); // only once

  // --------------------------------------------------------------------------
  // Client-side search (supports TRX ID, type, gateway, heading, card name, etc.)
  // --------------------------------------------------------------------------
  useEffect(() => {
    const term = search.trim().toLowerCase();

    if (!term) {
      setFilteredTransactions(allTransactions);
      setCurrentPage(1);
      return;
    }

    const filtered = allTransactions.filter((tx) => {
      const searchableText = [
        tx.trx?.toLowerCase() || "", // Transaction ID
        tx.displayType?.toLowerCase() || "", // e.g. "Add Money", "Transfer Money"
        tx.displayVia?.toLowerCase() || "", // gateway name, heading, card name
        tx.transaction_type?.toLowerCase() || "",
        tx.gateway_name?.toLowerCase() || "",
        tx.transaction_heading?.toLowerCase() || "",
        tx.card_name?.toLowerCase() || "",
      ].join(" ");

      return searchableText.includes(term);
    });

    setFilteredTransactions(filtered);
    setCurrentPage(1); // reset to page 1 on search
  }, [search, allTransactions]);

  // --------------------------------------------------------------------------
  // Pagination – 12 items per page
  // --------------------------------------------------------------------------
  useEffect(() => {
    const start = (currentPage - 1) * pageSize;
    setPaginatedTx(filteredTransactions.slice(start, start + pageSize));
    const pages = Math.ceil(filteredTransactions.length / pageSize);
    setTotalPages(pages || 1);
  }, [currentPage, filteredTransactions]);

  // --------------------------------------------------------------------------
  // Modal Content
  // --------------------------------------------------------------------------
  const renderModalContent = () => {
    if (!selectedTx) return null;

    const type = selectedTx.normalizedType;

    const commonFields = (
      <>
        <DetailRow label={t("modal.status")} value={selectedTx.status} />
        <DetailRow label={t("modal.transactionId")} value={selectedTx.trx} isMono />
        <DetailRow label={t("modal.requestAmount")} value={selectedTx.request_amount || "—"} />
        <DetailRow label={t("modal.payable")} value={selectedTx.payable || "—"} />
        <DetailRow label={t("modal.feesCharges")} value={selectedTx.total_charge || "—"} />
        <DetailRow label={t("modal.currentBalance")} value={selectedTx.current_balance || "—"} />
        <DetailRow label={t("modal.timeDate")} value={formatDate(selectedTx.date_time)} />
      </>
    );

    if (type === "VIRTUAL-CARD") {
      return (
        <>
          <DetailRow label={t("modal.transactionType")} value={selectedTx.transaction_type} />
          {commonFields}
          <DetailRow label={t("modal.cardAmount")} value={selectedTx.card_amount || selectedTx.request_amount || "—"} />
          <DetailRow label={t("modal.cardMasked")} value={selectedTx.card_number || "—"} isMono />
        </>
      );
    }

    if (type === "TRANSFER-MONEY") {
      return (
        <>
          <DetailRow label={t("modal.transactionHeading")} value={selectedTx.transaction_heading || "—"} />
          {commonFields}
          <DetailRow label={t("modal.recipientReceived")} value={selectedTx.recipient_received || "—"} />
        </>
      );
    }

    if (type === "ADD-MONEY") {
      return (
        <>
          <DetailRow label={t("modal.addBalanceVia")} value={selectedTx.gateway_name || "—"} />
          {commonFields}
          <DetailRow label={t("modal.exchangeRate")} value={selectedTx.exchange_rate || "—"} />
        </>
      );
    }

    if (type === "WITHDRAW-MONEY") {
      return (
        <>
          <DetailRow label={t("modal.withdrawMoney")} value={selectedTx.gateway_name || "—"} />
          {commonFields}
          <DetailRow label={t("modal.exchangeRate")} value={selectedTx.exchange_rate || "—"} />
          <DetailRow label={t("modal.willGet")} value={selectedTx.will_get || "—"} />
        </>
      );
    }

    if (type === "GIFT-CARD") {
      return (
        <>
          <DetailRow label={t("modal.transactionType")} value={selectedTx.transaction_type || t("types.giftCard")} />
          {commonFields}
          <DetailRow label={t("modal.exchangeRate")} value={selectedTx.exchange_rate || "—"} />
          <DetailRow label={t("modal.cardName")} value={selectedTx.card_name || "—"} />
          <DetailRow label={t("modal.receiverEmail")} value={selectedTx.receiver_email || "—"} />
          <DetailRow label={t("modal.receiverPhone")} value={selectedTx.receiver_phone || "—"} />
          <DetailRow label={t("modal.cardUnitPrice")} value={selectedTx.card_unit_price || "—"} />
          <DetailRow label={t("modal.cardQuantity")} value={selectedTx.card_quantity || "—"} />
          <DetailRow label={t("modal.cardTotalPrice")} value={selectedTx.card_total_price || "—"} />
        </>
      );
    }

    return (
      <>
        <DetailRow label={t("modal.transactionType")} value={selectedTx.transaction_type || t("modal.unknown")} />
        {commonFields}
      </>
    );
  };

  // --------------------------------------------------------------------------
  // Render
  // --------------------------------------------------------------------------
  if (loading) return <TransactionLogSkeleton />;
  if (error)
    return (
      <div className="py-12 text-center text-red-600 dark:text-red-400">
        {error}
      </div>
    );

  return (
    <>
      {/* Header + Search */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between mb-5">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-gray-100">
          {t("pageTitle")}
        </h1>
        <input
          type="text"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder={t("searchPlaceholder")}
          className="w-full sm:w-64 rounded-lg bg-white dark:bg-gray-800 px-4 py-2 text-sm border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary-400 dark:focus:ring-primary-500"
        />
      </div>

      {/* Search result count */}
      {search.trim() && (
        <div className="mb-4 text-sm text-gray-600 dark:text-gray-300">
          {t("searchResults", { count: filteredTransactions.length, term: search })}
        </div>
      )}

      {/* Table Card */}
      <div className="rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
        {/* Table Header Section */}
        <div className="p-5 border-b border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800">
          <h2 className="text-xl font-bold text-gray-900 dark:text-white">
            {t("tableTitle")}
          </h2>
        </div>

        {/* Table */}
        <div className="overflow-x-auto scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600">
          <div className="inline-block min-w-full align-middle">
            <div className="overflow-hidden bg-white dark:bg-gray-800">
              <table className="min-w-[1100px] w-full divide-y divide-gray-100 dark:divide-gray-700">
                <thead className="bg-gray-50 dark:bg-gray-900/40 sticky top-0 z-10">
                  <tr>
                    <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.transaction")}
                    </th>
                    <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.status")}
                    </th>
                    <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.transactionId")}
                    </th>
                    <th className="px-6 py-4 text-right text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.amount")}
                    </th>
                    <th className="px-6 py-4 text-right text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.payable")}
                    </th>
                    <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.feesCharges")}
                    </th>
                    <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.currentBalance")}
                    </th>
                    <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-gray-200 whitespace-nowrap">
                      {t("columns.timeDate")}
                    </th>
                  </tr>
                </thead>

                <tbody className="divide-y divide-gray-100 dark:divide-gray-700 bg-white dark:bg-gray-800">
                  {paginatedTx.length === 0 ? (
                    <tr>
                      <td colSpan={8} className="py-12 text-center text-gray-500 dark:text-gray-300">
                        {search.trim() ? t("empty.noMatch") : t("empty.noTransactions")}
                      </td>
                    </tr>
                  ) : (
                    paginatedTx.map((log) => (
                      <TransactionRow
                        key={log.trx || log.id}
                        log={log}
                        onClick={() => setSelectedTx(log)}
                      />
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2 mt-6">
          <button
            onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
            disabled={currentPage === 1}
            className="flex items-center justify-center w-9 h-9 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>

          {[...Array(totalPages)].map((_, i) => {
            const page = i + 1;
            if (Math.abs(page - currentPage) > 2 && page !== 1 && page !== totalPages)
              return null;
            return (
              <button
                key={page}
                onClick={() => setCurrentPage(page)}
                className={`w-9 h-9 rounded-lg border text-sm font-medium cursor-pointer ${
                  currentPage === page
                    ? "bg-primary-600 text-white border-primary-600 dark:bg-primary-700 dark:border-primary-700 dark:hover:bg-primary-600"
                    : "bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-700"
                }`}
              >
                {page}
              </button>
            );
          })}

          <button
            onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
            disabled={currentPage === totalPages}
            className="flex items-center justify-center w-9 h-9 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
          >
            <ChevronRight className="w-5 h-5" />
          </button>
        </div>
      )}

      {/* Modal */}
      {selectedTx && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/45 backdrop-blur-none p-4">
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 px-6 py-4 flex justify-between items-center z-10">
              <h2 className="text-xl font-bold text-gray-900 dark:text-gray-100">
                {t("modal.title")}
              </h2>
              <button
                onClick={() => setSelectedTx(null)}
                className="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full cursor-pointer"
              >
                <X size={24} className="text-gray-700 dark:text-gray-300" />
              </button>
            </div>

            <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-5">
              {renderModalContent()}
            </div>

            <div className="sticky bottom-0 bg-gray-50 dark:bg-gray-900 border-t border-gray-200 dark:border-gray-700 px-6 py-4 text-right">
              <button
                onClick={() => setSelectedTx(null)}
                className="px-6 py-2.5 bg-primary-600 dark:bg-primary-700 text-white rounded-lg hover:bg-primary-700 dark:hover:bg-primary-600 transition cursor-pointer"
              >
                {t("modal.close")}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

// ============================================================================
// HELPER COMPONENT
// ============================================================================

const DetailRow = ({ label, value, isMono = false }) => (
  <div>
    <dt className="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">
      {label}
    </dt>
    <dd className={`text-sm text-gray-900 dark:text-gray-100 ${isMono ? "font-mono" : ""}`}>
      {value || "—"}
    </dd>
  </div>
);

export default AllTransactionLog;
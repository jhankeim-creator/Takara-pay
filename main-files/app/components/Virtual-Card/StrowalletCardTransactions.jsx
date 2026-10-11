"use client";

import { useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { getStrowalletCardTransactions } from "../../utils/api";
import Loader from "../Loader";

const formatDate = (isoString) => {
  if (!isoString) return "—";
  const date = new Date(isoString);
  return date.toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const formatAmount = (str) => str || "—";

const getTransactionColor = (status) => {
  switch (status?.toLowerCase()) {
    case "success":
    case "successful":
      return "bg-emerald-50 text-emerald-700 border-emerald-200";
    case "pending":
    case "processing":
      return "bg-amber-50 text-amber-700 border-amber-200";
    case "failed":
    case "failure":
    case "rejected":
      return "bg-red-50 text-red-700 border-red-200";
    default:
      return "bg-gray-50 text-gray-700 border-gray-200";
  }
};

export default function StrowalletCardTransactions() {
  const searchParams = useSearchParams();
  const cardId = searchParams.get("card_id");

  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!cardId) {
      setError("No card selected.");
      setLoading(false);
      return;
    }

    const fetchTransactions = async () => {
      try {
        setLoading(true);
        setError(null);
        const res = await getStrowalletCardTransactions(cardId);

        if (res?.message?.error) {
          setError(res.message.error[0] || "Failed to load transactions");
          toast.error(res.message.error[0] || "Failed to load transactions");
          return;
        }

        setTransactions(
          res?.data?.transactions || res?.data?.card_transactions || [],
        );
      } catch (err) {
        setError("Something went wrong. Please try again later.");
        toast.error("Something went wrong. Please try again later");
      } finally {
        setLoading(false);
      }
    };

    fetchTransactions();
  }, [cardId]);

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-[50vh]">
        <Loader />
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12 px-4">
        <div className="max-w-md mx-auto bg-red-50 border border-red-200 rounded-xl p-6 text-red-700">
          {error}
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-gray-100">
          Card Transactions
        </h1>
        <a
          href={`/dashboard/Virtual-Card/StrowalletWebhookLogs?card_id=${cardId}`}
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center gap-2 px-5 py-2.5 btn-primary text-white rounded-xl font-medium shadow-sm transition-colors cursor-pointer"
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
              d="M14 5l7 7m0 0l-7 7m7-7H3"
            />
          </svg>
          Webhook Logs
        </a>
      </div>

      {/* Transaction table */}
      <div className="bg-white rounded-2xl shadow border border-gray-200 overflow-hidden">
        <div className="px-6 py-5 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">
            Transaction History
          </h2>
          <p className="text-sm text-gray-500 mt-1">
            All activity related to this virtual card (Strowallet)
          </p>
        </div>

        {transactions.length === 0 ? (
          <div className="py-16 text-center text-gray-500">
            No transactions found yet.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Date
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Reference
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Narrative
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Type
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Method
                  </th>
                  <th className="px-6 py-4 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Amount
                  </th>
                  <th className="px-6 py-4 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 bg-white">
                {transactions.map((tx) => {
                  const isCredit = tx.type?.toLowerCase() === "credit";
                  const cur = (tx.currency || "").toUpperCase();
                  return (
                    <tr
                      key={tx.id}
                      className="hover:bg-gray-50 transition-colors"
                    >
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                        {formatDate(tx.createdAt)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-mono text-gray-600">
                        {tx.reference || "—"}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">
                        {tx.narrative || "—"}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm">
                        <span
                          className={`capitalize font-medium ${
                            isCredit ? "text-emerald-600" : "text-red-600"
                          }`}
                        >
                          {tx.type || "—"}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700 capitalize">
                        {tx.method || "—"}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-semibold">
                        <span
                          className={isCredit ? "text-emerald-600" : "text-red-600"}
                        >
                          {isCredit ? "+" : "-"}
                          {formatAmount(tx.amount)} {cur}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-center">
                        <span
                          className={`inline-flex px-3 py-1 rounded-full text-xs font-medium border capitalize ${getTransactionColor(
                            tx.status,
                          )}`}
                        >
                          {tx.status || "Unknown"}
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

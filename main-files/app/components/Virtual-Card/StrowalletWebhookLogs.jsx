"use client";

import {
  ArrowDownUp,
  CalendarClock,
  ChevronDown,
  CreditCard,
  FileText,
  Hash,
  Info,
  ShieldCheck,
  Tag,
  Wallet,
} from "lucide-react";
import { useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { getStrowalletWebhookLogs } from "../../utils/api";
import Loader from "../Loader";

const formatDateTime = (isoString) => {
  if (!isoString) return "—";
  const d = new Date(isoString);
  return d.toLocaleString("en-GB", {
    day: "2-digit",
    month: "2-digit",
    year: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
  });
};

const statusColor = (status) => {
  switch (String(status).toLowerCase()) {
    case "success":
    case "successful":
      return "text-emerald-600 dark:text-emerald-400";
    case "failed":
    case "failure":
    case "declined":
      return "text-red-600 dark:text-red-400";
    case "pending":
    case "processing":
      return "text-amber-600 dark:text-amber-400";
    default:
      return "text-gray-700 dark:text-gray-300";
  }
};

/* One label/value row inside a log card */
const LogRow = ({ icon: Icon, label, value, valueClass = "" }) => {
  if (value === undefined || value === null || value === "") return null;
  return (
    <div className="flex items-center gap-4 px-5 sm:px-6 py-3.5 border-b border-indigo-100/70 dark:border-gray-700/60 last:border-0">
      <span className="shrink-0 w-9 h-9 rounded-full bg-indigo-100 dark:bg-indigo-900/40 flex items-center justify-center">
        <Icon className="w-4.5 h-4.5 text-indigo-600 dark:text-indigo-400" />
      </span>
      <span className="text-gray-600 dark:text-gray-300 font-medium">
        {label}
      </span>
      <span
        className={`ml-auto text-right font-semibold text-gray-900 dark:text-gray-100 break-all ${valueClass}`}
      >
        {value}
      </span>
    </div>
  );
};

/* One webhook log as an FAQ-style accordion (click header to expand) */
const WebhookLogItem = ({ log }) => {
  const [open, setOpen] = useState(false);
  const isFailed = ["failed", "failure", "declined"].includes(
    String(log.status).toLowerCase(),
  );

  return (
    <div className="rounded-2xl overflow-hidden border border-gray-200 dark:border-gray-700 shadow-sm bg-white dark:bg-gray-800">
      {/* Header (clickable) */}
      <button
        type="button"
        onClick={() => setOpen((o) => !o)}
        className="w-full flex items-center gap-4 px-5 sm:px-6 py-4 bg-indigo-50 dark:bg-indigo-900/20 hover:bg-indigo-100/70 dark:hover:bg-indigo-900/30 transition-colors cursor-pointer text-left"
      >
        <span
          className={`shrink-0 w-12 h-12 rounded-full flex items-center justify-center text-white ${
            isFailed ? "bg-red-500" : "bg-indigo-500"
          }`}
        >
          <ArrowDownUp className="w-6 h-6" />
        </span>
        <h3 className="text-base sm:text-lg font-bold text-gray-900 dark:text-gray-100">
          {log.event || log.event_type || "Webhook Event"}
        </h3>
        <span className="ml-auto text-base font-bold text-indigo-600 dark:text-indigo-400 whitespace-nowrap">
          {log.amount || "—"}
        </span>
        <ChevronDown
          className={`shrink-0 w-5 h-5 text-gray-500 dark:text-gray-400 transition-transform duration-300 ${
            open ? "rotate-180" : ""
          }`}
        />
      </button>

      {/* Details (collapsible) */}
      <div
        className="grid transition-all duration-300 ease-in-out"
        style={{ gridTemplateRows: open ? "1fr" : "0fr" }}
      >
        <div className="overflow-hidden">
          <div className="text-sm">
            <LogRow icon={Hash} label="TRX ID" value={log.transition_id} />
            <LogRow icon={CreditCard} label="Card Id" value={log.card_id} />
            <LogRow icon={Tag} label="Reference" value={log.reference} />
            <LogRow icon={FileText} label="Narration" value={log.narrative} />
            <LogRow icon={Info} label="Reason" value={log.reason} />
            <LogRow
              icon={Wallet}
              label="Charge Amount"
              value={log.charge_amount}
            />
            <LogRow
              icon={Wallet}
              label="Balance Before Termination"
              value={log.balance_before_termination}
            />
            <LogRow
              icon={ShieldCheck}
              label="Status"
              value={log.status}
              valueClass={`capitalize ${statusColor(log.status)}`}
            />
            <LogRow
              icon={CalendarClock}
              label="Time & Date"
              value={formatDateTime(log.created_at)}
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default function StrowalletWebhookLogs() {
  const searchParams = useSearchParams();
  const cardId = searchParams.get("card_id");

  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!cardId) {
      setError("No card selected.");
      setLoading(false);
      return;
    }

    const fetchLogs = async () => {
      try {
        setLoading(true);
        setError(null);
        const res = await getStrowalletWebhookLogs(cardId);
        if (res?.message?.error) {
          setError(res.message.error[0] || "Failed to load webhook logs");
          toast.error(res.message.error[0] || "Failed to load webhook logs");
          return;
        }
        setLogs(res?.data?.transactions || res?.data?.logs || []);
      } catch (err) {
        setError("Something went wrong. Please try again later.");
        toast.error("Something went wrong. Please try again later");
      } finally {
        setLoading(false);
      }
    };

    fetchLogs();
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
    <div className="max-w-4xl mx-auto">
      <h1 className="text-2xl sm:text-3xl font-bold text-gray-900 dark:text-gray-100 mb-8">
        Webhook Logs
      </h1>

      {logs.length === 0 ? (
        <div className="bg-white dark:bg-gray-800 rounded-2xl border border-gray-200 dark:border-gray-700 py-16 text-center text-gray-500">
          No webhook logs found yet.
        </div>
      ) : (
        <div className="space-y-4">
          {logs.map((log, i) => (
            <WebhookLogItem key={log.transition_id || log.reference || i} log={log} />
          ))}
        </div>
      )}
    </div>
  );
}

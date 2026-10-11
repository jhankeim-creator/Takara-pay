"use client";

import {
  ArrowDownToLine,
  Banknote,
  BadgeCheck,
  CalendarClock,
  CreditCard,
  Hash,
  Layers,
  Receipt,
  ShieldCheck,
  Star,
  User,
  Wallet,
} from "lucide-react";
import Image from "next/image";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import {
  freezeStrowalletCard,
  getStrowalletCardDetails,
  getStrowalletCards,
  setStrowalletCardAsDefault,
  unfreezeStrowalletCard,
} from "../../utils/api";
import Loader from "../Loader";

/* Reusable confirmation modal */
const ConfirmModal = ({
  open,
  title,
  message,
  confirmLabel,
  confirmClass,
  loading,
  onConfirm,
  onCancel,
}) => {
  if (!open) return null;
  return (
    <div
      className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4"
      onClick={onCancel}
    >
      <div
        className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-md w-full overflow-hidden"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="px-6 py-5 border-b border-gray-200 dark:border-gray-700">
          <h3 className="text-xl font-semibold text-gray-900 dark:text-gray-100">
            {title}
          </h3>
        </div>
        <div className="p-6 text-gray-600 dark:text-gray-300">{message}</div>
        <div className="bg-gray-50 dark:bg-gray-700/50 px-6 py-4 flex justify-end gap-3 border-t border-gray-200 dark:border-gray-700">
          <button
            type="button"
            onClick={onCancel}
            disabled={loading}
            className="px-5 py-2.5 text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors cursor-pointer disabled:opacity-50"
          >
            Cancel
          </button>
          <button
            type="button"
            onClick={onConfirm}
            disabled={loading}
            className={`px-6 py-2.5 text-white font-medium rounded-lg transition-colors shadow-sm cursor-pointer disabled:opacity-50 ${confirmClass}`}
          >
            {loading ? "Processing..." : confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
};

const formatCardNumber = (num) =>
  num
    ? num.replace(/\D/g, "").replace(/(\d{4})(?=\d)/g, "$1 ").trim()
    : "•••• •••• •••• ••••";

/* A single detail row: icon chip + label on the left, value on the right. */
const Row = ({ icon: Icon, label, children, last }) => (
  <div
    className={`flex items-center gap-4 px-5 sm:px-6 py-4 ${
      last ? "" : "border-b border-indigo-100/70 dark:border-gray-700/60"
    }`}
  >
    <span className="shrink-0 w-10 h-10 rounded-full bg-indigo-100 dark:bg-indigo-900/40 flex items-center justify-center">
      <Icon className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
    </span>
    <span className="text-gray-600 dark:text-gray-300 font-medium">{label}</span>
    <span className="ml-auto text-right text-gray-900 dark:text-gray-100 font-semibold break-all">
      {children}
    </span>
  </div>
);

export default function StrowalletCardDetails() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const cardId = searchParams.get("card_id");

  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Action states
  const [defaultLoading, setDefaultLoading] = useState(false);
  const [statusLoading, setStatusLoading] = useState(false);
  const [showDefaultModal, setShowDefaultModal] = useState(false);
  const [showStatusModal, setShowStatusModal] = useState(false);
  const [statusAction, setStatusAction] = useState(null); // "freeze" | "unfreeze"

  useEffect(() => {
    if (!cardId) {
      setError("No card selected.");
      setLoading(false);
      return;
    }

    const fetchDetails = async () => {
      try {
        setLoading(true);
        setError(null);
        // Details endpoint doesn't return CVV — fetch the list too and merge it.
        const [res, listRes] = await Promise.all([
          getStrowalletCardDetails(cardId),
          getStrowalletCards(),
        ]);
        if (res?.message?.error) {
          toast.error(res.message.error[0] || "Failed to load card details");
        }
        const d = res?.data || null;
        if (d?.myCards && !d.myCards.cvv) {
          const list = listRes?.data?.myCards || [];
          const match =
            list.find((c) => c.id === d.myCards.id) ||
            list.find((c) => c.card_id === d.myCards.card_id && c.cvv);
          if (match?.cvv) d.myCards.cvv = match.cvv;
        }
        setData(d);
      } catch (err) {
        setError(err.message || "Failed to load card details");
        toast.error("Failed to load card details");
      } finally {
        setLoading(false);
      }
    };

    fetchDetails();
  }, [cardId]);

  const card = data?.myCards || {};
  const baseCurr = data?.base_curr || "USD";
  const isDefault = !!card.is_default;
  const isActive = !!card.status; // true = active (unfrozen)

  /* Refresh details after an action */
  const refreshDetails = async () => {
    try {
      const res = await getStrowalletCardDetails(cardId);
      if (res?.data) setData(res.data);
    } catch {
      /* ignore */
    }
  };

  /* Make / remove default */
  const handleMakeDefault = async () => {
    if (defaultLoading) return;
    try {
      setDefaultLoading(true);
      const res = await setStrowalletCardAsDefault(cardId);
      if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to update default");
      } else {
        toast.success(res?.message?.success?.[0] || "Default card updated");
        await refreshDetails();
      }
    } catch {
      toast.error("Failed to update default card");
    } finally {
      setDefaultLoading(false);
      setShowDefaultModal(false);
    }
  };

  /* Freeze / unfreeze */
  const handleStatus = async (action) => {
    if (statusLoading) return;
    try {
      setStatusLoading(true);
      const res =
        action === "freeze"
          ? await freezeStrowalletCard(cardId)
          : await unfreezeStrowalletCard(cardId);
      if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to update card status");
      } else {
        toast.success(
          res?.message?.success?.[0] ||
            (action === "freeze" ? "Card frozen" : "Card unfrozen"),
        );
        await refreshDetails();
      }
    } catch {
      toast.error("Failed to update card status");
    } finally {
      setStatusLoading(false);
      setShowStatusModal(false);
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center py-32">
        <Loader />
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-2xl p-8 text-red-700 dark:text-red-400 text-center shadow-sm">
        {error}
      </div>
    );
  }

  if (!card.card_id) {
    return (
      <div className="bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-2xl p-8 text-center text-yellow-800 dark:text-yellow-300 shadow-sm">
        No card found.
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto">
      <h1 className="text-2xl sm:text-3xl font-bold text-gray-900 dark:text-gray-100 mb-8">
        Card Details
      </h1>

      <div className="grid grid-cols-1 md:grid-cols-12 gap-8">
        {/* ── LEFT: Card visual + actions + billing ───────────── */}
        <div className="md:col-span-5 space-y-6">
          {/* Virtual card */}
          <div
            className="relative text-white rounded-3xl shadow-2xl overflow-hidden aspect-[1.6/1]"
            style={
              card.card_bg
                ? {
                    backgroundImage: `url(${card.card_bg})`,
                    backgroundSize: "cover",
                    backgroundPosition: "center",
                  }
                : {}
            }
          >
            {!card.card_bg && (
              <div className="absolute inset-0 bg-linear-to-br from-indigo-950 via-indigo-900 to-slate-900" />
            )}
            <div className="absolute inset-0 bg-linear-to-br from-white/10 via-transparent to-transparent pointer-events-none" />

            <div className="relative h-full p-6 flex flex-col justify-between z-10">
              <div className="flex justify-between items-start">
                <span className="text-lg font-bold tracking-widest">
                  {(card.site_title || "TAKARA PAY").toUpperCase()}
                </span>
                {card.site_logo && (
                  <Image
                    src="/logo/favicon-white.webp"
                    alt="logo"
                    width={40}
                    height={40}
                    className="object-contain opacity-90"
                  />
                )}
              </div>

              <div className="flex items-center gap-3 -mt-2">
                <div className="w-12 h-9 relative">
                  <Image src="/Others/Chip.webp" alt="chip" fill className="object-contain" />
                </div>
                <div className="w-7 h-7 relative">
                  <Image
                    src="/Others/waves.webp"
                    alt="contactless"
                    fill
                    className="object-contain opacity-90"
                  />
                </div>
              </div>

              <div className="flex justify-between text-xl sm:text-2xl font-mono font-medium tracking-wide">
                {formatCardNumber(card.card_number)
                  .split(" ")
                  .map((g, i) => (
                    <span key={i}>{g}</span>
                  ))}
              </div>

              <div className="flex items-center gap-2 -mb-1">
                <span className="text-[10px] text-white/60 uppercase tracking-wider">
                  Exp. End:
                </span>
                <span className="text-sm font-medium">{card.expiry || "••/••"}</span>
              </div>

              <div className="flex justify-between items-end">
                <span className="text-base font-medium uppercase tracking-wide">
                  {card.name || "CARD HOLDER"}
                </span>
                <div className="w-14 h-9 relative">
                  <Image src="/Others/Visa-Logo.webp" alt="brand" fill className="object-contain" />
                </div>
              </div>
            </div>
          </div>

          {/* Action buttons (static for now) */}
          <div className="flex justify-around bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-5">
            <button
              type="button"
              onClick={() =>
                router.push(
                  `/dashboard/Virtual-Card/FundStrowalletCard?card_id=${cardId}`,
                )
              }
              className="group flex flex-col items-center gap-2 cursor-pointer"
            >
              <span className="w-11 h-11 rounded-full bg-indigo-50 dark:bg-indigo-900/30 flex items-center justify-center group-hover:bg-indigo-100 transition-colors">
                <Banknote className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
              </span>
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Fund</span>
            </button>

            <button
              type="button"
              onClick={() =>
                router.push(
                  `/dashboard/Virtual-Card/WithdrawStrowalletCard?card_id=${cardId}`,
                )
              }
              className="group flex flex-col items-center gap-2 cursor-pointer"
            >
              <span className="w-11 h-11 rounded-full bg-rose-50 dark:bg-rose-900/30 flex items-center justify-center group-hover:bg-rose-100 transition-colors">
                <ArrowDownToLine className="w-5 h-5 text-rose-600 dark:text-rose-400" />
              </span>
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                Withdraw
              </span>
            </button>

            <button
              type="button"
              onClick={() => setShowDefaultModal(true)}
              disabled={defaultLoading}
              className="group flex flex-col items-center gap-2 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span
                className={`w-11 h-11 rounded-full flex items-center justify-center transition-colors ${
                  isDefault
                    ? "bg-amber-500 text-white"
                    : "bg-amber-50 dark:bg-amber-900/30 text-amber-500 group-hover:bg-amber-100"
                }`}
              >
                {defaultLoading ? (
                  <svg className="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
                  </svg>
                ) : (
                  <Star className="w-5 h-5" fill={isDefault ? "currentColor" : "none"} />
                )}
              </span>
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                {isDefault ? "Remove Default" : "Make Default"}
              </span>
            </button>

            <button
              type="button"
              onClick={() =>
                router.push(
                  `/dashboard/Virtual-Card/StrowalletCardTransactions?card_id=${cardId}`,
                )
              }
              className="group flex flex-col items-center gap-2 cursor-pointer"
            >
              <span className="w-11 h-11 rounded-full bg-emerald-50 dark:bg-emerald-900/30 flex items-center justify-center group-hover:bg-emerald-100 transition-colors">
                <Receipt className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
              </span>
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                Transactions
              </span>
            </button>
          </div>

          {/* Billing Address */}
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
            <h3 className="text-xl font-bold text-gray-900 dark:text-gray-100 text-center py-4 border-b border-gray-100 dark:border-gray-700">
              Billing Address
            </h3>
            <div className="divide-y divide-gray-100 dark:divide-gray-700/60">
              <div className="px-6 py-4">
                <p className="text-sm font-semibold text-gray-800 dark:text-gray-200">
                  Billing Country
                </p>
                <p className="text-gray-600 dark:text-gray-400">United States</p>
              </div>
              <div className="px-6 py-4">
                <p className="text-sm font-semibold text-gray-800 dark:text-gray-200">
                  Billing City
                </p>
                <p className="text-gray-600 dark:text-gray-400">Miami</p>
              </div>
              <div className="px-6 py-4">
                <p className="text-sm font-semibold text-gray-800 dark:text-gray-200">
                  Billing Address
                </p>
                <p className="text-gray-600 dark:text-gray-400">
                  3401 N. Miami, Ave. Ste 230
                </p>
              </div>
              <div className="px-6 py-4">
                <p className="text-sm font-semibold text-gray-800 dark:text-gray-200">
                  Billing Zip Code
                </p>
                <p className="text-gray-600 dark:text-gray-400">33127</p>
              </div>
            </div>
          </div>
        </div>

        {/* ── RIGHT: Detail rows ──────────────────────────────── */}
        <div className="md:col-span-7">
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
            <Row icon={Wallet} label="Card Amount">
              {Number(card.amount || 0)} {baseCurr}
            </Row>
            <Row icon={Layers} label="Card Type">
              <span className="capitalize">{card.card_type || "Virtual"}</span>
            </Row>
            <Row icon={CreditCard} label="Card Id">
              {card.card_id || "—"}
            </Row>
            <Row icon={User} label="Customer Id">
              {card.customer_id || "—"}
            </Row>
            <Row icon={Hash} label="Card Number">
              <span className="font-mono tracking-wider">
                {formatCardNumber(card.card_number)}
              </span>
            </Row>
            <Row icon={ShieldCheck} label="Cvv">
              <span className="font-mono">
                {card.cvv || card.card_cvv || card.cvv2 || "•••"}
              </span>
            </Row>
            <Row icon={CalendarClock} label="Expiration">
              {card.expiry || "••/••"}
            </Row>
            <Row icon={BadgeCheck} label="Brand">
              <span className="capitalize">{card.card_brand || "—"}</span>
            </Row>

            {/* Status — Unfreeze / Freeze segmented toggle */}
            <Row icon={CreditCard} label="Status" last>
              <div className="inline-flex rounded-lg overflow-hidden border border-indigo-200 dark:border-indigo-800">
                <button
                  type="button"
                  onClick={() => {
                    setStatusAction("unfreeze");
                    setShowStatusModal(true);
                  }}
                  disabled={statusLoading || isActive}
                  className={`px-4 py-1.5 text-sm font-semibold transition-colors ${
                    isActive
                      ? "bg-indigo-600 text-white cursor-default"
                      : "bg-transparent text-gray-600 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-indigo-900/30 cursor-pointer disabled:opacity-60"
                  }`}
                >
                  Unfreeze
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setStatusAction("freeze");
                    setShowStatusModal(true);
                  }}
                  disabled={statusLoading || !isActive}
                  className={`px-4 py-1.5 text-sm font-semibold transition-colors ${
                    !isActive
                      ? "bg-indigo-600 text-white cursor-default"
                      : "bg-transparent text-gray-600 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-indigo-900/30 cursor-pointer disabled:opacity-60"
                  }`}
                >
                  Freeze
                </button>
              </div>
            </Row>
          </div>

          {/* Card back details */}
          {card.card_back_details && (
            <div className="mt-6 bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6">
              <div
                className="prose prose-sm max-w-none text-gray-600 dark:text-gray-300 dark:prose-invert"
                dangerouslySetInnerHTML={{ __html: card.card_back_details }}
              />
            </div>
          )}
        </div>
      </div>

      {/* Make / remove default confirmation */}
      <ConfirmModal
        open={showDefaultModal}
        title={isDefault ? "Remove Default Card" : "Make Default Card"}
        message={
          isDefault
            ? "Are you sure you want to remove this card as your default card?"
            : "Are you sure you want to set this card as your default card?"
        }
        confirmLabel={isDefault ? "Remove Default" : "Make Default"}
        confirmClass="bg-amber-600 hover:bg-amber-700"
        loading={defaultLoading}
        onConfirm={handleMakeDefault}
        onCancel={() => setShowDefaultModal(false)}
      />

      {/* Freeze / unfreeze confirmation */}
      <ConfirmModal
        open={showStatusModal}
        title={statusAction === "freeze" ? "Freeze Card" : "Unfreeze Card"}
        message={
          statusAction === "freeze"
            ? "Are you sure you want to freeze this card? It cannot be used until unfrozen."
            : "Are you sure you want to unfreeze this card and make it active again?"
        }
        confirmLabel={statusAction === "freeze" ? "Freeze" : "Unfreeze"}
        confirmClass={
          statusAction === "freeze"
            ? "bg-rose-600 hover:bg-rose-700"
            : "bg-indigo-600 hover:bg-indigo-700"
        }
        loading={statusLoading}
        onConfirm={() => handleStatus(statusAction)}
        onCancel={() => setShowStatusModal(false)}
      />
    </div>
  );
}

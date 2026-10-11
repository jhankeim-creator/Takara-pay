"use client";

import {
  BadgeCheck,
  Banknote,
  CalendarClock,
  Coins,
  CreditCard,
  Eye,
  EyeOff,
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
  blockSudoCard,
  getSoduCardDetails,
  setSudoCardAsDefault,
  unblockSudoCard,
} from "../../utils/api";
import Loader from "../Loader";

// Secure Proxy Show library (same script for sandbox & live, per Sudo docs).
const SECURE_PROXY_SRC =
  "https://js.securepro.xyz/sudo-show/1.1/ACiWvWF9tYAez4M498DHs.min.js";

// Fixed Secure Proxy vault IDs from Sudo docs (NOT the api_vault_id in the response).
const SECURE_VAULTS = { sandbox: "we0dsa28s", live: "vdl2xefo5" };
const getVaultId = (apiMode) =>
  apiMode === "live" || apiMode === "production"
    ? SECURE_VAULTS.live
    : SECURE_VAULTS.sandbox;

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

export default function VirtualCardDetails() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const cardId = searchParams.get("card_id");

  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Reveal (Secure Proxy) states
  const [scriptLoaded, setScriptLoaded] = useState(false);
  const [revealed, setRevealed] = useState(false);
  const [revealing, setRevealing] = useState(false);
  const [creds, setCreds] = useState(null); // { vaultId, token, cardId }

  // Action states
  const [defaultLoading, setDefaultLoading] = useState(false);
  const [statusLoading, setStatusLoading] = useState(false);

  // Confirmation modals
  const [showDefaultModal, setShowDefaultModal] = useState(false);
  const [showStatusModal, setShowStatusModal] = useState(false);
  const [statusAction, setStatusAction] = useState(null); // "block" | "unblock"

  /* Load card details */
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
        const res = await getSoduCardDetails(cardId);
        if (res?.message?.error) {
          toast.error(res.message.error[0] || "Failed to load card details");
        }
        setData(res?.data || null);
      } catch (err) {
        setError(err.message || "Failed to load card details");
        toast.error("Failed to load card details");
      } finally {
        setLoading(false);
      }
    };

    fetchDetails();
  }, [cardId]);

  /* Inject the Secure Proxy Show script once */
  useEffect(() => {
    if (typeof window === "undefined") return;
    if (window.SecureProxy) {
      setScriptLoaded(true);
      return;
    }
    const existing = document.querySelector("script[data-secure-proxy]");
    if (existing) {
      existing.addEventListener("load", () => setScriptLoaded(true));
      return;
    }
    const s = document.createElement("script");
    s.src = SECURE_PROXY_SRC;
    s.async = true;
    s.dataset.secureProxy = "true";
    s.onload = () => setScriptLoaded(true);
    s.onerror = () => toast.error("Failed to load secure card viewer");
    document.body.appendChild(s);
  }, []);

  /* Render the secure iframes once revealed + creds + script are ready */
  useEffect(() => {
    if (!revealed || !scriptLoaded || !creds || !window.SecureProxy) return;

    const numEl = document.getElementById("sp-card-number");
    const cvvEl = document.getElementById("sp-cvv");
    if (!numEl || !cvvEl) return;

    numEl.innerHTML = "";
    cvvEl.innerHTML = "";

    try {
      const numberSecret = window.SecureProxy.create(creds.vaultId);
      const cvvSecret = window.SecureProxy.create(creds.vaultId);

      const numberIframe = numberSecret.request({
        name: "pan-text",
        method: "GET",
        path: `/cards/${creds.cardId}/secure-data/number`,
        headers: { Authorization: `Bearer ${creds.token}` },
        htmlWrapper: "text",
        jsonPathSelector: "data.number",
        serializers: [
          numberSecret.SERIALIZERS.replace(
            "(\\d{4})(\\d{4})(\\d{4})(\\d{4})",
            "$1 $2 $3 $4 ",
          ),
        ],
      });
      numberIframe.render("#sp-card-number");

      const cvvIframe = cvvSecret.request({
        name: "cvv-text",
        method: "GET",
        path: `/cards/${creds.cardId}/secure-data/cvv2`,
        headers: { Authorization: `Bearer ${creds.token}` },
        htmlWrapper: "text",
        jsonPathSelector: "data.cvv2",
        serializers: [],
      });
      cvvIframe.render("#sp-cvv");
    } catch (e) {
      toast.error("Failed to display secure card data");
    }
  }, [revealed, scriptLoaded, creds]);

  const card = data?.card_details || {};
  const baseCurr = data?.base_curr || card.currency || "USD";
  const isDefault = !!card.is_default;
  const isActive = !!card.status; // true = active / unblocked
  const isSandbox = card.card_api_mode === "sandbox";

  const formatPan = (pan) =>
    pan ? (pan.match(/.{1,4}/g) || []).join(" ") : "•••• •••• •••• ••••";

  const last4 = card.card_pan ? card.card_pan.slice(-4) : "••••";

  /* Reveal / hide real card number + CVV via Secure Proxy */
  const handleReveal = async () => {
    if (revealed) {
      setRevealed(false);
      setCreds(null);
      const n = document.getElementById("sp-card-number");
      const c = document.getElementById("sp-cvv");
      if (n) n.innerHTML = "";
      if (c) c.innerHTML = "";
      return;
    }

    if (!scriptLoaded || !window.SecureProxy) {
      toast.error("Secure viewer is still loading, please try again");
      return;
    }

    try {
      setRevealing(true);
      // Fetch a FRESH token — the card token expires after ~2 minutes.
      const res = await getSoduCardDetails(cardId);
      const secure = res?.data?.card_secure_date;
      const cId = res?.data?.card_details?.card_id || card.card_id;

      if (!secure?.card_token || !cId) {
        toast.error("Secure card data is unavailable");
        return;
      }

      if (res?.data) setData(res.data);
      setCreds({
        // Documented Secure Proxy vault id (sandbox/live) — NOT api_vault_id.
        vaultId: getVaultId(secure.api_mode),
        token: secure.card_token,
        cardId: cId,
      });
      setRevealed(true);
    } catch (err) {
      toast.error("Failed to reveal card details");
    } finally {
      setRevealing(false);
    }
  };

  /* Refresh card details after an action */
  const refreshDetails = async () => {
    try {
      const res = await getSoduCardDetails(cardId);
      if (res?.data) setData(res.data);
    } catch {
      /* ignore refresh failure */
    }
  };

  /* Make / remove default */
  const handleMakeDefault = async () => {
    if (defaultLoading) return;
    try {
      setDefaultLoading(true);
      const res = await setSudoCardAsDefault(cardId);
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

  /* Block / unblock */
  const handleStatus = async (action) => {
    if (statusLoading) return;
    try {
      setStatusLoading(true);
      const res =
        action === "block"
          ? await blockSudoCard(cardId)
          : await unblockSudoCard(cardId);
      if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to update card status");
      } else {
        toast.success(
          res?.message?.success?.[0] ||
            (action === "block" ? "Card blocked" : "Card unblocked"),
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
      <span className="text-gray-600 dark:text-gray-300 font-medium">
        {label}
      </span>
      <span className="ml-auto text-right text-gray-900 dark:text-gray-100 font-semibold">
        {children}
      </span>
    </div>
  );

  return (
    <div className="max-w-6xl mx-auto">
      {/* iframe sizing for Secure Proxy injected content */}
      <style>{`#sp-card-number iframe, #sp-cvv iframe { height: 24px; width: 100%; border: 0; vertical-align: middle; }`}</style>

      <div className="flex items-center justify-between flex-wrap gap-3 mb-8">
        <h1 className="text-2xl sm:text-3xl font-bold text-gray-900 dark:text-gray-100">
          Card Details
        </h1>
        {isSandbox && (
          <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-wide bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400">
            <span className="w-1.5 h-1.5 rounded-full bg-amber-500" />
            Test Mode
          </span>
        )}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {/* ── LEFT: Card visual + actions ─────────────────────── */}
        <div className="lg:col-span-5 space-y-6">
          {/* Virtual card */}
          <div className="relative text-white rounded-3xl shadow-2xl overflow-hidden aspect-[1.6/1] bg-linear-to-br from-indigo-950 via-indigo-900 to-slate-900">
            <div className="absolute inset-0 bg-linear-to-br from-white/10 via-transparent to-transparent pointer-events-none" />
            <div className="absolute -right-10 -top-10 w-56 h-56 rounded-full bg-white/5" />
            <div className="absolute -right-20 top-10 w-56 h-56 rounded-full bg-white/5" />

            <div className="relative h-full p-6 flex flex-col justify-between z-10">
              {/* Top: title + logo */}
              <div className="flex justify-between items-start">
                <span className="text-lg font-bold tracking-widest">
                  {(card.site_title || "STRIPCARD").toUpperCase()}
                </span>
                {card.site_logo ? (
                  <Image
                    src="/logo/favicon-white.webp"
                    alt="logo"
                    width={40}
                    height={40}
                    className="object-contain opacity-90"
                  />
                ) : null}
              </div>

              {/* Chip + contactless */}
              <div className="flex items-center gap-3 -mt-2">
                <div className="w-12 h-9 relative">
                  <Image
                    src="/Others/Chip.webp"
                    alt="chip"
                    fill
                    className="object-contain"
                  />
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

              {/* Card number */}
              <div className="flex justify-between text-xl sm:text-2xl font-mono font-medium tracking-wide">
                {formatPan(card.card_pan)
                  .split(" ")
                  .map((g, i) => (
                    <span key={i}>{g}</span>
                  ))}
              </div>

              {/* Expiry */}
              <div className="flex items-center gap-2 -mb-1">
                <span className="text-[10px] text-white/60 uppercase tracking-wider">
                  Exp. End:
                </span>
                <span className="text-sm font-medium">
                  {card.expiry_month || "••"} / {card.expiry_year || "••"}
                </span>
              </div>

              {/* Holder + brand */}
              <div className="flex justify-between items-end">
                <span className="text-base font-medium uppercase tracking-wide">
                  {card.card_holder || "CARD HOLDER"}
                </span>
                {/* Mastercard mark */}
                <div className="flex items-center -space-x-3">
                  <span className="w-8 h-8 rounded-full bg-red-500/90" />
                  <span className="w-8 h-8 rounded-full bg-amber-400/90 mix-blend-screen" />
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
                  `/dashboard/Virtual-Card/FundSudoCard?card_id=${cardId}`,
                )
              }
              className="group flex flex-col items-center gap-2 cursor-pointer"
            >
              <span className="w-11 h-11 rounded-full bg-indigo-50 dark:bg-indigo-900/30 flex items-center justify-center group-hover:bg-indigo-100 dark:group-hover:bg-indigo-900/50 transition-colors">
                <Banknote className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
              </span>
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                Fund
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
                    : "bg-amber-50 dark:bg-amber-900/30 text-amber-500 dark:text-amber-400 group-hover:bg-amber-100"
                }`}
              >
                {defaultLoading ? (
                  <svg
                    className="w-5 h-5 animate-spin"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      className="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      strokeWidth="4"
                    />
                    <path
                      className="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8v8H4z"
                    />
                  </svg>
                ) : (
                  <Star
                    className="w-5 h-5"
                    fill={isDefault ? "currentColor" : "none"}
                  />
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
                  `/dashboard/Virtual-Card/CardTransactions?card_id=${cardId}`,
                )
              }
              className="group flex flex-col items-center gap-2 cursor-pointer"
            >
              <span className="w-11 h-11 rounded-full bg-emerald-50 dark:bg-emerald-900/30 flex items-center justify-center group-hover:bg-emerald-100 dark:group-hover:bg-emerald-900/50 transition-colors">
                <Receipt className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
              </span>
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                Transactions
              </span>
            </button>
          </div>
        </div>

        {/* ── RIGHT: Detail rows ──────────────────────────────── */}
        <div className="lg:col-span-7">
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
            <Row icon={Wallet} label="Amount">
              {Number(card.amount || 0).toFixed(2)} {baseCurr}
            </Row>

            <Row icon={User} label="Card Holder">
              {card.card_holder || "—"}
            </Row>

            <Row icon={Coins} label="Currency">
              {card.currency || baseCurr}
            </Row>

            <Row icon={BadgeCheck} label="Brand">
              {card.brand || "—"}
            </Row>

            <Row icon={Layers} label="Type">
              <span className="capitalize">{card.type || "virtual"}</span>
            </Row>

            <Row icon={Hash} label="Card Pan">
              <span className="font-mono px-3 py-1.5 rounded-lg bg-gray-50 dark:bg-gray-900/40 border border-gray-200 dark:border-gray-700 tracking-wider inline-flex items-center min-w-[180px] justify-end">
                {/* Secure Proxy injects the real PAN here when revealed */}
                <span
                  id="sp-card-number"
                  className="w-full text-right"
                  style={{ display: revealed ? "block" : "none" }}
                />
                {!revealed && <span>{`•••• •••• •••• ${last4}`}</span>}
              </span>
            </Row>

            <Row icon={CalendarClock} label="Expiry">
              {card.expiry_month || "••"} / {card.expiry_year || "••"}
            </Row>

            <Row icon={ShieldCheck} label="CVV">
              <span className="font-mono px-3 py-1.5 rounded-lg bg-gray-50 dark:bg-gray-900/40 border border-gray-200 dark:border-gray-700 inline-flex items-center min-w-[64px] justify-center">
                <span
                  id="sp-cvv"
                  className="w-full text-center"
                  style={{ display: revealed ? "block" : "none" }}
                />
                {!revealed && <span>•••</span>}
              </span>
            </Row>

            {/* Card Status — Unblock / Block segmented toggle */}
            <Row icon={CreditCard} label="Card Status">
              <div className="inline-flex rounded-lg overflow-hidden border border-indigo-200 dark:border-indigo-800">
                <button
                  type="button"
                  onClick={() => {
                    setStatusAction("unblock");
                    setShowStatusModal(true);
                  }}
                  disabled={statusLoading || isActive}
                  className={`px-4 py-1.5 text-sm font-semibold transition-colors ${
                    isActive
                      ? "bg-indigo-600 text-white cursor-default"
                      : "bg-transparent text-gray-600 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-indigo-900/30 cursor-pointer disabled:opacity-60"
                  }`}
                >
                  Unblock
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setStatusAction("block");
                    setShowStatusModal(true);
                  }}
                  disabled={statusLoading || !isActive}
                  className={`px-4 py-1.5 text-sm font-semibold transition-colors ${
                    !isActive
                      ? "bg-indigo-600 text-white cursor-default"
                      : "bg-transparent text-gray-600 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-indigo-900/30 cursor-pointer disabled:opacity-60"
                  }`}
                >
                  Block
                </button>
              </div>
            </Row>

            {/* Reveal Details — Secure Proxy show/hide */}
            <Row icon={Eye} label="Reveal Details" last>
              <button
                type="button"
                onClick={handleReveal}
                disabled={revealing}
                className="cursor-pointer text-gray-500 dark:text-gray-400 hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors disabled:opacity-50"
                aria-label={revealed ? "Hide details" : "Reveal details"}
              >
                {revealing ? (
                  <svg
                    className="w-5 h-5 animate-spin"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      className="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      strokeWidth="4"
                    />
                    <path
                      className="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8v8H4z"
                    />
                  </svg>
                ) : revealed ? (
                  <Eye className="w-5 h-5" />
                ) : (
                  <EyeOff className="w-5 h-5" />
                )}
              </button>
            </Row>
          </div>

          {/* Card back details (terms) */}
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

      {/* Block / unblock confirmation */}
      <ConfirmModal
        open={showStatusModal}
        title={statusAction === "block" ? "Block Card" : "Unblock Card"}
        message={
          statusAction === "block"
            ? "Are you sure you want to block this card? It cannot be used until unblocked."
            : "Are you sure you want to unblock this card and make it active again?"
        }
        confirmLabel={statusAction === "block" ? "Block" : "Unblock"}
        confirmClass={
          statusAction === "block"
            ? "bg-red-600 hover:bg-red-700"
            : "bg-indigo-600 hover:bg-indigo-700"
        }
        loading={statusLoading}
        onConfirm={() => handleStatus(statusAction)}
        onCancel={() => setShowStatusModal(false)}
      />
    </div>
  );
}

"use client";

import Image from "next/image";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import Loader from "../../components/Loader";
import { getStrowalletCards } from "../../utils/api";
import { useDashboard } from "../../context/DashboardContext";

const formatCardNumber = (num) => {
  if (!num) return "•••• •••• •••• ••••";
  const cleaned = num.replace(/\D/g, "");
  return cleaned.replace(/(\d{4})(?=\d)/g, "$1 ").trim();
};

/* ──────────────────────────────────────────────────────────────
   Flip card: front shows the card, click flips to the back which
   shows the magnetic strip, CVV and the card-back terms.
─────────────────────────────────────────────────────────────── */
function FlipCard({ card, cardBasicInfo, user, onDetails }) {
  const [flipped, setFlipped] = useState(false);

  const holder =
    card.name ||
    `${user?.firstname || ""} ${user?.lastname || ""}`.trim() ||
    "CARD HOLDER";
  const title = card.site_title || cardBasicInfo?.site_title || "TAKARA PAY";
  const logo =
    card.site_logo || cardBasicInfo?.site_logo || "/Others/card-user.webp";
  const backText =
    card.card_back_details || cardBasicInfo?.card_back_details || "";

  return (
    <div
      className="relative h-72 cursor-pointer select-none"
      style={{ perspective: "1400px" }}
      onClick={() => setFlipped((f) => !f)}
    >
      <div
        className="relative w-full h-full transition-transform duration-700"
        style={{
          transformStyle: "preserve-3d",
          transform: flipped ? "rotateY(180deg)" : "rotateY(0deg)",
        }}
      >
        {/* ── FRONT ─────────────────────────────────────────── */}
        <div
          className="absolute inset-0 rounded-3xl shadow-2xl overflow-hidden text-white bg-linear-to-br from-indigo-900 via-indigo-800 to-slate-900"
          style={{
            backfaceVisibility: "hidden",
            WebkitBackfaceVisibility: "hidden",
            pointerEvents: flipped ? "none" : "auto",
          }}
        >
          {/* Decorative blobs */}
          <div className="absolute -right-12 -top-12 w-52 h-52 rounded-full bg-white/5" />
          <div className="absolute -right-24 top-10 w-52 h-52 rounded-full bg-white/5" />
          <div className="absolute inset-0 bg-linear-to-br from-white/10 via-transparent to-transparent pointer-events-none" />

          {/* Card holder pill */}
          <div className="absolute top-5 left-1/2 -translate-x-1/2 z-20">
            <div className="flex items-center gap-1.5 bg-black/30 backdrop-blur-sm px-3 py-1 rounded-full max-w-[180px]">
              <span className="text-[10px] font-medium uppercase tracking-wide text-white/90 truncate">
                {holder}
              </span>
            </div>
          </div>

          <div className="relative h-full p-6 flex flex-col justify-between z-10">
            <div className="flex justify-between items-start">
              <span className="text-lg font-bold tracking-widest">
                {title.toUpperCase()}
              </span>
              <div className="w-11 h-11 rounded-full flex items-center overflow-hidden bg-white/10">
                <Image
                  src={logo}
                  alt="issuer"
                  width={44}
                  height={44}
                  className="object-cover"
                />
              </div>
            </div>

            <div className="flex items-center gap-3 -mt-1">
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

            <div className="text-xl tracking-[0.2em] font-mono font-semibold">
              {formatCardNumber(card.card_number)}
            </div>

            <div className="flex items-center gap-2">
              <span className="text-[10px] text-white/60 uppercase tracking-wider">
                Expires
              </span>
              <span className="text-sm font-medium">
                {card.expiry || "••/••"}
              </span>
            </div>

            <div className="flex justify-between items-end">
              <span className="text-base font-medium uppercase tracking-wide">
                {holder}
              </span>
              <div className="w-14 h-9 relative">
                <Image src="/Others/Visa-Logo.webp" alt="brand" fill className="object-contain" />
              </div>
            </div>
          </div>

          {/* Flip hint */}
          <div className="absolute bottom-3 right-4 flex items-center gap-1 text-[10px] text-white/50 z-20">
            <svg className="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
              />
            </svg>
            Tap to flip
          </div>
        </div>

        {/* ── BACK ──────────────────────────────────────────── */}
        <div
          className="absolute inset-0 rounded-3xl shadow-2xl overflow-hidden text-white bg-linear-to-br from-slate-900 via-indigo-950 to-slate-900"
          style={{
            backfaceVisibility: "hidden",
            WebkitBackfaceVisibility: "hidden",
            transform: "rotateY(180deg)",
            pointerEvents: flipped ? "auto" : "none",
          }}
        >
          {/* Magnetic strip */}
          <div className="absolute top-6 left-0 right-0 h-11 bg-black/80" />

          <div className="relative h-full pt-20 px-6 pb-5 flex flex-col justify-between z-10">
            {/* Signature + CVV strip */}
            <div className="flex items-stretch gap-3">
              <div className="flex-1 h-9 rounded bg-white/85" />
              <div className="h-9 px-4 rounded bg-white text-gray-900 font-mono font-semibold flex items-center">
                {card.cvv || "•••"}
              </div>
            </div>

            {/* Back details */}
            <div className="text-[11px] leading-relaxed text-white/70 line-clamp-4">
              {backText ? (
                <span dangerouslySetInnerHTML={{ __html: backText }} />
              ) : (
                "This card is property of the issuer. Misuse is a criminal offense."
              )}
            </div>

            {/* Details button */}
            <div className="flex justify-between items-center">
              <span className="text-[10px] text-white/40 uppercase tracking-wider">
                {title}
              </span>
              <button
                type="button"
                onClick={(e) => {
                  e.stopPropagation();
                  onDetails(card.card_id || card.id);
                }}
                className="inline-flex items-center gap-1.5 px-4 py-2 rounded-lg bg-white/15 hover:bg-white/25 backdrop-blur-sm text-sm font-medium transition-colors cursor-pointer"
              >
                View Details
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default function Strowallet() {
  const router = useRouter();
  const [cardsData, setCardsData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
    const dashbaord = useDashboard()
  console.log(dashbaord?.user?.kyc_verified);

  useEffect(() => {
    const fetchCards = async () => {
      try {
        const res = await getStrowalletCards();

        if (res?.message?.error) {
          setError(res.message.error[0] || "Failed to load virtual cards");
          return;
        }

        if (res?.data) {
          setCardsData(res.data);
        }
      } catch (err) {
        setError("Something went wrong. Please try again later.");
        toast.error("Something went wrong. Please try again later");
      } finally {
        setLoading(false);
      }
    };

    fetchCards();
  }, []);

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

  const {
    myCards = [],
    card_create_action = false,
    strowallet_customer_status = false,
    card_basic_info = {},
    transactions = [],
    user,
  } = cardsData || {};
  console.log(cardsData);

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
        return "bg-emerald-50 text-emerald-700 border-emerald-200 dark:bg-emerald-500/10 dark:text-emerald-300 dark:border-emerald-500/30";
      case "pending":
        return "bg-amber-50 text-amber-700 border-amber-200 dark:bg-amber-500/10 dark:text-amber-300 dark:border-amber-500/30";
      case "rejected":
        return "bg-red-50 text-red-700 border-red-200 dark:bg-red-500/10 dark:text-red-300 dark:border-red-500/30";
      default:
        return "bg-gray-50 text-gray-700 border-gray-200 dark:bg-gray-700/50 dark:text-gray-300 dark:border-gray-600";
    }
  };

  const handleViewDetails = (cardId) => {
    router.push(
      `/dashboard/Virtual-Card/StrowalletCardDetails?card_id=${cardId}`,
    );
  };

  // KYC gate: verified (1) -> create card, otherwise -> KYC page.
  const handleCreateCard = () => {
    if (Number(dashbaord?.user?.kyc_verified) === 1) {
      router.push("/dashboard/Virtual-Card/IssueStrowalletCard");
    } else {
      router.push("/dashboard/kyc");
    }
  };
  const handleNewCreateCard = () => {
    if (Number(dashbaord?.user?.kyc_verified) === 1) {
      router.push("/dashboard/Virtual-Card/CreateStrowalletCard");
    } else {
      router.push("/dashboard/kyc");
    }
  };

  return (
    <>
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-6 mb-8">
        <div>
          <h1 className="text-3xl font-bold dark:text-white text-gray-900">My Virtual Cards</h1>
        </div>

  <div className="flex flex-wrap items-center gap-3">
    <button
      type="button"
      onClick={handleNewCreateCard}
      className="inline-flex items-center gap-2 px-6 py-3 border-2 border-indigo-600 text-indigo-600 dark:text-indigo-400 dark:border-indigo-500 font-medium rounded-xl hover:bg-indigo-50 dark:hover:bg-indigo-900/20 transition-all duration-200 cursor-pointer"
    >
      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
      </svg>
      {strowallet_customer_status ? "Update Card Holder" :"  Create Card Holder" }
    
    </button>
{strowallet_customer_status && card_create_action && card_create_action < 4 &&  (
    <button
      type="button"
      onClick={handleCreateCard}
      className="inline-flex items-center gap-2 px-6 py-3 btn-primary text-white font-medium rounded-xl shadow-md transition-all duration-200 cursor-pointer"
    >
      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
      </svg>
      Create New Card
    </button>
 )} 
  </div>
      </div>

      {/* Cards grid */}
      {myCards.length === 0 ? (
        <div className="bg-gray-50 border-2 border-solid border-gray-300 rounded-2xl p-12 text-center mt-5">
          <div className="mx-auto w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mb-6">
            <svg className="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={1.5}
                d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"
              />
            </svg>
          </div>
          <h3 className="text-xl font-semibold text-gray-800 mb-3">
            No virtual cards yet
          </h3>
          <p className="text-gray-600 mb-6 max-w-md mx-auto">
            Create your first virtual card to start making secure online
            payments.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {myCards.map((card) => (
            <FlipCard
              key={card.id || card.card_id}
              card={card}
              cardBasicInfo={card_basic_info}
              user={user}
              onDetails={handleViewDetails}
            />
          ))}
        </div>
      )}

      {/* Transaction History */}
      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow border border-gray-200 dark:border-gray-700 overflow-hidden mt-12">
        <div className="px-6 py-5 border-b border-gray-200 dark:border-gray-700">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-gray-100">
            Transaction History
          </h2>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            All activity related to your virtual cards (Strowallet)
          </p>
        </div>

        {transactions.length === 0 ? (
          <div className="py-16 text-center text-gray-500 dark:text-gray-400">
            No transactions found yet.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
              <thead className="bg-gray-50 dark:bg-gray-700/40">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Date
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Transaction
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Transaction Type
                  </th>
                  <th className="px-6 py-4 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Request Amount
                  </th>
                  <th className="px-6 py-4 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Payable
                  </th>
                  <th className="px-6 py-4 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Total Charge
                  </th>
                  <th className="px-6 py-4 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    card Amount
                  </th>
                  <th className="px-6 py-4 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Current Balance
                  </th>
                  <th className="px-6 py-4 text-center text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                    Status
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
                {transactions.map((tx) => (
                  <tr key={tx.id} className="hover:bg-gray-50 dark:hover:bg-gray-700/40 transition-colors">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                      {formatDate(tx.date_time)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-mono text-gray-600 dark:text-gray-400">
                      {tx.trx || "—"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-100 font-medium">
                      {tx.transaction_type
                        ?.replace(/Virtual Card\(/g, "")
                        .replace(/\)/g, "") || "—"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <span
                        className={
                          tx.request_amount?.includes("-")
                            ? "text-red-600 dark:text-red-400"
                            : "text-emerald-600 dark:text-emerald-400"
                        }
                      >
                        {formatAmount(tx.request_amount)}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-gray-900 dark:text-gray-100">
                      {formatAmount(tx.payable)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-amber-700 dark:text-amber-400">
                      {formatAmount(tx.total_charge)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-gray-900 dark:text-gray-100">
                      {formatAmount(tx.card_amount)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-gray-900 dark:text-gray-100">
                      {formatAmount(tx.current_balance)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-center">
                      <span
                        className={`inline-flex px-3 py-1 rounded-full text-xs font-medium border ${getTransactionColor(
                          tx.status,
                        )}`}
                      >
                        {tx.status || "Unknown"}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </>
  );
}

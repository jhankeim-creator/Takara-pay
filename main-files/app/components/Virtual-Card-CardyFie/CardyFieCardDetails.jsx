"use client";

import Image from "next/image";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import {
  CardFreezeUnfreeze,
  CardyFieCardClose,
  getCardyFieCardDetails,
  getCardyFieCardTransactions,
  setCardyFieDefault,
} from "../../utils/api";
import Loader from "../Loader";

import {
  BanknotesIcon,
  ReceiptPercentIcon,
  StarIcon,
  XMarkIcon,
} from "@heroicons/react/24/outline";
import toast from "react-hot-toast";

export default function CardyFieCardDetails() {
  const searchParams = useSearchParams();
  const router = useRouter();

  const cardId = searchParams.get("card_id");

  const [cardDetails, setCardDetails] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [isFreezing, setIsFreezing] = useState(false);
  const [showCloseConfirmModal, setShowCloseConfirmModal] = useState(false);

  // Transactions modal states
  const [showTransactionsModal, setShowTransactionsModal] = useState(false);
  const [transactions, setTransactions] = useState([]);
  const [loadingTransactions, setLoadingTransactions] = useState(false);
  const [transactionsError, setTransactionsError] = useState(null);

  useEffect(() => {
    if (!cardId) {
      setError("No card selected. Please go back and choose a card.");
      setLoading(false);
      return;
    }

    const fetchDetails = async () => {
      try {
        const res = await getCardyFieCardDetails(cardId);

        if (res?.message?.error) {
          toast.error(res.message.error[0] || "Failed to load card details");
        }

        setCardDetails(res);
      } catch (err) {
        setError(err.message || "Failed to load card details");
        toast.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchDetails();
  }, [cardId]);

  const card = cardDetails?.data?.myCard || {};
  const isDefault = !!card.is_default;
  const baseCurrency = cardDetails?.data?.base_curr || "USD";

  const formatCardNumber = (masked) => {
    if (!masked) return "•••• •••• •••• ••••";
    // real_pan is already like "4040 38****** 9959"
    return masked;
  };

  const handleDeposit = () => {
    if (!cardId) return;
    router.push(
      `/dashboard/Virtual-Card-CardyFie/CardyFieDeposit?card_id=${cardId}`,
    );
  };
  const handleWithdraw = () => {
    if (!cardId) return;
    router.push(
      `/dashboard/Virtual-Card-CardyFie/CardyFieWithdraw?card_id=${cardId}`,
    );
  };
  const handleClose = () => {
    if (!cardId) {
      toast.error("No card selected");
      return;
    }

    // Early exit if already closed (defensive)
    if (card.status === "CLOSED") {
      toast("This card is already closed");
      return;
    }

    setShowCloseConfirmModal(true);
  };

  const confirmCloseCard = async () => {
    setShowCloseConfirmModal(false);

    const loadingToast = toast.loading("Closing card...", {
      position: "top-center",
    });

    try {
      const payload = {
        card_id: cardId,
      };

      const response = await CardyFieCardClose(payload);

      // Handle different response shapes
      if (response?.message?.error?.length > 0) {
        toast.error(response.message.error[0] || "Failed to close card", {
          id: loadingToast,
        });
        return;
      }

      if (response?.message?.success?.length > 0) {
        toast.success(
          response.message.success[0] || "Card closed successfully",
          {
            id: loadingToast,
          },
        );

        // Refresh card details
        try {
          const updated = await getCardyFieCardDetails(cardId);
          setCardDetails(updated);
        } catch (refreshErr) {
          toast("Card closed. Details will update shortly.");
        }
      } else {
        // Fallback when response shape is unexpected
        toast.error("Unexpected response from server", { id: loadingToast });
      }
    } catch (err) {
      toast.error(err.message || "Failed to close card", {
        id: loadingToast,
      });
    }
  };

  const handleDefaultAction = () => {
    if (!cardId) {
      toast.error("No card selected", {
        duration: 3000,
        position: "top-center",
      });
      return;
    }
    setShowConfirmModal(true);
  };

  const confirmDefaultAction = async () => {
    setShowConfirmModal(false);

    const actionText = isDefault
      ? "Removing default status..."
      : "Setting as default...";
    const loadingToast = toast.loading(actionText, {
      position: "top-center",
    });

    try {
      const res = await setCardyFieDefault(cardId);

      if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to update default status");
      }

      const successMsg =
        res?.message?.success?.[0] || "Status Updated Successfully";

      toast.success(successMsg, {
        id: loadingToast,
        duration: 4000,
        position: "top-center",
      });

      // Refresh
      try {
        const updated = await getCardyFieCardDetails(cardId);
        setCardDetails(updated);
      } catch (refreshErr) {
        toast("Action completed. Details will refresh shortly.");
      }
    } catch (err) {
      toast.error("Default action failed:", err);
      toast.error(err.message || "Failed to update default status", {
        id: loadingToast,
        duration: 5000,
        position: "top-center",
      });
    }
  };

  const handleToggleFreeze = async () => {
    if (!cardId) {
      toast.error("No card selected");
      return;
    }

    const newStatus = card.status === "ENABLED" ? "FREEZE" : "ENABLED";
    const actionText =
      newStatus === "FREEZE" ? "Freezing card..." : "Unfreezing card...";

    const loadingToast = toast.loading(actionText, {
      position: "top-center",
    });

    setIsFreezing(true);

    try {
      const payload = {
        card_id: cardId,
        status: newStatus,
      };

      const res = await CardFreezeUnfreeze(payload);

      if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to update card status");
      }

      const successMsg = res?.message?.success?.[0] || "Card status updated";

      toast.success(successMsg, {
        id: loadingToast,
        duration: 4000,
        position: "top-center",
      });

      // Refresh card details
      try {
        const updated = await getCardyFieCardDetails(cardId);
        setCardDetails(updated);
      } catch (refreshErr) {
        toast("Card updated! Details will refresh shortly.");
      }
    } catch (err) {
      toast.error("Freeze/Unfreeze failed:", err);
      toast.error(err.message || "Failed to update card status", {
        id: loadingToast,
        duration: 5000,
        position: "top-center",
      });
    } finally {
      setIsFreezing(false);
    }
  };

  const handleTransactions = async () => {
    setShowTransactionsModal(true);
    setLoadingTransactions(true);
    setTransactionsError(null);
    setTransactions([]);

    try {
      const res = await getCardyFieCardTransactions(cardId);

      if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to load transactions");
      }

      setTransactions(res?.data?.card_transactions || []);
    } catch (err) {
      setTransactionsError(err.message || "Failed to load transactions");
      toast.error(err);
    } finally {
      setLoadingTransactions(false);
    }
  };

  const closeTransactionsModal = () => {
    setShowTransactionsModal(false);
  };

  return (
    <>
      <h1 className="text-2xl font-bold text-gray-900 mb-10">
        CardyFie Card Details
      </h1>

      {loading ? (
        <div className="flex justify-center py-32">
          <Loader />
        </div>
      ) : error ? (
        <div className="bg-red-50 border border-red-200 rounded-2xl p-8 text-red-700 text-center shadow-sm">
          {error}
        </div>
      ) : !card.id ? (
        <div className="bg-yellow-50 border border-yellow-200 rounded-2xl p-8 text-center text-yellow-800 shadow-sm">
          No card found. Please select a card from the list.
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 xl:gap-10">
          {/* LEFT COLUMN */}
          <div className="lg:col-span-5 xl:col-span-5 space-y-8">
            {/* Card Visual */}
            <div className="relative bg-linear-to-br from-slate-800 via-slate-700 to-slate-900 text-white rounded-3xl shadow-2xl overflow-hidden h-72 md:h-80 transform transition-all duration-300 hover:scale-[1.02] hover:shadow-3xl mx-auto max-w-md lg:max-w-full">
              <div className="absolute inset-0 opacity-10 pointer-events-none">
                <div
                  className="w-full h-full"
                  style={{
                    backgroundImage:
                      "radial-gradient(circle, white 1.5px, transparent 1.5px)",
                    backgroundSize: "28px 28px",
                  }}
                />
              </div>

              <div className="absolute inset-0 bg-linear-to-br from-white/20 via-transparent to-transparent pointer-events-none" />

              <div className="absolute top-6 left-1/2 -translate-x-1/2 z-20">
                <div className="flex items-center gap-1.5 bg-black/30 backdrop-blur-sm px-2.5 py-1 rounded-full">
                  <div
                    className={`w-2 h-2 rounded-full ${
                      card.status === "ENABLED"
                        ? "bg-emerald-400 shadow-[0_0_8px_rgba(52,211,153,0.6)]"
                        : "bg-red-400 shadow-[0_0_8px_rgba(248,113,113,0.6)]"
                    }`}
                  />
                  <span className="text-[10px] font-medium uppercase tracking-wide text-white/90">
                    {card.status === "ENABLED"
                      ? "Active"
                      : card.status === "CLOSED"
                        ? "Closed"
                        : "Inactive"}
                  </span>
                </div>
              </div>

              <div className="relative h-full p-6 flex flex-col justify-between z-10">
                <div className="flex justify-between items-start">
                  <div className="text-xl font-bold tracking-wide">
                    STRIPCARD
                  </div>
                  <div className="flex justify-between items-start">
                    <div className="w-12 h-12 rounded-full overflow-hidden bg-white/10 backdrop-blur-sm border border-white/20 shadow-sm flex items-center justify-center">
                      <Image
                        src="/Others/card-user.webp"
                        alt="Card Issuer / User"
                        width={48}
                        height={48}
                        className="object-cover w-full h-full"
                      />
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-4">
                  <div className="w-14 h-10 relative">
                    <Image
                      src="/Others/Chip.webp"
                      alt="EMV Chip"
                      fill
                      className="object-contain"
                    />
                  </div>
                  <div className="w-9 h-9 relative">
                    <Image
                      src="/Others/waves.webp"
                      alt="Contactless"
                      fill
                      className="object-contain opacity-90"
                    />
                  </div>
                </div>

                <div className="text-xl tracking-[0.6em] font-mono font-semibold">
                  {formatCardNumber(card.real_pan)}
                </div>

                <div className="flex items-center gap-2">
                  <p className="text-xs text-white/70 uppercase tracking-wider">
                    Expires
                  </p>
                  <p className="text-base font-medium">
                    {card.card_exp_time || "••/••"}
                  </p>
                </div>

                <div className="flex justify-between items-center">
                  <p className="text-base font-medium uppercase">
                    {card.card_name || "USER NAME"}
                  </p>
                  <div className="w-16 h-10 relative">
                    <Image
                      src="/Others/Visa-Logo.webp"
                      alt="Visa"
                      fill
                      className="object-contain"
                    />
                  </div>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="space-y-2.5">
              {/* First Row - 2 Buttons */}
              <div className="grid grid-cols-2 gap-2.5">
                <button
                  onClick={handleDefaultAction}
                  className="cursor-pointer group flex flex-col items-center justify-center gap-1.5 py-3 px-3
             bg-white border-2 border-gray-200 rounded-xl shadow-sm
             hover:shadow-md hover:border-amber-400 hover:bg-amber-50/50
             transition-all duration-200"
                >
                  <StarIcon className="w-5 h-5 text-amber-500 group-hover:text-amber-600 transition-colors" />
                  <span className="font-semibold text-xs text-gray-800 group-hover:text-amber-600 transition-colors">
                    {isDefault ? "Remove Default" : "Make Default"}
                  </span>
                </button>

                <button
                  onClick={handleDeposit}
                  className="cursor-pointer group flex flex-col items-center justify-center gap-1.5 py-3 px-3 bg-white border-2 border-gray-200 rounded-xl shadow-sm hover:shadow-md hover:border-emerald-400 hover:bg-emerald-50/50 transition-all duration-200"
                >
                  <BanknotesIcon className="w-5 h-5 text-emerald-600 group-hover:text-emerald-700 transition-colors" />
                  <span className="font-semibold text-xs text-gray-800 group-hover:text-emerald-700 transition-colors">
                    Deposit
                  </span>
                </button>
              </div>

              {/* Second Row 3 Buttons – Withdraw | Transactions | Close (conditional) */}
              <div
                className="grid gap-2.5"
                style={{
                  gridTemplateColumns:
                    card.status === "CLOSED" ? "1fr 1fr" : "1fr 1fr 1fr",
                }}
              >
                <button
                  onClick={handleWithdraw}
                  className="cursor-pointer group flex flex-col items-center justify-center gap-1.5 py-3 px-2 bg-white border-2 border-gray-200 rounded-xl shadow-sm hover:shadow-md hover:border-indigo-400 hover:bg-indigo-50/50 transition-all duration-200"
                >
                  <BanknotesIcon className="w-5 h-5 text-indigo-600 group-hover:text-indigo-700 transition-colors" />
                  <span className="font-semibold text-xs text-gray-800 group-hover:text-indigo-700 transition-colors">
                    Withdraw
                  </span>
                </button>

                <button
                  onClick={handleTransactions}
                  className="cursor-pointer group flex flex-col items-center justify-center gap-1.5 py-3 px-2 bg-white border-2 border-gray-200 rounded-xl shadow-sm hover:shadow-md hover:border-blue-400 hover:bg-blue-50/50 transition-all duration-200"
                >
                  <ReceiptPercentIcon className="w-5 h-5 text-blue-600 group-hover:text-blue-700 transition-colors" />
                  <span className="font-semibold text-xs text-gray-800 group-hover:text-blue-700 transition-colors">
                    Transactions
                  </span>
                </button>

                {card.status !== "CLOSED" && (
                  <button
                    onClick={handleClose}
                    className="cursor-pointer group flex flex-col items-center justify-center gap-1.5 py-3 px-2 bg-white border-2 border-gray-200 rounded-xl shadow-sm hover:shadow-md hover:border-red-400 hover:bg-red-50/50 transition-all duration-200"
                  >
                    <XMarkIcon className="w-5 h-5 text-red-600 group-hover:text-red-700 transition-colors" />
                    <span className="font-semibold text-xs text-gray-800 group-hover:text-red-700 transition-colors">
                      Close
                    </span>
                  </button>
                )}
              </div>
            </div>

            {/* Billing Address – dynamic from API "address" field */}
            <div className="bg-white rounded-2xl shadow border border-gray-200 overflow-hidden">
              <div className="bg-gray-50 px-6 py-4 border-b">
                <h3 className="text-2xl font-semibold text-gray-900">
                  Address
                </h3>
              </div>
              <div className="p-6 space-y-6 text-gray-700">
                {card.address && card.address.trim() ? (
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <div className="sm:col-span-2">
                      <p className="text-sm font-semibold text-gray-700 mb-1">
                        Billing Address
                      </p>
                      <p className="text-base leading-relaxed">
                        {card.address}
                      </p>
                    </div>
                  </div>
                ) : (
                  <div className="text-center py-10 text-gray-500 italic">
                    No billing address provided
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* RIGHT COLUMN */}
          <div className="lg:col-span-7 xl:col-span-7 space-y-8">
            <div className="bg-white rounded-2xl shadow-lg border border-gray-200 overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full">
                  <tbody className="divide-y divide-gray-100">
                    {/* 1. Card Name */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 w-2/5 bg-gray-50/50">
                        Card Name
                      </td>
                      <td className="py-4 px-6 text-gray-900 font-medium">
                        {card.card_name || "—"}
                      </td>
                    </tr>

                    {/* 2. Card Id */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Card ID
                      </td>
                      <td className="py-4 px-6 font-mono text-sm text-gray-800 bg-gray-50/30 rounded">
                        {card.ulid || "—"}
                      </td>
                    </tr>

                    {/* 3. Card Amount */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Card Amount
                      </td>
                      <td className="py-4 px-6 text-gray-900 font-medium">
                        {card.amount !== undefined
                          ? `${Number(card.amount).toFixed(4)} ${card.currency || baseCurrency}`
                          : "—"}
                      </td>
                    </tr>

                    {/* 4. Card Tier */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Card Tier
                      </td>
                      <td className="py-4 px-6 text-gray-900">
                        <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-indigo-100 text-indigo-800">
                          {card.card_tier
                            ? card.card_tier.charAt(0).toUpperCase() +
                              card.card_tier.slice(1)
                            : "—"}
                        </span>
                      </td>
                    </tr>

                    {/* 5. Card Type */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Card Type
                      </td>
                      <td className="py-4 px-6 text-gray-900">
                        <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-purple-100 text-purple-800 capitalize">
                          {card.card_type || "—"}
                        </span>
                      </td>
                    </tr>

                    {/* 6. Customer Id */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Customer ID
                      </td>
                      <td className="py-4 px-6 font-mono text-sm text-gray-800 bg-gray-50/30 rounded">
                        {card.customer_ulid || card.card_user_id || "—"}
                      </td>
                    </tr>

                    {/* 7. Card Number (using real_pan) */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Card Number
                      </td>
                      <td className="py-4 px-6 font-mono text-base text-gray-900 tracking-wider">
                        {card.real_pan
                          ? formatCardNumber(card.real_pan)
                          : "•••• •••• •••• ••••"}
                      </td>
                    </tr>

                    {/* 8. CVV */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        CVV
                      </td>
                      <td className="py-4 px-6 font-mono text-lg text-gray-900 font-semibold">
                        {card.cvv || "•••"}
                      </td>
                    </tr>

                    {/* 9. Expiration */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Expiration
                      </td>
                      <td className="py-4 px-6 font-mono text-base text-gray-900">
                        {card.card_exp_time || "••/••"}
                      </td>
                    </tr>

                    {/* 10. Card Environment */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Environment
                      </td>
                      <td className="py-4 px-6 text-gray-900">
                        <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800 uppercase">
                          {card.env || "—"}
                        </span>
                      </td>
                    </tr>

                    {/* 11. Status */}
                    <tr className="hover:bg-gray-50/50 transition-colors">
                      <td className="py-4 px-6 font-semibold text-gray-700 bg-gray-50/50">
                        Status
                      </td>
                      <td className="py-4 px-6">
                        {card.status === "CLOSED" ? (
                          <span
                            className="inline-flex items-center px-4 py-1.5 rounded-full text-sm font-semibold uppercase tracking-wide
                       bg-red-100 text-red-800 border border-red-200"
                          >
                            {card.status}
                          </span>
                        ) : (
                          <button
                            onClick={handleToggleFreeze}
                            disabled={isFreezing}
                            className="cursor-pointer group inline-flex items-center justify-center gap-2 py-2.5 px-5
                               bg-white border-2 border-gray-200 rounded-full shadow-sm
                               hover:shadow-md hover:border-amber-400 hover:bg-amber-50/50
                               transition-all duration-200
                               disabled:opacity-50 disabled:cursor-not-allowed"
                          >
                            <StarIcon className="w-4 h-4 text-amber-500 group-hover:text-amber-600 transition-colors" />
                            <span className="font-semibold text-sm text-gray-800 group-hover:text-amber-600 transition-colors whitespace-nowrap">
                              {card?.status === "ENABLED"
                                ? "Freeze"
                                : "Unfreeze"}
                            </span>
                          </button>
                        )}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Confirmation Modal */}
      {showConfirmModal && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden">
            <div className="bg-amber-50 px-6 py-5 border-b border-amber-100">
              <h3 className="text-xl font-semibold text-amber-900 flex items-center gap-3">
                <StarIcon className="w-6 h-6 text-amber-600" />
                {isDefault ? "Remove as Default Card?" : "Set as Default Card?"}
              </h3>
            </div>

            <div className="p-6 text-gray-700">
              {isDefault ? (
                <>
                  <p>
                    Do you want to <strong>remove default status</strong> from
                    this card?
                  </p>
                  <p className="mt-3 text-sm text-gray-500">
                    You can set another card as default later.
                  </p>
                </>
              ) : (
                <>
                  <p>
                    Do you want to make this card your{" "}
                    <strong>default card</strong>?
                  </p>
                  <p className="mt-3 text-sm text-gray-500">
                    This card will be used as the primary card for transactions
                    where possible.
                  </p>
                </>
              )}
            </div>

            <div className="bg-gray-50 px-6 py-4 flex justify-end gap-3 border-t">
              <button
                onClick={() => setShowConfirmModal(false)}
                className="px-5 py-2.5 text-gray-700 font-medium hover:bg-gray-100 rounded-lg transition-colors cursor-pointer"
              >
                Cancel
              </button>
              <button
                onClick={confirmDefaultAction}
                className="px-6 py-2.5 bg-amber-600 text-white font-medium rounded-lg hover:bg-amber-700 transition-colors shadow-sm cursor-pointer"
              >
                {isDefault ? "Remove Default" : "Set as Default"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Transactions Modal */}
      {showTransactionsModal && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-hidden flex flex-col">
            <div className="bg-gray-50 px-6 py-4 border-b flex items-center justify-between">
              <h2 className="text-xl font-semibold text-gray-900">
                CardyFie Card Transactions
              </h2>
              <button
                onClick={closeTransactionsModal}
                className="text-gray-500 hover:text-gray-700 focus:outline-none transition-colors"
              >
                <XMarkIcon className="w-7 h-7 cursor-pointer" />
              </button>
            </div>

            <div className="p-6 overflow-y-auto flex-1">
              {loadingTransactions ? (
                <div className="flex justify-center items-center py-16">
                  <Loader />
                </div>
              ) : transactionsError ? (
                <div className="bg-red-50 border border-red-200 rounded-xl p-6 text-red-700 text-center">
                  {transactionsError}
                </div>
              ) : transactions.length === 0 ? (
                <div className="text-center py-12 text-gray-600">
                  <p className="text-lg font-medium">No transactions found</p>
                  <p className="mt-2">
                    This card has no transaction history yet.
                  </p>
                </div>
              ) : (
                <div className="space-y-5">
                  {transactions.map((tx, index) => (
                    <div
                      key={index}
                      className="border border-gray-200 rounded-xl p-5 hover:shadow-md transition-all bg-white"
                    >
                      {/* Main row: Date / Type / Amount */}
                      <div className="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-4 mb-4">
                        <div>
                          <p className="text-sm text-gray-500">
                            {tx.created_at
                              ? new Date(tx.created_at).toLocaleDateString(
                                  "en-US",
                                  {
                                    month: "short",
                                    day: "numeric",
                                    year: "numeric",
                                  },
                                ) +
                                " • " +
                                new Date(tx.created_at).toLocaleTimeString(
                                  "en-US",
                                  {
                                    hour: "2-digit",
                                    minute: "2-digit",
                                    hour12: true,
                                  },
                                )
                              : "—"}
                          </p>
                          <p className="font-semibold text-gray-900 mt-1 text-base">
                            {tx.trx_type || "Unknown Transaction"}
                          </p>
                        </div>

                        <div className="text-right">
                          <p
                            className={`font-bold text-xl ${
                              tx.amount_type === "CREDIT"
                                ? "text-emerald-600"
                                : tx.amount_type === "DEBIT"
                                  ? "text-red-600"
                                  : "text-gray-900"
                            }`}
                          >
                            {tx.enter_amount != null && tx.enter_amount !== ""
                              ? `${tx.amount_type === "DEBIT" ? "−" : ""}${Number(tx.enter_amount).toFixed(4)} ${tx.card_currency || baseCurrency}`
                              : "—"}
                          </p>
                        </div>
                      </div>

                      {/* Status + Trx ID + Amount Type */}
                      <div className="flex flex-wrap items-center gap-x-6 gap-y-2 text-sm">
                        {tx.status && (
                          <div>
                            <span className="text-gray-500">Status:</span>{" "}
                            <span
                              className={`font-medium ${
                                tx.status === "SUCCESS"
                                  ? "text-emerald-700"
                                  : tx.status === "FAILED" ||
                                      tx.status === "DECLINED" ||
                                      tx.status === "ERROR"
                                    ? "text-red-700"
                                    : "text-gray-700"
                              }`}
                            >
                              {tx.status}
                            </span>
                          </div>
                        )}

                        {tx.trx_id && (
                          <div>
                            <span className="text-gray-500">Trx ID:</span>{" "}
                            <span className="font-mono text-gray-800">
                              {tx.trx_id}
                            </span>
                          </div>
                        )}

                        {tx.amount_type && (
                          <div>
                            <span className="text-gray-500">Amount Type:</span>{" "}
                            <span
                              className={`font-medium ${
                                tx.amount_type === "CREDIT"
                                  ? "text-emerald-700"
                                  : tx.amount_type === "DEBIT"
                                    ? "text-red-700"
                                    : "text-gray-700"
                              }`}
                            >
                              {tx.amount_type}
                            </span>
                          </div>
                        )}
                      </div>

                      {/* Small footer info (only currency if different) */}
                      <div className="mt-3 text-xs text-gray-500 flex flex-wrap gap-x-5 gap-y-1">
                        {tx.card_currency &&
                          tx.card_currency !== baseCurrency && (
                            <div>Card currency: {tx.card_currency}</div>
                          )}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="bg-gray-50 px-6 py-4 border-t flex justify-end">
              <button
                onClick={closeTransactionsModal}
                className="px-6 py-2.5 bg-indigo-600 text-white font-medium rounded-lg hover:bg-indigo-700 transition-colors cursor-pointer"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Cancel Confirm Modal */}
      {showCloseConfirmModal && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden">
            <div className="bg-red-50 px-6 py-5 border-b border-red-100">
              <div className="flex items-center justify-between">
                <h3 className="text-xl font-semibold text-red-900 flex items-center gap-3">
                  Close This Card?
                </h3>

                <button
                  onClick={() => setShowCloseConfirmModal(false)}
                  className="cursor-pointer p-2 rounded-lg transition-colors"
                >
                  <XMarkIcon className="w-6 h-6 text-red-600" />
                </button>
              </div>
            </div>

            <div className="p-6 text-gray-700 space-y-4">
              <p>
                Are you sure you want to <strong>close</strong> this card?
              </p>
              <p className="text-sm text-gray-500">
                This action cannot be undone. The card will no longer be usable
                for transactions, deposits, or withdrawals.
              </p>
            </div>

            <div className="bg-gray-50 px-6 py-4 flex justify-end gap-3 border-t">
              <button
                onClick={() => setShowCloseConfirmModal(false)}
                className="cursor-pointer px-5 py-2.5 text-gray-700 font-medium hover:bg-gray-100 rounded-lg transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={confirmCloseCard}
                className="cursor-pointer px-6 py-2.5 bg-red-600 text-white font-medium rounded-lg hover:bg-red-700 transition-colors shadow-sm"
              >
                Close Card
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

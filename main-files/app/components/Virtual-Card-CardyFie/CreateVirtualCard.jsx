"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { getCardyfieCreateInfo } from "../../utils/api";
import CreateCardCustomer from "./CreateCardCustomer";
// import CreateCardPage from "./CreateCardPage";
import CreateCardPage from "../../components/Virtual-Card-CardyFie/CreateCardPage";
import CreateVirtualCardSkeleton from "./CreateVirtualCardSkeleton";
import toast from "react-hot-toast";

export default function CreateVirtualCard() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [customerStatus, setCustomerStatus] = useState(null);
  const [pendingText, setPendingText] = useState(null);
  const [cardCreateAllowed, setCardCreateAllowed] = useState(false);

  const router = useRouter();

  useEffect(() => {
    getCardyfieCreateInfo()
      .then((res) => {
        const data = res?.data || {};

        const exists = data.customer_exist_status === true;

        if (!exists) {
          setShowCreateForm(true);
        } else {
          // customer already exists → show status & pending message
          const status = data.customer_exist?.status || "UNKNOWN";
          setCustomerStatus(status);
          setPendingText(data.customer_pending_text || "");

          // NEW: check if we can proceed to card creation
          if (status === "APPROVED" && data.card_create_status === true) {
            setCardCreateAllowed(true);
          }
        }
      })
      .catch((err) => {
        // console.error("Error fetching cardyfie create info:", err);
        toast.error("Failed to load customer information");
        setError("Failed to load customer information");
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  // ────────────────────────────────────────────────
  // Loading state
  // ────────────────────────────────────────────────
  if (loading) {
    return <CreateVirtualCardSkeleton />;
  }

  // ────────────────────────────────────────────────
  // Error state
  // ────────────────────────────────────────────────
  if (error) {
    return (
      <div className="text-center py-12 text-red-600 dark:text-red-400">
        <p className="text-xl font-medium">{error}</p>
        <p className="mt-2 text-gray-600 dark:text-gray-400">
          Please try again later
        </p>
      </div>
    );
  }

  // ────────────────────────────────────────────────
  // Priority order:
  // 1. Approved + card_create_status true → show card creation
  // 2. Customer does NOT exist → show creation form
  // 3. Customer exists but not approved → show status + message
  // ────────────────────────────────────────────────

  // 1. Ready to create virtual card
  if (cardCreateAllowed) {
    return <CreateCardPage />; // card creation component
    // or: return <div>Create Card Page goes here</div>;
  }

  // 2. No customer yet → show form to create customer profile
  if (showCreateForm) {
    return <CreateCardCustomer />;
  }

  // 3. Customer exists → show status & instructions
  return (
    <div className="max-w-3xl mx-auto px-4 py-8 sm:px-6 lg:px-8">
      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-lg dark:shadow-gray-900/50 border border-gray-200 dark:border-gray-700 overflow-hidden">
        {/* Header */}
        <div className="px-8 py-6 text-gray-700 dark:text-gray-200">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
            Create CardyFie Virtual Card
          </h2>
          <p className="mt-2 opacity-90">
            Your customer profile has already been created
          </p>
        </div>

        {/* Main content */}
        <div className="p-8">
          {/* Status indicator */}
          <div className="mb-8">
            <div className="inline-flex items-center px-5 py-2.5 rounded-full bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200 font-medium">
              <span className="mr-2">Status of the customer you created:</span>
              <span
                className={`font-semibold ${
                  customerStatus === "APPROVED"
                    ? "text-green-700 dark:text-green-400"
                    : customerStatus === "PENDING"
                      ? "text-yellow-700 dark:text-yellow-400"
                      : customerStatus === "REJECTED"
                        ? "text-red-700 dark:text-red-400"
                        : "text-gray-700 dark:text-gray-300"
                }`}
              >
                {customerStatus || "Processing"}
              </span>
            </div>
          </div>

          {/* Pending / instruction text */}
          <div className="mb-10 bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-xl p-6">
            <p className="text-gray-800 dark:text-gray-200 leading-relaxed whitespace-pre-line">
              {pendingText ||
                "Your customer profile is currently under review."}
            </p>
          </div>

          {/* Action button */}
          <div className="flex justify-center">
            <button
              type="button"
              disabled={customerStatus !== "PENDING"}
              onClick={() =>
                router.push(
                  "/dashboard/Virtual-Card-CardyFie/Update-Card-Customer",
                )
              }
              className={`
                px-10 py-3.5 rounded-xl font-medium text-white shadow-md
                transition-all duration-200 cursor-pointer
                ${
                  customerStatus === "PENDING"
                    ? "btn-primary"
                    : "bg-gray-400 dark:bg-gray-600 cursor-not-allowed opacity-70"
                }
              `}
            >
              Update Customer
            </button>
          </div>

          <p className="text-center text-sm text-gray-500 dark:text-gray-400 mt-8">
            You will be able to create a virtual card once your customer profile
            is approved.
          </p>
        </div>
      </div>
    </div>
  );
}

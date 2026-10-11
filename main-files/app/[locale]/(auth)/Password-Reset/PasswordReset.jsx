"use client";

import { Eye, EyeOff } from "lucide-react";
import { useTranslations } from "next-intl";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import Loader from "../../../components/Loader";
import { resetPassword } from "../../../utils/api";

// ============================================================================
// MAIN COMPONENT
// ============================================================================
export default function PasswordReset() {
  const t = useTranslations("passwordReset");
  const router = useRouter();

  // --------------------------------------------------------------------------
  // State Management
  // --------------------------------------------------------------------------
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showNew, setShowNew] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [loading, setLoading] = useState(false);
  const [isResetting, setIsResetting] = useState(false);
  const [isMounted, setIsMounted] = useState(false);
  const [otp, setOtp] = useState(null);

  // --------------------------------------------------------------------------
  // Initialize Component (Client-side only)
  // --------------------------------------------------------------------------
  useEffect(() => {
    setIsMounted(true);

    // Safe access to sessionStorage
    if (typeof window !== "undefined") {
      const storedOtp = sessionStorage.getItem("reset_otp");
      setOtp(storedOtp);
    }
  }, []);

  // --------------------------------------------------------------------------
  // Protect Route - Redirect if No OTP
  // --------------------------------------------------------------------------
  useEffect(() => {
    // Wait until component is mounted (client-side)
    if (!isMounted) return;

    // If no OTP and we're not in the middle of reset → redirect
    if (!otp && !isResetting) {
      toast.error(t("invalidRequest"));
      router.replace("/forgot-password");
    }
  }, [isMounted, otp, isResetting, router]);

  // --------------------------------------------------------------------------
  // Submit Handler
  // --------------------------------------------------------------------------
  const handleReset = async (e) => {
    e.preventDefault();

    // Validate password match
    if (newPassword !== confirmPassword) {
      toast.error(t("mismatch"));
      return;
    }

    // Validate OTP exists
    if (!otp) {
      toast.error(t("missingOtp"));
      router.replace("/forgot-password");
      return;
    }

    setLoading(true);
    setIsResetting(true);

    try {
      const data = await resetPassword({
        code: otp,
        password: newPassword,
        password_confirmation: confirmPassword,
      });

      // Handle success response
      if (data.message?.success) {
        toast.success(data.message.success[0] || t("success"));
        sessionStorage.removeItem("reset_otp");
        router.push("/login");
      } else {
        // Handle error response
        toast.error(data.message?.error?.[0] || t("failed"));
        setIsResetting(false);
      }
    } catch (error) {
      const errorMsg = error.message || t("unexpected");
      toast.error(errorMsg);
      setIsResetting(false);
    } finally {
      setLoading(false);
    }
  };

  // --------------------------------------------------------------------------
  // Loading State - Before Mount
  // --------------------------------------------------------------------------
  if (!isMounted) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader />
      </div>
    );
  }

  // --------------------------------------------------------------------------
  // Loading State - Checking Session
  // --------------------------------------------------------------------------
  if (!otp && !isResetting) {
    return (
      <div className="min-h-screen flex items-center justify-center flex-col gap-6">
        <Loader />
      </div>
    );
  }

  // --------------------------------------------------------------------------
  // Main Render
  // --------------------------------------------------------------------------
  return (
    <div className="min-h-screen flex items-center justify-center bg-linear-to-br from-emerald-50 via-teal-50 to-green-50 px-4">
      <div className="w-full max-w-md bg-white rounded-2xl shadow-lg p-8">
        {/* Header Section */}
        <h2 className="text-2xl font-semibold text-center mb-6 text-gray-800">
          {t("title")}
        </h2>

        {/* Form Section */}
        <form onSubmit={handleReset} className="space-y-5">
          {/* New Password Field */}
          <div className="relative">
            <label className="block text-sm font-medium mb-1 text-gray-700">
              {t("newPasswordLabel")}
            </label>
            <input
              type={showNew ? "text" : "password"}
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              className="w-full border border-gray-300 rounded-lg px-4 py-3 pr-11 text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              placeholder={t("newPasswordPlaceholder")}
              required
            />
            <button
              type="button"
              onClick={() => setShowNew(!showNew)}
              className="cursor-pointer absolute right-4 top-[42px] text-gray-500 hover:text-gray-700"
            >
              {showNew ? <EyeOff size={20} /> : <Eye size={20} />}
            </button>
          </div>

          {/* Confirm Password Field */}
          <div className="relative">
            <label className="block text-sm font-medium mb-1 text-gray-700">
              {t("confirmPasswordLabel")}
            </label>
            <input
              type={showConfirm ? "text" : "password"}
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className="w-full border border-gray-300 rounded-lg px-4 py-3 pr-11 text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              placeholder={t("confirmPasswordPlaceholder")}
              required
            />
            <button
              type="button"
              onClick={() => setShowConfirm(!showConfirm)}
              className="cursor-pointer absolute right-4 top-[42px] text-gray-500 hover:text-gray-700"
            >
              {showConfirm ? <EyeOff size={20} /> : <Eye size={20} />}
            </button>
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={loading || !otp}
            className="cursor-pointer w-full btn-primary text-white py-3 rounded-xl font-medium hover:from-emerald-700 hover:to-green-700 transition-all disabled:opacity-60 disabled:cursor-not-allowed shadow-sm"
          >
            {loading ? t("resetting") : t("button")}
          </button>
        </form>

        {/* Back to Home Link */}
        <div className="text-center mt-6">
          <Link
            href="/login"
            className="cursor-pointer text-sm text-emerald-600 hover:text-emerald-700"
          >
            {t("backToHome")}
          </Link>
        </div>
      </div>
    </div>
  );
}

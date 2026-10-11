"use client";

import { useTranslations } from "next-intl";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useRef, useState } from "react";
import toast from "react-hot-toast";
import Loader from "../../../components/Loader";
import { resendEmailVerifyCode, verifyEmail } from "../../../utils/api";

const RESEND_DURATION = 60;

export default function EmailVerify() {
  const t = useTranslations("emailVerify");
  const [otp, setOtp] = useState(["", "", "", "", "", ""]);
  const [countdown, setCountdown] = useState(0);
  const [canResend, setCanResend] = useState(false);
  const [verifyLoading, setVerifyLoading] = useState(false);
  const [resendLoading, setResendLoading] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [checkingAuth, setCheckingAuth] = useState(true);
  const [isInitialLoad, setIsInitialLoad] = useState(true);

  const inputRefs = useRef([]);
  const router = useRouter();

  /* ================= AUTH CHECK ================= */
  useEffect(() => {
    const token =
      localStorage.getItem("auth_token") ||
      sessionStorage.getItem("auth_token");
    const user = localStorage.getItem("user") || sessionStorage.getItem("user");

    if (!token || !user) {
      router.push("/login");
      return;
    }

    try {
      const userData = JSON.parse(user);

      if (userData.email_verified === 1) {
        // Keep the dashboard's separate flag in sync so it doesn't bounce
        // back here (which would cause an infinite redirect loop).
        localStorage.setItem("email_verified", "1");
        sessionStorage.setItem("email_verified", "1");
        router.push("/dashboard");
        return;
      }

      setIsAuthenticated(true);
    } catch (error) {
      // console.error("Error parsing user data:", error);
      toast.error(t("unauthorized"));
      router.push("/login");
      return;
    } finally {
      setCheckingAuth(false);
    }
  }, [router]);

  /* ============ INITIALIZE COUNTDOWN ON FIRST VISIT ============ */
  useEffect(() => {
    if (!isAuthenticated) return;

    const endTime = sessionStorage.getItem("otp_resend_end");
    const hasVisited = sessionStorage.getItem("otp_page_visited");

    if (endTime) {
      // There's an active timer, restore it
      const remaining = Math.ceil((Number(endTime) - Date.now()) / 1000);
      if (remaining > 0) {
        setCountdown(remaining);
        setCanResend(false);
      } else {
        // Timer expired, allow resend
        setCountdown(0);
        setCanResend(true);
        sessionStorage.removeItem("otp_resend_end");
      }
    } else if (!hasVisited) {
      // First visit to the page, start initial countdown
      const initialEndTime = Date.now() + RESEND_DURATION * 1000;
      sessionStorage.setItem("otp_resend_end", initialEndTime.toString());
      sessionStorage.setItem("otp_page_visited", "true");
      setCountdown(RESEND_DURATION);
      setCanResend(false);
    } else {
      // Subsequent visits without active timer - don't start countdown
      setCountdown(0);
      setCanResend(true);
    }

    setIsInitialLoad(false);
  }, [isAuthenticated]);

  /* ================= COUNTDOWN TIMER ================= */
  useEffect(() => {
    if (countdown > 0) {
      const timer = setTimeout(() => setCountdown((c) => c - 1), 1000);
      return () => clearTimeout(timer);
    }

    if (countdown === 0 && !canResend && !isInitialLoad) {
      setCanResend(true);
      sessionStorage.removeItem("otp_resend_end");
    }
  }, [countdown, canResend, isInitialLoad]);

  /* ================= START COUNTDOWN ================= */
  const startCountdown = () => {
    const endTime = Date.now() + RESEND_DURATION * 1000;
    sessionStorage.setItem("otp_resend_end", endTime.toString());
    setCountdown(RESEND_DURATION);
    setCanResend(false);
  };

  /* ================= INPUT HANDLERS ================= */
  const handleChange = (index, value) => {
    if (isNaN(value)) return;

    const newOtp = [...otp];
    newOtp[index] = value.substring(value.length - 1);
    setOtp(newOtp);

    if (value && index < 5) {
      inputRefs.current[index + 1].focus();
    }
  };

  const handleKeyDown = (index, e) => {
    if (e.key === "Backspace" && !otp[index] && index > 0) {
      inputRefs.current[index - 1].focus();
    }
  };

  const handlePaste = (e) => {
    e.preventDefault();
    const data = e.clipboardData.getData("text").slice(0, 6);
    if (!/^\d+$/.test(data)) return;

    const newOtp = [...otp];
    data.split("").forEach((d, i) => (newOtp[i] = d));
    setOtp(newOtp);
    const focusIndex = Math.min(data.length, 5);
    inputRefs.current[focusIndex].focus();
  };

  /* ================= RESEND CLICK ================= */
  const handleResend = async () => {
    if (!canResend || resendLoading) return;

    setResendLoading(true);
    try {
      const response = await resendEmailVerifyCode();
      if (response?.message?.success) {
        toast.success(response.message.success[0]);
        setOtp(["", "", "", "", "", ""]);
        inputRefs.current[0].focus();
        startCountdown();
      } else if (response?.message?.error) {
        toast.error(response.message.error[0]);
      }
    } catch {
      toast.error(t("resendFailed"));
    } finally {
      setResendLoading(false);
    }
  };

  /* ================= VERIFY ================= */
  const handleVerify = async () => {
    const code = otp.join("");
    if (code.length !== 6) {
      toast.error(t("invalidOtp"));
      return;
    }

    setVerifyLoading(true);
    try {
      const response = await verifyEmail(code);
      if (response?.message?.success) {
        toast.success(response.message.success[0]);
        sessionStorage.removeItem("otp_resend_end");
        sessionStorage.removeItem("otp_page_visited");

        const storage = localStorage.getItem("user")
          ? localStorage
          : sessionStorage;
        const userStr = storage.getItem("user");

        if (userStr) {
          const userData = JSON.parse(userStr);
          userData.email_verified = 1;
          storage.setItem("user", JSON.stringify(userData));
        }

        // DashboardLayout reads the separate "email_verified" flag — keep it in
        // sync, otherwise it bounces back here and creates a redirect loop.
        storage.setItem("email_verified", "1");

        router.push("/dashboard");
      } else if (response?.message?.error) {
        toast.error(response.message.error[0]);
      }
    } catch {
      toast.error(t("verifyFailed"));
    } finally {
      setVerifyLoading(false);
    }
  };

  /* ================= LOADERS ================= */
  if (checkingAuth) {
    return (
      <div className="flex h-screen items-center justify-center bg-gray-50">
        <Loader />
      </div>
    );
  }

  if (!isAuthenticated) return null;

  /* ================= UI ================= */
  return (
    <div className="min-h-screen bg-linear-to-br from-primary-50 via-teal-50 to-primary-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-10 border border-gray-100">
        <div className="text-center mb-8">
          <Image
            src="/logo/logo-dark.webp"
            alt={t("logoAlt")}
            width={128}
            height={32}
            className="mx-auto mb-2"
            priority
          />
          <div className="h-1 w-20 bg-linear-to-r from-primary-400 to-primary-400 mx-auto rounded-full"></div>
        </div>

        <h2 className="text-2xl font-bold text-center text-gray-800 mb-2">
          {t("title")}
        </h2>

        <p className="text-center text-gray-500 text-sm mb-8">
          {t("subtitle")}
        </p>

        <div className="flex justify-center gap-3 mb-6">
          {otp.map((value, index) => (
            <input
              key={index}
              ref={(el) => (inputRefs.current[index] = el)}
              type="text"
              maxLength={1}
              value={value}
              onChange={(e) => handleChange(index, e.target.value)}
              onKeyDown={(e) => handleKeyDown(index, e)}
              onPaste={handlePaste}
              className="w-12 h-12 text-center text-2xl font-semibold text-gray-900 border-2 border-gray-300 rounded-xl focus:border-primary-500 focus:ring-2 focus:ring-primary-500 transition-all"
              disabled={verifyLoading}
            />
          ))}
        </div>

        <button
          onClick={handleVerify}
          disabled={otp.join("").length !== 6 || verifyLoading}
          className="w-full bg-linear-to-r from-primary-500 to-primary-500 text-white font-semibold py-3.5 rounded-xl disabled:opacity-50 disabled:cursor-not-allowed hover:from-primary-600 hover:to-primary-600 transition-all duration-200 shadow-lg hover:shadow-xl"
        >
          {verifyLoading ? (
            <span className="flex items-center justify-center gap-2">
              <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                <circle
                  className="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  strokeWidth="4"
                  fill="none"
                />
                <path
                  className="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                />
              </svg>
              {t("verifying")}
            </span>
          ) : (
            t("button")
          )}
        </button>

        <div className="mt-6 text-center text-sm text-gray-600">
          {canResend ? (
            <>
              {t("noCode")}{" "}
              <button
                onClick={handleResend}
                disabled={resendLoading}
                className="text-primary-600 font-semibold hover:underline disabled:opacity-50 disabled:cursor-not-allowed inline-flex items-center gap-1"
              >
                {resendLoading ? (
                  <>
                    <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24">
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                        fill="none"
                      />
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                      />
                    </svg>
                    {t("sending")}
                  </>
                ) : (
                  t("resendButton")
                )}
              </button>
            </>
          ) : (
            <span className="font-semibold text-gray-500">
              {t("resendCountdown", { seconds: countdown })}
            </span>
          )}
        </div>

        <div className="mt-8 text-center text-sm text-gray-600">
          {t("alreadyVerified")}{" "}
          <Link
            href="/login"
            className="text-primary-600 font-semibold hover:underline"
          >
            {t("loginNow")}
          </Link>
        </div>
      </div>
    </div>
  );
}

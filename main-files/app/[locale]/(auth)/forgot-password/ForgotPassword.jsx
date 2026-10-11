"use client";

import { CheckCircle2, Mail, Shield } from "lucide-react";
import { useTranslations } from "next-intl";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import ReCAPTCHA from "react-google-recaptcha";
import toast from "react-hot-toast";
import { useAppSettings } from "../../../providers/AppSettingsProvider";
import { forgotPassword, verifyOtp } from "../../../utils/api";

export default function ForgotPasswordPage() {
  const t = useTranslations("ForgotPassword");

  // Centralized app settings for reCAPTCHA
  const { appSettings } = useAppSettings();
  const recaptcha = appSettings?.google_recaptcha_credentials;
  const recaptchaEnabled = recaptcha?.status === true;
  const recaptchaSiteKey = recaptcha?.site_key ?? "";

  const router = useRouter();

  // --------------------------------------------------------------------------
  // State Management
  // --------------------------------------------------------------------------
  const [stage, setStage] = useState("email");
  const [loading, setLoading] = useState(false);

  // Email Stage
  const [email, setEmail] = useState("");
  const [captchaValue, setCaptchaValue] = useState(null);
  const [captchaError, setCaptchaError] = useState(false);

  // OTP Stage
  const [otp, setOtp] = useState(["", "", "", "", "", ""]);
  const [countdown, setCountdown] = useState(0);
  const [canResend, setCanResend] = useState(true);

  // --------------------------------------------------------------------------
  // Email Submit Handler
  // --------------------------------------------------------------------------
  const handleEmailSubmit = async (e) => {
    e.preventDefault();

    // only validate captcha if it's enabled in settings
    if (recaptchaEnabled && !captchaValue) {
      setCaptchaError(true);
      toast.error(t("emailStage.recaptchaError"));
      return;
    }

    setLoading(true);
    try {
      const data = await forgotPassword(email);
      if (data.message.success) {
        toast.success(data.message.success[0]);
        setStage("otp");
        setCountdown(60);
        setCanResend(false);
      } else {
        toast.error(data.message.error[0]);
      }
    } catch (error) {
      toast.error(error.message || t("emailStage.genericError"));
    } finally {
      setLoading(false);
    }
  };

  // --------------------------------------------------------------------------
  // OTP Handlers
  // --------------------------------------------------------------------------
  const handleOtpChange = (index, value) => {
    if (!/^\d*$/.test(value)) return;
    const newOtp = [...otp];
    newOtp[index] = value.slice(-1);
    setOtp(newOtp);
    if (value && index < 5) {
      document.getElementById(`otp-${index + 1}`).focus();
    }
  };

  const handleOtpKeyDown = (index, e) => {
    if (e.key === "Backspace" && !otp[index] && index > 0) {
      document.getElementById(`otp-${index - 1}`).focus();
    }
  };

  const handleOtpSubmit = async (e) => {
    e.preventDefault();
    const enteredOtp = otp.join("");
    if (enteredOtp.length !== 6) {
      toast.error(t("otpStage.invalidOtp"));
      return;
    }
    setLoading(true);
    try {
      const data = await verifyOtp(enteredOtp);
      if (data.message.success) {
        toast.success(data.message.success[0]);
        sessionStorage.setItem("reset_otp", enteredOtp);
        router.push("/Password-Reset");
      } else {
        toast.error(data.message.error[0]);
      }
    } catch (error) {
      toast.error(error.message || t("otpStage.verificationError"));
    } finally {
      setLoading(false);
    }
  };

  const handleResend = async () => {
    if (!canResend) return;
    setLoading(true);
    try {
      const data = await forgotPassword(email);
      if (data.message.success) {
        toast.success(data.message.success[0]);
        setCountdown(60);
        setCanResend(false);
      } else {
        toast.error(data.message.error[0]);
      }
    } catch (error) {
      toast.error(error.message || t("otpStage.resendError"));
    } finally {
      setLoading(false);
    }
  };

  // Countdown Effect
  useEffect(() => {
    if (countdown > 0) {
      const timer = setTimeout(() => setCountdown(countdown - 1), 1000);
      return () => clearTimeout(timer);
    } else if (countdown === 0 && stage === "otp") {
      setCanResend(true);
    }
  }, [countdown, stage]);

  // CAPTCHA Handlers
  const onCaptchaChange = (value) => {
    setCaptchaValue(value);
    setCaptchaError(false);
  };

  const onCaptchaExpired = () => {
    setCaptchaValue(null);
    setCaptchaError(true);
  };

  // --------------------------------------------------------------------------
  // RENDER
  // --------------------------------------------------------------------------
  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-gray-50 dark:bg-gray-950 transition-colors">
      <div className="bg-white dark:bg-gray-900 rounded-3xl shadow-2xl w-full max-w-lg p-8 md:p-10 border border-gray-200 dark:border-gray-700 transition-colors">
        {/* Logo */}
        <div className="text-center mb-8">
          <Image
            src="/logo/logo-dark.webp"
            alt={t("logoAlt")}
            width={128}
            height={32}
            className="mx-auto mb-2"
            priority
          />
          <div className="h-1 w-20 bg-gradient-to-r from-primary-500 to-primary-500 mx-auto rounded-full"></div>
        </div>

        {/* EMAIL STAGE */}
        {stage === "email" && (
          <>
            <h2 className="text-2xl font-bold text-center text-gray-900 dark:text-gray-100 mb-2">
              {t("emailStage.title")}
            </h2>
            <p className="text-center text-gray-600 dark:text-gray-400 text-sm mb-8">
              {t("emailStage.description")}
            </p>

            <form onSubmit={handleEmailSubmit} className="space-y-6">
              {/* Email Field */}
              <div>
                <label
                  htmlFor="email"
                  className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5"
                >
                  {t("emailStage.emailLabel")}{" "}
                  <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <Mail className="h-5 w-5 text-gray-400 dark:text-gray-500" />
                  </div>
                  <input
                    type="email"
                    id="email"
                    placeholder={t("emailStage.emailPlaceholder")}
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    className="w-full pl-12 pr-4 py-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-gray-100 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-transparent transition-all placeholder-gray-400 dark:placeholder-gray-500"
                  />
                </div>
              </div>

              {/* show reCAPTCHA only if enabled */}
              {recaptchaEnabled && recaptchaSiteKey && (
                <div className="space-y-3">
                  <div className="flex items-center gap-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    <Shield className="h-4 w-4 text-primary-600 dark:text-primary-500" />
                    <span>{t("emailStage.securityVerification")}</span>
                  </div>

                  <div className="flex justify-center">
                    <ReCAPTCHA
                      sitekey={recaptchaSiteKey}
                      onChange={onCaptchaChange}
                      onExpired={onCaptchaExpired}
                      theme="light"
                    />
                  </div>

                  {captchaValue && (
                    <div className="flex items-center justify-center gap-2 text-primary-600 dark:text-primary-400 text-sm font-semibold">
                      <CheckCircle2 className="h-4 w-4" />
                      <span>{t("emailStage.verificationSuccess")}</span>
                    </div>
                  )}

                  {captchaError && !captchaValue && (
                    <div className="flex items-center justify-center gap-2 text-red-600 dark:text-red-400 text-sm font-semibold">
                      <svg
                        className="h-4 w-4"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                        />
                      </svg>
                      <span>{t("emailStage.verificationRequired")}</span>
                    </div>
                  )}

                  <p className="text-xs text-gray-500 dark:text-gray-400 text-center">
                    {t("emailStage.securityHelpText")}
                  </p>
                </div>
              )}

              {/* Submit */}
              <button
                type="submit"
                disabled={loading}
                className="w-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-semibold py-3.5 rounded-xl shadow-md hover:shadow-lg transition-all duration-200 disabled:opacity-60 disabled:cursor-not-allowed dark:from-blue-500 dark:to-indigo-500 dark:hover:from-blue-600 dark:hover:to-indigo-600"
              >
                {loading ? t("emailStage.loading") : t("emailStage.button")}
              </button>
            </form>
          </>
        )}

        {/* OTP STAGE */}
        {stage === "otp" && (
          <>
            <h2 className="text-2xl font-bold text-center text-gray-900 dark:text-gray-100 mb-2">
              {t("otpStage.title")}
            </h2>
            <p className="text-center text-gray-600 dark:text-gray-400 text-sm mb-8">
              {t("otpStage.description")}{" "}
              <span className="font-semibold text-gray-800 dark:text-gray-200">
                {email}
              </span>
            </p>

            <form onSubmit={handleOtpSubmit} className="space-y-8">
              {/* OTP Inputs */}
              <div className="flex justify-center gap-3 sm:gap-4">
                {otp.map((digit, index) => (
                  <input
                    key={index}
                    id={`otp-${index}`}
                    type="text"
                    maxLength={1}
                    value={digit}
                    onChange={(e) => handleOtpChange(index, e.target.value)}
                    onKeyDown={(e) => handleOtpKeyDown(index, e)}
                    className="w-11 h-11 sm:w-12 sm:h-12 text-center text-2xl font-semibold bg-white dark:bg-gray-800 border-2 border-gray-300 dark:border-gray-600 text-gray-900 dark:text-gray-100 rounded-xl focus:border-primary-500 focus:ring-2 focus:ring-primary-500 dark:focus:border-primary-400 dark:focus:ring-primary-400 transition-all"
                    required
                  />
                ))}
              </div>

              {/* Resend */}
              <div className="text-center">
                {countdown > 0 ? (
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    {t("otpStage.resendCountdown.part1")}{" "}
                    <span className="font-bold text-primary-600 dark:text-primary-400">
                      {countdown}s
                    </span>
                  </p>
                ) : (
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    {t("otpStage.resendPrompt")}{" "}
                    <button
                      type="button"
                      onClick={handleResend}
                      disabled={!canResend || loading}
                      className="text-primary-600 dark:text-primary-400 font-semibold hover:text-primary-700 dark:hover:text-primary-300 hover:underline transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {loading
                        ? t("otpStage.resending")
                        : t("otpStage.resendButton")}
                    </button>
                  </p>
                )}
              </div>

              {/* Verify Button */}
              <button
                type="submit"
                disabled={loading}
                className="w-full bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white font-semibold py-3.5 rounded-xl shadow-md hover:shadow-lg hover:scale-[1.01] transition-all duration-200 disabled:opacity-60 disabled:cursor-not-allowed dark:from-primary-600 dark:to-primary-700 dark:hover:from-primary-700 dark:hover:to-primary-800"
              >
                {loading ? t("otpStage.verifying") : t("otpStage.button")}
              </button>
            </form>
          </>
        )}

        {/* Bottom Links */}
        <div className="mt-8 text-center text-sm text-gray-600 dark:text-gray-400 space-y-2">
          <p>
            {stage === "email" ? t("footer.emailStage") : t("footer.otpStage")}{" "}
            <Link
              href="/login"
              className="text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 font-semibold hover:underline transition-colors"
            >
              {t("footer.loginLink")}
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}

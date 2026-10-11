"use client";

import { CheckCircle2, Eye, EyeOff, Lock, Mail, Shield } from "lucide-react";
import { useTranslations } from "next-intl";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import ReCAPTCHA from "react-google-recaptcha";
import toast from "react-hot-toast";
import { useAppSettings } from "../../../providers/AppSettingsProvider";
import { loginUser } from "../../../utils/api";

export default function LoginPage() {
  const t = useTranslations("Login");
  const { appSettings } = useAppSettings();
  const recaptcha = appSettings?.google_recaptcha_credentials;
  const recaptchaEnabled = recaptcha?.status === true;
  const recaptchaSiteKey = recaptcha?.site_key ?? "";

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const [captchaValue, setCaptchaValue] = useState(null);
  const [captchaError, setCaptchaError] = useState(false);
  const [loading, setLoading] = useState(false);

  const router = useRouter();

  const getMessageString = (message) => {
    if (!message) return "";
    if (typeof message === "string") return message;
    if (Array.isArray(message)) return message.join(" • ");
    if (message.success && Array.isArray(message.success)) {
      return message.success.join(" • ");
    }
    if (message.error && Array.isArray(message.error)) {
      return message.error.join(" • ");
    }
    return "Response received";
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Only recaptcha will check if it is enabled
    if (recaptchaEnabled && !captchaValue) {
      setCaptchaError(true);
      toast.error(t("form.recaptchaError"));
      return;
    }

    setCaptchaError(false);
    setLoading(true);

    try {
      const response = await loginUser({
        email: email.trim(),
        password,
      });

      // Show server success message if available
      // Handle server error response
      if (response?.message?.error) {
        toast.error(getMessageString(response.message));
        setLoading(false);
        return;
      }

      // Handle success response
      if (response?.message?.success) {
        toast.success(getMessageString(response.message));
      }

      const token = response?.data?.token;
      const user = response?.data?.user;

      if (!token || !user) {
        toast.error(t("form.invalidResponse"));
        setLoading(false);
        return;
      }

      // Clear previous auth data
      localStorage.removeItem("auth_token");
      localStorage.removeItem("user");
      sessionStorage.removeItem("auth_token");
      sessionStorage.removeItem("user");

      // Always store auth data in localStorage.
      // "remember_me" flag controls frontend auto-logout:
      //   true  -> never auto-logout (stay until backend token expires)
      //   false -> auto-logout after 15 min of inactivity (see useIdleLogout)
      localStorage.setItem("auth_token", token);
      localStorage.setItem("user", JSON.stringify(user));
      localStorage.setItem("email_verified", user?.email_verified);
      localStorage.setItem("two_factor_verified", user?.two_factor_verified);
      localStorage.setItem("remember_me", rememberMe ? "true" : "false");

      // ====== 2FA Priority Check ======
      if (user.two_factor_status === 1 && user.two_factor_verified === 0) {
        // 2FA is enabled but not yet verified in this session
        setTimeout(() => {
          router.push("/GoogleTwoFactorAuth");
        }, 600);
        return; // Stop further redirection
      }

      // ====== Normal flow (no pending 2FA) ======
      if (user.email_verified === 1) {
        setTimeout(() => {
          router.push("/dashboard");
        }, 600);
      } else {
        setTimeout(() => {
          router.push("/email-verify");
        }, 600);
      }
    } catch (error) {
      let errorMessage = t("form.genericError");
      if (error.response?.data?.message) {
        errorMessage = getMessageString(error.response.data.message);
      } else if (error.response?.data?.error) {
        errorMessage = getMessageString(error.response.data.error);
      } else if (error.message) {
        errorMessage = error.message;
      }
      toast.error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const onCaptchaChange = (value) => {
    setCaptchaValue(value);
    setCaptchaError(false);
  };

  const onCaptchaExpired = () => {
    setCaptchaValue(null);
    setCaptchaError(true);
  };

  return (
    <div className="min-h-screen dark:from-gray-750 dark:via-gray-850 dark:to-indigo-950/30 flex items-center justify-center p-4 relative overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 right-20 w-72 h-72 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-20 left-20 w-96 h-96 bg-indigo-400/10 dark:bg-indigo-500/5 rounded-full blur-3xl animate-pulse" />
      </div>

      <div className="relative bg-white/80 dark:bg-gray-900/80 backdrop-blur-md rounded-2xl shadow-2xl w-full max-w-lg p-8 md:p-10 border border-blue-100/50 dark:border-blue-800/50">
        {/* Logo and Header */}
        <div className="text-center mb-8">
          <Image
            src="/logo/logo-dark.webp"
            alt={t("logoAlt")}
            width={150}
            height={32}
            className="mx-auto mb-4"
            priority
          />
          <div className="h-1 w-20 bg-gradient-to-r from-blue-600 to-indigo-600 mx-auto rounded-full"></div>
        </div>

        <h2 className="text-2xl md:text-3xl font-bold text-center text-slate-900 dark:text-slate-100 mb-2">
          {t("title")}
        </h2>
        <p className="text-center text-slate-600 dark:text-slate-300 text-sm mb-8">
          {t("subtitle")}
        </p>

        <form onSubmit={handleSubmit} className="space-y-5">
          {/* Email Field */}
          <div>
            <label
              htmlFor="email"
              className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
            >
              {t("form.labels.email")} <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <Mail className="h-5 w-5 text-slate-400 dark:text-slate-500" />
              </div>
              <input
                type="email"
                id="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder={t("form.placeholders.email")}
                required
                className="w-full pl-12 pr-4 py-3 border-2 text-slate-900 dark:text-slate-100 border-slate-200 dark:border-gray-700 rounded-lg focus:outline-none focus:ring-none focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 transition-all hover:border-slate-300 dark:hover:border-gray-600 bg-white dark:bg-gray-800 placeholder-slate-400 dark:placeholder-slate-500"
              />
            </div>
          </div>

          {/* Password Field */}
          <div>
            <label
              htmlFor="password"
              className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
            >
              {t("form.labels.password")}{" "}
              <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <Lock className="h-5 w-5 text-slate-400 dark:text-slate-500" />
              </div>
              <input
                type={showPassword ? "text" : "password"}
                id="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder={t("form.placeholders.password")}
                required
                className="w-full pl-12 pr-12 text-slate-900 dark:text-slate-100 py-3 border-2 border-slate-200 dark:border-gray-700 rounded-lg focus:outline-none focus:ring-none focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 transition-all hover:border-slate-300 dark:hover:border-gray-600 bg-white dark:bg-gray-800 placeholder-slate-400 dark:placeholder-slate-500"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="cursor-pointer absolute inset-y-0 right-0 pr-4 flex items-center text-slate-500 dark:text-slate-300 hover:text-slate-700 dark:hover:text-slate-300 transition-colors"
              >
                {showPassword ? (
                  <EyeOff className="h-5 w-5" />
                ) : (
                  <Eye className="h-5 w-5" />
                )}
              </button>
            </div>
          </div>

          {/* Remember Me & Forgot Password */}
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <input
                type="checkbox"
                id="rememberMe"
                checked={rememberMe}
                onChange={(e) => setRememberMe(e.target.checked)}
                className="h-4 w-4 text-blue-600 dark:text-blue-400 focus:ring-blue-500 dark:focus:ring-blue-400 border-slate-300 dark:border-gray-700 rounded cursor-pointer"
              />
              <label
                htmlFor="rememberMe"
                className="ml-2 block text-sm text-slate-700 dark:text-slate-300 cursor-pointer"
              >
                {t("form.rememberMe")}
              </label>
            </div>
            <Link
              href="/forgot-password"
              className="text-sm text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 hover:underline transition-colors font-medium"
            >
              {t("form.forgotPassword")}
            </Link>
          </div>

          {/* reCAPTCHA — will only show if status: true */}
          {recaptchaEnabled && recaptchaSiteKey && (
            <div className="space-y-3">
              <div className="flex items-center gap-2 text-sm font-semibold text-slate-700 dark:text-slate-300">
                <Shield className="h-4 w-4 text-blue-600 dark:text-blue-400" />
                <span>{t("form.securityVerification")}</span>
              </div>

              <div className="flex justify-start">
                <ReCAPTCHA
                  sitekey={recaptchaSiteKey}
                  onChange={onCaptchaChange}
                  onExpired={onCaptchaExpired}
                  theme="light"
                  size="normal"
                />
              </div>

              {captchaValue && (
                <div className="flex items-center justify-center gap-2 text-green-600 dark:text-green-400 text-sm font-semibold">
                  <CheckCircle2 className="h-4 w-4" />
                  <span>{t("form.verificationSuccess")}</span>
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
                  <span>{t("form.verificationRequired")}</span>
                </div>
              )}

              <p className="text-xs text-slate-500 dark:text-slate-300 text-center">
                {t("form.securityHelpText")}
              </p>
            </div>
          )}

          {/* Submit Button */}
          <button
            type="submit"
            disabled={loading}
            className={`w-full flex items-center justify-center bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-500 dark:to-indigo-500 text-white font-semibold py-3.5 rounded-lg shadow-lg hover:shadow-xl hover:from-blue-700 hover:to-indigo-700 dark:hover:from-blue-600 dark:hover:to-indigo-600 transition-all duration-200 ${
              loading
                ? "opacity-50 cursor-not-allowed"
                : "cursor-pointer hover:scale-[1.02]"
            }`}
          >
            {loading ? (
              <span className="h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
            ) : (
              t("form.button")
            )}
          </button>
        </form>

        {/* Footer Links */}
        <div className="mt-8 text-center text-sm text-slate-600 dark:text-slate-300 space-y-3">
          <p>
            {t("footer.noAccount")}{" "}
            <Link
              href="/register"
              className="text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 font-semibold hover:underline transition-colors"
            >
              {t("footer.signUp")}
            </Link>
          </p>
          <p>
            {t("footer.goBack")}{" "}
            <Link
              href="/"
              className="text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 font-semibold hover:underline transition-colors"
            >
              {t("footer.home")}
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}

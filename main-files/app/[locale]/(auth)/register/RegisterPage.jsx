"use client";

import {
  CheckCircle2,
  Eye,
  EyeOff,
  Lock,
  Mail,
  Shield,
  User,
} from "lucide-react";
import { useTranslations } from "next-intl";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import ReCAPTCHA from "react-google-recaptcha";
import toast from "react-hot-toast";
import { useAppSettings } from "../../../providers/AppSettingsProvider";
import { registerUser } from "../../../utils/api";

export default function RegisterPage() {
  const t = useTranslations("Register");

  // Central settings from recaptcha config
  const { appSettings } = useAppSettings();
  const recaptcha = appSettings?.google_recaptcha_credentials;
  const recaptchaEnabled = recaptcha?.status === true;
  const recaptchaSiteKey = recaptcha?.site_key ?? "";

  const [firstname, setFirstname] = useState("");
  const [lastname, setLastname] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [captchaValue, setCaptchaValue] = useState(null);
  const [captchaError, setCaptchaError] = useState(false);
  const [termsChecked, setTermsChecked] = useState(false);
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

    if (!termsChecked) {
      toast.error(t("form.termsError"));
      return;
    }

    // check reCAPTCHA only if it's enabled in settings
    if (recaptchaEnabled && !captchaValue) {
      setCaptchaError(true);
      toast.error(t("form.recaptchaError"));
      return;
    }

    setCaptchaError(false);
    setLoading(true);

    try {
      const userData = {
        firstname: firstname.trim(),
        lastname: lastname.trim(),
        email: email.trim(),
        password,
        agree: termsChecked ? 1 : 0,
      };

      const response = await registerUser(userData);

      // Show backend error message dynamically
      if (response?.message?.error) {
        toast.error(getMessageString(response.message));
        return;
      }

      // Show backend success message dynamically
      if (response?.message?.success) {
        toast.success(getMessageString(response.message));
      }

      const token = response?.data?.token;
      const user = response?.data?.user;

      if (!token) {
        toast.error(t("form.tokenMissing"));
        return;
      }

      sessionStorage.setItem("auth_token", token);
      if (user) {
        sessionStorage.setItem("user", JSON.stringify(user));
      }
      sessionStorage.setItem("email_verified", user?.email_verified);
      // toast.success(t("form.successMessage"));

      if (user?.email_verified === 1) {
        router.push("/dashboard");
      } else {
        router.push("/email-verify");
      }
    } catch (error) {
      let errorMessage = t("form.genericError");

      if (error.response?.data) {
        const backendData = error.response.data;
        if (
          backendData.message?.error &&
          Array.isArray(backendData.message.error)
        ) {
          errorMessage = backendData.message.error.join(" • ");
        } else if (backendData.message) {
          errorMessage =
            typeof backendData.message === "string"
              ? backendData.message
              : Object.values(backendData.message).flat().join(" • ");
        }
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
    <div className="min-h-screen dark:from-gray-950 dark:via-gray-900 dark:to-indigo-950/30 flex items-center justify-center p-4 relative overflow-hidden">
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

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-5">
          {/* First Name & Last Name - Side by side */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {/* First Name */}
            <div>
              <label
                htmlFor="firstName"
                className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
              >
                {t("form.labels.firstName")}{" "}
                <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <User className="h-5 w-5 text-slate-400 dark:text-slate-500" />
                </div>
                <input
                  type="text"
                  id="firstName"
                  value={firstname}
                  onChange={(e) => setFirstname(e.target.value)}
                  placeholder={t("form.placeholders.firstName")}
                  required
                  className="w-full pl-12 pr-4 py-3 border-2 text-slate-900 dark:text-slate-100 border-slate-200 dark:border-gray-700 rounded-lg focus:outline-none focus:ring-none focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 transition-all hover:border-slate-300 dark:hover:border-gray-600 bg-white dark:bg-gray-800 placeholder-slate-400 dark:placeholder-slate-500"
                />
              </div>
            </div>

            {/* Last Name */}
            <div>
              <label
                htmlFor="lastName"
                className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
              >
                {t("form.labels.lastName")}{" "}
                <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <User className="h-5 w-5 text-slate-400 dark:text-slate-500" />
                </div>
                <input
                  type="text"
                  id="lastName"
                  value={lastname}
                  onChange={(e) => setLastname(e.target.value)}
                  placeholder={t("form.placeholders.lastName")}
                  required
                  className="w-full pl-12 pr-4 py-3 border-2 text-slate-900 dark:text-slate-100 border-slate-200 dark:border-gray-700 rounded-lg focus:outline-none focus:ring-none focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 transition-all hover:border-slate-300 dark:hover:border-gray-600 bg-white dark:bg-gray-800 placeholder-slate-400 dark:placeholder-slate-500"
                />
              </div>
            </div>
          </div>

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
                className="w-full pl-12 pr-12 py-3 border-2 text-slate-900 dark:text-slate-100 border-slate-200 dark:border-gray-700 rounded-lg focus:outline-none focus:ring-none focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 transition-all hover:border-slate-300 dark:hover:border-gray-600 bg-white dark:bg-gray-800 placeholder-slate-400 dark:placeholder-slate-500"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-500 dark:text-slate-300 hover:text-slate-700 dark:hover:text-slate-300 transition-colors"
              >
                {showPassword ? (
                  <EyeOff className="h-5 w-5" />
                ) : (
                  <Eye className="h-5 w-5" />
                )}
              </button>
            </div>
          </div>

          {/* Terms Agreement Checkbox */}
          <div className="flex items-start gap-3">
            <input
              type="checkbox"
              id="terms"
              checked={termsChecked}
              onChange={(e) => setTermsChecked(e.target.checked)}
              className="mt-0.5 h-5 w-5 text-blue-600 dark:text-blue-400 rounded focus:ring-blue-500 dark:focus:ring-blue-400 cursor-pointer"
              required
            />
            <label
              htmlFor="terms"
              className="text-sm text-slate-700 dark:text-slate-300 cursor-pointer"
            >
              {t("form.termsAgreement.part1")}{" "}
              <Link
                href="/privacy-policy"
                className="text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 font-medium hover:underline"
              >
                {/* {t("form.termsAgreement.termsLink")} */}
              </Link>{" "}
              {/* {t("form.termsAgreement.and")} */}
              <Link
                href="/privacy-policy"
                className="text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 font-medium hover:underline"
              >
                {t("form.termsAgreement.privacyLink")}
              </Link>
            </label>
          </div>

          {/* show reCAPTCHA on enable */}
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

          {/* Sign Up Button */}
          <button
            type="submit"
            disabled={loading || !termsChecked}
            className="cursor-pointer w-full bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-500 dark:to-indigo-500 text-white font-semibold py-3.5 rounded-lg shadow-lg hover:shadow-xl hover:from-blue-700 hover:to-indigo-700 dark:hover:from-blue-600 dark:hover:to-indigo-600 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 hover:scale-[1.02]"
          >
            {loading ? t("form.loading") : t("form.button")}
          </button>
        </form>

        {/* Bottom Links */}
        <div className="mt-8 text-center text-sm text-slate-600 dark:text-slate-300 space-y-3">
          <p>
            {t("footer.alreadyHaveAccount")}{" "}
            <Link
              href="/login"
              className="text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 font-semibold hover:underline transition-colors"
            >
              {t("footer.login")}
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

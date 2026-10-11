/* eslint-disable @next/next/no-img-element */
"use client";

import { ArrowUpRight, Mail, Send, Sparkles } from "lucide-react";
import { useTranslations } from "next-intl";
import Link from "next/link";
import { useRef, useState } from "react";
import dynamic from "next/dynamic";
import toast from "react-hot-toast";

const ReCAPTCHA = dynamic(() => import("react-google-recaptcha"), { ssr: false });
import { useAppSettings } from "../../../providers/AppSettingsProvider";
import { subscribeNewsletter } from "../../../utils/api";

const SOCIAL_LINKS = [
  {
    label: "Facebook",
    href: "https://facebook.com",
    hoverBg: "hover:bg-[#1877F2]",
    hoverBorder: "hover:border-[#1877F2]",
    icon: (
      <svg viewBox="0 0 24 24" className="w-4 h-4" fill="currentColor">
        <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
      </svg>
    ),
  },
  {
    label: "Instagram",
    href: "https://instagram.com",
    hoverBg:
      "hover:bg-gradient-to-br hover:from-[#F58529] hover:via-[#DD2A7B] hover:to-[#8134AF]",
    hoverBorder: "hover:border-[#DD2A7B]",
    icon: (
      <svg viewBox="0 0 24 24" className="w-4 h-4" fill="currentColor">
        <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
      </svg>
    ),
  },
  {
    label: "X",
    href: "https://x.com",
    hoverBg: "hover:bg-black dark:hover:bg-white",
    hoverBorder: "hover:border-black dark:hover:border-white",
    icon: (
      <svg viewBox="0 0 24 24" className="w-4 h-4" fill="currentColor">
        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-4.714-6.231-5.401 6.231H2.748l7.73-8.835L1.254 2.25H8.08l4.253 5.622zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
      </svg>
    ),
  },
];

function Footer() {
  const t = useTranslations("Footer");

  // Recaptcha config from Central settings
  const { appSettings } = useAppSettings();
  const recaptcha = appSettings?.google_recaptcha_credentials;
  const recaptchaEnabled = recaptcha?.status === true;
  const recaptchaSiteKey = recaptcha?.site_key ?? "";

  const currentYear = new Date().getFullYear();

  const [email, setEmail] = useState("");
  const [captchaToken, setCaptchaToken] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isFocused, setIsFocused] = useState(false);
  const [loadRecaptcha, setLoadRecaptcha] = useState(false);
  const recaptchaRef = useRef(null);

  const onCaptchaChange = (token) => setCaptchaToken(token);
  const onCaptchaExpired = () => setCaptchaToken(null);

  const handleSubscribe = async (e) => {
    e.preventDefault();

    //  Will only check if enabled
    if (recaptchaEnabled && !captchaToken) {
      toast.error(t("subscribe.recaptchaError"));
      return;
    }
    setIsSubmitting(true);
    const response = await subscribeNewsletter(email);
    setIsSubmitting(false);

    // Handle error response
    if (response?.message?.error) {
      const errors = response.message.error;
      const errorText = Array.isArray(errors[0]) ? errors[0][0] : errors[0];
      toast.error(errorText || t("subscribe.errorMessage"));
      setCaptchaToken(null);
      if (recaptchaRef.current) recaptchaRef.current.reset();
      return;
    }

    // Success
    setEmail("");
    setCaptchaToken(null);
    if (recaptchaRef.current) recaptchaRef.current.reset();
    toast.success(
      response?.message?.success?.[0] ?? t("subscribe.successMessage"),
    );
  };

  return (
    <footer className="relative w-full overflow-hidden bg-gradient-to-br from-slate-50 via-blue-50/60 to-indigo-50 dark:from-[#0a0a14] dark:via-[#0d0d1f] dark:to-[#0f0a1e]">
      {/* Decorative mesh */}
      <div className="pointer-events-none absolute inset-0 overflow-hidden">
        <div className="absolute -top-24 left-1/2 h-64 w-[700px] -translate-x-1/2 rounded-full bg-blue-400/10 blur-3xl dark:bg-blue-600/8" />
        <div className="absolute -bottom-16 -right-16 h-72 w-72 rounded-full bg-indigo-400/15 blur-3xl dark:bg-indigo-700/10" />
        <div className="absolute -bottom-16 -left-16 h-56 w-56 rounded-full bg-blue-300/10 blur-3xl dark:bg-purple-700/10" />
        <svg
          className="absolute inset-0 h-full w-full opacity-[0.025] dark:opacity-0"
          xmlns="http://www.w3.org/2000/svg"
        >
          <defs>
            <pattern
              id="dots"
              x="0"
              y="0"
              width="24"
              height="24"
              patternUnits="userSpaceOnUse"
            >
              <circle cx="2" cy="2" r="1.5" fill="#6366f1" />
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#dots)" />
        </svg>
      </div>

      {/* Top shimmer line */}
      <div className="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-blue-500/60 to-transparent dark:via-indigo-400/40" />

      <div className="relative z-10 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 gap-12 py-16 lg:grid-cols-12 lg:gap-10 lg:py-20">
          {/* ── COL 1 : Brand ── */}
          <div className="lg:col-span-4 flex flex-col items-start gap-7">
            {/* Logo — anchored left, no stretching */}
            <img
              src="/logo/logo-dark.webp"
              alt={t("logoAlt")}
              loading="eager"
              className="h-9 w-auto max-w-[180px] object-contain object-left"
              
            />

            {/* Description */}
            <p className="text-sm leading-relaxed text-slate-500 dark:text-slate-400 max-w-[260px]">
              {t("thankYou")}
            </p>

            {/* Social block — all left-aligned */}
            <div className="flex flex-col items-start gap-3">
              <span className="text-[10px] font-bold uppercase tracking-[0.18em] text-slate-400 dark:text-slate-500">
                {t("followUs.title")}
              </span>
              <div className="flex items-center gap-2">
                {SOCIAL_LINKS.map(
                  ({ label, href, hoverBg, hoverBorder, icon }) => (
                    <a
                      key={label}
                      href={href}
                      target="_blank"
                      rel="noopener noreferrer"
                      aria-label={label}
                      className={`
                      group flex h-9 w-9 items-center justify-center overflow-hidden
                      rounded-xl border border-slate-200 bg-white/80 text-slate-500
                      shadow-sm backdrop-blur-sm transition-all duration-300
                      hover:scale-110 hover:text-white hover:shadow-md
                      dark:border-white/10 dark:bg-white/5 dark:text-slate-400
                      ${hoverBg} ${hoverBorder}
                    `}
                    >
                      {icon}
                    </a>
                  ),
                )}
              </div>
            </div>
          </div>

          {/* ── COL 2 : Links ── */}
          <div className="lg:col-span-2 flex flex-col items-start gap-5">
            <span className="text-[10px] font-bold uppercase tracking-[0.18em] text-slate-400 dark:text-slate-500">
              {t("usefulLinks.title")}
            </span>
            <nav className="flex flex-col gap-3">
              <Link
                href="/privacy-policy"
                className="group flex items-center gap-1.5 text-sm text-slate-600 transition-colors duration-200 hover:text-blue-600 dark:text-slate-400 dark:hover:text-blue-400"
              >
                {t("usefulLinks.privacyPolicy")}
                <ArrowUpRight className="h-3 w-3 opacity-0 -translate-y-0.5 transition-all duration-200 group-hover:opacity-100 group-hover:translate-y-0" />
              </Link>
            </nav>
          </div>

          {/* ── COL 3 : Newsletter ── */}
          <div className="lg:col-span-6">
            <div className="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white/60 p-6 shadow-sm backdrop-blur-md dark:border-white/[0.07] dark:bg-white/[0.03]">
              <div className="absolute inset-x-8 top-0 h-px bg-gradient-to-r from-transparent via-blue-400/60 to-transparent" />

              {/* Corner dots */}
              <div className="absolute right-5 top-5 flex gap-1">
                <span className="block h-1.5 w-1.5 rounded-full bg-blue-400/40 dark:bg-blue-500/30" />
                <span className="block h-1.5 w-1.5 rounded-full bg-indigo-400/40 dark:bg-indigo-500/30" />
                <span className="block h-1.5 w-1.5 rounded-full bg-purple-400/40 dark:bg-purple-500/30" />
              </div>

              {/* Header */}
              <div className="mb-4 flex items-start gap-3">
                <div className="mt-0.5 flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 shadow-lg shadow-blue-500/25">
                  <Sparkles className="h-4 w-4 text-white" />
                </div>
                <div>
                  <h3 className="text-base font-bold text-slate-900 dark:text-slate-100">
                    {t("subscribe.title")}
                  </h3>
                  <p className="mt-0.5 text-sm leading-relaxed text-slate-500 dark:text-slate-400">
                    {t("subscribe.description")}
                  </p>
                </div>
              </div>

              {/* Form */}
              <form 
                onSubmit={handleSubscribe} 
                className="flex flex-col gap-3"
                onMouseEnter={() => setLoadRecaptcha(true)}
                onTouchStart={() => setLoadRecaptcha(true)}
                onFocus={() => setLoadRecaptcha(true)}
              >
                <div
                  className={`
                    flex items-center overflow-hidden rounded-xl border transition-all duration-200
                    bg-white dark:bg-white/5
                    ${
                      isFocused
                        ? "border-blue-500 ring-4 ring-blue-500/10 dark:ring-blue-500/15"
                        : "border-slate-200 dark:border-white/10"
                    }
                  `}
                >
                  <Mail className="ml-3.5 h-4 w-4 flex-shrink-0 text-slate-400 dark:text-slate-500" />
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    onFocus={() => setIsFocused(true)}
                    onBlur={() => setIsFocused(false)}
                    placeholder={t("subscribe.placeholder")}
                    required
                    className="min-w-0 flex-1 bg-transparent px-3 py-3 text-sm text-slate-900 placeholder-slate-400 focus:outline-none dark:text-slate-100 dark:placeholder-slate-500"
                  />
                  <button
                    type="submit"
                    disabled={isSubmitting}
                    className="m-1 flex flex-shrink-0 items-center gap-1.5 rounded-lg bg-gradient-to-r from-blue-600 to-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow transition-all duration-200 hover:from-blue-700 hover:to-indigo-700 hover:shadow-md disabled:cursor-not-allowed disabled:opacity-60"
                  >
                    {isSubmitting ? (
                      <>
                        <svg
                          className="h-3.5 w-3.5 animate-spin"
                          viewBox="0 0 24 24"
                          fill="none"
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
                        {t("subscribe.sending")}
                      </>
                    ) : (
                      <>
                        <Send className="h-3.5 w-3.5" />
                        {t("subscribe.button")}
                      </>
                    )}
                  </button>
                </div>

                {/* reCAPTCHA — below input */}
                {recaptchaEnabled && recaptchaSiteKey && loadRecaptcha && (
                  <ReCAPTCHA
                    ref={recaptchaRef}
                    sitekey={recaptchaSiteKey}
                    onChange={onCaptchaChange}
                    onExpired={onCaptchaExpired}
                    theme="light"
                    size="normal"
                  />
                )}
              </form>
            </div>
          </div>
        </div>

        {/* Divider */}
        <div className="h-px bg-gradient-to-r from-transparent via-slate-200 to-transparent dark:via-white/10" />

        {/* Bottom bar */}
        <div className="flex flex-col items-center justify-between gap-3 py-6 text-xs text-slate-400 dark:text-slate-500 sm:flex-row">
          <span>
            © {currentYear}{" "}
            <span className="font-semibold text-blue-600 dark:text-blue-400">
              {t("copyright.company")}
            </span>
            . {t("copyright.allRights")}
          </span>
          <div className="flex items-center gap-5">
            <Link
              href="/privacy-policy"
              className="transition-colors duration-200 hover:text-blue-600 dark:hover:text-blue-400"
            >
              {t("usefulLinks.privacyPolicy")}
            </Link>
            <span className="h-3 w-px bg-slate-200 dark:bg-white/10" />
          </div>
        </div>
      </div>
    </footer>
  );
}

export default Footer;

"use client";

import {
  AlertTriangle,
  Check,
  CheckCircle2,
  Copy,
  Loader2,
  XCircle,
} from "lucide-react";
import { useEffect, useRef, useState } from "react";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";
import { getGoogle2FASetup, google2FAUpdateStatus } from "../../utils/api";
import TwoFactorSkeleton from "./TwoFactorSkeleton";



const TwoFactorAuthenticator = () => {
  // Translations scoped to the "twoFactorAuth" namespace
  const t = useTranslations("twoFactorAuth");

  // ── State
  const [secret,           setSecret]           = useState("");
  const [qrCodeSvg,        setQrCodeSvg]        = useState("");    // raw <svg> markup from the API
  const [status,           setStatus]           = useState(0);     // 0 = disabled, 1 = enabled
  const [alertMessage,     setAlertMessage]     = useState("");
  const [loading,          setLoading]          = useState(true);
  const [error,            setError]            = useState(null);
  const [copied,           setCopied]           = useState(false);
  const [isProcessing,     setIsProcessing]     = useState(false);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [actionType,       setActionType]       = useState("");    // "enable" | "disable"
  const [otp,              setOtp]              = useState(["", "", "", "", "", ""]);

  // Refs for the 6 one-digit boxes so we can move focus while typing
  const inputRefs = useRef([]);

  // ── Fetch 2FA setup data on mount 
  useEffect(() => {
    const fetch2FASetup = async () => {
      try {
        setLoading(true);
        const response = await getGoogle2FASetup();

        if (response?.data) {
          setSecret(response.data.qr_secrete || "");
          setQrCodeSvg(response.data.qr_code  || "");
          setStatus(response.data.qr_status  ?? 0);
          setAlertMessage(response.data.alert || "");
        } else if (response?.message?.error) {
          setError(response.message.error[0] || t("errors.loadFailed"));
        }
      } catch {
        setError(t("errors.loadGeneric"));
      } finally {
        setLoading(false);
      }
    };

    fetch2FASetup();
  }, []);

  // ── Handlers 

  // Copies the secret key to the clipboard and shows check icon
  const handleCopy = () => {
    if (!secret) return;
    navigator.clipboard.writeText(secret);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  // Opens the code modal for the requested action ("enable" | "disable")
  const openConfirmModal = (type) => {
    setActionType(type);
    setOtp(["", "", "", "", "", ""]);
    setShowConfirmModal(true);
  };

  const closeConfirmModal = () => {
    setShowConfirmModal(false);
    setOtp(["", "", "", "", "", ""]);
  };

  // ── Authenticator code input (6 single-digit boxes)

  const handleOtpChange = (index, value) => {
    if (value.length > 1) value = value[value.length - 1];
    if (!/^\d*$/.test(value)) return;

    const next = [...otp];
    next[index] = value;
    setOtp(next);

    // Auto-focus the next box once a digit is entered
    if (value && index < 5) inputRefs.current[index + 1]?.focus();
  };

  const handleOtpKeyDown = (index, e) => {
    if (e.key === "Backspace" && !otp[index] && index > 0) {
      inputRefs.current[index - 1]?.focus();
    }
  };

  const handleOtpPaste = (e) => {
    e.preventDefault();
    const pasted = e.clipboardData.getData("text").trim().slice(0, 6).split("");
    const next = [...otp];

    pasted.forEach((char, i) => {
      if (/^\d$/.test(char) && i < 6) next[i] = char;
    });

    setOtp(next);
    inputRefs.current[Math.min(pasted.length - 1, 5)]?.focus();
  };

  // Calls the API with the code typed by the user
  const handleConfirmAction = async () => {
    const code = otp.join("");

    if (code.length !== 6) {
      toast.error(t("modal.invalidCode"));
      return;
    }

    setShowConfirmModal(false);
    setIsProcessing(true);

    try {
      const response = await google2FAUpdateStatus(code);

      if (response?.message?.success) {
        const msg =
          response.message.success[0] ||
          (actionType === "enable" ? t("success.enabled") : t("success.disabled"));

        toast.success(msg);
        setStatus(actionType === "enable" ? 1 : 0); // reflect the new state locally
      } else if (response?.message?.error) {
        const errMsg = response.message.error[0] || t("errors.operationFailed");
        toast.error(errMsg);
      }
    } catch {
      toast.error(t("errors.generic"));
    } finally {
      setIsProcessing(false);
    }
  };

  // ── Derived values 

  const isEnabled = status === 1;

  // Button label and click action are derived from the current enable/processing state
  const buttonText = isProcessing
    ? t("button.processing")
    : isEnabled
      ? t("button.disable")
      : t("button.enable");

  const buttonAction = isEnabled
    ? () => openConfirmModal("disable")
    : () => openConfirmModal("enable");

  // ── Early return 

  if (loading) return <TwoFactorSkeleton />;

  // ── Render 
  return (
    <>
      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-lg dark:shadow-gray-900/40 p-8 w-full flex flex-col border border-gray-200 dark:border-gray-700 transition-colors duration-200">

        {/* ── Title*/}
        <h2 className="text-lg text-gray-700 dark:text-gray-200 text-center mb-6 font-medium">
          {t("title")}
        </h2>

        {/* ── Status badge: green "Enabled" pill or amber "Not Enabled" pill ── */}
        <div className="flex justify-center mb-6">
          {isEnabled ? (
            <div className="inline-flex items-center gap-1.5 px-3.5 py-1.5 bg-primary-100/80 dark:bg-primary-900/40 text-primary-700 dark:text-primary-300 text-sm font-medium rounded-full border border-primary-200 dark:border-primary-800">
              <CheckCircle2 size={16} className="text-primary-600 dark:text-primary-400" />
              <span>{t("badge.enabled")}</span>
            </div>
          ) : (
            <div className="inline-flex items-center gap-1.5 px-3.5 py-1.5 bg-amber-100/80 dark:bg-amber-900/30 text-amber-700 dark:text-amber-300 text-sm font-medium rounded-full border border-amber-200 dark:border-amber-800">
              <XCircle size={16} className="text-amber-600 dark:text-amber-400" />
              <span>{t("badge.notEnabled")}</span>
            </div>
          )}
        </div>

        {/* ── Secret key row with clipboard copy button  */}
        <div className="mb-8">
          <div className="flex items-center gap-2 bg-gray-50 dark:bg-gray-900/60 border border-gray-200 dark:border-gray-700 rounded-lg p-3">
            <input
              type="text"
              value={secret}
              readOnly
              className="flex-1 bg-transparent text-gray-800 dark:text-gray-200 font-mono text-sm outline-none"
              placeholder={t("secretPlaceholder")}
            />
            {/* Icon toggles between Copy and Check for 2 s after copying */}
            <button
              onClick={handleCopy}
              className="cursor-pointer p-2 hover:bg-gray-200 dark:hover:bg-gray-800 rounded-md transition-colors"
              aria-label={t("copyAriaLabel")}
              disabled={!secret}
            >
              {copied
                ? <Check className="w-5 h-5 text-primary-600 dark:text-primary-400" />
                : <Copy  className="w-5 h-5 text-gray-600 dark:text-gray-400"  />}
            </button>
          </div>
        </div>

        {/* ── QR code: raw SVG markup returned by the API (or fallback text) */}
        <div className="flex justify-center mb-8">
          <div className="w-48 h-48 bg-white rounded-lg flex items-center justify-center border-2 border-gray-200 dark:border-gray-700 overflow-hidden">
            {qrCodeSvg ? (
              <div
                role="img"
                aria-label={t("qrAlt")}
                className="w-[92%] h-[92%] [&>svg]:w-full [&>svg]:h-full"
                dangerouslySetInnerHTML={{ __html: qrCodeSvg }}
              />
            ) : (
              <span className="text-gray-400 dark:text-gray-500 text-xs">
                {t("qrNotAvailable")}
              </span>
            )}
          </div>
        </div>

        {/* ── Alert banner (only rendered when 2FA is enabled and a message exists) */}
        {isEnabled && alertMessage && (
          <p className="text-sm text-amber-700 dark:text-amber-300 bg-amber-50 dark:bg-amber-900/30 p-3 rounded-lg mb-6 text-center border border-amber-100 dark:border-amber-800">
            {alertMessage}
          </p>
        )}

        {/* ── Enable / Disable toggle button  */}
        <div className="mt-auto">
          <button
            onClick={buttonAction}
            disabled={isProcessing}
            className={`cursor-pointer w-full py-3 rounded-lg text-white font-semibold text-base transition-all flex items-center justify-center gap-2 hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed
              ${isEnabled
                ? "bg-red-600 hover:bg-red-700 dark:bg-red-700 dark:hover:bg-red-600"
                : "btn-primary"
              }`}
          >
            {isProcessing
              ? <Loader2 className="w-5 h-5 animate-spin" />
              : buttonText}
          </button>
        </div>
      </div>

      {/* ── Code modal: asks for the authenticator code before enable/disable */}
      {showConfirmModal && (
        <div className="fixed inset-0 bg-black/60 dark:bg-black/70 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl dark:shadow-gray-950/60 max-w-md w-full p-6 animate-in fade-in zoom-in duration-200 border border-gray-200 dark:border-gray-700">

            {/* Modal header: warning icon + context-aware title */}
            <div className="flex items-center gap-3 mb-4">
              <div className="w-12 h-12 bg-amber-100 dark:bg-amber-900/40 rounded-full flex items-center justify-center shrink-0">
                <AlertTriangle className="w-6 h-6 text-amber-600 dark:text-amber-400" />
              </div>
              <h3 className="text-xl font-semibold text-gray-800 dark:text-gray-100">
                {actionType === "enable" ? t("modal.titleEnable") : t("modal.titleDisable")}
              </h3>
            </div>

            {/* Modal body: confirmation copy */}
            <p className="text-gray-600 dark:text-gray-300 mb-5 leading-relaxed">
              {actionType === "enable" ? t("modal.confirmEnable") : t("modal.confirmDisable")}
            </p>

            {/* Authenticator code: 6 single-digit boxes posted as `code` */}
            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
                {t("modal.codeLabel")}
              </label>
              <div className="flex justify-center gap-2">
                {otp.map((digit, index) => (
                  <input
                    key={index}
                    ref={(el) => (inputRefs.current[index] = el)}
                    type="text"
                    inputMode="numeric"
                    autoComplete="one-time-code"
                    maxLength={1}
                    value={digit}
                    autoFocus={index === 0}
                    onChange={(e) => handleOtpChange(index, e.target.value)}
                    onKeyDown={(e) => handleOtpKeyDown(index, e)}
                    onPaste={handleOtpPaste}
                    className="w-11 h-13 sm:w-12 sm:h-14 text-center text-xl font-semibold text-gray-900 dark:text-gray-100 bg-white dark:bg-gray-900/60 border-2 border-gray-300 dark:border-gray-600 rounded-lg focus:border-primary-500 dark:focus:border-primary-400 focus:outline-none transition-colors"
                  />
                ))}
              </div>
            </div>

            {/* Modal */}
            <div className="flex gap-3">
              <button
                onClick={closeConfirmModal}
                className="cursor-pointer flex-1 py-2.5 px-4 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 rounded-lg font-medium hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
              >
                {t("modal.cancel")}
              </button>
              <button
                onClick={handleConfirmAction}
                disabled={otp.join("").length !== 6}
                className={`cursor-pointer flex-1 py-2.5 px-4 text-white rounded-lg font-medium hover:opacity-90 transition-all disabled:opacity-50 disabled:cursor-not-allowed
                  ${actionType === "enable"
                    ? "btn-primary"
                    : "bg-red-600 hover:bg-red-700 dark:bg-red-700 dark:hover:bg-red-600"
                  }`}
              >
                {actionType === "enable"
                  ? t("modal.confirmButtonEnable")
                  : t("modal.confirmButtonDisable")}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default TwoFactorAuthenticator;
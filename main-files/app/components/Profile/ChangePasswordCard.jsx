"use client";

import { Loader2 } from "lucide-react";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";
import { updateUserPassword } from "../../utils/api";
import { getToastMessage } from "../../utils/toastHelper";
import ChangePasswordSkeleton from "./ChangePasswordSkeleton";

// ---------------------------------------------------------------------------
// EyeIcon — shown when the password field is currently visible (click to hide)
// ---------------------------------------------------------------------------
const EyeOffIcon = () => (
  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth={2}
      d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029
         m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29
         m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5
         c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"
    />
  </svg>
);

// ---------------------------------------------------------------------------
// EyeIcon — shown when the password field is currently hidden (click to reveal)
// ---------------------------------------------------------------------------
const EyeIcon = () => (
  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth={2}
      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
    />
    <path
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth={2}
      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7
         -1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
    />
  </svg>
);

// ---------------------------------------------------------------------------
// Shared Tailwind class strings — defined once to keep JSX concise
// ---------------------------------------------------------------------------
const INPUT_CLASS =
  "w-full px-4 py-3 pr-12 border border-gray-300 dark:border-gray-600 rounded-lg " +
  "placeholder:text-gray-500 dark:placeholder:text-gray-400 " +
  "text-gray-900 dark:text-gray-100 dark:bg-gray-800 " +
  "focus:border-primary-500 focus:ring-1 focus:ring-primary-100 " +
  "dark:focus:border-primary-400 dark:focus:ring-primary-500/30 " +
  "outline-none transition-all";

const LABEL_CLASS =
  "block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2";

// ---------------------------------------------------------------------------
// ChangePasswordCard
// ---------------------------------------------------------------------------
function ChangePasswordCard() {
  // Translations scoped to the "changePassword" namespace
  const t = useTranslations("changePassword");

  // ── Form field values ────────────────────────────────────────────────────
  const [passwordData, setPasswordData] = useState({
    currentPassword: "",
    newPassword: "",
    confirmPassword: "",
  });

  // ── Skeleton loader ─────────────────────────────
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    const timer = setTimeout(() => setLoading(false), 2000);
    return () => clearTimeout(timer); // cleanup on unmount
  }, []);

  // ── Per-field password visibility toggles ────────────────────────────────
  const [showPasswords, setShowPasswords] = useState({
    current: false,
    new: false,
    confirm: false,
  });

  
  const [isSubmitting, setIsSubmitting] = useState(false);

  // ── Handlers ─────────────────────────────────────────────────────────────

  const handlePasswordChange = (e) => {
    setPasswordData({ ...passwordData, [e.target.name]: e.target.value });
  };

  /** Toggle the show/hide state for a specific password field. */
  const togglePasswordVisibility = (field) => {
    setShowPasswords((prev) => ({ ...prev, [field]: !prev[field] }));
  };

  /** Submit the form **/
  const handlePasswordChangeSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);

    const response = await updateUserPassword({
      current_password: passwordData.currentPassword,
      password: passwordData.newPassword,
      password_confirmation: passwordData.confirmPassword,
    });

    
    const { type, text } = getToastMessage(response);
    toast[type](text);

    
    if (type === "success") {
      setPasswordData({ currentPassword: "", newPassword: "", confirmPassword: "" });
      setShowPasswords({ current: false, new: false, confirm: false });
    }

    setIsSubmitting(false);
  };

  // ── Render ────────────────────────────────────────────────────────────────

  // Show skeleton placeholder while the initial loading delay is active
  if (loading) return <ChangePasswordSkeleton />;

  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl shadow-md dark:shadow-gray-950/50 p-6 mx-auto">
      {/* Card heading */}
      <h2 className="text-2xl font-bold text-gray-800 dark:text-gray-100 mb-8 text-center">
        {t("title")}
      </h2>

      <form onSubmit={handlePasswordChangeSubmit} className="space-y-6">

        {/* ── Current Password ─────────────────────────────────────────── */}
        <PasswordField
          label={t("fields.currentPassword")}
          name="currentPassword"
          value={passwordData.currentPassword}
          placeholder={t("placeholders.currentPassword")}
          visible={showPasswords.current}
          onToggle={() => togglePasswordVisibility("current")}
          onChange={handlePasswordChange}
          disabled={isSubmitting}
          labelClass={LABEL_CLASS}
          inputClass={INPUT_CLASS}
        />

        {/* ── New Password ─────────────────────────────────────────────── */}
        <PasswordField
          label={t("fields.newPassword")}
          name="newPassword"
          value={passwordData.newPassword}
          placeholder={t("placeholders.newPassword")}
          visible={showPasswords.new}
          onToggle={() => togglePasswordVisibility("new")}
          onChange={handlePasswordChange}
          disabled={isSubmitting}
          labelClass={LABEL_CLASS}
          inputClass={INPUT_CLASS}
        />

        {/* ── Confirm Password ─────────────────────────────────────────── */}
        <PasswordField
          label={t("fields.confirmPassword")}
          name="confirmPassword"
          value={passwordData.confirmPassword}
          placeholder={t("placeholders.confirmPassword")}
          visible={showPasswords.confirm}
          onToggle={() => togglePasswordVisibility("confirm")}
          onChange={handlePasswordChange}
          disabled={isSubmitting}
          labelClass={LABEL_CLASS}
          inputClass={INPUT_CLASS}
        />

        {/* ── Submit button ─────────────────────────────────────────────── */}
        <div className="flex justify-end mt-10">
          <button
            type="submit"
            disabled={isSubmitting}
            className={`cursor-pointer px-10 py-3 w-full text-white rounded-lg font-semibold shadow-md
              hover:shadow-lg flex items-center justify-center gap-2 transition-all btn-primary
              ${isSubmitting ? "opacity-90 cursor-wait" : ""}`}
            >
            {/* Show a spinner while the request is in-flight, label otherwise */}
            {isSubmitting ? <Loader2 className="w-5 h-5 animate-spin" /> : t("button.change")}
          </button>
        </div>
      </form>
    </div>
  );
}

export default ChangePasswordCard;

// ---------------------------------------------------------------------------
// PasswordField (internal helper component)
// ---------------------------------------------------------------------------
function PasswordField({
  label,
  name,
  value,
  placeholder,
  visible,
  onToggle,
  onChange,
  disabled,
  labelClass,
  inputClass,
}) {
  return (
    <div>
      <label className={labelClass}>
        {label} <span className="text-red-500">*</span>
      </label>

      <div className="relative">
        {/* Text when visible=true, password mask otherwise */}
        <input
          type={visible ? "text" : "password"}
          name={name}
          value={value}
          onChange={onChange}
          className={inputClass}
          placeholder={placeholder}
          required
          disabled={disabled}
        />

        {/* Visibility toggle — purely cosmetic, no form submission effect */}
        <button
          type="button"
          onClick={onToggle}
          disabled={disabled}
          className="absolute inset-y-0 right-0 pr-4 flex items-center
            text-gray-500 hover:text-gray-700
            dark:text-gray-400 dark:hover:text-gray-200
            transition cursor-pointer"
        >
          {visible ? <EyeOffIcon /> : <EyeIcon />}
        </button>
      </div>
    </div>
  );
}
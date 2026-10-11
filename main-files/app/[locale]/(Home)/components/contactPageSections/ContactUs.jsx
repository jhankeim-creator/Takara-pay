"use client";

import { Mail, MapPin, Phone, Send } from "lucide-react";
import { useTranslations } from "next-intl";
import { useRef, useState } from "react";
import ReCAPTCHA from "react-google-recaptcha";
import toast from "react-hot-toast";
import { useAppSettings } from "../../../../providers/AppSettingsProvider";
import { submitContactMessage } from "../../../../utils/api";

export default function ContactSection() {
  const t = useTranslations("Contact");

  // centralized app settings
  const { appSettings } = useAppSettings();
  const recaptcha = appSettings?.google_recaptcha_credentials;
  const recaptchaEnabled = recaptcha?.status === true;
  const recaptchaSiteKey = recaptcha?.site_key ?? "";

  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    subject: "",
    message: "",
  });

  const [recaptchaToken, setRecaptchaToken] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const recaptchaRef = useRef(null);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const onCaptchaChange = (token) => {
    setRecaptchaToken(token);
  };

  const onCaptchaExpired = () => {
    setRecaptchaToken(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // only enable recaptcha validation if it's enabled in settings
    if (recaptchaEnabled && !recaptchaToken) {
      toast.error(t("form.recaptchaError"));
      return;
    }

    setIsSubmitting(true);

    const response = await submitContactMessage(formData);

    setIsSubmitting(false);

    // Handle error response
    if (response?.message?.error) {
      const errors = response.message.error;
      const errorText = Array.isArray(errors) ? errors[0] : errors;
      toast.error(errorText || t("form.errorMessage"));

      // Reset reCAPTCHA on failure so user can retry
      setRecaptchaToken(null);
      if (recaptchaRef.current) recaptchaRef.current.reset();
      return;
    }

    // Success — reset form and reCAPTCHA
    setFormData({ name: "", email: "", phone: "", subject: "", message: "" });
    setRecaptchaToken(null);
    if (recaptchaRef.current) recaptchaRef.current.reset();

    toast.success(response?.message?.success?.[0] ?? t("form.successMessage"));
  };

  return (
    <section className="relative pt-4 md:pt-8 lg:pt-12 pb-20 md:pb-28 lg:pb-32 dark:from-gray-950 dark:via-indigo-950 dark:to-purple-950 overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-20 w-72 h-72 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-20 right-20 w-96 h-96 bg-indigo-400/10 dark:bg-indigo-500/5 rounded-full blur-3xl animate-pulse" />
      </div>

      <div className="relative container mx-auto px-4 sm:px-6 lg:px-8 max-w-7xl">
        <div className="grid grid-cols-1 lg:grid-cols-[5fr_3fr] gap-8 md:gap-12 lg:gap-16 items-start">
          {/* Left: Form */}
          <div className="bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm rounded-2xl shadow-2xl p-6 md:p-8 lg:p-10 border border-blue-100/50 dark:border-blue-800/50">
            {/* Title */}
            <h2 className="text-2xl sm:text-3xl lg:text-4xl font-bold mb-6 leading-tight">
              <span className="text-slate-900 dark:text-slate-100">
                {t("form.title.part1")}
              </span>
              <span className="ml-2 bg-gradient-to-r from-blue-600 via-indigo-600 to-violet-600 dark:from-blue-400 dark:via-indigo-400 dark:to-violet-400 bg-clip-text text-transparent">
                {t("form.title.highlight")}
              </span>
              <span className="text-slate-900 dark:text-slate-100">
                {" "}
                {t("form.title.part2")}
              </span>
            </h2>

            <form onSubmit={handleSubmit} className="space-y-5 md:space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-5 md:gap-6">
                <div>
                  <label
                    htmlFor="name"
                    className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
                  >
                    {t("form.labels.name")}
                  </label>
                  <input
                    type="text"
                    id="name"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    required
                    className="w-full px-4 py-3 bg-white dark:bg-gray-800 border-2 border-slate-200 dark:border-gray-700 rounded-lg focus:ring-1 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 outline-none transition-all text-slate-900 dark:text-slate-100 placeholder-slate-400 dark:placeholder-slate-500 hover:border-slate-300 dark:hover:border-gray-600"
                    placeholder={t("form.placeholders.name")}
                  />
                </div>

                <div>
                  <label
                    htmlFor="email"
                    className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
                  >
                    {t("form.labels.email")}
                  </label>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    required
                    className="w-full px-4 py-3 bg-white dark:bg-gray-800 border-2 border-slate-200 dark:border-gray-700 rounded-lg focus:ring-1 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 outline-none transition-all text-slate-900 dark:text-slate-100 placeholder-slate-400 dark:placeholder-slate-500 hover:border-slate-300 dark:hover:border-gray-600"
                    placeholder={t("form.placeholders.email")}
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-5 md:gap-6">
                <div>
                  <label
                    htmlFor="phone"
                    className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
                  >
                    {t("form.labels.phone")}
                  </label>
                  <input
                    type="tel"
                    id="phone"
                    name="phone"
                    value={formData.phone}
                    onChange={handleChange}
                    required
                    className="w-full px-4 py-3 bg-white dark:bg-gray-800 border-2 border-slate-200 dark:border-gray-700 rounded-lg focus:ring-1 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 outline-none transition-all text-slate-900 dark:text-slate-100 placeholder-slate-400 dark:placeholder-slate-500 hover:border-slate-300 dark:hover:border-gray-600"
                    placeholder={t("form.placeholders.phone")}
                  />
                </div>

                <div>
                  <label
                    htmlFor="subject"
                    className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
                  >
                    {t("form.labels.subject")}
                  </label>
                  <input
                    type="text"
                    id="subject"
                    name="subject"
                    value={formData.subject}
                    onChange={handleChange}
                    required
                    className="w-full px-4 py-3 bg-white dark:bg-gray-800 border-2 border-slate-200 dark:border-gray-700 rounded-lg focus:ring-1 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 outline-none transition-all text-slate-900 dark:text-slate-100 placeholder-slate-400 dark:placeholder-slate-500 hover:border-slate-300 dark:hover:border-gray-600"
                    placeholder={t("form.placeholders.subject")}
                  />
                </div>
              </div>

              <div>
                <label
                  htmlFor="message"
                  className="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2"
                >
                  {t("form.labels.message")}
                </label>
                <textarea
                  id="message"
                  name="message"
                  value={formData.message}
                  onChange={handleChange}
                  required
                  rows={5}
                  className="w-full px-4 py-3 bg-white dark:bg-gray-800 border-2 border-slate-200 dark:border-gray-700 rounded-lg focus:ring-1 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 outline-none transition-all resize-none text-slate-900 dark:text-slate-100 placeholder-slate-400 dark:placeholder-slate-500 hover:border-slate-300 dark:hover:border-gray-600"
                  placeholder={t("form.placeholders.message")}
                />
              </div>

              {/* reCAPTCHA — only show if status: true */}
              {recaptchaEnabled && recaptchaSiteKey && (
                <div className="flex justify-start">
                  <ReCAPTCHA
                    ref={recaptchaRef}
                    sitekey={recaptchaSiteKey}
                    onChange={onCaptchaChange}
                    onExpired={onCaptchaExpired}
                    theme="light"
                    size="normal"
                  />
                </div>
              )}

              <button
                type="submit"
                disabled={isSubmitting}
                className="cursor-pointer group w-full px-8 py-4 bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-500 dark:to-indigo-500 text-white font-semibold rounded-xl hover:from-blue-700 hover:to-indigo-700 dark:hover:from-blue-600 dark:hover:to-indigo-600 transition-all shadow-lg hover:shadow-xl hover:scale-[1.02] active:scale-[0.98] flex items-center justify-center gap-2 disabled:opacity-70 disabled:cursor-not-allowed disabled:scale-100"
              >
                <span>
                  {isSubmitting ? t("form.sending") : t("form.button")}
                </span>
                <Send
                  className={`w-5 h-5 transition-transform duration-300 ${isSubmitting ? "animate-pulse" : "group-hover:translate-x-1"}`}
                />
              </button>
            </form>
          </div>

          {/* Right: Information */}
          <div className="bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm rounded-2xl shadow-xl p-6 md:p-8 border border-blue-100/50 dark:border-blue-800/50">
            <h3 className="text-2xl md:text-3xl font-bold text-slate-900 dark:text-slate-100 mb-4">
              {t("info.title")}
            </h3>
            <p className="text-slate-600 dark:text-slate-400 leading-relaxed mb-8">
              {t("info.description")}
            </p>

            <div className="space-y-5 md:space-y-6">
              {/* Phone */}
              <div className="flex items-center gap-4 p-4 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-blue-900/30 dark:to-indigo-900/30 rounded-xl border border-blue-100/50 dark:border-blue-800/50 hover:shadow-md transition-shadow duration-300">
                <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-lg flex items-center justify-center shrink-0 shadow-md">
                  <Phone className="w-6 h-6 text-white" />
                </div>
                <div className="min-w-0">
                  <h4 className="text-base md:text-lg font-semibold text-slate-900 dark:text-slate-100 mb-0.5">
                    {t("info.phone.label")}
                  </h4>
                  <a
                    href="tel:+11234567890"
                    className="text-slate-600 dark:text-slate-400 text-xs sm:text-sm md:text-[15px] leading-snug sm:leading-relaxed"
                  >
                    {t("info.phone.value")}
                  </a>
                </div>
              </div>

              {/* Address */}
              <div className="flex items-center gap-4 p-4 bg-gradient-to-br from-green-50 to-emerald-50 dark:from-green-900/30 dark:to-emerald-900/30 rounded-xl border border-green-100/50 dark:border-green-800/50 hover:shadow-md transition-shadow duration-300">
                <div className="w-12 h-12 bg-gradient-to-br from-green-500 to-emerald-600 dark:from-green-600 dark:to-emerald-700 rounded-lg flex items-center justify-center shrink-0 shadow-md">
                  <MapPin className="w-6 h-6 text-white" />
                </div>
                <div className="min-w-0">
                  <h4 className="text-base md:text-lg font-semibold text-slate-900 dark:text-slate-100 mb-0.5">
                    {t("info.address.label")}
                  </h4>
                  <p className="text-slate-600 dark:text-slate-400 text-xs sm:text-sm md:text-[15px] leading-snug sm:leading-relaxed">
                    {t("info.address.value")}
                  </p>
                </div>
              </div>

              {/* Email */}
              <div className="flex items-center gap-4 p-4 bg-gradient-to-br from-purple-50 to-violet-50 dark:from-purple-900/30 dark:to-violet-900/30 rounded-xl border border-purple-100/50 dark:border-purple-800/50 hover:shadow-md transition-shadow duration-300">
                <div className="w-12 h-12 bg-gradient-to-br from-purple-500 to-violet-600 dark:from-purple-600 dark:to-violet-700 rounded-lg flex items-center justify-center shrink-0 shadow-md">
                  <Mail className="w-6 h-6 text-white" />
                </div>
                <div className="min-w-0">
                  <h4 className="text-base md:text-lg font-semibold text-slate-900 dark:text-slate-100 mb-0.5">
                    {t("info.email.label")}
                  </h4>
                  <a
                    href="mailto:info@example.com"
                    className="text-slate-600 dark:text-slate-400 text-xs sm:text-sm md:text-[15px] leading-snug sm:leading-relaxed"
                  >
                    {t("info.email.value")}
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

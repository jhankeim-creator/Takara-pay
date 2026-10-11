"use client";

import { useTranslations } from "next-intl";
import Link from "next/link";

function Cancel() {
  const t = useTranslations("paymentCancel");

  return (
    <div className="bg-slate-50 dark:bg-gray-900/60 flex items-center justify-center p-4 font-sans text-left transition-colors duration-300">
      {/* Background Decor */}
      <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-[10%] -left-[10%] w-[40%] h-[40%] rounded-full bg-green-100/50 dark:bg-green-900/20 blur-[120px]" />
        <div className="absolute -bottom-[10%] -right-[10%] w-[40%] h-[40%] rounded-full bg-blue-100/50 dark:bg-blue-900/20 blur-[120px]" />
      </div>

      <div
        className="relative z-10 w-full max-w-[440px] 
        bg-white dark:bg-gray-800 
        rounded-[32px] 
        shadow-[0_20px_50px_rgba(0,0,0,0.05)] dark:shadow-[0_20px_50px_rgba(0,0,0,0.4)] 
        border border-gray-100 dark:border-gray-700 
        p-10 text-center transition-colors duration-300"
      >
        {/* Cancel Icon */}
        <div
          className="inline-flex items-center justify-center w-20 h-20 rounded-full 
          bg-orange-50 dark:bg-orange-900/30 mb-8"
        >
          <div
            className="flex items-center justify-center w-12 h-12 rounded-full 
            bg-red-500 text-white 
            shadow-lg shadow-orange-200 dark:shadow-orange-900/40"
          >
            <svg
              fill="none"
              stroke="currentColor"
              strokeWidth="2.5"
              viewBox="0 0 24 24"
              className="w-6 h-6"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </div>
        </div>

        <h1 className="text-3xl font-bold text-gray-900 dark:text-white tracking-tight mb-3">
          {t("title")}
        </h1>

        <p className="text-gray-500 dark:text-gray-400 text-lg leading-relaxed mb-10">
          {t("description")}
        </p>

        <div className="space-y-3">
          <Link
            href="/dashboard"
            className="flex items-center justify-center w-full px-8 py-4 font-semibold 
    text-white 
    bg-primary-600 
    transition-all duration-200 
    rounded-2xl 
    hover:bg-primary-700 
    active:scale-[0.98] 
    shadow-xl shadow-primary-200/40 dark:shadow-primary-900/40"
          >
            {t("button")}
          </Link>
        </div>
      </div>
    </div>
  );
}

export default Cancel;

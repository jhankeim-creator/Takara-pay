"use client";

import { Shield } from "lucide-react";
import { useTranslations } from "next-intl";

export default function PrivacyPolicy() {
  const t = useTranslations("PrivacyPolicy");

  return (
    <section className="relative pt-8 pb-16 md:pt-12 md:pb-20 lg:pt-16 lg:pb-24 dark:from-gray-950 dark:via-indigo-950 dark:to-purple-950">
      {/* Very subtle background decoration */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-16 left-12 w-64 h-64 bg-blue-400/5 dark:bg-blue-500/5 rounded-full blur-3xl" />
        <div className="absolute bottom-24 right-12 w-80 h-80 bg-indigo-400/5 dark:bg-indigo-500/5 rounded-full blur-3xl" />
      </div>

      <div className="relative container mx-auto px-5 sm:px-6 lg:px-8 max-w-4xl">
        {/* Main content */}
        <div className="bg-white dark:bg-gray-900 rounded-xl shadow-lg border border-slate-200/70 dark:border-gray-700 overflow-hidden">
          {/* Header */}
          <div className="flex justify-center pt-5 mb-4">
            <div className="flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm border border-blue-100 dark:border-blue-800/50 shadow-sm">
              <Shield className="w-5 h-5 text-blue-600 dark:text-blue-400" />
              <span className="text-base font-semibold bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400 bg-clip-text text-transparent">
                {t("title")}
              </span>
            </div>
          </div>

          <div className="p-6 md:p-8 lg:p-10 text-left md:text-justify">
            <div className="space-y-8 md:space-y-10 prose prose-slate dark:prose-invert prose-sm sm:prose-base max-w-none">
              <div>
                <h2 className="text-left text-xl md:text-2xl font-semibold text-slate-800 dark:text-slate-100 mb-4">
                  {t("sections.collect.title")}
                </h2>
                <p className="text-slate-700 dark:text-slate-300 leading-relaxed">
                  {t("sections.collect.content")}
                </p>
              </div>

              <div>
                <h2 className="text-left text-xl md:text-2xl font-semibold text-slate-800 dark:text-slate-100 mb-4">
                  {t("sections.protect.title")}
                </h2>
                <p className="text-slate-700 dark:text-slate-300 leading-relaxed">
                  {t("sections.protect.part1")}
                </p>
                <p className="mt-3 text-slate-700 dark:text-slate-300 leading-relaxed">
                  {t("sections.protect.part2")}
                </p>
              </div>

              <div>
                <h2 className="text-left text-xl md:text-2xl font-semibold text-slate-800 dark:text-slate-100 mb-4">
                  {t("sections.disclose.title")}
                </h2>
                <p className="text-slate-700 dark:text-slate-300 leading-relaxed">
                  {t("sections.disclose.content")}
                </p>
              </div>

              <div>
                <h2 className="text-left text-xl md:text-2xl font-semibold text-slate-800 dark:text-slate-100 mb-4">
                  {t("sections.coppa.title")}
                </h2>
                <p className="text-slate-700 dark:text-slate-300 leading-relaxed">
                  {t("sections.coppa.content")}
                </p>
              </div>

              <div>
                <h2 className="text-left text-xl md:text-2xl font-semibold text-slate-800 dark:text-slate-100 mb-4">
                  {t("sections.changes.title")}
                </h2>
                <p className="text-slate-700 dark:text-slate-300 leading-relaxed">
                  {t("sections.changes.content")}
                </p>
              </div>

              <div>
                <h2 className="text-left text-xl md:text-2xl font-semibold text-slate-800 dark:text-slate-100 mb-4">
                  {t("sections.retain.title")}
                </h2>
                <p className="text-slate-700 dark:text-slate-300 leading-relaxed">
                  {t("sections.retain.content")}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
/* eslint-disable @next/next/no-img-element */
"use client";

import { Shield, Sparkles, Target, Users } from "lucide-react";
import { useTranslations } from "next-intl";

export default function AboutSection() {
  const t = useTranslations("About");

  return (
    <section className="relative py-12 md:py-16 lg:py-20 dark:from-gray-950 dark:via-indigo-950 dark:to-purple-950 overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-20 w-72 h-72 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-20 right-20 w-96 h-96 bg-indigo-400/10 dark:bg-indigo-500/5 rounded-full blur-3xl animate-pulse" />
      </div>

      <div className="relative container mx-auto px-4 sm:px-6 lg:px-8 max-w-7xl">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-10 md:gap-12 lg:gap-16 items-center">
          {/* Left: Text Content */}
          <div className="space-y-3 md:space-y-4 order-1">
            {/* Badge */}
            <div className="animate-[--animate-fade-up] mb-2">
              <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/85 backdrop-blur-xl border border-indigo-500/15 shadow-[0_2px_16px_rgb(99_102_241/0.12)] text-sm font-semibold text-indigo-700 dark:bg-slate-900/80 dark:border-indigo-400/20 dark:text-indigo-300">
                <span className="size-1.5 rounded-full bg-indigo-600 dark:bg-indigo-400 animate-[--animate-pulse-dot]" />

                {t("badge")}
              </span>
            </div>

            {/* Main Title */}
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold leading-tight">
              <span className="text-slate-900 dark:text-slate-100">
                {t("title.part1")}
              </span>
              <span className="ml-2 bg-gradient-to-r from-blue-600 via-indigo-600 to-violet-600 dark:from-blue-400 dark:via-indigo-400 dark:to-violet-400 bg-clip-text text-transparent">
                {t("title.part2")}
              </span>
            </h2>

            {/* Description */}
            <p className="text-base sm:text-lg text-slate-600 dark:text-slate-300 leading-relaxed">
              {t("description")}
            </p>

            {/* Highlight Cards - Simple Single Line */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
              {/* Our Vision */}
              <div className="flex items-center gap-2 bg-white/80 dark:bg-gray-800/70 backdrop-blur-sm px-3 py-3 md:px-4 md:py-3.5 rounded-lg border border-blue-100/50 dark:border-blue-800/50 hover:shadow-lg hover:border-blue-200 dark:hover:border-blue-700 transition-all duration-300">
                <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-lg flex items-center justify-center shrink-0">
                  <Target className="w-4 h-4 text-white" />
                </div>
                <h3 className="text-xs md:text-sm font-semibold text-slate-900 dark:text-slate-100">
                  {t("highlights.vision.title")}
                </h3>
              </div>

              {/* The StripCard Difference */}
              <div className="flex items-center gap-2 bg-white/80 dark:bg-gray-800/70 backdrop-blur-sm px-3 py-3 md:px-4 md:py-3.5 rounded-lg border border-indigo-100/50 dark:border-indigo-800/50 hover:shadow-lg hover:border-indigo-200 dark:hover:border-indigo-700 transition-all duration-300">
                <div className="w-8 h-8 bg-gradient-to-br from-indigo-500 to-violet-600 dark:from-indigo-600 dark:to-violet-700 rounded-lg flex items-center justify-center shrink-0">
                  <Sparkles className="w-4 h-4 text-white" />
                </div>
                <h3 className="text-xs md:text-sm font-semibold text-slate-900 dark:text-slate-100">
                  {t("highlights.difference.title")}
                </h3>
              </div>

              {/* Our Commitment */}
              <div className="flex items-center gap-2 bg-white/80 dark:bg-gray-800/70 backdrop-blur-sm px-3 py-3 md:px-4 md:py-3.5 rounded-lg border border-green-100/50 dark:border-green-800/50 hover:shadow-lg hover:border-green-200 dark:hover:border-green-700 transition-all duration-300">
                <div className="w-8 h-8 bg-gradient-to-br from-green-500 to-emerald-600 dark:from-green-600 dark:to-emerald-700 rounded-lg flex items-center justify-center shrink-0">
                  <Shield className="w-4 h-4 text-white" />
                </div>
                <h3 className="text-xs md:text-sm font-semibold text-slate-900 dark:text-slate-100">
                  {t("highlights.commitment.title")}
                </h3>
              </div>

              {/* Join Us */}
              <div className="flex items-center gap-2 bg-white/80 dark:bg-gray-800/70 backdrop-blur-sm px-3 py-3 md:px-4 md:py-3.5 rounded-lg border border-purple-100/50 dark:border-purple-800/50 hover:shadow-lg hover:border-purple-200 dark:hover:border-purple-700 transition-all duration-300">
                <div className="w-8 h-8 bg-gradient-to-br from-purple-500 to-violet-600 dark:from-purple-600 dark:to-violet-700 rounded-lg flex items-center justify-center shrink-0">
                  <Users className="w-4 h-4 text-white" />
                </div>
                <h3 className="text-xs md:text-sm font-semibold text-slate-900 dark:text-slate-100">
                  {t("highlights.join.title")}
                </h3>
              </div>
            </div>
          </div>

          {/* Right: Image */}
          <div className="relative order-2">
            <div className="relative rounded-2xl overflow-hidden shadow-none shadow-blue-500/20 dark:shadow-blue-500/10 group">
              {/* Main Image */}
              <div className="aspect-4/3 md:aspect-5/4 lg:aspect-auto">
                <img
                  src="/About-Us-Sections/Smart_Transactions.webp"
                  alt={t("imageAlt")}
                  className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                />
              </div>

              {/* Gradient overlay on hover */}
              <div className="absolute inset-0 bg-gradient-to-tr from-blue-600/20 via-transparent to-indigo-600/20 dark:from-blue-500/15 dark:via-transparent dark:to-indigo-500/15 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            </div>

            {/* Floating decorative elements */}
            <div className="absolute -top-6 -right-6 w-32 h-32 bg-gradient-to-br from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-2xl shadow-xl rotate-12 opacity-20 blur-sm hidden lg:block" />
            <div className="absolute -bottom-6 -left-6 w-24 h-24 bg-gradient-to-br from-violet-500 to-purple-600 dark:from-violet-600 dark:to-violet-700 rounded-2xl shadow-xl -rotate-12 opacity-20 blur-sm hidden lg:block" />
          </div>
        </div>
      </div>
    </section>
  );
}

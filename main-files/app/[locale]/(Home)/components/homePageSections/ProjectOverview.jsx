/* eslint-disable @next/next/no-img-element */
"use client";
import { useTranslations } from "next-intl";
import { useEffect, useRef, useState } from "react";

export default function ProjectOverview() {
  const t = useTranslations("ProjectOverview");

  const [counters, setCounters] = useState({
    users: 0,
    happy: 0,
    services: 0,
    transactions: 0,
  });
  const [hasAnimated, setHasAnimated] = useState(false);
  const sectionRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && !hasAnimated) {
          setHasAnimated(true);
          animateCounters();
        }
      },
      { threshold: 0.3 },
    );

    if (sectionRef.current) {
      observer.observe(sectionRef.current);
    }

    return () => observer.disconnect();
  }, [hasAnimated]);

  const animateCounters = () => {
    const duration = 2000;
    const steps = 60;
    const stepDuration = duration / steps;

    const targets = {
      users: 100,
      happy: 1000,
      services: 12000,
      transactions: 10,
    };

    let step = 0;
    const timer = setInterval(() => {
      step++;
      const progress = step / steps;

      setCounters({
        users: Math.floor(targets.users * progress),
        happy: Math.floor(targets.happy * progress),
        services: Math.floor(targets.services * progress),
        transactions: Math.floor(targets.transactions * progress),
      });

      if (step >= steps) {
        clearInterval(timer);
        setCounters(targets);
      }
    }, stepDuration);
  };

  return (
    <section
      ref={sectionRef}
      className="relative w-full py-12 sm:py-16 md:py-20 lg:py-24 bg-gradient-to-br from-slate-50 via-white to-blue-50/30 dark:from-slate-950 dark:via-slate-900 dark:to-indigo-950/40 overflow-hidden"
    >
      {/* Background Elements */}
      <div className="absolute inset-0 pointer-events-none overflow-hidden">
        <div className="absolute top-20 sm:top-40 right-10 sm:right-20 w-48 h-48 sm:w-96 sm:h-96 bg-gradient-to-bl from-blue-400/10 to-transparent dark:from-blue-600/8 dark:to-transparent rounded-full blur-3xl animate-pulse-slow" />
        <div className="absolute bottom-20 sm:bottom-40 left-10 sm:left-20 w-48 h-48 sm:w-96 sm:h-96 bg-gradient-to-tr from-indigo-400/10 to-transparent dark:from-indigo-600/8 dark:to-transparent rounded-full blur-3xl animate-pulse-slow [animation-delay:2s]" />
        <div className="absolute top-1/2 left-1/4 w-32 h-32 sm:w-64 sm:h-64 bg-gradient-to-br from-purple-400/5 to-transparent dark:from-purple-600/5 dark:to-transparent rounded-full blur-2xl animate-pulse-slow [animation-delay:1s]" />
        <div className="absolute bottom-1/3 right-1/3 w-40 h-40 sm:w-72 sm:h-72 bg-gradient-to-tl from-cyan-400/5 to-transparent dark:from-cyan-600/5 dark:to-transparent rounded-full blur-2xl animate-pulse-slow [animation-delay:3s]" />
      </div>

      {/* Enhanced Dot Pattern */}
      <div
        className="absolute inset-0 opacity-[0.02] dark:opacity-[0.05]"
        style={{
          backgroundImage: `radial-gradient(circle, #4F46E5 1px, transparent 1px)`,
          backgroundSize: "30px 30px",
        }}
      />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-12">
        {/* Header */}
        <div className="text-center mb-12 sm:mb-14 md:mb-16 max-w-3xl mx-auto">
          {/* Section Badge */}
          <div className="animate-[--animate-fade-up] pb-5">
                <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/85 backdrop-blur-xl border border-indigo-500/15 shadow-[0_2px_16px_rgb(99_102_241/0.12)] text-sm font-semibold text-indigo-700 dark:bg-slate-900/80 dark:border-indigo-400/20 dark:text-indigo-300">
                  <span className="size-1.5 rounded-full bg-indigo-600 dark:bg-indigo-400 animate-[--animate-pulse-dot]" />

                  {t("badge")}
                </span>
          </div>

          {/* Title */}
          <h2 className="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-bold text-slate-900 dark:text-slate-100 mb-5 sm:mb-7 px-4">
            {t("title.main")}{" "}
            <span className="bg-gradient-to-r from-blue-600 via-indigo-600 to-violet-600 dark:from-blue-400 dark:via-indigo-400 dark:to-violet-400 bg-clip-text text-transparent">
              {t("title.highlight")}
            </span>
          </h2>

          {/* Description */}
          <p className="text-sm sm:text-base md:text-lg text-slate-600 dark:text-slate-300 px-4 max-w-2xl mx-auto">
            {t("description")}
          </p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5 sm:gap-6 lg:gap-8 mb-12 sm:mb-14 md:mb-16">
          {/* Stat 1 - Users */}
          <div className="group relative bg-white/90 backdrop-blur-sm dark:bg-slate-900/70 rounded-3xl shadow-xl hover:shadow-2xl border border-white/60 dark:border-slate-700/50 transition-all duration-500 overflow-hidden hover:-translate-y-3 animate-fade-in-up">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-500 to-cyan-500 opacity-0 group-hover:opacity-[0.08] dark:group-hover:opacity-[0.15] transition-opacity duration-500" />
            <div className="absolute inset-0 bg-gradient-to-br from-blue-500 to-cyan-500 opacity-0 group-hover:opacity-[0.12] blur-xl dark:group-hover:opacity-[0.20] transition-opacity duration-500" />
            <div className="absolute inset-0 -translate-x-full group-hover:translate-x-full transition-transform duration-1000 bg-gradient-to-r from-transparent via-white/20 to-transparent dark:via-slate-200/10" />
            <div className="relative p-6 sm:p-7 md:p-9 text-center">
              <div className="inline-flex items-center justify-center w-16 h-16 sm:w-18 sm:h-18 md:w-22 md:h-22 bg-gradient-to-br from-blue-50 to-cyan-50 dark:from-blue-950/50 dark:to-cyan-950/50 rounded-3xl mb-4 md:mb-5 group-hover:scale-110 transition-transform duration-500 shadow-lg group-hover:shadow-xl">
                <span className="text-2xl sm:text-3xl md:text-4xl font-bold bg-gradient-to-br from-blue-600 to-cyan-600 bg-clip-text text-transparent">
                  {counters.users}+
                </span>
              </div>
              <h3 className="text-base sm:text-lg md:text-xl font-bold text-slate-900 dark:text-slate-100 mb-2 md:mb-3 group-hover:bg-gradient-to-r group-hover:from-blue-600 group-hover:to-cyan-600 group-hover:bg-clip-text group-hover:text-transparent transition-all duration-300">
                {t("stats.users.title")}
              </h3>
              <p className="text-xs sm:text-sm text-slate-600 dark:text-slate-400">
                {t("stats.users.subtitle")}
              </p>
            </div>
            <div className="h-1.5 bg-gradient-to-r from-blue-500 to-cyan-500 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500 origin-left" />
          </div>

          {/* Stat 2 - Happy Users */}
          <div
            className="group relative bg-white/90 backdrop-blur-sm dark:bg-slate-900/70 rounded-3xl shadow-xl hover:shadow-2xl border border-white/60 dark:border-slate-700/50 transition-all duration-500 overflow-hidden hover:-translate-y-3 animate-fade-in-up"
            style={{ animationDelay: "150ms" }}
          >
            <div className="absolute inset-0 bg-gradient-to-br from-green-500 to-emerald-500 opacity-0 group-hover:opacity-[0.08] dark:group-hover:opacity-[0.15] transition-opacity duration-500" />
            <div className="absolute inset-0 bg-gradient-to-br from-green-500 to-emerald-500 opacity-0 group-hover:opacity-[0.12] blur-xl dark:group-hover:opacity-[0.20] transition-opacity duration-500" />
            <div className="absolute inset-0 -translate-x-full group-hover:translate-x-full transition-transform duration-1000 bg-gradient-to-r from-transparent via-white/20 to-transparent dark:via-slate-200/10" />
            <div className="relative p-6 sm:p-7 md:p-9 text-center">
              <div className="inline-flex items-center justify-center w-16 h-16 sm:w-18 sm:h-18 md:w-22 md:h-22 bg-gradient-to-br from-green-50 to-emerald-50 dark:from-green-950/50 dark:to-emerald-950/50 rounded-3xl mb-4 md:mb-5 group-hover:scale-110 transition-transform duration-500 shadow-lg group-hover:shadow-xl">
                <span className="text-2xl sm:text-3xl md:text-4xl font-bold bg-gradient-to-br from-green-600 to-emerald-600 bg-clip-text text-transparent">
                  {counters.happy >= 1000 ? "1K" : counters.happy}+
                </span>
              </div>
              <h3 className="text-base sm:text-lg md:text-xl font-bold text-slate-900 dark:text-slate-100 mb-2 md:mb-3 group-hover:bg-gradient-to-r group-hover:from-green-600 group-hover:to-emerald-600 group-hover:bg-clip-text group-hover:text-transparent transition-all duration-300">
                {t("stats.happy.title")}
              </h3>
              <p className="text-xs sm:text-sm text-slate-600 dark:text-slate-400">
                {t("stats.happy.subtitle")}
              </p>
            </div>
            <div className="h-1.5 bg-gradient-to-r from-green-500 to-emerald-500 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500 origin-left" />
          </div>

          {/* Stat 3 - Services */}
          <div
            className="group relative bg-white/90 backdrop-blur-sm dark:bg-slate-900/70 rounded-3xl shadow-xl hover:shadow-2xl border border-white/60 dark:border-slate-700/50 transition-all duration-500 overflow-hidden hover:-translate-y-3 animate-fade-in-up sm:col-span-2 lg:col-span-1"
            style={{ animationDelay: "300ms" }}
          >
            <div className="absolute inset-0 bg-gradient-to-br from-purple-500 to-fuchsia-500 opacity-0 group-hover:opacity-[0.08] dark:group-hover:opacity-[0.15] transition-opacity duration-500" />
            <div className="absolute inset-0 bg-gradient-to-br from-purple-500 to-fuchsia-500 opacity-0 group-hover:opacity-[0.12] blur-xl dark:group-hover:opacity-[0.20] transition-opacity duration-500" />
            <div className="absolute inset-0 -translate-x-full group-hover:translate-x-full transition-transform duration-1000 bg-gradient-to-r from-transparent via-white/20 to-transparent dark:via-slate-200/10" />
            <div className="relative p-6 sm:p-7 md:p-9 text-center">
              <div className="inline-flex items-center justify-center w-16 h-16 sm:w-18 sm:h-18 md:w-22 md:h-22 bg-gradient-to-br from-purple-50 to-fuchsia-50 dark:from-purple-950/50 dark:to-fuchsia-950/50 rounded-3xl mb-4 md:mb-5 group-hover:scale-110 transition-transform duration-500 shadow-lg group-hover:shadow-xl">
                <span className="text-2xl sm:text-3xl md:text-4xl font-bold bg-gradient-to-br from-purple-600 to-fuchsia-600 bg-clip-text text-transparent">
                  {counters.services >= 1000
                    ? (counters.services / 1000).toFixed(0) + "K"
                    : counters.services}
                  +
                </span>
              </div>
              <h3 className="text-base sm:text-lg md:text-xl font-bold text-slate-900 dark:text-slate-100 mb-2 md:mb-3 group-hover:bg-gradient-to-r group-hover:from-purple-600 group-hover:to-fuchsia-600 group-hover:bg-clip-text group-hover:text-transparent transition-all duration-300">
                {t("stats.services.title")}
              </h3>
              <p className="text-xs sm:text-sm text-slate-600 dark:text-slate-400">
                {t("stats.services.subtitle")}
              </p>
            </div>
            <div className="h-1.5 bg-gradient-to-r from-purple-500 to-fuchsia-500 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500 origin-left" />
          </div>
        </div>

        {/* Image Section */}
        <div
          className="relative max-w-5xl mx-auto animate-fade-in-up"
          style={{ animationDelay: "450ms" }}
        >
          <div className="relative overflow-hidden rounded-3xl shadow-2xl group">
            {/* Image */}
            <img
              src="/Project-Overview-Sections/banking_payment.avif"
              alt="Financial Dashboard"
              className="w-full aspect-[16/9] object-cover transition-transform duration-700 group-hover:scale-[1.08]"
            />

            {/* Gradient Overlay */}
            <div className="absolute inset-0 bg-gradient-to-tr from-blue-600/15 via-transparent to-indigo-600/15 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

            {/* Decorative Corners */}
            <div className="absolute bottom-0 left-0 w-20 h-20 sm:w-24 sm:h-24 md:w-28 md:h-28 lg:w-36 lg:h-36 bg-gradient-to-tr from-blue-500/25 to-transparent dark:from-blue-600/20 dark:to-transparent rounded-tr-[4rem]" />
            <div className="absolute top-0 right-0 w-16 h-16 sm:w-20 sm:h-20 md:w-24 md:h-24 lg:w-28 lg:h-28 bg-gradient-to-bl from-indigo-500/20 to-transparent dark:from-indigo-600/15 dark:to-transparent rounded-bl-[3rem]" />

            {/* Floating Badge – bottom-left corner */}
            <div className="absolute bottom-3 left-3 sm:bottom-6 sm:left-6 z-10 max-w-[calc(100%-24px)] sm:max-w-none">
              <div className="relative bg-white/20 dark:bg-slate-900/30 backdrop-blur-xl rounded-xl sm:rounded-2xl border border-white/30 dark:border-white/10 shadow-2xl p-3 sm:p-5 flex items-center gap-2.5 sm:gap-4 group/badge hover:scale-105 transition-transform duration-300">
                {/* Glow */}
                <div className="absolute inset-0 rounded-xl sm:rounded-2xl bg-gradient-to-br from-blue-500/20 to-violet-500/20 blur-md -z-10" />

                {/* Icon ring */}
                <div className="relative flex-shrink-0 flex items-center justify-center w-8 h-8 sm:w-12 sm:h-12 rounded-lg sm:rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 shadow-lg shadow-blue-500/40">
                  <svg
                    className="w-4 h-4 sm:w-6 sm:h-6 text-white"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    strokeWidth={2.5}
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"
                    />
                  </svg>
                  <span className="absolute -inset-1 rounded-lg sm:rounded-xl border border-blue-400/40 animate-ping opacity-50" />
                </div>

                {/* Text */}
                <div className="flex flex-col justify-center">
                  <p className="text-[9px] sm:text-xs font-bold uppercase tracking-wider text-white/70 leading-tight sm:leading-none mb-0.5 sm:mb-1">
                    {t("transactionsBadge.label")}
                  </p>
                  <p className="text-base sm:text-xl font-extrabold text-white leading-none flex items-center">
                    {t("transactionsBadge.amount", {
                      value: counters.transactions,
                    })}
                    <span className="text-blue-300 ml-0.5">+</span>
                  </p>
                  <p className="text-[8px] sm:text-xs text-white/60 leading-tight sm:leading-none mt-0.5 sm:mt-1">
                    {t("transactionsBadge.subtitle")}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

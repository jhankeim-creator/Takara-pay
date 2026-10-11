/* eslint-disable @next/next/no-img-element */
"use client";

import { Download, Shield, Zap } from "lucide-react";
import { useTranslations } from "next-intl";
import {
  AppStoreIcon,
  GooglePlayIcon,
} from "../../../../components/StoreButtonsIcon";
import { useAppSettings } from "../../../../providers/AppSettingsProvider";

export default function DownloadApp() {
  const t = useTranslations("DownloadApp");
  const { appSettings } = useAppSettings();

  const appUrls = {
  android_url: appSettings?.app_url?.android_url || "https://play.google.com/store/apps",
  iso_url: appSettings?.app_url?.iso_url || "https://www.apple.com/app-store/",
};
  return (
    <section className="relative w-full py-16 md:py-24 lg:py-32 bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50 dark:from-gray-950 dark:via-indigo-950 dark:to-purple-950 overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 right-20 w-72 h-72 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-20 left-20 w-96 h-96 bg-indigo-400/10 dark:bg-indigo-500/5 rounded-full blur-3xl animate-pulse" />
      </div>

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-10 md:gap-12 lg:gap-16 items-center">
          {/* Left – Image (Desktop only) */}
          <div className="relative hidden lg:block">
            <div className="relative rounded-2xl overflow-hidden shadow-none shadow-blue-500/20 dark:shadow-blue-500/10 group">
              {/* Main Image */}
              <img
                src="/Download-App-Sections/download_app.webp"
                alt={t("imageAlt")}
                className="w-full h-auto object-cover rounded-2xl transform scale-[1.15] sm:scale-125 lg:scale-[1.37] group-hover:scale-[1.30] transition-transform duration-700 ease-in-out origin-center"
              />

              {/* Gradient overlay on hover */}
              <div className="absolute inset-0 bg-gradient-to-tr from-blue-600/20 via-transparent to-indigo-600/20 dark:from-blue-500/15 dark:via-transparent dark:to-indigo-500/15 opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-2xl" />
            </div>

            {/* Floating decorative elements */}
            <div className="absolute top-4 right-18 w-32 h-32 bg-gradient-to-br from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-2xl shadow-xl rotate-12 opacity-20 blur-sm hidden lg:block" />
            <div className="absolute bottom-4 left-32 w-24 h-24 bg-gradient-to-br from-violet-500 to-purple-600 dark:from-violet-600 dark:to-violet-700 rounded-2xl shadow-xl -rotate-12 opacity-20 blur-sm hidden lg:block" />

            {/* Floating badge */}
            <div className="absolute top-[38%] left-1 bg-white/95 dark:bg-gray-800/90 backdrop-blur-md rounded-xl shadow-lg p-3 border border-blue-100 dark:border-blue-800/50 hidden sm:block">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-lg flex items-center justify-center">
                  <Download className="w-4 h-4 text-white" />
                </div>
                <div>
                  <p className="text-xs font-bold text-slate-900 dark:text-slate-100">
                    {t("floatingBadge.available")}
                  </p>
                  <p className="text-[10px] text-slate-600 dark:text-slate-300">
                    {t("floatingBadge.platforms")}
                  </p>
                </div>
              </div>
            </div>
          </div>

          {/* Right – Text content + Official badges */}
          <div className="space-y-6 md:space-y-8 text-center lg:text-left">
            <div className="space-y-3 md:space-y-4">
              {/* Small caption with badge style */}
              <div className="animate-[--animate-fade-up]">
                <span className="inline-flex items-center gap-2 px-4 py-2 mx-auto lg:mx-0 rounded-full bg-white/85 backdrop-blur-xl border border-indigo-500/15 shadow-[0_2px_16px_rgb(99_102_241/0.12)] text-sm font-semibold text-indigo-700 dark:bg-slate-900/80 dark:border-indigo-400/20 dark:text-indigo-300">
                  <span className="size-1.5 rounded-full bg-indigo-600 dark:bg-indigo-400 animate-[--animate-pulse-dot]" />

                  {t("sectionBadge")}
                </span>
              </div>

              {/* Main title with gradient accent */}
              <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold leading-tight">
                <span className="text-slate-900 dark:text-slate-100">
                  {t("title.part1")}{" "}
                </span>
                <span className="bg-gradient-to-r from-blue-600 via-indigo-600 to-violet-600 dark:from-blue-400 dark:via-indigo-400 dark:to-violet-400 bg-clip-text text-transparent">
                  {t("title.part2")}
                </span>
              </h2>
            </div>

            {/* First paragraph */}
            <p className="text-base sm:text-lg text-slate-600 dark:text-slate-300 leading-relaxed">
              {t("paragraph1")}
            </p>

            {/* Second paragraph */}
            <p className="text-base sm:text-lg text-slate-600 dark:text-slate-300 leading-relaxed">
              {t("paragraph2")}
            </p>

            {/* Feature highlights */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-4 text-left">
              <div className="flex items-center gap-3 p-3 bg-white/60 dark:bg-gray-800/60 backdrop-blur-sm rounded-lg border border-blue-100/50 dark:border-blue-800/50">
                <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-lg flex items-center justify-center shrink-0">
                  <Zap className="w-5 h-5 text-white" />
                </div>
                <div>
                  <p className="text-xs font-bold text-slate-900 dark:text-slate-100">
                    {t("features.fast.title")}
                  </p>
                  <p className="text-[10px] text-slate-600 dark:text-slate-300">
                    {t("features.fast.subtitle")}
                  </p>
                </div>
              </div>

              <div className="flex items-center gap-3 p-3 bg-white/60 dark:bg-gray-800/60 backdrop-blur-sm rounded-lg border border-blue-100/50 dark:border-blue-800/50">
                <div className="w-10 h-10 bg-gradient-to-br from-green-500 to-emerald-600 dark:from-green-600 dark:to-emerald-700 rounded-lg flex items-center justify-center shrink-0">
                  <Shield className="w-5 h-5 text-white" />
                </div>
                <div>
                  <p className="text-xs font-bold text-slate-900 dark:text-slate-100">
                    {t("features.secure.title")}
                  </p>
                  <p className="text-[10px] text-slate-600 dark:text-slate-300">
                    {t("features.secure.subtitle")}
                  </p>
                </div>
              </div>

              <div className="flex items-center gap-3 p-3 bg-white/60 dark:bg-gray-800/60 backdrop-blur-sm rounded-lg border border-blue-100/50 dark:border-blue-800/50">
                <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-violet-600 dark:from-purple-600 dark:to-violet-700 rounded-lg flex items-center justify-center shrink-0">
                  <Download className="w-5 h-5 text-white" />
                </div>
                <div>
                  <p className="text-xs font-bold text-slate-900 dark:text-slate-100">
                    {t("features.free.title")}
                  </p>
                  <p className="text-[10px] text-slate-600 dark:text-slate-300">
                    {t("features.free.subtitle")}
                  </p>
                </div>
              </div>
            </div>

            {/* Mobile/Tablet Image (Visible only on < lg) */}
            <div className="relative block lg:hidden py-4 sm:py-8">
              <div className="relative rounded-2xl overflow-hidden shadow-none shadow-blue-500/20 dark:shadow-blue-500/10 group">
                <img
                  src="/Download-App-Sections/download_app.webp"
                  alt={t("imageAlt")}
                  className="w-full h-auto object-cover rounded-2xl transform scale-[1.15] sm:scale-125 transition-transform duration-700 ease-in-out origin-center"
                />
                <div className="absolute inset-0 bg-gradient-to-tr from-blue-600/20 via-transparent to-indigo-600/20 dark:from-blue-500/15 dark:via-transparent dark:to-indigo-500/15 opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-2xl" />
              </div>

              {/* Floating badge for Mobile/Tablet */}
              <div className="absolute top-[38%] left-1 bg-white/95 dark:bg-gray-800/90 backdrop-blur-md rounded-xl shadow-lg p-3 border border-blue-100 dark:border-blue-800/50 hidden sm:block lg:hidden">
                <div className="flex items-center gap-2">
                  <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-lg flex items-center justify-center">
                    <Download className="w-4 h-4 text-white" />
                  </div>
                  <div>
                    <p className="text-xs font-bold text-slate-900 dark:text-slate-100">
                      {t("floatingBadge.available")}
                    </p>
                    <p className="text-[10px] text-slate-600 dark:text-slate-300">
                      {t("floatingBadge.platforms")}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            {/* Official Download Buttons */}
            <div className="pt-6 lg:pt-0">
              <p className="text-sm font-semibold text-slate-700 dark:text-slate-300 mb-4">
                {t("downloadPrompt")}
              </p>
              <div className="flex flex-wrap items-center justify-center lg:justify-start gap-6 pb-8 lg:pb-20">
                {/* Google Play */}
                <div className="relative group">
                  <a
                    href={appUrls.android_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="block transition-all duration-300 hover:scale-105 hover:brightness-95 active:scale-95 shadow-lg hover:shadow-xl"
                  >
                    <GooglePlayIcon />
                  </a>
                  {/* QR Card */}
                  <div className="absolute left-1/2 -translate-x-1/2 top-full mt-3 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-50 hidden lg:block">
                    <div className="bg-white p-3 rounded-xl shadow-2xl border w-44 text-center">
                      <img
                        src={`https://qrcode.tec-it.com/API/QRCode?data=${encodeURIComponent(appUrls.android_url)}`}
                        alt={t("qr.googleAlt")}
                        className="w-36 h-36 mx-auto"
                      />
                    </div>
                  </div>
                </div>

                {/* App Store */}
                <div className="relative group">
                  <a
                    href={appUrls.iso_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="block transition-all duration-300 hover:scale-105 hover:brightness-95 active:scale-95 shadow-lg hover:shadow-xl"
                  >
                    <AppStoreIcon />
                  </a>
                  {/* QR Card */}
                  <div className="absolute left-1/2 -translate-x-1/2 top-full mt-3 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-50 hidden lg:block">
                    <div className="bg-white p-3 rounded-xl shadow-2xl border w-44 text-center">
                      <img
                        src={`https://qrcode.tec-it.com/API/QRCode?data=${encodeURIComponent(appUrls.iso_url)}`}
                        alt={t("qr.appStoreAlt")}
                        className="w-36 h-36 mx-auto"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

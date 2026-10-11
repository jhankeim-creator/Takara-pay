/* eslint-disable react-hooks/set-state-in-effect */
"use client";

import { Check, ChevronDown, Globe, Menu, Moon, Sun } from "lucide-react";
import { usePathname, useRouter, useSearchParams  } from "next/navigation";
import { useTranslations } from "next-intl";
import { useEffect, useRef, useState } from "react";
import toast from "react-hot-toast";
import "../styles/Navbar.css";
import { getUserProfile } from "../utils/api";
import UserMenu from "./UserMenu";
import NotificationBell from "./icons/NotificationBell";

const LANGUAGES = [
  { code: "en", label: "English", native: "English" },
  { code: "ar", label: "Arabic", native: "العربية" },
  { code: "es", label: "Spanish", native: "Español" },
  { code: "fr", label: "French", native: "Français" },
  { code: "hi", label: "Hindi", native: "हिन्दी" },
];

export default function Navbar({ onMenuClick }) {
  const [userName, setUserName] = useState("User");
  const [isDarkMode, setIsDarkMode] = useState(false);
  const [isLangOpen, setIsLangOpen] = useState(false);
  const langDropdownRef = useRef(null);
  const pathname = usePathname();
  const router = useRouter();
  const searchParams = useSearchParams();
   const t = useTranslations("Nav");

  useEffect(() => {
    const savedMode = localStorage.getItem("darkMode") === "true";
    setIsDarkMode(savedMode);
    if (savedMode) document.documentElement.classList.add("dark");
  }, []);

  useEffect(() => {
    const fetchUser = async () => {
      try {
        const response = await getUserProfile();
        const user = response?.data?.user || response?.user;
        if (user) {
          const name =
            user.fullname ||
            `${user.firstname || ""} ${user.lastname || ""}`.trim() ||
            user.username ||
            "User";
          setUserName(name);
        }
      } catch (error) {
        toast.error("Failed to load user name");
      }
    };
    fetchUser();
  }, []);

  // Close dropdown on outside click
  useEffect(() => {
    const handleClickOutside = (e) => {
      if (
        langDropdownRef.current &&
        !langDropdownRef.current.contains(e.target)
      ) {
        setIsLangOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const toggleDarkMode = () => {
    const newMode = !isDarkMode;
    setIsDarkMode(newMode);
    localStorage.setItem("darkMode", newMode.toString());
    if (newMode) document.documentElement.classList.add("dark");
    else document.documentElement.classList.remove("dark");
  };

  const getCurrentLocale = () => pathname.split("/")[1] || "en";

  const switchLanguage = (langCode) => {
  const currentLocale = getCurrentLocale();
  const newPath = pathname.replace(`/${currentLocale}`, `/${langCode}`);

  const params = searchParams.toString();

  const finalUrl = params ? `${newPath}?${params}` : newPath;

  router.push(finalUrl || `/${langCode}`);
  setIsLangOpen(false);
};

  const currentLang =
    LANGUAGES.find((l) => l.code === getCurrentLocale()) || LANGUAGES[0];

  return (
    <nav className="px-4 sm:px-6 py-4">
      <div className="flex items-center justify-between">
        {/* Left Side */}
        <div className="flex items-center gap-4">
          <button
            onClick={onMenuClick}
            className="lg:hidden p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors cursor-pointer"
            aria-label="Open menu"
          >
            <Menu size={24} className="text-black dark:text-white" />
          </button>

          <div className="hidden sm:block ltr:pl-4 rtl:pr-4">
            <h1 className="text-base sm:text-lg font-semibold text-gray-950 dark:text-gray-200">
              {t("welcomeBack")}
            </h1>
            <p className="text-xs sm:text-sm text-gray-600 dark:text-gray-400 mt-0.5">
              {userName}
            </p>
          </div>
        </div>

        {/* Right Side */}
        <div className="flex items-center gap-2 sm:gap-3 px-0 sm:px-8">
          {/* Language Switcher */}

          <div className="relative" ref={langDropdownRef}>
            <button
              className={`flex items-center gap-1.5 px-3 py-2 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors text-gray-700 dark:text-gray-200 ${
                isLangOpen ? "bg-gray-100 dark:bg-gray-800" : ""
              }`}
              onClick={() => setIsLangOpen((v) => !v)}
              aria-label="Select language"
            >
              <Globe size={20} />
              <span className="lang-code uppercase text-sm font-semibold">{currentLang.code}</span>
              <ChevronDown
                size={16}
                className={`transition-transform duration-200 ${isLangOpen ? "rotate-180" : ""}`}
              />
            </button>

            {isLangOpen && (
              <div className="absolute ltr:-right-14 sm:ltr:right-0 rtl:-left-14 sm:rtl:left-0 mt-2 w-56 bg-white dark:bg-gray-900 rounded-2xl shadow-xl border border-gray-200 dark:border-gray-700 py-2 z-50 overflow-hidden">
                {LANGUAGES.map((lang) => {
                  const isSelected = lang.code === currentLang.code;
                  return (
                    <button
                      key={lang.code}
                      className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors text-left ${
                        isSelected ? "bg-gray-50 dark:bg-gray-800" : ""
                      }`}
                      onClick={() => switchLanguage(lang.code)}
                    >
                      <span className="text-2xl">{lang.flag}</span>
                      <div className="flex flex-col">
                        <span className="font-medium text-sm">
                          {lang.native}
                        </span>
                        <span className="text-xs text-gray-500 dark:text-gray-400">
                          {lang.label}
                        </span>
                      </div>
                      {isSelected && (
                        <Check size={13} className="ltr:ml-auto rtl:mr-auto text-green-500" />
                      )}
                    </button>
                  );
                })}
              </div>
            )}
          </div>

          {/* Dark Mode Toggle */}
          <button
            onClick={toggleDarkMode}
            className="cursor-pointer flex items-center justify-center w-9 h-9 rounded-lg text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200 hover:scale-105"
            aria-label="Toggle dark mode"
          >
            {isDarkMode ? (
              <Sun className="w-5 h-5 transition-transform duration-300 hover:rotate-90" />
            ) : (
              <Moon className="w-5 h-5 transition-transform duration-300 hover:-rotate-12" />
            )}
          </button>

          <NotificationBell />
          <UserMenu />
        </div>
      </div>
    </nav>
  );
}

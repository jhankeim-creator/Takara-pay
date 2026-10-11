/* eslint-disable react-hooks/set-state-in-effect */
"use client";
import {
  Check,
  ChevronDown,
  Globe,
  HelpCircle,
  LayoutDashboard,
  Menu,
  Moon,
  Sun,
  X,
} from "lucide-react";
import { useTranslations } from "next-intl";
import Image from "next/image";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useRef, useState } from "react";

const LANGUAGES = [
  { code: "en", label: "English", native: "English" },
  { code: "ar", label: "Arabic", native: "العربية" },
  { code: "es", label: "Spanish", native: "Español" },
  { code: "fr", label: "French", native: "Français" },
  { code: "hi", label: "Hindi", native: "हिन्दी" },
];

export default function Navbar() {
  const [isDarkMode, setIsDarkMode] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);
  const [isLangOpen, setIsLangOpen] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const langDropdownRef = useRef(null);
  const pathname = usePathname();
  const router = useRouter();
  const t = useTranslations("Nav");

  useEffect(() => {
    const savedMode = localStorage.getItem("darkMode") === "true";
    setIsDarkMode(savedMode);
    if (savedMode) {
      document.documentElement.classList.add("dark");
    }

    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };
    window.addEventListener("scroll", handleScroll);

    // ── Auth check ──────────────────────────────────────────────────────────
    const user = localStorage.getItem("user") || sessionStorage.getItem("user");
    setIsLoggedIn(Boolean(user));
    // ────────────────────────────────────────────────────────────────────────

    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // Close lang dropdown on outside click
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
    if (newMode) {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
  };

  const toggleMobileMenu = () => setIsMobileMenuOpen(!isMobileMenuOpen);
  const closeMobileMenu = () => setIsMobileMenuOpen(false);

  const isActive = (path) => {
    if (path === "/") return pathname === "/en" || pathname === "/ar";
    return pathname.includes(path);
  };

  const getCurrentLocale = () => pathname.split("/")[1] || "en";

  const switchLanguage = (langCode) => {
    const currentLocale = getCurrentLocale();
    const newPath = pathname.replace(`/${currentLocale}`, `/${langCode}`);
    router.push(newPath || `/${langCode}`);
    setIsLangOpen(false);
    setIsMobileMenuOpen(false);
  };

  const currentLang =
    LANGUAGES.find((l) => l.code === getCurrentLocale()) || LANGUAGES[0];

  const navLinks = [
    { href: "/", label: t("home") },
    { href: "/about", label: t("about") },
    { href: "/services", label: t("services") },
    { href: "/announcement", label: t("announcement") },
  ];

  return (
    <>
      <style>{`
        

        .navbar-root {
         
          position: absolute;
          top: 0;
          left: 0;
          z-index: 50;
          width: 100%;
          padding: 12px 16px;
          display: flex;
          justify-content: center;
          background: transparent;
          pointer-events: none;
          transition: all 0.3s ease;
        }

        .navbar-root.scrolled {
          position: fixed;
          background: transparent;
        }

        .navbar-pill {
          pointer-events: all;
          display: flex;
          align-items: center;
          justify-content: space-between;
          width: 100%;
          max-width: 1220px;
          padding: 0 16px 0 24px;
          height: 60px;
          border-radius: 9999px;
          border: 1px solid rgba(255,255,255,0.18);
          background: rgba(255, 255, 255, 0.68);
          backdrop-filter: blur(20px) saturate(220%);
          -webkit-backdrop-filter: blur(20px) saturate(220%);
          box-shadow:
            0 4px 24px rgba(99,102,241,0.10),
            0 1.5px 6px rgba(0,0,0,0.06),
            inset 0 1px 0 rgba(255,255,255,0.7);
          transition: box-shadow 0.3s ease, background 0.3s ease;
        }

        .dark .navbar-pill {
          background: rgba(30, 41, 59, 0.72);
          border-color: rgba(255,255,255,0.09);
          backdrop-filter: blur(24px) saturate(180%);
          -webkit-backdrop-filter: blur(24px) saturate(180%);
          box-shadow:
            0 4px 24px rgba(99,102,241,0.12),
            0 1.5px 6px rgba(0,0,0,0.3),
            inset 0 1px 0 rgba(255,255,255,0.08);
        }

        .navbar-pill.scrolled {
          box-shadow:
            0 8px 40px rgba(99,102,241,0.16),
            0 2px 10px rgba(0,0,0,0.10),
            inset 0 1px 0 rgba(255,255,255,0.7);
        }

        .navbar-logo img {
          width: 130px;
          height: auto;
          transition: transform 0.3s ease;
        }

        .navbar-logo:hover img {
          transform: scale(1.04);
        }

        .navbar-links {
          display: flex;
          align-items: center;
          gap: 4px;
        }

        .nav-link {
          position: relative;
          padding: 8px 16px;
          border-radius: 9999px;
          font-size: 14.5px;
          font-weight: 500;
          color: #374151;
          text-decoration: none;
          transition: background 0.2s ease, color 0.2s ease;
          white-space: nowrap;
        }

        .dark .nav-link {
          color: #d1d5db;
        }

        .nav-link:hover {
          background: rgba(99,102,241,0.08);
          color: #4f46e5;
        }

        .dark .nav-link:hover {
          background: rgba(99,102,241,0.15);
          color: #818cf8;
        }

        .nav-link.active {
          background: rgba(99,102,241,0.12);
          color: #4f46e5;
          font-weight: 600;
        }

        .dark .nav-link.active {
          background: rgba(99,102,241,0.20);
          color: #818cf8;
        }

        .dark .nav-link.active::after {
          background: #818cf8;
        }

        .navbar-right {
          display: flex;
          align-items: center;
          gap: 6px;
        }

        .icon-btn {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 38px;
          height: 38px;
          border-radius: 50%;
          border: none;
          background: transparent;
          color: #6b7280;
          cursor: pointer;
          transition: background 0.2s ease, color 0.2s ease, transform 0.2s ease;
        }

        .dark .icon-btn {
          color: #9ca3af;
        }

        .icon-btn:hover {
          background: rgba(99,102,241,0.10);
          color: #4f46e5;
          transform: scale(1.08);
        }

        .dark .icon-btn:hover {
          background: rgba(99,102,241,0.18);
          color: #818cf8;
        }

        .help-link {
          display: flex;
          align-items: center;
          padding: 6px 12px;
          border-radius: 9999px;
          font-size: 13px;
          font-weight: 500;
          color: #6b7280;
          text-decoration: none;
          transition: background 0.2s ease, color 0.2s ease;
        }

        .dark .help-link {
          color: #9ca3af;
        }

        .help-link:hover {
          background: rgba(99,102,241,0.08);
          color: #4f46e5;
        }

        .nav-divider {
          width: 1px;
          height: 20px;
          background: rgba(0,0,0,0.1);
          margin: 0 4px;
        }

        .dark .nav-divider {
          background: rgba(255,255,255,0.1);
        }

        .btn-login {
          padding: 7px 16px;
          border-radius: 9999px;
          font-size: 13px;
          font-weight: 600;
          color: #374151;
          text-decoration: none;
          border: 1.5px solid rgba(0,0,0,0.12);
          transition: all 0.2s ease;
          white-space: nowrap;
        }

        .dark .btn-login {
          color: #d1d5db;
          border-color: rgba(255,255,255,0.12);
        }

        .btn-login:hover {
          border-color: #4f46e5;
          color: #4f46e5;
          background: rgba(99,102,241,0.06);
        }

        .dark .btn-login:hover {
          border-color: #818cf8;
          color: #818cf8;
        }

        .btn-signup {
          padding: 7px 18px;
          border-radius: 9999px;
          font-size: 13px;
          font-weight: 600;
          color: #fff;
          text-decoration: none;
          background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
          box-shadow: 0 2px 12px rgba(99,102,241,0.35);
          transition: all 0.2s ease;
          white-space: nowrap;
          border: none;
        }

        .btn-signup:hover {
          background: linear-gradient(135deg, #4338ca 0%, #6d28d9 100%);
          box-shadow: 0 4px 18px rgba(99,102,241,0.45);
          transform: translateY(-1px) scale(1.03);
        }

        /* ── Dashboard button (logged-in state) ── */
        .btn-dashboard {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 7px 18px;
          border-radius: 9999px;
          font-size: 13px;
          font-weight: 600;
          color: #fff;
          text-decoration: none;
          background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
          box-shadow: 0 2px 12px rgba(99,102,241,0.35);
          transition: all 0.2s ease;
          white-space: nowrap;
          border: none;
        }

        .btn-dashboard:hover {
          background: linear-gradient(135deg, #4338ca 0%, #6d28d9 100%);
          box-shadow: 0 4px 18px rgba(99,102,241,0.45);
          transform: translateY(-1px) scale(1.03);
        }

        /* ── Language Dropdown ── */
        .lang-wrapper {
          position: relative;
        }

        .lang-trigger {
          display: flex;
          align-items: center;
          gap: 5px;
          height: 38px;
          padding: 0 10px 0 8px;
          border-radius: 9999px;
          border: none;
          background: transparent;
          color: #6b7280;
          cursor: pointer;
          font-size: 13px;
          font-weight: 500;
          transition: background 0.2s ease, color 0.2s ease, transform 0.2s ease;
          white-space: nowrap;
        }

        .dark .lang-trigger {
          color: #9ca3af;
        }

        .lang-trigger:hover {
          background: rgba(99,102,241,0.10);
          color: #4f46e5;
          transform: scale(1.04);
        }

        .dark .lang-trigger:hover {
          background: rgba(99,102,241,0.18);
          color: #818cf8;
        }

        .lang-trigger .lang-flag {
          font-size: 15px;
          line-height: 1;
        }

        .lang-trigger .lang-code {
          font-size: 12px;
          font-weight: 600;
          letter-spacing: 0.03em;
          text-transform: uppercase;
        }

        .lang-trigger .lang-chevron {
          transition: transform 0.22s ease;
          opacity: 0.6;
        }

        .lang-trigger.open .lang-chevron {
          transform: rotate(180deg);
        }

        .lang-dropdown {
          position: absolute;
          top: calc(100% + 10px);
          right: 0;
          min-width: 190px;
          border-radius: 18px;
          border: 1px solid rgba(255,255,255,0.22);
          background: rgba(255,255,255,0.92);
          backdrop-filter: blur(24px) saturate(200%);
          -webkit-backdrop-filter: blur(24px) saturate(200%);
          box-shadow:
            0 8px 40px rgba(99,102,241,0.14),
            0 2px 10px rgba(0,0,0,0.08);
          padding: 6px;
          animation: langDropIn 0.22s cubic-bezier(0.4,0,0.2,1);
          z-index: 100;
        }

        .dark .lang-dropdown {
          background: rgba(22, 33, 55, 0.94);
          border-color: rgba(255,255,255,0.10);
          box-shadow:
            0 8px 40px rgba(99,102,241,0.18),
            0 2px 10px rgba(0,0,0,0.35);
        }

        @keyframes langDropIn {
          from { opacity: 0; transform: translateY(-6px) scale(0.97); }
          to   { opacity: 1; transform: translateY(0)   scale(1);    }
        }

        .lang-option {
          display: flex;
          align-items: center;
          gap: 10px;
          width: 100%;
          padding: 9px 12px;
          border-radius: 12px;
          border: none;
          background: transparent;
          cursor: pointer;
          font-size: 13.5px;
          font-weight: 500;
          color: #374151;
          transition: background 0.16s ease, color 0.16s ease;
          text-align: left;
        }

        .dark .lang-option {
          color: #d1d5db;
        }

        .lang-option:hover {
          background: rgba(99,102,241,0.09);
          color: #4f46e5;
        }

        .dark .lang-option:hover {
          background: rgba(99,102,241,0.17);
          color: #818cf8;
        }

        .lang-option.selected {
          background: rgba(99,102,241,0.11);
          color: #4f46e5;
          font-weight: 600;
        }

        .dark .lang-option.selected {
          background: rgba(99,102,241,0.22);
          color: #818cf8;
        }

        .lang-option .opt-flag {
          font-size: 16px;
          line-height: 1;
          flex-shrink: 0;
        }

        .lang-option .opt-labels {
          display: flex;
          flex-direction: column;
          gap: 1px;
          flex: 1;
        }

        .lang-option .opt-native {
          font-size: 13px;
          font-weight: 600;
        }

        .lang-option .opt-english {
          font-size: 11px;
          opacity: 0.55;
          font-weight: 400;
        }

        .lang-option .opt-check {
          margin-left: auto;
          flex-shrink: 0;
          color: #4f46e5;
        }

        .dark .lang-option .opt-check {
          color: #818cf8;
        }

        /* ── Hamburger ── */
        .hamburger-btn {
          display: none;
          align-items: center;
          justify-content: center;
          width: 38px;
          height: 38px;
          border-radius: 50%;
          background: transparent;
          border: 1.5px solid rgba(0,0,0,0.10);
          color: #374151;
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .dark .hamburger-btn {
          color: #d1d5db;
          border-color: rgba(255,255,255,0.12);
        }

        .hamburger-btn:hover {
          background: rgba(99,102,241,0.08);
          border-color: #4f46e5;
          color: #4f46e5;
        }

        /* ── Mobile Drawer ── */
        .mobile-drawer {
          pointer-events: all;
          position: fixed;
          inset: 0;
          z-index: 49;
          display: flex;
          flex-direction: column;
          background: rgba(255,255,255,0.97);
          backdrop-filter: blur(24px);
          padding: 80px 24px 32px;
          animation: slideDown 0.28s cubic-bezier(0.4,0,0.2,1);
        }

        .dark .mobile-drawer {
          background: rgba(15, 23, 42, 0.97);
        }

        @keyframes slideDown {
          from { opacity: 0; transform: translateY(-12px); }
          to { opacity: 1; transform: translateY(0); }
        }

        .mobile-nav-link {
          display: block;
          padding: 14px 20px;
          border-radius: 16px;
          font-size: 18px;
          font-weight: 600;
          color: #1f2937;
          text-decoration: none;
          transition: all 0.18s ease;
        }

        .dark .mobile-nav-link {
          color: #f3f4f6;
        }

        .mobile-nav-link:hover, .mobile-nav-link.active {
          background: rgba(99,102,241,0.10);
          color: #4f46e5;
          padding-left: 28px;
        }

        .dark .mobile-nav-link:hover, .dark .mobile-nav-link.active {
          background: rgba(99,102,241,0.18);
          color: #818cf8;
        }

        .mobile-utils-row {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 10px 20px;
          border-radius: 16px;
          font-size: 15px;
          font-weight: 500;
          color: #6b7280;
          cursor: pointer;
          text-decoration: none;
          transition: all 0.18s ease;
          background: transparent;
          border: none;
          width: 100%;
        }

        .dark .mobile-utils-row {
          color: #9ca3af;
        }

        .mobile-utils-row:hover {
          background: rgba(99,102,241,0.08);
          color: #4f46e5;
        }

        .dark .mobile-utils-row:hover {
          background: rgba(99,102,241,0.15);
          color: #818cf8;
        }

        /* ── Mobile Language Chips (scrollable row) ── */
        .mobile-lang-section {
          padding: 4px 0;
        }

        .mobile-lang-header {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 0 4px 8px;
          font-size: 11px;
          font-weight: 700;
          color: #9ca3af;
          text-transform: uppercase;
          letter-spacing: 0.08em;
        }

        /* Scrollable chip row — hides native scrollbar but stays scrollable */
        .mobile-lang-chips {
          display: flex;
          gap: 8px;
          overflow-x: auto;
          padding-bottom: 4px;
          -webkit-overflow-scrolling: touch;
          scrollbar-width: none;          /* Firefox */
          -ms-overflow-style: none;       /* IE/Edge */
        }

        .mobile-lang-chips::-webkit-scrollbar {
          display: none;                  /* Chrome/Safari */
        }

        .lang-chip {
          display: inline-flex;
          align-items: center;
          gap: 6px;
          flex-shrink: 0;
          padding: 8px 14px;
          border-radius: 9999px;
          border: 1.5px solid rgba(0,0,0,0.10);
          background: transparent;
          font-size: 13px;
          font-weight: 500;
          color: #374151;
          cursor: pointer;
          transition: all 0.18s ease;
          white-space: nowrap;
        }

        .dark .lang-chip {
          color: #d1d5db;
          border-color: rgba(255,255,255,0.12);
        }

        .lang-chip:hover {
          border-color: #4f46e5;
          color: #4f46e5;
          background: rgba(99,102,241,0.07);
        }

        .dark .lang-chip:hover {
          border-color: #818cf8;
          color: #818cf8;
          background: rgba(99,102,241,0.14);
        }

        .lang-chip.selected {
          border-color: #4f46e5;
          background: rgba(99,102,241,0.12);
          color: #4f46e5;
          font-weight: 700;
        }

        .dark .lang-chip.selected {
          border-color: #818cf8;
          background: rgba(99,102,241,0.22);
          color: #818cf8;
        }

        .lang-chip .chip-flag {
          font-size: 15px;
          line-height: 1;
        }

        .mobile-separator {
          height: 1px;
          background: rgba(0,0,0,0.07);
          margin: 16px 0;
        }

        .dark .mobile-separator {
          background: rgba(255,255,255,0.07);
        }

        .mobile-auth {
          margin-top: auto;
          display: flex;
          flex-direction: column;
          gap: 10px;
        }

        .mobile-btn-login {
          display: block;
          width: 100%;
          padding: 14px;
          border-radius: 9999px;
          font-size: 15px;
          font-weight: 600;
          color: #374151;
          text-align: center;
          text-decoration: none;
          border: 2px solid rgba(0,0,0,0.12);
          transition: all 0.2s ease;
        }

        .dark .mobile-btn-login {
          color: #d1d5db;
          border-color: rgba(255,255,255,0.12);
        }

        .mobile-btn-login:hover {
          border-color: #4f46e5;
          color: #4f46e5;
        }

        .mobile-btn-signup {
          display: block;
          width: 100%;
          padding: 14px;
          border-radius: 9999px;
          font-size: 15px;
          font-weight: 600;
          color: #fff;
          text-align: center;
          text-decoration: none;
          background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
          box-shadow: 0 4px 20px rgba(99,102,241,0.35);
          transition: all 0.2s ease;
        }

        .mobile-btn-signup:hover {
          box-shadow: 0 6px 28px rgba(99,102,241,0.45);
          transform: translateY(-1px);
        }

        /* Mobile dashboard button */
        .mobile-btn-dashboard {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
          width: 100%;
          padding: 14px;
          border-radius: 9999px;
          font-size: 15px;
          font-weight: 600;
          color: #fff;
          text-align: center;
          text-decoration: none;
          background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
          box-shadow: 0 4px 20px rgba(99,102,241,0.35);
          transition: all 0.2s ease;
        }

        .mobile-btn-dashboard:hover {
          box-shadow: 0 6px 28px rgba(99,102,241,0.45);
          transform: translateY(-1px);
        }

        @media (max-width: 1023px) {
          .navbar-links,
          .help-link,
          .icon-btn,
          .lang-wrapper,
          .nav-divider,
          .btn-login,
          .btn-signup,
          .btn-dashboard,
          .desktop-only {
            display: none !important;
          }
          .hamburger-btn {
            display: flex;
          }
          .navbar-pill {
            padding: 0 12px 0 20px;
            height: 56px;
            max-width: 96%;
          }
        }

        @media (max-width: 480px) {
          .navbar-root {
            padding: 10px 10px;
          }
          .navbar-pill {
            height: 54px;
          }
        }
      `}</style>

      <nav className={`navbar-root${isScrolled ? " scrolled" : ""}`}>
        <div className={`navbar-pill${isScrolled ? " scrolled" : ""}`}>
          <Link href="/" className="navbar-logo" style={{ flexShrink: 0 }}>
            <Image
              src="/logo/logo-dark.webp"
              alt="Logo"
              width={130}
              height={40}
              className="object-contain"
              priority
              fetchPriority="high"
            />
          </Link>

          <div className="navbar-links">
            {navLinks.map(({ href, label }) => (
              <Link
                key={href}
                href={href}
                className={`nav-link${isActive(href) ? " active" : ""}`}
              >
                {label}
              </Link>
            ))}
          </div>

          <div className="navbar-right">
            <Link href="/contact" className="help-link desktop-only">
              {t("contact")}
            </Link>

            {/* ── Language Dropdown (desktop) ── */}
            <div className="lang-wrapper desktop-only" ref={langDropdownRef}>
              <button
                className={`lang-trigger${isLangOpen ? " open" : ""}`}
                onClick={() => setIsLangOpen((v) => !v)}
                aria-label="Select language"
                aria-expanded={isLangOpen}
              >
                <Globe size={16} />
                <span className="lang-code">{currentLang.code}</span>
                <ChevronDown size={13} className="lang-chevron" />
              </button>

              {isLangOpen && (
                <div className="lang-dropdown" role="menu">
                  {LANGUAGES.map((lang) => {
                    const isSelected = lang.code === currentLang.code;
                    return (
                      <button
                        key={lang.code}
                        className={`lang-option${isSelected ? " selected" : ""}`}
                        onClick={() => switchLanguage(lang.code)}
                        role="menuitem"
                      >
                        <span className="opt-flag">{lang.flag}</span>
                        <span className="opt-labels">
                          <span className="opt-native">{lang.native}</span>
                          <span className="opt-english">{lang.label}</span>
                        </span>
                        {isSelected && (
                          <Check size={13} className="opt-check" />
                        )}
                      </button>
                    );
                  })}
                </div>
              )}
            </div>

            <button
              onClick={toggleDarkMode}
              className="icon-btn desktop-only"
              aria-label="Toggle dark mode"
            >
              {isDarkMode ? <Sun size={16} /> : <Moon size={16} />}
            </button>

            <div className="nav-divider desktop-only" />

            {/* ── Auth-aware buttons (desktop) ── */}
            {isLoggedIn ? (
              <Link href="/dashboard" className="btn-dashboard desktop-only">
                <LayoutDashboard size={14} />
                {t("dashboard") ?? "Dashboard"}
              </Link>
            ) : (
              <>
                <Link href="/login" className="btn-login desktop-only">
                  {t("login")}
                </Link>
                <Link href="/register" className="btn-signup desktop-only">
                  {t("register")}
                </Link>
              </>
            )}

            <button
              onClick={toggleMobileMenu}
              className="hamburger-btn"
              aria-label="Toggle menu"
            >
              {isMobileMenuOpen ? <X size={18} /> : <Menu size={18} />}
            </button>
          </div>
        </div>
      </nav>

      {isMobileMenuOpen && (
        <div className="mobile-drawer">
          <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
            {navLinks.map(({ href, label }) => (
              <Link
                key={href}
                href={href}
                onClick={closeMobileMenu}
                className={`mobile-nav-link${isActive(href) ? " active" : ""}`}
              >
                {label}
              </Link>
            ))}
          </div>

          <div className="mobile-separator" />

          {/* ── Mobile Language Chips (horizontally scrollable) ── */}
          <div className="mobile-lang-section">
            <div className="mobile-lang-header">
              <Globe size={11} />
              {t("language")}
            </div>
            <div
              className="mobile-lang-chips"
              role="group"
              aria-label="Select language"
            >
              {LANGUAGES.map((lang) => {
                const isSelected = lang.code === getCurrentLocale();
                return (
                  <button
                    key={lang.code}
                    className={`lang-chip${isSelected ? " selected" : ""}`}
                    onClick={() => switchLanguage(lang.code)}
                    aria-pressed={isSelected}
                  >
                    <span className="chip-flag">{lang.flag}</span>
                    <span>{lang.native}</span>
                    {isSelected && (
                      <Check size={12} style={{ marginLeft: 2 }} />
                    )}
                  </button>
                );
              })}
            </div>
          </div>

          <div className="mobile-separator" />

          <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
            <button onClick={toggleDarkMode} className="mobile-utils-row">
              {isDarkMode ? (
                <>
                  <Sun size={18} style={{ color: "#f59e0b" }} />
                  {t("lightMode")}
                </>
              ) : (
                <>
                  <Moon size={18} style={{ color: "#4f46e5" }} />
                  {t("darkMode")}
                </>
              )}
            </button>
            <Link
              href="/contact"
              onClick={closeMobileMenu}
              className="mobile-utils-row"
            >
              <HelpCircle size={18} />
              {t("contact")}
            </Link>
          </div>

          {/* ── Auth-aware buttons (mobile) ── */}
          <div className="mobile-auth">
            {isLoggedIn ? (
              <Link
                href="/dashboard"
                onClick={closeMobileMenu}
                className="mobile-btn-dashboard"
              >
                <LayoutDashboard size={18} />
                {t("dashboard") ?? "Dashboard"}
              </Link>
            ) : (
              <>
                <Link
                  href="/login"
                  onClick={closeMobileMenu}
                  className="mobile-btn-login"
                >
                  {t("login")}
                </Link>
                <Link
                  href="/register"
                  onClick={closeMobileMenu}
                  className="mobile-btn-signup"
                >
                  {t("register")}
                </Link>
              </>
            )}
          </div>
        </div>
      )}
    </>
  );
}

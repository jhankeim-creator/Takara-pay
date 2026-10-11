"use client";

import { usePathname, useRouter } from "next/navigation";
import { useEffect, useMemo, useRef, useState } from "react";
import Loader from "../../components/Loader";
import Navbar from "../../components/Navbar";
import Sidebar from "../../components/Sidebar";
import { DashboardProvider } from "../../context/DashboardContext";
import { useIdleLogout } from "../../hooks/useIdleLogout";
import { getUserDashboard } from "../../utils/api";
import { checkAuthentication } from "../../utils/auth";

export default function DashboardLayoutClient({ children }) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [dashboardData, setDashboardData] = useState(null);

  const router = useRouter();
  const pathname = usePathname();

  /* This layout survives client side navigation, so a mount-only fetch would
     serve the same dashboard payload until a hard reload — leaving stale
     active_virtual_system / module_access / balances behind after an admin
     changes them. Re-running per route keeps them current; the ref marks the
     first load so later refreshes stay silent and non-destructive. */
  const hasLoadedRef = useRef(false);
  // Signature of the payload already in state, so an unchanged background
  // refresh does not push a new object and re-render the whole dashboard.
  const lastPayloadRef = useRef("");

  // Auto-logout after 15 min of inactivity when "Remember Me" was not selected.
  useIdleLogout();

  useEffect(() => {
    let cancelled = false;

    const checkAuthAndFetch = async () => {
      const isFirstLoad = !hasLoadedRef.current;

      /* =====================
         Theme Initialization
         (first load only — the toggle owns it afterwards)
      ===================== */
      if (isFirstLoad && typeof window !== "undefined") {
        if (localStorage.getItem("darkMode") === "true") {
          document.documentElement.classList.add("dark");
        } else {
          document.documentElement.classList.remove("dark");
        }
      }

      /* =====================
         Auth Token Check
      ===================== */
      if (!checkAuthentication()) {
        router.replace("/login");
        return;
      }

      /* =====================
         Get Stored User
      ===================== */
      const storedUser =
        JSON.parse(localStorage.getItem("user")) ||
        JSON.parse(sessionStorage.getItem("user"));

      if (!storedUser) {
        router.replace("/login");
        return;
      }

      /* =====================
         Get Stored Flags
      ===================== */
      const emailVerified =
        localStorage.getItem("email_verified") ||
        sessionStorage.getItem("email_verified");

      const twoFactorVerified =
        localStorage.getItem("two_factor_verified") ||
        sessionStorage.getItem("two_factor_verified");

      /* =====================
         Get 2FA Status (from user)
      ===================== */
      const twoFactorStatus = Number(storedUser.two_factor_status);

      /* =====================
         Email Check
      ===================== */
      if (emailVerified === "0") {
        router.replace("/email-verify");
        return;
      }

      /* =====================
         2FA Check (MAIN FIX)
      ===================== */
      if (twoFactorStatus === 1 && twoFactorVerified === "0") {
        router.replace("/GoogleTwoFactorAuth");
        return;
      }

      /* =====================
         Fetch Dashboard
         isLoading already starts true, so the first load needs no extra set —
         and a route change refreshes in the background without a full screen
         loader flashing over the page the user just opened.
      ===================== */
      try {
        const res = await getUserDashboard();
        if (cancelled) return;

        if (res?.data) {
          // Only commit when something actually differs. Pushing an identical
          // payload would still be a new object, re-rendering every consumer
          // on each navigation — that is the flicker.
          const signature = JSON.stringify(res.data);
          if (signature !== lastPayloadRef.current) {
            lastPayloadRef.current = signature;
            setDashboardData(res.data);
          }
          hasLoadedRef.current = true;
        } else if (isFirstLoad) {
          // Nothing usable on the very first load — the API returned an error
          // payload rather than throwing.
          setDashboardData(null);
        }
        // A failed background refresh keeps the data we already have.
      } catch (err) {
        if (cancelled) return;

        /* =====================
           Cleanup — only when there is no session to fall back on. A blip
           during a background refresh must not sign the user out.
        ===================== */
        if (isFirstLoad) {
          localStorage.clear();
          sessionStorage.clear();

          router.replace("/login");
        }
      } finally {
        if (!cancelled && isFirstLoad) setIsLoading(false);
      }
    };

    checkAuthAndFetch();
    return () => {
      cancelled = true;
    };
  }, [pathname, router]);

  /* =====================
     Context
     Memoised: without this the object is rebuilt on every layout render —
     including a sidebar open/close — and every consumer re-renders with it.
     Must sit above the early return so the hook order never changes.
  ===================== */
  const contextValue = useMemo(
    () => ({
      activeVirtualSystem: dashboardData?.active_virtual_system,
      user: dashboardData?.user,
      userWallet: dashboardData?.userWallet,
      moduleAccess: dashboardData?.module_access,
      transactions: dashboardData?.transactions,
      baseCurr: dashboardData?.base_curr,
    }),
    [dashboardData],
  );

  /* =====================
     Loader
  ===================== */
  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors duration-300">
        <Loader />
      </div>
    );
  }

  return (
    <DashboardProvider value={contextValue}>
      <div className="flex h-screen bg-gray-50 dark:bg-gray-900/60 overflow-hidden">
        <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />

        <div className="flex-1 flex flex-col overflow-hidden">
          <Navbar onMenuClick={() => setSidebarOpen(true)} />

          <main className="flex-1 overflow-y-auto p-10">{children}</main>
        </div>
      </div>
    </DashboardProvider>
  );
}

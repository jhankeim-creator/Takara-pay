"use client";

import { useRouter } from "next/navigation";
import { useEffect, useRef } from "react";

const IDLE_LIMIT_MS = 15 * 60 * 1000;

const ACTIVITY_KEY = "last_activity";
const CHECK_INTERVAL_MS = 1000;

export function useIdleLogout() {
  const router = useRouter();
  const intervalRef = useRef(null);

  useEffect(() => {
    if (typeof window === "undefined") return;

    if (localStorage.getItem("remember_me") === "true") return;

    const logout = () => {
      localStorage.clear();
      sessionStorage.clear();
      router.replace("/login");
    };

    let lastWrite = 0;
    const markActivity = () => {
      const now = Date.now();
      if (now - lastWrite >= 1000) {
        lastWrite = now;
        localStorage.setItem(ACTIVITY_KEY, String(now));
      }
    };

    const events = [
      "mousemove",
      "mousedown",
      "keydown",
      "scroll",
      "touchstart",
      "click",
    ];

    events.forEach((e) =>
      window.addEventListener(e, markActivity, { passive: true }),
    );

    localStorage.setItem(ACTIVITY_KEY, String(Date.now()));
    lastWrite = Date.now();

    intervalRef.current = setInterval(() => {
      const last = Number(localStorage.getItem(ACTIVITY_KEY)) || Date.now();
      if (Date.now() - last > IDLE_LIMIT_MS) {
        logout();
      }
    }, CHECK_INTERVAL_MS);

    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
      events.forEach((e) => window.removeEventListener(e, markActivity));
    };
  }, [router]);
}

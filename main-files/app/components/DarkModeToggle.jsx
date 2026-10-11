/* eslint-disable react-hooks/set-state-in-effect */
"use client";
import { Moon, Sun } from "lucide-react";
import { useEffect, useState } from "react";
import styles from "../styles/DarkModeToggle.css";

export default function DarkModeToggle() {
  const [isDark, setIsDark] = useState(false);
  const [isAnimating, setIsAnimating] = useState(false);

  useEffect(() => {
    const saved = localStorage.getItem("theme");
    if (saved) {
      const dark = saved === "dark";
      setIsDark(dark);
      document.documentElement.classList.toggle("dark", dark);
    } else {
      const prefersDark = window.matchMedia(
        "(prefers-color-scheme: dark)",
      ).matches;
      setIsDark(prefersDark);
      document.documentElement.classList.toggle("dark", prefersDark);
    }
  }, []);

  const toggle = () => {
    if (isAnimating) return;
    setIsAnimating(true);
    const newDark = !isDark;
    setIsDark(newDark);
    document.documentElement.classList.toggle("dark", newDark);
    localStorage.setItem("theme", newDark ? "dark" : "light");
    setTimeout(() => setIsAnimating(false), 380);
  };

  const mode = isDark ? "dark" : "light";

  return (
    <button
      className={`${styles.toggleRoot} ${styles.toggleTrack} ${styles[mode]}`}
      onClick={toggle}
      aria-label="Toggle dark mode"
      aria-pressed={isDark}
    >
      {/* Glow */}
      <div className={`${styles.toggleGlow} ${styles[mode]}`} />

      {/* Stars */}
      <div className={`${styles.particle} ${styles.star} ${styles.s1}`} />
      <div className={`${styles.particle} ${styles.star} ${styles.s2}`} />
      <div className={`${styles.particle} ${styles.star} ${styles.s3}`} />

      {/* Clouds */}
      <div className={`${styles.particle} ${styles.cloud} ${styles.c1}`} />
      <div className={`${styles.particle} ${styles.cloud} ${styles.c2}`} />

      {/* BG icons */}
      <div className={`${styles.toggleBgIcon} ${styles.sun}`}>
        <Sun
          size={13}
          color={isDark ? "#f59e0b" : "#d97706"}
          strokeWidth={2.4}
        />
      </div>
      <div className={`${styles.toggleBgIcon} ${styles.moon}`}>
        <Moon
          size={13}
          color={isDark ? "#ffffff" : "#6366f1"}
          strokeWidth={2.4}
        />
      </div>

      {/* Knob */}
      <div className={`${styles.toggleKnob} ${styles[mode]}`}>
        <span className={`${styles.knobIcon} ${styles.sun}`}>
          <Sun size={13} color="#b45309" strokeWidth={2.4} />
        </span>
        <span className={`${styles.knobIcon} ${styles.moon}`}>
          <Moon size={13} color="#ffffff" strokeWidth={2.4} />
        </span>
      </div>
    </button>
  );
}

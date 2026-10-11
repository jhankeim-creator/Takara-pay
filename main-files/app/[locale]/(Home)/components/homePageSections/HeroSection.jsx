"use client";
import Link from "next/link";
import React, { useEffect, useState } from "react";
import { useTranslations } from "next-intl";

/* ─────────────────────────────────────────────────────────────────────────
   SPOTLIGHT CONFIG
   Each entry is a blurred circular light blob.
   Positions cover: center, top-left, top-center, top-right,
   mid-left, mid-right, bottom-left, bottom-center, bottom-right.
   Two color sets: dark mode and light mode.
───────────────────────────────────────────────────────────────────────── */
const SPOTS = [
  /* ── CENTER stage — main dramatic spotlight ── */
  {
    id: "c-main",
    style: { top: "50%", left: "50%", transform: "translate(-50%, -50%)" },
    w: 950,
    h: 950,
    blur: 80,
    cDark:
      "radial-gradient(circle, rgba(34,211,238,0.32) 0%, rgba(99,102,241,0.22) 35%, rgba(168,85,247,0.12) 60%, transparent 80%)",
    cLight:
      "radial-gradient(circle, rgba(6,182,212,0.26)  0%, rgba(79,70,229,0.18)  35%, rgba(124,58,237,0.10) 60%, transparent 80%)",
    anim: "orbPulse 7s ease-in-out infinite",
  },
  /* ── CENTER — tight inner hot core ── */
  {
    id: "c-core",
    style: { top: "40%", left: "50%", transform: "translate(-50%, -50%)" },
    w: 440,
    h: 370,
    blur: 44,
    cDark:
      "radial-gradient(ellipse, rgba(99,102,241,0.40) 0%, rgba(34,211,238,0.18) 55%, transparent 75%)",
    cLight:
      "radial-gradient(ellipse, rgba(79,70,229,0.30)  0%, rgba(6,182,212,0.14)  55%, transparent 75%)",
    anim: "orbPulse 5s 0.5s ease-in-out infinite",
  },
  /* ── TOP-LEFT corner ── */
  {
    id: "tl",
    style: { top: "-8%", left: "-6%" },
    w: 400,
    h: 400,
    blur: 68,
    cDark:
      "radial-gradient(circle, rgba(34,211,238,0.34) 0%, rgba(99,102,241,0.16) 55%, transparent 75%)",
    cLight:
      "radial-gradient(circle, rgba(6,182,212,0.28)  0%, rgba(79,70,229,0.14)  55%, transparent 75%)",
    anim: "cornerBreath 7s 0s ease-in-out infinite",
  },
  /* ── TOP-CENTER ── */
  {
    id: "tc",
    style: { top: "-10%", left: "50%", transform: "translateX(-50%)" },
    w: 360,
    h: 320,
    blur: 62,
    cDark:
      "radial-gradient(ellipse, rgba(168,85,247,0.30) 0%, rgba(99,102,241,0.14) 55%, transparent 78%)",
    cLight:
      "radial-gradient(ellipse, rgba(124,58,237,0.24) 0%, rgba(79,70,229,0.12)  55%, transparent 78%)",
    anim: "cornerBreath 8s 0.6s ease-in-out infinite",
  },
  /* ── TOP-RIGHT corner ── */
  {
    id: "tr",
    style: { top: "-10%", right: "-6%" },
    w: 420,
    h: 420,
    blur: 72,
    cDark:
      "radial-gradient(circle, rgba(168,85,247,0.34) 0%, rgba(34,211,238,0.14) 55%, transparent 75%)",
    cLight:
      "radial-gradient(circle, rgba(124,58,237,0.26) 0%, rgba(6,182,212,0.12)  55%, transparent 75%)",
    anim: "cornerBreath 6.5s 1.2s ease-in-out infinite",
  },
  /* ── MID-LEFT edge ── */
  {
    id: "ml",
    style: { top: "38%", left: "-8%" },
    w: 320,
    h: 320,
    blur: 56,
    cDark:
      "radial-gradient(circle, rgba(99,102,241,0.28) 0%, rgba(168,85,247,0.12) 55%, transparent 78%)",
    cLight:
      "radial-gradient(circle, rgba(79,70,229,0.22)  0%, rgba(124,58,237,0.10) 55%, transparent 78%)",
    anim: "cornerBreath 9s 2.4s ease-in-out infinite",
  },
  /* ── MID-RIGHT edge ── */
  {
    id: "mr",
    style: { top: "33%", right: "-7%" },
    w: 300,
    h: 300,
    blur: 52,
    cDark:
      "radial-gradient(circle, rgba(34,211,238,0.26) 0%, rgba(99,102,241,0.12) 55%, transparent 78%)",
    cLight:
      "radial-gradient(circle, rgba(6,182,212,0.22)  0%, rgba(79,70,229,0.10)  55%, transparent 78%)",
    anim: "cornerBreath 7.5s 1.5s ease-in-out infinite",
  },
  /* ── BOTTOM-LEFT ── */
  {
    id: "bl",
    style: { bottom: "-10%", left: "-5%" },
    w: 380,
    h: 380,
    blur: 66,
    cDark:
      "radial-gradient(circle, rgba(168,85,247,0.28) 0%, rgba(34,211,238,0.12) 55%, transparent 75%)",
    cLight:
      "radial-gradient(circle, rgba(124,58,237,0.22) 0%, rgba(6,182,212,0.10)  55%, transparent 75%)",
    anim: "cornerBreath 8.5s 1.8s ease-in-out infinite",
  },
  /* ── BOTTOM-CENTER ── */
  {
    id: "bc",
    style: { bottom: "-8%", left: "50%", transform: "translateX(-50%)" },
    w: 340,
    h: 280,
    blur: 58,
    cDark:
      "radial-gradient(ellipse, rgba(99,102,241,0.26) 0%, rgba(34,211,238,0.10) 55%, transparent 78%)",
    cLight:
      "radial-gradient(ellipse, rgba(79,70,229,0.20)  0%, rgba(6,182,212,0.08)  55%, transparent 78%)",
    anim: "cornerBreath 7s 0.9s ease-in-out infinite",
  },
  /* ── BOTTOM-RIGHT ── */
  {
    id: "br",
    style: { bottom: "-9%", right: "-6%" },
    w: 390,
    h: 390,
    blur: 70,
    cDark:
      "radial-gradient(circle, rgba(34,211,238,0.28) 0%, rgba(168,85,247,0.12) 55%, transparent 75%)",
    cLight:
      "radial-gradient(circle, rgba(6,182,212,0.22)  0%, rgba(124,58,237,0.10)  55%, transparent 75%)",
    anim: "cornerBreath 7.8s 0.3s ease-in-out infinite",
  },
];

/* ─────────────────────────────────────────────────────────────────────────
   ORGANIC BLOB CONFIG
───────────────────────────────────────────────────────────────────────── */
const BLOBS = [
  {
    id: "blob-tr",
    style: { top: "-5%", right: "-8%" },
    w: 520,
    h: 480,
    borderRadius: "62% 38% 70% 30% / 42% 58% 42% 58%",
    blur: 72,
    cDark:
      "linear-gradient(135deg, rgba(99,102,241,0.28) 0%, rgba(168,85,247,0.18) 50%, rgba(34,211,238,0.10) 100%)",
    cLight:
      "linear-gradient(135deg, rgba(79,70,229,0.20) 0%, rgba(124,58,237,0.14) 50%, rgba(6,182,212,0.08) 100%)",
    anim: "cornerBreath 9s 0.4s ease-in-out infinite",
  },
  {
    id: "blob-bl",
    style: { bottom: "-6%", left: "-10%" },
    w: 560,
    h: 480,
    borderRadius: "38% 62% 30% 70% / 58% 42% 58% 42%",
    blur: 80,
    cDark:
      "linear-gradient(135deg, rgba(34,211,238,0.22) 0%, rgba(99,102,241,0.16) 55%, rgba(168,85,247,0.08) 100%)",
    cLight:
      "linear-gradient(135deg, rgba(6,182,212,0.18) 0%, rgba(79,70,229,0.12) 55%, rgba(124,58,237,0.06) 100%)",
    anim: "cornerBreath 11s 1.2s ease-in-out infinite",
  },
  {
    id: "blob-mr",
    style: { top: "30%", right: "-5%" },
    w: 320,
    h: 360,
    borderRadius: "72% 28% 56% 44% / 50% 66% 34% 50%",
    blur: 60,
    cDark:
      "linear-gradient(160deg, rgba(168,85,247,0.24) 0%, rgba(99,102,241,0.12) 100%)",
    cLight:
      "linear-gradient(160deg, rgba(124,58,237,0.18) 0%, rgba(79,70,229,0.10) 100%)",
    anim: "orbPulse 8s 2s ease-in-out infinite",
  },
  {
    id: "blob-ml",
    style: { top: "25%", left: "-6%" },
    w: 300,
    h: 340,
    borderRadius: "28% 72% 44% 56% / 66% 34% 66% 34%",
    blur: 58,
    cDark:
      "linear-gradient(200deg, rgba(34,211,238,0.22) 0%, rgba(99,102,241,0.12) 100%)",
    cLight:
      "linear-gradient(200deg, rgba(6,182,212,0.18) 0%, rgba(79,70,229,0.10) 100%)",
    anim: "orbPulse 10s 0.8s ease-in-out infinite",
  },
  {
    id: "blob-cb",
    style: { bottom: "0%", left: "50%", transform: "translateX(-50%)" },
    w: 480,
    h: 220,
    borderRadius: "50% 50% 38% 62% / 60% 60% 40% 40%",
    blur: 64,
    cDark:
      "linear-gradient(180deg, rgba(99,102,241,0.18) 0%, rgba(168,85,247,0.10) 100%)",
    cLight:
      "linear-gradient(180deg, rgba(79,70,229,0.14) 0%, rgba(124,58,237,0.08) 100%)",
    anim: "cornerBreath 8s 3s ease-in-out infinite",
  },
];

/* ─────────────────────────────────────────────────────────────────────────
   DECORATIVE DOTS & CIRCLES CONFIG
   Small floating dots and hollow circles scattered around the content.
───────────────────────────────────────────────────────────────────────── */
const DOTS = [
  /* Solid dots */
  // { id: "d1", top: "12%",  left: "8%",   size: 4,  opacity: 0.55, anim: "dotFloat 6s 0s ease-in-out infinite",   filled: true  },
  // { id: "d2", top: "22%",  left: "14%",  size: 3,  opacity: 0.40, anim: "dotFloat 7s 1s ease-in-out infinite",   filled: true  },
  // { id: "d3", top: "18%",  right: "10%", size: 5,  opacity: 0.50, anim: "dotFloat 5s 0.5s ease-in-out infinite", filled: true  },
  // { id: "d4", top: "35%",  right: "7%",  size: 3,  opacity: 0.35, anim: "dotFloat 8s 2s ease-in-out infinite",   filled: true  },
  // { id: "d5", top: "62%",  left: "6%",   size: 4,  opacity: 0.45, anim: "dotFloat 6.5s 1.5s ease-in-out infinite", filled: true },
  // { id: "d6", top: "72%",  right: "9%",  size: 3,  opacity: 0.40, anim: "dotFloat 7.5s 0.8s ease-in-out infinite", filled: true },
  // { id: "d7", top: "80%",  left: "18%",  size: 5,  opacity: 0.30, anim: "dotFloat 9s 2.5s ease-in-out infinite",  filled: true  },
  // { id: "d8", top: "55%",  right: "15%", size: 4,  opacity: 0.35, anim: "dotFloat 6s 3s ease-in-out infinite",    filled: true  },
  // { id: "d9", top: "8%",   left: "32%",  size: 3,  opacity: 0.45, anim: "dotFloat 5.5s 1.2s ease-in-out infinite", filled: true },
  // { id: "d10",top: "6%",   right: "28%", size: 4,  opacity: 0.35, anim: "dotFloat 8s 0.3s ease-in-out infinite",  filled: true  },
  // { id: "d11",top: "88%",  left: "42%",  size: 3,  opacity: 0.30, anim: "dotFloat 7s 1.8s ease-in-out infinite",  filled: true  },
  // { id: "d12",top: "45%",  left: "4%",   size: 6,  opacity: 0.25, anim: "dotFloat 10s 0.6s ease-in-out infinite", filled: true  },
  /* Hollow circles */
  {
    id: "c1",
    top: "15%",
    left: "18%",
    size: 18,
    opacity: 0.22,
    anim: "dotFloat 8s 0.4s ease-in-out infinite",
    filled: false,
  },
  {
    id: "c2",
    top: "25%",
    right: "18%",
    size: 24,
    opacity: 0.18,
    anim: "dotFloat 10s 1.6s ease-in-out infinite",
    filled: false,
  },
  {
    id: "c3",
    top: "60%",
    left: "12%",
    size: 14,
    opacity: 0.25,
    anim: "dotFloat 7s 2.2s ease-in-out infinite",
    filled: false,
  },
  {
    id: "c4",
    top: "70%",
    right: "14%",
    size: 20,
    opacity: 0.2,
    anim: "dotFloat 9s 0.9s ease-in-out infinite",
    filled: false,
  },
  {
    id: "c5",
    top: "5%",
    left: "45%",
    size: 12,
    opacity: 0.28,
    anim: "dotFloat 6s 1.1s ease-in-out infinite",
    filled: false,
  },
  {
    id: "c6",
    top: "85%",
    right: "22%",
    size: 16,
    opacity: 0.22,
    anim: "dotFloat 11s 1.4s ease-in-out infinite",
    filled: false,
  },
  {
    id: "c7",
    top: "42%",
    right: "3%",
    size: 10,
    opacity: 0.3,
    anim: "dotFloat 7.5s 3.1s ease-in-out infinite",
    filled: false,
  },
  {
    id: "c8",
    top: "78%",
    left: "5%",
    size: 22,
    opacity: 0.16,
    anim: "dotFloat 12s 0.7s ease-in-out infinite",
    filled: false,
  },
];

/* ─── EMV Chip ────────────────────────────────────────────────────────── */
function ChipIcon({ dark }) {
  const c1 = dark ? "#a78bfa" : "#7c3aed";
  const c2 = dark ? "#c4b5fd" : "#a78bfa";
  const c3 = dark ? "#7c3aed" : "#5b21b6";
  return (
    <svg width="40" height="30" viewBox="0 0 40 30" fill="none">
      <rect
        x="1"
        y="1"
        width="38"
        height="28"
        rx="5"
        fill={c3}
        stroke={c2}
        strokeWidth="0.6"
      />
      <rect x="7" y="7" width="26" height="16" rx="2.5" fill={c1} />
      {[14, 20, 26].map((x) => (
        <React.Fragment key={x}>
          <line x1={x} y1="1" x2={x} y2="7" stroke={c2} strokeWidth="1.1" />
          <line x1={x} y1="23" x2={x} y2="29" stroke={c2} strokeWidth="1.1" />
        </React.Fragment>
      ))}
      {[10, 15, 20].map((y) => (
        <React.Fragment key={y}>
          <line x1="1" y1={y} x2="7" y2={y} stroke={c2} strokeWidth="1.1" />
          <line x1="33" y1={y} x2="39" y2={y} stroke={c2} strokeWidth="1.1" />
        </React.Fragment>
      ))}
      <rect x="11" y="10" width="18" height="10" rx="2" fill={c3} />
      {[15, 20, 25].map((x) => (
        <line
          key={x}
          x1={x}
          y1="10"
          x2={x}
          y2="20"
          stroke={c1}
          strokeWidth="0.6"
        />
      ))}
    </svg>
  );
}

/* ─── NFC Wave icon ───────────────────────────────────────────────────── */
function NFCIcon({ dark }) {
  const stroke = dark ? "rgba(196,181,253,0.65)" : "rgba(124,58,237,0.55)";
  return (
    <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
      {[9, 6, 3].map((r, i) => (
        <path
          key={i}
          d={`M ${11 - r * 0.7} ${11 - r * 0.5} A ${r} ${r} 0 0 1 ${11 + r * 0.7} ${11 + r * 0.5}`}
          stroke={stroke}
          strokeWidth="1.5"
          strokeLinecap="round"
          fill="none"
          opacity={1 - i * 0.28}
        />
      ))}
    </svg>
  );
}

/* ─── Enhanced Virtual Card ───────────────────────────────────────────── */
function VirtualCard({ dark }) {
  const [hovered, setHovered] = useState(false);

  const cardBg = dark
    ? "linear-gradient(140deg, #0d0b22 0%, #16124a 45%, #120e38 75%, #090717 100%)"
    : "linear-gradient(140deg, #1e1b4b 0%, #2e2a6e 45%, #3730a3 75%, #1e1b4b 100%)";

  const glowSpread = dark ? "rgba(99,102,241,0.30)" : "rgba(79,70,229,0.35)";
  const borderC = hovered
    ? dark
      ? "rgba(196,181,253,0.48)"
      : "rgba(165,180,252,0.58)"
    : dark
      ? "rgba(139,92,246,0.24)"
      : "rgba(99,102,241,0.30)";

  const numC = dark ? "rgba(224,231,255,0.85)" : "rgba(238,242,255,0.92)";
  const labelC = dark ? "rgba(167,139,250,0.50)" : "rgba(196,181,253,0.65)";
  const nameC = dark ? "rgba(224,231,255,0.80)" : "rgba(238,242,255,0.90)";

  return (
    <div
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        position: "relative",
        width: 340,
        height: 215,
        borderRadius: 20,
        backgroundImage: cardBg,
        border: `1px solid ${borderC}`,
        boxShadow: hovered
          ? `0 0 72px ${glowSpread}, 0 32px 80px rgba(0,0,0,0.55), inset 0 1px 0 rgba(196,181,253,0.16)`
          : `0 0 36px ${glowSpread}, 0 20px 50px rgba(0,0,0,0.42), inset 0 1px 0 rgba(196,181,253,0.09)`,
        transition: "all 0.52s cubic-bezier(0.23,1,0.32,1)",
        transform: hovered
          ? "translateY(-7px) scale(1.014)"
          : "translateY(0) scale(1)",
        cursor: "pointer",
        overflow: "hidden",
      }}
    >
      {/* Holographic sheen */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          pointerEvents: "none",
          borderRadius: 20,
          backgroundImage:
            "linear-gradient(118deg, transparent 22%, rgba(139,92,246,0.07) 44%, rgba(196,181,253,0.11) 50%, rgba(99,102,241,0.05) 56%, transparent 74%)",
          opacity: hovered ? 1 : 0.42,
          transition: "opacity 0.45s ease",
        }}
      />

      {/* Top edge shimmer */}
      <div
        style={{
          position: "absolute",
          top: 0,
          left: 0,
          right: 0,
          height: 1,
          pointerEvents: "none",
          backgroundImage:
            "linear-gradient(90deg, transparent 8%, rgba(196,181,253,0.42) 33%, rgba(224,231,255,0.58) 50%, rgba(196,181,253,0.42) 67%, transparent 92%)",
          borderRadius: "20px 20px 0 0",
        }}
      />

      {/* Hover sweep */}
      <div
        style={{
          position: "absolute",
          top: "-40%",
          left: "-15%",
          width: "55%",
          height: "220%",
          backgroundImage:
            "linear-gradient(108deg, transparent, rgba(196,181,253,0.055) 50%, transparent)",
          transform: hovered ? "translateX(210%)" : "translateX(0%)",
          transition: "transform 0.78s ease",
          pointerEvents: "none",
        }}
      />

      {/* Card body */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          padding: "20px 22px",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
        }}
      >
        {/* Row 1 — brand + NFC */}
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "flex-start",
          }}
        >
          <div>
            <p
              style={{
                fontSize: 11,
                fontWeight: 700,
                letterSpacing: "0.18em",
                textTransform: "uppercase",
                color: nameC,
                fontFamily: "var(--font-dm-mono)",
                margin: 0,
                marginBottom: 2,
              }}
            >
              TAKARA PAY PRO
            </p>
            <p
              style={{
                fontSize: 9,
                letterSpacing: "0.14em",
                textTransform: "uppercase",
                color: labelC,
                margin: 0,
              }}
            >
              Virtual Card
            </p>
          </div>
          <NFCIcon dark={dark} />
        </div>

        {/* Row 2 — Chip */}
        <div>
          <ChipIcon dark={dark} />
        </div>

        {/* Row 3 — Number */}
        <p
          style={{
            fontSize: 13.5,
            letterSpacing: "0.24em",
            color: numC,
            fontFamily: "var(--font-dm-mono)",
            margin: 0,
          }}
        >
          5312 •••• •••• 7842
        </p>

        {/* Row 4 — Holder / Valid / CVV / VISA */}
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "flex-end",
          }}
        >
          <div>
            <p
              style={{
                fontSize: 8,
                textTransform: "uppercase",
                letterSpacing: "0.13em",
                color: labelC,
                margin: "0 0 3px",
              }}
            >
              Card Holder
            </p>
            <p
              style={{
                fontSize: 11,
                textTransform: "uppercase",
                letterSpacing: "0.1em",
                color: nameC,
                margin: 0,
              }}
            >
              Alex Morgan
            </p>
          </div>
          <div style={{ textAlign: "center" }}>
            <p
              style={{
                fontSize: 8,
                textTransform: "uppercase",
                letterSpacing: "0.13em",
                color: labelC,
                margin: "0 0 3px",
              }}
            >
              Valid
            </p>
            <p
              style={{
                fontSize: 11,
                color: numC,
                fontFamily: "var(--font-dm-mono)",
                margin: 0,
              }}
            >
              11/30
            </p>
          </div>
          <div style={{ textAlign: "center" }}>
            <p
              style={{
                fontSize: 8,
                textTransform: "uppercase",
                letterSpacing: "0.13em",
                color: labelC,
                margin: "0 0 3px",
              }}
            >
              CVV
            </p>
            <p
              style={{
                fontSize: 11,
                color: numC,
                fontFamily: "var(--font-dm-mono)",
                margin: 0,
              }}
            >
              •••
            </p>
          </div>
          <div
            style={{
              padding: "4px 10px",
              borderRadius: 5,
              backgroundImage: dark
                ? "linear-gradient(135deg,rgba(139,92,246,0.22),rgba(99,102,241,0.12))"
                : "linear-gradient(135deg,rgba(99,102,241,0.22),rgba(79,70,229,0.12))",
              border: `1px solid ${dark ? "rgba(196,181,253,0.24)" : "rgba(165,180,252,0.30)"}`,
            }}
          >
            <p
              style={{
                fontSize: 13,
                fontWeight: 800,
                letterSpacing: "0.06em",
                color: nameC,
                fontFamily: "var(--font-dm-mono)",
                margin: 0,
              }}
            >
              VISA
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

/* ─── Main HeroSection ────────────────────────────────────────────────── */
function HeroSection() {
  const t = useTranslations("Hero");
  const [dark, setDark] = useState(true);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    const check = () =>
      setDark(document.documentElement.classList.contains("dark"));
    check();
    const obs = new MutationObserver(check);
    obs.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class"],
    });
    return () => obs.disconnect();
  }, []);

  useEffect(() => {
    const t = setTimeout(() => setMounted(true), 60);
    return () => clearTimeout(t);
  }, []);

  /* ── Theme tokens ── */
  const bg = dark ? "#070A12" : "#f0f0ff";
  const textCol = dark ? "white" : "#0f0a2e";
  const subCol = dark ? "#9ca3af" : "#4B5563";
  const badgeBg = dark ? "rgba(255,255,255,0.05)" : "rgba(99,102,241,0.07)";
  const badgeBdr = dark ? "rgba(255,255,255,0.10)" : "rgba(99,102,241,0.22)";
  const badgeTxt = dark ? "#d1d5db" : "#3730a3";

  const gradTitleImg = dark
    ? "linear-gradient(90deg, #22d3ee 0%, #6366f1 50%, #a855f7 100%)"
    : "linear-gradient(90deg, #0891b2 0%, #4f46e5 50%, #7c3aed 100%)";

  /* Buttons */
  const btnPrimBg = dark ? "white" : "#1e1b4b";
  const btnPrimTxt = dark ? "#070A12" : "white";
  const btnPrimHov = dark ? "#e5e7eb" : "#312e81";
  const btnOutBdr = dark ? "rgba(255,255,255,0.20)" : "rgba(99,102,241,0.35)";
  const btnOutHov = dark ? "rgba(255,255,255,0.55)" : "rgba(99,102,241,0.75)";
  const btnOutTxt = dark ? "white" : "#1e1b4b";

  /* Staggered fade-in helper */
  const fade = (delay) => ({
    opacity: mounted ? 1 : 0,
    transform: mounted ? "translateY(0)" : "translateY(20px)",
    transition: `opacity 0.75s ease ${delay}s, transform 0.75s ease ${delay}s`,
  });

  return (
    <section
      style={{
        position: "relative",
        minHeight: "100svh",
        paddingTop: "50px",
        backgroundColor: bg,
        color: textCol,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        overflow: "hidden",
        transition: "background-color 0.45s ease, color 0.45s ease",
      }}
    >
      {/* Fonts + Keyframes */}
      <style>{`
        @keyframes heroFloat {
          0%, 100% { transform: translateY(0px); }
          50%       { transform: translateY(-13px); }
        }
        @keyframes floatA {
          0%, 100% { transform: translateY(0px); }
          50%       { transform: translateY(-12px); }
        }
        @keyframes floatB {
          0%, 100% { transform: translateY(0px); }
          50%       { transform: translateY(14px); }
        }
        @keyframes livePulse {
          0%       { transform: scale(1);   opacity: 0.7; }
          100%     { transform: scale(2.2); opacity: 0; }
        }
        @keyframes cardGlowPulse {
          0%, 100% { opacity: 0.55; transform: translateX(-50%) scale(1); }
          50%       { opacity: 0.75; transform: translateX(-50%) scale(1.06); }
        }
        @keyframes orbPulse {
          0%, 100% { opacity: 1;    transform: scale(1); }
          50%       { opacity: 0.72; transform: scale(1.08); }
        }
        @keyframes cornerBreath {
          0%, 100% { opacity: 0.85; transform: scale(1); }
          50%       { opacity: 0.55; transform: scale(0.94); }
        }
        @keyframes dotFloat {
          0%, 100% { transform: translateY(0px); }
          50%       { transform: translateY(-8px); }
        }
        @media (max-width: 380px) {
          .virtual-card-scale {
            transform: scale(0.85);
            transform-origin: top center;
          }
        }
      `}</style>

      {/* ══════════════════════════════════════════════════════════
          SPOTLIGHT LAYER
      ══════════════════════════════════════════════════════════ */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          pointerEvents: "none",
          zIndex: 0,
          overflow: "hidden",
        }}
        aria-hidden="true"
      >
        {SPOTS.map((s) => (
          <div
            key={s.id}
            style={{
              position: "absolute",
              width: s.w,
              height: s.h,
              backgroundImage: dark ? s.cDark : s.cLight,
              filter: `blur(${s.blur}px)`,
              animation: s.anim,
              ...s.style,
            }}
          />
        ))}
      </div>

      {/* ══════════════════════════════════════════════════════════
          ORGANIC BLOB LAYER
      ══════════════════════════════════════════════════════════ */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          pointerEvents: "none",
          zIndex: 0,
          overflow: "hidden",
        }}
        aria-hidden="true"
      >
        {BLOBS.map((b) => (
          <div
            key={b.id}
            style={{
              position: "absolute",
              width: b.w,
              height: b.h,
              backgroundImage: dark ? b.cDark : b.cLight,
              borderRadius: b.borderRadius,
              filter: `blur(${b.blur}px)`,
              animation: b.anim,
              ...b.style,
            }}
          />
        ))}
      </div>

      {/* ══════════════════════════════════════════════════════════
          DECORATIVE DOTS & CIRCLES LAYER
      ══════════════════════════════════════════════════════════ */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          pointerEvents: "none",
          zIndex: 2,
          overflow: "hidden",
        }}
        aria-hidden="true"
      >
        {DOTS.map((d) => {
          const dotColor = dark
            ? `rgba(${d.filled ? "139,92,246" : "99,102,241"}, ${d.opacity})`
            : `rgba(${d.filled ? "99,102,241" : "79,70,229"}, ${d.opacity})`;
          const pos = {};
          if (d.top) pos.top = d.top;
          if (d.left) pos.left = d.left;
          if (d.right) pos.right = d.right;
          if (d.bottom) pos.bottom = d.bottom;
          return (
            <div
              key={d.id}
              style={{
                position: "absolute",
                width: d.size,
                height: d.size,
                borderRadius: "50%",
                backgroundColor: d.filled ? dotColor : "transparent",
                border: d.filled ? "none" : `1.5px solid ${dotColor}`,
                animation: d.anim,
                ...pos,
              }}
            />
          );
        })}
      </div>

      {/* Floating Info Cards - Moved CLOSER to content */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          pointerEvents: "none",
          zIndex: 5,
        }}
        aria-hidden="true"
      >
        {/* Card 1 — Secure */}
        <div
          className="hidden lg:flex absolute top-24 lg:top-50 -left-1 sm:-left-4 lg:left-80 items-center gap-2.5 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md rounded-2xl shadow-[0_8px_32px_rgb(0_0_0/0.08)] dark:shadow-[0_8px_32px_rgb(0_0_0/0.4)] border border-slate-100/80 dark:border-slate-700 px-4 py-3 z-20 transition-all"
          style={{ animation: "floatA 4s ease-in-out infinite" }}
        >
          <div className="size-9 rounded-xl bg-emerald-500/10 flex items-center justify-center flex-shrink-0">
            <span style={{ fontSize: "18px" }}>🛡️</span>
          </div>
          <div>
            <div className="text-[12px] font-bold text-slate-800 dark:text-slate-100">
              {t("secureTitle")}
            </div>
            <div className="text-[10px] text-slate-500 dark:text-slate-400">
              {t("sslProtected")}
            </div>
          </div>
        </div>

        {/* Card 2 — Instant */}
        <div
          className="hidden lg:flex absolute right-12 sm:right-16 lg:right-[450px] bottom-32 sm:bottom-[35%] items-center gap-2.5 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md rounded-2xl shadow-[0_8px_32px_rgb(0_0_0/0.08)] dark:shadow-[0_8px_32px_rgb(0_0_0/0.4)] border border-slate-100/80 dark:border-slate-700 px-4 py-3 z-20 transition-all"
          style={{ animation: "floatB 4.5s ease-in-out infinite" }}
        >
          <div className="size-9 rounded-xl bg-blue-500/10 flex items-center justify-center flex-shrink-0">
            <span style={{ fontSize: "18px" }}>⚡</span>
          </div>
          <div>
            <div className="text-[12px] font-bold text-slate-800 dark:text-slate-100">
              {t("instant")}
            </div>
            <div className="text-[10px] text-slate-500 dark:text-slate-400">
              {t("activation")}
            </div>
          </div>
        </div>

        {/* Card 3 — Top Rated */}
        <div
          className="hidden lg:flex absolute left-16 sm:left-[23%] bottom-16 lg:bottom-96 items-center gap-2.5 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md rounded-2xl shadow-[0_8px_32px_rgb(0_0_0/0.08)] dark:shadow-[0_8px_32px_rgb(0_0_0/0.4)] border border-slate-100/80 dark:border-slate-700 px-4 py-3 z-20 transition-all"
          style={{ animation: "floatA 5s 0.6s ease-in-out infinite" }}
        >
          <div className="size-9 rounded-xl bg-amber-500/10 flex items-center justify-center flex-shrink-0">
            <span style={{ fontSize: "18px" }}>⭐</span>
          </div>
          <div>
            <div className="text-[12px] font-bold text-slate-800 dark:text-slate-100">
              {t("topRated")}
            </div>
            <div className="text-[10px] text-slate-500 dark:text-slate-400">
              {t("topRatedStars")}
            </div>
          </div>
        </div>

        {/* Card 4 — Growth */}
        <div
          className="hidden lg:flex absolute -right-1 sm:-right-3 lg:right-55 top-20 sm:top-24 lg:top-50 items-center gap-2.5 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md rounded-2xl shadow-[0_8px_32px_rgb(0_0_0/0.08)] dark:shadow-[0_8px_32px_rgb(0_0_0/0.4)] border border-slate-100/80 dark:border-slate-700 px-4 py-3 z-20 transition-all"
          style={{ animation: "floatB 3.8s 0.3s ease-in-out infinite" }}
        >
          <div className="size-9 rounded-xl bg-violet-500/10 flex items-center justify-center flex-shrink-0">
            <span style={{ fontSize: "18px" }}>📈</span>
          </div>
          <div>
            <div className="text-[12px] font-bold text-slate-800 dark:text-slate-100">
              {t("growth")}
            </div>
            <div className="text-[10px] text-slate-500 dark:text-slate-400">
              {t("monthlyUsersShort")}
            </div>
          </div>
        </div>
      </div>

      {/* GRID FLOOR */}
      <div
        style={{
          position: "absolute",
          bottom: 0,
          left: 0,
          right: 0,
          height: "50%",
          opacity: dark ? 0.09 : 0.05,
          backgroundImage: `
            linear-gradient(to right, #ffffff18 1px, transparent 1px),
            linear-gradient(to top,   #ffffff18 1px, transparent 1px)
          `,
          backgroundSize: "60px 60px",
          pointerEvents: "none",
          zIndex: 1,
        }}
      />

      {/* CONTENT */}
      <div
        style={{
          position: "relative",
          zIndex: 10,
          textAlign: "center",
          maxWidth: 896,
          padding: "80px 24px",
        }}
      >
        {/* Badge */}
        <div
          style={{
            ...fade(0.1),
            display: "inline-flex",
            alignItems: "center",
            gap: 8,
            padding: "7px 16px",
            borderRadius: 999,
            border: `1px solid ${badgeBdr}`,
            backgroundColor: badgeBg,
            fontSize: 11,
            letterSpacing: "0.14em",
            color: badgeTxt,
            marginBottom: 32,
            fontFamily: "var(--font-dm-mono)",
          }}
        >
          <span
            style={{
              position: "relative",
              display: "inline-flex",
              alignItems: "center",
              width: 8,
              height: 8,
            }}
          >
            <span
              style={{
                position: "absolute",
                inset: 0,
                borderRadius: "50%",
                backgroundColor: "#4ade80",
                animation: "livePulse 2s ease-out infinite",
              }}
            />
            <span
              style={{
                width: 8,
                height: 8,
                borderRadius: "50%",
                backgroundColor: "#4ade80",
                display: "block",
              }}
            />
          </span>
          {t("liveBadge")}
        </div>

        {/* Headline */}
        <div style={fade(0.25)}>
          <h1 style={{ fontWeight: 600, lineHeight: 1.05, margin: 0 }}>
            <span
              style={{
                display: "block",
                fontSize: "clamp(2.75rem, 8.5vw, 5.8rem)",
                color: textCol,
                letterSpacing: "-0.03em",
              }}
            >
              {t("heading1")}
            </span>

            <span
              style={{
                display: "block",
                fontSize: "clamp(2.75rem, 8.5vw, 5.8rem)",
                letterSpacing: "-0.03em",
                backgroundImage: gradTitleImg,
                WebkitBackgroundClip: "text",
                WebkitTextFillColor: "transparent",
                backgroundClip: "text",
                color: "transparent",
              }}
            >
              {t("heading2")}
            </span>

            <span
              style={{
                display: "block",
                fontSize: "clamp(2.75rem, 8.5vw, 5.8rem)",
                color: textCol,
                letterSpacing: "-0.03em",
                marginTop: "-8px",
              }}
            >
              {t("heading3")}
            </span>
          </h1>
        </div>

        {/* Subtitle */}
        <p
          style={{
            ...fade(0.45),
            marginTop: 28,
            color: subCol,
            fontSize: "clamp(1rem, 2vw, 1.15rem)",
            maxWidth: 560,
            margin: "28px auto 0",
            lineHeight: 1.75,
            fontWeight: 300,
          }}
        >
          {t("description")}
        </p>

        {/* CTA buttons */}
        <div
          style={{
            ...fade(0.62),
            marginTop: 48,
            display: "flex",
            flexWrap: "wrap",
            alignItems: "center",
            justifyContent: "center",
            gap: 14,
          }}
        >
          <Link href="/dashboard" style={{ textDecoration: "none" }}>
            <button
              style={{
                padding: "13px 32px",
                borderRadius: 999,
                border: "none",
                cursor: "pointer",
                backgroundColor: btnPrimBg,
                color: btnPrimTxt,
                fontWeight: 600,
                fontSize: 14.5,
                transition: "all 0.25s ease",
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.backgroundColor = btnPrimHov;
                e.currentTarget.style.transform = "translateY(-2px)";
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.backgroundColor = btnPrimBg;
                e.currentTarget.style.transform = "translateY(0)";
              }}
            >
              {t("cta")}
            </button>
          </Link>
        </div>

        {/* Floating Virtual Card */}
        <div
          style={{
            ...fade(0.78),
            marginTop: 64,
            position: "relative",
            display: "flex",
            justifyContent: "center",
          }}
        >
          <div
            style={{
              position: "absolute",
              width: 400,
              height: 240,
              backgroundImage: `linear-gradient(135deg, rgba(34,211,238,0.22), rgba(168,85,247,0.22))`,
              filter: "blur(56px)",
              borderRadius: 36,
              top: "8%",
              left: "50%",
              transform: "translateX(-50%)",
              animation: "cardGlowPulse 5.5s ease-in-out infinite",
              pointerEvents: "none",
            }}
          />

          <div
            className="virtual-card-scale"
            style={{ animation: "heroFloat 6.5s ease-in-out infinite" }}
          >
            <VirtualCard dark={dark} />
          </div>
        </div>
      </div>
    </section>
  );
}

export default HeroSection;

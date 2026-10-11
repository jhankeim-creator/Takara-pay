/* eslint-disable @next/next/no-img-element */
"use client";

import { useTranslations } from "next-intl";

function Card({ step, delay }) {
  return (
    <div className="hiw-card hiw-fade" style={{ animationDelay: `${delay}ms` }}>
      <div
        className="hiw-card-bg"
        style={{
          background: `linear-gradient(135deg, ${step.color1}08, ${step.color2}10)`,
        }}
      />
      <div
        className="hiw-card-topbar"
        style={{
          background: `linear-gradient(90deg, ${step.color1}, ${step.color2})`,
        }}
      />
      <div
        className="hiw-icon"
        style={{
          background: `linear-gradient(135deg, ${step.color1}1a, ${step.color2}28)`,
          border: `1px solid ${step.color1}28`,
        }}
      >
        <img src={step.image} alt={step.title} loading="lazy" />
      </div>
      <div>
        <span
          className="hiw-tag"
          style={{ color: step.color1, background: `${step.color1}18` }}
        >
          {step.tag}
        </span>
        <h3 className="hiw-title">{step.title}</h3>
        <p className="hiw-desc">{step.description}</p>
      </div>
    </div>
  );
}

function HowItWorks() {
  const t = useTranslations("HowItWorks");

  const steps = [
  {
    id: 1,
    image: "/icons/HowItWorksSections/create-your-account.webp",
    title: t("steps.0.title"),
    description: t("steps.0.description"),
    color1: "#10b981", // Emerald 500
    color2: "#3b82f6", // Blue 500
    tag: t("steps.0.tag"),
  },
  {
    id: 2,
    image: "/icons/HowItWorksSections/loading-funds.webp",
    title: t("steps.1.title"),
    description: t("steps.1.description"),
    color1: "#3b82f6", // Blue 500
    color2: "#6366f1", // Indigo 500
    tag: t("steps.1.tag"),
  },
  {
    id: 3,
    image: "/icons/HowItWorksSections/buy-a-virtual-card.webp",
    title: t("steps.2.title"),
    description: t("steps.2.description"),
    color1: "#6366f1", // Indigo 500
    color2: "#8b5cf6", // Violet 500
    tag: t("steps.2.tag"),
  },
  {
    id: 4,
    image: "/icons/HowItWorksSections/manage-your-virtual-card.webp",
    title: t("steps.3.title"),
    description: t("steps.3.description"),
    color1: "#8b5cf6", // Violet 500
    color2: "#d946ef", // Fuchsia 500
    tag: t("steps.3.tag"),
  },
  {
    id: 5,
    image: "/icons/HowItWorksSections/make-transactions.webp",
    title: t("steps.4.title"),
    description: t("steps.4.description"),
    color1: "#f43f5e", // Rose 500
    color2: "#fb923c", // Orange 400
    tag: t("steps.4.tag"),
  },
  {
    id: 6,
    image: "/icons/HowItWorksSections/stay-secure.webp",
    title: t("steps.5.title"),
    description: t("steps.5.description"),
    color1: "#f59e0b", // Amber 500
    color2: "#10b981", // Emerald 500
    tag: t("steps.5.tag"),
  },
  {
    id: 7,
    image: "/icons/HowItWorksSections/access-support.webp",
    title: t("steps.6.title"),
    description: t("steps.6.description"),
    color1: "#06b6d4", // Cyan 500
    color2: "#3b82f6", // Blue 500
    tag: t("steps.6.tag"),
  },
  {
    id: 8,
    image: "/icons/HowItWorksSections/enjoy-global-flexibility.webp",
    title: t("steps.7.title"),
    description: t("steps.7.description"),
    color1: "#6366f1", // Indigo 500
    color2: "#0ea5e9", // Sky 500
    tag: t("steps.7.tag"),
  },
];

  const ArrowRight = () => (
    <div className="hiw-arrow">
      <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
        <path
          d="M3 9h12M11 5l4 4-4 4"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </svg>
    </div>
  );

  const ArrowLeft = () => (
    <div className="hiw-arrow">
      <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
        <path
          d="M15 9H3M7 5L3 9l4 4"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </svg>
    </div>
  );

  return (
    <section className="hiw-root relative w-full py-20 md:py-28 overflow-hidden">
      <style>{`
        .hiw-root {
          background: #f8faff;
        }
        .dark .hiw-root { background: #060a14; }

        .hiw-root::before {
          content: '';
          position: absolute;
          inset: 0;
          background-image:
            linear-gradient(rgba(99,102,241,0.055) 1px, transparent 1px),
            linear-gradient(90deg, rgba(99,102,241,0.055) 1px, transparent 1px);
          background-size: 52px 52px;
          mask-image: radial-gradient(ellipse 90% 80% at 50% 50%, black 20%, transparent 100%);
          pointer-events: none;
        }
        .dark .hiw-root::before {
          background-image:
            linear-gradient(rgba(99,102,241,0.09) 1px, transparent 1px),
            linear-gradient(90deg, rgba(99,102,241,0.09) 1px, transparent 1px);
        }

        .hiw-blob {
          position: absolute; border-radius: 50%;
          pointer-events: none; filter: blur(90px);
        }

        /* Badge */
        .hiw-badge {
          display: inline-flex; align-items: center; gap: 9px;
          padding: 7px 18px 7px 9px; border-radius: 100px;
          background: white; border: 1px solid rgba(99,102,241,0.2);
          box-shadow: 0 2px 16px rgba(99,102,241,0.1);
        }
        .dark .hiw-badge { background: rgba(13,18,40,0.9); border-color: rgba(99,102,241,0.3); }
        .hiw-badge-icon {
          width: 30px; height: 30px; border-radius: 50%;
          background: linear-gradient(135deg, #3b82f6, #6366f1, #8b5cf6);
          display: flex; align-items: center; justify-content: center; font-size: 13px;
        }
        .hiw-badge-text {
          font-size: 11px; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase;
          background: linear-gradient(90deg, #3b82f6, #6366f1, #8b5cf6);
          -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        /* Card */
        .hiw-card {
          background: white;
          border-radius: 20px;
          border: 1px solid rgba(226,232,240,0.9);
          padding: 24px 20px 20px;
          display: flex; flex-direction: column; gap: 14px;
          box-shadow: 0 2px 16px rgba(0,0,0,0.04);
          transition: all 0.32s cubic-bezier(0.4,0,0.2,1);
          position: relative; overflow: hidden; cursor: default;
          flex: 1;
        }
        .dark .hiw-card {
          background: rgba(11,17,35,0.85);
          border-color: rgba(99,102,241,0.12);
          box-shadow: 0 2px 24px rgba(0,0,0,0.3);
        }
        .hiw-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 20px 50px rgba(99,102,241,0.13);
          border-color: rgba(99,102,241,0.22);
        }
        .dark .hiw-card:hover {
          box-shadow: 0 20px 50px rgba(99,102,241,0.22);
          border-color: rgba(99,102,241,0.3);
        }
        .hiw-card-bg {
          position: absolute; inset: 0; opacity: 0;
          transition: opacity 0.32s ease; pointer-events: none;
        }
        .hiw-card:hover .hiw-card-bg { opacity: 1; }
        .hiw-card-topbar {
          position: absolute; top: 0; left: 0; right: 0; height: 3px;
          border-radius: 20px 20px 0 0;
          transform: scaleX(0); transform-origin: left;
          transition: transform 0.38s ease;
        }
        .hiw-card:hover .hiw-card-topbar { transform: scaleX(1); }

        /* Icon */
        .hiw-icon {
          width: 52px; height: 52px; border-radius: 14px;
          display: flex; align-items: center; justify-content: center;
          flex-shrink: 0; transition: transform 0.32s ease; position: relative;
        }
        .hiw-card:hover .hiw-icon { transform: scale(1.1) rotate(-4deg); }
        .hiw-icon img {
          width: 28px; height: 28px; object-fit: contain;
          filter: drop-shadow(0 2px 4px rgba(0,0,0,0.12));
          position: relative; z-index: 1;
        }

        .hiw-tag {
          display: inline-block; font-size: 9px; font-weight: 800;
          letter-spacing: 0.1em; text-transform: uppercase;
          padding: 3px 9px; border-radius: 100px; margin-bottom: 5px;
        }
        .hiw-title {
          font-size: 15px; font-weight: 800; color: #0f172a;
          margin: 0 0 6px; line-height: 1.3; letter-spacing: -0.01em;
        }
        .dark .hiw-title { color: #f1f5f9; }
        .hiw-desc { font-size: 13px; color: #64748b; line-height: 1.65; margin: 0; }
        .dark .hiw-desc { color: #94a3b8; }

        /* Arrow connector */
        .hiw-arrow {
          display: none;
        }
        @media (min-width: 1024px) {
          .hiw-arrow {
            display: flex; align-items: center; justify-content: center;
            width: 32px; flex-shrink: 0; align-self: center;
            color: #cbd5e1; margin-top: -10px;
          }
          .dark .hiw-arrow { color: #1e293b; }
        }

        /* Snake row */
        .hiw-row {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 14px;
        }
        @media (min-width: 1024px) {
          .hiw-row {
            display: flex; align-items: stretch; gap: 0;
          }
        }

        /* Bend connector between rows */
        .hiw-bend {
          display: none;
        }
        @media (min-width: 1024px) {
          .hiw-bend {
            display: flex; align-items: center;
            justify-content: flex-end;
            padding-right: 16px; margin: 4px 0;
            color: #e2e8f0; gap: 6px;
          }
          .dark .hiw-bend { color: #1e293b; }
          .hiw-bend span {
            font-size: 10px; font-weight: 600; letter-spacing: 0.06em;
            color: #cbd5e1; text-transform: uppercase;
          }
          .dark .hiw-bend span { color: #1e293b; }
        }

        /* Fade */
        .hiw-fade { animation: hiw-up 0.5s ease both; }
        @keyframes hiw-up {
          from { opacity: 0; transform: translateY(16px); }
          to { opacity: 1; transform: translateY(0); }
        }

        /* Divider */
        .hiw-div { display: flex; align-items: center; gap: 6px; justify-content: center; }
        .hiw-div-line { height: 2px; border-radius: 2px; background: linear-gradient(90deg, #3b82f6, #8b5cf6); }
        .hiw-div-dot { width: 5px; height: 5px; border-radius: 50%; background: #6366f1; }

        /* ── Dark-mode fix: heading that has inline color overriding dark class ── */
        .hiw-heading {
          color: #0f172a;
        }
        .dark .hiw-heading {
          color: #f8fafc;
        }
      `}</style>

      <div
        className="hiw-blob"
        style={{
          width: 500,
          height: 500,
          top: -80,
          right: -80,
          background:
            "radial-gradient(circle, rgba(99,102,241,0.1) 0%, transparent 65%)",
        }}
      />
      <div
        className="hiw-blob"
        style={{
          width: 400,
          height: 400,
          bottom: -60,
          left: -80,
          background:
            "radial-gradient(circle, rgba(59,130,246,0.09) 0%, transparent 65%)",
        }}
      />

      <div className="relative max-w-7xl mx-auto px-6 sm:px-8 lg:px-12">
        {/* Header */}
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            gap: 16,
            textAlign: "center",
            marginBottom: 52,
          }}
        >
          <div className="animate-[--animate-fade-up]">
                <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/85 backdrop-blur-xl border border-indigo-500/15 shadow-[0_2px_16px_rgb(99_102_241/0.12)] text-sm font-semibold text-indigo-700 dark:bg-slate-900/80 dark:border-indigo-400/20 dark:text-indigo-300">
                  <span className="size-1.5 rounded-full bg-indigo-600 dark:bg-indigo-400 animate-[--animate-pulse-dot]" />

                  {t("badge")}
                </span>
          </div>

          {/* FIX: removed inline color, use .hiw-heading CSS class instead */}
          <h2
            className="hiw-heading"
            style={{
              fontSize: "clamp(28px, 4.5vw, 50px)",
              fontWeight: 900,
              lineHeight: 1.1,
              letterSpacing: "-0.025em",
              margin: 0,
            }}
          >
            {t("title.main")}
            <br />
            <span
              style={{
                background:
                  "linear-gradient(135deg, #3b82f6 0%, #6366f1 45%, #8b5cf6 100%)",
                WebkitBackgroundClip: "text",
                WebkitTextFillColor: "transparent",
              }}
            >
              {t("title.highlight")}
            </span>
          </h2>

          <div className="hiw-div">
            <div className="hiw-div-line" style={{ width: 28 }} />
            <div className="hiw-div-dot" />
            <div className="hiw-div-line" style={{ width: 48 }} />
            <div className="hiw-div-dot" />
            <div className="hiw-div-line" style={{ width: 28 }} />
          </div>

          <p
            className="dark:text-slate-400"
            style={{
              fontSize: 16,
              color: "#64748b",
              lineHeight: 1.75,
              maxWidth: 640,
              margin: 0,
            }}
          >
            {t("description")}
          </p>
        </div>

        {/* Row 1: steps 1–4 → left to right */}
        <div className="hiw-row">
          {steps
            .slice(0, 4)
            .map((step, i) => [
              <Card key={step.id} step={step} delay={i * 70} />,
              i < 3 ? <ArrowRight key={`arrow-${step.id}`} /> : null,
            ])}
        </div>

        {/* Bend connector */}
        <div className="hiw-bend">
          <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
            <path
              d="M24 6 Q24 22 8 22 L6 22"
              stroke="currentColor"
              strokeWidth="1.6"
              strokeLinecap="round"
              fill="none"
            />
            <path
              d="M10 18l-4 4 4 4"
              stroke="currentColor"
              strokeWidth="1.6"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
          <span>{t("continueLabel")}</span>
        </div>

        {/* Row 2: steps 5–8 → right to left */}
        <div className="hiw-row" style={{ marginTop: 14 }}>
          {steps.slice(4, 8).map((step, i) => (
            <div
              key={step.id}
              className="hiw-row-item"
              style={{ display: "flex", alignItems: "stretch", gap: 0 }}
            >
              {i > 0 && <ArrowLeft />}
              <Card step={step} delay={(i + 4) * 70} />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

export default HowItWorks;
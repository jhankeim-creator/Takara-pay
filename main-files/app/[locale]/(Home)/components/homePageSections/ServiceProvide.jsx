/* eslint-disable @next/next/no-img-element */
"use client";

import { useTranslations } from "next-intl";
import Link from "next/link";

// icons ────────────────────────────────────
const ServiceIcons = [
  // 1 — Buy Virtual Card
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/buy-virtual-card.webp"
      alt="Buy Virtual Card"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 2 — Add Money
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/add-money.webp"
      alt="Add Money"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 3 — Global Transfer
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/money-transfer.webp"
      alt="Global Money Transfer"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 4 — Withdraw Money
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/withdraw-money.webp"
      alt="Withdraw Money"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 5 — Virtual Card Top-up
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/virtual-card-topup.webp"
      alt="Virtual Card Top-up"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 6 — Gift Card
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/giftcard.webp"
      alt="Gift Card"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 7 — Virtual Card API
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/setup-virtual-card-api.webp"
      alt="Virtual Card API Setup"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 8 — Biometric Login
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/biometric-login.webp"
      alt="Biometric Login"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 9 — Transaction Logs
  ({ size = 28 }) => (
    <img
      src="/icons/ServicesSectionAssets/transaction-logs.webp"
      alt="Transaction Logs"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),

  // 10 — Multi-language Support
  ({ size = 32 }) => (
    <img
      src="/icons/ServicesSectionAssets/multi-language.webp"
      alt="Multi-language Support"
      width={size}
      height={size}
      style={{ width: size, height: size, objectFit: "contain" }}
    />
  ),
];


// ─────────────────────────────────────────────────────────────────────────────

function ServiceProvide() {
  const t = useTranslations("ServiceProvide");

  const accents = [
    "#3B82F6",
    "#6366F1",
    "#8B5CF6",
    "#F59E0B",
    "#06B6D4",
    "#A855F7",
    "#EC4899",
    "#3B82F6",
    "#8B5CF6",
    "#06B6D4",
  ];

  const services = Array.from({ length: 10 }, (_, index) => ({
    id: index + 1,
    Icon: ServiceIcons[index],
    accent: accents[index],
    tag: t(`items.${index}.tag`),
    title: t(`items.${index}.title`),
    description: t(`items.${index}.description`),
  }));

  const mainServices = services.slice(0, 8);
  const lastServices = services.slice(8);

  return (
    <section className="relative w-full py-24 overflow-hidden bg-[#f8f9ff] dark:bg-[#080c18]">
      <style>{`
        .sp-card {
          position: relative;
          background: rgba(255,255,255,0.85);
          backdrop-filter: blur(12px);
          border: 1px solid rgba(255,255,255,0.9);
          border-radius: 20px;
          padding: 28px 24px;
          display: flex;
          align-items: flex-start;
          gap: 18px;
          transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
          overflow: hidden;
          cursor: default;
        }

        .dark .sp-card {
          background: rgba(15, 20, 40, 0.75);
          border-color: rgba(99, 102, 241, 0.12);
        }

        .sp-card::before {
          content: '';
          position: absolute;
          inset: 0;
          border-radius: 20px;
          opacity: 0;
          transition: opacity 0.35s ease;
          background: linear-gradient(135deg, rgba(59,130,246,0.06), rgba(139,92,246,0.06));
        }

        .sp-card:hover::before {
          opacity: 1;
        }

        .sp-card:hover {
          transform: translateY(-4px);
          box-shadow: 0 20px 60px -12px rgba(99, 102, 241, 0.18), 0 0 0 1px rgba(99, 102, 241, 0.15);
          border-color: rgba(99, 102, 241, 0.25);
        }

        .dark .sp-card:hover {
          box-shadow: 0 20px 60px -12px rgba(99, 102, 241, 0.3), 0 0 0 1px rgba(99, 102, 241, 0.3);
          border-color: rgba(99, 102, 241, 0.4);
        }

        .sp-icon-wrap {
          flex-shrink: 0;
          width: 56px;
          height: 56px;
          border-radius: 14px;
          display: flex;
          align-items: center;
          justify-content: center;
          position: relative;
          transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sp-card:hover .sp-icon-wrap {
          transform: scale(1.08) rotate(-3deg);
        }

        .sp-tag {
          display: inline-block;
          font-size: 10px;
          font-weight: 700;
          letter-spacing: 0.08em;
          text-transform: uppercase;
          padding: 3px 9px;
          border-radius: 20px;
          margin-bottom: 6px;
        }

        .sp-title {
          font-size: 15px;
          font-weight: 700;
          color: #0f172a;
          margin: 0 0 6px 0;
          line-height: 1.3;
          transition: color 0.2s ease;
        }

        .dark .sp-title {
          color: #f1f5f9;
        }

        .sp-desc {
          font-size: 13px;
          color: #64748b;
          line-height: 1.6;
          margin: 0;
        }

        .dark .sp-desc {
          color: #94a3b8;
        }

        .sp-number {
          position: absolute;
          bottom: 16px;
          right: 18px;
          font-size: 42px;
          font-weight: 800;
          line-height: 1;
          opacity: 0.04;
          color: #6366f1;
          pointer-events: none;
          transition: opacity 0.35s ease;
        }

        .sp-card:hover .sp-number {
          opacity: 0.08;
        }

        .sp-line-accent {
          width: 3px;
          height: 100%;
          border-radius: 2px;
          position: absolute;
          left: 0;
          top: 0;
          opacity: 0;
          transition: opacity 0.35s ease;
        }
        .sp-card:hover .sp-line-accent {
          opacity: 1;
        }

        .sp-badge {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          padding: 8px 20px;
          border-radius: 100px;
          background: rgba(255,255,255,0.9);
          border: 1px solid rgba(99,102,241,0.2);
          box-shadow: 0 4px 20px rgba(99,102,241,0.12);
          backdrop-filter: blur(8px);
        }

        .dark .sp-badge {
          background: rgba(15,20,40,0.8);
          border-color: rgba(99,102,241,0.25);
        }

        .sp-dot {
          width: 8px;
          height: 8px;
          border-radius: 50%;
          background: linear-gradient(135deg, #3b82f6, #8b5cf6);
          animation: sp-pulse 2s ease-in-out infinite;
        }

        @keyframes sp-pulse {
          0%, 100% { opacity: 1; transform: scale(1); }
          50% { opacity: 0.6; transform: scale(0.85); }
        }

        .sp-fade-in {
          animation: sp-fade-up 0.5s ease both;
        }

        @keyframes sp-fade-up {
          from { opacity: 0; transform: translateY(16px); }
          to { opacity: 1; transform: translateY(0); }
        }

        .sp-blob {
          position: absolute;
          border-radius: 50%;
          filter: blur(80px);
          pointer-events: none;
        }

        .sp-heading {
          color: #0f172a;
        }
        .dark .sp-heading {
          color: #f8fafc;
        }

        .sp-cta-title {
          color: #0f172a;
        }
        .dark .sp-cta-title {
          color: #f1f5f9;
        }
      `}</style>

      {/* Background blobs */}
      <div
        className="sp-blob"
        style={{
          width: 500,
          height: 500,
          top: -100,
          right: -100,
          background:
            "radial-gradient(circle, rgba(99,102,241,0.12) 0%, transparent 70%)",
        }}
      />
      <div
        className="sp-blob"
        style={{
          width: 400,
          height: 400,
          bottom: -80,
          left: -80,
          background:
            "radial-gradient(circle, rgba(59,130,246,0.1) 0%, transparent 70%)",
        }}
      />
      <div
        className="sp-blob"
        style={{
          width: 300,
          height: 300,
          top: "40%",
          left: "45%",
          background:
            "radial-gradient(circle, rgba(139,92,246,0.07) 0%, transparent 70%)",
        }}
      />

      <div className="sp-section relative max-w-7xl mx-auto px-6 sm:px-8 lg:px-12">
        {/* Header */}
        <div
          className="flex flex-col items-center text-center mb-16"
          style={{ gap: 20 }}
        >
          <div className="animate-[--animate-fade-up]">
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/85 backdrop-blur-xl border border-indigo-500/15 shadow-[0_2px_16px_rgb(99_102_241/0.12)] text-sm font-semibold text-indigo-700 dark:bg-slate-900/80 dark:border-indigo-400/20 dark:text-indigo-300">
              <span className="size-1.5 rounded-full bg-indigo-600 dark:bg-indigo-400 animate-[--animate-pulse-dot]" />

              {t("badge")}
            </div>
          </div>

          <h2
            className="sp-heading"
            style={{
              fontSize: "clamp(28px, 4vw, 48px)",
              fontWeight: 800,
              lineHeight: 1.15,
              margin: 0,
              maxWidth: 640,
            }}
          >
            {t("title")}{" "}
            <span
              style={{
                background:
                  "linear-gradient(135deg, #3b82f6 0%, #6366f1 50%, #8b5cf6 100%)",
                WebkitBackgroundClip: "text",
                WebkitTextFillColor: "transparent",
              }}
            >
              {t("gradientPart")}
            </span>
          </h2>

          <p
            style={{
              fontSize: 16,
              color: "#64748b",
              lineHeight: 1.7,
              maxWidth: 580,
              margin: 0,
            }}
            className="dark:text-slate-400"
          >
            {t("description")}
          </p>

          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 8,
              marginTop: 4,
            }}
          >
            <div
              style={{
                width: 24,
                height: 2,
                borderRadius: 2,
                background: "linear-gradient(90deg, transparent, #6366f1)",
              }}
            />
            <div
              style={{
                width: 6,
                height: 6,
                borderRadius: "50%",
                background: "#6366f1",
              }}
            />
            <div
              style={{
                width: 40,
                height: 2,
                borderRadius: 2,
                background: "linear-gradient(90deg, #6366f1, #8b5cf6)",
              }}
            />
            <div
              style={{
                width: 6,
                height: 6,
                borderRadius: "50%",
                background: "#8b5cf6",
              }}
            />
            <div
              style={{
                width: 24,
                height: 2,
                borderRadius: 2,
                background: "linear-gradient(90deg, #8b5cf6, transparent)",
              }}
            />
          </div>
        </div>

        {/* Main 8 cards */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))",
            gap: 16,
          }}
        >
          {mainServices.map((service, index) => {
            const Icon = service.Icon;
            return (
              <div
                key={service.id}
                className="sp-card sp-fade-in"
                style={{ animationDelay: `${index * 60}ms` }}
              >
                <div
                  className="sp-line-accent"
                  style={{
                    background: `linear-gradient(180deg, ${service.accent}, transparent)`,
                  }}
                />
                <div
                  className="sp-icon-wrap"
                  style={{
                    background: `linear-gradient(135deg, ${service.accent}18, ${service.accent}30)`,
                    border: `1px solid ${service.accent}25`,
                  }}
                >
                  <Icon size={28} />
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <span
                    className="sp-tag"
                    style={{
                      color: service.accent,
                      background: `${service.accent}15`,
                    }}
                  >
                    {service.tag}
                  </span>
                  <h3 className="sp-title">{service.title}</h3>
                  <p className="sp-desc">{service.description}</p>
                </div>
                <span className="sp-number">
                  {String(service.id).padStart(2, "0")}
                </span>
              </div>
            );
          })}
        </div>

        {/* Last 2 cards — centered at same column width */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4 mx-auto w-full lg:max-w-[66.66%]">
          {lastServices.map((service, index) => {
            const Icon = service.Icon;
            return (
              <div
                key={service.id}
                className="sp-card sp-fade-in"
                style={{ animationDelay: `${(8 + index) * 60}ms` }}
              >
                <div
                  className="sp-line-accent"
                  style={{
                    background: `linear-gradient(180deg, ${service.accent}, transparent)`,
                  }}
                />
                <div
                  className="sp-icon-wrap"
                  style={{
                    background: `linear-gradient(135deg, ${service.accent}18, ${service.accent}30)`,
                    border: `1px solid ${service.accent}25`,
                  }}
                >
                  <Icon size={28} />
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <span
                    className="sp-tag"
                    style={{
                      color: service.accent,
                      background: `${service.accent}15`,
                    }}
                  >
                    {service.tag}
                  </span>
                  <h3 className="sp-title">{service.title}</h3>
                  <p className="sp-desc">{service.description}</p>
                </div>
                <span className="sp-number">
                  {String(service.id).padStart(2, "0")}
                </span>
              </div>
            );
          })}
        </div>

        {/* CTA stripe */}
        <div
          className="dark:border-indigo-500/20"
          style={{
            marginTop: 48,
            borderRadius: 20,
            padding: "28px 36px",
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            flexWrap: "wrap",
            gap: 16,
            background:
              "linear-gradient(135deg, rgba(59,130,246,0.08) 0%, rgba(139,92,246,0.08) 100%)",
            border: "1px solid rgba(99,102,241,0.15)",
          }}
        >
          <div>
            <p
              className="sp-cta-title sp-section"
              style={{ margin: 0, fontSize: 18, fontWeight: 700 }}
            >
              {t("cta.ready")}
            </p>
            <p
              style={{ margin: "4px 0 0", fontSize: 14, color: "#64748b" }}
              className="dark:text-slate-400 sp-section"
            >
              {t("cta.join")}
            </p>
          </div>

          <Link href="/services" style={{ textDecoration: "none" }}>
            <button
              style={{
                padding: "12px 28px",
                borderRadius: 12,
                border: "none",
                cursor: "pointer",
                fontSize: 14,
                fontWeight: 700,
                fontFamily: "inherit",
                background:
                  "linear-gradient(135deg, #3b82f6 0%, #6366f1 50%, #8b5cf6 100%)",
                color: "#fff",
                letterSpacing: "0.01em",
                boxShadow: "0 8px 24px rgba(99,102,241,0.35)",
                transition: "transform 0.2s ease, box-shadow 0.2s ease",
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.transform = "translateY(-2px)";
                e.currentTarget.style.boxShadow =
                  "0 12px 32px rgba(99,102,241,0.45)";
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.transform = "translateY(0)";
                e.currentTarget.style.boxShadow =
                  "0 8px 24px rgba(99,102,241,0.35)";
              }}
            >
              {t("cta.button")}
            </button>
          </Link>
        </div>
      </div>
    </section>
  );
}

export default ServiceProvide;

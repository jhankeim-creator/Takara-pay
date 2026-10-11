/* eslint-disable @next/next/no-img-element */
"use client";

import {
  ArrowDownCircle,
  CreditCard,
  Gift,
  Home,
  Lock,
  PlusCircle,
  Receipt,
  Send,
  ShieldCheck,
  UserCircle,
  X,
} from "lucide-react";
import { useTranslations } from "next-intl";
import Link from "next/link";
import { usePathname } from "../../i18n/navigation";

const navigationGroups = [
  {
    titleKey: "main.title",
    items: [{ icon: Home, labelKey: "main.dashboard", href: "/dashboard" }],
  },
  {
    titleKey: "moneyManagement.title",
    items: [
      {
        icon: PlusCircle,
        labelKey: "moneyManagement.addMoney",
        href: "/dashboard/add-money",
      },
      {
        icon: Send,
        labelKey: "moneyManagement.transferMoney",
        href: "/dashboard/transfer-money",
      },
      {
        icon: ArrowDownCircle,
        labelKey: "moneyManagement.withdrawMoney",
        href: "/dashboard/withdraw-money",
      },
    ],
  },
  {
    titleKey: "services.title",
    items: [
      {
        icon: CreditCard,
        labelKey: "services.virtualCard",
        href: "/dashboard/Virtual-Card",
      },
      {
        icon: Gift,
        labelKey: "services.giftCard",
        href: "/dashboard/gift-card",
      },
      {
        icon: Receipt,
        labelKey: "services.transactions",
        href: "/dashboard/transactions",
      },
    ],
  },
  {
    titleKey: "account.title",
    items: [
      {
        icon: UserCircle,
        labelKey: "account.profile",
        href: "/dashboard/profile",
      },
      { icon: ShieldCheck, labelKey: "account.kyc", href: "/dashboard/kyc" },
      { icon: Lock, labelKey: "account.twoFactor", href: "/dashboard/2fa" },
      // {
      //   icon: HeadphonesIcon,
      //   labelKey: "account.support",  // skip for now, as we don't have a support page API yet
      //   href: "/dashboard/support",
      // },
    ],
  },
];

export default function Sidebar({ isOpen, onClose }) {
  const t = useTranslations("Sidebar");
  const pathname = usePathname();

  const isActive = (href) => pathname === href;

  return (
    <>
      <style jsx>{`
        .gradient-text {
          background: linear-gradient(
            76.84deg,
            #3b82f6 -2.66%,
            #2563eb 105.87%
          );
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }

        .gradient-icon {
          background: linear-gradient(
            76.84deg,
            #3b82f6 -2.66%,
            #2563eb 105.87%
          );
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
          display: inline-flex;
        }

        .gradient-icon svg {
          stroke: #3b82f6;
          stroke-width: 2;
        }
      `}</style>

      {/* Overlay for mobile */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black/30 dark:bg-black/50 z-40 lg:hidden"
          onClick={onClose}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed lg:static inset-y-0 left-0 z-50 w-64 overflow-y-auto transition-transform duration-300 ease-in-out lg:translate-x-0 ${
          isOpen ? "translate-x-0" : "-translate-x-full"
        } bg-white dark:bg-gray-900`}
      >
        {/* Logo */}
        <div className="p-6 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link href="/">
              <img
                src="/logo/logo-dark.webp"
                alt="logo"
                fetchPriority="high"
                loading="eager"
                className="w-40 h-10 rounded-lg object-contain cursor-pointer"
              />
            </Link>
          </div>

          {/* Close button for mobile */}
          <button
            onClick={onClose}
            className="lg:hidden p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            aria-label={t("closeMenu")}
          >
            <X size={20} className="text-gray-600 dark:text-gray-400" />
          </button>
        </div>

        {/* Navigation */}
        <nav className="p-4">
          {navigationGroups.map((group, groupIndex) => (
            <div
              key={group.titleKey}
              className={groupIndex < navigationGroups.length - 1 ? "mb-6" : ""}
            >
              {group.titleKey !== "main.title" && (
                <h3 className="px-3 mb-2 text-xs font-semibold text-gray-500 uppercase">
                  {t(group.titleKey)}
                </h3>
              )}
              <div className="space-y-1">
                {group.items.map((item) => {
                  const Icon = item.icon;
                  const active = isActive(item.href);
                  return (
                    <Link
                      key={item.href}
                      href={item.href}
                      onClick={onClose}
                      className={`flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors ${
                        active
                          ? "bg-primary-50 dark:bg-gray-800"
                          : "text-black dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800"
                      }`}
                    >
                      <span className={active ? "gradient-icon" : ""}>
                        <Icon
                          size={20}
                          className={
                            active ? "" : "text-gray-600 dark:text-gray-400"
                          }
                          strokeWidth={2}
                        />
                      </span>
                      <span
                        className={`text-sm font-medium ${
                          active ? "gradient-text" : ""
                        }`}
                      >
                        {t(item.labelKey)}
                      </span>
                    </Link>
                  );
                })}
              </div>
            </div>
          ))}
        </nav>
      </aside>
    </>
  );
}

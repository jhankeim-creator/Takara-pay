"use client";

import {
  ArrowUpRight,
  CreditCard,
  Eye,
  EyeOff,
  Gift,
  Plus,
  Send,
  Ticket,
} from "lucide-react";
import { useTranslations } from "next-intl";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { getUserDashboard, getUserGiftCards } from "../../utils/api";
import WalletBalanceSkeleton from "./WalletBalanceSkeleton";

// ============================================================================
// COLOR CONFIGURATION (now with dark mode variants)
// ============================================================================
const COLOR_MAP = {
  "bg-blue-500": {
    base: "rgba(59, 130, 246, 0.15)",
    hover: "rgba(59, 130, 246, 0.30)",
    shadow: "rgba(59, 130, 246, 0.5)",
    darkBase: "rgba(59, 130, 246, 0.20)",
    darkHover: "rgba(59, 130, 246, 0.40)",
  },
  "bg-purple-500": {
    base: "rgba(168, 85, 247, 0.15)",
    hover: "rgba(168, 85, 247, 0.30)",
    shadow: "rgba(168, 85, 247, 0.5)",
    darkBase: "rgba(168, 85, 247, 0.20)",
    darkHover: "rgba(168, 85, 247, 0.40)",
  },
  "bg-cyan-500": {
    base: "rgba(6, 182, 212, 0.15)",
    hover: "rgba(6, 182, 212, 0.30)",
    shadow: "rgba(6, 182, 212, 0.5)",
    darkBase: "rgba(6, 182, 212, 0.20)",
    darkHover: "rgba(6, 182, 212, 0.40)",
  },
  "bg-green-500": {
    base: "rgba(34, 197, 94, 0.15)",
    hover: "rgba(34, 197, 94, 0.30)",
    shadow: "rgba(34, 197, 94, 0.5)",
    darkBase: "rgba(34, 197, 94, 0.20)",
    darkHover: "rgba(34, 197, 94, 0.40)",
  },
  "bg-pink-500": {
    base: "rgba(236, 72, 153, 0.15)",
    hover: "rgba(236, 72, 153, 0.30)",
    shadow: "rgba(236, 72, 153, 0.5)",
    darkBase: "rgba(236, 72, 153, 0.20)",
    darkHover: "rgba(236, 72, 153, 0.40)",
  },
  "bg-indigo-500": {
    base: "rgba(99, 102, 241, 0.15)",
    hover: "rgba(99, 102, 241, 0.30)",
    shadow: "rgba(99, 102, 241, 0.5)",
    darkBase: "rgba(99, 102, 241, 0.20)",
    darkHover: "rgba(99, 102, 241, 0.40)",
  },
};

// ============================================================================
// MAIN COMPONENT
// ============================================================================
export default function WalletBalanceSection() {
  const router = useRouter();
  const t = useTranslations("WalletBalanceSection");

  const [showBalance, setShowBalance] = useState(true);
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [giftCardCount, setGiftCardCount] = useState(0);

  useEffect(() => {
    async function fetchData() {
      try {
        const [dashRes, giftRes] = await Promise.all([
          getUserDashboard(),
          getUserGiftCards(),
        ]);
        if (dashRes?.data) {
          setData(dashRes.data);
        }
        if (giftRes?.data?.gift_cards) {
          setGiftCardCount(giftRes.data.gift_cards.length);
        }
      } catch (err) {
        // Error handled by API utility
      } finally {
        setLoading(false);
      }
    }

    fetchData();
  }, []);

  const extractNumber = (str) => {
    if (!str) return 0;
    const match = str.match(/[\d.]+/);
    return match ? parseFloat(match[0]) : 0;
  };

  if (loading) {
    return <WalletBalanceSkeleton />;
  }

  const wallet = data?.userWallet?.[0] || {};
  const currencySymbol = wallet?.currency?.symbol || "$";
  const currentBalance = Number(wallet?.balance || 0).toFixed(4);

  const totalAddMoneyNum = extractNumber(data?.totalAddMoney);
  const totalTransactionsNum = extractNumber(data?.totalTransactions);
  const activeCardsCount = Number(data?.active_cards || 0);
  const activeTicketsCount = Number(data?.active_tickets || 0); // Placeholder, replace with actual count if available


  const cards = [
    {
      icon: null,
      symbol: currencySymbol,
      name: t("currentBalance"),
      amount: `${currencySymbol}${currentBalance}`,
      color: "bg-blue-500",
    },
    {
      icon: null,
      symbol: currencySymbol,
      name: t("totalAddMoney"),
      amount: `${currencySymbol}${totalAddMoneyNum.toFixed(0)}`,
      color: "bg-purple-500",
    },
    {
      icon: null,
      symbol: currencySymbol,
      name: t("totalTransactions"),
      amount: `${currencySymbol}${totalTransactionsNum.toFixed(4)}`,
      color: "bg-cyan-500",
    },
    // {
    //   icon: Ticket,
    //   name: t("activeTickets"),
    //   amount: activeTicketsCount,
    //   color: "bg-pink-500",
    // },
    {
      icon: CreditCard,
      name: t("activeCard"),
      amount: activeCardsCount,
      color: "bg-green-500",
    },
    {
      icon: Gift,
      name: t("totalGiftCards"),
      amount: giftCardCount,
      color: "bg-indigo-500",
    },
  ];

  const handleAddMoney = () => {
    if (data?.module_access?.add_money) {
      router.push("/dashboard/add-money");
    }
  };

  const handleSendMoney = () => {
    if (data?.module_access?.transfer_money) {
      router.push("/dashboard/transfer-money");
    }
  };

  return (
    <>
      {/* Header Section */}
      <div className="flex flex-col gap-5 md:flex-row md:items-center md:justify-between mb-6">
        <div>
          <div className="flex items-center gap-3 mb-2">
            <span className="text-gray-600 dark:text-gray-300 text-sm font-medium">
              {t("totalWalletBalance")}
            </span>
            <button
              onClick={() => setShowBalance(!showBalance)}
              className="text-gray-500 hover:text-gray-700 dark:text-gray-300 dark:hover:text-gray-200 cursor-pointer"
              aria-label={showBalance ? t("hideBalance") : t("showBalance")}
            >
              {showBalance ? <Eye size={18} /> : <EyeOff size={18} />}
            </button>
          </div>

          <h1 className="text-3xl sm:text-4xl font-bold text-gray-900 dark:text-white">
            {showBalance ? `${currencySymbol}${currentBalance}` : "••••••••"}
          </h1>
        </div>

        <div className="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
          <button
            onClick={handleAddMoney}
            className="flex items-center justify-center gap-2 px-6 py-3 text-white rounded-lg font-medium cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            style={{ background: "#012C20" }}
            disabled={!data?.module_access?.add_money}
          >
            <Plus size={20} />
            {t("addMoney")}
          </button>

          <button
            onClick={handleSendMoney}
            className="flex items-center justify-center gap-2 px-6 py-3 text-white rounded-lg font-medium cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed transition-colors btn-primary"
            disabled={!data?.module_access?.transfer_money}
          >
            <Send size={20} />
            {t("sendMoney")}
          </button>
        </div>
      </div>

      {/* Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-5 gap-4">
        {cards.map((card, index) => {
          const colors = COLOR_MAP[card.color];

          return (
            <div
              key={index}
              className="bg-white dark:bg-gray-800 rounded-xl p-4 hover:shadow-md transition-shadow duration-200 border border-gray-100 dark:border-gray-700"
            >
              <div className="flex items-start justify-between mb-3">
                <div
                  className={`${card.color} dark:opacity-90 w-10 h-10 rounded-lg flex items-center justify-center text-white shadow-lg`}
                  style={{
                    boxShadow: `0 0 20px ${colors.shadow}`,
                  }}
                >
                  {card.icon ? (
                    <card.icon size={24} />
                  ) : (
                    <span className="text-xl font-bold">{card.symbol}</span>
                  )}
                </div>

                <button
                  className="w-7 h-7 flex items-center justify-center rounded-full transition-colors duration-200"
                  style={{
                    background: colors.base,
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.background = colors.hover;
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.background = colors.base;
                  }}
                >
                  <ArrowUpRight size={14} className="text-gray-700 dark:text-gray-100" />
                </button>
              </div>

              <p className="text-xs text-gray-600 dark:text-gray-300 mb-0.5">
                {card.name}
              </p>
              <p className="text-base font-bold text-gray-900 dark:text-white">
                {card.amount}
              </p>
            </div>
          );
        })}
      </div>
    </>
  );
}
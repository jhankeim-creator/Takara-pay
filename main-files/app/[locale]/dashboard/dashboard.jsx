"use client";

import TransactionHistory from "../../components/wallet/TransactionHistory";
import WalletBalanceSection from "../../components/wallet/WalletBalanceSection";

export default function Dashboard() {
  return (
    <div>
      <div className="mb-6">
        <WalletBalanceSection />
      </div>

      <TransactionHistory />
    </div>
  );
}

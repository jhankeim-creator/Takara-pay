"use client";
import { useState } from "react";
import MoneyWithdrawalLimit from "../../../components/Withdraw-Money/MoneyWithdrawalLimit";
import WithdrawMoney from "../../../components/Withdraw-Money/WithdrawMoney";
import WithdrawMoneyLog from "../../../components/Withdraw-Money/WithdrawMoneyLog";
import WithdrawMoneyPreview from "../../../components/Withdraw-Money/WithdrawMoneyPreview";

export default function WithdrawMoneyPage() {
  // State that both form and preview will share
  const [amount, setAmount] = useState("");
  const [selectedGatewayCurrency, setSelectedGatewayCurrency] = useState(null);

  return (
    <>
      {/* Withdraw form and preview section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 mb-7">
        <WithdrawMoney
          amount={amount}
          setAmount={setAmount}
          selectedGatewayCurrency={selectedGatewayCurrency}
          setSelectedGatewayCurrency={setSelectedGatewayCurrency}
        />

        <WithdrawMoneyPreview
          amount={amount}
          selectedGatewayCurrency={selectedGatewayCurrency}
        />
      </div>

      {/* Shows withdrawal limits */}
      <MoneyWithdrawalLimit />

      {/* Shows withdrawal history/log */}
      <WithdrawMoneyLog />
    </>
  );
}

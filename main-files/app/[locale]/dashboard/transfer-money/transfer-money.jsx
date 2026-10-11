"use client";

import { useState } from "react";
import MoneyTransferLimit from "../../../components/Transfer-Money/MoneyTransferLimit";
import TransferMoney from "../../../components/Transfer-Money/TransferMoney";
import TransferMoneyLog from "../../../components/Transfer-Money/TransferMoneyLog";
import TransferMoneyPreview from "../../../components/Transfer-Money/TransferMoneyPreview";

export default function TransferMoneyPage() {
  // Shared state
  const [amount, setAmount] = useState("");
  const [fixedCharge, setFixedCharge] = useState(0);
  const [percentCharge, setPercentCharge] = useState(0);
  const [currency, setCurrency] = useState("");

  // Callback to update charges (both at once)
  const handleChargesChange = (fixed, percent) => {
    setFixedCharge(fixed);
    setPercentCharge(percent);
  };

  return (
    <>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 mb-7">
        <TransferMoney
          onAmountChange={setAmount}
          onChargesChange={handleChargesChange}
          onCurrencyChange={setCurrency}
        />

        <TransferMoneyPreview
          amount={amount}
          fixedCharge={fixedCharge}
          percentCharge={percentCharge}
          currency={currency}
        />
      </div>

      <MoneyTransferLimit />
      <TransferMoneyLog />
    </>
  );
}

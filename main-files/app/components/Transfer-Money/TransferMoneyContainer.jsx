"use client";

import { useEffect, useState } from "react";
import TransferMoney from "./TransferMoney";
import TransferMoneyPreview from "./TransferMoneyPreview";
import { getTransferMoneyInfo } from "../../utils/api";

export default function TransferMoneyContainer() {
  const [amount, setAmount] = useState("");
  const [fixedCharge, setFixedCharge] = useState(0);
  const [percentCharge, setPercentCharge] = useState(0);
  const [currency, setCurrency] = useState("USD");

  useEffect(() => {
    const fetchInfo = async () => {
      const res = await getTransferMoneyInfo();
      if (res?.data?.transferMoneyCharge) {
        setFixedCharge(res.data.transferMoneyCharge.fixed_charge);
        setPercentCharge(res.data.transferMoneyCharge.percent_charge);
      }
      if (res?.data?.base_curr) {
        setCurrency(res.data.base_curr);
      }
    };

    fetchInfo();
  }, []);

  // Fee calculation
  const fee =
    amount && Number(amount) > 0
      ? fixedCharge + (Number(amount) * percentCharge) / 100
      : 0;

  const recipientReceived =
    amount && Number(amount) > 0 ? Number(amount) - fee : 0;

  const totalPayable =
    amount && Number(amount) > 0 ? Number(amount) + fee : 0;

  return (
    <div className="space-y-6">
      <TransferMoney
        amount={amount}
        setAmount={setAmount}
      />

      <TransferMoneyPreview
        amount={amount}
        fee={fee}
        recipientReceived={recipientReceived}
        totalPayable={totalPayable}
        currency={currency}
      />
    </div>
  );
}

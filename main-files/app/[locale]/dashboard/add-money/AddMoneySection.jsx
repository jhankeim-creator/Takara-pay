"use client";

import { useState } from "react";
import AddMoneyForm from "../../../components/Add-Money/AddMoneyForm";
import AddMoneyLog from "../../../components/Add-Money/AddMoneyLog";
import AddMoneyPreview from "../../../components/Add-Money/AddMoneyPreview";
import LimitInformation from "../../../components/Add-Money/LimitInformation";

function AddMoneySection() {
  const [previewData, setPreviewData] = useState({
    amount: "",
    walletCurrency: "",
    selectedGateway: null,
    fixedCharge: 0,
    percentCharge: 0,
    chargeCurrency: "",
  });

  const handleFormUpdate = (updatedData) => {
    setPreviewData(updatedData);
  };

  return (
    <>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 mb-7">
        <AddMoneyForm onFormUpdate={handleFormUpdate} />
        <AddMoneyPreview {...previewData} />
      </div>

      {/* Destructure directly from previewData */}
      <LimitInformation
        selectedGateway={previewData.selectedGateway}
        walletCurrency={previewData.walletCurrency}
      />

      <AddMoneyLog />
    </>
  );
}

export default AddMoneySection;

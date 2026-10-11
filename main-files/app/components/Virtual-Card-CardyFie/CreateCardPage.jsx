import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import Select from "react-select";
import {
  createCardyFieCard,
  getCardyFieCards,
  getUserDashboard,
} from "../../utils/api";
import CreateVirtualCardSkeleton from "./CreateVirtualCardSkeleton";

function CreateCardPage() {
  // ============================================================================
  // CONSTANTS & OPTIONS
  // ============================================================================
  const cardTierOptions = [
    { value: "universal", label: "Universal" },
    { value: "platinum", label: "Platinum" },
  ];

  const cardTypeOptions = [
    { value: "visa", label: "Visa" },
    { value: "mastercard", label: "Mastercard" },
  ];

  // ============================================================================
  // STATE MANAGEMENT
  // ============================================================================
  const [formData, setFormData] = useState({
    cardHolderName: "",
    cardTier: cardTierOptions[0],
    cardType: cardTypeOptions[0],
    cardCurrency: null,
    fromWallet: null,
  });

  const [currencyOptions, setCurrencyOptions] = useState([]);
  const [cardCharge, setCardCharge] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const router = useRouter();

  // ============================================================================
  // DATA FETCHING
  // ============================================================================
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);

        // 1. Dashboard – get base_curr + wallets
        const dashRes = await getUserDashboard();
        if (!dashRes?.data) {
          toast.error(
            dashRes?.message?.error?.[0] || "Failed to load dashboard",
          );
        }

        const dashData = dashRes.data;

        // Fixed Card Currency – only base_curr
        let baseCurrencyOption = null;
        if (dashData.base_curr) {
          const baseCode = dashData.base_curr.toLowerCase();
          const baseUpper = dashData.base_curr.toUpperCase();

          // Try to get symbol & name from matching wallet if available
          const matchingWallet = dashData.userWallet?.find(
            (w) => w.currency.code.toUpperCase() === baseUpper,
          );

          baseCurrencyOption = {
            value: baseCode,
            label: baseUpper,
            symbol: matchingWallet?.currency.symbol || "$",
            code: baseUpper,
          };

          setFormData((prev) => ({
            ...prev,
            cardCurrency: baseCurrencyOption,
          }));
        }

        // 2. From Wallet options (multiple possible)
        if (dashData.userWallet?.length > 0) {
          const walletOptions = dashData.userWallet.map((w) => {
            const curr = w.currency;
            const balanceFormatted = Number(w.balance || 0).toFixed(4);
            return {
              value: curr.code.toLowerCase(),
              label: `${curr.name} (${balanceFormatted} ${curr.code})`,
              symbol: curr.symbol || "$",
              balance: Number(w.balance || 0),
              code: curr.code.toUpperCase(),
            };
          });

          setCurrencyOptions(walletOptions);

          // Auto-select first wallet
          setFormData((prev) => ({
            ...prev,
            fromWallet: walletOptions[0] || prev.fromWallet,
          }));
        }

        // 3. Card fees
        const cardRes = await getCardyFieCards();
        if (cardRes?.data?.cardCharge) {
          setCardCharge(cardRes.data.cardCharge);
        }
      } catch (err) {
        setError(err.message || "Error loading data");
        // console.error(err);
        toast.error(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // ============================================================================
  // HELPER FUNCTIONS
  // ============================================================================
  const getIssueFee = () => {
    if (!cardCharge) return 0;
    const tier = formData.cardTier?.value || "universal";
    return tier === "platinum"
      ? cardCharge.platinum_card_issues_fee || 0
      : cardCharge.universal_card_issues_fee || 0;
  };

  // ============================================================================
  // COMPUTED VALUES
  // ============================================================================
  const issueFee = getIssueFee();
  const chargeTierLabel = formData.cardTier?.label || "Universal";
  const selectedWallet = formData.fromWallet;
  const currencyCode = selectedWallet?.code || "";
  const displayBalance = (selectedWallet?.balance || 0).toFixed(4);

  // ============================================================================
  // LOADING & ERROR STATES
  // ============================================================================
  if (loading) {
    return <CreateVirtualCardSkeleton />;
  }

  if (error || !formData.cardCurrency) {
    return (
      <div className="text-red-600 text-center min-h-screen pt-20 px-4">
        {error || "Cannot Load the Page"}
      </div>
    );
  }

  // ============================================================================
  // CUSTOM STYLES
  // ============================================================================
  const customSelectStyles = {
    control: (base, state) => ({
      ...base,
      background: "#ffffff",
      borderColor: state.isFocused ? "#34d399" : "#e5e7eb",
      borderWidth: "1.5px",
      borderRadius: "10px",
      padding: "6px 4px",
      cursor: "pointer",
      boxShadow: state.isFocused ? "0 0 0 3px rgba(37, 99, 235, 0.1)" : "none",
      transition: "all 0.2s ease",
      "&:hover": {
        borderColor: "#34d399",
      },
    }),
    option: (base, state) => ({
      ...base,

      backgroundColor: state.isFocused
        ? "#ecfdf5" // only on hover
        : "#ffffff", // normal & selected both white

      color: "#1f2937",

      padding: "12px 16px",
      cursor: "pointer",
      transition: "all 0.15s ease",

      "&:active": {
        backgroundColor: "#ecfdf5",
      },
    }),

    menu: (base) => ({
      ...base,
      borderRadius: "10px",
      overflow: "hidden",
      boxShadow:
        "0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)",
      border: "1.5px solid #e5e7eb",
    }),
    placeholder: (base) => ({
      ...base,
      color: "#9ca3af",
      fontSize: "15px",
    }),
    singleValue: (base) => ({
      ...base,
      color: "#1f2937",
      fontSize: "15px",
    }),
  };

  // ============================================================================
  // EVENT HANDLERS
  // ============================================================================
  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!formData.cardHolderName.trim()) {
      toast.error("Card holder's name is required");
      return;
    }

    if (!formData.fromWallet) {
      toast.error("Please select a wallet");
      return;
    }

    // Balance check
    if (selectedWallet?.balance < issueFee) {
      toast.error(`Your Wallet Balance Is Insufficient`);
      return;
    }

    setSubmitting(true);

    const payload = {
      name_on_card: formData.cardHolderName.trim(),
      card_tier: formData.cardTier.value,
      card_type: formData.cardType.value,
      currency: formData.cardCurrency.value,
      from_currency: formData.fromWallet.value,
    };

    try {
      const response = await createCardyFieCard(payload);

      // Success case
      if (response?.message?.success) {
        toast.success(response?.message?.success?.[0]);
        router.push("/dashboard/Virtual-Card-CardyFie");
      }
      // Error case
      else if (response?.message?.error?.length > 0) {
        toast.error(response.message.error[0]);
      } else if (response?.message) {
        // Fallback
        toast.error(response.message);
      } else {
        toast.error("Failed to Create Virtual Card");
      }
    } catch (err) {
      // Network Error
      const serverMsg = err.response?.data?.message?.error?.[0];
      if (serverMsg) {
        toast.error(serverMsg);
      } else {
        toast.error("Something went wrong. Please try again.");
      }
    } finally {
      setSubmitting(false);
    }
  };

  // ============================================================================
  // RENDER
  // ============================================================================
  return (
    <div className="flex items-center justify-center">
      <div className="w-full grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* ====================================================================
            FORM SECTION
            ==================================================================== */}
        <div className="bg-white rounded-3xl shadow-2xl shadow-indigo-100/50 p-10 border border-slate-100">
          <div className="text-center mb-10">
            <h1 className="text-3xl font-bold text-slate-800 mb-2">
              Create Virtual Card
            </h1>
            <p className="text-slate-500 text-sm">
              Fill in the details to generate your card
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">
                Card Holder&apos;s Name <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.cardHolderName}
                onChange={(e) =>
                  setFormData({ ...formData, cardHolderName: e.target.value })
                }
                placeholder="Enter Card Holder's Name"
                required
                className="w-full text-gray-600 px-4 py-3.5 border-[1.5px] border-slate-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-3 focus:ring-emerald-100 transition"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">
                Card Tier <span className="text-red-500">*</span>
              </label>
              <Select
                options={cardTierOptions}
                value={formData.cardTier}
                onChange={(opt) => setFormData({ ...formData, cardTier: opt })}
                styles={customSelectStyles}
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">
                Card Type <span className="text-red-500">*</span>
              </label>
              <Select
                options={cardTypeOptions}
                value={formData.cardType}
                onChange={(opt) => setFormData({ ...formData, cardType: opt })}
                styles={customSelectStyles}
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">
                Card Currency <span className="text-red-500">*</span>
              </label>
              <Select
                options={formData.cardCurrency ? [formData.cardCurrency] : []}
                value={formData.cardCurrency}
                onChange={(opt) =>
                  setFormData({ ...formData, cardCurrency: opt })
                }
                styles={customSelectStyles}
                isSearchable={false}
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">
                From Wallet <span className="text-red-500">*</span>
              </label>
              <Select
                options={currencyOptions}
                value={formData.fromWallet}
                onChange={(opt) =>
                  setFormData({ ...formData, fromWallet: opt })
                }
                styles={customSelectStyles}
              />
            </div>

            <div className="flex items-center gap-3">
              <p className="text-sm font-medium text-slate-600">
                Available Balance
              </p>
              <p className="text-sm font-bold text-slate-800">
                {displayBalance} {currencyCode}
              </p>
            </div>

            <button
              type="submit"
              disabled={submitting}
              className={`w-full text-white font-semibold py-4 rounded-xl shadow-lg text-lg transition-all duration-200 cursor-pointer ${submitting ? "btn-primary cursor-not-allowed" : "btn-primary hover:opacity-90"}`}
            >
              {submitting ? "Creating card..." : "Confirm"}
            </button>
          </form>
        </div>

        {/* ====================================================================
            PREVIEW SECTION
            ==================================================================== */}
        <div className="bg-white rounded-3xl shadow-2xl shadow-indigo-100/50 p-10 border border-slate-100 h-fit">
          <h2 className="text-2xl font-bold text-slate-800 mb-6 text-center">
            Preview
          </h2>

          <div className="space-y-5">
            <div className="flex justify-between items-center border-b pb-3">
              <span className="text-slate-600 font-medium">Card Type</span>
              <span className="font-semibold text-slate-800">
                {formData.cardType?.label || "—"}
              </span>
            </div>

            <div className="flex justify-between items-center border-b pb-3">
              <span className="text-slate-600 font-medium">Exchange Rate</span>
              <span className="font-semibold text-slate-800">
                1 {currencyCode} = 1.0000 {currencyCode}
              </span>
            </div>

            <div className="flex justify-between items-center pb-3">
              <span className="text-slate-600 font-medium">
                Total Charge{" "}
                <span className="text-blue-500">({chargeTierLabel})</span>
              </span>
              <span className="font-semibold text-slate-800">
                {issueFee.toFixed(4)} {currencyCode}
              </span>
            </div>

            <div className="flex justify-between items-center pt-4 border-t border-slate-200">
              <span className="text-lg font-semibold text-slate-700">
                Total Payable Amount
              </span>
              <span className="text-xl font-bold text-emerald-600">
                {issueFee.toFixed(4)} {currencyCode}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default CreateCardPage;

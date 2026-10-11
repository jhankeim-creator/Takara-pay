/* eslint-disable @next/next/no-img-element */
"use client";

import { ChevronDown, ChevronUp } from "lucide-react";
import { useSearchParams } from "next/navigation";
import { useEffect, useRef, useState } from "react";
import toast from "react-hot-toast";
import { getAllGiftCards, getGiftCardDetails } from "../../utils/api";
import BuyGiftCardModal from "./BuyGiftCardModal";
import GiftCardFormSkeleton from "./GiftCardFormSkeleton";
import { useTranslations } from "next-intl";

const ProductDetails = () => {
  const t = useTranslations("ProductDetails");

  const searchParams = useSearchParams();
  const productId = searchParams.get("productId");

  // ==================== State Management ====================
  const [card, setCard] = useState(null);
  const [loadingCard, setLoadingCard] = useState(true);
  const [error, setError] = useState(null);

  const [amount, setAmount] = useState("");
  const [receiverEmail, setReceiverEmail] = useState("");
  const [country, setCountry] = useState("");
  const [countryCode, setCountryCode] = useState("");
  const [phone, setPhone] = useState("");
  const [fromName, setFromName] = useState("");
  const [quantity, setQuantity] = useState(1);
  const [wallet, setWallet] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [countryDropdownOpen, setCountryDropdownOpen] = useState(false);
  const [walletDropdownOpen, setWalletDropdownOpen] = useState(false);
  const [countryIso, setCountryIso] = useState("");
  const [apiData, setApiData] = useState(null);

  // Dynamic countries
  const [countryOptions, setCountryOptions] = useState([]);
  const [loadingCountries, setLoadingCountries] = useState(true);

  // Dynamic wallets
  const [walletOptions, setWalletOptions] = useState([]);
  const [loadingWallets, setLoadingWallets] = useState(true);

  const countryDropdownRef = useRef(null);
  const walletDropdownRef = useRef(null);

  // ==================== Fetch Gift Card Details ====================
  useEffect(() => {
    if (!productId) {
      setError(t("errors.noProductId"));
      setLoadingCard(false);
      return;
    }

    const fetchCardDetails = async () => {
      try {
        setLoadingCard(true);
        setError(null);

        const response = await getGiftCardDetails(productId);

        if (response?.message?.error) {
          toast.error(
            response.message.error[0] || t("errors.loadFailed")
          );
        }

        const apiProduct = response?.data?.product;

        if (!apiProduct || !apiProduct.productId) {
          toast.error(t("errors.productNotFound"));
        }

        const normalizedCard = {
          id: apiProduct.productId,
          name: apiProduct.productName,
          image: apiProduct.logoUrls?.[0] || null,
          currency: apiProduct.recipientCurrencyCode || "USD",
          denominationType: apiProduct.denominationType || "RANGE",
          minAmount: Number(apiProduct.minRecipientDenomination || 1),
          maxAmount: Number(apiProduct.maxRecipientDenomination || 10000),
          fixedRecipientDenominations:
            apiProduct.fixedRecipientDenominations || [],
          raw: apiProduct,
        };

        setCard(normalizedCard);
        setApiData(response?.data);
      } catch (err) {
        setError(err.message || t("errors.genericError"));
        toast.error(err.message || t("errors.loadFailed"));
      } finally {
        setLoadingCard(false);
      }
    };

    fetchCardDetails();
  }, [productId]);

  // ==================== Fetch Countries ====================
  useEffect(() => {
    const fetchCountries = async () => {
      try {
        setLoadingCountries(true);
        const response = await getAllGiftCards(1);

        if (response?.message?.error) {
          toast.error(response.message.error[0] || t("errors.loadCountriesFailed"));
          return;
        }

        const apiCountries = response?.data?.countries || [];

        const formatted = apiCountries.map((c) => ({
          name: c.name,
          code: c.iso2,
          callingCode: `+${c.mobile_code}`,
        }));

        formatted.sort((a, b) => a.name.localeCompare(b.name));
        setCountryOptions(formatted);
      } catch (err) {
        toast.error(t("errors.loadCountriesFailed"));
      } finally {
        setLoadingCountries(false);
      }
    };

    fetchCountries();
  }, []);

  // ==================== Fetch Wallet Options ====================
  useEffect(() => {
    if (!card?.id) return;

    const fetchWallets = async () => {
      try {
        setLoadingWallets(true);

        const response = await getGiftCardDetails(card.id);

        if (response?.message?.error) {
          toast.error(
            response.message.error[0] || t("errors.loadWalletsFailed")
          );
          return;
        }

        const userWallets = response?.data?.userWallet || [];

        const formattedWallets = userWallets.map((w) => ({
          name: `${w.name} (${w.currency_code})`,
          currency: w.currency_code,
          balance: w.balance,
          symbol: w.currency_symbol || "",
        }));

        setWalletOptions(formattedWallets);
      } catch (err) {
        toast.error(t("errors.loadWalletsFailed"));
      } finally {
        setLoadingWallets(false);
      }
    };

    fetchWallets();
  }, [card?.id]);

  // ==================== Auto-fill Phone Country Code ====================
  useEffect(() => {
    if (countryCode) {
      setPhone(countryCode + " ");
    }
  }, [countryCode]);

  // ==================== Close Dropdowns on Outside Click ====================
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (
        countryDropdownRef.current &&
        !countryDropdownRef.current.contains(event.target)
      ) {
        setCountryDropdownOpen(false);
      }
      if (
        walletDropdownRef.current &&
        !walletDropdownRef.current.contains(event.target)
      ) {
        setWalletDropdownOpen(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // ==================== Amount Type Determination ====================
  // Determines which UI to show for the Amount field:
  // - "FIXED_BUTTONS" → fixedRecipientDenominations has values, user picks one
  // - "RANGE"         → minRecipientDenomination & maxRecipientDenomination exist, free text input
  const getAmountType = () => {
    const hasFixedOptions =
      card?.fixedRecipientDenominations &&
      card.fixedRecipientDenominations.length > 0;

    const hasRangeOptions =
      card?.raw?.minRecipientDenomination !== null &&
      card?.raw?.minRecipientDenomination !== undefined &&
      card?.raw?.maxRecipientDenomination !== null &&
      card?.raw?.maxRecipientDenomination !== undefined;

    // Fixed denominations take priority — show selectable buttons
      if (hasFixedOptions) return "FIXED_BUTTONS";
    
      // Range fallback — show free text input
      if (hasRangeOptions) return "RANGE";
    
      // Last resort fallback — show free text input with whatever min/max we have
      return "RANGE";
  };

  const amountType = getAmountType();

  // ==================== Form Submission Handler ====================
  const handleSubmit = (e) => {
    e.preventDefault();

    if (!amount || !receiverEmail || !country || !wallet) {
      toast.error(t("errors.fillAllFields"));
      return;
    }

    // ---- Validate amount based on type ----
    if (amountType === "FIXED_BUTTONS") {
      const validOptions = card.fixedRecipientDenominations.map(Number);
      if (!validOptions.includes(Number(amount))) {
        toast.error(
          t("errors.invalidFixedAmount", { amounts: validOptions.join(", ") })
        );
        return;
      }
    } else {
      // Amount must be within min/max range
      const min = card.minAmount;
      const max = card.maxAmount;
      const numAmount = Number(amount);
      if (isNaN(numAmount) || numAmount < min || numAmount > max) {
        toast.error(
          t("errors.amountOutOfRange", { min: min.toFixed(2), max: max.toFixed(2) })
        );
        return;
      }
    }

    setIsModalOpen(true);
  };

  // ==================== Confirm Purchase Handler ====================
  const handleConfirm = () => {
    setIsModalOpen(false);
    toast.success(t("success.purchaseSent"));
  };

  // ==================== Purchase Details Object ====================
  const purchaseDetails = {
    productId: card?.id,
    productName: card?.name,
    amount: Number(amount) || 0,
    quantity,
    receiverEmail: receiverEmail || "N/A",
    country: country || "N/A",
    countryIso: countryIso || "",
    phone: phone || "N/A",
    fromName: fromName || "N/A",
    wallet,
  };

  // ==================== LOADING / ERROR STATES ====================
  if (loadingCard) {
    return <GiftCardFormSkeleton />;
  }

  if (error || !card) {
    return (
      <div className="min-h-[60vh] flex flex-col items-center justify-center text-center px-4">
        <p className="text-red-600 dark:text-red-400 text-lg mb-4">
          {error || t("errors.productNotFound")}
        </p>
        <button
          onClick={() => window.history.back()}
          className="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-600 text-white rounded-lg font-medium transition-colors"
        >
          {t("buttons.goBack")}
        </button>
      </div>
    );
  }

  // ==================== MAIN RENDER ====================
  return (
    <>
      <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-lg overflow-hidden border border-neutral-200 dark:border-gray-700">
        <form onSubmit={handleSubmit} noValidate>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-0">
            {/* ==================== Left - Card Display ==================== */}
            <div className="md:col-span-1 lg:col-span-2 bg-gray-100 dark:bg-gray-800 p-6 sm:p-8 md:p-10 flex flex-col justify-center items-center border-b md:border-b-0 md:border-r border-neutral-200 dark:border-gray-700">
              <div className="w-full max-w-xs">
                <img
                  src={card.image || "/images/placeholder-giftcard.png"}
                  alt={card.name}
                  className="w-full aspect-square object-cover rounded-xl shadow-md mb-6"
                />
                <h1 className="text-2xl font-bold mb-2 text-gray-900 dark:text-gray-100">
                  {card.name}
                </h1>

                {/* Wallet Balance Display */}
                {walletOptions.length > 0 ? (
                  <div className="bg-white dark:bg-gray-800 rounded-xl p-4 border border-neutral-200 dark:border-gray-700 shadow-sm">
                    <p className="text-xs text-gray-500 dark:text-gray-300 mb-1">
                      {t("preview.availableBalance")}
                    </p>
                    <p className="text-2xl font-bold text-gray-900 dark:text-gray-100">
                      {walletOptions.map((w, idx) => (
                        <span key={w.currency}>
                          {w.symbol}
                          {w.balance?.toFixed(4)}
                          {idx < walletOptions.length - 1 && " | "}
                        </span>
                      ))}
                    </p>
                  </div>
                ) : (
                  // Skeleton while wallets are loading
                  <div className="bg-white dark:bg-gray-800 rounded-xl p-4 border border-neutral-200 dark:border-gray-700 shadow-sm animate-pulse">
                    <div className="h-3 w-32 bg-gray-200 dark:bg-gray-700 rounded mb-2" />
                    <div className="h-7 w-48 bg-gray-300 dark:bg-gray-600 rounded" />
                  </div>
                )}
              </div>
            </div>

            {/* ==================== Right - Form Fields ==================== */}
            <div className="md:col-span-1 lg:col-span-3 p-6 sm:p-8 md:p-10">
              <h2 className="text-2xl font-bold text-gray-900 dark:text-gray-100 mb-6">
                {t("form.title")}
              </h2>

              <div className="space-y-4">

                {/* ==================== Amount Field ==================== */}
                <div>
                  <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                    {t("form.amount.label")}
                  </label>

                  {/* ---- FIXED BUTTONS: show selectable denomination buttons ---- */}
                  {amountType === "FIXED_BUTTONS" && (
                    <>
                      <p className="text-xs text-gray-500 dark:text-gray-400 mb-3">
                        {t("form.amount.fixedHint", { currency: card.currency || "" })}
                      </p>
                      <div className="flex flex-wrap gap-2">
                        {card.fixedRecipientDenominations.map((option) => (
                          <button
                            key={option}
                            type="button"
                            onClick={() => setAmount(String(option))}
                            className={`px-4 py-2 rounded-lg border font-semibold text-sm transition-all duration-200 cursor-pointer ${
                              Number(amount) === Number(option)
                                ? "bg-blue-600 dark:bg-blue-700 border-blue-600 dark:border-blue-700 text-white shadow-md"
                                : "bg-white dark:bg-gray-800 border-neutral-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 hover:border-blue-500 dark:hover:border-blue-500 hover:text-blue-600 dark:hover:text-blue-400"
                            }`}
                          >
                            {card.currency || ""} {option}
                          </button>
                        ))}
                      </div>
                    </>
                  )}

                  {/* ---- RANGE INPUT: show free text input with min/max hint ---- */}
                  {amountType === "RANGE" && (
                    <>
                      <p className="text-xs text-gray-500 dark:text-gray-400 mb-2">
                        {t("form.amount.rangeHint", {
                          min: card.minAmount?.toFixed(2),
                          max: card.maxAmount?.toFixed(2),
                          currency: card.currency || ""
                        })}
                      </p>
                      <input
                        type="number"
                        min={card.minAmount}
                        max={card.maxAmount}
                        step="0.01"
                        value={amount}
                        onChange={(e) => setAmount(e.target.value)}
                        placeholder={t("form.amount.placeholder")}
                        className="w-full px-4 py-3 border border-neutral-300 dark:border-gray-600 rounded-lg text-gray-800 dark:text-gray-200 placeholder-gray-400 dark:placeholder-gray-400 focus:border-blue-600 focus:outline-none transition-all no-spinner bg-white dark:bg-gray-800"
                      />
                    </>
                  )}
                </div>

                {/* ==================== Receiver Email ==================== */}
                <div>
                  <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                    {t("form.receiverEmail.label")}
                  </label>
                  <input
                    type="email"
                    value={receiverEmail}
                    onChange={(e) => setReceiverEmail(e.target.value)}
                    placeholder={t("form.receiverEmail.placeholder")}
                    className="w-full px-4 py-3 border border-neutral-300 dark:border-gray-600 rounded-lg text-gray-800 dark:text-gray-200 placeholder-gray-400 dark:placeholder-gray-400 focus:border-blue-600 focus:outline-none transition-all bg-white dark:bg-gray-800"
                  />
                </div>

                {/* ==================== Country & Phone ==================== */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                      {t("form.country.label")}
                    </label>
                    <div className="relative" ref={countryDropdownRef}>
                      <button
                        type="button"
                        onClick={() =>
                          setCountryDropdownOpen(!countryDropdownOpen)
                        }
                        disabled={loadingCountries}
                        className="cursor-pointer w-full px-4 py-3 pr-10 border border-neutral-300 dark:border-gray-600 rounded-lg text-gray-800 dark:text-gray-200 bg-white dark:bg-gray-800 focus:border-blue-600 focus:outline-none transition-all text-left disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        <span
                          className={
                            country
                              ? "text-gray-800 dark:text-gray-200"
                              : "text-gray-400 dark:text-gray-500"
                          }
                        >
                          {loadingCountries
                            ? t("form.country.loading")
                            : country || t("form.country.placeholder")}
                        </span>
                      </button>
                      <div className="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        {countryDropdownOpen ? (
                          <ChevronUp className="w-5 h-5 text-gray-500 dark:text-gray-300" />
                        ) : (
                          <ChevronDown className="w-5 h-5 text-gray-500 dark:text-gray-300" />
                        )}
                      </div>

                      {countryDropdownOpen && (
                        <div className="absolute top-full left-0 right-0 mt-1 bg-white dark:bg-gray-800 border border-neutral-300 dark:border-gray-600 rounded-lg shadow-lg max-h-60 overflow-y-auto z-50">
                          {countryOptions.map((c) => (
                            <div
                              key={c.code}
                              onClick={() => {
                                setCountry(c.name);
                                setCountryIso(c.code);
                                setCountryCode(c.callingCode);
                                setCountryDropdownOpen(false);
                              }}
                              className="cursor-pointer px-4 py-3 hover:bg-blue-50 dark:hover:bg-blue-900/30 transition-colors text-gray-800 dark:text-gray-200 border-b border-neutral-100 dark:border-gray-700 last:border-b-0"
                            >
                              {c.name}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                      {t("form.phone.label")}
                    </label>
                    <input
                      type="tel"
                      value={phone}
                      onChange={(e) => setPhone(e.target.value)}
                      placeholder={t("form.phone.placeholder")}
                      className="w-full px-4 py-3 border border-neutral-300 dark:border-gray-600 rounded-lg text-gray-800 dark:text-gray-200 placeholder-gray-400 dark:placeholder-gray-400 focus:border-blue-600 focus:outline-none transition-all no-spinner bg-white dark:bg-gray-800"
                    />
                  </div>
                </div>

                {/* ==================== From Name & Quantity ==================== */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                      {t("form.fromName.label")}
                    </label>
                    <input
                      type="text"
                      value={fromName}
                      onChange={(e) => setFromName(e.target.value)}
                      placeholder={t("form.fromName.placeholder")}
                      className="w-full px-4 py-3 border border-neutral-300 dark:border-gray-600 rounded-lg text-gray-800 dark:text-gray-200 placeholder-gray-400 dark:placeholder-gray-400 focus:border-blue-600 focus:outline-none transition-all bg-white dark:bg-gray-800"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                      {t("form.quantity.label")}
                    </label>
                    <input
                      type="number"
                      min={1}
                      max={100}
                      value={quantity}
                      onChange={(e) => {
                        const val = e.target.value;
                        if (val === "" || /^[1-9]\d*$/.test(val)) {
                          setQuantity(val === "" ? "" : Number(val));
                        }
                      }}
                      onBlur={() => {
                        const num = Number(quantity);
                        if (isNaN(num) || num < 1) setQuantity(1);
                        if (num > 100) setQuantity(100);
                      }}
                      className="w-full px-4 py-3 border border-neutral-300 dark:border-gray-600 rounded-lg text-gray-800 dark:text-gray-200 placeholder-gray-400 dark:placeholder-gray-400 focus:border-blue-600 focus:outline-none transition-all no-spinner bg-white dark:bg-gray-800"
                    />
                  </div>
                </div>

                {/* ==================== Wallet Dropdown ==================== */}
                <div>
                  <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                    {t("form.wallet.label")}
                  </label>
                  <div className="relative" ref={walletDropdownRef}>
                    <button
                      type="button"
                      onClick={() => setWalletDropdownOpen(!walletDropdownOpen)}
                      disabled={loadingWallets}
                      className="cursor-pointer w-full px-4 py-3 pr-10 border border-neutral-300 dark:border-gray-600 rounded-lg text-gray-800 dark:text-gray-200 bg-white dark:bg-gray-800 focus:border-blue-600 focus:outline-none transition-all text-left disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span
                        className={
                          wallet
                            ? "text-gray-800 dark:text-gray-200"
                            : "text-gray-400 dark:text-gray-500"
                        }
                      >
                        {loadingWallets
                          ? t("form.wallet.loading")
                          : wallet || t("form.wallet.placeholder")}
                      </span>
                    </button>
                    <div className="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                      {walletDropdownOpen ? (
                        <ChevronUp className="w-5 h-5 text-gray-500 dark:text-gray-300" />
                      ) : (
                        <ChevronDown className="w-5 h-5 text-gray-500 dark:text-gray-300" />
                      )}
                    </div>

                    {walletDropdownOpen && (
                      <div className="absolute top-full left-0 right-0 mt-1 bg-white dark:bg-gray-800 border border-neutral-300 dark:border-gray-600 rounded-lg shadow-lg max-h-60 overflow-y-auto z-50">
                        {walletOptions.length === 0 ? (
                          <div className="px-4 py-3 text-gray-500 dark:text-gray-300">
                            {t("form.wallet.noWallets")}
                          </div>
                        ) : (
                          walletOptions.map((w) => (
                            <div
                              key={w.currency}
                              onClick={() => {
                                setWallet(w.name);
                                setWalletDropdownOpen(false);
                              }}
                              className="cursor-pointer px-4 py-3 hover:bg-blue-50 dark:hover:bg-blue-900/30 transition-colors text-gray-800 dark:text-gray-200 border-b border-neutral-100 dark:border-gray-700 last:border-b-0"
                            >
                              <span>{w.name}</span>
                            </div>
                          ))
                        )}
                      </div>
                    )}
                  </div>
                </div>

                {/* ==================== Submit Button ==================== */}
                <button
                  type="submit"
                  className="cursor-pointer w-full bg-gradient-to-r from-blue-600 to-blue-700 dark:from-blue-700 dark:to-blue-800 text-white font-semibold py-4 rounded-lg transition-all duration-300 shadow-md hover:shadow-lg mt-6 hover:from-blue-700 hover:to-blue-800 dark:hover:from-blue-800 dark:hover:to-blue-900"
                >
                  {t("form.button")}
                </button>
              </div>
            </div>
          </div>
        </form>
      </div>

      {/* ==================== Buy Gift Card Modal ==================== */}
      <BuyGiftCardModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onConfirm={handleConfirm}
        purchaseDetails={purchaseDetails}
        card={card}
        apiData={apiData}
      />
    </>
  );
};

export default ProductDetails;
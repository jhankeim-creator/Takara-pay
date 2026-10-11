"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { parsePhoneNumberFromString } from "libphonenumber-js";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";
import PhoneInput from "react-phone-input-2";
import "react-phone-input-2/lib/style.css";
import Select from "react-select";
import {
  createSudoCards,
  getRemainingLimits,
  getSudoCards,
} from "../../utils/api";
import Loader from "../Loader";

/* ── Backend contract: POST /user/my-card/sudo/create ───────────────────────
   card_brand      required|string|in:MasterCard,Visa
   card_amount     required|numeric|gt:0
   currency        required|string
   from_currency   required|string

   The fields below are required only while card_extra_fields_status is true
   (i.e. the Sudo customer has not been created yet). They are described by
   card_extra_fields, so the form renders whatever the API sends:
     date_of_birth · identity_type (BVN/NIN/TIN) · identity_number
     phone_number · id_image_front · id_image_back · address_verification
─────────────────────────────────────────────────────────────────────────── */

// Values must match backend: MasterCard, Visa.
const CARD_BRANDS = [
  { value: "MasterCard", label: "MasterCard" },
  { value: "Visa", label: "Visa" },
];

const FILE_TYPES = [
  "image/jpeg",
  "image/jpg",
  "image/png",
  "image/webp",
  "image/svg+xml",
];
const FILE_MAX_MB = 5;

const digitsOnly = (v) => String(v || "").replace(/\D/g, "");

const humanSize = (bytes) =>
  bytes >= 1024 * 1024
    ? `${(bytes / (1024 * 1024)).toFixed(2)} MB`
    : `${Math.max(1, Math.round(bytes / 1024))} KB`;

const isPhoneField = (name) => /phone/i.test(String(name || ""));

/* Sudo stores one full number (dial code + subscriber). Older records
   can can carry the dial code twice — "1" + "18008675309" — which
   the phone widget then force-fits into the 10 digit US mask and mangles
   ("+1 (180) 086-7530"). Trust the raw value first; only when it fails to
   parse do we try dropping a duplicated dial code. */
const normalizeFullPhone = (raw) => {
  const digits = digitsOnly(raw);
  if (!digits) return "";

  const candidates = [digits];
  for (let len = 1; len <= 4 && len < digits.length; len++) {
    const code = digits.slice(0, len);
    const rest = digits.slice(len);
    if (rest.startsWith(code)) candidates.push(rest); // "1" + "1800…" -> "1800…"
  }

  for (const candidate of candidates) {
    const parsed = parsePhoneNumberFromString(`+${candidate}`);
    if (parsed?.isValid()) {
      return `${parsed.countryCallingCode}${parsed.nationalNumber}`;
    }
  }
  return digits; // nothing parsed — show it untouched rather than reshaping it
};

// A field counts as required when the API says so, or (for the older shape)
// when it arrives empty and therefore still needs filling in.
const isFieldRequired = (f) =>
  typeof f?.required === "boolean" ? f.required : f?.value === "";

const CreateSudoCard = () => {
  const router = useRouter();

  const [cardsData, setCardsData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [isDark, setIsDark] = useState(false);

  // Fixed fields
  const [amount, setAmount] = useState("");
  const [selectedCurrency, setSelectedCurrency] = useState(null);
  const [selectedWallet, setSelectedWallet] = useState(null);
  const [selectedBrand, setSelectedBrand] = useState(CARD_BRANDS[0]);

  // Dynamic extra fields — kept in one object keyed by field_name so the form
  // keeps working no matter how many extra fields the API returns.
  const [extraValues, setExtraValues] = useState({});
  // File-type extra fields: the picked File plus an objectURL for the preview.
  const [extraFiles, setExtraFiles] = useState({});
  const [extraPreviews, setExtraPreviews] = useState({});
  const fileInputRefs = useRef({});

  // Remaining limits (in BASE currency) from the get-remaining API.
  const [remainingDaily, setRemainingDaily] = useState(null);
  const [remainingMonthly, setRemainingMonthly] = useState(null);

  /* ===========================
     Fetch card creation info
  =========================== */
  useEffect(() => {
    let mounted = true;

    const fetchCards = async () => {
      try {
        const res = await getSudoCards();
        if (!mounted) return;

        if (res?.message?.error) {
          setError(res.message.error[0] || "Failed to load virtual cards");
          return;
        }

        if (!res?.data) return;

        const data = res.data;
        setCardsData(data);

        // Default currency = base currency
        const defaultCurrency = data.supported_currency?.find(
          (c) => c.currency_code === data.base_curr,
        );
        if (defaultCurrency) {
          setSelectedCurrency({
            value: defaultCurrency.currency_code,
            label: defaultCurrency.currency_code,
            rate: defaultCurrency.rate,
            symbol: defaultCurrency.currency_symbol,
          });
        }

        // Default wallet = first wallet
        if (data.userWallet?.length > 0) {
          const w = data.userWallet[0];
          setSelectedWallet({
            value: w.currency.code,
            label: `${w.currency.name} ( ${w.balance.toFixed(4)} ${w.currency.code} )`,
            balance: w.balance,
            code: w.currency.code,
          });
        }

        // Seed the dynamic fields with whatever the API already knows
        const init = {};
        (data.card_extra_fields || []).forEach((f) => {
          init[f.field_name] =
            f.type === "file" ? "" : isPhoneField(f.field_name)
              ? normalizeFullPhone(f.value)
              : f.value || "";
        });
        setExtraValues(init);
      } catch (err) {
        if (mounted) setError("Something went wrong. Please try again later.");
      } finally {
        if (mounted) setLoading(false);
      }
    };

    fetchCards();
    return () => {
      mounted = false;
    };
  }, []);

  /* Fetch remaining limits (base currency) */
  useEffect(() => {
    if (!cardsData?.cardCharge?.id) return;

    let mounted = true;
    const fetchRemaining = async () => {
      const fields = cardsData.get_remaining_fields || {};
      const params = {
        transaction_type: fields.transaction_type || "VIRTUAL-CARD",
        attribute: fields.attribute || "RECEIVED",
        charge_id: cardsData.cardCharge.id,
        sender_amount: 0,
        currency_code: cardsData.base_curr,
      };

      try {
        const res = await getRemainingLimits(params);
        if (!mounted) return;
        const result = res?.data || res || {};
        setRemainingDaily(Number(result.remainingDaily) || 0);
        setRemainingMonthly(Number(result.remainingMonthly) || 0);
      } catch (err) {
        if (!mounted) return;
        setRemainingDaily(cardsData.cardCharge.daily_limit);
        setRemainingMonthly(cardsData.cardCharge.monthly_limit);
      }
    };

    fetchRemaining();
    return () => {
      mounted = false;
    };
  }, [cardsData]);

  /* The selects and the phone widget are styled inline — track the theme */
  useEffect(() => {
    const root = document.documentElement;
    const read = () => setIsDark(root.classList.contains("dark"));
    read();

    const observer = new MutationObserver(read);
    observer.observe(root, { attributes: true, attributeFilter: ["class"] });
    return () => observer.disconnect();
  }, []);

  /* Release preview objectURLs on unmount */
  useEffect(
    () => () => {
      Object.values(extraPreviews).forEach((url) => URL.revokeObjectURL(url));
    },
    [extraPreviews],
  );

  /* react-select styles (app indigo theme, light + dark) */
  const selectStyles = useMemo(
    () => ({
      control: (base, state) => ({
        ...base,
        background: isDark ? "#374151" : "#ffffff",
        minHeight: "48px",
        borderColor: state.isFocused
          ? "#6366f1"
          : isDark
            ? "#4b5563"
            : "#d1d5db",
        borderWidth: "1.5px",
        borderRadius: "10px",
        padding: "2px 4px",
        boxShadow: state.isFocused
          ? "0 0 0 3px rgba(99, 102, 241, 0.15)"
          : "none",
        "&:hover": { borderColor: "#6366f1" },
      }),
      option: (base, state) => ({
        ...base,
        backgroundColor: state.isSelected
          ? "#4f46e5"
          : state.isFocused
            ? isDark
              ? "#374151"
              : "#eef2ff"
            : isDark
              ? "#1f2937"
              : "#ffffff",
        color: state.isSelected ? "#ffffff" : isDark ? "#f3f4f6" : "#111827",
        padding: "10px 14px",
        cursor: "pointer",
      }),
      menu: (base) => ({
        ...base,
        background: isDark ? "#1f2937" : "#ffffff",
        borderRadius: "10px",
        border: `1px solid ${isDark ? "#4b5563" : "#d1d5db"}`,
        boxShadow: "0 10px 25px -5px rgba(0,0,0,0.12)",
        overflow: "hidden",
      }),
      singleValue: (base) => ({
        ...base,
        color: isDark ? "#f3f4f6" : "#111827",
      }),
      input: (base) => ({ ...base, color: isDark ? "#f3f4f6" : "#111827" }),
      placeholder: (base) => ({ ...base, color: "#9ca3af" }),
      menuPortal: (base) => ({ ...base, zIndex: 9999 }),
    }),
    [isDark],
  );

  const currencySelectStyles = useMemo(
    () => ({
      container: (base) => ({ ...base, height: "100%" }),
      control: (base, state) => ({
        ...base,
        height: "100%",
        minHeight: 0,
        background: state.isFocused ? "#4338ca" : "#4f46e5",
        border: "none",
        borderRadius: 0,
        boxShadow: "none",
        cursor: "pointer",
        "&:hover": { background: "#4338ca" },
      }),
      valueContainer: (base) => ({ ...base, padding: "0 4px 0 14px" }),
      singleValue: (base) => ({ ...base, color: "#ffffff", fontWeight: 600 }),
      dropdownIndicator: (base) => ({
        ...base,
        color: "#ffffff",
        padding: "0 10px 0 0",
      }),
      indicatorSeparator: () => ({ display: "none" }),
      option: (base, state) => ({
        ...base,
        backgroundColor: state.isSelected
          ? "#4f46e5"
          : state.isFocused
            ? isDark
              ? "#374151"
              : "#eef2ff"
            : isDark
              ? "#1f2937"
              : "#ffffff",
        color: state.isSelected ? "#ffffff" : isDark ? "#f3f4f6" : "#111827",
        padding: "10px 14px",
        cursor: "pointer",
      }),
      menu: (base) => ({
        ...base,
        background: isDark ? "#1f2937" : "#ffffff",
        border: `1px solid ${isDark ? "#4b5563" : "#d1d5db"}`,
        borderRadius: "10px",
        minWidth: "140px",
        overflow: "hidden",
        boxShadow: "0 10px 25px -5px rgba(0,0,0,0.15)",
      }),
      menuPortal: (base) => ({ ...base, zIndex: 9999 }),
    }),
    [isDark],
  );

  const phoneStyles = useMemo(
    () => ({
      input: {
        width: "100%",
        height: "48px",
        paddingLeft: "58px",
        fontSize: "14px",
        borderRadius: "10px",
        border: `1.5px solid ${isDark ? "#4b5563" : "#d1d5db"}`,
        background: isDark ? "#374151" : "#ffffff",
        color: isDark ? "#f3f4f6" : "#111827",
      },
      button: {
        border: `1.5px solid ${isDark ? "#4b5563" : "#d1d5db"}`,
        borderRight: "none",
        borderRadius: "10px 0 0 10px",
        background: isDark ? "#4b5563" : "#f9fafb",
      },
      dropdown: {
        borderRadius: "10px",
        border: `1px solid ${isDark ? "#4b5563" : "#d1d5db"}`,
        background: isDark ? "#1f2937" : "#ffffff",
        color: isDark ? "#f3f4f6" : "#111827",
        boxShadow: "0 10px 25px -5px rgba(0,0,0,0.15)",
        textAlign: "left",
      },
      search: {
        width: "90%",
        height: "34px",
        borderRadius: "8px",
        border: `1px solid ${isDark ? "#4b5563" : "#e5e7eb"}`,
        background: isDark ? "#374151" : "#ffffff",
        color: isDark ? "#f3f4f6" : "#111827",
      },
    }),
    [isDark],
  );

  // Portal menus to <body> so they aren't clipped by parent containers.
  const menuPortalTarget =
    typeof document !== "undefined" ? document.body : undefined;

  const baseCurrency = cardsData?.base_curr;
  // Extra fields only render when the API flag is enabled.
  const extraFields = cardsData?.card_extra_fields || [];
  const showExtraFields =
    cardsData?.card_extra_fields_status === true && extraFields.length > 0;

  /* ===========================
     Money math (currency aware)
     - amount is entered in the SELECTED currency
     - charges / payable are shown in the BASE currency
     - limits are shown in the SELECTED currency (base * rate)
  =========================== */
  const charge = cardsData?.cardCharge || {};
  const rate = selectedCurrency?.rate || 1;
  const selectedCode = selectedCurrency?.value || baseCurrency;

  const amountNum = Number(amount) || 0;
  const amountInBase = amountNum / rate; // selected -> base
  // Form "Fees" line shows the fixed charge even at amount 0.
  const feeBase =
    (charge.fixed_charge || 0) +
    (amountInBase * (charge.percent_charge || 0)) / 100;
  // Preview charge/payable are 0 until a real amount is entered.
  const previewCharge = amountNum > 0 ? feeBase : 0;
  const totalPayableBase = amountNum > 0 ? amountInBase + feeBase : 0;

  /* Limits — the API reports them in base currency, shown in the selected one */
  const dailyBase = charge.daily_limit || 0;
  const monthlyBase = charge.monthly_limit || 0;
  const minBase = charge.min_limit || 0;
  const maxBase = charge.max_limit || 0;

  const dailyLimitDisp = dailyBase * rate;
  const monthlyLimitDisp = monthlyBase * rate;
  const minLimitDisp = minBase * rate;
  const maxLimitDisp = maxBase * rate;
  const remainingDailyDisp = (remainingDaily ?? dailyBase) * rate;
  const remainingMonthlyDisp = (remainingMonthly ?? monthlyBase) * rate;

  /* The wallet holds its own currency, so convert the payable into it */
  const walletRate =
    cardsData?.supported_currency?.find(
      (c) => c.currency_code === selectedWallet?.code,
    )?.rate ?? 1;
  const payableInWallet = totalPayableBase * walletRate;

  /* ===========================
     Dynamic field helpers
  =========================== */
  const setExtraValue = (name, value) =>
    setExtraValues((prev) => ({ ...prev, [name]: value }));

  const applyFile = (field, file) => {
    if (!file) return;
    const name = field.field_name;

    if (!FILE_TYPES.includes(file.type)) {
      toast.error(`${field.label_name}: only JPG, PNG, WEBP or SVG allowed`);
      return;
    }
    if (file.size > FILE_MAX_MB * 1024 * 1024) {
      toast.error(`${field.label_name}: file is larger than ${FILE_MAX_MB} MB`);
      return;
    }

    setExtraFiles((prev) => ({ ...prev, [name]: file }));
    setExtraPreviews((prev) => {
      if (prev[name]) URL.revokeObjectURL(prev[name]);
      return { ...prev, [name]: URL.createObjectURL(file) };
    });
  };

  const clearFile = (name) => {
    setExtraFiles((prev) => {
      const next = { ...prev };
      delete next[name];
      return next;
    });
    setExtraPreviews((prev) => {
      if (prev[name]) URL.revokeObjectURL(prev[name]);
      const next = { ...prev };
      delete next[name];
      return next;
    });
    if (fileInputRefs.current[name]) fileInputRefs.current[name].value = "";
  };

  /* ===========================
     Submit — create the card
  =========================== */
  const handleSubmit = async () => {
    if (submitting) return;

    if (!amountNum || amountNum <= 0) {
      toast.error("Please enter a valid amount");
      return;
    }
    if (minBase > 0 && amountNum < minLimitDisp) {
      toast.error(
        `Minimum card amount is ${minLimitDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (maxBase > 0 && amountNum > maxLimitDisp) {
      toast.error(
        `Maximum card amount is ${maxLimitDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (!selectedBrand?.value) {
      toast.error("Please select a card brand");
      return;
    }
    if (!selectedWallet?.code) {
      toast.error("Please select a wallet");
      return;
    }
    if (remainingDaily != null && amountInBase > remainingDaily) {
      toast.error(
        `Daily limit exceeded. Remaining ${remainingDailyDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (remainingMonthly != null && amountInBase > remainingMonthly) {
      toast.error(
        `Monthly limit exceeded. Remaining ${remainingMonthlyDisp.toFixed(4)} ${selectedCode}`,
      );
      return;
    }
    if (payableInWallet > (selectedWallet.balance ?? 0) + 1e-9) {
      toast.error(
        `Insufficient balance. You need ${payableInWallet.toFixed(4)} ${selectedWallet.code}`,
      );
      return;
    }

    // Required extra fields — text inputs and uploads alike
    if (showExtraFields) {
      const missing = extraFields.find((f) => {
        if (!isFieldRequired(f)) return false;
        if (f.type === "file") return !extraFiles[f.field_name] && !f.value;
        return !String(extraValues[f.field_name] ?? "").trim();
      });
      if (missing) {
        toast.error(`${missing.label_name} is required`);
        return;
      }
    }

    // Always-required fields (backend keys).
    const payload = new FormData();
    payload.append("card_amount", amount);
    payload.append("currency", selectedCode);
    payload.append("from_currency", selectedWallet.code);
    payload.append("card_brand", selectedBrand.value);

    // Extra fields (date_of_birth, identity_type, …) are only required/sent
    // when the customer isn't created yet — i.e. card_extra_fields_status is true.
    if (showExtraFields) {
      extraFields.forEach((f) => {
        const name = f.field_name;
        if (f.type === "file") {
          const file = extraFiles[name];
          if (file) payload.append(name, file, file.name);
          return;
        }
        payload.append(name, String(extraValues[name] ?? "").trim());
      });
    }

    try {
      setSubmitting(true);
      const res = await createSudoCards(payload);

      if (res?.message?.success) {
        toast.success(res.message.success[0] || "Virtual card created");
        router.push("/dashboard/Virtual-Card");
      } else if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to create card");
      } else {
        toast.error("Unexpected response. Please try again.");
      }
    } catch (err) {
      toast.error("Failed to create card. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  /* ===========================
     Loading / error states
  =========================== */
  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-[50vh]">
        <Loader />
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12 px-4">
        <div className="max-w-md mx-auto bg-red-50 dark:bg-red-500/10 border border-red-200 dark:border-red-500/30 rounded-xl p-6 text-red-700 dark:text-red-300">
          {error}
        </div>
      </div>
    );
  }

  const row = (label, value, highlight = false) => (
    <div className="flex items-center justify-between gap-3 py-3 border-b border-gray-100 dark:border-gray-700/60 last:border-0">
      <span className="text-gray-500 dark:text-gray-400">{label}</span>
      <span
        className={
          highlight
            ? "text-base font-bold text-indigo-600 dark:text-indigo-400 text-right"
            : "font-semibold text-gray-900 dark:text-gray-100 text-right"
        }
      >
        {value}
      </span>
    </div>
  );

  const labelCls =
    "block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-1.5";
  const inputCls =
    "w-full px-4 h-12 border border-gray-300 dark:border-gray-600 rounded-lg focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 text-gray-900 dark:text-gray-100 bg-white dark:bg-gray-700 placeholder-gray-400 no-spinner disabled:opacity-60";

  /* One dynamic extra field (text / number / date / select / file / phone) */
  const renderExtraField = (field) => {
    const name = field.field_name;
    const required = isFieldRequired(field);
    const label = (
      <label className={labelCls}>
        {field.label_name}
        {required && <span className="text-red-600 ml-1">*</span>}
      </label>
    );

    if (field.type === "file") {
      const picked = extraFiles[name];
      const preview = extraPreviews[name];
      const saved = field.value;

      return (
        <div key={field.id}>
          {label}
          {picked || saved ? (
            <div className="rounded-xl border-2 border-dashed border-indigo-300 dark:border-indigo-500/40 p-3">
              <div className="relative mx-auto max-w-xs">
                <div className="rounded-lg border border-gray-200 bg-white p-2 dark:border-gray-600 dark:bg-gray-700/50">
                  <img
                    src={preview || saved}
                    alt={field.label_name}
                    className="mx-auto max-h-36 w-auto rounded object-contain"
                  />
                </div>
                {picked && (
                  <button
                    type="button"
                    onClick={() => clearFile(name)}
                    disabled={submitting}
                    aria-label={`Remove ${field.label_name}`}
                    className="absolute -top-2.5 -right-2.5 flex h-7 w-7 cursor-pointer items-center justify-center rounded-full bg-red-500 text-white shadow-sm transition hover:bg-red-600 disabled:opacity-50"
                  >
                    <svg
                      className="h-4 w-4"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2.2}
                        d="M6 18L18 6M6 6l12 12"
                      />
                    </svg>
                  </button>
                )}
              </div>
              <div className="mt-2 flex flex-wrap items-center justify-center gap-x-3 gap-y-1 text-xs">
                <span className="max-w-[14rem] truncate text-gray-500 dark:text-gray-400">
                  {picked
                    ? `${picked.name} · ${humanSize(picked.size)}`
                    : "Saved document"}
                </span>
                <button
                  type="button"
                  onClick={() => fileInputRefs.current[name]?.click()}
                  disabled={submitting}
                  className="cursor-pointer font-medium text-indigo-600 hover:underline disabled:opacity-50 dark:text-indigo-400"
                >
                  {picked ? "Change image" : "Replace image"}
                </button>
              </div>
            </div>
          ) : (
            <button
              type="button"
              onClick={() => fileInputRefs.current[name]?.click()}
              disabled={submitting}
              className="flex w-full cursor-pointer items-center gap-3 rounded-xl border-2 border-dashed border-indigo-300 p-3 text-left transition-colors hover:border-indigo-500 disabled:cursor-not-allowed dark:border-indigo-500/40"
            >
              <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded bg-indigo-50 text-indigo-600 dark:bg-indigo-500/15 dark:text-indigo-300">
                <svg
                  className="h-5 w-5"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={1.8}
                    d="M12 16V8m0 0l-3 3m3-3l3 3M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                  />
                </svg>
              </span>
              <span>
                <span className="block text-sm font-medium text-gray-800 dark:text-gray-100">
                  Upload image
                </span>
                <span className="block text-xs text-gray-400">
                  JPG, PNG, WEBP or SVG · max {FILE_MAX_MB} MB
                </span>
              </span>
            </button>
          )}

          <input
            ref={(el) => {
              fileInputRefs.current[name] = el;
            }}
            type="file"
            accept="image/jpeg,image/jpg,image/png,image/webp,image/svg+xml"
            onChange={(e) => applyFile(field, e.target.files?.[0])}
            disabled={submitting}
            className="hidden"
          />
        </div>
      );
    }

    if (field.type === "select") {
      const options = (field.options || []).map((o) => ({
        value: o.value,
        label: o.name,
      }));
      return (
        <div key={field.id}>
          {label}
          <Select
            value={options.find((o) => o.value === extraValues[name]) || null}
            onChange={(opt) => setExtraValue(name, opt ? opt.value : "")}
            options={options}
            placeholder={field.place_holder || "Choose One"}
            styles={selectStyles}
            menuPortalTarget={menuPortalTarget}
            isDisabled={submitting}
          />
        </div>
      );
    }

    // Sudo wants the full number (dial code + subscriber), digits only.
    if (isPhoneField(name)) {
      return (
        <div key={field.id}>
          {label}
          <PhoneInput
            country={
              parsePhoneNumberFromString(
                `+${extraValues[name] || ""}`,
              )?.country?.toLowerCase() || "us"
            }
            value={extraValues[name] || ""}
            onChange={(value) => setExtraValue(name, digitsOnly(value))}
            disabled={submitting}
            enableSearch
            disableSearchIcon
            countryCodeEditable={false}
            searchPlaceholder="Search country"
            containerStyle={{ width: "100%" }}
            inputStyle={phoneStyles.input}
            buttonStyle={phoneStyles.button}
            dropdownStyle={phoneStyles.dropdown}
            searchStyle={phoneStyles.search}
          />
        </div>
      );
    }

    return (
      <div key={field.id}>
        {label}
        <input
          type={field.type === "number" ? "text" : field.type}
          inputMode={field.type === "number" ? "numeric" : undefined}
          value={extraValues[name] ?? ""}
          max={field.type === "date" ? new Date().toISOString().slice(0, 10) : undefined}
          onChange={(e) =>
            setExtraValue(
              name,
              field.type === "number"
                ? digitsOnly(e.target.value)
                : e.target.value,
            )
          }
          placeholder={field.place_holder}
          disabled={submitting}
          className={inputCls}
        />
      </div>
    );
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 lg:gap-8">
      {/* ── LEFT: Form ──────────────────────────────────────── */}
      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 md:p-8 h-fit">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-gray-100 text-center mb-8">
          Create Virtual Card
        </h2>

        {/* Card Amount */}
        <div className="mb-6">
          <label className={labelCls}>
            Card Amount <span className="text-red-600">*</span>
          </label>
          <div className="flex items-stretch h-12 border border-gray-300 dark:border-gray-600 rounded-lg focus-within:border-indigo-500 focus-within:ring-1 focus-within:ring-indigo-500 transition-all overflow-hidden">
            <input
              type="number"
              min="0"
              step="0.01"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="Enter Amount"
              disabled={submitting}
              className="flex-1 px-4 h-full text-gray-900 dark:text-gray-100 bg-white dark:bg-gray-700 focus:outline-none text-base no-spinner"
            />
            <div className="w-24 h-full shrink-0">
              <Select
                value={selectedCurrency}
                onChange={(v) => setSelectedCurrency(v)}
                options={cardsData?.supported_currency?.map((c) => ({
                  value: c.currency_code,
                  label: c.currency_code,
                  rate: c.rate,
                  symbol: c.currency_symbol,
                }))}
                styles={currencySelectStyles}
                menuPortalTarget={menuPortalTarget}
                isSearchable={false}
                isDisabled={submitting}
              />
            </div>
          </div>
        </div>

        {/* Card Brand */}
        <div className="mb-3">
          <label className={labelCls}>
            Card Brand <span className="text-red-600">*</span>
          </label>
          <Select
            value={selectedBrand}
            onChange={(v) => setSelectedBrand(v)}
            options={CARD_BRANDS}
            styles={selectStyles}
            menuPortalTarget={menuPortalTarget}
            isSearchable={false}
            isDisabled={submitting}
          />
        </div>

        {/* Transaction limit + fees */}
        <div className="flex flex-wrap justify-between gap-2 text-sm font-medium text-amber-600 dark:text-amber-500 mb-6">
          <span>
            {minLimitDisp.toFixed(4)} {selectedCode} – {maxLimitDisp.toFixed(4)}{" "}
            {selectedCode}
          </span>
          <span>
            Fees: {(charge.fixed_charge || 0).toFixed(4)} {baseCurrency} +{" "}
            {(charge.percent_charge || 0).toFixed(4)}% = {feeBase.toFixed(4)}{" "}
            {baseCurrency}
          </span>
        </div>

        {/* From Wallet */}
        <div className="mb-3">
          <label className={labelCls}>
            From Wallet <span className="text-red-600">*</span>
          </label>
          <Select
            value={selectedWallet}
            onChange={(v) => setSelectedWallet(v)}
            options={cardsData?.userWallet?.map((w) => ({
              value: w.currency.code,
              label: `${w.currency.name} ( ${w.balance.toFixed(4)} ${w.currency.code} )`,
              balance: w.balance,
              code: w.currency.code,
            }))}
            styles={selectStyles}
            menuPortalTarget={menuPortalTarget}
            isDisabled={submitting}
          />
        </div>

        {/* Available balance */}
        <div className="flex flex-wrap justify-end gap-2 text-sm font-medium text-amber-600 dark:text-amber-500 mb-8">
          <span>
            Available Balance {selectedWallet?.balance?.toFixed(4) ?? "0.0000"}{" "}
            {selectedWallet?.code ?? baseCurrency}
          </span>
        </div>

        {/* Dynamic extra fields (only when card_extra_fields_status === true) */}
        {showExtraFields && (
          <div className="mb-8 border-t border-gray-100 dark:border-gray-700/60 pt-6">
            <p className="mb-4 text-xs font-semibold tracking-wider text-gray-400 uppercase dark:text-gray-500">
              Card Holder Verification
            </p>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              {extraFields.map((field) => (
                <div
                  key={field.id}
                  className={field.type === "file" ? "md:col-span-2" : ""}
                >
                  {renderExtraField(field)}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Confirm */}
        <button
          onClick={handleSubmit}
          disabled={submitting}
          className="w-full py-3.5 btn-primary text-white font-semibold text-base rounded-xl shadow-sm disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
        >
          {submitting ? "Processing..." : "Confirm"}
        </button>
      </div>

      {/* ── RIGHT: Preview + Limit Information ───────────────── */}
      <div className="space-y-6 lg:space-y-8 h-fit lg:sticky lg:top-6 self-start">
        {/* Preview */}
        <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 md:p-8">
          <h3 className="text-2xl font-bold text-gray-900 dark:text-gray-100 text-center mb-6">
            Preview
          </h3>
          <div className="text-sm">
            {row("Card Amount", `${amountNum.toFixed(4)} ${selectedCode}`)}
            {row("Card Brand", selectedBrand?.label || "—")}
            {row(
              "Exchange Rate",
              `1 ${selectedCode} = ${(1 / rate).toFixed(8)} ${baseCurrency}`,
            )}
            {row("Total Charge", `${previewCharge.toFixed(4)} ${baseCurrency}`)}
            {row(
              "Total Payable Amount",
              `${totalPayableBase.toFixed(4)} ${baseCurrency}`,
              true,
            )}
          </div>
        </div>

        {/* Limit Information */}
        <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 md:p-8">
          <h3 className="text-2xl font-bold text-gray-900 dark:text-gray-100 text-center mb-6">
            Limit Information
          </h3>
          <div className="text-sm">
            {row(
              "Transaction Limit",
              `${minLimitDisp.toFixed(4)} ${selectedCode} – ${maxLimitDisp.toFixed(4)} ${selectedCode}`,
            )}
            {row("Daily Limit", `${dailyLimitDisp.toFixed(4)} ${selectedCode}`)}
            {row(
              "Remaining Daily Limit",
              `${remainingDailyDisp.toFixed(4)} ${selectedCode}`,
              true,
            )}
            {row(
              "Monthly Limit",
              `${monthlyLimitDisp.toFixed(4)} ${selectedCode}`,
            )}
            {row(
              "Remaining Monthly Limit",
              `${remainingMonthlyDisp.toFixed(4)} ${selectedCode}`,
              true,
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default CreateSudoCard;

"use client";

import isoCountries from "i18n-iso-countries";
import { useRouter } from "next/navigation";
import { useEffect, useMemo, useRef, useState } from "react";
import toast from "react-hot-toast";
import PhoneInput from "react-phone-input-2";
import "react-phone-input-2/lib/style.css";
import Select from "react-select";
import {
  getStrowalletCardHolder,
  getStrowalletCards,
  storeStrowalletCardHolder,
} from "../../utils/api";
import { countryOptions as ISO_COUNTRIES } from "../../utils/countries";
import Loader from "../Loader";

/* ── Backend contract: POST /user/strowallet-card/store/card-holder ─────────
   name          required|string|min:2|max:100
   first_name    required|string|min:2|max:50
   last_name     required|string|min:2|max:50
   dob           required|date|before:today
   id_type       required|in:national_id,passport,drivers_license
   id_number     required|string|min:3|max:50
   email         required|email|max:100
   line1         required|string|max:250
   city          required|string|max:100
   state         required|string|max:100
   postal_code   required|string|max:20
   country       required|string|max:20   (3 letter code — USA, NGA, HTI)
   phone_code    required|string|max:6    (digits only, no +)
   phone         required|string|max:20
   id_image      file — required while the KYC record has no document yet
─────────────────────────────────────────────────────────────────────────── */

// ID types — values must match backend: national_id, passport, drivers_license.
const ID_TYPES = [
  { value: "national_id", label: "National ID" },
  { value: "passport", label: "Passport" },
  { value: "drivers_license", label: "Driver's License" },
];

/* The backend takes these three in lowercase snake_case; the UI shows them
   title cased ("bill_payment" -> "Bill Payment"). */
const titleCase = (v) =>
  String(v)
    .split("_")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");

const toOptions = (values) =>
  values.map((value) => ({ value, label: titleCase(value) }));

// required|string|in:personal,business,savings,investment,travel,shopping,bill_payment,other
const ACCOUNT_PURPOSES = toOptions([
  "personal",
  "business",
  "savings",
  "investment",
  "travel",
  "shopping",
  "bill_payment",
  "other",
]);

// required|string|in:employed,self_employed,unemployed,student,retired
const EMPLOYMENT_STATUSES = toOptions([
  "employed",
  "self_employed",
  "unemployed",
  "student",
  "retired",
]);

// required|string|in:engineer,doctor,teacher,accountant,business_owner,sales,freelancer,student,other
const OCCUPATIONS = toOptions([
  "engineer",
  "doctor",
  "teacher",
  "accountant",
  "business_owner",
  "sales",
  "freelancer",
  "student",
  "other",
]);

const labelFor = (options, value) =>
  options.find((o) => o.value === value)?.label || "";

const MAX = {
  name: 100,
  first_name: 50,
  last_name: 50,
  id_number: 50,
  email: 100,
  line1: 250,
  city: 100,
  state: 100,
  postal_code: 20,
  phone_code: 6,
  phone: 20,
};

const ID_IMAGE_TYPES = [
  "image/jpeg",
  "image/jpg",
  "image/png",
  "image/webp",
  "application/pdf",
];
const ID_IMAGE_MAX_MB = 5;

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

const EMPTY_FORM = {
  name: "",
  first_name: "",
  last_name: "",
  date_of_birth: "",
  identity_type: "",
  identity_number: "",
  email: "",
  address: "",
  city: "",
  state: "",
  zip_code: "",
  country: "",
  phone_code: "",
  phone: "",
  account_purpose: "",
  employment_status: "",
  occupation: "",
};

// Normalise any country value (ISO3 / ISO2 / full name) to the ISO2 code the
// dropdown uses.
const toIso2 = (c) => {
  if (!c) return "";
  const v = String(c).trim();
  if (v.length === 3) return isoCountries.alpha3ToAlpha2(v.toUpperCase()) || "";
  if (v.length === 2) return v.toUpperCase();
  const hit = ISO_COUNTRIES.find(
    (o) => o.name.toLowerCase() === v.toLowerCase(),
  );
  return hit ? hit.code : "";
};

const digitsOnly = (v) => String(v || "").replace(/\D/g, "");

/* ── Saved ID document ─────────────────────────────────────────────────────
   The API may return the document under any of a few keys, and as an absolute
   URL or a path relative to the app root — resolve both.
─────────────────────────────────────────────────────────────────────────── */

const API_ORIGIN = (() => {
  try {
    return new URL(process.env.NEXT_PUBLIC_API_BASE_URL).origin;
  } catch {
    return "";
  }
})();

// idImageData is what /get/card-holder returns (a full storage URL).
const DOC_KEYS = [
  "idImageData",
  "id_image_url",
  "id_image_path",
  "id_image",
  "idImage",
  "id_document",
  "id_card_image",
  "kyc_image",
  "document",
  "image",
];

const looksLikeFile = (v) =>
  typeof v === "string" &&
  (/^https?:\/\//i.test(v.trim()) ||
    /\.(jpe?g|png|webp|gif|bmp|pdf)(\?.*)?$/i.test(v.trim()));

// Known keys first (across every source), then any image/document-ish key.
const pickDocument = (...sources) => {
  const objs = sources.filter((s) => s && typeof s === "object");

  for (const key of DOC_KEYS) {
    for (const o of objs) if (looksLikeFile(o[key])) return o[key].trim();
  }
  for (const o of objs) {
    for (const [k, v] of Object.entries(o)) {
      if (/image|document|photo|file|attachment/i.test(k) && looksLikeFile(v)) {
        return v.trim();
      }
    }
  }
  return "";
};

const resolveAssetUrl = (value, ...bases) => {
  const v = String(value || "").trim();
  if (!v) return "";
  if (/^(https?:)?\/\//i.test(v) || v.startsWith("data:")) return v;

  const path = v.replace(/^\/+/, "");
  const base = bases.map((b) => String(b || "").trim()).find(Boolean);
  if (base) return `${base.replace(/\/+$/, "")}/${path}`;
  return API_ORIGIN ? `${API_ORIGIN}/${path}` : `/${path}`;
};

const isPdfUrl = (url) => /\.pdf(\?.*)?$/i.test(String(url || ""));

// The phone widget holds one value (dial code + national number); the payload
// keeps them split, so compose without doubling an already prefixed code.
const composePhone = (code, national) => {
  const c = digitsOnly(code);
  const n = digitsOnly(national);
  if (!c) return n;
  return n.startsWith(c) ? n : `${c}${n}`;
};

const humanSize = (bytes) =>
  bytes >= 1024 * 1024
    ? `${(bytes / (1024 * 1024)).toFixed(2)} MB`
    : `${Math.max(1, Math.round(bytes / 1024))} KB`;

/* ── Layout helpers ────────────────────────────────────────────────────── */

// A quiet group label with the fields under it — no numbers, no descriptions.
const Group = ({ title, children }) => (
  <div>
    <p className="mb-4 text-xs font-semibold tracking-wider text-gray-400 uppercase dark:text-gray-500">
      {title}
    </p>
    <div className="grid grid-cols-1 gap-x-4 gap-y-5 sm:grid-cols-2">
      {children}
    </div>
  </div>
);

const Field = ({ label, required = true, error, className = "", children }) => (
  <div className={className}>
    <label className="mb-1.5 block text-[13px] font-medium text-gray-600 dark:text-gray-300">
      {label}
      {required && <span className="ml-0.5 text-red-500">*</span>}
    </label>
    {children}
    {error && <p className="mt-1.5 text-xs text-red-500">{error}</p>}
  </div>
);

const CreateStrowalletCard = () => {
  const router = useRouter();

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  const [form, setForm] = useState(EMPTY_FORM);
  const [errors, setErrors] = useState({});
  // A saved card holder can't be edited (no update endpoint) — shown read only.
  const [isExisting, setIsExisting] = useState(false);

  // Value shown in the phone widget — dial code + national number.
  const [phoneValue, setPhoneValue] = useState("");
  const [isDark, setIsDark] = useState(false);

  /* ID document state */
  const [idImage, setIdImage] = useState(null); // newly picked File
  const [idImagePreview, setIdImagePreview] = useState(null); // objectURL, images only
  const [existingIdImage, setExistingIdImage] = useState(null); // already on the record
  const [existingIdBroken, setExistingIdBroken] = useState(false); // saved URL failed to load
  const [dragging, setDragging] = useState(false);
  const fileInputRef = useRef(null);

  // `name` mirrors "first last" until the user types their own value.
  const nameEdited = useRef(false);

  const setField = (key, value) => {
    setForm((p) => ({ ...p, [key]: value }));
    setErrors((p) => (p[key] ? { ...p, [key]: undefined } : p));
  };

  /* Load existing card holder; fall back to the logged in user's info */
  useEffect(() => {
    let mounted = true;

    const fetchData = async () => {
      try {
        const [holderRes, cardsRes] = await Promise.all([
          getStrowalletCardHolder(),
          getStrowalletCards(),
        ]);
        if (!mounted) return;

        const holder = holderRes?.data?.card_holder;
        const u = cardsRes?.data?.user;

        // Any document already stored against the holder / KYC record. The
        // path may be relative, so resolve it against whatever base the API
        // hands back (falling back to the API origin).
        const savedImage = pickDocument(holder, holderRes?.data, u);
        if (savedImage) {
          setExistingIdImage(
            resolveAssetUrl(
              savedImage,
              holderRes?.data?.image_path,
              holderRes?.data?.base_url,
              cardsRes?.data?.image_path,
              cardsRes?.data?.base_url,
            ),
          );
        }

        if (holder && (holder.first_name || holder.name || holder.email)) {
          // Prefill from the saved card holder
          nameEdited.current = Boolean(holder.name);
          setForm({
            name: holder.name || "",
            first_name: holder.first_name || "",
            last_name: holder.last_name || "",
            date_of_birth: String(
              holder.dob || holder.date_of_birth || "",
            ).slice(0, 10),
            identity_type: holder.id_type || holder.identity_type || "",
            identity_number: holder.id_number || holder.identity_number || "",
            email: holder.email || holder.customer_email || "",
            address: holder.line1 || holder.address || "",
            city: holder.city || "",
            state: holder.state || "",
            zip_code: holder.postal_code || holder.zip_code || "",
            country: toIso2(holder.country),
            phone_code: digitsOnly(holder.phone_code),
            phone: holder.phone || "",
            account_purpose: String(holder.account_purpose || "").toLowerCase(),
            employment_status: String(
              holder.employment_status || "",
            ).toLowerCase(),
            occupation: String(holder.occupation || "").toLowerCase(),
          });
          setPhoneValue(composePhone(holder.phone_code, holder.phone));
          // Strowallet has no update endpoint — an existing holder is view only.
          setIsExisting(true);
        } else if (u) {
          // Fall back to the logged in user's profile
          const addr = u.address || {};
          const fullname =
            u.fullname || `${u.firstname || ""} ${u.lastname || ""}`.trim();
          nameEdited.current = Boolean(fullname);
          setForm((p) => ({
            ...p,
            name: fullname,
            first_name: u.firstname || "",
            last_name: u.lastname || "",
            email: u.email || "",
            phone_code: digitsOnly(u.mobile_code),
            phone: u.mobile || "",
            country: toIso2(addr.country),
            city: addr.city || "",
            state: addr.state || "",
            zip_code: addr.zip || "",
            address: addr.address || "",
          }));
          setPhoneValue(composePhone(u.mobile_code, u.mobile));
        }
      } catch (err) {
        setError("Something went wrong. Please try again later.");
        toast.error("Something went wrong. Please try again later");
      } finally {
        if (mounted) setLoading(false);
      }
    };

    fetchData();
    return () => {
      mounted = false;
    };
  }, []);

  /* The phone widget is styled inline, so it needs to know the active theme */
  useEffect(() => {
    const root = document.documentElement;
    const read = () => setIsDark(root.classList.contains("dark"));
    read();

    const observer = new MutationObserver(read);
    observer.observe(root, { attributes: true, attributeFilter: ["class"] });
    return () => observer.disconnect();
  }, []);

  /* Release the preview objectURL */
  useEffect(
    () => () => {
      if (idImagePreview) URL.revokeObjectURL(idImagePreview);
    },
    [idImagePreview],
  );

  /* react-select styling — matches the plain inputs, light + dark */
  const makeSelectStyles = (hasError) => ({
    control: (base, state) => ({
      ...base,
      background: isDark ? "#374151" : "#ffffff",
      minHeight: "48px",
      borderColor: hasError
        ? "#fca5a5"
        : state.isFocused
          ? "#6366f1"
          : isDark
            ? "#4b5563"
            : "#e5e7eb",
      borderWidth: "1px",
      borderRadius: "10px",
      padding: "2px 4px",
      boxShadow: state.isFocused
        ? `0 0 0 1px ${hasError ? "#f87171" : "#6366f1"}`
        : "none",
      "&:hover": {
        borderColor: hasError ? "#fca5a5" : isDark ? "#6366f1" : "#c7d2fe",
      },
    }),
    placeholder: (base) => ({ ...base, color: "#9ca3af" }),
    input: (base) => ({ ...base, color: isDark ? "#f3f4f6" : "#111827" }),
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
      border: `1px solid ${isDark ? "#4b5563" : "#e5e7eb"}`,
      boxShadow: "0 10px 25px -5px rgba(0,0,0,0.10)",
      overflow: "hidden",
    }),
    noOptionsMessage: (base) => ({
      ...base,
      color: isDark ? "#9ca3af" : "#6b7280",
    }),
    singleValue: (base) => ({
      ...base,
      color: isDark ? "#f3f4f6" : "#111827",
    }),
    menuPortal: (base) => ({ ...base, zIndex: 9999 }),
  });

  const menuPortalTarget =
    typeof document !== "undefined" ? document.body : undefined;

  const countryOptions = useMemo(
    () =>
      ISO_COUNTRIES.map((c) => ({
        value: c.code,
        label: c.name,
        callingCode: c.callingCode,
      })),
    [],
  );

  const selectedCountry =
    countryOptions.find((o) => o.value === form.country) || null;

  const today = useMemo(() => new Date().toISOString().slice(0, 10), []);

  /* ── Conditions ───────────────────────────────────────────────────────── */

  // First / last name feed `name` while the user has not customised it.
  const setNamePart = (key, value) => {
    setForm((p) => {
      const next = { ...p, [key]: value };
      if (!nameEdited.current) {
        next.name = `${next.first_name} ${next.last_name}`.trim();
      }
      return next;
    });
    setErrors((p) => ({ ...p, [key]: undefined, name: undefined }));
  };

  // Country drives the dial code; the national number the user typed is kept.
  const handleCountry = (opt) => {
    const nextCode = digitsOnly(opt?.callingCode);
    setPhoneValue(composePhone(nextCode, form.phone));
    setForm((p) => ({
      ...p,
      country: opt ? opt.value : "",
      phone_code: nextCode,
    }));
    setErrors((p) => ({ ...p, country: undefined, phone_code: undefined }));
  };

  // The widget owns one string — split it back into phone_code + phone so the
  // payload keys stay exactly the same.
  const handlePhone = (value, country) => {
    const digits = digitsOnly(value);
    const dial = digitsOnly(country?.dialCode);
    const national =
      dial && digits.startsWith(dial) ? digits.slice(dial.length) : digits;

    setPhoneValue(digits);
    setForm((p) => ({ ...p, phone_code: dial, phone: national }));
    setErrors((p) => ({ ...p, phone_code: undefined, phone: undefined }));
  };

  const applyFile = (file) => {
    if (!file) return;

    if (!ID_IMAGE_TYPES.includes(file.type)) {
      setErrors((p) => ({
        ...p,
        id_image: "Only JPG, PNG, WEBP or PDF files are allowed",
      }));
      toast.error("Only JPG, PNG, WEBP or PDF files are allowed");
      return;
    }
    if (file.size > ID_IMAGE_MAX_MB * 1024 * 1024) {
      setErrors((p) => ({
        ...p,
        id_image: `File is too large — maximum ${ID_IMAGE_MAX_MB} MB`,
      }));
      toast.error(`File is too large — maximum ${ID_IMAGE_MAX_MB} MB`);
      return;
    }

    if (idImagePreview) URL.revokeObjectURL(idImagePreview);
    setIdImage(file);
    setIdImagePreview(
      file.type.startsWith("image/") ? URL.createObjectURL(file) : null,
    );
    setErrors((p) => ({ ...p, id_image: undefined }));
  };

  const clearFile = () => {
    if (idImagePreview) URL.revokeObjectURL(idImagePreview);
    setIdImage(null);
    setIdImagePreview(null);
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  const handleDrop = (e) => {
    e.preventDefault();
    setDragging(false);
    if (submitting || isExisting) return;
    applyFile(e.dataTransfer?.files?.[0]);
  };

  /* Validation — mirrors the backend rules */
  const validate = () => {
    const v = (k) => String(form[k] || "").trim();
    const e = {};

    if (!v("name")) e.name = "Name is required";
    else if (v("name").length < 2)
      e.name = "Name must be at least 2 characters";

    if (!v("first_name")) e.first_name = "First name is required";
    else if (v("first_name").length < 2)
      e.first_name = "First name must be at least 2 characters";

    if (!v("last_name")) e.last_name = "Last name is required";
    else if (v("last_name").length < 2)
      e.last_name = "Last name must be at least 2 characters";

    if (!v("date_of_birth")) e.date_of_birth = "Date of birth is required";
    else if (v("date_of_birth") >= today)
      e.date_of_birth = "Date of birth must be before today";

    if (!v("identity_type")) e.identity_type = "ID type is required";
    else if (!ID_TYPES.some((o) => o.value === v("identity_type")))
      e.identity_type = "Select a valid ID type";

    if (!v("identity_number")) e.identity_number = "ID number is required";
    else if (v("identity_number").length < 3)
      e.identity_number = "ID number must be at least 3 characters";

    if (!v("email")) e.email = "Email is required";
    else if (!EMAIL_RE.test(v("email"))) e.email = "Enter a valid email address";

    if (!v("address")) e.address = "Address is required";
    if (!v("city")) e.city = "City is required";
    if (!v("state")) e.state = "State is required";
    if (!v("zip_code")) e.zip_code = "Postal code is required";
    if (!v("country")) e.country = "Country is required";

    if (!v("phone_code")) e.phone_code = "Phone code is required";
    else if (!/^\d{1,6}$/.test(v("phone_code")))
      e.phone_code = "Phone code must be digits only (max 6)";

    if (!v("phone")) e.phone = "Phone number is required";
    else if (digitsOnly(v("phone")).length < 4)
      e.phone = "Enter a valid phone number";
    else if (v("phone").length > MAX.phone) e.phone = "Phone number is too long";

    if (!ACCOUNT_PURPOSES.some((o) => o.value === v("account_purpose")))
      e.account_purpose = "Account purpose is required";
    if (!EMPLOYMENT_STATUSES.some((o) => o.value === v("employment_status")))
      e.employment_status = "Employment status is required";
    if (!OCCUPATIONS.some((o) => o.value === v("occupation")))
      e.occupation = "Occupation is required";

    // id_image is only mandatory while no document exists on the record.
    if (!idImage && !existingIdImage) e.id_image = "ID document is required";

    return e;
  };

  /* Submit — store the card holder, then move to the create-card step */
  const handleSubmit = async (event) => {
    event?.preventDefault();
    if (submitting || isExisting) return;

    const found = validate();
    const firstKey = Object.keys(found).find((k) => found[k]);
    if (firstKey) {
      setErrors(found);
      toast.error(found[firstKey]);
      // phone_code lives inside the phone widget, so it shares its anchor.
      const anchor = firstKey === "phone_code" ? "phone" : firstKey;
      document
        .querySelector(`[data-field="${anchor}"]`)
        ?.scrollIntoView({ behavior: "smooth", block: "center" });
      return;
    }
    setErrors({});

    // Backend wants ISO3 country code (e.g. USA); the dropdown stores ISO2.
    const countryAlpha3 = form.country
      ? isoCountries.alpha2ToAlpha3(form.country) || form.country
      : "";

    const t = (k) => String(form[k] || "").trim();

    // Keys expected by /user/strowallet-card/store/card-holder
    const payload = new FormData();
    payload.append("name", t("name"));
    payload.append("first_name", t("first_name"));
    payload.append("last_name", t("last_name"));
    payload.append("dob", t("date_of_birth")); // YYYY-MM-DD
    payload.append("id_type", t("identity_type"));
    payload.append("id_number", t("identity_number"));
    payload.append("email", t("email"));
    payload.append("line1", t("address"));
    payload.append("city", t("city"));
    payload.append("state", t("state"));
    payload.append("postal_code", t("zip_code"));
    payload.append("country", countryAlpha3);
    payload.append("phone_code", digitsOnly(form.phone_code));
    payload.append("phone", t("phone"));
    payload.append("account_purpose", t("account_purpose"));
    payload.append("employment_status", t("employment_status"));
    payload.append("occupation", t("occupation"));
    // Only sent when a new file was picked — the stored one is kept otherwise.
    if (idImage) payload.append("id_image", idImage, idImage.name);

    try {
      setSubmitting(true);
      const res = await storeStrowalletCardHolder(payload);

      if (res?.message?.success) {
        toast.success(res.message.success[0] || "Card holder saved");
        router.push("/dashboard/Virtual-Card/IssueStrowalletCard");
        return;
      }

      // Laravel style field errors -> show them next to the inputs
      const fieldErrors = res?.errors || res?.data?.errors;
      if (fieldErrors && typeof fieldErrors === "object") {
        const apiKeyToField = {
          dob: "date_of_birth",
          id_type: "identity_type",
          id_number: "identity_number",
          line1: "address",
          postal_code: "zip_code",
        };
        const mapped = {};
        Object.entries(fieldErrors).forEach(([key, val]) => {
          mapped[apiKeyToField[key] || key] = Array.isArray(val) ? val[0] : val;
        });
        setErrors(mapped);
        toast.error(Object.values(mapped)[0] || "Please check the form");
      } else if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to save card holder");
      } else {
        toast.error("Unexpected response. Please try again.");
      }
    } catch {
      toast.error("Failed to save card holder. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="flex min-h-[50vh] items-center justify-center">
        <Loader />
      </div>
    );
  }

  if (error) {
    return (
      <div className="px-4 py-12 text-center">
        <div className="mx-auto max-w-md rounded-xl border border-red-200 bg-red-50 p-6 text-red-700 dark:border-red-500/30 dark:bg-red-500/10 dark:text-red-300">
          {error}
        </div>
      </div>
    );
  }

  /* A newly picked file always wins over whatever is saved on the record */
  const hasPreview = Boolean(idImage || existingIdImage);
  const previewSrc = idImage ? idImagePreview : existingIdImage;
  const previewIsPdf = idImage
    ? idImage.type === "application/pdf"
    : isPdfUrl(existingIdImage);
  const previewBroken = idImage ? false : existingIdBroken;

  // react-phone-input-2 ships its own stylesheet, so it is themed inline to
  // match the plain inputs above.
  const phoneInvalid = Boolean(errors.phone || errors.phone_code);
  const phoneBorder = phoneInvalid
    ? "#fca5a5"
    : isDark
      ? "#4b5563"
      : "#e5e7eb";
  const phoneStyles = {
    input: {
      width: "100%",
      height: "48px",
      paddingLeft: "58px",
      fontSize: "14px",
      borderRadius: "10px",
      border: `1px solid ${phoneBorder}`,
      background: isDark ? "#374151" : "#ffffff",
      color: isDark ? "#f3f4f6" : "#111827",
      opacity: submitting ? 0.6 : 1,
    },
    button: {
      border: `1px solid ${phoneBorder}`,
      borderRight: "none",
      borderRadius: "10px 0 0 10px",
      background: isDark ? "#4b5563" : "#f9fafb",
    },
    dropdown: {
      borderRadius: "10px",
      border: `1px solid ${isDark ? "#4b5563" : "#e5e7eb"}`,
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
  };

  // A saved holder can't be changed (no update endpoint) — same form, locked.
  const locked = submitting || isExisting;

  const inputCls = (key) =>
    `w-full h-12 px-4 rounded-[10px] border bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-1 disabled:opacity-60 disabled:cursor-not-allowed ${
      errors[key]
        ? "border-red-300 focus:border-red-400 focus:ring-red-400"
        : "border-gray-200 dark:border-gray-600 hover:border-indigo-200 focus:border-indigo-500 focus:ring-indigo-500"
    }`;

  return (
    <div className="mx-auto max-w-2xl">
      {/* Heading */}
      <div className="mb-6">
        <h2 className="text-xl font-bold text-gray-900 dark:text-gray-100">
          Card Holder Details
        </h2>
        <p className="mt-1 text-sm text-gray-500 dark:text-gray-400">
          Use the details exactly as they appear on your ID.
        </p>
      </div>

      <form
        onSubmit={handleSubmit}
        noValidate
        className="rounded-2xl border border-gray-200 bg-white p-6 shadow-sm sm:p-8 dark:border-gray-700 dark:bg-gray-800"
      >
        <div className="space-y-8">
          {/* Personal */}
          <Group title="Personal">
            <Field label="First Name" error={errors.first_name}>
              <input
                data-field="first_name"
                value={form.first_name}
                maxLength={MAX.first_name}
                onChange={(e) => setNamePart("first_name", e.target.value)}
                placeholder="John"
                disabled={locked}
                className={inputCls("first_name")}
              />
            </Field>

            <Field label="Last Name" error={errors.last_name}>
              <input
                data-field="last_name"
                value={form.last_name}
                maxLength={MAX.last_name}
                onChange={(e) => setNamePart("last_name", e.target.value)}
                placeholder="Doe"
                disabled={locked}
                className={inputCls("last_name")}
              />
            </Field>

            <Field
              label="Name On Card"
              error={errors.name}
              className="sm:col-span-2"
            >
              <input
                data-field="name"
                value={form.name}
                maxLength={MAX.name}
                onChange={(e) => {
                  nameEdited.current = true;
                  setField("name", e.target.value);
                }}
                placeholder="John Doe"
                disabled={locked}
                className={inputCls("name")}
              />
            </Field>

            <Field label="Date Of Birth" error={errors.date_of_birth}>
              <input
                data-field="date_of_birth"
                type="date"
                value={form.date_of_birth}
                max={today}
                onChange={(e) => setField("date_of_birth", e.target.value)}
                disabled={locked}
                className={`${inputCls("date_of_birth")} dark:scheme-dark`}
              />
            </Field>

            <Field label="Email" error={errors.email}>
              <input
                data-field="email"
                type="email"
                value={form.email}
                maxLength={MAX.email}
                onChange={(e) => setField("email", e.target.value)}
                placeholder="name@example.com"
                disabled={locked}
                className={inputCls("email")}
              />
            </Field>
          </Group>

          {/* Identity */}
          <Group title="Identity">
            <Field label="ID Type" error={errors.identity_type}>
              <div data-field="identity_type">
                <Select
                  value={
                    ID_TYPES.find((o) => o.value === form.identity_type) || null
                  }
                  onChange={(opt) =>
                    setField("identity_type", opt ? opt.value : "")
                  }
                  options={ID_TYPES}
                  placeholder="Select"
                  styles={makeSelectStyles(Boolean(errors.identity_type))}
                  menuPortalTarget={menuPortalTarget}
                  isSearchable={false}
                  isDisabled={locked}
                />
              </div>
            </Field>

            <Field label="ID Number" error={errors.identity_number}>
              <input
                data-field="identity_number"
                value={form.identity_number}
                maxLength={MAX.id_number}
                onChange={(e) => setField("identity_number", e.target.value)}
                placeholder="123456789"
                disabled={locked}
                className={inputCls("identity_number")}
              />
            </Field>

            {/* ID image — required only while nothing is on file yet */}
            <Field
              label="ID Image"
              required={!existingIdImage}
              error={errors.id_image}
              className="sm:col-span-2"
            >
              <div data-field="id_image">
                {hasPreview ? (
                  /* Framed preview — a newly picked file wins over the saved one */
                  <div
                    onDragOver={(e) => {
                      e.preventDefault();
                      setDragging(true);
                    }}
                    onDragLeave={() => setDragging(false)}
                    onDrop={handleDrop}
                    className={`rounded-xl border-2 border-dashed p-4 transition-colors ${
                      errors.id_image
                        ? "border-red-300 dark:border-red-500/40"
                        : dragging
                          ? "border-indigo-500 bg-indigo-50/50 dark:bg-indigo-500/10"
                          : "border-indigo-300 dark:border-indigo-500/40"
                    }`}
                  >
                    <div className="relative mx-auto max-w-md">
                      <div className="rounded-xl border border-gray-200 bg-white p-3 dark:border-gray-600 dark:bg-gray-700/50">
                        {previewIsPdf ? (
                          <div className="flex h-40 flex-col items-center justify-center gap-2 text-indigo-600 dark:text-indigo-300">
                            <svg
                              className="h-10 w-10"
                              fill="none"
                              stroke="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                strokeWidth={1.6}
                                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h7l5 5v11a2 2 0 01-2 2z"
                              />
                            </svg>
                            <span className="text-xs font-semibold">
                              PDF document
                            </span>
                          </div>
                        ) : previewBroken || !previewSrc ? (
                          <div className="flex h-40 flex-col items-center justify-center gap-2 text-gray-400">
                            <svg
                              className="h-10 w-10"
                              fill="none"
                              stroke="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                strokeWidth={1.6}
                                d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                              />
                            </svg>
                            <span className="text-xs">Preview unavailable</span>
                          </div>
                        ) : (
                          <img
                            src={previewSrc}
                            alt="ID document"
                            onError={() =>
                              idImage
                                ? setIdImagePreview(null)
                                : setExistingIdBroken(true)
                            }
                            className="mx-auto max-h-56 w-auto rounded-lg object-contain"
                          />
                        )}
                      </div>

                      {/* Remove — only a newly picked file can be taken back */}
                      {idImage && (
                        <button
                          type="button"
                          onClick={clearFile}
                          disabled={locked}
                          aria-label="Remove image"
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

                    {/* Caption + actions */}
                    <div className="mt-3 flex flex-wrap items-center justify-center gap-x-4 gap-y-1 text-xs">
                      <span className="max-w-[16rem] truncate text-gray-500 dark:text-gray-400">
                        {idImage
                          ? `${idImage.name} · ${humanSize(idImage.size)}`
                          : "Saved document"}
                      </span>
                      {!isExisting && (
                        <button
                          type="button"
                          onClick={() => fileInputRef.current?.click()}
                          disabled={locked}
                          className="cursor-pointer font-medium text-indigo-600 hover:underline disabled:opacity-50 dark:text-indigo-400"
                        >
                          {idImage ? "Change image" : "Replace image"}
                        </button>
                      )}
                      {!idImage && (
                        <a
                          href={existingIdImage}
                          target="_blank"
                          rel="noreferrer"
                          className="font-medium text-indigo-600 hover:underline dark:text-indigo-400"
                        >
                          View
                        </a>
                      )}
                    </div>
                  </div>
                ) : (
                  /* Nothing to show yet */
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    onDragOver={(e) => {
                      e.preventDefault();
                      setDragging(true);
                    }}
                    onDragLeave={() => setDragging(false)}
                    onDrop={handleDrop}
                    disabled={locked}
                    className={`flex w-full cursor-pointer items-center gap-3 rounded-xl border-2 border-dashed p-4 text-left transition-colors disabled:cursor-not-allowed ${
                      errors.id_image
                        ? "border-red-300 dark:border-red-500/40"
                        : dragging
                          ? "border-indigo-500 bg-indigo-50/50 dark:bg-indigo-500/10"
                          : "border-indigo-300 hover:border-indigo-500 dark:border-indigo-500/40"
                    }`}
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
                        JPG, PNG, WEBP or PDF · max {ID_IMAGE_MAX_MB} MB
                      </span>
                    </span>
                  </button>
                )}

                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/jpeg,image/jpg,image/png,image/webp,application/pdf"
                  onChange={(e) => applyFile(e.target.files?.[0])}
                  disabled={locked}
                  className="hidden"
                />
              </div>
            </Field>
          </Group>

          {/* Account details */}
          <Group title="Account Details">
            <Field
              label="Account Purpose"
              error={errors.account_purpose}
              className="sm:col-span-2"
            >
              <div data-field="account_purpose">
                <Select
                  value={
                    ACCOUNT_PURPOSES.find(
                      (o) => o.value === form.account_purpose,
                    ) || null
                  }
                  onChange={(opt) =>
                    setField("account_purpose", opt ? opt.value : "")
                  }
                  options={ACCOUNT_PURPOSES}
                  placeholder="Select account purpose"
                  styles={makeSelectStyles(Boolean(errors.account_purpose))}
                  menuPortalTarget={menuPortalTarget}
                  isSearchable={false}
                  isDisabled={locked}
                />
              </div>
            </Field>

            <Field label="Employment Status" error={errors.employment_status}>
              <div data-field="employment_status">
                <Select
                  value={
                    EMPLOYMENT_STATUSES.find(
                      (o) => o.value === form.employment_status,
                    ) || null
                  }
                  onChange={(opt) =>
                    setField("employment_status", opt ? opt.value : "")
                  }
                  options={EMPLOYMENT_STATUSES}
                  placeholder="Select status"
                  styles={makeSelectStyles(Boolean(errors.employment_status))}
                  menuPortalTarget={menuPortalTarget}
                  isSearchable={false}
                  isDisabled={locked}
                />
              </div>
            </Field>

            <Field label="Occupation" error={errors.occupation}>
              <div data-field="occupation">
                <Select
                  value={
                    OCCUPATIONS.find((o) => o.value === form.occupation) || null
                  }
                  onChange={(opt) =>
                    setField("occupation", opt ? opt.value : "")
                  }
                  options={OCCUPATIONS}
                  placeholder="Select occupation"
                  styles={makeSelectStyles(Boolean(errors.occupation))}
                  menuPortalTarget={menuPortalTarget}
                  isSearchable={false}
                  isDisabled={locked}
                />
              </div>
            </Field>
          </Group>

          {/* Address */}
          <Group title="Address">
            <Field
              label="Address"
              error={errors.address}
              className="sm:col-span-2"
            >
              <input
                data-field="address"
                value={form.address}
                maxLength={MAX.line1}
                onChange={(e) => setField("address", e.target.value)}
                placeholder="123 Main Street"
                disabled={locked}
                className={inputCls("address")}
              />
            </Field>

            <Field label="City" error={errors.city}>
              <input
                data-field="city"
                value={form.city}
                maxLength={MAX.city}
                onChange={(e) => setField("city", e.target.value)}
                placeholder="San Francisco"
                disabled={locked}
                className={inputCls("city")}
              />
            </Field>

            <Field label="State" error={errors.state}>
              <input
                data-field="state"
                value={form.state}
                maxLength={MAX.state}
                onChange={(e) => setField("state", e.target.value)}
                placeholder="CA"
                disabled={locked}
                className={inputCls("state")}
              />
            </Field>

            <Field label="Postal Code" error={errors.zip_code}>
              <input
                data-field="zip_code"
                value={form.zip_code}
                maxLength={MAX.postal_code}
                onChange={(e) => setField("zip_code", e.target.value)}
                placeholder="94111"
                disabled={locked}
                className={inputCls("zip_code")}
              />
            </Field>

            <Field label="Country" error={errors.country}>
              <div data-field="country">
                <Select
                  value={selectedCountry}
                  onChange={handleCountry}
                  options={countryOptions}
                  placeholder="Select"
                  styles={makeSelectStyles(Boolean(errors.country))}
                  menuPortalTarget={menuPortalTarget}
                  isDisabled={locked}
                />
              </div>
            </Field>

            <Field
              label="Phone"
              error={errors.phone_code || errors.phone}
              className="sm:col-span-2"
            >
              <div data-field="phone">
                <PhoneInput
                  country={(form.country || "us").toLowerCase()}
                  value={phoneValue}
                  onChange={handlePhone}
                  disabled={locked}
                  enableSearch
                  disableSearchIcon
                  countryCodeEditable={false}
                  searchPlaceholder="Search country"
                  inputProps={{ name: "phone" }}
                  containerStyle={{ width: "100%" }}
                  inputStyle={phoneStyles.input}
                  buttonStyle={phoneStyles.button}
                  dropdownStyle={phoneStyles.dropdown}
                  searchStyle={phoneStyles.search}
                />
              </div>
            </Field>
          </Group>
        </div>

        {/* Actions */}
        <div className="mt-8">
          {!isExisting && (
            <button
              type="submit"
              disabled={locked}
              className="btn-primary w-full cursor-pointer py-3.5 text-base font-semibold text-white disabled:cursor-not-allowed disabled:opacity-50"
            >
              {submitting ? "Processing..." : "Continue"}
            </button>
          )}
          <button
            type="button"
            onClick={() => router.back()}
            disabled={submitting}
            className="mt-3 w-full cursor-pointer py-1 text-sm text-gray-500 transition hover:text-gray-700 disabled:opacity-50 dark:text-gray-400 dark:hover:text-gray-200"
          >
            {isExisting ? "Back" : "Cancel"}
          </button>
        </div>
      </form>
    </div>
  );
};

export default CreateStrowalletCard;

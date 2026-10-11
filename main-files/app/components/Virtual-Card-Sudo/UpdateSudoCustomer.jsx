"use client";

import { parsePhoneNumberFromString } from "libphonenumber-js";
import { useRouter } from "next/navigation";
import { useEffect, useMemo, useRef, useState } from "react";
import toast from "react-hot-toast";
import PhoneInput from "react-phone-input-2";
import "react-phone-input-2/lib/style.css";
import Select from "react-select";
import { getSudoCustomerInfo, updateSudoCustomer } from "../../utils/api";
import Loader from "../Loader";

/* ── Backend contract: POST /user/my-card/sudo/update/customer ──────────────
   first_name           required          last_name        required
   date_of_birth        required (Y-m-d)  identity_type    required BVN/NIN/TIN
   identity_number      required number   phone_number     required full number
   line1                required          line2            nullable
   city                 required          state            required
   country              required          postal_code      required
   id_image_front       image             id_image_back    image
   address_verification image

   The form is driven by data.input_fields from GET /edit/customer, so whatever
   the API sends is what renders — the groups below only decide the layout.
─────────────────────────────────────────────────────────────────────────── */

const GROUPS = [
  {
    title: "Personal",
    fields: ["first_name", "last_name", "date_of_birth", "phone_number"],
  },
  { title: "Identity", fields: ["identity_type", "identity_number"] },
  {
    title: "Address",
    fields: ["line1", "line2", "city", "state", "postal_code", "country"],
  },
  {
    title: "Documents",
    fields: ["id_image_front", "id_image_back", "address_verification"],
  },
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

/* Sudo stores one full number (dial code + subscriber). Records written by an
   earlier version can carry the dial code twice — "1" + "18008675309" — which
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

const isFilled = (v) =>
  v !== undefined && v !== null && String(v).trim() !== "";

/* input_fields often arrives with an empty `value` — the selects always do, and
   billingAddress.line2 can be null — even though the customer record already
   holds the data. Every field therefore falls back to the customer object it
   was derived from, and then to an option flagged `selected`. */
const CUSTOMER_PATHS = {
  first_name: (c) => c?.individual?.firstName,
  last_name: (c) => c?.individual?.lastName,
  date_of_birth: (c) => c?.individual?.dob,
  identity_type: (c) => c?.individual?.identity?.type,
  identity_number: (c) => c?.individual?.identity?.number,
  phone_number: (c) => c?.phoneNumber,
  line1: (c) => c?.billingAddress?.line1,
  line2: (c) => c?.billingAddress?.line2,
  city: (c) => c?.billingAddress?.city,
  state: (c) => c?.billingAddress?.state,
  country: (c) => c?.billingAddress?.country,
  postal_code: (c) => c?.billingAddress?.postalCode,
  id_image_front: (c) => c?.individual?.documents?.idFrontUrl,
  id_image_back: (c) => c?.individual?.documents?.idBackUrl,
  address_verification: (c) => c?.individual?.documents?.addressVerificationUrl,
};

// <input type="date"> only accepts YYYY-MM-DD; dob can arrive as an ISO stamp.
const toDateInput = (v) => {
  const s = String(v ?? "").trim();
  if (!s) return "";
  const direct = s.match(/^(\d{4}-\d{2}-\d{2})/);
  if (direct) return direct[1];
  const d = new Date(s);
  return Number.isNaN(d.getTime()) ? "" : d.toISOString().slice(0, 10);
};

const resolveFieldValue = (field, customer) => {
  if (isFilled(field?.value)) return String(field.value);

  const fromCustomer = CUSTOMER_PATHS[field?.field_name]?.(customer);
  if (isFilled(fromCustomer)) return String(fromCustomer);

  const preselected = (field?.options || []).find((o) => o.selected);
  return preselected ? String(preselected.value) : "";
};

/* ── Layout helpers ────────────────────────────────────────────────────── */

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

const Field = ({ label, required, error, className = "", children }) => (
  <div className={className}>
    <label className="mb-1.5 block text-[13px] font-medium text-gray-600 dark:text-gray-300">
      {label}
      {required && <span className="ml-0.5 text-red-500">*</span>}
    </label>
    {children}
    {error && <p className="mt-1.5 text-xs text-red-500">{error}</p>}
  </div>
);

const UpdateSudoCustomer = () => {
  const router = useRouter();

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [isDark, setIsDark] = useState(false);

  const [customer, setCustomer] = useState(null);
  const [fields, setFields] = useState([]);
  const [values, setValues] = useState({});
  const [errors, setErrors] = useState({});

  // File fields: the already-stored URL, the newly picked File, its preview
  const [savedUrls, setSavedUrls] = useState({});
  const [files, setFiles] = useState({});
  const [previews, setPreviews] = useState({});
  const [brokenImages, setBrokenImages] = useState({});
  const fileInputRefs = useRef({});

  /* Load the customer + the field definitions */
  useEffect(() => {
    let mounted = true;

    const loadCustomer = async () => {
      try {
        const res = await getSudoCustomerInfo();
        if (!mounted) return;

        if (res?.message?.error) {
          setError(res.message.error[0] || "Failed to load customer details");
          return;
        }

        const list = res?.data?.input_fields || [];
        const cust = res?.data?.customer || null;
        setCustomer(cust);
        setFields(list);

        const init = {};
        const saved = {};
        list.forEach((f) => {
          const resolved = resolveFieldValue(f, cust);

          if (f.type === "file") {
            saved[f.field_name] = resolved; // already-uploaded document URL
            return;
          }
          if (f.type === "date") {
            init[f.field_name] = toDateInput(resolved);
            return;
          }
          init[f.field_name] = isPhoneField(f.field_name)
            ? normalizeFullPhone(resolved)
            : resolved;
        });
        setValues(init);
        setSavedUrls(saved);
      } catch (err) {
        if (mounted) setError("Something went wrong. Please try again later.");
      } finally {
        if (mounted) setLoading(false);
      }
    };

    loadCustomer();
    return () => {
      mounted = false;
    };
  }, []);

  /* The selects and phone widget are styled inline — track the theme */
  useEffect(() => {
    const root = document.documentElement;
    const read = () => setIsDark(root.classList.contains("dark"));
    read();

    const observer = new MutationObserver(read);
    observer.observe(root, { attributes: true, attributeFilter: ["class"] });
    return () => observer.disconnect();
  }, []);

  /* Release preview objectURLs */
  useEffect(
    () => () => {
      Object.values(previews).forEach((url) => URL.revokeObjectURL(url));
    },
    [previews],
  );

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

  const phoneStyles = useMemo(
    () => ({
      input: {
        width: "100%",
        height: "48px",
        paddingLeft: "58px",
        fontSize: "14px",
        borderRadius: "10px",
        border: `1px solid ${isDark ? "#4b5563" : "#e5e7eb"}`,
        background: isDark ? "#374151" : "#ffffff",
        color: isDark ? "#f3f4f6" : "#111827",
      },
      button: {
        border: `1px solid ${isDark ? "#4b5563" : "#e5e7eb"}`,
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
    }),
    [isDark],
  );

  const menuPortalTarget =
    typeof document !== "undefined" ? document.body : undefined;

  const today = useMemo(() => new Date().toISOString().slice(0, 10), []);

  const setValue = (name, value) => {
    setValues((p) => ({ ...p, [name]: value }));
    setErrors((p) => (p[name] ? { ...p, [name]: undefined } : p));
  };

  const applyFile = (field, file) => {
    if (!file) return;
    const name = field.field_name;

    if (!FILE_TYPES.includes(file.type)) {
      setErrors((p) => ({
        ...p,
        [name]: "Only JPG, PNG, WEBP or SVG files are allowed",
      }));
      return;
    }
    if (file.size > FILE_MAX_MB * 1024 * 1024) {
      setErrors((p) => ({
        ...p,
        [name]: `File is too large — maximum ${FILE_MAX_MB} MB`,
      }));
      return;
    }

    setFiles((p) => ({ ...p, [name]: file }));
    setPreviews((p) => {
      if (p[name]) URL.revokeObjectURL(p[name]);
      return { ...p, [name]: URL.createObjectURL(file) };
    });
    setBrokenImages((p) => ({ ...p, [name]: false }));
    setErrors((p) => ({ ...p, [name]: undefined }));
  };

  const clearFile = (name) => {
    setFiles((p) => {
      const next = { ...p };
      delete next[name];
      return next;
    });
    setPreviews((p) => {
      if (p[name]) URL.revokeObjectURL(p[name]);
      const next = { ...p };
      delete next[name];
      return next;
    });
    if (fileInputRefs.current[name]) fileInputRefs.current[name].value = "";
  };

  /* Validation — driven by each field's own `required` flag */
  const validate = () => {
    const e = {};

    fields.forEach((f) => {
      const name = f.field_name;

      if (f.type === "file") {
        if (f.required && !files[name] && !savedUrls[name]) {
          e[name] = `${f.label_name} is required`;
        }
        return;
      }

      const v = String(values[name] ?? "").trim();
      if (f.required && !v) {
        e[name] = `${f.label_name} is required`;
        return;
      }
      if (!v) return;

      if (f.type === "date" && v >= today) {
        e[name] = "Date of birth must be before today";
      }
      if (f.type === "number" && !/^\d+$/.test(v)) {
        e[name] = `${f.label_name} must be digits only`;
      }
      if (isPhoneField(name) && digitsOnly(v).length < 8) {
        e[name] = "Enter a valid phone number";
      }
    });

    return e;
  };

  const handleSubmit = async (event) => {
    event?.preventDefault();
    if (submitting) return;

    const found = validate();
    const firstKey = Object.keys(found).find((k) => found[k]);
    if (firstKey) {
      setErrors(found);
      toast.error(found[firstKey]);
      document
        .querySelector(`[data-field="${firstKey}"]`)
        ?.scrollIntoView({ behavior: "smooth", block: "center" });
      return;
    }
    setErrors({});

    const payload = new FormData();
    fields.forEach((f) => {
      const name = f.field_name;
      if (f.type === "file") {
        const file = files[name];
        // Only sent when a new file was picked — the stored one is kept otherwise.
        if (file) payload.append(name, file, file.name);
        return;
      }
      payload.append(name, String(values[name] ?? "").trim());
    });

    try {
      setSubmitting(true);
      const res = await updateSudoCustomer(payload);

      if (res?.message?.success) {
        toast.success(res.message.success[0] || "Customer details updated");
        router.push("/dashboard/Virtual-Card");
        return;
      }

      // Laravel style field errors -> show them next to the inputs
      const fieldErrors = res?.errors || res?.data?.errors;
      if (fieldErrors && typeof fieldErrors === "object") {
        const mapped = {};
        Object.entries(fieldErrors).forEach(([key, val]) => {
          mapped[key] = Array.isArray(val) ? val[0] : val;
        });
        setErrors(mapped);
        toast.error(Object.values(mapped)[0] || "Please check the form");
      } else if (res?.message?.error) {
        toast.error(res.message.error[0] || "Failed to update customer");
      } else {
        toast.error("Unexpected response. Please try again.");
      }
    } catch {
      toast.error("Failed to update customer. Please try again.");
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

  const inputCls = (name) =>
    `w-full h-12 px-4 rounded-[10px] border bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-1 disabled:opacity-60 disabled:cursor-not-allowed ${
      errors[name]
        ? "border-red-300 focus:border-red-400 focus:ring-red-400"
        : "border-gray-200 dark:border-gray-600 hover:border-indigo-200 focus:border-indigo-500 focus:ring-indigo-500"
    }`;

  /* One field, rendered from its API definition */
  const renderField = (field) => {
    const name = field.field_name;
    const label = field.label_name;
    const err = errors[name];

    if (field.type === "file") {
      const picked = files[name];
      const saved = savedUrls[name];
      const src = previews[name] || saved;
      const showImage = src && !brokenImages[name];

      return (
        <Field
          key={field.id}
          label={label}
          required={field.required && !saved}
          error={err}
          className="sm:col-span-2"
        >
          <div data-field={name}>
            {src ? (
              <div className="rounded-xl border-2 border-dashed border-indigo-300 p-4 dark:border-indigo-500/40">
                <div className="relative mx-auto max-w-md">
                  <div className="rounded-xl border border-gray-200 bg-white p-3 dark:border-gray-600 dark:bg-gray-700/50">
                    {showImage ? (
                      <img
                        src={src}
                        alt={label}
                        onError={() =>
                          setBrokenImages((p) => ({ ...p, [name]: true }))
                        }
                        className="mx-auto max-h-56 w-auto rounded-lg object-contain"
                      />
                    ) : (
                      <div className="flex h-40 items-center justify-center text-xs text-gray-400">
                        Preview unavailable
                      </div>
                    )}
                  </div>

                  {picked && (
                    <button
                      type="button"
                      onClick={() => clearFile(name)}
                      disabled={submitting}
                      aria-label={`Remove ${label}`}
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

                <div className="mt-3 flex flex-wrap items-center justify-center gap-x-4 gap-y-1 text-xs">
                  <span className="max-w-64 truncate text-gray-500 dark:text-gray-400">
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
                  {!picked && saved && (
                    <a
                      href={saved}
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
              <button
                type="button"
                onClick={() => fileInputRefs.current[name]?.click()}
                disabled={submitting}
                className={`flex w-full cursor-pointer items-center gap-3 rounded-xl border-2 border-dashed p-4 text-left transition-colors disabled:cursor-not-allowed ${
                  err
                    ? "border-red-300 dark:border-red-500/40"
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
        </Field>
      );
    }

    if (field.type === "select") {
      const options = (field.options || []).map((o) => ({
        value: o.value,
        label: o.name,
      }));
      const selected =
        options.find((o) => o.value === values[name]) ||
        options.find((o) => o.label === values[name]) ||
        null;

      return (
        <Field
          key={field.id}
          label={label}
          required={field.required}
          error={err}
        >
          <div data-field={name}>
            <Select
              value={selected}
              onChange={(opt) => setValue(name, opt ? opt.value : "")}
              options={options}
              placeholder={field.place_holder || "Choose One"}
              styles={makeSelectStyles(Boolean(err))}
              menuPortalTarget={menuPortalTarget}
              isSearchable={options.length > 8}
              isDisabled={submitting}
            />
          </div>
        </Field>
      );
    }

    // Sudo wants the full number (dial code + subscriber), digits only.
    if (isPhoneField(name)) {
      return (
        <Field
          key={field.id}
          label={label}
          required={field.required}
          error={err}
        >
          <div data-field={name}>
            <PhoneInput
              country={
                parsePhoneNumberFromString(
                  `+${values[name] || ""}`,
                )?.country?.toLowerCase() || "us"
              }
              value={values[name] || ""}
              onChange={(value) => setValue(name, digitsOnly(value))}
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
        </Field>
      );
    }

    return (
      <Field key={field.id} label={label} required={field.required} error={err}>
        <input
          data-field={name}
          type={field.type === "number" ? "text" : field.type}
          inputMode={field.type === "number" ? "numeric" : undefined}
          value={values[name] ?? ""}
          max={field.type === "date" ? today : undefined}
          onChange={(e) =>
            setValue(
              name,
              field.type === "number"
                ? digitsOnly(e.target.value)
                : e.target.value,
            )
          }
          placeholder={field.place_holder}
          disabled={submitting}
          className={`${inputCls(name)} ${
            field.type === "date" ? "dark:scheme-dark" : ""
          }`}
        />
      </Field>
    );
  };

  // Lay the API fields out in known groups; anything unexpected still renders.
  const grouped = GROUPS.map((g) => ({
    title: g.title,
    items: g.fields
      .map((n) => fields.find((f) => f.field_name === n))
      .filter(Boolean),
  })).filter((g) => g.items.length > 0);

  const placed = new Set(GROUPS.flatMap((g) => g.fields));
  const rest = fields.filter((f) => !placed.has(f.field_name));
  if (rest.length) grouped.push({ title: "Other", items: rest });

  const status = customer?.status;

  const formatDate = (v) => {
    if (!v) return null;
    const d = new Date(v);
    return Number.isNaN(d.getTime())
      ? null
      : d.toLocaleDateString("en-US", {
          year: "numeric",
          month: "short",
          day: "numeric",
        });
  };

  /* Read-only facts the API owns — no input field carries them */
  const summary = [
    ["Name", customer?.name],
    ["Email", customer?.emailAddress],
    ["Type", customer?.type],
    ["Customer ID", customer?._id],
    ["Created", formatDate(customer?.createdAt)],
    ["Last updated", formatDate(customer?.updatedAt)],
  ].filter(([, v]) => isFilled(v));

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

      {/* Customer summary */}
      {(summary.length > 0 || status) && (
        <div className="mb-6 rounded-2xl border border-gray-200 bg-white p-5 shadow-sm dark:border-gray-700 dark:bg-gray-800">
          <div className="mb-4 flex items-center justify-between gap-3">
            <p className="text-xs font-semibold tracking-wider text-gray-400 uppercase dark:text-gray-500">
              Sudo Customer
            </p>
            {status && (
              <span
                className={`inline-flex items-center rounded-full px-3 py-1 text-xs font-medium capitalize ${
                  String(status).toLowerCase() === "active"
                    ? "bg-emerald-50 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-300"
                    : "bg-amber-50 text-amber-700 dark:bg-amber-500/10 dark:text-amber-300"
                }`}
              >
                {status}
              </span>
            )}
          </div>
          <dl className="grid grid-cols-1 gap-x-6 gap-y-3 sm:grid-cols-2">
            {summary.map(([label, value]) => (
              <div key={label} className="min-w-0">
                <dt className="text-[11px] tracking-wide text-gray-400 uppercase dark:text-gray-500">
                  {label}
                </dt>
                <dd className="truncate text-sm text-gray-800 dark:text-gray-100">
                  {value}
                </dd>
              </div>
            ))}
          </dl>
        </div>
      )}

      <form
        onSubmit={handleSubmit}
        noValidate
        className="rounded-2xl border border-gray-200 bg-white p-6 shadow-sm sm:p-8 dark:border-gray-700 dark:bg-gray-800"
      >
        <div className="space-y-8">
          {grouped.map((g) => (
            <Group key={g.title} title={g.title}>
              {g.items.map((f) => renderField(f))}
            </Group>
          ))}
        </div>

        {/* Actions */}
        <div className="mt-8">
          <button
            type="submit"
            disabled={submitting}
            className="btn-primary w-full cursor-pointer py-3.5 text-base font-semibold text-white disabled:cursor-not-allowed disabled:opacity-50"
          >
            {submitting ? "Processing..." : "Save Changes"}
          </button>
          <button
            type="button"
            onClick={() => router.back()}
            disabled={submitting}
            className="mt-3 w-full cursor-pointer py-1 text-sm text-gray-500 transition hover:text-gray-700 disabled:opacity-50 dark:text-gray-400 dark:hover:text-gray-200"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
};

export default UpdateSudoCustomer;

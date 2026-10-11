/* eslint-disable @next/next/no-img-element */
"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import {
  getStrowalletCreateInfo,
  updateStrowalletCustomer,
  updateStrowalletCustomerStatus
} from "../../utils/api";
import Loader from "../Loader";
import CreateCardCustomer from "./CreateCardCustomer";
import CreateCardPage from "./CreateCardPage";
import { useTranslations } from "next-intl";

/* ===========================
   KYC Level Resolution Helpers
- Determine KYC status level from status string
   - Generate appropriate badge styling
   =========================== */
const resolveKycLevel = (status) => {
  const s = (status || "").toLowerCase();
  if (s.includes("high kyc")) return "success";
  if (s.includes("low kyc") || s.includes("unreview kyc")) return "warning";
  if (s.includes("reject kyc") || s.includes("fail kyc")) return "danger";
  return "warning";
};

const getStatusBadgeStyle = (status) => {
  const level = resolveKycLevel(status);
  if (level === "success")
    return "bg-emerald-50 text-emerald-700 border-emerald-200 dark:bg-emerald-900/30 dark:text-emerald-400 dark:border-emerald-700";
  if (level === "warning")
    return "bg-amber-50 text-amber-700 border-amber-200 dark:bg-amber-900/30 dark:text-amber-400 dark:border-amber-700";
  if (level === "danger")
    return "bg-red-50 text-red-700 border-red-200 dark:bg-red-900/30 dark:text-red-400 dark:border-red-700";
  return "bg-gray-50 text-gray-700 border-gray-200 dark:bg-gray-700/40 dark:text-gray-300 dark:border-gray-600";
};

/* ===========================
   Main Component
   - Manages virtual card creation flow
   - Handles KYC status display and updates
=========================== */
export default function CreateVirtualCard() {
  const t = useTranslations("CreateVirtualCard");

  /* ===========================
     Router & State Initialization
  =========================== */
  const router = useRouter();
  const [info, setInfo] = useState(null);
  console.log(info);
  const [loading, setLoading] = useState(true);
  const [fetchError, setFetchError] = useState(null);

  const [showUpdateForm, setShowUpdateForm] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  /* ===========================
     Computed Values
     - Filter allowed update fields
  =========================== */
  const allowedUpdateFields =
    info?.customer_create_fields
      ?.filter((f) =>
        ["first_name", "last_name", "user_image", "id_image_font"].includes(
          f.field_name,
        ),
      )
      .map((f) => f.field_name) || [];

  const [formValues, setFormValues] = useState({});
  const [filePreviews, setFilePreviews] = useState({});

  /* ===========================
     Initial Data Fetch Effect
  =========================== */
  useEffect(() => {
    fetchInfo();
  }, []);

  /* ===========================
     API Data Fetching
     - Retrieve Strowallet customer info
     - Pre-populate form with existing data
  =========================== */
  const fetchInfo = async () => {
    setLoading(true);
    setFetchError(null);
    try {
      const res = await getStrowalletCreateInfo();
      console.log(res);
      if (res?.message?.error) {
        const err = res.message.error[0] || t("errors.loadFailed");
        setFetchError(err);
        toast.error(err);
        return;
      }
      if (res?.data) {
        setInfo(res.data);

        // call status update if customer already exists
        if (res.data.customer_exist_status) {
          updateStrowalletCustomerStatus().catch(() => {});  // sometimes need to off this to check the status update form, because if the status is updated to high kyc, the form will show, but I need to test the form
        }

        // Pre-populate form if customer exists
        if (res.data.customer_exist) {
          const exist = res.data.customer_exist;
          setFormValues({
            first_name: exist.firstName || "",
            last_name: exist.lastName || "",
          });
          setFilePreviews({
            id_image_font: exist.idImage || null,
            user_image: exist.userPhoto || null,
          });
        }
      }
    } catch (err) {
      const msg = t("errors.genericError");
      setFetchError(msg);
      toast.error(msg);
    } finally {
      setLoading(false);
    }
  };

  // ────────────────────────────────────────────────
  //  Early return when KYC is already "high kyc"
  // ────────────────────────────────────────────────
  if (
    !loading &&
    info?.customer_kyc_status?.toLowerCase().includes("high kyc")
  ) {
    return <CreateCardPage />;
  }

  /* ===========================
     Helper Functions
  =========================== */
  const getFieldFromApi = (fieldName) => {
    return (
      info?.customer_create_fields?.find((f) => f.field_name === fieldName) ||
      {}
    );
  };

  /* ===========================
     Form Input Handlers
  =========================== */
  const handleTextChange = (fieldName, value) => {
    setFormValues((prev) => ({ ...prev, [fieldName]: value }));
  };

  const handleFileChange = (fieldName, file) => {
    if (!file) return;
    setFormValues((prev) => ({ ...prev, [fieldName]: file }));
    
    // Generate preview for uploaded file
    const reader = new FileReader();
    reader.onloadend = () => {
      setFilePreviews((prev) => ({ ...prev, [fieldName]: reader.result }));
    };
    reader.readAsDataURL(file);
  };

  /* ===========================
     Form Submission Handler
     - Update customer KYC information
     - Handle success/error responses
  =========================== */
  const handleSubmitUpdate = async (e) => {
    e.preventDefault();
    if (submitting) return;

    setSubmitting(true);
    
    // Build FormData with allowed fields only
    const formData = new FormData();

    allowedUpdateFields.forEach((field) => {
      const value = formValues[field];
      if (value) {
        if (value instanceof File) {
          formData.append(field, value);
        } else if (typeof value === "string" && value.trim()) {
          formData.append(field, value.trim());
        }
      }
    });

    try {
      const res = await updateStrowalletCustomer(formData);
      if (res?.message?.success) {
        const msg = res.message.success[0] || t("success.customerUpdated");
        toast.success(msg);
        
        // Reset form and refresh data after successful update
        setTimeout(() => {
          setShowUpdateForm(false);
          setFormValues((prev) => ({
            ...prev,
            id_image_font: null,
            user_image: null,
          }));
          setFilePreviews({});
          fetchInfo();
          router.refresh();
        }, 3500);
      } else if (res?.message?.error) {
        const errMsg =
          res.message.error[0] || t("errors.updateFailed");
        toast.error(errMsg);
      } else {
        toast.error(t("errors.unexpectedResponse"));
      }
    } catch (err) {
      toast.error(t("errors.updateFailed"));
    } finally {
      setSubmitting(false);
    }
  };

  /* ===========================
     Loading State UI
  =========================== */
  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-[60vh]">
        <Loader />
      </div>
    );
  }

  /* ===========================
     Error State UI
  =========================== */
  if (fetchError) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-10 text-center">
        <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-2xl p-8 shadow-sm">
          <div className="flex justify-center mb-4">
            <div className="w-14 h-14 bg-red-100 dark:bg-red-900/40 rounded-full flex items-center justify-center">
              <svg
                className="w-7 h-7 text-red-600 dark:text-red-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
            </div>
          </div>
          <h3 className="text-lg font-semibold text-red-900 dark:text-red-300 mb-2">
            {t("errors.loadError")}
          </h3>
          <p className="text-red-700 dark:text-red-400 mb-6">{fetchError}</p>
          <button
            onClick={fetchInfo}
            className="btn-primary px-8 py-3 rounded-xl font-medium shadow-lg hover:shadow-xl transition-all duration-200 cursor-pointer"
          >
            {t("buttons.tryAgain")}
          </button>
        </div>
      </div>
    );
  }

  /* ===========================
     New Customer Flow
     - Redirect to customer creation if no existing customer
  =========================== */
  if (!info?.customer_exist_status) {
    return (
      <CreateCardCustomer createFields={info?.customer_create_fields || []} />
    );
  }

  /* ===========================
     Existing Customer Data
  =========================== */  
  const { customer_kyc_status, customer_low_kyc_text } = info;
  const kycLevel = resolveKycLevel(customer_kyc_status);
  const showUpdateButton = kycLevel !== "success";

  /* ===========================
     Main UI - KYC Status & Update Form
  =========================== */
  return (
    <>
      <div className="max-w-5xl mx-auto">
        <div className="mb-10">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-gray-100 mb-3 tracking-tight">
            {t("header.title")}
          </h1>
          <p className="text-base text-gray-600 dark:text-gray-400">
            {t("header.subtitle")}
          </p>
        </div>

        {/* Main Content Card */}
        <div className="bg-white dark:bg-gray-800 rounded-3xl shadow-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
          {/* Card Header */}
          <div className="bg-linear-to-r from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20 px-4 sm:px-6 md:px-8 py-4 sm:py-6 border-b border-gray-200 dark:border-gray-700">
            <h2 className="text-xl font-bold text-gray-900 dark:text-gray-100 flex items-center gap-3">
              <svg
                className="w-7 h-7 text-blue-600 dark:text-blue-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d={
                    showUpdateForm
                      ? "M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                      : "M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                  }
                />
              </svg>
              {showUpdateForm ? t("updateForm.title") : t("kycStatus.title")}
            </h2>
          </div>

          <div className="p-4 sm:p-6 md:p-8 space-y-6 md:space-y-8">
            {/* ===========================
                 Update Form Section
            =========================== */}  
            {showUpdateForm ? (
              <div onSubmit={handleSubmitUpdate}>
                {/* Text Input Fields */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                  {allowedUpdateFields
                    .filter((fieldName) => {
                      const field = getFieldFromApi(fieldName);
                      return field.field_name && field.type !== "file";
                    })
                    .map((fieldName) => {
                      const field = getFieldFromApi(fieldName);
                      return (
                        <div key={fieldName} className="space-y-2">
                          <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300">
                            {field.label_name}
                            {field.site_label && (
                              <span className="text-xs text-gray-500 dark:text-gray-400 font-normal block mt-1">
                                {field.site_label}
                              </span>
                            )}
                          </label>
                          <input
                            type={field.type === "date" ? "date" : "text"}
                            value={formValues[fieldName] || ""}
                            onChange={(e) =>
                              handleTextChange(fieldName, e.target.value)
                            }
                            className="mt-1 block w-full rounded-xl border border-gray-300 dark:border-gray-600 
                              bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-100
                              placeholder-gray-400 dark:placeholder-gray-500
                              shadow-sm focus:border-primary-500 dark:focus:border-primary-400
                              focus:ring-2 focus:ring-primary-200 dark:focus:ring-primary-400
                              sm:text-sm px-4 py-3 transition-all duration-200 cursor-text"
                            disabled={submitting}
                          />
                        </div>
                      );
                    })}
                </div>

                {/* File Upload Fields */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {allowedUpdateFields
                    .filter((fieldName) => {
                      const field = getFieldFromApi(fieldName);
                      return field.field_name && field.type === "file";
                    })
                    .map((fieldName) => {
                      const field = getFieldFromApi(fieldName);
                      return (
                        <div key={fieldName} className="space-y-3">
                          <label className="block text-sm font-semibold text-gray-700 dark:text-gray-300">
                            {field.label_name}
                            {field.site_label && (
                              <span className="text-xs text-gray-500 dark:text-gray-400 font-normal block mt-1">
                                {field.site_label}
                              </span>
                            )}
                          </label>

                          {/* File Preview */}
                          {filePreviews[fieldName] && (
                            <div className="p-4 bg-gray-50 dark:bg-gray-700/50 rounded-xl border border-gray-200 dark:border-gray-600">
                              <img
                                src={filePreviews[fieldName]}
                                alt={field.label_name}
                                className="h-32 w-full object-contain rounded-lg border-2 border-gray-200 dark:border-gray-600"
                              />
                            </div>
                          )}

                          {/* File Input */}
                          <input
                            type="file"
                            accept="image/*"
                            onChange={(e) =>
                              handleFileChange(fieldName, e.target.files?.[0])
                            }
                            className="block w-full text-sm text-gray-600 dark:text-gray-400 cursor-pointer
                              file:mr-4 file:py-3 file:px-6
                              file:rounded-xl file:border-0
                              file:text-sm file:font-semibold
                              file:bg-primary-50 dark:file:bg-primary-900/40
                              file:text-primary-700 dark:file:text-primary-300
                              hover:file:bg-primary-100 dark:hover:file:bg-primary-900/60
                              file:cursor-pointer file:transition-all file:duration-200
                              border border-gray-300 dark:border-gray-600 rounded-xl
                              bg-white dark:bg-gray-700
                              focus:outline-none focus:ring-2 focus:ring-primary-400 dark:focus:ring-primary-500
                              focus:border-transparent"
                            disabled={submitting}
                          />
                        </div>
                      );
                    })}
                </div>

                {/* Form Action Buttons */}
                <div className="flex flex-col sm:flex-row justify-center gap-4 pt-6 border-t border-gray-200 dark:border-gray-700 mt-8">
                  <button
                    type="button"
                    onClick={() => setShowUpdateForm(false)}
                    className="w-full sm:w-auto px-8 py-3 border-2 border-gray-300 dark:border-gray-600 rounded-xl 
                      text-gray-700 dark:text-gray-300 font-semibold 
                      hover:bg-gray-50 dark:hover:bg-gray-700/50 
                      hover:border-gray-400 dark:hover:border-gray-500 
                      transition-all duration-200 cursor-pointer"
                    disabled={submitting}
                  >
                    {t("buttons.cancel")}
                  </button>

                  <button
                    type="button"
                    onClick={handleSubmitUpdate}
                    disabled={submitting}
                    className="btn-primary w-full sm:w-auto px-10 py-3 font-semibold rounded-xl shadow-lg 
                      hover:shadow-xl transition-all duration-200 disabled:opacity-50 
                      disabled:cursor-not-allowed cursor-pointer"
                  >
                    {submitting ? t("buttons.updating") : t("buttons.submitUpdate")}
                  </button>
                </div>
              </div>
            ) : (
              /* ===========================
                   KYC Status Display Section
              =========================== */
              <>
                <div className="bg-linear-to-br from-gray-50 to-blue-50 dark:from-gray-700/50 dark:to-blue-900/20 rounded-2xl p-6 border border-gray-200 dark:border-gray-600">
                  <p className="text-sm font-semibold text-gray-600 dark:text-gray-400 mb-3 uppercase tracking-wide">
                    {t("kycStatus.currentStatus")}
                  </p>
                  <span
                    className={`inline-flex px-6 py-3 rounded-xl text-base font-bold border-2 shadow-sm ${getStatusBadgeStyle(
                      customer_kyc_status,
                    )}`}
                  >
                    {customer_kyc_status || t("kycStatus.unreviewed")}
                  </span>
                </div>

                {/* KYC Status Message (if provided) */}
                {customer_low_kyc_text && (
                  <div
                    className={`rounded-2xl p-6 border-2 shadow-sm ${
                      kycLevel === "success"
                        ? "bg-primary-50 border-primary-200 text-primary-800 dark:bg-primary-900/20 dark:border-primary-700 dark:text-primary-300"
                        : kycLevel === "danger"
                          ? "bg-red-50 border-red-200 text-red-800 dark:bg-red-900/20 dark:border-red-700 dark:text-red-300"
                          : "bg-amber-50 border-amber-200 text-amber-800 dark:bg-amber-900/20 dark:border-amber-700 dark:text-amber-300"
                    }`}
                  >
                    <div className="flex gap-3">
                      <div className="shrink-0">
                        {kycLevel === "success" ? (
                          <svg
                            className="w-6 h-6 text-primary-600 dark:text-primary-400"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                            />
                          </svg>
                        ) : kycLevel === "danger" ? (
                          <svg
                            className="w-6 h-6 text-red-600 dark:text-red-400"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
                            />
                          </svg>
                        ) : (
                          <svg
                            className="w-6 h-6 text-amber-600 dark:text-amber-400"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                            />
                          </svg>
                        )}
                      </div>
                      <p className="leading-relaxed font-medium">
                        {customer_low_kyc_text}
                      </p>
                    </div>
                  </div>
                )}

                {/* Success Message (when no custom text provided) */}
                {kycLevel === "success" && !customer_low_kyc_text && (
                  <div className="bg-primary-50 dark:bg-primary-900/20 border-2 border-primary-200 dark:border-primary-700 rounded-2xl p-6 shadow-sm">
                    <div className="flex gap-3 items-center">
                      <svg
                        className="w-6 h-6 text-primary-600 dark:text-primary-400 shrink-0"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                        />
                      </svg>
                      <p className="text-primary-800 dark:text-primary-300 font-medium">
                        {t("kycStatus.successMessage")}
                      </p>
                    </div>
                  </div>
                )}

                {/* Update Button (shown when KYC is not successful) */}
                {showUpdateButton && (
                  <div className="pt-6 text-center border-t border-gray-200 dark:border-gray-700">
                    <button
                      onClick={() => setShowUpdateForm(true)}
                      className="btn-primary w-full sm:w-auto inline-flex justify-center items-center gap-2 px-10 py-4 font-semibold 
                        rounded-xl shadow-lg hover:shadow-xl transition-all duration-200 cursor-pointer"
                    >
                      <svg
                        className="w-5 h-5"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                        />
                      </svg>
                      {t("buttons.updateCustomer")}
                    </button>
                  </div>
                )}
              </>
            )}
          </div>
        </div>
      </div>
    </>
  );
}
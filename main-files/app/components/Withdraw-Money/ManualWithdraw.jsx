"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl"; 
import { submitFinalWithdraw } from "../../utils/api";

export default function ManualWithdraw() {
  const router = useRouter();
  const t = useTranslations("manualWithdraw"); 

  const [withdrawData, setWithdrawData] = useState(null);
  const [formValues, setFormValues] = useState({});
  const [submitting, setSubmitting] = useState(false);
  const [pageError, setPageError] = useState(null);

  // Load pending withdrawal data from sessionStorage
  useEffect(() => {
    const savedData = sessionStorage.getItem("pendingWithdrawData");

    if (savedData) {
      try {
        const parsed = JSON.parse(savedData);
        setWithdrawData(parsed);

        // Initialize form values
        const initial = {};
        parsed.input_fields?.forEach((field) => {
          initial[field.name] = ""; // empty string for all fields
        });
        setFormValues(initial);
      } catch (err) {
        setPageError(t("errors.loadFailed"));
        toast.error(t("errors.loadFailedToast"));
      }
    } else {
      setPageError(t("errors.noPending"));

      router.replace("/dashboard/withdraw-money"); // redirect back to withdraw page
    }
  }, [router]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormValues((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async () => {
    // Client-side required fields check
    const requiredFields =
      withdrawData?.input_fields?.filter((f) => f.required) || [];
    const missing = requiredFields.find((f) => !formValues[f.name]?.trim());

    if (missing) {
      return toast.error(t("errors.fillField", { label: missing.label }));
    }

    setSubmitting(true);
    setPageError(null);

    try {
      const payload = {
        trx: withdrawData.trx,
        ...formValues,
      };

      const response = await submitFinalWithdraw(payload);

      if (response?.message?.success) {
        // Show success message exactly from server
        const successMsg =
          response.message.success[0] ||
          t("success.submitted");
        toast.success(successMsg);

        // Clean up
        sessionStorage.removeItem("pendingWithdrawData");

        // Redirect to dashboard or success page
        router.push("/dashboard");
      } else {
        // Show server error message exactly as received
        const errorMsg =
          response?.message?.error?.[0] ||
          t("errors.submitFailed");
        toast.error(errorMsg);
        setPageError(errorMsg);
      }
    } catch (err) {
      const fallback = t("errors.unexpected");
      toast.error(fallback);
      setPageError(fallback);
      // console.error("Final withdrawal submission error:", err);
      toast.error(t("errors.submissionFailed"));
    } finally {
      setSubmitting(false);
    }
  };

  if (!withdrawData) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
        <p className="text-gray-600 dark:text-gray-400 text-lg">
          {t("loading")}
        </p>
      </div>
    );
  }

  return (
  <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl dark:shadow-gray-950/40 p-8 w-full">
    {/* Header */}
    <div className="text-center mb-8">
      <h1 className="text-2xl font-bold text-gray-800 dark:text-gray-100 mb-4">
        {t("title", {
          gateway:
            withdrawData.gateway_currency_name
              .split(" ")
              .slice(0, -1)
              .join(" "),
        })}
      </h1>

      <div
        className="text-gray-600 dark:text-gray-300 text-base prose max-w-none dark:prose-invert"
        dangerouslySetInnerHTML={{ __html: withdrawData.details || "" }}
      />
    </div>

    {/* Dynamic Form */}
    <div className="space-y-6">
      {withdrawData.input_fields?.map((field) => (
        <div key={field.name}>
          <label className="block text-gray-800 dark:text-gray-200 font-medium mb-2">
            {field.label}
            {field.required && (
              <span className="text-red-500 ml-1">*</span>
            )}
          </label>

          <input
            type={field.type}
            name={field.name}
            value={formValues[field.name] || ""}
            onChange={handleChange}
            required={field.required}
            placeholder={field.label}
            className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 dark:focus:ring-primary-600 text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-800 placeholder-gray-400 dark:placeholder-gray-500"
          />
        </div>
      ))}
    </div>

    {/* Submit Button */}
    <button
      onClick={handleSubmit}
      disabled={submitting}
      className={`cursor-pointer w-full mt-8 py-3 px-6 rounded-lg btn-primary
        hover:opacity-90
        ${submitting ? "opacity-70 cursor-wait" : ""}
        disabled:opacity-50 disabled:cursor-not-allowed
        focus:outline-none focus:ring-2 focus:ring-primary-400 dark:focus:ring-primary-600 focus:ring-offset-2 dark:focus:ring-offset-gray-900`}
    >
      {submitting ? t("button.submitting") : t("button.confirm")}
    </button>
  </div>
);
}
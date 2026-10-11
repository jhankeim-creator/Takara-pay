"use client";

import { useState } from "react";
import toast from "react-hot-toast";
import PhoneInput from "react-phone-input-2";
import "react-phone-input-2/lib/style.css";
import { createStrowalletCustomer } from "../../utils/api";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";

export default function CreateCardCustomer({ createFields }) {
  const [formData, setFormData] = useState({});
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const t = useTranslations("CreateCardCustomer");

  const handleInputChange = (fieldName, value) => {
    setFormData((prev) => ({
      ...prev,
      [fieldName]: value,
    }));
  };

  const handleFileChange = (fieldName, file) => {
    setFormData((prev) => ({
      ...prev,
      [fieldName]: file,
    }));
  };

  const handlePhoneChange = (value, country) => {
    handleInputChange("phone_combined", value);
    handleInputChange("phone_code", country.dialCode);
    handleInputChange("phone", value.replace(`+${country.dialCode}`, ""));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    setLoading(true);

    try {
      const submitData = { ...formData };

      // ──────────────────────────────────────────────────────────────
      // Rename email → customer_email
      if (submitData.email) {
        submitData.customer_email = submitData.email;
        delete submitData.email;
      }
      // ──────────────────────────────────────────────────────────────

      // ──────────────────────────────────────────────────────────────
      // Make sure phone_code has + prefix
      if (submitData.phone_code && !submitData.phone_code.startsWith("+")) {
        submitData.phone_code = "+" + submitData.phone_code;
      }
      // ──────────────────────────────────────────────────────────────

      if (submitData.phone_combined) {
        const fullPhone = submitData.phone_combined.replace(/\s+/g, "").trim();

        const match = fullPhone.match(/^\+(\d{1,4})(.+)$/);
        if (match) {
          submitData.phone_code = "+" + match[1];
          submitData.phone = match[2].replace(/^0+/, "");
        }

        delete submitData.phone_combined;
      }

      const formDataToSend = new FormData();

      Object.entries(submitData).forEach(([key, value]) => {
        if (value instanceof File) {
          formDataToSend.append(key, value);
        } else if (value !== undefined && value !== null && value !== "") {
          formDataToSend.append(key, value);
        }
      });

      const response = await createStrowalletCustomer(formDataToSend);

      if (response?.message?.error && Array.isArray(response.message.error)) {
        response.message.error.forEach((errMsg) => {
          toast.error(errMsg);
        });
      } else if (
        response?.data ||
        response?.message?.success ||
        response?.status === "success"
      ) {
        toast.success(t("customerCreated"));
        setFormData({}); // optional reset

        // ─── Redirect after success ───
        router.push("/dashboard");
      } else {
        toast.error(t("somethingWentWrong"));
      }
    } catch (error) {
      toast.error(t("failedToCreateCustomer"));
      // console.error("Create customer error:", error);
    } finally {
      setLoading(false);
    }
  };

  // Helper to safely get field metadata
  const getField = (name) =>
    createFields.find((f) => f.field_name === name) || {};

  const getPlaceholder = (name) => {
    const placeholders = {
      first_name: t("placeholders.firstName"),
      last_name: t("placeholders.lastName"),
      house_number: t("placeholders.houseNumber"),
      address: t("placeholders.address"),
      zip_code: t("placeholders.zipCode"),
    };

    return placeholders[name] || `${t("enter")} ${name.replace(/_/g, " ").toLowerCase()}`;
  };

  return (
    <>
      <div className="mx-auto w-full max-w-7xl">
        <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 sm:p-8 lg:p-10 transition-colors duration-200">
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
              {t("title")} 
            </h2>
            <p className="text-gray-600 dark:text-gray-400 mt-2 transition-colors">
              {t("description")}
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-5">
            {/* Row 1: First Name + Last Name */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {["first_name", "last_name"].map((name) => {
                const field = getField(name);
                if (!field.field_name) return null;
                return (
                  <div key={name}>
                    <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2 transition-colors">
                      {field.label_name ||
                        t(`fields.${name}`, {
                          defaultValue: name.replace(/_/g, " "),
                        })}
                      <span className="ml-1 text-red-500">*</span>
                      {field.site_label && (
                        <span className="ml-2 text-xs font-medium text-gray-600 dark:text-gray-400">
                          ({field.site_label})
                        </span>
                      )}
                    </label>
                    <input
                      type="text"
                      value={formData[name] || ""}
                      onChange={(e) => handleInputChange(name, e.target.value)}
                      required
                      className="w-full h-12 px-4 text-gray-900 font-medium dark:text-white bg-white dark:bg-gray-800 border-2 border-gray-200 dark:border-gray-700 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-100 dark:focus:ring-primary-500/30 transition-all"
                      placeholder={getPlaceholder(name)}
                    />
                  </div>
                );
              })}
            </div>

            {/* Row 2: Phone + Email */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Phone - Left */}
              <div>
                <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2 transition-colors">
                  {t("fields.phone")}
                  <span className="ml-1 text-red-500">*</span>
                  {getField("phone")?.site_label && (
                    <span className="text-xs font-normal text-gray-500 dark:text-gray-400 ml-2">
                      ({getField("phone").site_label})
                    </span>
                  )}
                </label>

                <PhoneInput
                  country="us"
                  value={formData.phone_combined || ""}
                  onChange={handlePhoneChange}
                  inputProps={{
                    name: "phone",
                    required: true,
                  }}
                  containerStyle={{ width: "100%" }}
                  inputStyle={{
                    width: "100%",
                    height: "48px",
                    padding: "12px 14px 12px 52px",
                    border: "2px solid",
                    borderRadius: "12px",
                    fontSize: "15px",
                    fontWeight: "500",
                    // Dynamic dark/light colors via inline style (this is the key fix)
                    backgroundColor:
                      document.documentElement.classList.contains("dark")
                        ? "#1f2937"
                        : "#ffffff",
                    color: document.documentElement.classList.contains("dark")
                      ? "#f3f4f6"
                      : "#111827",
                    borderColor: document.documentElement.classList.contains(
                      "dark",
                    )
                      ? "#374151"
                      : "#e5e7eb",
                  }}
                  buttonStyle={{
                    border: "2px solid",
                    borderRight: "none",
                    borderRadius: "12px 0 0 12px",
                    backgroundColor:
                      document.documentElement.classList.contains("dark")
                        ? "#1f2937"
                        : "#f9fafb",
                    borderColor: document.documentElement.classList.contains(
                      "dark",
                    )
                      ? "#374151"
                      : "#e5e7eb",
                  }}
                  dropdownStyle={{
                    borderRadius: "12px",
                    boxShadow: "0 10px 25px rgba(0,0,0,0.1)",
                    backgroundColor:
                      document.documentElement.classList.contains("dark")
                        ? "#1f2937"
                        : "#ffffff",
                    color: document.documentElement.classList.contains("dark")
                      ? "#f3f4f6"
                      : "#111827",
                  }}
                  placeholder={t("placeholders.phone")}
                />
              </div>

              {/* Email - Right (unchanged, already good) */}
              <div>
                <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2 transition-colors">
                  {getField("email").label_name || t("fields.email")}
                  {getField("email").site_label && (
                    <span className="text-xs font-normal text-gray-500 dark:text-gray-400 ml-2">
                      ({getField("email").site_label})
                    </span>
                  )}
                  <span className="ml-1 text-red-500">*</span>
                </label>
                <input
                  type="email"
                  value={formData.email || ""}
                  onChange={(e) => handleInputChange("email", e.target.value)}
                  required
                  className="w-full h-12 px-4 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border-2 border-gray-200 dark:border-gray-700 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-100 dark:focus:ring-primary-500/30 transition-all"
                  placeholder={t("placeholders.email")}
                />
              </div>
            </div>

            {/* Row 3: Date of Birth + House Number */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {["date_of_birth", "house_number"].map((name) => {
                const field = getField(name);
                if (!field.field_name) return null;
                return (
                  <div key={name}>
                    <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2 transition-colors">
                      {field.label_name ||
                        t(`fields.${name}`, {
                          defaultValue: name.replace(/_/g, " "),
                        })}
                      <span className="ml-1 text-red-500">*</span>
                      {field.site_label && (
                        <span className="text-xs font-normal text-gray-500 dark:text-gray-400 ml-2">
                          ({field.site_label})
                        </span>
                      )}
                    </label>
                    {name === "date_of_birth" ? (
                      <input
                        type="date"
                        value={formData[name] || ""}
                        onChange={(e) =>
                          handleInputChange(name, e.target.value)
                        }
                        required
                        className="w-full h-12 px-4 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border-2 border-gray-200 dark:border-gray-700 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-100 dark:focus:ring-primary-500/30 transition-all"
                      />
                    ) : (
                      <input
                        type="text"
                        value={formData[name] || ""}
                        onChange={(e) =>
                          handleInputChange(name, e.target.value)
                        }
                        required
                        className="w-full h-12 px-4 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border-2 border-gray-200 dark:border-gray-700 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-100 dark:focus:ring-primary-500/30 transition-all"
                        placeholder={getPlaceholder(name)}
                      />
                    )}
                  </div>
                );
              })}
            </div>

            {/* Row 4: Address + Zip Code */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {["address", "zip_code"].map((name) => {
                const field = getField(name);
                if (!field.field_name) return null;
                return (
                  <div key={name}>
                    <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2 transition-colors">
                      {field.label_name ||
                        t(`fields.${name}`, {
                          defaultValue: name.replace(/_/g, " "),
                        })}
                      <span className="ml-1 text-red-500">*</span>
                      {field.site_label && (
                        <span className="text-xs font-normal text-gray-500 dark:text-gray-400 ml-2">
                          ({field.site_label})
                        </span>
                      )}
                    </label>
                    <input
                      type="text"
                      value={formData[name] || ""}
                      onChange={(e) => handleInputChange(name, e.target.value)}
                      required
                      className="w-full h-12 px-4 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border-2 border-gray-200 dark:border-gray-700 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-100 dark:focus:ring-primary-500/30 transition-all"
                      placeholder={getPlaceholder(name)}
                    />
                  </div>
                );
              })}
            </div>

            {/* Full-width file upload fields */}
            {createFields
              .filter(
                (field) =>
                  field.type === "file" &&
                  ![
                    "first_name",
                    "last_name",
                    "phone",
                    "phone_code",
                    "email",
                    "date_of_birth",
                    "house_number",
                    "address",
                    "zip_code",
                  ].includes(field.field_name),
              )
              .map((field) => (
                <div key={field.id} className="pt-5">
                  <label className="block text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2 transition-colors">
                    {field.label_name ||
                      t(`fields.${field.field_name}`, {
                        defaultValue: field.field_name.replace(/_/g, " "),
                      })}
                    <span className="ml-1 text-red-500">*</span>
                    {field.site_label && (
                      <span className="text-xs font-normal text-gray-500 dark:text-gray-400 ml-2">
                        ({field.site_label})
                      </span>
                    )}
                  </label>
                  <input
                    type="file"
                    accept="image/*"
                    onChange={(e) =>
                      handleFileChange(
                        field.field_name,
                        e.target.files[0] || null,
                      )
                    }
                    required
                    className="w-full text-sm text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:bg-primary-50 dark:file:bg-primary-900/40 file:text-primary-700 dark:file:text-primary-300 hover:file:bg-primary-100 dark:hover:file:bg-primary-900/60 focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-400/30 cursor-pointer transition"
                  />
                </div>
              ))}

            {/* Submit Button */}
            <div className="pt-9">
              <button
                type="submit"
                disabled={loading}
                className={`cursor-pointer w-full h-14 btn-primary text-white text-base font-semibold rounded-xl shadow-lg hover:shadow-xl transition-all duration-200 active:scale-[0.98] ${
                  loading ? "opacity-50 cursor-not-allowed" : ""
                }`}
              >
                {loading ? t("submitting") : t("submit")}
              </button>
            </div>
          </form>
        </div>
      </div>
    </>
  );
}
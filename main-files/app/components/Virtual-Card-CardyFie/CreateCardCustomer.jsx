"use client";

import { useState } from "react";
import toast from "react-hot-toast";
import { createCardyFieCustomer } from "../../utils/api";
import { countryOptions } from "../../utils/countries";

export default function CreateCardCustomer() {
  const [formData, setFormData] = useState({
    first_name: "",
    last_name: "",
    email: "",
    date_of_birth: "",
    identity_type: "Passport",
    identity_number: "",
    id_front_image: null,
    id_back_image: null,
    user_image: null,
    house_number: "",
    country: "",
    city: "",
    state: "",
    zip_code: "",
    address: "",
  });

  const [loading, setLoading] = useState(false);

  const handleInputChange = (field, value) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const handleFileChange = (field, file) => {
    setFormData((prev) => ({ ...prev, [field]: file }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const fd = new FormData();

      // Text fields
      [
        "first_name",
        "last_name",
        "email",
        "date_of_birth",
        "identity_type",
        "identity_number",
        "house_number",
        "country",
        "city",
        "state",
        "zip_code",
        "address",
      ].forEach((key) => {
        if (formData[key]?.trim?.()) {
          fd.append(key, formData[key].trim());
        }
      });

      // Files
      if (formData.id_front_image)
        fd.append("id_front_image", formData.id_front_image);
      if (formData.id_back_image)
        fd.append("id_back_image", formData.id_back_image);
      if (formData.user_image) fd.append("user_image", formData.user_image);

      const response = await createCardyFieCustomer(fd);

      if (response?.message?.error?.length) {
        response.message.error.forEach((msg) => toast.error(msg));
      } else if (response?.message?.success?.length || response?.data) {
        toast.success("Customer created successfully!");
        // Optional: reset form or redirect
      } else {
        toast.error("Something went wrong.");
      }
    } catch (err) {
      // console.error(err);
      toast.error("Something went wrong");
    } finally {
      setLoading(false);
    }
  };

  // Reusable base input style (derived from file input)
  const baseInputClass = `
  w-full border border-gray-300 rounded-lg
  text-sm text-gray-700 bg-white
  focus:outline-none focus:ring-1 focus:ring-green-400
  transition-all duration-200
`;

  // Reusable text input style
  const inputClass = `
  ${baseInputClass}
  h-12 px-4 placeholder:text-gray-400
`;

  // Reusable file input style class for all
  const fileInputClass = `
  ${baseInputClass}
  p-2.5 cursor-pointer
  file:mr-4 file:py-2 file:px-4
  file:rounded-lg file:border-0
  file:text-sm file:font-semibold
  file:bg-green-50 file:text-green-700
  hover:file:bg-green-100
`;

  return (
    <div className="mx-auto w-full max-w-7xl px-4 py-8">
      <div className="bg-white rounded-2xl shadow-lg border border-gray-100 p-6 sm:p-8 lg:p-10">
        <div className="mb-8">
          <h2 className="text-3xl font-bold text-gray-900 tracking-tight">
            Create Customer
          </h2>
          <p className="text-gray-600 text-base mt-2 leading-relaxed">
            Please fill in the required details to set up your CardyFie customer
            profile
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Row 1: first_name + last_name */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                First Name <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.first_name}
                onChange={(e) =>
                  handleInputChange("first_name", e.target.value)
                }
                required
                className={inputClass}
                placeholder="Enter First Name"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Last Name <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.last_name}
                onChange={(e) => handleInputChange("last_name", e.target.value)}
                required
                className={inputClass}
                placeholder="Enter Last Name"
              />
            </div>
          </div>

          {/* Row 2: email + date_of_birth */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Email <span className="text-red-500">*</span>
              </label>
              <input
                type="email"
                value={formData.email}
                onChange={(e) => handleInputChange("email", e.target.value)}
                required
                className={inputClass}
                placeholder="Enter Customer Email"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Date of Birth <span className="text-red-500">*</span>{" "}
                <span className="text-xs text-gray-400">
                  (Should match with your ID)
                </span>
              </label>
              <input
                type="date"
                value={formData.date_of_birth}
                onChange={(e) =>
                  handleInputChange("date_of_birth", e.target.value)
                }
                required
                className={inputClass}
              />
            </div>
          </div>

          {/* Row 3: identity_type + identity_number */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Identity Type <span className="text-red-500">*</span>
              </label>
              <select
                value={formData.identity_type}
                onChange={(e) =>
                  handleInputChange("identity_type", e.target.value)
                }
                required
                className={inputClass}
              >
                <option value="Passport">Passport</option>
                <option value="National ID Card (NID)">
                  National ID Card (NID)
                </option>
                <option value="Bank Verification Number">
                  Bank Verification Number
                </option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Identity Number <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.identity_number}
                onChange={(e) =>
                  handleInputChange("identity_number", e.target.value)
                }
                required
                className={inputClass}
                placeholder="Enter Identity Number"
              />
            </div>
          </div>

          {/* Row 4: id_front_image + id_back_image */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                ID Card Image <span className="text-red-500">*</span>{" "}
                <span className="text-xs text-gray-400">(Font Side)</span>
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={(e) =>
                  handleFileChange(
                    "id_front_image",
                    e.target.files?.[0] || null,
                  )
                }
                required
                className={fileInputClass}
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                ID Card Image <span className="text-red-500">*</span>{" "}
                <span className="text-xs text-gray-400">(Back Side)</span>
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={(e) =>
                  handleFileChange("id_back_image", e.target.files?.[0] || null)
                }
                required
                className={fileInputClass}
              />
            </div>
          </div>

          {/* Row 5: user_image + house_number */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Your Photo <span className="text-red-500">*</span>
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={(e) =>
                  handleFileChange("user_image", e.target.files?.[0] || null)
                }
                required
                className={fileInputClass}
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                House Number <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.house_number}
                onChange={(e) =>
                  handleInputChange("house_number", e.target.value)
                }
                required
                className={inputClass}
                placeholder="Enter House Number"
              />
            </div>
          </div>

          {/* Row 6: country + city */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Country <span className="text-red-500">*</span>
              </label>
              <select
                value={formData.country}
                onChange={(e) => handleInputChange("country", e.target.value)}
                required
                className={inputClass}
              >
                <option value="">Select country</option>
                {countryOptions.map((c) => (
                  <option key={c.code} value={c.code}>
                    {c.name}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                City <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.city}
                onChange={(e) => handleInputChange("city", e.target.value)}
                className={inputClass}
                placeholder="Enter City"
              />
            </div>
          </div>

          {/* Row 7: state + zip_code */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                State <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.state}
                onChange={(e) => handleInputChange("state", e.target.value)}
                className={inputClass}
                placeholder="Enter State"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Zip Code <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.zip_code}
                onChange={(e) => handleInputChange("zip_code", e.target.value)}
                required
                className={inputClass}
                placeholder="Enter zip code"
              />
            </div>
          </div>

          {/* Row 8: address – full width */}
          <div>
            <label className="block text-sm font-semibold text-gray-800 mb-2">
              Address <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              value={formData.address}
              onChange={(e) => handleInputChange("address", e.target.value)}
              required
              className={inputClass}
              placeholder="Enter Address"
            />
          </div>

          {/* Submit Button */}
          <div className="pt-6">
            <button
              type="submit"
              disabled={loading}
              className={`w-full h-14 text-white text-base font-semibold rounded-xl shadow-md transition-all duration-200 ${
                loading ? "btn-primary" : "btn-primary cursor-pointer"
              }`}
            >
              {loading ? "Creating Customer..." : "Submit"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

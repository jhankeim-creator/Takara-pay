"use client";

import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import {
  getCardyfieCustomerEditInfo,
  updateCardyFieCustomer,
} from "../../utils/api";

export default function UpdateCustomer() {
  const [formData, setFormData] = useState({
    first_name: "",
    last_name: "",
    date_of_birth: "",
    identity_type: "passport",
    identity_number: "",
    id_front_image: null,
    id_back_image: null,
    user_image: null,
    house_number: "",
    city: "",
    state: "",
    zip_code: "",
    address: "",
  });

  const [existingImages, setExistingImages] = useState({
    id_front_image: "",
    id_back_image: "",
    user_image: "",
  });

  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await getCardyfieCustomerEditInfo();
        const customer = res?.data?.card_customer;

        if (customer) {
          setFormData({
            first_name: customer.first_name || "",
            last_name: customer.last_name || "",
            date_of_birth: customer.date_of_birth || "",
            identity_type: customer.id_type || "passport",
            identity_number: customer.id_number || "",
            house_number: customer.house_number || "",
            city: customer.city || "",
            state: customer.state || "",
            zip_code: customer.zip_code || "",
            address: customer.address_line_1 || "",
            id_front_image: null,
            id_back_image: null,
            user_image: null,
          });

          setExistingImages({
            id_front_image:
              customer.id_front_image || customer.idFontImage || "",
            id_back_image: customer.id_back_image || customer.idBackImage || "",
            user_image: customer.user_image || customer.userImage || "",
          });
        }
      } catch (err) {
        // console.error("Failed to load customer data", err);
        toast.error("Failed to load existing customer data");
      }
    };

    fetchData();
  }, []);

  const handleInputChange = (fieldName, value) => {
    setFormData((prev) => ({ ...prev, [fieldName]: value }));
  };

  const handleFileChange = (fieldName, file) => {
    setFormData((prev) => ({ ...prev, [fieldName]: file }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const formDataToSend = new FormData();

      Object.entries(formData).forEach(([key, value]) => {
        if (value instanceof File) {
          formDataToSend.append(key, value);
        } else if (value !== undefined && value !== null && value !== "") {
          formDataToSend.append(key, value);
        }
      });

      const response = await updateCardyFieCustomer(formDataToSend);

      if (response?.message?.error && Array.isArray(response.message.error)) {
        response.message.error.forEach((errMsg) => toast.error(errMsg));
      } else if (
        response?.data ||
        response?.message?.success ||
        response?.status === "success"
      ) {
        toast.success("Customer updated successfully!");
      } else {
        toast.error("Something went wrong. Please try again.");
      }
    } catch (error) {
      toast.error("Failed to update customer");
      // console.error("Update customer error:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto w-full max-w-5xl">
      <div className="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 lg:p-8">
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900">Update Customer</h2>
          <p className="text-gray-600 mt-1 text-sm">
            Update the required information for your customer profile
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Row 1: Names */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                First Name<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.first_name}
                onChange={(e) =>
                  handleInputChange("first_name", e.target.value)
                }
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
                placeholder="Enter first name"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Last Name<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.last_name}
                onChange={(e) => handleInputChange("last_name", e.target.value)}
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
                placeholder="Enter last name"
              />
            </div>
          </div>

          {/* Row 2: DOB + Identity Type */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Date of Birth<span className="ml-1 text-red-500">*</span>
                <span className="ml-1 text-xs text-gray-500">
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
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Identity Type<span className="ml-1 text-red-500">*</span>
              </label>
              <select
                value={formData.identity_type}
                onChange={(e) =>
                  handleInputChange("identity_type", e.target.value)
                }
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
              >
                <option value="national_id">National ID Card (NID)</option>
                <option value="passport">Passport</option>
                <option value="Bank_Verification_Number">
                  Bank Verification Number
                </option>
              </select>
            </div>
          </div>

          {/* Row 3: Identity Number + House Number */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Identity Number<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.identity_number}
                onChange={(e) =>
                  handleInputChange("identity_number", e.target.value)
                }
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
                placeholder="Enter Identity Number"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                House Number<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.house_number}
                onChange={(e) =>
                  handleInputChange("house_number", e.target.value)
                }
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
                placeholder="Enter House Number"
              />
            </div>
          </div>

          {/* Row 4: City + State */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                City<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.city}
                onChange={(e) => handleInputChange("city", e.target.value)}
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
                placeholder="Enter City"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                State<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.state}
                onChange={(e) => handleInputChange("state", e.target.value)}
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
                placeholder="Enter State"
              />
            </div>
          </div>

          {/* Row 5: Zip Code + User Photo */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Zip Code<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="text"
                value={formData.zip_code}
                onChange={(e) => handleInputChange("zip_code", e.target.value)}
                required
                className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
                placeholder="Enter Zip Code"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                ID Card Image (Font Side)
                <span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={(e) =>
                  handleFileChange("user_image", e.target.files?.[0] || null)
                }
                className="w-full text-sm text-gray-700 bg-white border border-gray-300 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:bg-gray-100 file:text-gray-700 hover:file:bg-gray-200 focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-emerald-400/30 cursor-pointer transition"
              />
            </div>
          </div>

          {/* Row 6: ID Front + ID Back */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                ID Card Image (Back Side)
                <span className="ml-1 text-red-500">*</span>
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
                className="w-full text-sm text-gray-700 bg-white border border-gray-300 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:bg-gray-100 file:text-gray-700 hover:file:bg-gray-200 focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-emerald-400/30 cursor-pointer transition"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-800 mb-2">
                Your Photo<span className="ml-1 text-red-500">*</span>
              </label>
              <input
                type="file"
                accept="image/*"
                onChange={(e) =>
                  handleFileChange("id_back_image", e.target.files?.[0] || null)
                }
                className="w-full text-sm text-gray-700 bg-white border border-gray-300 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:bg-gray-100 file:text-gray-700 hover:file:bg-gray-200 focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-emerald-400/30 cursor-pointer transition"
              />
            </div>
          </div>

          {/* Full-width Address */}
          <div>
            <label className="block text-sm font-semibold text-gray-800 mb-2">
              Address<span className="ml-1 text-red-500">*</span>
            </label>
            <input
              type="text"
              value={formData.address}
              onChange={(e) => handleInputChange("address", e.target.value)}
              required
              className="w-full h-12 px-4 text-gray-900 font-medium bg-white border-2 border-gray-200 rounded-xl focus:outline-none focus:border-emerald-400 focus:ring-1 focus:ring-blue-50 transition-all"
              placeholder="Enter full address"
            />
          </div>

          {/* Full-width Currently Uploaded Images */}
          <div className="pt-4">
            <label className="block text-sm font-semibold text-gray-800 mb-3">
              Currently Uploaded Images
            </label>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
              {[
                {
                  key: "id_front_image",
                  label: "ID Card Image (Font Side)",
                  url: existingImages.id_front_image,
                },
                {
                  key: "id_back_image",
                  label: "ID Card Image (Back Side)",
                  url: existingImages.id_back_image,
                },
                {
                  key: "user_image",
                  label: "Your Photo",
                  url: existingImages.user_image,
                },
              ].map(({ key, label, url }) => (
                <div key={key} className="text-center">
                  <p className="text-xs text-gray-600 mb-2 font-medium">
                    {label}
                  </p>
                  {url ? (
                    <div className="border border-gray-300 rounded-lg overflow-hidden bg-gray-50">
                      <img
                        src={url}
                        alt={`${label} preview`}
                        className="w-full h-40 object-contain"
                        onError={(e) => {
                          e.target.src = "/placeholder-image.jpg";
                          e.target.alt = "Image not available";
                        }}
                      />
                    </div>
                  ) : (
                    <div className="w-full h-40 bg-gray-100 rounded-lg flex items-center justify-center text-gray-500 text-sm">
                      No image uploaded
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>

          {/* Full-width Submit */}
          <div className="pt-6">
            <button
              type="submit"
              disabled={loading}
              className={`w-full h-14 btn-primary text-white text-base font-semibold rounded-xl shadow-lg hover:shadow-xl transition-all duration-200 active:scale-[0.98] ${
                loading ? "opacity-50 cursor-not-allowed" : "cursor-pointer"
              }`}
            >
              {loading ? "Updating..." : "Submit"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

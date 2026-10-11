/* eslint-disable @next/next/no-img-element */
"use client";

import { Loader2, Trash2 } from "lucide-react";
import { useRouter } from "next/navigation";
import { useEffect, useRef, useState } from "react";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";
import {
  deleteUserAccount,
  getUserProfile,
  updateUserProfile,
} from "../../utils/api";
import MyProfileSkeleton from "./MyProfileSkeleton";

// ---------------------------------------------------------------------------
// Shared Tailwind class strings — defined once to keep JSX concise
// ---------------------------------------------------------------------------
const INPUT_CLASS =
  "w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg " +
  "placeholder:text-gray-500 dark:placeholder:text-gray-400 " +
  "text-gray-900 dark:text-gray-100 dark:bg-gray-800 " +
  "focus:border-primary-500 dark:focus:border-primary-400 " +
  "focus:ring-1 focus:ring-primary-100 dark:focus:ring-primary-500/30 " +
  "outline-none transition-all";

const LABEL_CLASS =
  "block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2";

// ---------------------------------------------------------------------------
// CameraIcon — overlaid on the profile picture to indicate it is clickable
// ---------------------------------------------------------------------------
const CameraIcon = () => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    className="h-5 w-5"
    viewBox="0 0 20 20"
    fill="currentColor"
  >
    <path
      fillRule="evenodd"
      d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-4 3 3 2-2 3 3z"
      clipRule="evenodd"
    />
  </svg>
);

// ---------------------------------------------------------------------------
// ChevronDownIcon — used inside the country dropdown trigger button
// ---------------------------------------------------------------------------
const ChevronDownIcon = ({ open }) => (
  <svg
    className={`w-5 h-5 text-gray-500 dark:text-gray-400 transition-transform ${
      open ? "rotate-180" : ""
    }`}
    fill="none"
    stroke="currentColor"
    viewBox="0 0 24 24"
  >
    <path
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth={2}
      d="M19 9l-7 7-7-7"
    />
  </svg>
);

// ---------------------------------------------------------------------------
// WarningIcon — displayed inside the delete-account confirmation modal
// ---------------------------------------------------------------------------
const WarningIcon = () => (
  <svg
    className="w-8 h-8 text-red-600 dark:text-red-400"
    fill="none"
    stroke="currentColor"
    viewBox="0 0 24 24"
  >
    <path
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth={2}
      d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4
         c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
    />
  </svg>
);

// ---------------------------------------------------------------------------
// MyProfileCard
// ---------------------------------------------------------------------------
function MyProfileCard() {
// Translations scoped to the "myProfile" namespace
  const t = useTranslations("myProfile");

  const router = useRouter();

  // ── UI state ──────────────────────────────────────────────────────────────
  const [loading, setLoading] = useState(true);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [isCountryOpen, setIsCountryOpen] = useState(false);

  // ── Data state ────────────────────────────────────────────────────────────
  const [userEmail, setUserEmail] = useState("");
  const [profileImage, setProfileImage] = useState("");   
  const [imageFile, setImageFile] = useState(null);       
  const [countries, setCountries] = useState([]);

  const [profileData, setProfileData] = useState({
    firstName: "",
    lastName: "",
    country: "",
    countryCode: "",
    phone: "",
    address: "",
    city: "",
    state: "",
    zipCode: "",
  });

  
  const imageInputRef = useRef(null);

  // ── Fetch profile on mount ────────────────────────────────────────────────
  useEffect(() => {
    const fetchProfile = async () => {
      setLoading(true);

      const res = await getUserProfile();

      if (res?.data?.user) {
        const user = res.data.user;

        // Populate the country list for the dropdown
        setCountries(res.data.countries || []);

        
        setProfileData({
          firstName:   user.firstname              || "",
          lastName:    user.lastname               || "",
          country:     user.address?.country       || "",
          countryCode: user.mobile_code ? `+${user.mobile_code}` : "",
          phone:       user.mobile                 || "",
          address:     user.address?.address       || "",
          city:        user.address?.city          || "",
          state:       user.address?.state         || "",
          zipCode:     user.address?.zip           || "",
        });

        setUserEmail(user.email);
        setProfileImage(user.userImage);
      }

      setLoading(false);
    };

    fetchProfile();
  }, []);

  // ── Handlers ──────────────────────────────────────────────────────────────

  
  const handleProfileChange = (e) => {
    setProfileData({ ...profileData, [e.target.name]: e.target.value });
  };

  
  const handleImageChange = (e) => {
    setImageFile(e.target.files?.[0] ?? null);
  };

  /** Update country + dial code when the user picks from the dropdown, and reset phone. */
  const handleCountrySelect = (country) => {
    setProfileData((prev) => ({
      ...prev,
      country:     country.name,
      countryCode: `+${country.mobile_code}`,
      phone:       "", 
    }));
    setIsCountryOpen(false);
  };

  /** API payload and submit profile changes **/
  const handleProfileUpdate = async (e) => {
    e.preventDefault();
    setLoading(true);

    const payload = {
      firstname:  profileData.firstName,
      lastname:   profileData.lastName,
      country:    profileData.country,
      phone_code: profileData.countryCode
        ? profileData.countryCode.replace("+", "")
        : null,
      phone:    profileData.phone    || null,
      address:  profileData.address,
      city:     profileData.city,
      state:    profileData.state,
      zip_code: profileData.zipCode,
    };

    const res = await updateUserProfile(payload, imageFile);

    if (res?.message?.success) {
      toast.success(res.message.success[0]);

      // Preview the newly uploaded image locally without a page reload
      if (imageFile) {
        setProfileImage(URL.createObjectURL(imageFile));
      }

      
      setImageFile(null);
      if (imageInputRef.current) {
        imageInputRef.current.value = "";
      }
    } else if (res?.message?.error) {
      toast.error(res.message.error[0]);
    }

    setLoading(false);
  };

  
  const handleDeleteAccount = () => {
    setShowDeleteModal(true);
  };

  /** Call the API to permanently delete the account */
  const confirmDeleteAccount = async () => {
    setLoading(true);

    try {
      const res = await deleteUserAccount();

      if (res?.message?.success?.length) {
        toast.success(res.message.success[0]);

        // Clear all auth tokens from both storage layers before redirecting
        localStorage.removeItem("auth_token");
        sessionStorage.removeItem("auth_token");
        localStorage.removeItem("user");
        sessionStorage.removeItem("user");

        router.push("/login");
        return;
      }

      if (res?.message?.error?.length) {
        toast.error(res.message.error[0]);
      }
    } catch {
      toast.error(t("errors.deleteUnexpected"));
    } finally {
      
      setLoading(false);
      setShowDeleteModal(false);
    }
  };

  /** Dismiss the delete-account modal without taking any action. */
  const cancelDeleteAccount = () => {
    setShowDeleteModal(false);
  };

  // ── Render ────────────────────────────────────────────────────────────────

  // Show skeleton placeholder while profile data is loading
  if (loading) return <MyProfileSkeleton />;

  return (
    <>
      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-md dark:shadow-gray-950/50 p-6 mx-auto">

        {/* ── Header: title + email badge ───────────────────────────────── */}
        <div className="relative flex flex-col items-center mb-10">
          {/* Header row: title and delete button (stacked/absolute on sm+, row on mobile) */}
          <div className="w-full flex items-center justify-between sm:block mb-4 sm:mb-0">
            <h2 className="text-xl sm:text-2xl font-bold text-gray-800 dark:text-gray-100 text-left sm:text-center sm:mb-3">
              {t("title")}
            </h2>

            <button
              type="button"
              onClick={handleDeleteAccount}
              className="static sm:absolute sm:top-0 sm:right-0 px-3 py-1.5 sm:px-4 sm:py-2 bg-red-50 hover:bg-red-100 dark:bg-red-950/30 dark:hover:bg-red-900/40 text-red-600 dark:text-red-400 border border-red-200 dark:border-red-900/50 rounded-lg transition-all cursor-pointer font-semibold text-xs sm:text-sm flex items-center gap-2 whitespace-nowrap"
            >
              {t("buttons.deleteAccount")}
            </button>
          </div>

          {/* Email badge */}
          <div className="inline-flex items-center gap-2 bg-primary-50 dark:bg-primary-950/60 text-primary-700 dark:text-primary-700 px-5 py-2.5 rounded-full text-sm sm:text-base font-medium shadow-sm">
            {userEmail}
          </div>
        </div>

        {/* ── Profile image with upload overlay ────────────────────────── */}
        <div className="flex justify-center mb-8">
          <div className="relative inline-block">
            {/* Avatar — shows the local preview while a new file is staged */}
            <div className="w-24 h-24 rounded-full overflow-hidden shadow-lg dark:shadow-gray-900/60">
              <img
                src={imageFile ? URL.createObjectURL(imageFile) : profileImage}
                alt={t("profileImageAlt")}
                className="w-full h-full object-cover"
              />
            </div>

            {/* Hidden file input — triggered by the label below */}
            <input
              type="file"
              accept="image/*"
              ref={imageInputRef}
              onChange={handleImageChange}
              className="hidden"
              id="profile-image-upload"
            />

            {/* Camera-icon badge that opens the file picker */}
            <label
              htmlFor="profile-image-upload"
              className="absolute bottom-0 right-0 p-1.5 bg-primary-500 text-white rounded-full cursor-pointer hover:bg-primary-600 transition-colors"
            >
              <CameraIcon />
            </label>
          </div>
        </div>

        {/* ── Profile form ─────────────────────────────────────────────── */}
        <form
          onSubmit={handleProfileUpdate}
          className="grid grid-cols-1 md:grid-cols-2 gap-5"
        >
          {/* First name */}
          <div>
            <label className={LABEL_CLASS}>
              {t("fields.firstName")} <span className="text-red-500">*</span>
            </label>
            <input
              name="firstName"
              value={profileData.firstName}
              onChange={handleProfileChange}
              className={INPUT_CLASS}
              required
            />
          </div>

          {/* Last name */}
          <div>
            <label className={LABEL_CLASS}>
              {t("fields.lastName")} <span className="text-red-500">*</span>
            </label>
            <input
              name="lastName"
              value={profileData.lastName}
              onChange={handleProfileChange}
              className={INPUT_CLASS}
              required
            />
          </div>

          {/* ── Country dropdown ──────────────────────────────────────── */}
          <div className="relative">
            <label className={LABEL_CLASS}>
              {t("fields.country")} <span className="text-red-500">*</span>
            </label>

            {/* Trigger button — toggles the dropdown list */}
            <button
              type="button"
              onClick={() => setIsCountryOpen(!isCountryOpen)}
              className={`${INPUT_CLASS} flex justify-between items-center bg-white dark:bg-gray-800 cursor-pointer`}
            >
              <span>{profileData.country || t("fields.countryPlaceholder")}</span>
              <ChevronDownIcon open={isCountryOpen} />
            </button>

            {/* Scrollable list of countries */}
            {isCountryOpen && (
              <div className="absolute z-50 w-full mt-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-lg shadow-lg dark:shadow-gray-950/60 max-h-60 overflow-y-auto">
                {countries.map((country) => (
                  <div
                    key={country.id}
                    onClick={() => handleCountrySelect(country)}
                    className="px-4 py-3 hover:bg-primary-50 dark:hover:bg-primary-900/40 cursor-pointer text-gray-800 dark:text-gray-200 font-medium text-base transition-colors"
                  >
                    {country.name}
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* ── Phone (prefixed with dial code) ──────────────────────── */}
          <div>
            <label className={LABEL_CLASS}>
              {t("fields.phone")} <span className="text-red-500">*</span>
            </label>
            <input
              name="phone"
              // Display as "<countryCode> <number>" when a code is present
              value={
                profileData.countryCode
                  ? `${profileData.countryCode} ${profileData.phone}`
                  : profileData.phone
              }
              onChange={(e) =>
                // Strip the country-code prefix before storing the bare number
                setProfileData({
                  ...profileData,
                  phone: e.target.value
                    .replace(profileData.countryCode || "", "")
                    .trim(),
                })
              }
              className={INPUT_CLASS}
              placeholder={t("fields.phonePlaceholder")}
              required
            />
          </div>

          {/* Address */}
          <div>
            <label className={LABEL_CLASS}>{t("fields.address")}</label>
            <input
              name="address"
              value={profileData.address}
              onChange={handleProfileChange}
              className={INPUT_CLASS}
            />
          </div>

          {/* City */}
          <div>
            <label className={LABEL_CLASS}>{t("fields.city")}</label>
            <input
              name="city"
              value={profileData.city}
              onChange={handleProfileChange}
              className={INPUT_CLASS}
            />
          </div>

          {/* State */}
          <div>
            <label className={LABEL_CLASS}>{t("fields.state")}</label>
            <input
              name="state"
              value={profileData.state}
              onChange={handleProfileChange}
              className={INPUT_CLASS}
            />
          </div>

          {/* Zip code */}
          <div>
            <label className={LABEL_CLASS}>{t("fields.zipCode")}</label>
            <input
              name="zipCode"
              value={profileData.zipCode}
              onChange={handleProfileChange}
              className={INPUT_CLASS}
            />
          </div>

          {/* ── Action buttons ────────────────────────────────────────── */}
          <div className="col-span-1 md:col-span-2 flex flex-col sm:flex-row gap-4 justify-center mt-6">

            {/* Save changes — shows a spinner while the request is in-flight */}
            <button
              type="submit"
              disabled={loading}
              className={`px-10 py-3 btn-primary text-white rounded-lg font-semibold transition-all cursor-pointer flex items-center justify-center gap-2
                ${loading ? "opacity-70 cursor-wait" : "hover:opacity-90"}`}
            >
              {loading
                ? <Loader2 className="w-5 h-5 animate-spin" />
                : t("buttons.updateProfile")}
            </button>
          </div>
        </form>
      </div>

      {/* ── Delete-account confirmation modal ──────────────────────────────── */}
      {showDeleteModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/45 backdrop-blur-none p-4">
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-2xl dark:shadow-gray-950/70 max-w-md w-full p-6 transform transition-all">

            {/* Warning icon badge */}
            <div className="flex justify-center mb-4">
              <div className="w-16 h-16 bg-red-100 dark:bg-red-950/60 rounded-full flex items-center justify-center">
                <WarningIcon />
              </div>
            </div>

            <h3 className="text-2xl font-semibold text-gray-900 dark:text-gray-100 text-center mb-3">
              {t("deleteModal.title")}
            </h3>

            <p className="text-gray-600 dark:text-gray-400 text-center mb-6">
              {t("deleteModal.description")}
            </p>

            {/* Cancel / Confirm actions */}
            <div className="flex gap-3">
              <button
                onClick={cancelDeleteAccount}
                className="flex-1 px-6 py-3 bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200 rounded-lg font-semibold hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors cursor-pointer"
              >
                {t("deleteModal.cancel")}
              </button>
              <button
                onClick={confirmDeleteAccount}
                className="flex-1 px-6 py-3 bg-red-500 hover:bg-red-600 dark:bg-red-600 dark:hover:bg-red-700 text-white rounded-lg font-semibold transition-colors cursor-pointer"
              >
                {t("deleteModal.confirm")}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

export default MyProfileCard;
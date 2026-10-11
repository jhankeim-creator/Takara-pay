import axios from "axios";
import { setupCache } from "axios-cache-interceptor";
const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_BASE_URL,
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
  },
});

const cachedApi = setupCache(api, {
  ttl: 5 * 60 * 1000,
  cacheTakeover: true,
});

export default cachedApi;

// Interceptor to automatically add Bearer token from localStorage
api.interceptors.request.use((config) => {
  const token =
    localStorage.getItem("auth_token") || sessionStorage.getItem("auth_token");

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  // Locale detect
  const locale =
    typeof window !== "undefined"
      ? window.location.pathname.split("/")[1]
      : "en";

  // Skip logic (important)
  if (config.skipLang) {
    return config;
  }

  // Add lang param safely
  if (config.url) {
    config.url += config.url.includes("?")
      ? `&lang=${locale}`
      : `?lang=${locale}`;
  }

  return config;
});

// Interceptor for handling 401 Unauthorized responses
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem("jwtToken"); // sessionStorage.removeItem("jwtToken"); // Removed as per task
      localStorage.removeItem("userInfo");
      localStorage.removeItem("email_verified");
      localStorage.removeItem("sms_verified");
      localStorage.removeItem("two_factor_verified");
      localStorage.removeItem("auth_token");
      localStorage.removeItem("user");

      window.location.href = "/login";
    }
    return Promise.reject(error);
  },
);

export const loginUser = async (credentials) => {
  try {
    const { data } = await api.post("/user/login", credentials);
    return data;
  } catch (error) {
    console.log("Error", error);
    return error.response?.data;
  }
};

export const registerUser = async (userData) => {
  try {
    const { data } = await api.post("/user/register", userData);
    return data;
  } catch (error) {
    console.log("Error", error);
    return error.response?.data;
  }
};

export const logoutUser = async () => {
  try {
    const { data } = await api.get("/user/logout");
    return data;
  } catch (error) {
    console.log(error);
  }
};

export const getUserNotifications = async () => {
  try {
    const { data } = await api.get("/user/notifications");
    return data;
  } catch (error) {
    console.log("Error fetching notifications", error);
    return error.response?.data;
  }
};

export const forgotPassword = async (email) => {
  const formData = new FormData();
  formData.append("email", email);
  try {
    const { data } = await api.post("/user/forget/password", formData);
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const verifyOtp = async (otp) => {
  const formData = new FormData();
  formData.append("code", otp);
  try {
    const { data } = await api.post("/user/forget/verify/code", formData);
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const resetPassword = async ({
  code,
  password,
  password_confirmation,
}) => {
  const formData = new FormData();
  formData.append("code", code);
  formData.append("password", password);
  formData.append("password_confirmation", password_confirmation);

  try {
    const { data } = await api.post("/user/forget/reset/password", formData);
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const verifyEmail = async (code) => {
  const formData = new FormData();
  formData.append("code", code);
  try {
    const { data } = await api.post("/user/email-verify", formData);
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const resendEmailVerifyCode = async () => {
  try {
    const { data } = await api.post("/user/send-code");
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const getUserDashboard = async () => {
  try {
    // Not cached: this response carries active_virtual_system and module_access,
    // so a 5 minute cached copy would keep showing the old card provider after
    // an admin switches it — and that stale UI then calls the wrong endpoints.
    const { data } = await api.get("/user/dashboard", { cache: false });
    return data;
  } catch (error) {
    console.error("Dashboard fetch error:", error);
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const getUserProfile = async () => {
  try {
    const { data } = await api.get("/user/profile");
    return data;
  } catch (error) {
    // console.error("Profile fetch error:", error);
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const updateUserProfile = async (profileData, imageFile) => {
  const formData = new FormData();

  for (const key in profileData) {
    if (profileData[key] !== null && profileData[key] !== undefined) {
      formData.append(key, profileData[key]);
    }
  }

  if (imageFile) {
    formData.append("image", imageFile);
  }

  try {
    const { data } = await api.post("/user/profile/update", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const deleteUserAccount = async () => {
  try {
    const { data } = await api.post("/user/delete/account");
    return data;
  } catch (error) {
    console.error("Delete account error:", error);
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const updateUserPassword = async ({
  current_password,
  password,
  password_confirmation,
}) => {
  const formData = new FormData();
  formData.append("current_password", current_password);
  formData.append("password", password);
  formData.append("password_confirmation", password_confirmation);

  try {
    const { data } = await api.post("/user/password/update", formData);
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const getKycInputFields = async () => {
  try {
    const { data } = await api.get("/user/kyc/input-fields");
    return data;
  } catch (error) {
    console.error("KYC fetch error:", error);
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["Failed to fetch KYC data"] } };
  }
};

export const submitKyc = async (kycFormValues) => {
  const formData = new FormData();

  // Append dynamic fields
  Object.keys(kycFormValues).forEach((key) => {
    if (kycFormValues[key] !== null && kycFormValues[key] !== undefined) {
      formData.append(key, kycFormValues[key]);
    }
  });

  try {
    const { data } = await api.post("/user/kyc/submit", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    // console.error("KYC submit error:", error);
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["Failed to submit KYC"] } };
  }
};

export const getUserGiftCards = async () => {
  try {
    const { data } = await api.get("/user/gift-card");
    return data;
  } catch (error) {
    if (error.response) {
      return error.response?.data || { message: { error: ["Network error"] } };
    }
  }
};

export const getAllGiftCards = async (page = 2) => {
  try {
    const { data } = await api.get(`/user/gift-card/all?page=${page}`);
    return data;
  } catch (error) {
    console.error("Error fetching gift cards:", error);

    if (error.response?.data) {
      return error.response.data;
    }

    return {
      message: {
        error: ["An unexpected error occurred while fetching gift cards"],
      },
    };
  }
};

export const searchGiftCardsByCountry = async (iso2, page = 1) => {
  try {
    const { data } = await api.get(
      `/user/gift-card/search?country=${iso2.toUpperCase()}&page=${page}`,
    );
    return data;
  } catch (error) {
    console.error("Gift cards search error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred while searching gift cards"],
      },
    };
  }
};

export const getGiftCardDetails = async (productId) => {
  try {
    const { data } = await api.get(
      `/user/gift-card/details?product_id=${productId}`,
    );
    return data;
  } catch (error) {
    // console.error("Gift card details fetch error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: [
          "An unexpected error occurred while fetching gift card details",
        ],
      },
    };
  }
};

export const submitGiftCardOrder = async (orderData) => {
  try {
    // Using FormData since many of your other endpoints use it
    const formData = new FormData();

    // Append all fields
    Object.entries(orderData).forEach(([key, value]) => {
      formData.append(key, value);
    });

    const { data } = await api.post("/user/gift-card/order", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    return data;
  } catch (error) {
    // console.error("Gift card order submission error:", error);

    if (error.response?.data) {
      return error.response.data;
    }

    return {
      message: {
        error: [
          "An unexpected error occurred while placing the gift card order",
        ],
      },
    };
  }
};

export const transferMoneyConfirmed = async ({ email, amount }) => {
  const formData = new FormData();
  formData.append("email", email);
  formData.append("amount", amount);

  try {
    const { data } = await api.post("/user/transfer-money/confirmed", formData);
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred"],
      },
    };
  }
};

export const checkTransferReceiverExist = async (email) => {
  const formData = new FormData();
  formData.append("email", email);

  try {
    const { data } = await api.post("/user/transfer-money/exist", formData);
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred"],
      },
    };
  }
};

export const getTransferMoneyInfo = async () => {
  try {
    const { data } = await api.get("/user/transfer-money/info");
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred"],
      },
    };
  }
};

export const getWithdrawInfo = async () => {
  try {
    const { data } = await api.get("/user/withdraw/info");
    return data;
  } catch (error) {
    console.error("Error fetching withdraw info:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["Failed to load withdrawal information"],
      },
    };
  }
};

export const submitWithdrawInsert = async ({ gateway, amount }) => {
  try {
    const formData = new FormData();

    // BACKEND EXPECTS CURRENCY ALIAS HERE
    formData.append("gateway", gateway);
    formData.append("amount", amount);

    const response = await api.post("/user/withdraw/insert", formData);
    return response.data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["Network error or server unreachable"],
      },
    };
  }
};

export const submitFinalWithdraw = async (data) => {
  try {
    const formData = new FormData();

    // Required trx
    formData.append("trx", data.trx);

    // Append all dynamic fields (email, card_number, etc.)
    Object.entries(data).forEach(([key, value]) => {
      if (key !== "trx") {
        formData.append(key, value);
      }
    });

    const response = await api.post(
      "/user/withdraw/manual/confirmed",
      formData,
    );
    return response.data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["Network error or server unreachable"],
      },
    };
  }
};

export const getGoogle2FASetup = async () => {
  try {
    const { data } = await api.get("/user/security/google-2fa");
    return data;
  } catch (error) {
    ("Error fetching 2FA setup:", error);

    if (error.response?.data) {
      return error.response.data;
    }

    return {
      message: { error: ["Failed to load 2FA setup information"] },
      data: null,
    };
  }
};

export const google2FAUpdateStatus = async (code) => {
  const formData = new FormData();
  formData.append("code", code);

  try {
    const { data } = await api.post(
      "/user/security/google-2fa/status/update",
      formData
    );
    return data;
  } catch (error) {
    ("Error enabling Google 2FA:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["An unexpected error occurred while enabling 2FA"] },
    };
  }
};

export const verifyGoogle2FA = async (otpCode) => {
  const formData = new FormData();
  formData.append("otp", otpCode);

  try {
    const { data } = await api.post("/user/google-2fa/otp/verify", formData);
    return data;
  } catch (error) {
    // ("2FA verification error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["Network error or server unreachable"],
      },
    };
  }
};

export const getAddMoneyInformation = async () => {
  try {
    const { data } = await api.get("/user/add-money/information");
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to load add money information"] },
    };
  }
};

export const submitAddMoney = async ({ amount, currency }) => {
  const formData = new FormData();
  formData.append("amount", amount);
  formData.append("currency", currency); // alias of the selected gateway currency
  formData.append("source", "WEB");
  const BASE_URL = window.location.origin; // Dynamically get the base URL (e.g., https://domain-name.com)
  formData.append(
    "success_url",
    `${BASE_URL}/en/dashboard/add-money/add-money-success`,
  );
  formData.append(
    "cancel_url",
    `${BASE_URL}/en/dashboard/add-money/add-money-cancel`,
  );

  try {
    const { data } = await api.post("/user/add-money/submit-data", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    if (error.response) {
      return error.response.data;
    }
    return { message: { error: ["An unexpected error occurred."] } };
  }
};

export const getUserTransactions = async (page = 1, limit = 12) => {
  try {
    const response = await api.get(
      `/user/transactions?page=${page}&limit=${limit}`,
    );
    return response.data;
  } catch (error) {
    console.error("getUserTransactions error:", error);
    if (error.response) {
      return error.response.data;
    }
    return {
      message: { error: ["Network error or server is not responding"] },
      data: { transactions: {} },
    };
  }
};

export const submitManualPaymentProof = async ({ track, formData }) => {
  try {
    const { data } = await api.post(
      "/user/add-money/manual/payment/confirmed",
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      },
    );
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred while submitting payment proof."],
      },
    };
  }
};
// --------------------------- Virtual Card APIs----------------------------------

// ────────────────────────────────────────────────────────────────
// New function for Strowallet Virtual Card endpoint
// ────────────────────────────────────────────────────────────────
export const getStrowalletCards = async () => {
  try {
    const { data } = await api.get("/user/strowallet-card");
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fetch virtual cards. Please try again."] },
    };
  }
};

// GET /user/strowallet-card/create/info
export const getStrowalletCreateInfo = async () => {
  try {
    const { data } = await api.get("/user/strowallet-card/create/info");
    return data;
  } catch (error) {
    console.error("Strowallet create info error:", error);
    if (error.response) return error.response.data;
    return { message: { error: ["Failed to load create info"] } };
  }
};

export const getStrowalletCharges = async () => {
  try {
    // Not cached: an admin fee change must show up on the create / fund /
    // withdraw pages straight away, not after the 5 minute cache expires.
    const { data } = await api.get("/user/strowallet-card/charges", {
      cache: false,
    });
    return data;
  } catch (error) {
    console.error("Strowallet create info error:", error);
    if (error.response) return error.response.data;
    return { message: { error: ["Failed to load create info"] } };
  }
};

// GET /user/strowallet-card/update/customer/status
export const updateStrowalletCustomerStatus = async () => {
  // sometimes need to off this to check the status update form, because if the status is updated to high kyc, the form will show, but I need to test the form
  try {
    const { data } = await api.get(
      "/user/strowallet-card/update/customer/status",
    );
    return data;
  } catch (error) {
    console.error("Strowallet customer status update error:", error);
    if (error.response) return error.response.data;
    return { message: { error: ["Failed to update customer status"] } };
  }
};

// POST /user/strowallet-card/update/customer
export const updateStrowalletCustomer = async (formData) => {
  try {
    const { data } = await api.post(
      "/user/strowallet-card/update/customer",
      formData,
      {
        headers: { "Content-Type": "multipart/form-data" },
      },
    );
    return data;
  } catch (error) {
    console.error("Update customer error:", error);
    if (error.response) return error.response.data;
    return { message: { error: ["Update failed"] } };
  }
};

export const createStrowalletCustomer = async (formData) => {
  try {
    const { data } = await api.post(
      "/user/strowallet-card/create/customer",
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      },
    );
    return data;
  } catch (error) {
    console.log("Create customer error:", error);
    if (error.response) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to create customer. Please try again."] },
    };
  }
};

export const createStrowalletCard = async (payload) => {
  try {
    const { data } = await api.post("/user/strowallet-card/create", payload, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    console.log("Create virtual card error:", error);
    if (error.response) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to create virtual card. Please try again."] },
    };
  }
};

// ────────────────────────────────────────────────
// NEW: API function for card details
// ────────────────────────────────────────────────
export const getSoduCardDetails = async (cardId) => {
  try {
    const { data } = await api.get(
      `/user/my-card/sudo/details?card_id=${cardId}`,
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to fetch card details."] } };
  }
};

// Sudo: make / remove default card
export const setSudoCardAsDefault = async (cardId) => {
  const formData = new FormData();
  formData.append("card_id", cardId);
  try {
    const { data } = await api.post(
      "/user/my-card/sudo/make-remove/default",
      formData,
      {
        headers: { "Content-Type": "multipart/form-data" },
      },
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to update default card status."] } };
  }
};

// Sudo: block card
export const blockSudoCard = async (cardId) => {
  const formData = new FormData();
  formData.append("card_id", cardId);
  try {
    const { data } = await api.post("/user/my-card/sudo/block", formData, {
      headers: { "Content-Type": "multipart/form-data" },
    });
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to block card."] } };
  }
};

// Sudo: unblock card
export const unblockSudoCard = async (cardId) => {
  const formData = new FormData();
  formData.append("card_id", cardId);
  try {
    const { data } = await api.post("/user/my-card/sudo/unblock", formData, {
      headers: { "Content-Type": "multipart/form-data" },
    });
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to unblock card."] } };
  }
};

// Sudo: card transactions
export const getSudoCardTransactions = async (cardId) => {
  try {
    const { data } = await api.get(
      `/user/my-card/sudo/transaction?card_id=${cardId}`,
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to fetch card transactions."] } };
  }
};

// Sudo: fund card
export const fundSudoCard = async ({
  card_id,
  fund_amount,
  currency,
  from_currency,
}) => {
  const formData = new FormData();
  formData.append("card_id", card_id);
  formData.append("fund_amount", fund_amount);
  formData.append("currency", currency);
  formData.append("from_currency", from_currency);
  try {
    const { data } = await api.post("/user/my-card/sudo/fund", formData, {
      headers: { "Content-Type": "multipart/form-data" },
    });
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to fund card. Please try again."] } };
  }
};
export const getStrowalletCardDetails = async (cardId) => {
  try {
    const { data } = await api.get(
      `/user/strowallet-card/details?card_id=${cardId}`,
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to fetch card details."] } };
  }
};

export const getStrowalletCardTransactions = async (cardId) => {
  try {
    const { data } = await api.get(
      `/user/strowallet-card/transaction?card_id=${cardId}`,
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to fetch card transactions."] } };
  }
};

// ────────────────────────────────────────────────
// NEW: Fund API function (add this to your api file)
// ────────────────────────────────────────────────
export const fundStrowalletCard = async (payload) => {
  try {
    const { data } = await api.post("/user/strowallet-card/fund", payload);
    return data;
  } catch (error) {
    console.log("Fund virtual card error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fund card. Please try again."] },
    };
  }
};

export const withdrawStrowalletCard = async (payload) => {
  try {
    const { data } = await api.post("/user/strowallet-card/withdraw", payload);
    return data;
  } catch (error) {
    console.log("Withdraw virtual card error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to withdraw. Please try again."] },
    };
  }
};

// Strowallet: get existing card holder (returns null data if not created yet)
export const getStrowalletCardHolder = async () => {
  try {
    const { data } = await api.get("/user/strowallet-card/get/card-holder");
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to load card holder."] } };
  }
};

// Strowallet: create / store card holder
export const storeStrowalletCardHolder = async (payload) => {
  try {
    const { data } = await api.post(
      "/user/strowallet-card/store/card-holder",
      payload,
      { headers: { "Content-Type": "multipart/form-data" } },
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return {
      message: { error: ["Failed to save card holder. Please try again."] },
    };
  }
};

export const setStrowalletCardAsDefault = async (cardId) => {
  try {
    const { data } = await api.post(
      "/user/strowallet-card/make-remove/default",
      { card_id: cardId },
    );
    return data;
  } catch (error) {
    console.error("Set default card error:", error);
    if (error.response?.data) return error.response.data;
    return {
      message: { error: ["Failed to update default card status."] },
    };
  }
};

// ── Strowallet Card Freeze / Unfreeze ─────────────────────────────────────
export const freezeStrowalletCard = async (cardId) => {
  const formData = new FormData();
  formData.append("card_id", cardId);

  try {
    const { data } = await api.post("/user/strowallet-card/block", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
  }
};

export const unfreezeStrowalletCard = async (cardId) => {
  const formData = new FormData();
  formData.append("card_id", cardId);

  try {
    const { data } = await api.post("/user/strowallet-card/unblock", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
  }
};

export const getStrowalletWebhookLogs = async (cardId) => {
  try {
    const { data } = await api.get(
      `/user/strowallet-card/webhook?card_id=${cardId}`,
    );
    return data;
  } catch (error) {
    console.log("Error fetching webhook logs:", error);
    throw error;
  }
};

// ---------------------------CardyFie Virtual Card APIs----------------------------------
export const getCardyFieCards = async () => {
  try {
    const { data } = await api.get("/user/cardyfie-card");
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fetch virtual cards. Please try again."] },
    };
  }
};

// GET /user/cardyfie-card/create/info
export const getCardyfieCreateInfo = async () => {
  try {
    const { data } = await api.get("/user/cardyfie-card/create/info");
    return data;
  } catch (error) {
    console.error("Cardyfie create info error:", error);
    if (error.response) return error.response.data;
    return { message: { error: ["Failed to load create info"] } };
  }
};

export const createCardyFieCustomer = async (formData) => {
  try {
    const { data } = await api.post(
      "/user/cardyfie-card/create/customer",
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      },
    );
    return data;
  } catch (error) {
    console.log("Create customer error:", error);
    if (error.response) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to create customer. Please try again."] },
    };
  }
};

// GET /user/cardyfie-card/edit/customer/page
export const getCardyfieCustomerEditInfo = async () => {
  try {
    const { data } = await api.get("/user/cardyfie-card/edit/customer/page");
    return data;
  } catch (error) {
    console.error("Failed to fetch customer edit info:", error);
    if (error.response) return error.response.data;
    return { message: { error: ["Failed to load customer edit information"] } };
  }
};

// POST /user/strowallet-card/update/customer  (multipart/form-data)   // BIG NOTE ISSUE strowallet API FOR CardyFie FOR UPDATE CUSTOMER SAME API END POINT
export const updateCardyFieCustomer = async (formData) => {
  try {
    const { data } = await api.post(
      "/user/strowallet-card/update/customer",
      formData,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      },
    );
    return data;
  } catch (error) {
    console.error("Update customer error:", error);
    if (error.response) return error.response.data;
    return {
      message: { error: ["Failed to update customer. Please try again."] },
    };
  }
};

export const createCardyFieCard = async (payload) => {
  try {
    const { data } = await api.post("/user/cardyfie-card/create", payload, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    console.log("Create virtual card error:", error);
    if (error.response) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to create virtual card. Please try again."] },
    };
  }
};

export const getCardyFieCardDetails = async (cardId) => {
  try {
    const { data } = await api.get(
      `/user/cardyfie-card/details?card_id=${cardId}`,
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to fetch card details."] } };
  }
};

export const getCardyFieCardTransactions = async (cardId) => {
  try {
    const { data } = await api.get(
      `/user/cardyfie-card/transaction?card_id=${cardId}`,
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return { message: { error: ["Failed to fetch card transactions."] } };
  }
};

export const setCardyFieDefault = async (cardId) => {
  try {
    const { data } = await api.post("/user/cardyfie-card/make-remove/default", {
      card_id: cardId,
    });
    return data;
  } catch (error) {
    console.error("Set default card error:", error);
    if (error.response?.data) return error.response.data;
    return {
      message: { error: ["Failed to update default card status."] },
    };
  }
};

export const DepositCardyFie = async (payload) => {
  try {
    const { data } = await api.post("/user/cardyfie-card/deposit", payload);
    return data;
  } catch (error) {
    console.log("Fund virtual card error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fund card. Please try again."] },
    };
  }
};

export const WithdrawCardyFie = async (payload) => {
  try {
    const { data } = await api.post("/user/cardyfie-card/withdraw", payload);
    return data;
  } catch (error) {
    console.log("Fund virtual card error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fund card. Please try again."] },
    };
  }
};

export const CardFreezeUnfreeze = async (payload) => {
  try {
    const { data } = await api.post(
      "/user/cardyfie-card/change/status",
      payload,
    );
    return data;
  } catch (error) {
    console.log("Fund virtual card error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fund card. Please try again."] },
    };
  }
};

export const CardyFieCardClose = async (payload) => {
  try {
    const { data } = await api.post("/user/cardyfie-card/close", payload);
    return data;
  } catch (error) {
    console.log("Fund virtual card error:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fund card. Please try again."] },
    };
  }
};

// ---------------------------Stripe Virtual Card APIs----------------------------------

export const getStripeCards = async () => {
  try {
    const { data } = await api.get("/user/my-card/stripe");
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fetch virtual cards. Please try again."] },
    };
  }
};
// ---------------------------Sudo Virtual Card APIs----------------------------------

export const getSudoCards = async () => {
  try {
    const { data } = await api.get("/user/my-card/sudo");
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to fetch virtual cards. Please try again."] },
    };
  }
};

export const createSudoCards = async (payload) => {
  try {
    const { data } = await api.post("/user/my-card/sudo/create", payload, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
    return data;
  } catch (error) {
    console.log("Create virtual card error:", error);
    if (error.response) {
      return error.response.data;
    }
    return {
      message: { error: ["Failed to create virtual card. Please try again."] },
    };
  }
};

// Sudo: fees & charges — GET /user/my-card/sudo/charges
export const getSudoCharges = async () => {
  try {
    const { data } = await api.get("/user/my-card/sudo/charges");
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return {
      message: { error: ["Failed to load fees & charges. Please try again."] },
    };
  }
};

// Sudo: card holder (customer) details + dynamic form fields
// GET /user/my-card/sudo/edit/customer
export const getSudoCustomerInfo = async () => {
  try {
    const { data } = await api.get("/user/my-card/sudo/edit/customer");
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return {
      message: { error: ["Failed to load customer information."] },
    };
  }
};

// Sudo: update the card holder (customer)
// POST /user/my-card/sudo/update/customer  (multipart — carries KYC images)
export const updateSudoCustomer = async (payload) => {
  try {
    const { data } = await api.post(
      "/user/my-card/sudo/update/customer",
      payload,
      { headers: { "Content-Type": "multipart/form-data" } },
    );
    return data;
  } catch (error) {
    if (error.response?.data) return error.response.data;
    return {
      message: { error: ["Failed to update customer. Please try again."] },
    };
  }
};

// Get Remaining Limits
export const getRemainingLimits = async (params) => {
  try {
    const { data } = await api.get("/user/get-remaining", { params });
    return data;
  } catch (error) {
    console.error("Error fetching remaining limits:", error);
    if (error.response?.data) {
      return error.response.data;
    }
    return { message: { error: ["Failed to load remaining information"] } };
  }
};

// Public APIs (Submit contact form)
export const submitContactMessage = async (formData) => {
  try {
    const { data } = await api.post("/global/contact/message", {
      name: formData.name,
      email: formData.email,
      mobile: formData.phone,
      subject: formData.subject,
      message: formData.message,
    });
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred. Please try again."],
      },
    };
  }
};

// Subscribe to newsletter
export const subscribeNewsletter = async (email) => {
  try {
    const { data } = await api.post("/global/subscribe/request", { email });
    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred. Please try again."],
      },
    };
  }
};

// Get app settings (includes app_url for Android & iOS, reCAPTCHA keys, onboard screen data, etc.)
export const getAppSettings = async () => {
  try {
    const { data } = await api.get("/app-settings", {
      cache: {
        ttl: 30 * 60 * 1000,
      },
    });

    return data;
  } catch (error) {
    if (error.response?.data) {
      return error.response.data;
    }
    return {
      message: {
        error: ["An unexpected error occurred. Please try again."],
      },
    };
  }
};

// Get announcement list (for announcement page)
export const getSiteSectionData = async () => {
  try {
    const { data } = await api.get("/global/site-section-data");
    return data;
  } catch (error) {
    console.log("Error", error);
  }
};

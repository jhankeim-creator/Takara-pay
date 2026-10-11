import { useRouter } from "next/navigation";
import toast from "react-hot-toast";
import { logoutUser } from "../../utils/api";

export const useLogout = () => {
  const router = useRouter();

  const handleLogout = async () => {
    try {
      /* ===========================
         API REQUEST
      ============================ */
      const data = await logoutUser();

      /* ===========================
         SUCCESS RESPONSE HANDLING
      ============================ */

      // Backend sends success array
      if (data?.message?.success && Array.isArray(data.message.success)) {
        const successMsg = data.message.success.join(" • ");
        toast.success(successMsg);
      } else if (data?.message) {
        const msg =
          typeof data.message === "string"
            ? data.message
            : JSON.stringify(data.message);

        toast.success(msg);
      }
    } catch (error) {
      /* ===========================
         ERROR RESPONSE HANDLING
      ============================ */

      let errorMsg; // Required to avoid runtime crash

      if (error.response?.data?.message) {
        const msg = error.response.data.message;

        // Common backend pattern: error array
        if (msg.error && Array.isArray(msg.error)) {
          errorMsg = msg.error.join(" • ");
        }

        // Sometimes message itself is an array
        else if (Array.isArray(msg)) {
          errorMsg = msg.join(" • ");
        }

        // Simple string error
        else if (typeof msg === "string") {
          errorMsg = msg;
        }

        // Rare edge case: success array inside error response
        else if (msg.success && Array.isArray(msg.success)) {
          errorMsg = msg.success.join(" • ");
        }
      }

      // Show only server-provided message
      toast.error(errorMsg);
    } finally {
      /* ===========================
         CLIENT CLEANUP & REDIRECT
      ============================ */

      localStorage.removeItem("auth_token");
      localStorage.removeItem("user");
      localStorage.clear();
      sessionStorage.clear();

      router.push("/login");
    }
  };

  return { handleLogout };
};

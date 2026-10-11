import { Download } from "lucide-react";
import Image from "next/image";
import { useTranslations } from "next-intl"; 

const DownloadAuthenticatorApp = () => {
  const t = useTranslations("downloadAuthenticator"); 

  return (
    <div
      className="
      bg-white dark:bg-gray-800 
      rounded-2xl 
      shadow-lg dark:shadow-gray-900/50 
      p-8 w-full 
      flex flex-col 
      border border-gray-200 dark:border-gray-700
      transition-colors duration-200
    "
    >
      <h2
        className="
        text-lg 
        text-gray-700 dark:text-gray-200 
        text-center mb-4 
        font-medium
      "
      >
        {t("title")}
      </h2>

      <p
        className="
        text-sm 
        text-gray-600 dark:text-gray-400 
        text-center mb-8 
        leading-relaxed
      "
      >
        {t("description")}
      </p>

      <div className="flex justify-center mb-8">
        <div
          className="
          bg-gray-100 dark:bg-gray-700 
          p-4 rounded-2xl 
          shadow-sm dark:shadow-gray-900/30
        "
        >
          <Image
            src="/Two-Factor Authenticator-Sections/google-authenticator.webp"
            alt={t("imageAlt")}
            width={192}
            height={192}
            className="w-56 h-56 object-contain rounded-xl"
            priority
          />
        </div>
      </div>

      <a
        href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2"
        target="_blank"
        rel="noopener noreferrer"
        className="w-full mt-auto block"
      >
        <button
          className="
            cursor-pointer w-full py-3 
            rounded-lg 
            text-white font-semibold text-base 
            transition-all duration-200 
            flex items-center justify-center gap-2
            btn-primary
            shadow-md hover:shadow-lg
            active:scale-[0.985]
          "
        >
          <Download className="w-5 h-5" />
          {t("button")}
        </button>
      </a>
    </div>
  );
};

export default DownloadAuthenticatorApp;
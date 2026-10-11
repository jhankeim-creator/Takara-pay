import { NextIntlClientProvider } from "next-intl";
import { getMessages } from "next-intl/server";
import { DM_Mono, DM_Sans, Geist, Geist_Mono } from "next/font/google";
import { notFound } from "next/navigation";
import { Toaster } from "react-hot-toast";
import { routing } from "../../i18n/routing";
import "../globals.css";
import { AppSettingsProvider } from "../providers/AppSettingsProvider";
import { getAppSettings } from "../utils/getAppSettings";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
  display: "swap",
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
  display: "swap",
});

const dmSans = DM_Sans({
  variable: "--font-dm-sans",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800", "900"],
  display: "swap",
});

const dmMono = DM_Mono({
  variable: "--font-dm-mono",
  subsets: ["latin"],
  weight: ["300", "400", "500"],
  display: "swap",
});

export const metadata = {
  title: {
    default: "TAKARA PAY",
    template: "%s",
  },
  icons: {
    icon: "/logo/favicon-white.webp",
  },
};

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export default async function LocaleLayout({ children, params }) {
  const { locale } = await params;

  // Validate locale
  if (!routing.locales.includes(locale)) {
    notFound();
  }

  // Load messages for the current locale
  const messages = await getMessages({ locale });

  // App Settings API call
  const appData = await getAppSettings();

  // RTL support: Arabic reads right-to-left
  const direction = locale === "ar" ? "rtl" : "ltr";

  return (
    <html lang={locale} dir={direction}>
      <body
        className={`${geistSans.variable} ${geistMono.variable} ${dmSans.variable} ${dmMono.variable} antialiased`}
      >
        <NextIntlClientProvider locale={locale} messages={messages}>
          <AppSettingsProvider initialSettings={appData}>
            {children}
            <Toaster
              position="top-center"
              reverseOrder={false}
              gutter={8}
              toastOptions={{
                duration: 4000,
                style: {
                  background: "#333",
                  color: "#fff",
                  fontSize: "14px",
                },
                success: { duration: 3000 },
                error: { duration: 5000 },
              }}
            />
          </AppSettingsProvider>
        </NextIntlClientProvider>
      </body>
    </html>
  );
}

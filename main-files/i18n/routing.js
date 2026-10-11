import { defineRouting } from "next-intl/routing";

export const routing = defineRouting({
  // All supported locales — add new ones here
  locales: ["en", "ar", "es", "fr", "hi"],

  // Default locale (used when no locale matches)
  defaultLocale: "en",

  // URL prefix strategy: always show locale in URL
  localePrefix: "always",
});

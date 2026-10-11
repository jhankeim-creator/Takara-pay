import countries from "i18n-iso-countries";
import en from "i18n-iso-countries/langs/en.json";
import { getCountryCallingCode } from "libphonenumber-js";

countries.registerLocale(en);

export const countryOptions = Object.entries(
  countries.getNames("en", { select: "official" }),
)
  .map(([code, name]) => {
    try {
      return {
        code, // ISO code (US, GB, CA)
        name,
        callingCode: `+${getCountryCallingCode(code)}`,
      };
    } catch {
      // Countries like AQ (Antarctica) have no calling code
      return null;
    }
  })
  .filter(Boolean);

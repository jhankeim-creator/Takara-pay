"use client";

import { useDashboard } from "../../context/DashboardContext";
import CardyFie from "../Virtual-Card-CardyFie/CardyFie";
import Stripe from "../Virtual-Card-Stripe/Stripe";
import Sudo from "../Virtual-Card-Sudo/Sudo";
import Strowallet from "./Strowallet";

/* The admin can switch the active provider at any time and the value arrives as
   a free-form string — "sudo", "Sudo", "SUDO", "sudo_card", "Virtual Card
   (Sudo)" have all been seen. Matching it with === against a lowercase literal
   breaks on any casing or separator change, so normalise first. */
const PROVIDERS = [
  { match: "strowallet", Component: Strowallet, label: "Strowallet" },
  { match: "sudo", Component: Sudo, label: "Sudo" },
  { match: "cardyfie", Component: CardyFie, label: "CardyFie" },
  { match: "stripe", Component: Stripe, label: "Stripe" },
];

const normalise = (v) =>
  String(v ?? "")
    .toLowerCase()
    .replace(/[^a-z]/g, "");

// module_access flags can come back as booleans, 1/0 or "1"/"0".
const isEnabled = (v) =>
  v !== undefined &&
  v !== null &&
  v !== false &&
  v !== 0 &&
  v !== "0" &&
  v !== "" &&
  String(v).toLowerCase() !== "false";

const Notice = ({ title, children }) => (
  <div className="mx-auto max-w-lg rounded-2xl border border-gray-200 bg-white p-8 text-center shadow-sm dark:border-gray-700 dark:bg-gray-800">
    <h2 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
      {title}
    </h2>
    <div className="mt-2 text-sm text-gray-500 dark:text-gray-400">
      {children}
    </div>
  </div>
);

export default function VirtualCard() {
  // useDashboard returns undefined outside the provider — never destructure it
  // directly, or the whole page throws instead of rendering a message.
  const dashboard = useDashboard() || {};
  const { activeVirtualSystem, moduleAccess } = dashboard;

  /* The dashboard fetch can resolve without data (an API error payload has no
     `data`), which used to render "Unsupported system: undefined". */
  if (!moduleAccess) {
    return (
      <Notice title="Dashboard data unavailable">
        We could not read your account settings. Please refresh the page, and if
        it keeps happening sign in again.
      </Notice>
    );
  }

  if (!isEnabled(moduleAccess.virtual_card)) {
    return (
      <Notice title="Virtual cards are not available">
        This feature is not enabled for your account.
      </Notice>
    );
  }

  const key = normalise(activeVirtualSystem);
  const provider = key
    ? PROVIDERS.find((p) => key.includes(p.match))
    : undefined;

  if (provider) {
    const { Component } = provider;
    return <Component />;
  }

  /* No provider configured yet, or one this build does not implement. */
  return (
    <Notice title="No card provider configured">
      {key ? (
        <>
          The active provider{" "}
          <span className="font-semibold text-gray-700 dark:text-gray-300">
            {String(activeVirtualSystem)}
          </span>{" "}
          is not supported here. Supported:{" "}
          {PROVIDERS.map((p) => p.label).join(", ")}.
        </>
      ) : (
        "Your administrator has not selected a virtual card provider yet."
      )}
    </Notice>
  );
}

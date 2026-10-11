"use client";

import { createContext, useContext, useState } from "react";

const AppSettingsContext = createContext(undefined);

export function useAppSettings() {
  const context = useContext(AppSettingsContext);
  if (context === undefined) {
    console.log("useAppSettings must be used within AppSettingsProvider");
  }
  return context;
}

export function AppSettingsProvider({ children, initialSettings }) {
  const [appSettings] = useState(initialSettings);

  return (
    <AppSettingsContext.Provider value={{ appSettings }}>
      {children}
    </AppSettingsContext.Provider>
  );
}

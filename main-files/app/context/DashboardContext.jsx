"use client";

import { createContext, useContext } from "react";

const DashboardContext = createContext(undefined);

export function DashboardProvider({ children, value }) {
  return (
    <DashboardContext.Provider value={value}>
      {children}
    </DashboardContext.Provider>
  );
}

export function useDashboard() {
  const ctx = useContext(DashboardContext);
  if (!ctx) {
    console.log("useDashboard must be used inside DashboardProvider");
  }
  return ctx;
}

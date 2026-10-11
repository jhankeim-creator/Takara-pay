import DashboardLayoutClient from "./DashboardLayoutClient";

export const metadata = {
  title: "Dashboard",
};

export default function DashboardLayout({ children }) {
  return <DashboardLayoutClient>{children}</DashboardLayoutClient>;
}

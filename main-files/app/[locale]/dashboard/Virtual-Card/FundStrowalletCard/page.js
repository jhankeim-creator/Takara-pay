import { Suspense } from "react";
import FundStrowalletCard from "../../../../components/Virtual-Card/FundStrowalletCard";

export const metadata = {
  title: "Fund Virtual Card",
};

function page() {
  return (
    <Suspense fallback={null}>
      <FundStrowalletCard />
    </Suspense>
  );
}

export default page;

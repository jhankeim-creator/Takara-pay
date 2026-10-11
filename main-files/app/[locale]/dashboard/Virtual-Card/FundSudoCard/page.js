import { Suspense } from "react";
import FundSudoCard from "../../../../components/Virtual-Card/FundSudoCard";

export const metadata = {
  title: "Fund Virtual Card",
};

function page() {
  return (
    <Suspense fallback={null}>
      <FundSudoCard />
    </Suspense>
  );
}

export default page;

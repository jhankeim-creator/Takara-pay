import { Suspense } from "react";
import WithdrawStrowalletCard from "../../../../components/Virtual-Card/WithdrawStrowalletCard";

export const metadata = {
  title: "Withdraw from Virtual Card",
};

function page() {
  return (
    <Suspense fallback={null}>
      <WithdrawStrowalletCard />
    </Suspense>
  );
}

export default page;

import { Suspense } from "react";
import StrowalletCardTransactions from "../../../../components/Virtual-Card/StrowalletCardTransactions";

export const metadata = {
  title: "Card Transactions",
};

function page() {
  return (
    <Suspense fallback={null}>
      <StrowalletCardTransactions />
    </Suspense>
  );
}

export default page;

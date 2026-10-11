import { Suspense } from "react";
import SudoCardTransactions from "../../../../components/Virtual-Card/SudoCardTransactions";

export const metadata = {
  title: "Card Transactions",
};

function page() {
  return (
    <Suspense fallback={null}>
      <SudoCardTransactions />
    </Suspense>
  );
}

export default page;

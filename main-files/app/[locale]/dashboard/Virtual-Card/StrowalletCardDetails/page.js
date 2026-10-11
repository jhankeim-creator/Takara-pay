import { Suspense } from "react";
import StrowalletCardDetails from "../../../../components/Virtual-Card/StrowalletCardDetails";

export const metadata = {
  title: "Card Details",
};

function page() {
  return (
    <Suspense fallback={null}>
      <StrowalletCardDetails />
    </Suspense>
  );
}

export default page;

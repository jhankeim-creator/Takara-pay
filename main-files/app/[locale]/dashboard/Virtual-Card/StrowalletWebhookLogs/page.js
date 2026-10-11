import { Suspense } from "react";
import StrowalletWebhookLogs from "../../../../components/Virtual-Card/StrowalletWebhookLogs";

export const metadata = {
  title: "Webhook Logs",
};

function page() {
  return (
    <Suspense fallback={null}>
      <StrowalletWebhookLogs />
    </Suspense>
  );
}

export default page;

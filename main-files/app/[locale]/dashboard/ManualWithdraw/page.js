import ManualWithdraw from "../../../components/Withdraw-Money/ManualWithdraw";
import PaymentInformation from "../../../components/Withdraw-Money/PaymentInformation";

export const metadata = {
  title: "Withdraw Money",
};

export default function Page() {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-7 mb-7">
      <ManualWithdraw />
      <PaymentInformation />
    </div>
  );
}

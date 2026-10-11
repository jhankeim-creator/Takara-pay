import Footer from "../../(Home)/components/Footer";
import Navbar from "../../(Home)/components/Navbar";
import ForgotPasswordPage from "./ForgotPassword";

export const metadata = {
  title: "Forgot Password",
};

export default function Page() {
  return (
    <>
      <Navbar />
      <ForgotPasswordPage />
      <Footer />
    </>
  );
}

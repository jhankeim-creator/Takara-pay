import Footer from "../components/Footer";
import Navbar from "../components/Navbar";
import PrivacyPolicy from "../components/privacy-policy/PrivacyPolicy";

export const metadata = {
  title: "TAKARA PAY - Privacy Policy",
};

function page() {
  return (
    <main>
      <Navbar />
      <main className="pt-24">
        <PrivacyPolicy />
      </main>
      <Footer />
    </main>
  );
}

export default page;

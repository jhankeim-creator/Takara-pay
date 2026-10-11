import ContactUs from "../components/contactPageSections/ContactUs";
import Footer from "../components/Footer";
import Navbar from "../components/Navbar";

export const metadata = {
  title: "TAKARA PAY - Contact",
};

function ContactPage() {
  return (
    <>
      <Navbar />
      <main className="pt-24">
        <ContactUs />
      </main>
      <Footer />
    </>
  );
}

export default ContactPage;

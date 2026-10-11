import Footer from "../components/Footer";
import ServiceProvide from "../components/homePageSections/ServiceProvide";
import Navbar from "../components/Navbar";

export const metadata = {
  title: "StripCard - Services",
};

function ServicePage() {
  return (
    <>
      <Navbar />
      <ServiceProvide />
      <Footer />
    </>
  );
}

export default ServicePage;

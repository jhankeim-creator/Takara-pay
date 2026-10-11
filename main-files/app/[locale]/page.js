import Footer from "./(Home)/components/Footer";
import DownloadApp from "./(Home)/components/homePageSections/DownloadApp";
import HeroSection from "./(Home)/components/homePageSections/HeroSection";
import HowItWorks from "./(Home)/components/homePageSections/HowItWorks";
import ProjectOverview from "./(Home)/components/homePageSections/ProjectOverview";
import ServiceProvide from "./(Home)/components/homePageSections/ServiceProvide";
import WhyChooseUs from "./(Home)/components/homePageSections/WhyChooseUs";
import Navbar from "./(Home)/components/Navbar";

export const metadata = {
  title: "StripCard - Virtual Credit Card Solution ",
};

function RootHomePage() {
  return (
    <>
      <Navbar />
      <HeroSection />
      <ServiceProvide />
      <WhyChooseUs />
      <HowItWorks />
      <ProjectOverview />
      <DownloadApp />
      <Footer />
    </>
  );
}

export default RootHomePage;

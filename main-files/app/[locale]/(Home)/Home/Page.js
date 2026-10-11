import Footer from "../components/Footer";
import DownloadApp from "../components/homePageSections/DownloadApp";
import HeroSection from "../components/homePageSections/HeroSection";
import HowItWorks from "../components/homePageSections/HowItWorks";
import ProjectOverview from "../components/homePageSections/ProjectOverview";
import ServiceProvide from "../components/homePageSections/ServiceProvide";
import WhyChooseUs from "../components/homePageSections/WhyChooseUs";
import Navbar from "../components/Navbar";

import { getTranslations } from "next-intl/server";

export async function generateMetadata({ params }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Metadata" });

  return {
    title: t("home.title"),
    description: t("home.description"),
  };
}

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

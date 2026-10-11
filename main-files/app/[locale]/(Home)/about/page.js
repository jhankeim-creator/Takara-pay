import AboutSection from "../components/aboutPageSections/AboutUs";
import FaqSection from "../components/aboutPageSections/FaqSection";
import TestimonialsSection from "../components/aboutPageSections/UserTestimonials";
import Footer from "../components/Footer";
import Navbar from "../components/Navbar";

export const metadata = {
  title: "StripCard - About",
};

export default function AboutPage() {
  return (
    <>
      <Navbar />
      <main className="pt-24">
        <AboutSection />
        <TestimonialsSection />
        <FaqSection />
      </main>
      <Footer />
    </>
  );
}

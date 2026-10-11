import RecentAnnouncement from "../components/announcementPageSections/RecentAnnouncement";
import Footer from "../components/Footer";
import Navbar from "../components/Navbar";

export const metadata = {
  title: "StripCard - Announcement",
};

function page() {
  return (
    <>
      <Navbar />
      <main className="pt-24">
        <RecentAnnouncement />
      </main>
      <Footer />
    </>
  );
}

export default page;

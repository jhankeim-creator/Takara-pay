import Footer from "../../(Home)/components/Footer";
import Navbar from "../../(Home)/components/Navbar";
import RegisterPage from "./RegisterPage";

export const metadata = {
  title: "Registration",
};

export default function Page() {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      <main className="flex-grow pt-24 pb-16">
        <RegisterPage />
      </main>
      <Footer />
    </div>
  );
}

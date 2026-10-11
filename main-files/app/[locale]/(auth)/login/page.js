import Footer from "../../(Home)/components/Footer";
import Navbar from "../../(Home)/components/Navbar";
import LoginPage from "./LoginPage";

export const metadata = {
  title: "Login",
  description: "Secure login to your StripCard account",
};

export default function Page() {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      <main className="flex-grow pt-24 pb-16">
        <LoginPage />
      </main>
      <Footer />
    </div>
  );
}

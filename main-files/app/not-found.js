import NotFoundActions from "./components/NotFoundActions/NotFoundActions";
import "./globals.css";

export const metadata = {
  title: "404 - Page Not Found",
  description: "The page you are looking for does not exist.",
  icons: {
    icon: "/logo/favicon-white.webp",
  },
};

export default function NotFound() {
  return (
    <div className="relative flex min-h-screen items-center justify-center overflow-hidden bg-[#f8f7f4] px-6 transition-colors duration-300 dark:bg-slate-950">
      {/* Background Orbs */}
      <div className="pointer-events-none absolute inset-0">
        <div className="absolute -top-[8%] -left-[8%] h-[45%] w-[45%] rounded-full bg-blue-300/30 blur-[80px] dark:bg-blue-600/10" />
        <div className="absolute -bottom-[8%] -right-[8%] h-[40%] w-[40%] rounded-full bg-blue-400/20 blur-[80px] dark:bg-blue-900/15" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 h-[25%] w-[25%] rounded-full bg-indigo-300/15 blur-[100px] dark:bg-indigo-500/5" />
      </div>

      <div className="relative z-10 text-center max-w-lg">
        {/* Italic serif 404 */}
        <p className="select-none font-serif italic text-[clamp(7rem,18vw,11rem)] font-semibold leading-none tracking-[-4px] text-blue-600/20 dark:text-blue-400/20">
          404
        </p>

        <div className="mt-4 md:mt-6">
          {/* Accent divider */}
          <div className="mx-auto mb-5 h-0.5 w-8 rounded-full bg-blue-500/60 dark:bg-blue-400/50" />

          <h2 className="font-serif text-[clamp(1.8rem,4vw,2.7rem)] italic font-semibold leading-tight tracking-tight text-slate-950 dark:text-white">
            Lost in Space?
          </h2>

          <p className="mx-auto mt-4 max-w-md text-[16px] font-normal leading-relaxed text-slate-700 dark:text-slate-300">
            The page you’re looking for doesn’t exist or may have been moved.
            Return to the home page to continue exploring.
          </p>
        </div>

        <NotFoundActions />
      </div>
    </div>
  );
}

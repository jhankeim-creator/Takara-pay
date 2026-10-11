"use client";

export default function NotFoundActions() {
  return (
    <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row sm:gap-6">
      <button
        onClick={() => (window.location.href = "/")}
        className="cursor-pointer group relative w-full overflow-hidden rounded-full bg-blue-600 px-8 py-4 text-sm font-bold text-white shadow-2xl shadow-blue-500/40 transition-all hover:bg-blue-700 hover:shadow-blue-600/50 active:scale-95 sm:w-auto"
      >
        <span className="relative z-10">Return Home</span>
        <div className="absolute inset-0 -translate-x-full bg-gradient-to-r from-transparent via-white/20 to-transparent transition-transform duration-500 group-hover:translate-x-full" />
      </button>
    </div>
  );
}

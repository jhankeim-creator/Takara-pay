import { Globe } from "lucide-react";

export default function GlobeIcon() {
  return (
    <button
      className={`
        p-2 rounded-lg 
        hover:bg-gray-100 dark:hover:bg-gray-800 
        active:bg-gray-200 dark:active:bg-gray-700
        transition-colors duration-150 cursor-pointer
      `}
      aria-label="Language"
    >
      <Globe size={20} className="text-gray-900 dark:text-gray-200" />
    </button>
  );
}

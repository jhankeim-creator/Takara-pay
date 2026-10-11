import { Bell, Clock, Loader2 } from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useRef, useState } from "react";
import { getUserNotifications } from "../../utils/api";

export default function NotificationBell() {
  const t = useTranslations("Notifications");
  const [isOpen, setIsOpen] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(false);
  const dropdownRef = useRef(null);

  const fetchNotifications = async () => {
    setLoading(true);
    try {
      const response = await getUserNotifications();
      if (response?.data?.notifications) {
        // Sort by latest first
        const sorted = response.data.notifications.sort((a, b) => 
          new Date(b.created_at) - new Date(a.created_at)
        );
        setNotifications(sorted);
      }
    } catch (error) {
      console.log("Error fetching notifications", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchNotifications();
  }, []);

  useEffect(() => {
    if (isOpen) {
      fetchNotifications();
    }
  }, [isOpen]);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const formatRelativeTime = (dateString) => {
    if (!dateString) return "";
    const now = new Date();
    const date = new Date(dateString);
    const diffInSeconds = Math.floor((now - date) / 1000);

    if (diffInSeconds < 60) return t("justNow");
    
    const diffInMinutes = Math.floor(diffInSeconds / 60);
    if (diffInMinutes < 60) return t("minutesAgo", { minutes: diffInMinutes });
    
    const diffInHours = Math.floor(diffInMinutes / 60);
    if (diffInHours < 24) return t("hoursAgo", { hours: diffInHours });
    
    const diffInDays = Math.floor(diffInHours / 24);
    if (diffInDays === 1) return t("yesterday");
    if (diffInDays < 7) return t("daysAgo", { days: diffInDays });
    
    return date.toLocaleDateString();
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className={`
          p-2 rounded-lg 
          hover:bg-gray-100 dark:hover:bg-gray-800 
          active:bg-gray-200 dark:active:bg-gray-700
          transition-colors duration-150 cursor-pointer
          relative group
        `}
        aria-label="Notifications"
      >
        <Bell size={20} className="text-gray-900 dark:text-gray-200 group-hover:scale-110 transition-transform" />
        {notifications.length > 0 && (
          <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full border border-white dark:border-gray-900 animate-pulse"></span>
        )}
      </button>

      {isOpen && (
        <div className="absolute ltr:-right-12 sm:ltr:right-0 rtl:-left-12 sm:rtl:left-0 mt-3 w-80 sm:w-85 bg-white dark:bg-gray-900 rounded-2xl shadow-2xl border border-gray-100 dark:border-gray-800 z-50 overflow-hidden animate-in fade-in zoom-in duration-200">
          <div className="p-4 bg-gray-50/50 dark:bg-gray-800/50 border-b border-gray-100 dark:border-gray-800 flex justify-between items-center">
            <h3 className="font-bold text-gray-900 dark:text-gray-100">{t("title")}</h3>
          </div>

          <div className="max-h-[420px] overflow-y-auto custom-scrollbar">
            {loading ? (
              <div className="flex flex-col justify-center items-center py-16 gap-3">
                <Loader2 className="w-8 h-8 animate-spin text-primary-500" />
                <p className="text-xs text-gray-500 font-medium">{t("loading")}</p>
              </div>
            ) : notifications.length > 0 ? (
              <div className="divide-y divide-gray-50 dark:divide-gray-800/50">
                {notifications.slice(0, 4).map((notification, index) => (
                  <div
                    key={index}
                    className="p-4 hover:bg-gray-50/80 dark:hover:bg-gray-800/40 transition-colors cursor-default"
                  >
                    <div className="flex justify-between items-start gap-3 mb-1">
                      <p className="text-base font-bold text-gray-900 dark:text-gray-100 flex-1">
                        {notification.title}
                      </p>
                      <div className="flex items-center gap-1 text-xs text-blue-500 dark:text-blue-400 whitespace-nowrap pt-0.5">
                        <Clock size={10} />
                        {formatRelativeTime(notification.created_at)}
                      </div>
                    </div>
                    <p className="text-sm text-gray-600 dark:text-gray-400 leading-relaxed">
                      {notification.message}
                    </p>
                  </div>
                ))}
              </div>
            ) : (
              <div className="py-20 text-center">
                <div className="relative inline-block mb-4">
                  <Bell className="w-12 h-12 text-gray-100 dark:text-gray-800 mx-auto" />
                  <div className="absolute inset-0 bg-gradient-to-t from-white dark:from-gray-900 to-transparent"></div>
                </div>
                <p className="text-sm text-gray-500 dark:text-gray-400 font-semibold">{t("empty")}</p>
                <p className="text-sm text-gray-400 dark:text-gray-500 mt-1">{t("emptyMsg")}</p>
              </div>
            )}
          </div>
          
          
        </div>
      )}
    </div>
  );
}

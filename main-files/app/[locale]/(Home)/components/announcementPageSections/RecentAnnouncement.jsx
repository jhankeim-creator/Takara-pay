"use client";

import {
  ArrowLeft,
  ChevronRight,
  Clock,
  Folder,
  Sparkles,
  Tag,
} from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import Image from "next/image";
import { useEffect, useState } from "react";
import { getSiteSectionData } from "../../../../utils/api";
import SkeletonLoader from "./SkeletonLoader";

// Constants

const categoryColorMap = {
  Finance:
    "bg-blue-50/80 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 border-blue-200/60 dark:border-blue-700/50",
  Insurance:
    "bg-purple-50/80 dark:bg-purple-900/30 text-purple-700 dark:text-purple-300 border-purple-200/60 dark:border-purple-700/50",
  Help: "bg-emerald-50/80 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-300 border-emerald-200/60 dark:border-emerald-700/50",
  Taxes:
    "bg-amber-50/80 dark:bg-amber-900/30 text-amber-700 dark:text-amber-300 border-amber-200/60 dark:border-amber-700/50",
  "Credit Card":
    "bg-rose-50/80 dark:bg-rose-900/30 text-rose-700 dark:text-rose-300 border-rose-200/60 dark:border-rose-700/50",
};

// Helper
function mapAnnouncements(rawList, locale, baseUrl, imagePath, defaultImage) {
  const fallbackImage = `${baseUrl}${defaultImage}`;

  return rawList.map((item) => {
    const nameLang = item.name.language[locale] ?? item.name.language["en"];
    const detailLang =
      item.details.language[locale] ?? item.details.language["en"];

    const image = item.image
      ? `${baseUrl}${imagePath}/${item.image}`
      : fallbackImage;

    return {
      id: item.id,
      image,
      title: nameLang?.name ?? "",
      details: detailLang?.details ?? "",
      date: new Date(item.created_at)
        .toLocaleDateString("en-GB")
        .replace(/\//g, "-"),
      tags: item.tags ?? [],
    };
  });
}

// Detail Page
function AnnouncementDetail({
  item,
  onSelect,
  onBack,
  allAnnouncements,
  categories,
}) {
  const t = useTranslations("Announcements");
  const recentPosts = allAnnouncements.filter((a) => a.id !== item.id);

  return (
    <section className="relative min-h-screen pt-8 pb-16 dark:from-gray-800 dark:via-indigo-850 dark:to-purple-950 overflow-hidden">
      {/* Decorative blobs */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-16 left-10 md:left-20 w-72 h-72 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-12 right-10 md:right-20 w-96 h-96 bg-indigo-400/10 dark:bg-indigo-500/5 rounded-full blur-3xl animate-pulse" />
      </div>

      <div className="relative container mx-auto px-5 sm:px-6 lg:px-8 max-w-7xl">
        {/* Back button */}
        <button
          onClick={onBack}
          className="cursor-pointer mb-8 inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm border border-blue-100 dark:border-blue-800/50 text-indigo-700 dark:text-indigo-300 font-medium shadow-sm hover:shadow-md hover:bg-white dark:hover:bg-gray-800 transition-all duration-200 text-sm"
        >
          <ArrowLeft size={16} />
          {t("detail.backButton")}
        </button>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:gap-10">
          {/* Main Content */}
          <div className="lg:col-span-2">
            <div className="bg-white/75 dark:bg-gray-800/70 backdrop-blur-sm rounded-2xl shadow-lg shadow-blue-200/10 dark:shadow-blue-500/5 border border-blue-100/60 dark:border-blue-800/50 overflow-hidden">
              {/* Hero image */}
              <div className="relative w-full aspect-video overflow-hidden">
                <Image
                  src={item.image}
                  alt={item.title}
                  fill
                  className="object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/40 via-transparent to-transparent" />
              </div>

              <div className="p-6 md:p-8 lg:p-10">
                {/* Meta */}
                <div className="flex items-center gap-2 text-sm text-slate-500 dark:text-slate-400 mb-4">
                  <Clock size={15} />
                  <span>{item.date}</span>
                </div>

                {/* Title */}
                <h1 className="text-2xl md:text-3xl lg:text-4xl font-bold text-slate-900 dark:text-slate-100 leading-tight mb-6">
                  {item.title}
                </h1>

                {/* Divider */}
                <div className="h-px bg-gradient-to-r from-blue-200 via-indigo-200 to-transparent dark:from-blue-800 dark:via-indigo-800 mb-6" />

                {/* HTML coming from the API */}
                <div
                  className="prose prose-slate dark:prose-invert prose-lg max-w-none leading-relaxed text-slate-700 dark:text-slate-300"
                  dangerouslySetInnerHTML={{ __html: item.details }}
                />

                {/* Tags */}
                <div className="mt-8 pt-6 border-t border-slate-100/80 dark:border-gray-700">
                  <div className="flex items-center gap-2 mb-3">
                    <Tag
                      size={15}
                      className="text-indigo-500 dark:text-indigo-400"
                    />
                    <h4 className="text-sm font-semibold text-slate-700 dark:text-slate-200 uppercase tracking-wider">
                      {t("detail.tagsTitle")}
                    </h4>
                  </div>
                  <div className="flex flex-wrap gap-2">
                    {item.tags.map((tag, idx) => (
                      <span
                        key={idx}
                        className="px-3.5 py-1.5 bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-900/30 dark:to-indigo-900/30 text-indigo-700 dark:text-indigo-300 rounded-full text-sm font-medium border border-indigo-100/70 dark:border-indigo-800/50 hover:border-indigo-300 dark:hover:border-indigo-600 transition-colors cursor-pointer"
                      >
                        #{tag}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Categories */}
            <div className="bg-white/75 dark:bg-gray-800/70 backdrop-blur-sm rounded-2xl shadow-lg shadow-blue-200/10 dark:shadow-blue-500/5 border border-blue-100/60 dark:border-blue-800/50 p-6">
              <div className="flex items-center gap-2 mb-5">
                <Folder
                  size={16}
                  className="text-blue-600 dark:text-blue-400"
                />
                <h3 className="font-bold text-slate-900 dark:text-slate-100 text-base uppercase tracking-wide">
                  {t("detail.categoriesTitle")}
                </h3>
              </div>
              <ul className="space-y-2">
                {categories.map((cat, idx) => (
                  <li key={idx}>
                    <button className="cursor-pointer w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl hover:bg-blue-50 dark:hover:bg-blue-900/20 transition-colors group">
                      <div className="flex items-center gap-2.5">
                        {/* <ChevronRight
                          size={14}
                          className="text-blue-400 dark:text-blue-500 group-hover:text-blue-600 dark:group-hover:text-blue-300 transition-colors"
                        /> */}
                        <span className="text-sm font-medium text-slate-700 dark:text-slate-300 group-hover:text-blue-700 dark:group-hover:text-blue-300 transition-colors">
                          {cat.name}
                        </span>
                      </div>
                      {/* API's has_announcements count */}
                      <span
                        className={`text-xs font-semibold px-2 py-0.5 rounded-full border ${
                          categoryColorMap[cat.name] ??
                          "bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-600"
                        }`}
                      >
                        {cat.has_announcements}
                      </span>
                    </button>
                  </li>
                ))}
              </ul>
            </div>

            {/* Recent Posts */}
            <div className="bg-white/75 dark:bg-gray-800/70 backdrop-blur-sm rounded-2xl shadow-lg shadow-blue-200/10 dark:shadow-blue-500/5 border border-blue-100/60 dark:border-blue-800/50 p-6">
              <div className="flex items-center gap-2 mb-5">
                <Sparkles
                  size={16}
                  className="text-blue-600 dark:text-blue-400"
                />
                <h3 className="font-bold text-slate-900 dark:text-slate-100 text-base uppercase tracking-wide">
                  {t("detail.recentPostsTitle")}
                </h3>
              </div>
              <div className="space-y-4">
                {recentPosts.map((post) => (
                  <button
                    key={post.id}
                    onClick={() => onSelect(post)}
                    className="cursor-pointer w-full flex gap-3 group text-left"
                  >
                    <div className="relative w-16 h-16 rounded-xl overflow-hidden shrink-0 border border-blue-100/60 dark:border-blue-800/40">
                      <Image
                        src={post.image}
                        alt={post.title}
                        fill
                        className="object-cover group-hover:scale-105 transition-transform duration-300"
                      />
                    </div>
                    <div className="flex flex-col justify-center min-w-0">
                      <p className="text-sm font-semibold text-slate-800 dark:text-slate-200 line-clamp-2 group-hover:text-blue-700 dark:group-hover:text-blue-400 transition-colors leading-snug">
                        {post.title}
                      </p>
                      <div className="flex items-center gap-1 mt-1.5 text-xs text-slate-500 dark:text-slate-400">
                        <Clock size={12} />
                        {post.date}
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            </div>

            {/* Tags sidebar */}
            <div className="bg-white/75 dark:bg-gray-800/70 backdrop-blur-sm rounded-2xl shadow-lg shadow-blue-200/10 dark:shadow-blue-500/5 border border-blue-100/60 dark:border-blue-800/50 p-6">
              <div className="flex items-center gap-2 mb-5">
                <Tag size={16} className="text-blue-600 dark:text-blue-400" />
                <h3 className="font-bold text-slate-900 dark:text-slate-100 text-base uppercase tracking-wide">
                  {t("detail.tagsTitle")}
                </h3>
              </div>
              <div className="flex flex-wrap gap-2">
                {item.tags.map((tag, idx) => (
                  <span
                    key={idx}
                    className="px-3 py-1.5 bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-900/30 dark:to-indigo-900/30 text-indigo-700 dark:text-indigo-300 rounded-full text-xs font-medium border border-indigo-100/70 dark:border-indigo-800/50 cursor-pointer hover:border-indigo-300 dark:hover:border-indigo-600 transition-colors"
                  >
                    #{tag}
                  </span>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

// List Page
function AnnouncementList({ announcements, onSelect }) {
  const t = useTranslations("Announcements");

  return (
    <section className="relative pt-8 pb-12 md:pt-12 md:pb-16 lg:pt-16 lg:pb-20 dark:from-gray-800 dark:via-indigo-850 dark:to-purple-950 overflow-hidden">
      {/* Decorative blobs */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-16 left-10 md:left-20 w-64 h-64 md:w-72 md:h-72 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-12 right-10 md:right-20 w-80 h-80 md:w-96 md:h-96 bg-indigo-400/10 dark:bg-indigo-500/5 rounded-full blur-3xl animate-pulse" />
      </div>

      <div className="relative container mx-auto px-5 sm:px-6 lg:px-8 max-w-7xl -mt-4 md:-mt-6 lg:-mt-8">
        {/* Header */}
        <div className="text-center mb-6 md:mb-10">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm shadow-lg shadow-blue-500/10 dark:shadow-blue-500/5 border border-blue-100 dark:border-blue-800/50 mx-auto mb-4">
            <Sparkles className="w-4 h-4 text-blue-600 dark:text-blue-400" />
            <span className="text-xs uppercase tracking-widest bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400 bg-clip-text text-transparent font-semibold">
              {t("list.badge")}
            </span>
          </div>
          <h2 className="text-3xl md:text-4xl font-bold text-slate-900 dark:text-slate-100 leading-tight">
            {t("list.title.part1")}{" "}
            <span className="bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400 bg-clip-text text-transparent">
              {t("list.title.highlight")}
            </span>
          </h2>
        </div>

        {/* Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5 lg:gap-6">
          {announcements.map((item) => (
            <div
              key={item.id}
              className="group relative bg-white/75 dark:bg-gray-800/70 backdrop-blur-sm rounded-2xl shadow-lg shadow-blue-200/10 dark:shadow-blue-500/5 border border-blue-100/60 dark:border-blue-800/50 overflow-hidden transition-all duration-300 hover:shadow-xl hover:shadow-blue-300/20 dark:hover:shadow-blue-500/10 hover:-translate-y-2 hover:border-blue-200/70 dark:hover:border-blue-700 flex flex-col cursor-pointer"
              onClick={() => onSelect(item)}
            >
              <div className="relative h-48 overflow-hidden shrink-0">
                <Image
                  src={item.image}
                  alt={item.title}
                  fill
                  className="object-cover transition-transform duration-700 group-hover:scale-110"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/30 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
              </div>

              <div className="p-5 md:p-6 flex flex-col grow">
                <h3 className="text-lg md:text-xl font-semibold text-slate-900 dark:text-slate-100 mb-2.5 line-clamp-2 group-hover:text-blue-700 dark:group-hover:text-blue-400 transition-colors">
                  {item.title}
                </h3>
                {/* API details HTML — as a preview in the card */}
                <div
                  className="text-slate-600 dark:text-slate-300 mb-5 line-clamp-3 grow text-[15px] leading-relaxed"
                  dangerouslySetInnerHTML={{ __html: item.details }}
                />
                <div className="flex items-center justify-between text-sm mt-auto pt-4 border-t border-slate-100/80 dark:border-gray-700">
                  <div className="flex items-center gap-1.5 text-slate-500 dark:text-slate-300 font-medium">
                    <Clock size={16} />
                    {item.date}
                  </div>
                  <span className="text-blue-600 dark:text-blue-400 font-semibold flex items-center gap-1.5 group-hover:gap-2 transition-all">
                    {t("list.readMore")}
                    <span aria-hidden="true">→</span>
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

// Root Component
export default function RecentAnnouncement() {
  const [selectedAnnouncement, setSelectedAnnouncement] = useState(null);
  const [announcements, setAnnouncements] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);

  const locale = useLocale();

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        const json = await getSiteSectionData();

        const rawAnnouncements = json?.data?.announcements ?? [];
        const rawCategories = json?.data?.announcement_categories ?? [];
        const baseUrl = json?.data?.base_url ?? "";
        const imagePath = json?.data?.image_path ?? "";
        const defaultImage = json?.data?.default_image ?? "";

        setAnnouncements(mapAnnouncements(rawAnnouncements, locale, baseUrl, imagePath, defaultImage));
        setCategories(rawCategories);
      } catch (err) {
        console.log("Announcements fetch failed:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [locale]);

  // Scroll to top when navigating between list and details
  useEffect(() => {
    if (typeof window !== "undefined" && !loading) {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedAnnouncement]);

  if (loading) {
    return <SkeletonLoader />;
  }

  if (selectedAnnouncement) {
    return (
      <AnnouncementDetail
        item={selectedAnnouncement}
        onSelect={setSelectedAnnouncement}
        onBack={() => setSelectedAnnouncement(null)}
        allAnnouncements={announcements}
        categories={categories}
      />
    );
  }

  return (
    <AnnouncementList
      announcements={announcements}
      onSelect={setSelectedAnnouncement}
    />
  );
}
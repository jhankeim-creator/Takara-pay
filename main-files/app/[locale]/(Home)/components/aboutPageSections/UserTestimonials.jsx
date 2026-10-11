"use client";

import { Quote, Star } from "lucide-react";
import { useTranslations } from "next-intl";
import Image from "next/image";

export default function TestimonialsSection() {
  const t = useTranslations("Testimonials");

  const testimonials = [
    {
      name: t("testimonials.0.name"),
      role: t("testimonials.0.role"),
      image: "/UserTestimonials/Freelancer.webp",
      text: t("testimonials.0.text"),
      rating: 5,
    },
    {
      name: t("testimonials.1.name"),
      role: t("testimonials.1.role"),
      image: "/UserTestimonials/Entrepreneur.webp",
      text: t("testimonials.1.text"),
      rating: 5,
    },
    {
      name: t("testimonials.2.name"),
      role: t("testimonials.2.role"),
      image: "/UserTestimonials/Content_Creator.webp",
      text: t("testimonials.2.text"),
      rating: 5,
    },
  ];

  return (
    <section className="relative py-16 md:py-20 lg:py-24 bg-gradient-to-r from-slate-50 via-blue-50 to-indigo-100 dark:from-gray-950 dark:via-indigo-950 dark:to-purple-950 overflow-hidden">
      {/* Subtle Background Pattern */}
      <div
        className="absolute inset-0 opacity-[0.015] dark:opacity-[0.03]"
        style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23000000' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
        }}
      />

      {/* Decorative top wave */}
      <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-blue-200 to-transparent dark:via-blue-600 opacity-50" />

      <div className="relative container mx-auto px-4 sm:px-6 lg:px-8 max-w-7xl">
        {/* Header */}
        <div className="text-center mb-12 md:mb-16">
          {/* Small badge */}
          <div className="animate-[--animate-fade-up]">
            <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/85 backdrop-blur-xl border border-indigo-500/15 shadow-[0_2px_16px_rgb(99_102_241/0.12)] text-sm font-semibold text-indigo-700 dark:bg-slate-900/80 dark:border-indigo-400/20 dark:text-indigo-300">
              <span className="size-1.5 rounded-full bg-indigo-600 dark:bg-indigo-400 animate-[--animate-pulse-dot]" />

              {t("header.badge")}
            </span>
          </div>

          {/* Main title */}
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold text-slate-900 dark:text-slate-100 mb-6 max-w-4xl mx-auto leading-tight">
            {t("header.title.main")}{" "}
            <span className="bg-gradient-to-r from-blue-600 via-indigo-600 to-violet-600 dark:from-blue-400 dark:via-indigo-400 dark:to-violet-400 bg-clip-text text-transparent">
              {t("header.title.highlight")}
            </span>{" "}
            {t("header.title.suffix")}
          </h2>

          {/* Description */}
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-300 leading-relaxed max-w-4xl mx-auto">
            {t("header.description")}
          </p>
        </div>

        {/* Testimonials Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
          {testimonials.map((testimonial, index) => (
            <div
              key={index}
              className="group bg-gradient-to-r from-slate-50 to-blue-50/30 dark:from-gray-800 dark:to-gray-900 rounded-2xl shadow-md hover:shadow-2xl transition-all duration-300 hover:-translate-y-1 border border-slate-200/50 dark:border-gray-700 overflow-hidden flex flex-col h-full"
            >
              <div className="p-6 md:p-8 flex flex-col grow">
                {/* Quote icon */}
                <div className="mb-6">
                  <div className="w-12 h-12 bg-gradient-to-r from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                    <Quote className="w-6 h-6 text-white" />
                  </div>
                </div>

                {/* Star Rating */}
                <div className="flex gap-1 mb-6">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <Star
                      key={i}
                      className="w-5 h-5 fill-yellow-400 dark:fill-yellow-300 text-yellow-400 dark:text-yellow-300"
                    />
                  ))}
                </div>

                {/* Testimonial Text – grows to push footer down */}
                <blockquote className="text-slate-700 dark:text-slate-300 leading-relaxed text-sm md:text-base mb-6 grow">
                  &quot;{testimonial.text}&quot;
                </blockquote>

                {/* Author Info – always at bottom */}
                <div className="flex items-center gap-4 pt-6 border-t border-slate-200/50 dark:border-gray-700 mt-auto">
                  <div className="relative w-14 h-14 rounded-full overflow-hidden ring-2 ring-blue-100 dark:ring-blue-800 shrink-0">
                    <Image
                      src={testimonial.image}
                      alt={testimonial.name}
                      fill
                      className="object-cover"
                    />
                  </div>
                  <div>
                    <h4 className="text-base md:text-lg font-bold text-slate-900 dark:text-slate-100">
                      {testimonial.name}
                    </h4>
                    <p className="text-sm text-slate-600 dark:text-slate-300">
                      {testimonial.role}
                    </p>
                  </div>
                </div>
              </div>

              {/* Bottom accent line */}
              <div className="h-1 bg-gradient-to-r from-blue-500 via-indigo-500 to-violet-500 dark:from-blue-600 dark:via-indigo-600 dark:to-violet-600 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300 origin-left" />
            </div>
          ))}
        </div>

        {/* Bottom CTA or stats */}
        <div className="mt-12 md:mt-16 text-center">
          <div className="inline-flex items-center gap-6 px-8 py-4 bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-900/30 dark:to-indigo-900/30 rounded-2xl border border-blue-100 dark:border-blue-800/50">
            <div className="text-center">
              <p className="text-2xl md:text-3xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400 bg-clip-text text-transparent">
                {t("stats.users.count")}
              </p>
              <p className="text-xs md:text-sm text-slate-600 dark:text-slate-300 font-medium">
                {t("stats.users.label")}
              </p>
            </div>
            <div className="w-px h-12 bg-slate-300 dark:bg-gray-600" />
            <div className="text-center">
              <div className="flex gap-1 justify-center">
                {[...Array(5)].map((_, i) => (
                  <Star
                    key={i}
                    className="w-4 h-4 md:w-5 md:h-5 fill-yellow-400 dark:fill-yellow-300 text-yellow-400 dark:text-yellow-300"
                  />
                ))}
              </div>
              <p className="text-xs md:text-sm text-slate-600 dark:text-slate-300 font-medium mt-1">
                {t("stats.rating")}
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

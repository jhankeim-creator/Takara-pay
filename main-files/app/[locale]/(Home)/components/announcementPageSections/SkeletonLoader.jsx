import React from "react";

export default function SkeletonLoader() {
  return (
    <section className="relative pt-8 pb-12 md:pt-12 md:pb-16 lg:pt-16 lg:pb-20 dark:from-gray-800 dark:via-indigo-850 dark:to-purple-950 overflow-hidden">
      {/* Decorative blobs */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-16 left-10 md:left-20 w-64 h-64 md:w-72 md:h-72 bg-blue-400/10 dark:bg-blue-500/5 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-12 right-10 md:right-20 w-80 h-80 md:w-96 md:h-96 bg-indigo-400/10 dark:bg-indigo-500/5 rounded-full blur-3xl animate-pulse" />
      </div>

      <div className="relative container mx-auto px-5 sm:px-6 lg:px-8 max-w-7xl -mt-4 md:-mt-6 lg:-mt-8">
        {/* Header Skeleton */}
        <div className="text-center mb-6 md:mb-10">
          <div className="w-40 h-8 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded-full mx-auto mb-4" />
          <div className="w-3/4 max-w-md h-10 md:h-12 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded-xl mx-auto" />
        </div>

        {/* Cards Skeleton */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5 lg:gap-6">
          {[1, 2, 3].map((item) => (
            <div
              key={item}
              className="bg-white/75 dark:bg-gray-800/70 backdrop-blur-sm rounded-2xl border border-blue-100/60 dark:border-blue-800/50 overflow-hidden flex flex-col"
            >
              <div className="h-48 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse shrink-0" />

              <div className="p-5 md:p-6 flex flex-col grow">
                <div className="h-6 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded mb-2.5 w-3/4" />
                <div className="h-6 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded mb-5 w-1/2" />
                
                <div className="space-y-2 mb-5 grow">
                  <div className="h-4 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded w-full" />
                  <div className="h-4 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded w-full" />
                  <div className="h-4 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded w-4/5" />
                </div>
                
                <div className="flex items-center justify-between mt-auto pt-4 border-t border-slate-100/80 dark:border-gray-700">
                  <div className="h-4 w-24 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded" />
                  <div className="h-4 w-20 bg-gray-200/80 dark:bg-gray-700/80 animate-pulse rounded" />
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

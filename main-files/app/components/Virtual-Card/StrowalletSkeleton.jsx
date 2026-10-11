import React from "react";

export default function StrowalletSkeleton() {
  return (
    <div className="w-full">
      {/* Header Skeleton */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-6 mb-8">
        <div className="h-9 w-48 bg-gray-200 dark:bg-gray-700 rounded-lg animate-pulse" />
        <div className="h-12 w-48 bg-gray-200 dark:bg-gray-700 rounded-xl animate-pulse" />
      </div>

      {/* Cards Grid Skeleton */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {[1, 2, 3].map((i) => (
          <div
            key={i}
            className="relative rounded-3xl h-72 bg-gray-100 dark:bg-gray-800/60 border border-gray-200 dark:border-gray-700 animate-pulse overflow-hidden"
          >
            {/* Status Indicator */}
            <div className="absolute top-6 left-1/2 -translate-x-1/2 z-20">
              <div className="w-20 h-6 bg-gray-200 dark:bg-gray-700 rounded-full" />
            </div>

            <div className="relative h-full p-6 flex flex-col justify-between z-10">
              {/* Top Row: Title and Logo */}
              <div className="flex justify-between items-start">
                <div className="w-24 h-6 bg-gray-200 dark:bg-gray-700 rounded-md" />
                <div className="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-full" />
              </div>

              {/* Chips */}
              <div className="flex items-center gap-4">
                <div className="w-14 h-10 bg-gray-200 dark:bg-gray-700 rounded-md" />
                <div className="w-9 h-9 bg-gray-200 dark:bg-gray-700 rounded-full" />
              </div>

              {/* Bottom Row: Card Number and Details */}
              <div className="mt-auto space-y-4">
                {/* Card Number */}
                <div className="w-3/4 h-6 bg-gray-200 dark:bg-gray-700 rounded-md" />
                
                {/* Balance / Expire Date */}
                <div className="flex justify-between">
                  <div className="space-y-2">
                    <div className="w-10 h-3 bg-gray-200 dark:bg-gray-700 rounded-sm" />
                    <div className="w-16 h-4 bg-gray-200 dark:bg-gray-700 rounded-md" />
                  </div>
                  <div className="space-y-2 text-right flex flex-col items-end">
                    <div className="w-10 h-3 bg-gray-200 dark:bg-gray-700 rounded-sm" />
                    <div className="w-16 h-4 bg-gray-200 dark:bg-gray-700 rounded-md" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

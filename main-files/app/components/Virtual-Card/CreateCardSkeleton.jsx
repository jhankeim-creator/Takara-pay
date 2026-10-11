"use client";

export default function CreateCardSkeleton() {
  return (
    <div className="space-y-8">
      <div className="grid grid-cols-1 gap-8 lg:grid-cols-2 lg:gap-10">
        {/* Left Skeleton */}
        <div className="overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl">
          <div className="p-6 sm:p-8 lg:p-10">
            <div className="mx-auto mb-8 h-8 w-56 rounded-lg bg-gray-200 dark:bg-gray-700 animate-pulse" />

            <div className="space-y-6">
              {[...Array(5)].map((_, index) => (
                <div key={index} className="space-y-2">
                  <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />
                  <div className="h-12 w-full rounded-lg bg-gray-200 dark:bg-gray-700 animate-pulse" />
                </div>
              ))}

              <div className="rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/40 p-5 space-y-3">
                <div className="h-4 w-2/3 rounded bg-gray-200 dark:bg-gray-600 animate-pulse" />
                <div className="h-4 w-1/2 rounded bg-gray-200 dark:bg-gray-600 animate-pulse" />
              </div>

              <div className="h-12 w-full rounded-lg bg-gray-200 dark:bg-gray-700 animate-pulse" />
            </div>
          </div>
        </div>

        {/* Right Preview Skeleton */}
        <div className="overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl h-fit">
          <div className="p-6 sm:p-8 lg:p-10">
            <div className="mx-auto mb-8 h-8 w-40 rounded-lg bg-gray-200 dark:bg-gray-700 animate-pulse" />

            <div className="space-y-5">
              {[...Array(4)].map((_, index) => (
                <div
                  key={index}
                  className="flex items-center justify-between border-b border-gray-100 dark:border-gray-700 py-3"
                >
                  <div className="h-4 w-28 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />
                  <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Limit Information Skeleton */}
      <div className="overflow-hidden rounded-2xl bg-white dark:bg-gray-800 shadow-xl">
        <div className="p-6 sm:p-8 lg:p-10">
          <div className="mx-auto mb-8 h-8 w-52 rounded-lg bg-gray-200 dark:bg-gray-700 animate-pulse" />

          <div className="space-y-5">
            {[...Array(3)].map((_, index) => (
              <div
                key={index}
                className="flex items-center justify-between border-b border-gray-100 dark:border-gray-700 py-3"
              >
                <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />
                <div className="h-4 w-28 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
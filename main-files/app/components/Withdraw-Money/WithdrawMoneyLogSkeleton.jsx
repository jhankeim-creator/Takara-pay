"use client";

const WithdrawMoneyLogSkeleton = () => {
  return (
    <div className="mt-6">
      <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm overflow-hidden">
        
        {/* Header skeleton (matches real header layout) */}
        <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-50/80 dark:bg-gray-800/60 px-6 py-5 flex flex-col gap-3 md:flex-row md:items-center md:justify-between md:relative">
          
          {/* Title skeleton */}
          <div className="h-6 w-48 mx-auto md:mx-0 md:absolute md:left-1/2 md:-translate-x-1/2 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />

          {/* Spacer (desktop only) */}
          <div className="hidden md:block" />

          {/* Button skeleton */}
          <div className="w-full md:w-auto">
            <div className="h-10 w-full md:w-28 rounded-xl bg-gray-200 dark:bg-gray-700 animate-pulse" />
          </div>
        </div>

        {/* Table header skeleton */}
        <div className="overflow-x-auto scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600">
          <div className="grid min-w-[1200px] grid-cols-8 gap-4 px-6 py-3 bg-gray-50 dark:bg-gray-900">
            {Array.from({ length: 8 }).map((_, i) => (
              <div
                key={i}
                className="h-4 w-full rounded bg-gray-200 dark:bg-gray-700 animate-pulse"
              />
            ))}
          </div>

          {/* Rows skeleton */}
          <div className="divide-y divide-gray-200 dark:divide-gray-700 min-w-[1200px]">
            {Array.from({ length: 6 }).map((_, i) => (
              <div
                key={i}
                className="grid grid-cols-8 gap-4 px-6 py-4"
              >
                {/* Withdraw By */}
                <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />

                {/* Status (dot + text feel) */}
                <div className="flex items-center gap-2">
                  <div className="h-2 w-2 rounded-full bg-gray-300 dark:bg-gray-600 animate-pulse" />
                  <div className="h-4 w-16 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />
                </div>

                {/* Transaction ID */}
                <div className="h-4 w-28 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />

                {/* Exchange Rate */}
                <div className="h-4 w-20 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />

                {/* Fees */}
                <div className="h-4 w-20 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />

                {/* Will Get */}
                <div className="h-4 w-20 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />

                {/* Current Balance */}
                <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />

                {/* Date */}
                <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-700 animate-pulse" />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default WithdrawMoneyLogSkeleton;
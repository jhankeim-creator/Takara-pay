"use client";

function AddMoneyLogSkeleton() {
  return (
    <div className="mt-6 animate-pulse">
      <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm overflow-hidden">
        
        {/* Header Skeleton (matches real layout) */}
        <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-100 dark:bg-gray-900 px-6 py-5 flex flex-col gap-3 md:flex-row md:items-center md:justify-between md:relative">
          
          {/* Title */}
          <div className="h-6 w-40 bg-gray-300 dark:bg-gray-700 rounded mx-auto md:mx-0 md:absolute md:left-1/2 md:-translate-x-1/2" />

          {/* Spacer (desktop only) */}
          <div className="hidden md:block" />

          {/* Button */}
          <div className="w-full md:w-auto">
            <div className="h-10 w-full md:w-36 bg-gray-300 dark:bg-gray-700 rounded-xl" />
          </div>
        </div>

        {/* Table wrapper (same scroll behavior) */}
        <div className="overflow-x-auto">
          <div className="inline-block min-w-full align-middle">
            
            {/* Table Header Skeleton */}
            <div className="min-w-[1100px] grid grid-cols-7 gap-4 px-6 py-4 bg-gray-50 dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700">
              {Array.from({ length: 7 }).map((_, i) => (
                <div
                  key={i}
                  className="h-4 w-full rounded bg-gray-300 dark:bg-gray-700"
                />
              ))}
            </div>

            {/* Table Rows Skeleton */}
            <div className="min-w-[1100px] divide-y divide-gray-200 dark:divide-gray-700">
              {Array.from({ length: 5 }).map((_, rowIndex) => (
                <div
                  key={rowIndex}
                  className="grid grid-cols-7 gap-4 px-6 py-5 items-center"
                >
                  <div className="h-4 w-40 rounded bg-gray-200 dark:bg-gray-700" />
                  <div className="h-4 w-20 rounded bg-gray-200 dark:bg-gray-700" />
                  <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-700 font-mono" />
                  <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700" />
                  <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700" />
                  <div className="h-4 w-28 rounded bg-gray-200 dark:bg-gray-700" />
                  <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-700" />
                </div>
              ))}
            </div>

            {/* Empty state spacing consistency */}
            <div className="h-4" />
          </div>
        </div>
      </div>
    </div>
  );
}

export default AddMoneyLogSkeleton;
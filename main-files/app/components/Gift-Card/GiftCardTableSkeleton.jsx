const GiftCardTableSkeleton = () => {
  return (
    <div className="rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm overflow-hidden">
      
      {/* Header Skeleton */}
      <div className="rounded-t-2xl bg-gray-100 dark:bg-gray-700 px-6 py-4 flex items-center justify-between">
        <div className="h-4 w-40 bg-gray-200/90 dark:bg-white/20 rounded animate-pulse" />
        <div className="h-8 w-32 bg-gray-200/90 dark:bg-white/20 rounded-lg animate-pulse" />
      </div>

      {/* Desktop Skeleton */}
      <div className="hidden md:block overflow-x-auto">
        
        {/* Table Header */}
        <div className="grid grid-cols-5 gap-6 px-6 py-4 bg-gray-100 dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700">
          {[...Array(5)].map((_, i) => (
            <div
              key={i}
              className="h-3 w-24 bg-gray-300 dark:bg-gray-700 rounded animate-pulse"
            />
          ))}
        </div>

        {/* Table Rows */}
        {[...Array(5)].map((_, i) => (
          <div
            key={i}
            className="grid grid-cols-5 gap-6 px-6 py-4 border-b border-gray-200 dark:border-gray-700 animate-pulse"
          >
            {/* Card Details */}
            <div className="flex items-center gap-3">
              <div className="w-16 h-10 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="space-y-2">
                <div className="h-3 w-28 bg-gray-200 dark:bg-gray-700 rounded" />
                <div className="h-3 w-36 bg-gray-200 dark:bg-gray-700 rounded" />
              </div>
            </div>

            {/* Receiver Info */}
            <div className="space-y-2">
              <div className="h-3 w-40 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="h-3 w-28 bg-gray-200 dark:bg-gray-700 rounded" />
            </div>

            {/* Pricing */}
            <div className="space-y-2">
              <div className="h-3 w-24 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="h-3 w-16 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="h-3 w-28 bg-gray-200 dark:bg-gray-700 rounded" />
            </div>

            {/* Payment */}
            <div className="space-y-2">
              <div className="h-3 w-44 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="h-3 w-32 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="h-3 w-24 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="h-3 w-28 bg-gray-200 dark:bg-gray-700 rounded" />
            </div>

            {/* Status */}
            <div className="flex items-center justify-center">
              <div className="h-6 w-20 bg-gray-200 dark:bg-gray-700 rounded-full" />
            </div>
          </div>
        ))}
      </div>

      {/* Mobile Skeleton */}
      <div className="md:hidden divide-y divide-gray-200 dark:divide-gray-700">
        {[...Array(4)].map((_, i) => (
          <div key={i} className="px-6 py-4 space-y-4 animate-pulse">
            
            {/* Trx ID */}
            <div className="flex justify-between">
              <div className="h-3 w-20 bg-gray-200 dark:bg-gray-700 rounded" />
              <div className="h-3 w-28 bg-gray-200 dark:bg-gray-700 rounded" />
            </div>

            {/* Card */}
            <div className="flex items-center gap-3 pb-3 border-b border-gray-100 dark:border-gray-700">
              <div className="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-lg" />
              <div className="space-y-2">
                <div className="h-3 w-32 bg-gray-200 dark:bg-gray-700 rounded" />
                <div className="h-3 w-20 bg-gray-200 dark:bg-gray-700 rounded" />
              </div>
            </div>

            {/* Grid Info */}
            <div className="grid grid-cols-2 gap-3">
              {[...Array(6)].map((_, j) => (
                <div
                  key={j}
                  className="h-3 w-full bg-gray-200 dark:bg-gray-700 rounded"
                />
              ))}
            </div>

            {/* Status */}
            <div className="h-6 w-24 bg-gray-200 dark:bg-gray-700 rounded-full" />
          </div>
        ))}
      </div>

      {/* Mobile Bottom Button Skeleton */}
      <div className="md:hidden px-6 py-4 border-t border-gray-200 dark:border-gray-700">
        <div className="h-10 w-full bg-gray-200 dark:bg-gray-700 rounded-xl animate-pulse" />
      </div>
    </div>
  );
};

export default GiftCardTableSkeleton;
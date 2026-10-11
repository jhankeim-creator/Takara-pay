const GiftCardListSkeleton = () => {
  return (
    <div className="animate-pulse">
      {/* Header Skeleton */}
      <div className="flex flex-col gap-5 md:flex-row md:items-center md:justify-between mb-8">
        <div className="h-7 w-48 bg-gray-200 dark:bg-gray-700 rounded mx-auto md:mx-0" />

        <div className="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
          <div className="h-10 w-full sm:w-52 bg-gray-200 dark:bg-gray-700 rounded-lg" />
          <div className="h-10 w-full sm:w-24 bg-gray-200 dark:bg-gray-700 rounded-lg" />
        </div>
      </div>

      {/* Grid Skeleton */}
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4 mb-8">
        {[...Array(12)].map((_, i) => (
          <div
            key={i}
            className="rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm overflow-hidden"
          >
            <div className="aspect-4/3 bg-gray-200 dark:bg-gray-700" />
            <div className="p-3">
              <div className="h-4 w-3/4 mx-auto bg-gray-200 dark:bg-gray-700 rounded" />
            </div>
          </div>
        ))}
      </div>

      {/* Pagination Skeleton */}
      <div className="flex justify-center gap-2">
        {[...Array(5)].map((_, i) => (
          <div
            key={i}
            className="w-9 h-9 bg-gray-200 dark:bg-gray-700 rounded-lg"
          />
        ))}
      </div>
    </div>
  );
};

export default GiftCardListSkeleton;

export default function WalletBalanceSkeleton() {
  return (
    <>
      {/* Header Skeleton */}
      <div className="flex flex-col gap-5 md:flex-row md:items-center md:justify-between mb-6 animate-pulse">
        <div>
          <div className="flex items-center gap-3 mb-2">
            <div className="h-4 w-40 bg-gray-200 dark:bg-gray-700 rounded" />
            <div className="w-5 h-5 bg-gray-200 dark:bg-gray-700 rounded-full" />
          </div>
          <div className="h-10 w-56 bg-gray-300 dark:bg-gray-600 rounded" />
        </div>

        <div className="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
          <div className="h-12 w-full sm:w-40 bg-gray-300 dark:bg-gray-600 rounded-lg" />
          <div className="h-12 w-full sm:w-40 bg-gray-300 dark:bg-gray-600 rounded-lg" />
        </div>
      </div>

      {/* Cards Skeleton Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-5 gap-4 animate-pulse">
        {[...Array(5)].map((_, index) => (
          <div
            key={index}
            className="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-100 dark:border-gray-700"
          >
            <div className="flex items-start justify-between mb-3">
              <div className="w-10 h-10 bg-gray-300 dark:bg-gray-700 rounded-lg" />
              <div className="w-7 h-7 bg-gray-200 dark:bg-gray-700 rounded-full" />
            </div>

            <div className="h-3 w-28 bg-gray-200 dark:bg-gray-700 rounded mb-1" />
            <div className="h-5 w-20 bg-gray-300 dark:bg-gray-600 rounded" />
          </div>
        ))}
      </div>
    </>
  );
}
const GiftCardFormSkeleton = () => {
  return (
    <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-lg overflow-hidden border border-neutral-200 dark:border-gray-700 shimmer">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-0 animate-pulse">
        {/* Left Card Preview */}
        <div className="md:col-span-1 lg:col-span-2 bg-gray-100 dark:bg-gray-800 p-6 sm:p-8 md:p-10 flex flex-col items-center border-b md:border-b-0 md:border-r border-neutral-200 dark:border-gray-700">
          <div className="w-full max-w-xs">
            <div className="w-full aspect-square bg-gray-300 dark:bg-gray-700 rounded-xl mb-6 shadow-sm" />
            <div className="h-7 bg-gray-300 dark:bg-gray-700 rounded w-3/4 mb-2" />
            <div className="h-4 bg-gray-200 dark:bg-gray-600 rounded w-1/2 mb-6 opacity-60" />

            <div className="bg-white dark:bg-gray-800 rounded-xl p-4 border border-neutral-200 dark:border-gray-700 shadow-sm">
              <div className="h-3 bg-gray-200 dark:bg-gray-600 rounded w-1/3 mb-2" />
              <div className="h-7 bg-gray-300 dark:bg-gray-700 rounded w-2/3" />
            </div>
          </div>
        </div>

        {/* Right Form Fields */}
        <div className="md:col-span-1 lg:col-span-3 p-6 sm:p-8 md:p-10 space-y-6">
          <div className="h-8 bg-gray-300 dark:bg-gray-700 rounded w-1/3 mb-6" />

          {/* Amount */}
          <div>
            <div className="h-4 bg-gray-200 dark:bg-gray-600 rounded w-20 mb-3" />
            <div className="h-12 bg-gray-300 dark:bg-gray-700 rounded-lg w-full" />
          </div>

          {/* Email */}
          <div>
            <div className="h-4 bg-gray-200 dark:bg-gray-600 rounded w-32 mb-3" />
            <div className="h-12 bg-gray-300 dark:bg-gray-700 rounded-lg w-full" />
          </div>

          {/* Grid fields (Country/Phone, Name/Qty) */}
          {[...Array(2)].map((_, i) => (
            <div key={i} className="grid grid-cols-1 lg:grid-cols-2 gap-4">
              <div>
                <div className="h-4 bg-gray-200 dark:bg-gray-600 rounded w-24 mb-3" />
                <div className="h-12 bg-gray-300 dark:bg-gray-700 rounded-lg w-full" />
              </div>
              <div>
                <div className="h-4 bg-gray-200 dark:bg-gray-600 rounded w-24 mb-3" />
                <div className="h-12 bg-gray-300 dark:bg-gray-700 rounded-lg w-full" />
              </div>
            </div>
          ))}

          {/* Wallet */}
          <div>
            <div className="h-4 bg-gray-200 dark:bg-gray-600 rounded w-28 mb-3" />
            <div className="h-12 bg-gray-300 dark:bg-gray-700 rounded-lg w-full" />
          </div>

          <div className="h-14 bg-blue-600/30 dark:bg-blue-700/30 rounded-lg w-full mt-8" />
        </div>
      </div>
    </div>
  );
};

export default GiftCardFormSkeleton;

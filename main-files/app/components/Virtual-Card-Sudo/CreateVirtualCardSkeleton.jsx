function CreateVirtualCardSkeleton() {
  return (
    <div className="max-w-3xl mx-auto px-4 py-8 sm:px-6 lg:px-8 animate-pulse">
      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
        {/* Header */}
        <div className="px-8 py-6">
          <div className="h-7 w-2/3 bg-gray-200 dark:bg-gray-700 rounded mb-3" />
          <div className="h-4 w-1/2 bg-gray-200 dark:bg-gray-700 rounded" />
        </div>

        {/* Main content */}
        <div className="p-8">
          {/* Status pill */}
          <div className="mb-8">
            <div className="inline-flex items-center px-5 py-2.5 rounded-full bg-gray-200 dark:bg-gray-700">
              <div className="h-4 w-72 bg-gray-300 dark:bg-gray-600 rounded" />
            </div>
          </div>

          {/* Pending text box */}
          <div className="mb-10 rounded-xl border border-gray-200 dark:border-gray-700 p-6 bg-gray-100 dark:bg-gray-700">
            <div className="space-y-3">
              <div className="h-4 w-full bg-gray-300 dark:bg-gray-600 rounded" />
              <div className="h-4 w-11/12 bg-gray-300 dark:bg-gray-600 rounded" />
              <div className="h-4 w-5/6 bg-gray-300 dark:bg-gray-600 rounded" />
            </div>
          </div>

          {/* Button */}
          <div className="flex justify-center">
            <div className="h-12 w-56 bg-gray-300 dark:bg-gray-600 rounded-xl" />
          </div>

          {/* Footer text */}
          <div className="mt-8 flex justify-center">
            <div className="h-3 w-3/4 bg-gray-200 dark:bg-gray-700 rounded" />
          </div>
        </div>
      </div>
    </div>
  );
}

export default CreateVirtualCardSkeleton;

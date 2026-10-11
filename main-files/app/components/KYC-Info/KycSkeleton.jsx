function KycSkeleton() {
  return (
    <div
      className="
        max-w-2xl mx-auto 
        p-6 
        bg-white dark:bg-gray-800 
        rounded-xl 
        shadow-md dark:shadow-gray-900/40 
        border border-gray-200 dark:border-gray-700
        transition-colors duration-200
      "
    >
      <div className="animate-pulse">
        {/* Header */}
        <div className="mb-6 border-b border-gray-200 dark:border-gray-700 pb-4">
          <div className="h-6 w-48 bg-gray-200 dark:bg-gray-700 rounded mb-3" />
          <div className="h-4 w-32 bg-gray-200 dark:bg-gray-700 rounded" />
        </div>

        {/* Form Fields */}
        <div className="space-y-5">
          {[...Array(3)].map((_, i) => (
            <div key={i}>
              <div className="h-4 w-32 bg-gray-200 dark:bg-gray-700 rounded mb-2" />
              <div className="h-11 w-full bg-gray-200 dark:bg-gray-700 rounded-lg" />
            </div>
          ))}

          {/* Submit Button placeholder */}
          <div className="h-11 w-full bg-gray-300 dark:bg-gray-600 rounded-lg" />
        </div>
      </div>
    </div>
  );
}

export default KycSkeleton;

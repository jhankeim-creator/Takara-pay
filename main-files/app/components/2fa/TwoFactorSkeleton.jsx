function TwoFactorSkeleton() {
  return (
    <div
      className="
        bg-white dark:bg-gray-800 
        rounded-2xl 
        shadow-lg dark:shadow-gray-900/40 
        p-8 w-full 
        flex flex-col 
        border border-gray-200 dark:border-gray-700
        transition-colors duration-200
      "
    >
      {/* Title */}
      <div className="h-5 w-56 mx-auto mb-6 rounded bg-gray-200 dark:bg-gray-700 shimmer" />

      {/* Status badge */}
      <div className="flex justify-center mb-6">
        <div className="h-7 w-28 rounded-full bg-gray-200 dark:bg-gray-700 shimmer" />
      </div>

      {/* Secret input area */}
      <div className="mb-8">
        <div className="h-12 w-full rounded-lg bg-gray-200 dark:bg-gray-700 shimmer" />
      </div>

      {/* QR Code placeholder */}
      <div className="flex justify-center mb-8">
        <div className="w-48 h-48 rounded-lg bg-gray-200 dark:bg-gray-700 shimmer" />
      </div>

      {/* Optional alert / message placeholder */}
      <div className="h-12 w-full rounded-lg bg-gray-200 dark:bg-gray-700 shimmer mb-6" />

      {/* Action button placeholder */}
      <div className="mt-auto">
        <div className="h-12 w-full rounded-lg bg-gray-300 dark:bg-gray-600 shimmer" />
      </div>
    </div>
  );
}

export default TwoFactorSkeleton;

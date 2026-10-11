const TransferLogSkeleton = () => {
  const columns = [
    "w-40", // Transfer To
    "w-20", // Status
    "w-28", // Transaction ID
    "w-24", // Fees
    "w-28", // Recipient
    "w-28", // Balance
    "w-32", // Date
  ];

  return (
    <div className="animate-pulse">
      {/* Header Skeleton */}
      <div className="grid min-w-[1350px] grid-cols-7 gap-x-8 px-6 py-4 bg-gray-50 dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700">
        {columns.map((w, i) => (
          <div
            key={i}
            className={`h-4 rounded bg-gray-200 dark:bg-gray-700 ${w}`}
          />
        ))}
      </div>

      {/* Rows Skeleton */}
      <div className="divide-y divide-gray-200 dark:divide-gray-700 min-w-[1350px]">
        {Array.from({ length: 6 }).map((_, rowIndex) => (
          <div
            key={rowIndex}
            className="grid grid-cols-7 gap-x-8 px-6 py-5 items-center"
          >
            {/* Transfer To */}
            <div className="h-4 w-40 rounded bg-gray-200 dark:bg-gray-700" />

            {/* Status (dot + text) */}
            <div className="flex items-center gap-2">
              <div className="h-2.5 w-2.5 rounded-full bg-gray-300 dark:bg-gray-600" />
              <div className="h-4 w-16 rounded bg-gray-200 dark:bg-gray-700" />
            </div>

            {/* Transaction ID */}
            <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-700" />

            {/* Fees */}
            <div className="h-4 w-20 rounded bg-gray-200 dark:bg-gray-700" />

            {/* Recipient Received */}
            <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700" />

            {/* Current Balance */}
            <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700" />

            {/* Date (right aligned) */}
            <div className="flex justify-end">
              <div className="h-4 w-32 rounded bg-gray-200 dark:bg-gray-700" />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default TransferLogSkeleton;
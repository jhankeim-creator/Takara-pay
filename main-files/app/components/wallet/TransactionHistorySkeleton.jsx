function TransactionHistorySkeleton({ rows = 6 }) {
  return (
    <div className="rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 animate-pulse">
      {/* Header Skeleton */}
      <div className="p-4 border-b border-gray-200 dark:border-gray-700">
        <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
          {/* "Latest Transactions" title */}
          <div className="h-6 w-48 bg-gray-200 dark:bg-gray-700 rounded" />

          {/* Search + Filter */}
          <div className="flex flex-col gap-2 sm:flex-row md:gap-2">
            <div className="h-10 w-full sm:w-48 md:w-60 bg-gray-200 dark:bg-gray-700 rounded-lg" />
            <div className="h-10 w-28 bg-gray-200 dark:bg-gray-700 rounded-lg" />
          </div>
        </div>
      </div>

      {/* Table Skeleton */}
      <div className="overflow-x-auto">
        <div className="inline-block min-w-full align-middle">
          <div className="overflow-hidden">
            <table className="min-w-full divide-y divide-gray-100 dark:divide-gray-700">
              {/* Table Head */}
              <thead className="bg-gray-50 dark:bg-gray-900/40">
                <tr>
                  {Array.from({ length: 8 }).map((_, index) => (
                    <th key={index} className="px-6 py-3">
                      <div className="h-4 w-24 bg-gray-200 dark:bg-gray-700 rounded" />
                    </th>
                  ))}
                </tr>
              </thead>

              {/* Table Body */}
              <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-100 dark:divide-gray-700">
                {Array.from({ length: rows }).map((_, index) => (
                  <tr key={index}>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-gray-200 dark:bg-gray-700 rounded-full" />
                        <div className="h-4 w-28 bg-gray-200 dark:bg-gray-700 rounded" />
                      </div>
                    </td>

                    <td className="px-6 py-4 text-right">
                      <div className="h-5 w-20 bg-gray-200 dark:bg-gray-700 rounded ml-auto" />
                    </td>

                    <td className="px-6 py-4 text-right">
                      <div className="h-4 w-20 bg-gray-200 dark:bg-gray-700 rounded ml-auto" />
                    </td>

                    <td className="px-6 py-4">
                      <div className="h-4 w-24 bg-gray-200 dark:bg-gray-700 rounded" />
                    </td>

                    <td className="px-6 py-4">
                      <div className="h-4 w-40 bg-gray-200 dark:bg-gray-700 rounded" />
                    </td>

                    <td className="px-6 py-4">
                      <div className="h-6 w-24 bg-gray-200 dark:bg-gray-700 rounded-full" />
                    </td>

                    <td className="px-6 py-4">
                      <div className="h-6 w-20 bg-gray-200 dark:bg-gray-700 rounded-full" />
                    </td>

                    <td className="px-6 py-4">
                      <div className="h-4 w-32 bg-gray-200 dark:bg-gray-700 rounded" />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

export default TransactionHistorySkeleton;

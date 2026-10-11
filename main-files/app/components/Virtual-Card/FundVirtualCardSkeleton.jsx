function FundVirtualCardSkeleton() {
  const shimmer =
    "relative overflow-hidden bg-gray-200 dark:bg-gray-700 rounded " +
    "before:absolute before:inset-0 " +
    "before:-translate-x-full " +
    "before:bg-gradient-to-r before:from-transparent before:via-white/60 dark:before:via-white/10 before:to-transparent " +
    "before:animate-[shimmer_1.5s_infinite]";

  return (
    <>
      <style jsx>{`
        @keyframes shimmer {
          100% {
            transform: translateX(100%);
          }
        }
      `}</style>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-10">
        {/* Form Skeleton */}
        <div className="rounded-2xl bg-white dark:bg-gray-800 shadow-xl p-6 sm:p-8 lg:p-10 space-y-6">
          <div className={`${shimmer} h-6 w-48 mx-auto`} />

          <div className="space-y-2">
            <div className={`${shimmer} h-4 w-32`} />
            <div className={`${shimmer} h-12 w-full rounded-lg`} />
          </div>

          <div className="space-y-2">
            <div className={`${shimmer} h-4 w-28`} />
            <div className={`${shimmer} h-12 w-full rounded-lg`} />
          </div>

          <div className="rounded-lg bg-gray-50 dark:bg-gray-700/50 p-5 space-y-3">
            <div className={`${shimmer} h-4 w-3/4`} />
            <div className={`${shimmer} h-4 w-2/3`} />
          </div>

          <div className={`${shimmer} h-12 w-full rounded-lg`} />
        </div>

        {/* Preview Skeleton */}
        <div className="rounded-2xl bg-white dark:bg-gray-800 shadow-xl p-6 sm:p-8 lg:p-10 space-y-6">
          <div className={`${shimmer} h-6 w-32 mx-auto`} />

          {[1, 2, 3, 4].map((i) => (
            <div key={i} className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-700 last:border-0">
              <div className={`${shimmer} h-4 w-32`} />
              <div className={`${shimmer} h-4 w-24`} />
            </div>
          ))}
        </div>
      </div>

      {/* Limit Information Skeleton */}
      <div className="mt-10 rounded-2xl bg-white dark:bg-gray-800 shadow-xl p-6 sm:p-8 lg:p-10 space-y-6">
        <div className={`${shimmer} h-6 w-40 mx-auto`} />

        {[1, 2, 3].map((i) => (
          <div key={i} className="flex justify-between items-center py-2 border-b border-gray-100 dark:border-gray-700 last:border-0">
            <div className={`${shimmer} h-4 w-40`} />
            <div className={`${shimmer} h-4 w-32`} />
          </div>
        ))}
      </div>
    </>
  );
}

export default FundVirtualCardSkeleton;
"use client";

function AddMoneyFormSkeleton() {
  return (
    <div className="w-full rounded-2xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm animate-pulse overflow-hidden">

      {/* Header (matches real centered title bar) */}
      <div className="rounded-t-2xl border-b border-gray-200 dark:border-gray-700 bg-gray-100 dark:bg-gray-900 px-6 py-5">
        <div className="mx-auto h-6 w-44 rounded bg-gray-300 dark:bg-gray-700" />
      </div>

      {/* Body */}
      <div className="flex flex-col space-y-7 p-6">

        {/* Payment Gateway */}
        <div>
          <div className="mb-2 h-4 w-44 rounded bg-gray-200 dark:bg-gray-700" />
          <div className="relative h-11 w-full rounded-xl bg-gray-200 dark:bg-gray-700" />
        </div>

        {/* Amount + Currency */}
        <div>
          <div className="mb-2 h-4 w-36 rounded bg-gray-200 dark:bg-gray-700" />
          
          <div className="flex h-11 w-full rounded-xl bg-gray-200 dark:bg-gray-700 overflow-hidden">
            {/* input area */}
            <div className="flex-1" />

            {/* currency dropdown */}
            <div className="w-24 border-l border-gray-300 dark:border-gray-600" />
          </div>
        </div>

        {/* Info Box */}
        <div className="space-y-3 rounded-xl bg-gray-100 dark:bg-gray-800/60 px-4 py-4">
          
          {/* Balance */}
          <div className="flex justify-between items-center">
            <div className="h-4 w-36 rounded bg-gray-200 dark:bg-gray-700" />
            <div className="h-4 w-28 rounded bg-gray-200 dark:bg-gray-700" />
          </div>

          {/* Charge */}
          <div className="flex justify-between items-center">
            <div className="h-4 w-24 rounded bg-gray-200 dark:bg-gray-700" />
            <div className="h-4 w-40 rounded bg-gray-200 dark:bg-gray-700" />
          </div>
        </div>

        {/* Divider */}
        <div className="border-t border-dashed border-gray-200 dark:border-gray-700" />

        {/* Submit Button (gradient match) */}
        <div className="h-14 w-full rounded-xl bg-gradient-to-r from-gray-300 to-gray-200 dark:from-gray-700 dark:to-gray-600" />
      </div>
    </div>
  );
}

export default AddMoneyFormSkeleton;
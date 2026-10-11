"use client";

export default function ChangePasswordSkeleton() {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl shadow-md p-6 max-w-4xl mx-auto">
      {/* Title */}
      <div className="h-7 w-52 bg-gray-200 dark:bg-gray-700 rounded mx-auto mb-10 shimmer" />

      <div className="space-y-6">
        {/* Input skeletons */}
        {[1, 2, 3].map((_, i) => (
          <div key={i}>
            <div className="h-4 w-40 bg-gray-200 dark:bg-gray-700 rounded mb-2 shimmer" />
            <div className="h-12 w-full bg-gray-200 dark:bg-gray-700 rounded-lg shimmer" />
          </div>
        ))}

        {/* Button */}
        <div className="flex justify-end mt-10">
          <div className="h-12 w-full bg-gray-300 dark:bg-gray-600 rounded-lg shimmer" />
        </div>
      </div>
    </div>
  );
}

export default function MyProfileSkeleton() {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl shadow-md p-6 max-w-4xl mx-auto animate-pulse">
      {/* Header */}
      <div className="text-center mb-8">
        <div className="h-6 w-40 bg-gray-200 dark:bg-gray-700 rounded mx-auto mb-4" />
        <div className="h-8 w-64 bg-gray-200 dark:bg-gray-700 rounded-full mx-auto" />
      </div>

      {/* Profile Image */}
      <div className="flex justify-center mb-8">
        <div className="w-24 h-24 rounded-full bg-gray-200 dark:bg-gray-700" />
      </div>

      {/* Form Skeleton */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        {Array.from({ length: 8 }).map((_, i) => (
          <div key={i}>
            <div className="h-4 w-24 bg-gray-200 dark:bg-gray-700 rounded mb-2" />
            <div className="h-11 w-full bg-gray-200 dark:bg-gray-700 rounded-lg" />
          </div>
        ))}
      </div>

      {/* Buttons */}
      <div className="flex gap-4 justify-center mt-10">
        <div className="h-12 w-40 bg-gray-200 dark:bg-gray-700 rounded-lg" />
        <div className="h-12 w-48 bg-gray-200 dark:bg-gray-700 rounded-lg" />
      </div>
    </div>
  );
}
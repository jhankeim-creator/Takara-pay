"use client";

export default function AddNewTicket() {
  return (
    <div className="bg-white dark:bg-gray-900 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
      {/* Dark Header Style */}
      <div className="bg-[#0f172a] dark:bg-[#020617] p-5">
        <h2 className="text-white font-semibold text-lg">Add New Ticket</h2>
      </div>

      <div className="p-8">
        <form className="space-y-6 w-full">
          {/* Subject Field */}
          <div className="w-full">
            <label className="block text-[#475569] dark:text-gray-400 text-sm font-semibold mb-2">
              Subject <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              placeholder="Enter Subject..."
              className="w-full p-4 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-lg focus:outline-none focus:ring-1 focus:ring-emerald-500/20 focus:border-emerald-400 transition-all placeholder:text-gray-400 dark:placeholder:text-gray-500 text-gray-700 dark:text-gray-200"
              required
            />
          </div>

          {/* Message Field */}
          <div className="w-full">
            <label className="block text-[#475569] dark:text-gray-400 text-sm font-semibold mb-2">
              Message <span className="text-red-500">*</span>
            </label>
            <textarea
              rows={6}
              placeholder="Write Here..."
              className="w-full p-4 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-lg focus:outline-none focus:ring-1 focus:ring-emerald-500/20 focus:border-emerald-400 transition-all placeholder:text-gray-400 dark:placeholder:text-gray-500 resize-none text-gray-700 dark:text-gray-200"
              required
            ></textarea>
          </div>

          {/* Attachments Field - Restored to Original Style */}
          <div className="w-full">
            <label className="block text-[#475569] dark:text-gray-400 text-sm font-semibold mb-2">
              Attachments
            </label>
            <div className="w-full p-3 bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-lg flex items-center">
              <input
                type="file"
                className="block w-full text-sm text-gray-500 dark:text-gray-400
                  file:mr-4 file:py-2 file:px-4
                  file:rounded-md file:border-0
                  file:text-sm file:font-semibold
                  file:bg-gray-200 dark:file:bg-gray-700 file:text-gray-700 dark:file:text-gray-300
                  hover:file:bg-gray-300 dark:hover:file:bg-gray-600 cursor-pointer transition-all"
              />
            </div>
          </div>

          {/* Submit Button */}
          <div className="pt-4">
            <button
              type="submit"
              className="cursor-pointer w-full md:w-auto px-12 btn-primary text-white font-bold py-4 rounded-xl transition-all shadow-lg shadow-indigo-100 dark:shadow-indigo-950/50"
            >
              Add New
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
"use client";

import { MessageSquare, Plus } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";

const tickets = [
  {
    id: "#ST28483261",
    name: "Test User2",
    email: "user2@appdevs.net",
    subject: "Ducimus fugiat qua",
    status: "Pending",
    lastReplied: "2026-03-30 11:17 AM",
  },
  {
    id: "#ST11291836",
    name: "Test User2",
    email: "user2@appdevs.net",
    subject: "Aliquid ut cillum a",
    status: "Pending",
    lastReplied: "2026-03-25 19:06 PM",
  },
];

export default function SupportTickets() {
  const router = useRouter();

  const handleDetails = (ticket) => {
    const id = ticket.id.replace("#", "");
    router.push(`/dashboard/support/TicketDetails?id=${id}`);
  };

  return (
    <div className="bg-white dark:bg-gray-900 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
      {/* Dark Header Component Style */}
      <div className="bg-[#0f172a] dark:bg-[#020617] p-4 flex justify-between items-center">
        <h2 className="text-white font-semibold text-lg px-2">
          Support Tickets
        </h2>
        <Link href="/dashboard/support/AddTickets">
          <button className="cursor-pointer flex items-center gap-2 bg-white/10 hover:bg-white/20 text-white text-sm px-4 py-2 rounded-lg border border-white/20 transition-all">
            <Plus size={16} />
            Add New
          </button>
        </Link>
      </div>

      {/* Table Section */}
      <div className="overflow-x-auto">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="border-b border-gray-100 dark:border-gray-700">
              <th className="py-5 px-6 text-[#475569] dark:text-gray-400 font-semibold text-[13px]">
                Ticket ID
              </th>
              <th className="py-5 px-6 text-[#475569] dark:text-gray-400 font-semibold text-[13px]">
                Full Name
              </th>
              <th className="py-5 px-6 text-[#475569] dark:text-gray-400 font-semibold text-[13px]">
                Email
              </th>
              <th className="py-5 px-6 text-[#475569] dark:text-gray-400 font-semibold text-[13px]">
                Subject
              </th>
              <th className="py-5 px-6 text-[#475569] dark:text-gray-400 font-semibold text-[13px]">
                Status
              </th>
              <th className="py-5 px-6 text-[#475569] dark:text-gray-400 font-semibold text-[13px]">
                Last Replied
              </th>
              <th className="py-5 px-6 text-[#475569] dark:text-gray-400 font-semibold text-[13px] text-right">
                Details
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-50 dark:divide-gray-700/50">
            {tickets.map((ticket, index) => (
              <tr key={index} className="hover:bg-gray-50/50 dark:hover:bg-gray-800/50 transition-colors">
                <td className="py-5 px-6 text-[#64748b] dark:text-gray-400 text-sm">
                  {ticket.id}
                </td>
                <td className="py-5 px-6 text-[#64748b] dark:text-gray-400 text-sm">
                  {ticket.name}
                </td>
                <td className="py-5 px-6 text-[#64748b] dark:text-gray-400 text-sm lowercase">
                  {ticket.email}
                </td>
                <td className="py-5 px-6 text-[#64748b] dark:text-gray-400 text-sm">
                  {ticket.subject}
                </td>
                <td className="py-5 px-6">
                  <div className="flex items-center gap-2 text-[#10b981] text-sm font-medium">
                    <span className="w-2 h-2 rounded-full bg-[#10b981]"></span>
                    Success
                  </div>
                </td>
                <td className="py-5 px-6 text-[#64748b] dark:text-gray-400 text-sm">
                  {ticket.lastReplied}
                </td>
                <td className="py-5 px-6 text-right">
                  <button
                    onClick={() => handleDetails(ticket)}
                    className="cursor-pointer p-2 text-[#6366f1] hover:bg-indigo-50 dark:hover:bg-indigo-950/50 rounded-lg transition-all inline-flex items-center justify-center"
                    title="View Details"
                  >
                    <MessageSquare size={18} />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
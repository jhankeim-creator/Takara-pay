"use client";

import { ArrowLeft, Send, User } from "lucide-react";
import { useRouter, useSearchParams } from "next/navigation";
import { Suspense } from "react";

const tickets = [
  {
    id: "ST28483261",
    name: "Test User2",
    email: "user2@appdevs.net",
    subject: "Ducimus fugiat qua",
    status: "Pending",
    lastReplied: "2026-03-30 11:17 AM",
    messages: [
      {
        sender: "Test User2",
        time: "2026-03-30 11:17 AM",
        text: "Hi, I'm having an issue with my account. Can someone help me?",
        isUser: true,
      },
      {
        sender: "Support Agent",
        time: "2026-03-30 11:45 AM",
        text: "Hello! Thank you for reaching out. We're looking into your issue and will get back to you shortly.",
        isUser: false,
      },
    ],
  },
  {
    id: "ST11291836",
    name: "Test User2",
    email: "user2@appdevs.net",
    subject: "Aliquid ut cillum a",
    status: "Pending",
    lastReplied: "2026-03-25 19:06 PM",
    messages: [
      {
        sender: "Test User2",
        time: "2026-03-25 19:06 PM",
        text: "I need assistance regarding my recent transaction.",
        isUser: true,
      },
    ],
  },
];

function TicketDetailsContent() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const id = searchParams.get("id");

  const ticket = tickets.find((t) => t.id === id);

  if (!ticket) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-center">
        <div className="text-5xl mb-4">🎫</div>
        <h3 className="text-xl font-bold text-gray-900 dark:text-white">
          Ticket not found
        </h3>
        <p className="text-gray-500 dark:text-gray-400 mb-6">
          This ticket doesn&apos;t exist or was moved.
        </p>
        <button
          onClick={() => window.history.back()}
          className="cursor-pointer text-sm font-semibold text-blue-600"
        >
          ← Go back
        </button>
      </div>
    );
  }

  return (
    <div className="px-4 lg:px-0">
      {/* Top Breadcrumb */}
      <button
        onClick={() => router.back()}
        className="cursor-pointer flex items-center gap-2 text-gray-500 dark:text-gray-400 hover:text-[#6366f1] dark:hover:text-[#6366f1] mb-6 font-medium transition-colors group"
      >
        <ArrowLeft
          size={18}
          className="group-hover:-translate-x-1 transition-transform"
        />
        Back to Tickets
      </button>

      {/* Main Container: Split Layout */}
      <div className="flex flex-col lg:flex-row bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden min-h-[650px]">
        {/* LEFT COLUMN: Chat Interface */}
        <div className="flex-1 flex flex-col border-r border-gray-100 dark:border-gray-700 bg-white dark:bg-gray-900">
          {/* Chat Header - Dark Navy Style */}
          <div className="p-5 bg-[#0f172a] dark:bg-[#020617] flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center text-white border border-white/20">
              <User size={20} />
            </div>
            <div>
              <h3 className="font-bold text-white leading-tight">
                {ticket.name}
              </h3>
              <p className="text-[10px] text-indigo-300 font-bold uppercase tracking-widest">
                Ticket ID : <span className="text-white">#{ticket.id}</span>
              </p>
            </div>
          </div>

          {/* Messages Area */}
          <div className="flex-1 p-6 overflow-y-auto space-y-6 bg-gray-50/30 dark:bg-gray-800/30">
            {ticket.messages.map((msg, i) => (
              <div
                key={i}
                className={`flex items-start gap-3 ${msg.isUser ? "justify-end" : "justify-start"}`}
              >
                {!msg.isUser && (
                  <div className="w-8 h-8 rounded-full bg-indigo-100 dark:bg-indigo-900/50 flex items-center justify-center text-[#6366f1] shrink-0">
                    <User size={14} />
                  </div>
                )}

                <div className="flex flex-col max-w-[75%]">
                  <div
                    className={`p-4 rounded-2xl text-sm shadow-sm ${
                      msg.isUser
                        ? "bg-[#6366f1] text-white rounded-tr-none"
                        : "bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-200 border border-gray-100 dark:border-gray-700 rounded-tl-none"
                    }`}
                  >
                    <p className="leading-relaxed">{msg.text}</p>
                  </div>
                  <span
                    className={`text-[10px] mt-1 text-gray-400 dark:text-gray-500 ${msg.isUser ? "text-right" : "text-left"}`}
                  >
                    {msg.time}
                  </span>
                </div>

                {msg.isUser && (
                  <div className="w-10 h-10 rounded-full border-2 border-white dark:border-gray-700 shadow-sm flex items-center justify-center overflow-hidden shrink-0">
                    <img
                      src={`https://api.dicebear.com/7.x/avataaars/svg?seed=${ticket.name}`}
                      alt="avatar"
                    />
                  </div>
                )}
              </div>
            ))}
          </div>

          {/* Bottom Input Area */}
          <div className="p-4 bg-white dark:bg-gray-900 border-t border-gray-100 dark:border-gray-700 flex items-center gap-3">
            <div className="flex-1">
              <textarea
                placeholder="Write something...."
                className="w-full bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-xl px-5 py-3 text-sm text-gray-700 dark:text-gray-200 placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-1 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all resize-none h-14"
              />
            </div>
            <button className="bg-[#6366f1] p-3 rounded-xl text-white hover:bg-[#4f46e5] shadow-lg shadow-indigo-100 dark:shadow-indigo-950/50 transition-all active:scale-95">
              <Send size={20} />
            </button>
          </div>
        </div>

        {/* RIGHT COLUMN: Support Details Sidebar */}
        <div className="w-full lg:w-[380px] p-8 flex flex-col bg-[#f8fafc] dark:bg-gray-800/50">
          {/* Status Badge */}
          <div className="flex items-center gap-2 mb-8 bg-white dark:bg-gray-800 w-fit px-4 py-1.5 rounded-full border border-gray-100 dark:border-gray-700 shadow-sm">
            <span className="w-2.5 h-2.5 rounded-full bg-amber-500"></span>
            <span className="text-[#475569] dark:text-gray-400 text-xs font-bold uppercase tracking-wider">
              {ticket.status}
            </span>
          </div>

          <h2 className="text-lg font-bold text-[#0f172a] dark:text-gray-100 mb-8 border-b border-gray-200 dark:border-gray-700 pb-2">
            Support Details
          </h2>

          <div className="space-y-6">
            {/* Subject Row */}
            <div className="flex flex-col gap-1">
              <span className="text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider">
                Subject
              </span>
              <span className="text-gray-700 dark:text-gray-300 font-medium">
                {ticket.subject}
              </span>
            </div>

            {/* Description Row */}
            <div className="flex flex-col gap-1">
              <span className="text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider">
                Description
              </span>
              <span className="text-gray-700 dark:text-gray-300 leading-relaxed">
                Ut qui nobis repelle ducimus fugiat qua.
              </span>
            </div>

            {/* Attachments Row */}
            <div className="flex flex-col gap-2">
              <span className="text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider">
                Attachments (1)
              </span>
              <div className="flex items-center gap-2 text-[#6366f1] bg-indigo-50 dark:bg-indigo-950/50 w-fit px-3 py-1 rounded-md cursor-pointer hover:bg-indigo-100 dark:hover:bg-indigo-950 transition-colors">
                <span className="text-xs font-bold">image_file.png</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default function TicketDetails() {
  return (
    <Suspense
      fallback={
        <div className="flex justify-center items-center py-40">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#6366f1]"></div>
        </div>
      }
    >
      <TicketDetailsContent />
    </Suspense>
  );
}

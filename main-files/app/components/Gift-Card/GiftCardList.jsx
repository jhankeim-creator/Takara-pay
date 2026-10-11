/* eslint-disable @next/next/no-img-element */
"use client";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import { getAllGiftCards, searchGiftCardsByCountry } from "../../utils/api";
import GiftCardListSkeleton from "./GiftCardListSkeleton";

const GiftCardList = () => {
  const router = useRouter();
  const searchParams = useSearchParams();

  // ============================================================
  // STATE MANAGEMENT
  // ============================================================

  // Read initial country from URL (persists on reload)
  const initialCountry = searchParams.get("country") || "all";

  const [selectedCountry, setSelectedCountry] = useState(initialCountry);
  const [pendingCountry, setPendingCountry] = useState(initialCountry);
  const [isOpen, setIsOpen] = useState(false);

  const [giftCards, setGiftCards] = useState([]);
  const [countries, setCountries] = useState([]);

  const [currentPage, setCurrentPage] = useState(1);
  const [lastPage, setLastPage] = useState(1);
  const [paginationLinks, setPaginationLinks] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // ============================================================
  // DATA FETCHING
  // ============================================================

  const fetchGiftCards = async (page = 1, countryIso = selectedCountry) => {
    setLoading(true);
    setError(null);

    try {
      let result;
      if (countryIso === "all" || !countryIso) {
        result = await getAllGiftCards(page);
      } else {
        result = await searchGiftCardsByCountry(countryIso, page);
      }

      if (result?.message?.error) {
        setError(result.message.error[0] || "Failed to load gift cards");
        return;
      }

      const productsData = result?.data?.products || {};
      const products = productsData.data || [];
      const apiCountries = result?.data?.countries || [];

      setGiftCards(products);
      setCurrentPage(productsData.current_page || 1);
      setLastPage(productsData.last_page || 1);
      setPaginationLinks(productsData.links || []);

      // Load countries only once
      if (countries.length === 0) {
        const formattedCountries = [
          { id: 0, name: "All Countries", iso2: "all" },
          ...apiCountries.map((c) => ({
            id: c.id,
            name: c.name,
            iso2: c.iso2.toLowerCase(),
          })),
        ];
        setCountries(formattedCountries);
      }
    } catch (err) {
      setError(err.message || "Failed to load gift cards");
    } finally {
      setLoading(false);
    }
  };

  // ============================================================
  // EFFECTS
  // ============================================================

  // Load on mount + when page changes in URL
  useEffect(() => {
    const countryFromUrl = searchParams.get("country")?.toLowerCase() || "all";
    const pageFromUrl = Number(searchParams.get("page")) || 1;

    setSelectedCountry(countryFromUrl);
    setPendingCountry(countryFromUrl);
    setCurrentPage(pageFromUrl);

    fetchGiftCards(pageFromUrl, countryFromUrl);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams]);

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  const handleSearch = () => {
    const newParams = new URLSearchParams(searchParams);
    if (pendingCountry === "all") {
      newParams.delete("country");
    } else {
      newParams.set("country", pendingCountry.toUpperCase());
    }
    newParams.set("page", "1"); // reset to page 1 on new search

    router.push(`?${newParams.toString()}`);
    setIsOpen(false);
  };

  const handlePageChange = (page) => {
    if (page >= 1 && page <= lastPage) {
      const newParams = new URLSearchParams(searchParams);
      newParams.set("page", page.toString());
      router.push(`?${newParams.toString()}`);
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  };

  const handleCardClick = (card) => {
    router.push(`/dashboard/gift-card/${card.productId}`);
  };

  // ============================================================
  // DERIVED VALUES
  // ============================================================

  const selectedLabel =
    countries.find((c) => c.iso2 === selectedCountry)?.name || "All Countries";

  // ============================================================
  // LOADING STATE
  // ============================================================

  if (loading) {
    return <GiftCardListSkeleton />;
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  if (error) {
    return (
      <div className="text-center text-red-600 dark:text-red-400 py-10">
        {error}
        <br />
        <button
          onClick={() => fetchGiftCards(currentPage, selectedCountry)}
          className="mt-4 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 dark:bg-emerald-700 dark:hover:bg-emerald-600 text-white rounded-lg cursor-pointer"
        >
          Try Again
        </button>
      </div>
    );
  }

  // ============================================================
  // MAIN RENDER
  // ============================================================

  return (
    <>
      {/* ============================================================ */}
      {/* HEADER SECTION - Filter Dropdown + Search Button */}
      {/* ============================================================ */}

      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-gray-100">
          Gift Cards
        </h1>

        <div className="flex items-center gap-3">
          {/* Country Filter Dropdown */}
          <div className="relative">
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="flex items-center gap-2 px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 text-sm font-medium hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-emerald-400 min-w-[200px] cursor-pointer"
            >
              <svg
                className="w-5 h-5 text-gray-400 dark:text-gray-500"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                />
              </svg>
              <span className="flex-1 text-left">
                {countries.find((c) => c.iso2 === pendingCountry)?.name ||
                  "All Countries"}
              </span>

              <svg
                className={`w-4 h-4 text-gray-500 dark:text-gray-400 transition-transform ${
                  isOpen ? "rotate-180" : ""
                }`}
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </button>

            {/* Dropdown Menu */}
            {isOpen && (
              <>
                <div
                  className="fixed inset-0 z-10 cursor-pointer"
                  onClick={() => setIsOpen(false)}
                />
                <div className="absolute z-20 mt-2 w-full rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-lg max-h-80 overflow-y-auto">
                  {countries.map((country) => (
                    <button
                      key={country.iso2}
                      onClick={() => {
                        setPendingCountry(country.iso2);
                        setIsOpen(false);
                      }}
                      className={`w-full px-4 py-2.5 text-left text-sm hover:bg-gray-50 dark:hover:bg-gray-700 first:rounded-t-lg last:rounded-b-lg cursor-pointer ${
                        pendingCountry === country.iso2
                          ? "bg-emerald-50 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-300 font-medium"
                          : "text-gray-700 dark:text-gray-300"
                      }`}
                    >
                      {country.name}
                    </button>
                  ))}
                </div>
              </>
            )}
          </div>

          {/* Search Button */}
          <button
            onClick={handleSearch}
            className="px-5 py-2.5 bg-emerald-600 hover:bg-emerald-700 dark:bg-emerald-700 dark:hover:bg-emerald-600 text-white rounded-lg font-medium text-sm transition-colors cursor-pointer"
          >
            Search
          </button>
        </div>
      </div>

      {/* ============================================================ */}
      {/* GIFT CARDS GRID SECTION */}
      {/* ============================================================ */}

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4 mb-8">
        {giftCards.length === 0 ? (
          <div className="col-span-full text-center py-12 text-gray-600 dark:text-gray-400">
            No gift cards found
          </div>
        ) : (
          giftCards.map((card) => (
            <div
              key={card.productId}
              onClick={() => handleCardClick(card)}
              className="group cursor-pointer rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 shadow-sm hover:shadow-md transition-all duration-200 hover:border-emerald-400 dark:hover:border-emerald-500"
            >
              <div className="aspect-4/3 overflow-hidden bg-gray-100 dark:bg-gray-900">
                <img
                  src={card.logoUrls?.[0] || "/images/placeholder-giftcard.png"}
                  alt={card.productName}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-200"
                />
              </div>
              <div className="p-3">
                <h3 className="text-sm font-medium text-gray-900 dark:text-gray-100 text-center truncate">
                  {card.productName}
                </h3>
              </div>
            </div>
          ))
        )}
      </div>

      {/* ============================================================ */}
      {/* PAGINATION SECTION */}
      {/* ============================================================ */}

      {lastPage > 1 && (
        <div className="flex items-center justify-center gap-2 flex-wrap">
          <button
            onClick={() => handlePageChange(currentPage - 1)}
            disabled={currentPage === 1}
            className="px-3 py-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 text-sm font-medium hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
          >
            Previous
          </button>

          {paginationLinks
            .filter(
              (link) =>
                link.label !== "&laquo; Previous" &&
                link.label !== "Next &raquo;",
            )
            .map((link, index) => {
              if (link.url === null) {
                return (
                  <span
                    key={index}
                    className="px-4 py-2 text-sm text-gray-500 dark:text-gray-400"
                  >
                    ...
                  </span>
                );
              }
              return (
                <button
                  key={index}
                  onClick={() => handlePageChange(Number(link.label))}
                  className={`w-9 h-9 rounded-lg text-sm font-medium cursor-pointer ${
                    currentPage === Number(link.label)
                      ? "bg-emerald-500 text-white dark:bg-emerald-600 dark:text-white"
                      : "border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
                  }`}
                >
                  {link.label}
                </button>
              );
            })}

          <button
            onClick={() => handlePageChange(currentPage + 1)}
            disabled={currentPage === lastPage}
            className="px-3 py-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 text-sm font-medium hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
          >
            Next
          </button>
        </div>
      )}
    </>
  );
};

export default GiftCardList;

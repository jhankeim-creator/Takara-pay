"use client";

import { useParams } from "next/navigation";
import { Suspense, useEffect, useState } from "react";
import toast from "react-hot-toast";
import GiftCardForm from "../../../../components/Gift-Card/GiftCardForm";
import GiftCardFormSkeleton from "../../../../components/Gift-Card/GiftCardFormSkeleton";
import { getGiftCardDetails } from "../../../../utils/api";

export default function GiftCardDetailPage() {
  const { id } = useParams();
  const productId = Number(id);

  const [card, setCard] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchCardDetails = async () => {
      if (!productId || isNaN(productId)) {
        setError("Invalid Gift Card ID");
        setLoading(false);

        return;
      }

      setLoading(true);
      setError(null);

      try {
        const response = await getGiftCardDetails(productId);

        // Handle API-level error messages
        if (response?.message?.error) {
          const errorMsg =
            response.message.error[0] || "Failed to load gift card details";
          setError(errorMsg);
          toast.error(errorMsg);
          return;
        }

        const product = response?.data?.product;
        if (!product) {
          setError("Gift Card not Found");

          return;
        }

        // Main data mapping
        const mappedCard = {
          id: product.productId,
          name: product.productName?.trim() || "Unnamed Gift Card",
          slug:
            product.productName
              ?.toLowerCase()
              .replace(/\s+/g, "-")
              .replace(/[^a-z0-9-]/g, "") || "",

          image: product.logoUrls?.[0] || "/images/placeholder-giftcard.png",

          brand: {
            name: product.brand?.brandName || "Unknown Brand",
            logo: product.brand?.logoUrl || null,
            id: product.brand?.brandId,
          },

          category: product.category?.name || null,

          country: {
            name: product.country?.name || "",
            iso: product.country?.isoName || "",
            flag: product.country?.flagUrl || null,
          },

          denominationType: product.denominationType || "RANGE",
          currency: product.recipientCurrencyCode || "",
          minAmount: Number(product.minRecipientDenomination) || 0,
          maxAmount: Number(product.maxRecipientDenomination) || 0,
          fixedRecipientDenominations: Array.isArray(
            product.fixedRecipientDenominations,
          )
            ? product.fixedRecipientDenominations.map(Number)
            : [],

          recipient: {
            currency: product.recipientCurrencyCode || "",
            minAmount: Number(product.minRecipientDenomination) || 0,
            maxAmount: Number(product.maxRecipientDenomination) || 0,
            fixedDenominations: Array.isArray(
              product.fixedRecipientDenominations,
            )
              ? product.fixedRecipientDenominations.map(Number)
              : [],
          },

          sender: {
            currency: product.senderCurrencyCode || "",
            minAmount: Number(product.minSenderDenomination) || 0,
            maxAmount: Number(product.maxSenderDenomination) || 0,
            fixedDenominations: Array.isArray(product.fixedSenderDenominations)
              ? product.fixedSenderDenominations.map(Number)
              : [],
          },

          exchangeRate:
            Number(product.recipientCurrencyToSenderCurrencyExchangeRate) || 1,

          fees: {
            senderFee: Number(product.senderFee) || 0,
            senderFeePercentage: Number(product.senderFeePercentage) || 0,
            discountPercentage: Number(product.discountPercentage) || 0,
          },

          redeemInstructions: {
            concise: product.redeemInstruction?.concise?.trim() || "",
            verbose: product.redeemInstruction?.verbose?.trim() || "",
          },

          status: product.status || "ACTIVE",
          isGlobal: !!product.global,
          supportsPreOrder: !!product.supportsPreOrder,
          additionalRequirements: {
            userIdRequired:
              product.additionalRequirements?.userIdRequired ?? false,
          },
        };

        // User wallet
        const wallet = response?.data?.userWallet?.[0];
        if (wallet) {
          mappedCard.userWallet = {
            currency: wallet.currency_code,
            symbol: wallet.currency_symbol,
            balance: Number(wallet.balance) || 0,
            name: wallet.name,
            rate: Number(wallet.rate) || 1,
          };
        }

        // Platform charges (including daily/monthly limits)
        const charge = response?.data?.cardCharge;
        if (charge) {
          mappedCard.platformCharges = {
            fixed: Number(charge.fixed_charge) || 0,
            percentage: Number(charge.percent_charge) || 0,
            minLimit: Number(charge.min_limit) || 0,
            maxLimit: Number(charge.max_limit) || 0,
            dailyLimit: Number(charge.daily_limit) || 0,
            monthlyLimit: Number(charge.monthly_limit) || 0,
          };
        }

        setCard(mappedCard);
      } catch (err) {
        // Only show user-friendly message
        const userMessage = err.message?.includes("network")
          ? "Network error. Please check your connection."
          : "Something went wrong while loading the gift card";

        setError(userMessage);
        toast.error(userMessage);
      } finally {
        setLoading(false);
      }
    };

    fetchCardDetails();
  }, [productId]);

  if (loading) {
    return <GiftCardFormSkeleton />;
  }

  if (error) {
    return (
      <div className="min-h-[60vh] flex flex-col items-center justify-center gap-6 px-4">
        <div className="text-red-600 text-xl md:text-2xl font-medium text-center">
          {error}
        </div>
        <button
          onClick={() => window.location.reload()}
          className="cursor-pointer px-8 py-3 btn-primary text-white rounded-lg font-medium transition-colors"
        >
          Try Again
        </button>
      </div>
    );
  }

  if (!card) {
    return (
      <div className="min-h-[60vh] flex items-center justify-center text-red-600 text-xl">
        Gift Card not Found
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto px-4 py-8 lg:py-12">
      <Suspense fallback={<GiftCardFormSkeleton />}>
        <GiftCardForm card={card} />
      </Suspense>
    </div>
  );
}

import type { Metadata } from "next";
import { BuyVsRentCalculatorClient } from "@/components/calculators/BuyVsRentCalculatorClient";

export const metadata: Metadata = {
  title: "Buy vs Rent Calculator | Homebrix",
  description: "Compare the 10-year financial outcome of buying vs renting a home.",
};

export default function BuyVsRentCalculatorPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">Buy vs Rent Calculator</h1>
      <p className="text-muted-foreground mb-8">Compare the long-term cost of buying vs renting</p>
      <BuyVsRentCalculatorClient />
    </div>
  );
}

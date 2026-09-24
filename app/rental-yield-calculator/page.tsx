import type { Metadata } from "next";
import { RentalYieldCalculatorClient } from "@/components/calculators/RentalYieldCalculatorClient";

export const metadata: Metadata = {
  title: "Rental Yield Calculator | Homebrix",
  description: "Calculate gross and net rental yield to estimate ROI for investment properties.",
};

export default function RentalYieldCalculatorPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">Rental Yield Calculator</h1>
      <p className="text-muted-foreground mb-8">Estimate ROI for an investment property</p>
      <RentalYieldCalculatorClient />
    </div>
  );
}

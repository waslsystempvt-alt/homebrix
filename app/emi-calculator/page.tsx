import type { Metadata } from "next";
import { EmiCalculatorClient } from "@/components/calculators/EmiCalculatorClient";

export const metadata: Metadata = {
  title: "Home Loan EMI Calculator | Homebrix",
  description: "Calculate your monthly home loan EMI with amortization schedule. Plan your home purchase with accurate EMI estimates.",
};

export default function EmiCalculatorPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">EMI Calculator</h1>
      <p className="text-muted-foreground mb-8">Estimate your monthly home loan installment</p>
      <EmiCalculatorClient />
    </div>
  );
}

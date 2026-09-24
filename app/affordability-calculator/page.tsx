import type { Metadata } from "next";
import { AffordabilityCalculatorClient } from "@/components/calculators/AffordabilityCalculatorClient";

export const metadata: Metadata = {
  title: "Home Affordability Calculator | Homebrix",
  description: "Find out how much home you can afford based on your income, savings, and down payment.",
};

export default function AffordabilityCalculatorPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">Affordability Calculator</h1>
      <p className="text-muted-foreground mb-8">See how much home you can afford</p>
      <AffordabilityCalculatorClient />
    </div>
  );
}

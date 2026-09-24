import type { Metadata } from "next";
import { HomeLoanEligibilityClient } from "@/components/calculators/HomeLoanEligibilityClient";

export const metadata: Metadata = {
  title: "Home Loan Eligibility Calculator | Homebrix",
  description: "Check your maximum home loan eligibility based on your monthly income and existing obligations.",
};

export default function HomeLoanEligibilityPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">Home Loan Eligibility</h1>
      <p className="text-muted-foreground mb-8">Estimate the maximum loan amount you&apos;re eligible for</p>
      <HomeLoanEligibilityClient />
    </div>
  );
}

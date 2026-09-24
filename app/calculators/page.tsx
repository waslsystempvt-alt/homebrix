import type { Metadata } from "next";
import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Calculator, Landmark, Percent, Home, Scale, TrendingUp } from "lucide-react";

export const metadata: Metadata = {
  title: "Real Estate Calculators | Homebrix",
  description: "Free calculators for home buyers — EMI, stamp duty, home loan eligibility, affordability, buy vs rent, and rental yield.",
};

export const CALCULATORS = [
  { href: "/emi-calculator", title: "EMI Calculator", desc: "Calculate your monthly home loan EMI", icon: Calculator },
  { href: "/stamp-duty-calculator/maharashtra", title: "Stamp Duty Calculator", desc: "State-specific stamp duty & registration", icon: Landmark },
  { href: "/home-loan-eligibility", title: "Home Loan Eligibility", desc: "Check your maximum loan eligibility", icon: Percent },
  { href: "/affordability-calculator", title: "Affordability Calculator", desc: "Find out how much home you can afford", icon: Home },
  { href: "/buy-vs-rent-calculator", title: "Buy vs Rent Calculator", desc: "Compare 10-year cost of buying vs renting", icon: Scale },
  { href: "/rental-yield-calculator", title: "Rental Yield Calculator", desc: "Estimate ROI for investment properties", icon: TrendingUp },
];

export default function CalculatorsHubPage() {
  return (
    <div className="mx-auto max-w-5xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2 text-center">Real Estate Calculators</h1>
      <p className="text-muted-foreground text-center mb-10">Free tools to plan your home purchase</p>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
        {CALCULATORS.map((calc) => (
          <Link key={calc.href} href={calc.href}>
            <Card className="p-6 hover:shadow-md transition-shadow h-full flex gap-4 items-start">
              <calc.icon className="size-8 text-primary shrink-0" />
              <div>
                <p className="font-semibold">{calc.title}</p>
                <p className="text-sm text-muted-foreground">{calc.desc}</p>
              </div>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}

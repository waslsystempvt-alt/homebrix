"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Slider } from "@/components/ui/slider";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Calculator } from "lucide-react";
import { formatFullINR, formatIndianAmountInWords } from "@/lib/utils/format";
import { calculateEmi } from "@/lib/calculators/emi";
import { cn } from "@/lib/utils";

const LOAN_PRESETS = [
  { label: "50 L", value: 50_00_000 },
  { label: "1 Cr", value: 1_00_00_000 },
  { label: "5 Cr", value: 5_00_00_000 },
  { label: "20 Cr", value: 20_00_00_000 },
  { label: "30 Cr", value: 30_00_00_000 },
];

const MIN_LOAN = 5_00_000;
const MAX_LOAN = 30_00_00_000;

export function EmiCalculatorInline({ defaultPrice }: { defaultPrice: number }) {
  const [loanAmount, setLoanAmount] = useState(() => Math.min(Math.max(Math.round(defaultPrice), MIN_LOAN), MAX_LOAN));
  const [interestRate, setInterestRate] = useState(9);
  const [tenureYears, setTenureYears] = useState(20);

  const emi = useMemo(
    () => calculateEmi(loanAmount, interestRate, tenureYears),
    [loanAmount, interestRate, tenureYears]
  );
  const totalPayable = emi * tenureYears * 12;
  const totalInterest = totalPayable - loanAmount;

  return (
    <section className="space-y-1">
      <div className="flex items-center gap-2">
        <Calculator className="size-5 text-primary" />
        <h2 className="text-xl font-bold">EMI Calculator</h2>
      </div>
      <p className="text-sm text-muted-foreground mb-4">Plan your home loan with our EMI calculator</p>

      <Card className="rounded-2xl p-6 shadow-sm">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 lg:gap-8">
          <div className="space-y-5">
            <div className="space-y-2">
              <div className="flex items-baseline justify-between gap-3">
                <Label>Loan Amount</Label>
                <div className="text-right">
                  <p className="font-bold leading-tight">{formatFullINR(loanAmount)}</p>
                  <p className="text-xs text-muted-foreground">{formatIndianAmountInWords(loanAmount)}</p>
                </div>
              </div>
              <Slider
                value={[loanAmount]}
                onValueChange={([v]) => setLoanAmount(v)}
                min={MIN_LOAN}
                max={MAX_LOAN}
                step={50_000}
              />
              <div className="flex flex-wrap gap-2 pt-1">
                {LOAN_PRESETS.map((p) => (
                  <button
                    key={p.label}
                    type="button"
                    onClick={() => setLoanAmount(p.value)}
                    className={cn(
                      "rounded-full border px-3 py-1 text-xs font-medium transition-colors",
                      loanAmount === p.value
                        ? "border-primary bg-primary/10 text-primary"
                        : "text-muted-foreground hover:border-primary/40 hover:text-foreground"
                    )}
                  >
                    {p.label}
                  </button>
                ))}
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="emi-rate">Interest Rate (p.a.)*</Label>
                <div className="relative">
                  <Input
                    id="emi-rate"
                    type="number"
                    step="0.1"
                    min={1}
                    max={20}
                    value={interestRate}
                    onChange={(e) => setInterestRate(Number(e.target.value) || 0)}
                    className="pr-8"
                  />
                  <span className="absolute right-3 top-1/2 -translate-y-1/2 text-sm text-muted-foreground">%</span>
                </div>
              </div>
              <div className="space-y-2">
                <div className="flex items-baseline justify-between">
                  <Label>Tenure (Yrs)</Label>
                  <span className="font-bold">{tenureYears}</span>
                </div>
                <Slider value={[tenureYears]} onValueChange={([v]) => setTenureYears(v)} min={1} max={30} step={1} className="mt-3" />
              </div>
            </div>
          </div>

          <div className="flex flex-col gap-4">
            <div className="rounded-xl bg-primary/10 p-4 text-center">
              <p className="text-sm text-muted-foreground">Monthly EMI</p>
              <p className="text-2xl font-bold text-primary">{formatFullINR(emi)}*</p>
            </div>

            <div className="divide-y rounded-lg border sm:grid sm:grid-cols-3 sm:gap-2 sm:divide-y-0 sm:border-none sm:text-center">
              <div className="flex items-center justify-between gap-2 p-2.5 sm:block sm:rounded-lg sm:border">
                <p className="text-xs text-muted-foreground sm:text-[10px] sm:leading-tight">Principal</p>
                <p className="text-sm font-semibold sm:text-xs">{formatFullINR(loanAmount)}</p>
              </div>
              <div className="flex items-center justify-between gap-2 p-2.5 sm:block sm:rounded-lg sm:border">
                <p className="text-xs text-muted-foreground sm:text-[10px] sm:leading-tight">Interest Payable</p>
                <p className="text-sm font-semibold sm:text-xs">{formatFullINR(totalInterest)}*</p>
              </div>
              <div className="flex items-center justify-between gap-2 p-2.5 sm:block sm:rounded-lg sm:border">
                <p className="text-xs text-muted-foreground sm:text-[10px] sm:leading-tight">Total Payable</p>
                <p className="text-sm font-semibold sm:text-xs">{formatFullINR(totalPayable)}*</p>
              </div>
            </div>

            <div className="flex gap-3 mt-auto">
              <Button className="h-10 flex-1 rounded-xl" asChild>
                <a href="#lead-form">Apply Now</a>
              </Button>
              <Button variant="outline" className="h-10 flex-1 rounded-xl" asChild>
                <Link href="/emi-calculator">Know More</Link>
              </Button>
            </div>
          </div>
        </div>

        <p className="text-xs text-muted-foreground text-center mt-5">
          *For representation purpose only. Final values may vary subject to bank&apos;s policy.
        </p>
      </Card>
    </section>
  );
}

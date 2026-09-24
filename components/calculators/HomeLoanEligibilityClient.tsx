"use client";

import { useMemo, useState } from "react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { SliderField } from "@/components/calculators/SliderField";
import { maxLoanFromEmi } from "@/lib/calculators/emi";
import { formatPriceINR } from "@/lib/utils/format";

const FOIR = 0.5; // Fixed Obligation to Income Ratio banks typically use

export function HomeLoanEligibilityClient() {
  const [monthlyIncome, setMonthlyIncome] = useState(100000);
  const [existingEmis, setExistingEmis] = useState(0);
  const [interestRate, setInterestRate] = useState(8.5);
  const [tenureYears, setTenureYears] = useState(20);

  const maxAffordableEmi = useMemo(
    () => Math.max(0, monthlyIncome * FOIR - existingEmis),
    [monthlyIncome, existingEmis]
  );

  const maxLoan = useMemo(
    () => maxLoanFromEmi(maxAffordableEmi, interestRate, tenureYears),
    [maxAffordableEmi, interestRate, tenureYears]
  );

  return (
    <Card className="p-6 space-y-6">
      <div className="space-y-2">
        <Label>Monthly Income</Label>
        <Input type="number" value={monthlyIncome} onChange={(e) => setMonthlyIncome(Number(e.target.value) || 0)} />
      </div>

      <div className="space-y-2">
        <Label>Existing Monthly EMIs (if any)</Label>
        <Input type="number" value={existingEmis} onChange={(e) => setExistingEmis(Number(e.target.value) || 0)} />
      </div>

      <SliderField
        label="Interest Rate"
        value={interestRate}
        onChange={setInterestRate}
        min={5}
        max={15}
        step={0.1}
        formatValue={(v) => `${v.toFixed(1)}%`}
      />

      <SliderField
        label="Tenure"
        value={tenureYears}
        onChange={setTenureYears}
        min={5}
        max={30}
        step={1}
        formatValue={(v) => `${v} years`}
      />

      <div className="rounded-lg bg-primary/5 p-4 text-center space-y-1">
        <p className="text-sm text-muted-foreground">You&apos;re eligible for a loan of up to</p>
        <p className="text-2xl font-bold text-primary">{formatPriceINR(Math.round(maxLoan))}</p>
        <p className="text-xs text-muted-foreground">
          Based on max EMI of ₹{Math.round(maxAffordableEmi).toLocaleString("en-IN")}/month (50% of income after existing obligations)
        </p>
      </div>
    </Card>
  );
}

"use client";

import { useMemo, useState } from "react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { SliderField } from "@/components/calculators/SliderField";
import { maxLoanFromEmi } from "@/lib/calculators/emi";
import { formatPriceINR } from "@/lib/utils/format";

const FOIR = 0.5;

export function AffordabilityCalculatorClient() {
  const [monthlyIncome, setMonthlyIncome] = useState(100000);
  const [downPaymentSavings, setDownPaymentSavings] = useState(1000000);
  const [interestRate, setInterestRate] = useState(8.5);
  const [tenureYears, setTenureYears] = useState(20);

  const maxAffordableEmi = monthlyIncome * FOIR;
  const maxLoan = useMemo(
    () => maxLoanFromEmi(maxAffordableEmi, interestRate, tenureYears),
    [maxAffordableEmi, interestRate, tenureYears]
  );
  const maxPropertyValue = maxLoan + downPaymentSavings;

  return (
    <Card className="p-6 space-y-6">
      <div className="space-y-2">
        <Label>Monthly Income</Label>
        <Input type="number" value={monthlyIncome} onChange={(e) => setMonthlyIncome(Number(e.target.value) || 0)} />
      </div>

      <div className="space-y-2">
        <Label>Down Payment Savings</Label>
        <Input
          type="number"
          value={downPaymentSavings}
          onChange={(e) => setDownPaymentSavings(Number(e.target.value) || 0)}
        />
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
        <p className="text-sm text-muted-foreground">You can afford a home up to</p>
        <p className="text-2xl font-bold text-primary">{formatPriceINR(Math.round(maxPropertyValue))}</p>
        <p className="text-xs text-muted-foreground">
          {formatPriceINR(Math.round(maxLoan))} loan + {formatPriceINR(downPaymentSavings)} down payment
        </p>
      </div>
    </Card>
  );
}

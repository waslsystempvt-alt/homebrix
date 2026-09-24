"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { SliderField } from "@/components/calculators/SliderField";
import { calculateEmi, buildAmortizationSchedule } from "@/lib/calculators/emi";
import { formatPriceINR } from "@/lib/utils/format";

export function EmiCalculatorClient() {
  const [principal, setPrincipal] = useState(6500000);
  const [interestRate, setInterestRate] = useState(8.5);
  const [tenureYears, setTenureYears] = useState(20);

  const emi = useMemo(() => calculateEmi(principal, interestRate, tenureYears), [principal, interestRate, tenureYears]);
  const totalPayment = emi * tenureYears * 12;
  const totalInterest = totalPayment - principal;
  const schedule = useMemo(
    () => buildAmortizationSchedule(principal, interestRate, tenureYears),
    [principal, interestRate, tenureYears]
  );

  return (
    <div className="space-y-8">
      <Card className="p-6 space-y-6">
        <div className="space-y-2">
          <Label>Loan Amount</Label>
          <Input type="number" value={principal} onChange={(e) => setPrincipal(Number(e.target.value) || 0)} />
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

        <div className="grid grid-cols-3 gap-4 pt-4 border-t text-center">
          <div>
            <p className="text-xs text-muted-foreground">Monthly EMI</p>
            <p className="text-xl font-bold text-primary">₹{Math.round(emi).toLocaleString("en-IN")}</p>
          </div>
          <div>
            <p className="text-xs text-muted-foreground">Total Interest</p>
            <p className="text-xl font-bold">{formatPriceINR(totalInterest)}</p>
          </div>
          <div>
            <p className="text-xs text-muted-foreground">Total Payment</p>
            <p className="text-xl font-bold">{formatPriceINR(totalPayment)}</p>
          </div>
        </div>

        <Button className="w-full" variant="outline" asChild>
          <Link href="/home-loan-eligibility">Apply for Home Loan →</Link>
        </Button>
      </Card>

      <Card className="p-6">
        <h2 className="font-semibold mb-4">Amortization Schedule (Yearly)</h2>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left p-2 font-medium">Year</th>
                <th className="text-right p-2 font-medium">Principal Paid</th>
                <th className="text-right p-2 font-medium">Interest Paid</th>
                <th className="text-right p-2 font-medium">Balance</th>
              </tr>
            </thead>
            <tbody>
              {schedule.map((row) => (
                <tr key={row.year} className="border-t">
                  <td className="p-2">{row.year}</td>
                  <td className="p-2 text-right">{formatPriceINR(Math.round(row.principalPaid))}</td>
                  <td className="p-2 text-right">{formatPriceINR(Math.round(row.interestPaid))}</td>
                  <td className="p-2 text-right">{formatPriceINR(Math.round(row.balance))}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  );
}

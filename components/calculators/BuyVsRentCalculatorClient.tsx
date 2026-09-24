"use client";

import { useMemo, useState } from "react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { SliderField } from "@/components/calculators/SliderField";
import { calculateBuyVsRent } from "@/lib/calculators/buyVsRent";
import { formatPriceINR } from "@/lib/utils/format";
import {
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

export function BuyVsRentCalculatorClient() {
  const [propertyPrice, setPropertyPrice] = useState(6500000);
  const [downPaymentPct, setDownPaymentPct] = useState(20);
  const [monthlyRent, setMonthlyRent] = useState(25000);
  const [interestRate, setInterestRate] = useState(8.5);

  const data = useMemo(
    () =>
      calculateBuyVsRent({
        propertyPrice,
        downPaymentPct,
        interestRate,
        loanTenureYears: 20,
        monthlyRent,
        rentEscalationPct: 5,
        propertyAppreciationPct: 6,
        investmentReturnPct: 10,
        years: 10,
      }),
    [propertyPrice, downPaymentPct, monthlyRent, interestRate]
  );

  const final = data[data.length - 1];
  const buyingIsCheaper = final.netCostBuying < final.netCostRenting;

  return (
    <div className="space-y-6">
      <Card className="p-6 space-y-6">
        <div className="space-y-2">
          <Label>Property Price</Label>
          <Input type="number" value={propertyPrice} onChange={(e) => setPropertyPrice(Number(e.target.value) || 0)} />
        </div>

        <div className="space-y-2">
          <Label>Monthly Rent (equivalent property)</Label>
          <Input type="number" value={monthlyRent} onChange={(e) => setMonthlyRent(Number(e.target.value) || 0)} />
        </div>

        <SliderField
          label="Down Payment"
          value={downPaymentPct}
          onChange={setDownPaymentPct}
          min={10}
          max={50}
          step={5}
          formatValue={(v) => `${v}%`}
        />

        <SliderField
          label="Interest Rate"
          value={interestRate}
          onChange={setInterestRate}
          min={5}
          max={15}
          step={0.1}
          formatValue={(v) => `${v.toFixed(1)}%`}
        />
      </Card>

      <Card className="p-6">
        <h2 className="font-semibold mb-4">Net Cost Over 10 Years</h2>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={data} margin={{ left: 10, right: 10 }}>
              <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
              <XAxis dataKey="year" tickFormatter={(v) => `Yr ${v}`} fontSize={12} />
              <YAxis tickFormatter={(v) => formatPriceINR(v)} fontSize={12} width={70} />
              <Tooltip formatter={(v) => formatPriceINR(Number(v))} labelFormatter={(v) => `Year ${v}`} />
              <Line type="monotone" dataKey="netCostBuying" name="Buying" stroke="var(--primary)" strokeWidth={2} />
              <Line type="monotone" dataKey="netCostRenting" name="Renting" stroke="#94a3b8" strokeWidth={2} />
            </LineChart>
          </ResponsiveContainer>
        </div>
        <div className="mt-4 text-center rounded-lg bg-primary/5 p-4">
          <p className="font-semibold">
            {buyingIsCheaper ? "Buying" : "Renting"} looks better over 10 years by{" "}
            {formatPriceINR(Math.abs(final.netCostBuying - final.netCostRenting))}
          </p>
          <p className="text-xs text-muted-foreground mt-1">
            Lower net cost = better outcome (accounts for property appreciation and invested savings). Estimate only, not financial advice.
          </p>
        </div>
      </Card>
    </div>
  );
}

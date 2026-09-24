"use client";

import { useMemo, useState } from "react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { formatPriceINR } from "@/lib/utils/format";

export function RentalYieldCalculatorClient() {
  const [propertyPrice, setPropertyPrice] = useState(6500000);
  const [monthlyRent, setMonthlyRent] = useState(25000);
  const [annualExpenses, setAnnualExpenses] = useState(30000);

  const { grossYield, netYield, annualRent } = useMemo(() => {
    const annualRent = monthlyRent * 12;
    const grossYield = propertyPrice > 0 ? (annualRent / propertyPrice) * 100 : 0;
    const netYield = propertyPrice > 0 ? ((annualRent - annualExpenses) / propertyPrice) * 100 : 0;
    return { grossYield, netYield, annualRent };
  }, [propertyPrice, monthlyRent, annualExpenses]);

  return (
    <Card className="p-6 space-y-6">
      <div className="space-y-2">
        <Label>Property Price</Label>
        <Input type="number" value={propertyPrice} onChange={(e) => setPropertyPrice(Number(e.target.value) || 0)} />
      </div>

      <div className="space-y-2">
        <Label>Monthly Rent</Label>
        <Input type="number" value={monthlyRent} onChange={(e) => setMonthlyRent(Number(e.target.value) || 0)} />
      </div>

      <div className="space-y-2">
        <Label>Annual Expenses (maintenance, tax, etc.)</Label>
        <Input type="number" value={annualExpenses} onChange={(e) => setAnnualExpenses(Number(e.target.value) || 0)} />
      </div>

      <div className="grid grid-cols-2 gap-4 pt-4 border-t">
        <div className="rounded-lg bg-primary/5 p-4 text-center">
          <p className="text-xs text-muted-foreground">Gross Yield</p>
          <p className="text-2xl font-bold text-primary">{grossYield.toFixed(2)}%</p>
        </div>
        <div className="rounded-lg bg-muted p-4 text-center">
          <p className="text-xs text-muted-foreground">Net Yield</p>
          <p className="text-2xl font-bold">{netYield.toFixed(2)}%</p>
        </div>
      </div>
      <p className="text-xs text-muted-foreground text-center">Annual rent: {formatPriceINR(annualRent)}</p>
    </Card>
  );
}

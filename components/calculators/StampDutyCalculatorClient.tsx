"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { formatPriceINR } from "@/lib/utils/format";

export function StampDutyCalculatorClient({
  currentState,
  allStates,
}: {
  currentState: { slug: string; name: string; stampDutyPct: number; registrationPct: number };
  allStates: { slug: string; name: string }[];
}) {
  const router = useRouter();
  const [price, setPrice] = useState(6500000);

  const { stampDuty, registration, total } = useMemo(() => {
    const stampDuty = (price * currentState.stampDutyPct) / 100;
    const registration = (price * currentState.registrationPct) / 100;
    return { stampDuty, registration, total: stampDuty + registration };
  }, [price, currentState]);

  return (
    <Card className="p-6 space-y-6">
      <div className="space-y-2">
        <Label>State</Label>
        <Select value={currentState.slug} onValueChange={(v) => router.push(`/stamp-duty-calculator/${v}`)}>
          <SelectTrigger className="w-full">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {allStates.map((s) => (
              <SelectItem key={s.slug} value={s.slug}>
                {s.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-2">
        <Label>Property Value</Label>
        <Input type="number" value={price} onChange={(e) => setPrice(Number(e.target.value) || 0)} />
      </div>

      <div className="space-y-3 pt-4 border-t">
        <div className="flex justify-between text-sm">
          <span>Stamp Duty ({currentState.stampDutyPct}%)</span>
          <span className="font-medium">{formatPriceINR(stampDuty)}</span>
        </div>
        <div className="flex justify-between text-sm">
          <span>Registration Fee ({currentState.registrationPct}%)</span>
          <span className="font-medium">{formatPriceINR(registration)}</span>
        </div>
        <div className="flex justify-between pt-3 border-t font-semibold">
          <span>Total Charges</span>
          <span className="text-primary">{formatPriceINR(total)}</span>
        </div>
      </div>
    </Card>
  );
}

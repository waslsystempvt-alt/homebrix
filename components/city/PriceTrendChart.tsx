"use client";

import { CartesianGrid, Line, LineChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

interface PriceTrendPoint {
  periodEnd: Date;
  avgPriceSqft: number | null;
}

export function PriceTrendChart({ trend }: { trend: PriceTrendPoint[] }) {
  const data = trend
    .filter((t) => t.avgPriceSqft !== null)
    .map((t) => ({
      period: t.periodEnd.toLocaleDateString("en-IN", { month: "short", year: "2-digit" }),
      avgPriceSqft: t.avgPriceSqft,
    }));

  if (data.length < 2) return null;

  return (
    <div className="h-72 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data} margin={{ left: 10, right: 10 }}>
          <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
          <XAxis dataKey="period" fontSize={12} />
          <YAxis tickFormatter={(v) => `₹${v.toLocaleString("en-IN")}`} fontSize={12} width={70} />
          <Tooltip
            formatter={(v) => [`₹${Number(v).toLocaleString("en-IN")}/sqft`, "Avg. Price"]}
            labelFormatter={(v) => v}
          />
          <Line type="monotone" dataKey="avgPriceSqft" name="Avg ₹/sqft" stroke="var(--primary)" strokeWidth={2} dot={false} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

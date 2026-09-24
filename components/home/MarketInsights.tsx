import { Card } from "@/components/ui/card";
import { TrendingUp } from "lucide-react";
import { getMarketInsights } from "@/lib/db/queries";
import { SectionHeading } from "@/components/home/SectionHeading";

export async function MarketInsights() {
  const insights = await getMarketInsights(6);
  if (insights.length === 0) return null;

  return (
    <section className="mx-auto max-w-7xl px-4 py-14">
      <SectionHeading kicker="Live Data" title="Market Insights" subtitle="Average rates across our top markets, updated regularly." />
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-4">
        {insights.map((insight) => (
          <Card key={insight.slug} className="gap-2 p-4 shadow-sm transition-shadow hover:shadow-md">
            <p className="text-sm font-medium text-muted-foreground">{insight.city}</p>
            <p className="text-lg font-bold">₹{insight.avgPriceSqft.toLocaleString("en-IN")}</p>
            <p className="flex items-center gap-1 text-xs font-medium text-success">
              <TrendingUp className="size-3.5" />
              per sqft
            </p>
          </Card>
        ))}
      </div>
    </section>
  );
}

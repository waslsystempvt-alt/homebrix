import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { PriceTrendChart } from "@/components/city/PriceTrendChart";
import type { getPropertyRatesData } from "@/lib/db/queries";

function ChangeBadge({ pct }: { pct: number | null | undefined }) {
  if (pct === null || pct === undefined) return null;
  const n = Number(pct);
  return (
    <Badge variant={n >= 0 ? "success" : "destructive"} className="font-medium">
      {n >= 0 ? "+" : ""}
      {n.toFixed(1)}%
    </Badge>
  );
}

export function PropertyRatesView({
  data,
}: {
  data: NonNullable<Awaited<ReturnType<typeof getPropertyRatesData>>>;
}) {
  const { city, avgPriceSqft, latestCityTrend, cityTrend, localityRates, mostAppreciated } = data;

  return (
    <div>
      <section className="border-b bg-gradient-to-b from-primary/5 to-background py-12 px-4">
        <div className="mx-auto max-w-3xl text-center">
          <h1 className="text-3xl md:text-4xl font-bold tracking-tight mb-3">
            Property Rates in {city.name}
          </h1>
          <p className="text-muted-foreground text-lg">
            {avgPriceSqft ? `Average ₹${avgPriceSqft.toLocaleString("en-IN")}/sqft` : "Price trends"} across{" "}
            {city.localities.length} localities
            {latestCityTrend?.yoyChangePct != null && (
              <>
                {" "}
                · <ChangeBadge pct={Number(latestCityTrend.yoyChangePct)} /> YoY
              </>
            )}
          </p>
        </div>
      </section>

      {cityTrend.length >= 2 && (
        <section className="mx-auto max-w-5xl px-4 py-10">
          <h2 className="text-2xl font-bold mb-6">{city.name} Price Trend</h2>
          <Card className="p-4">
            <PriceTrendChart trend={cityTrend} />
          </Card>
          {latestCityTrend && (
            <div className="mt-4 flex flex-wrap gap-6 text-sm">
              {latestCityTrend.yoyChangePct != null && (
                <div>
                  <span className="text-muted-foreground">1yr change: </span>
                  <ChangeBadge pct={Number(latestCityTrend.yoyChangePct)} />
                </div>
              )}
              {latestCityTrend.qoqChangePct != null && (
                <div>
                  <span className="text-muted-foreground">Quarterly change: </span>
                  <ChangeBadge pct={Number(latestCityTrend.qoqChangePct)} />
                </div>
              )}
            </div>
          )}
        </section>
      )}

      {mostAppreciated.length > 0 && (
        <section className="mx-auto max-w-5xl px-4 py-10 border-t">
          <h2 className="text-2xl font-bold mb-6">Most Appreciated Localities</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {mostAppreciated.map(({ locality, latestTrend }) => (
              <Link key={locality.id} href={`/${city.slug}/${locality.slug}-real-estate`}>
                <Card className="p-4 hover:shadow-md transition-shadow gap-1">
                  <div className="flex items-center justify-between">
                    <p className="font-medium text-sm">{locality.name}</p>
                    <ChangeBadge pct={latestTrend?.yoyChangePct != null ? Number(latestTrend.yoyChangePct) : null} />
                  </div>
                  {locality.avgPriceSqft && (
                    <p className="text-xs text-muted-foreground">₹{locality.avgPriceSqft.toLocaleString("en-IN")}/sqft</p>
                  )}
                </Card>
              </Link>
            ))}
          </div>
        </section>
      )}

      <section className="mx-auto max-w-5xl px-4 py-10 border-t">
        <h2 className="text-2xl font-bold mb-6">Locality-wise Rates in {city.name}</h2>
        <Card className="overflow-x-auto p-0">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b text-left text-muted-foreground">
                <th className="px-4 py-3 font-medium">Locality</th>
                <th className="px-4 py-3 font-medium">Avg. Price/sqft</th>
                <th className="px-4 py-3 font-medium">1yr Change</th>
                <th className="px-4 py-3 font-medium">New Projects</th>
              </tr>
            </thead>
            <tbody>
              {localityRates.map(({ locality, latestTrend }) => (
                <tr key={locality.id} className="border-b last:border-0">
                  <td className="px-4 py-3">
                    <Link href={`/${city.slug}/${locality.slug}-real-estate`} className="font-medium hover:text-primary hover:underline">
                      {locality.name}
                    </Link>
                  </td>
                  <td className="px-4 py-3">
                    {locality.avgPriceSqft ? `₹${locality.avgPriceSqft.toLocaleString("en-IN")}` : "—"}
                  </td>
                  <td className="px-4 py-3">
                    {latestTrend?.yoyChangePct != null ? (
                      <ChangeBadge pct={Number(latestTrend.yoyChangePct)} />
                    ) : (
                      "—"
                    )}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground">{locality.projectCount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </Card>
      </section>

      <section className="mx-auto max-w-5xl px-4 py-10 border-t flex flex-wrap gap-3">
        <Link href={`/new-projects-in-${city.slug}`} className="px-4 py-2 rounded-full border text-sm hover:bg-muted">
          New Projects in {city.name}
        </Link>
        <Link href={`/${city.slug}-real-estate`} className="px-4 py-2 rounded-full border text-sm hover:bg-muted">
          {city.name} Real Estate
        </Link>
        <Link href={`/builders-in-${city.slug}`} className="px-4 py-2 rounded-full border text-sm hover:bg-muted">
          Builders in {city.name}
        </Link>
      </section>
    </div>
  );
}

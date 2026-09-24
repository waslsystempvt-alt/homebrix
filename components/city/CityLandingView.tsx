import Link from "next/link";
import { Card } from "@/components/ui/card";
import { ProjectSection } from "@/components/home/ProjectSection";
import { HeroSearchBar } from "@/components/search/HeroSearchBar";
import type { getCityLandingData } from "@/lib/db/queries";

export function CityLandingView({ data }: { data: NonNullable<Awaited<ReturnType<typeof getCityLandingData>>> }) {
  const { city, avgPriceSqft, totalProjects, newLaunch, underConstruction, readyToMove, builders, nearbyCities } = data;

  return (
    <div>
      <section className="border-b bg-gradient-to-b from-primary/5 to-background py-12 px-4">
        <div className="mx-auto max-w-3xl text-center mb-8">
          <h1 className="text-3xl md:text-4xl font-bold tracking-tight mb-3">
            Real Estate in {city.name}
          </h1>
          <p className="text-muted-foreground text-lg">
            {totalProjects.toLocaleString("en-IN")} new projects · {builders.length} builders
            {avgPriceSqft && (
              <>
                {" · Avg "}
                <Link href={`/property-rates-in-${city.slug}`} className="text-primary hover:underline">
                  ₹{avgPriceSqft.toLocaleString("en-IN")}/sqft
                </Link>
              </>
            )}
          </p>
        </div>
        <HeroSearchBar />
      </section>

      <section className="mx-auto max-w-7xl px-4 py-10">
        <h2 className="text-2xl font-bold mb-6">Top Localities in {city.name}</h2>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          {city.localities.map((locality) => (
            <Link key={locality.id} href={`/${city.slug}/${locality.slug}-real-estate`}>
              <Card className="p-4 hover:shadow-md transition-shadow gap-1">
                <p className="font-medium text-sm">{locality.name}</p>
                {locality.avgPriceSqft && (
                  <p className="text-xs text-muted-foreground">₹{locality.avgPriceSqft.toLocaleString("en-IN")}/sqft</p>
                )}
              </Card>
            </Link>
          ))}
        </div>
      </section>

      <ProjectSection title="New Launch Projects" projects={newLaunch} viewAllHref={`/new-launch-in-${city.slug}`} />
      <ProjectSection title="Under Construction Projects" projects={underConstruction} viewAllHref={`/under-construction-in-${city.slug}`} />
      <ProjectSection title="Ready to Move Projects" projects={readyToMove} viewAllHref={`/ready-to-move-in-${city.slug}`} />

      {builders.length > 0 && (
        <section className="mx-auto max-w-7xl px-4 py-10">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-2xl font-bold">Top Builders in {city.name}</h2>
            <Link href={`/builders-in-${city.slug}`} className="text-sm font-medium text-primary hover:underline">
              View All →
            </Link>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-6 gap-4">
            {builders.slice(0, 6).map((builder) => (
              <Link key={builder.id} href={`/builder/${builder.slug}`}>
                <Card className="p-4 text-center hover:shadow-md transition-shadow gap-1">
                  <p className="font-medium text-sm line-clamp-1">{builder.name}</p>
                  <p className="text-xs text-muted-foreground">{builder._count.projects} projects</p>
                </Card>
              </Link>
            ))}
          </div>
        </section>
      )}

      {nearbyCities.length > 0 && (
        <section className="mx-auto max-w-7xl px-4 py-10">
          <h2 className="text-2xl font-bold mb-6">Nearby Cities</h2>
          <div className="flex flex-wrap gap-3">
            {nearbyCities.map((nc) => (
              <Link
                key={nc.slug}
                href={`/${nc.slug}-real-estate`}
                className="px-4 py-2 rounded-full border text-sm hover:bg-muted"
              >
                {nc.name}
              </Link>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}

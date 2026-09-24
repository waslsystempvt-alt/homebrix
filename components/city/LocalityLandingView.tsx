import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { MapPin, Building2, TrendingUp } from "lucide-react";
import { ProjectSection } from "@/components/home/ProjectSection";
import type { getLocalityLandingData } from "@/lib/db/queries";
import { buildFilterPath } from "@/lib/search/pathFilter";
import { breadcrumbSchema, itemListSchema, jsonLdScript } from "@/lib/seo/schema";
import { SITE_URL } from "@/lib/seo/site";

export function LocalityLandingView({
  data,
}: {
  data: NonNullable<Awaited<ReturnType<typeof getLocalityLandingData>>>;
}) {
  const { city, locality, projects, nearbyLocalities, builders, places } = data;

  const pathname = `/${city.slug}/${locality.slug}-real-estate`;

  const breadcrumb = breadcrumbSchema([
    { name: "Home", url: SITE_URL },
    { name: city.name, url: `${SITE_URL}/${city.slug}-real-estate` },
    { name: `${locality.name} Real Estate`, url: `${SITE_URL}${pathname}` },
  ]);

  const itemList = itemListSchema(
    projects.map((p) => ({ name: p.name, url: `${SITE_URL}/projects/${p.city.slug}/${p.slug}` }))
  );

  const placeSchema = {
    "@context": "https://schema.org",
    "@type": "Place",
    name: `${locality.name}, ${city.name}`,
    address: {
      "@type": "PostalAddress",
      addressLocality: locality.name,
      addressRegion: city.name,
      addressCountry: "IN",
    },
  };

  const bhkQuickLinks = [
    { label: `1 BHK in ${locality.name}`, href: buildFilterPath(`new-projects-in-${city.slug}`, { locality: locality.slug, bhk: 1 }) },
    { label: `2 BHK in ${locality.name}`, href: buildFilterPath(`new-projects-in-${city.slug}`, { locality: locality.slug, bhk: 2 }) },
    { label: `3 BHK in ${locality.name}`, href: buildFilterPath(`new-projects-in-${city.slug}`, { locality: locality.slug, bhk: 3 }) },
    { label: `Under ₹1 Cr in ${locality.name}`, href: buildFilterPath(`new-projects-in-${city.slug}`, { locality: locality.slug, budgetSlug: "under-1-crore" }) },
  ];

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 space-y-10">
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(breadcrumb)} />
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(itemList)} />
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(placeSchema)} />

      {/* Header Banner */}
      <div className="bg-card border rounded-2xl p-6 sm:p-8 shadow-xs space-y-4">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant="secondary">Locality Overview</Badge>
          <Badge variant="outline">{city.name}</Badge>
        </div>

        <h1 className="text-3xl font-bold tracking-tight sm:text-4xl text-foreground">
          {locality.name}, {city.name} Real Estate
        </h1>

        <div className="flex flex-wrap items-center gap-6 text-sm text-muted-foreground pt-2">
          <span className="flex items-center gap-1.5 font-medium text-foreground">
            <Building2 className="size-4 text-primary" />
            <strong className="text-foreground">{projects.length}</strong> active projects
          </span>
          {locality.avgPriceSqft && (
            <span className="flex items-center gap-1.5 font-medium text-foreground">
              <TrendingUp className="size-4 text-green-600" />
              Avg <strong className="text-foreground">₹{locality.avgPriceSqft.toLocaleString("en-IN")}</strong>/sq.ft
            </span>
          )}
        </div>

        {/* Quick BHK Links */}
        <div className="pt-4 border-t flex flex-wrap gap-2">
          {bhkQuickLinks.map((link) => (
            <Link
              key={link.label}
              href={link.href}
              className="px-3 py-1.5 rounded-full border bg-background text-xs font-medium hover:bg-muted transition-colors"
            >
              {link.label}
            </Link>
          ))}
        </div>
      </div>

      {/* Projects List */}
      <ProjectSection title={`New Projects in ${locality.name}`} projects={projects} />

      {/* Top Landmarks in Locality */}
      {places && places.length > 0 && (
        <section className="space-y-4">
          <div>
            <h2 className="text-xl font-bold">Top Landmarks near {locality.name}</h2>
            <p className="text-sm text-muted-foreground">Find properties close to major hubs, stations and hospitals</p>
          </div>
          <div className="flex flex-wrap gap-3">
            {places.map((place) => (
              <Link
                key={place.id}
                href={`/flats-near-${place.seoSlug}`}
                className="px-4 py-2 rounded-xl border bg-card hover:bg-muted text-sm flex items-center gap-2 transition-colors shadow-xs"
              >
                <MapPin className="size-4 text-primary shrink-0" />
                <span className="font-medium">{place.name}</span>
                <span className="text-xs text-muted-foreground capitalize">
                  ({place.category.replace(/_/g, " ")})
                </span>
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Builders in Locality */}
      {builders.length > 0 && (
        <section>
          <h2 className="text-xl font-bold mb-4">Top Builders Active Here</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-4">
            {builders.map((builder) => (
              <Link key={builder.id} href={`/builder/${builder.slug}`}>
                <Card className="p-4 text-center hover:shadow-md transition-shadow gap-1">
                  <p className="font-medium text-sm line-clamp-1">{builder.name}</p>
                </Card>
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Nearby Localities */}
      {nearbyLocalities.length > 0 && (
        <section>
          <h2 className="text-xl font-bold mb-4">Nearby Localities</h2>
          <div className="flex flex-wrap gap-3">
            {nearbyLocalities.map((nl) => (
              <Link
                key={nl.id}
                href={`/${city.slug}/${nl.slug}-real-estate`}
                className="px-4 py-2 rounded-full border text-sm hover:bg-muted flex items-center gap-2"
              >
                {nl.name}
                {nl.avgPriceSqft && (
                  <span className="text-muted-foreground">₹{nl.avgPriceSqft.toLocaleString("en-IN")}/sqft</span>
                )}
              </Link>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}

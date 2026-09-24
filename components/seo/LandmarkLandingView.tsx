import Link from "next/link";
import { ChevronRight, MapPin, Star, Building2 } from "lucide-react";
import { FilterSidebar } from "@/components/search/FilterSidebar";
import { SortBar } from "@/components/search/SortBar";
import { Pagination } from "@/components/search/Pagination";
import { ProjectCardWide } from "@/components/project/ProjectCardWide";
import { Badge } from "@/components/ui/badge";
import { generateLandmarkSeoContent } from "@/lib/seo/landmarkContent";
import { formatPriceINR } from "@/lib/utils/format";
import type { FacetOption } from "@/lib/search/query";
import type { SearchFilters } from "@/lib/search/types";
import { breadcrumbSchema, itemListSchema, jsonLdScript } from "@/lib/seo/schema";
import { SITE_URL } from "@/lib/seo/site";

export function LandmarkLandingView({
  place,
  city,
  projects,
  total,
  totalPages,
  filters,
  rawSearchParams,
  localityFacets,
  regionFacets,
  builderFacets,
  cityFacets,
}: {
  place: {
    id: string;
    name: string;
    slug: string;
    seoSlug: string;
    category: string;
    address?: string | null;
    rating?: any;
    reviewCount?: number | null;
    importanceScore: number;
  };
  city: { name: string; slug: string };
  projects: any[];
  total: number;
  totalPages: number;
  filters: SearchFilters;
  rawSearchParams: Record<string, string | string[] | undefined>;
  localityFacets: FacetOption[];
  regionFacets: FacetOption[];
  builderFacets: FacetOption[];
  cityFacets: FacetOption[];
}) {
  const seoContent = generateLandmarkSeoContent(place.name, city.name, place.category, total);
  const pathname = `/flats-near-${place.seoSlug}`;

  const breadcrumb = breadcrumbSchema([
    { name: "Home", url: SITE_URL },
    { name: city.name, url: `${SITE_URL}/${city.slug}-real-estate` },
    { name: `Flats near ${place.name}`, url: `${SITE_URL}${pathname}` },
  ]);

  const itemList = itemListSchema(
    projects.map((p) => ({ name: p.name, url: `${SITE_URL}/projects/${p.city.slug}/${p.slug}` }))
  );

  const landmarkSchema = {
    "@context": "https://schema.org",
    "@type": seoContent.schemaType,
    name: place.name,
    address: place.address || `${place.name}, ${city.name}`,
    ...(place.rating ? { aggregateRating: { "@type": "AggregateRating", ratingValue: String(place.rating), reviewCount: place.reviewCount || 10 } } : {}),
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-8">
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(breadcrumb)} />
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(itemList)} />
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(landmarkSchema)} />

      {/* Breadcrumb */}
      <nav aria-label="Breadcrumb" className="mb-4 flex flex-wrap items-center gap-1.5 text-sm text-muted-foreground">
        <Link href="/" className="transition-colors hover:text-primary">
          Home
        </Link>
        <ChevronRight className="size-3.5 shrink-0 opacity-50" />
        <Link href={`/${city.slug}-real-estate`} className="transition-colors hover:text-primary">
          {city.name}
        </Link>
        <ChevronRight className="size-3.5 shrink-0 opacity-50" />
        <span className="text-foreground">Flats near {place.name}</span>
      </nav>

      {/* Hero Section */}
      <div className="mb-8 bg-card border rounded-2xl p-6 sm:p-8 shadow-xs">
        <div className="flex flex-wrap items-center gap-2 mb-3">
          <Badge variant="secondary" className="capitalize">
            <MapPin className="size-3 mr-1" />
            {place.category.replace(/_/g, " ")}
          </Badge>
          <Badge variant="outline">{city.name}</Badge>
          {place.rating && (
            <Badge variant="secondary" className="bg-amber-50 text-amber-700 border-amber-200">
              <Star className="size-3 fill-amber-500 text-amber-500 mr-1" />
              {String(place.rating)} rating
            </Badge>
          )}
        </div>

        <h1 className="text-3xl font-bold tracking-tight sm:text-4xl text-foreground">
          {seoContent.heading}
        </h1>

        <p className="mt-3 text-sm sm:text-base text-muted-foreground leading-relaxed max-w-3xl">
          {seoContent.intro}
        </p>

        <div className="mt-5 flex flex-wrap gap-4 text-xs sm:text-sm text-muted-foreground pt-4 border-t">
          <span className="flex items-center gap-1.5 font-medium text-foreground">
            <Building2 className="size-4 text-primary" />
            <strong className="text-foreground">{total}</strong> verified projects nearby
          </span>
          {place.address && (
            <span className="flex items-center gap-1">
              Address: <span className="text-foreground font-medium">{place.address}</span>
            </span>
          )}
        </div>
      </div>

      {/* Search Grid */}
      <div className="flex flex-col lg:flex-row gap-8">
        <FilterSidebar
          baseSlug={`flats-near-${place.seoSlug}`}
          localityFacets={localityFacets}
          regionFacets={regionFacets}
          builderFacets={builderFacets}
          cityFacets={cityFacets}
        />

        <div className="flex-1 min-w-0">
          <div className="flex items-center justify-between mb-6 gap-4">
            <p className="text-sm text-muted-foreground shrink-0">
              {total.toLocaleString("en-IN")} results near {place.name}
            </p>
            <SortBar />
          </div>

          {projects.length === 0 ? (
            <div className="flex flex-col items-center rounded-2xl border border-dashed bg-card/50 px-6 py-16 text-center">
              <p className="text-lg font-semibold">No projects match these specific filters</p>
              <p className="mt-1.5 max-w-sm text-sm text-muted-foreground">
                Try widening your distance or clearing filters to see more projects around {place.name}.
              </p>
              <Link
                href={`/flats-near-${place.seoSlug}`}
                className="mt-5 inline-flex h-10 items-center rounded-full bg-primary px-5 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
              >
                Clear filters
              </Link>
            </div>
          ) : (
            <div className="flex flex-col gap-6">
              {projects.map((project) => (
                <ProjectCardWide key={project.id} project={project} />
              ))}
            </div>
          )}

          <Pagination
            pathname={pathname}
            searchParams={rawSearchParams}
            currentPage={filters.page}
            totalPages={totalPages}
          />
        </div>
      </div>
    </div>
  );
}

import Link from "next/link";
import { notFound } from "next/navigation";
import { ChevronRight, SearchX } from "lucide-react";
import { FilterSidebar } from "@/components/search/FilterSidebar";
import { SortBar } from "@/components/search/SortBar";
import { Pagination } from "@/components/search/Pagination";
import { ProjectCardWide } from "@/components/project/ProjectCardWide";
import { Badge } from "@/components/ui/badge";
import { searchProjects } from "@/lib/search/query";
import { parseSearchFilters } from "@/lib/search/types";
import type { ConstructionStatusFilter } from "@/lib/search/types";
import { buildFilterPath } from "@/lib/search/pathFilter";
import { formatPriceINR } from "@/lib/utils/format";
import type { Prisma } from "@/generated/prisma/client";
import { breadcrumbSchema, itemListSchema, jsonLdScript } from "@/lib/seo/schema";
import { SITE_URL } from "@/lib/seo/site";

export async function SearchResultsView({
  citySlug,
  localitySlug,
  regionSlug,
  regionLabel,
  status,
  heading,
  baseSlug,
  activeBhk,
  activeBhkPlus,
  activeBudgetSlug,
  rawSearchParams,
  pathWhere,
  pathFilterLabel,
}: {
  citySlug: string;
  localitySlug?: string;
  regionSlug?: string;
  regionLabel?: string;
  status: ConstructionStatusFilter;
  heading: string;
  baseSlug: string;
  activeBhk?: number;
  activeBhkPlus?: boolean;
  activeBudgetSlug?: string;
  rawSearchParams: Record<string, string | string[] | undefined>;
  pathWhere?: Prisma.ProjectWhereInput;
  pathFilterLabel?: string;
}) {
  const pathname = buildFilterPath(baseSlug, {
    locality: localitySlug,
    region: regionSlug,
    bhk: activeBhk,
    bhkPlus: activeBhkPlus,
    budgetSlug: activeBudgetSlug,
  });
  const filters = parseSearchFilters(rawSearchParams);
  const { projects, total, totalPages, city, locality, region, localityFacets, regionFacets, builderFacets, cityFacets, fallbackProjects } =
    await searchProjects({ citySlug, localitySlug, regionSlug, status, pathWhere }, filters);

  if (!city) notFound();
  if (localitySlug && !locality) notFound();
  if (regionSlug && !region) notFound();

  const locationLabel = locality
    ? `${locality.name}, ${city.name}`
    : region
      ? `${region.name}, ${city.name}`
      : city.name;

  const breadcrumb = breadcrumbSchema([
    { name: "Home", url: SITE_URL },
    { name: city.name, url: `${SITE_URL}/${city.slug}-real-estate` },
    { name: heading, url: `${SITE_URL}${pathname}` },
  ]);
  const itemList = itemListSchema(
    projects.map((p) => ({ name: p.name, url: `${SITE_URL}/projects/${p.city.slug}/${p.slug}` }))
  );

  const activeBuilderNames = builderFacets.filter((b) => filters.builderSlugs.includes(b.slug)).map((b) => b.name);

  return (
    <div className="mx-auto max-w-7xl px-4 py-8">
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(breadcrumb)} />
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(itemList)} />

      {/* Visible breadcrumb mirrors the BreadcrumbList JSON-LD above it. */}
      <nav aria-label="Breadcrumb" className="mb-4 flex flex-wrap items-center gap-1.5 text-sm text-muted-foreground">
        <Link href="/" className="transition-colors hover:text-primary">
          Home
        </Link>
        <ChevronRight className="size-3.5 shrink-0 opacity-50" />
        <Link href={`/${city.slug}-real-estate`} className="transition-colors hover:text-primary">
          {city.name}
        </Link>
        <ChevronRight className="size-3.5 shrink-0 opacity-50" />
        <span className="text-foreground">{heading}</span>
      </nav>

      <div className="mb-8">
        <h1 className="text-3xl font-semibold leading-[1.15] tracking-tight sm:text-4xl">
          {heading}
          {pathFilterLabel ? ` — ${pathFilterLabel}` : ""} in {locationLabel}
        </h1>
        <p className="mt-2.5 text-sm text-muted-foreground">
          <span className="nums font-semibold text-foreground">{total.toLocaleString("en-IN")}</span>{" "}
          {total === 1 ? "project" : "projects"} matching your search
        </p>
        <div className="flex flex-wrap gap-2 mt-4">
          {regionLabel && <Badge variant="secondary">{regionLabel} region</Badge>}
          {filters.reraOnly && <Badge variant="secondary">RERA Verified</Badge>}
          {filters.possessionRange && <Badge variant="secondary">Possession {filters.possessionRange}</Badge>}
          {(filters.priceMin !== null || filters.priceMax !== null) && (
            <Badge variant="secondary">
              {filters.priceMin !== null ? formatPriceINR(filters.priceMin) : "₹0"} –{" "}
              {filters.priceMax !== null ? formatPriceINR(filters.priceMax) : "Any"}
            </Badge>
          )}
          {(filters.areaMin !== null || filters.areaMax !== null) && (
            <Badge variant="secondary">
              {filters.areaMin ?? 0} – {filters.areaMax ?? "4000+"} sq.ft
            </Badge>
          )}
          {activeBuilderNames.map((name) => (
            <Badge key={name} variant="secondary">
              {name}
            </Badge>
          ))}
        </div>
      </div>

      <div className="flex flex-col lg:flex-row gap-8">
        <FilterSidebar
          baseSlug={baseSlug}
          activeLocality={localitySlug}
          activeRegion={regionSlug}
          activeBhk={activeBhk}
          activeBhkPlus={activeBhkPlus}
          activeBudgetSlug={activeBudgetSlug}
          localityFacets={localityFacets}
          regionFacets={regionFacets}
          builderFacets={builderFacets}
          cityFacets={cityFacets}
        />

        <div className="flex-1 min-w-0">
          <div className="flex items-center justify-between mb-6 gap-4">
            <p className="text-sm text-muted-foreground shrink-0">
              {total.toLocaleString("en-IN")} results
            </p>
            <SortBar />
          </div>

          {projects.length === 0 ? (
            <div className="space-y-8">
              <div className="flex flex-col items-center rounded-2xl border border-dashed bg-card/50 px-6 py-16 text-center">
                <span className="mb-4 flex size-14 items-center justify-center rounded-2xl bg-muted text-muted-foreground">
                  <SearchX className="size-7" />
                </span>
                <p className="text-lg font-semibold">No projects match these specific filters</p>
                <p className="mt-1.5 max-w-sm text-sm text-muted-foreground">
                  Try widening your budget or clearing a filter — there are {city.name} projects waiting just outside
                  this range.
                </p>
                <Link
                  href={`/${baseSlug}`}
                  className="mt-5 inline-flex h-10 items-center rounded-full bg-primary px-5 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
                >
                  Clear all filters
                </Link>
              </div>

              {fallbackProjects && fallbackProjects.length > 0 && (
                <div>
                  <h2 className="text-xl font-semibold mb-4">Popular projects in {city.name} you might like</h2>
                  <div className="flex flex-col gap-6">
                    {fallbackProjects.map((project) => (
                      <ProjectCardWide key={project.id} project={project} />
                    ))}
                  </div>
                </div>
              )}
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

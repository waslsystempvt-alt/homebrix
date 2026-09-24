import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { SearchResultsView } from "@/components/search/SearchResultsView";
import { LocalityLandingView } from "@/components/city/LocalityLandingView";
import { getCityBySlug, getLocalityBySlug, getLocalityLandingData, getRegionBySlug } from "@/lib/db/queries";
import { parseLocalityRealEstateSlug, parseSearchSlug } from "@/lib/search/slugParser";
import { buildFilterPath, parsePathFilterSegment } from "@/lib/search/pathFilter";
import { shouldNoIndexSearchPage } from "@/lib/seo/robots";
import { SITE_URL } from "@/lib/seo/site";
import type { Prisma } from "@/generated/prisma/client";

interface ResolvedFilters {
  city: Awaited<ReturnType<typeof getCityBySlug>>;
  locality: Awaited<ReturnType<typeof getLocalityBySlug>>;
  region: Awaited<ReturnType<typeof getRegionBySlug>>;
  localitySlug?: string;
  regionSlug?: string;
  bhk?: number;
  bhkPlus?: boolean;
  bhkLabel?: string;
  budgetSlug?: string;
  budgetLabel?: string;
  pathWhere?: Prisma.ProjectWhereInput;
  malformed: boolean;
}

/**
 * A search-hub URL can combine at most one geo segment (a specific locality
 * OR a broader region — not both), one BHK, and one budget segment. The geo
 * segment is ambiguous from the string alone, so it's resolved against the
 * DB: region slugs are checked first (they're the coarser, less common pick),
 * falling back to a locality lookup.
 */
async function resolveFilterSegments(citySlug: string, segments: string[]): Promise<ResolvedFilters> {
  let geoSlug: string | undefined;
  let bhk: number | undefined;
  let bhkPlus: boolean | undefined;
  let bhkLabel: string | undefined;
  let budgetSlug: string | undefined;
  let budgetLabel: string | undefined;
  let malformed = false;
  const wheres: Prisma.ProjectWhereInput[] = [];

  for (const segment of segments) {
    const parsed = parsePathFilterSegment(segment);
    if (parsed.kind === "bhk") {
      if (bhk !== undefined) malformed = true;
      bhk = parsed.bhk;
      bhkPlus = parsed.plus;
      bhkLabel = parsed.label;
      wheres.push(parsed.plus ? { bhkTypes: { hasSome: [4, 5, 6, 7, 8, 9, 10] } } : { bhkTypes: { has: parsed.bhk } });
    } else if (parsed.kind === "budget") {
      if (budgetSlug !== undefined) malformed = true;
      budgetSlug = parsed.slug;
      budgetLabel = parsed.label;
      const priceWhere: Prisma.ProjectWhereInput = {};
      if (parsed.min !== undefined) priceWhere.priceMin = { gte: parsed.min };
      if (parsed.max !== undefined) priceWhere.priceMax = { lte: parsed.max };
      wheres.push(priceWhere);
    } else {
      if (geoSlug !== undefined) malformed = true;
      geoSlug = parsed.slug;
    }
  }

  const city = await getCityBySlug(citySlug);

  let locality: Awaited<ReturnType<typeof getLocalityBySlug>> = null;
  let region: Awaited<ReturnType<typeof getRegionBySlug>> = null;
  let localitySlug: string | undefined;
  let regionSlug: string | undefined;

  if (geoSlug) {
    region = await getRegionBySlug(citySlug, geoSlug);
    if (region) {
      regionSlug = geoSlug;
    } else {
      locality = await getLocalityBySlug(citySlug, geoSlug);
      localitySlug = geoSlug;
    }
  }

  return {
    city,
    locality,
    region,
    localitySlug,
    regionSlug,
    bhk,
    bhkPlus,
    bhkLabel,
    budgetSlug,
    budgetLabel,
    pathWhere: wheres.length > 0 ? { AND: wheres } : undefined,
    malformed,
  };
}

export async function generateMetadata({
  params,
  searchParams,
}: {
  params: Promise<{ slug: string; filters: string[] }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}): Promise<Metadata> {
  const { slug, filters } = await params;
  const sp = await searchParams;

  const parsedSlug = parseSearchSlug(slug);
  if (parsedSlug) {
    const resolved = await resolveFilterSegments(parsedSlug.citySlug, filters);
    if (!resolved.city || resolved.malformed) return {};
    if (resolved.localitySlug && !resolved.locality) return {};
    if (resolved.regionSlug && !resolved.region) return {};

    const cityName = resolved.city.name;
    const labelParts = [
      resolved.locality?.name ?? resolved.region?.name,
      resolved.bhkLabel,
      resolved.budgetLabel,
    ].filter((p): p is string => Boolean(p));
    const suffix = labelParts.length > 0 ? `${labelParts.join(" ")} in ${cityName}` : cityName;
    const canonicalPath = buildFilterPath(slug, {
      locality: resolved.localitySlug,
      region: resolved.regionSlug,
      bhk: resolved.bhk,
      bhkPlus: resolved.bhkPlus,
      budgetSlug: resolved.budgetSlug,
    });

    return {
      title: `${parsedSlug.heading} — ${suffix} | Homebrix`,
      description: `Browse ${parsedSlug.heading.toLowerCase()} — ${suffix}. RERA verified, zero brokerage.`,
      alternates: { canonical: `${SITE_URL}${canonicalPath}` },
      robots: shouldNoIndexSearchPage(sp) ? { index: false, follow: true } : undefined,
    };
  }

  if (filters.length === 1) {
    const localitySlug = parseLocalityRealEstateSlug(filters[0]);
    if (localitySlug) {
      const [city, locality] = await Promise.all([getCityBySlug(slug), getLocalityBySlug(slug, localitySlug)]);
      const label = locality && city ? `${locality.name}, ${city.name}` : slug;
      return {
        title: `${label} Real Estate – New Projects, Price Trends | Homebrix`,
        description: `Explore new builder projects and price trends in ${label}.`,
        alternates: { canonical: `${SITE_URL}/${slug}/${filters[0]}` },
      };
    }
  }

  return {};
}

export default async function SearchHubFiltersPage({
  params,
  searchParams,
}: {
  params: Promise<{ slug: string; filters: string[] }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const { slug, filters } = await params;
  const sp = await searchParams;

  const parsedSlug = parseSearchSlug(slug);
  if (parsedSlug) {
    const resolved = await resolveFilterSegments(parsedSlug.citySlug, filters);
    if (!resolved.city || resolved.malformed) notFound();
    if (resolved.localitySlug && !resolved.locality) notFound();
    if (resolved.regionSlug && !resolved.region) notFound();

    const pathFilterLabel = [resolved.bhkLabel, resolved.budgetLabel].filter(Boolean).join(" · ") || undefined;

    return (
      <SearchResultsView
        citySlug={parsedSlug.citySlug}
        localitySlug={resolved.localitySlug}
        regionSlug={resolved.regionSlug}
        regionLabel={resolved.region?.name}
        status={parsedSlug.status}
        heading={parsedSlug.heading}
        baseSlug={slug}
        activeBhk={resolved.bhk}
        activeBhkPlus={resolved.bhkPlus}
        activeBudgetSlug={resolved.budgetSlug}
        rawSearchParams={sp}
        pathWhere={resolved.pathWhere}
        pathFilterLabel={pathFilterLabel}
      />
    );
  }

  if (filters.length === 1) {
    const localitySlug = parseLocalityRealEstateSlug(filters[0]);
    if (localitySlug) {
      const data = await getLocalityLandingData(slug, localitySlug);
      if (!data) notFound();
      return <LocalityLandingView data={data} />;
    }
  }

  notFound();
}

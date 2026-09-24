import type { ConstructionStatusFilter } from "@/lib/search/types";

const PREFIXES: { prefix: string; status: ConstructionStatusFilter; heading: string }[] = [
  { prefix: "new-projects-in-", status: null, heading: "New Projects" },
  { prefix: "under-construction-in-", status: "under_construction", heading: "Under Construction Projects" },
  { prefix: "new-launch-in-", status: "new_launch", heading: "New Launch Projects" },
  { prefix: "ready-to-move-in-", status: "ready_to_move", heading: "Ready to Move Projects" },
];

export interface ParsedSearchSlug {
  status: ConstructionStatusFilter;
  heading: string;
  citySlug: string;
  prefix: string;
}

/**
 * Parses SEO search-hub slugs like "new-projects-in-mumbai" or
 * "under-construction-in-navi-mumbai" into a status + city slug.
 * Folder names can't mix literal text with a dynamic segment in the
 * App Router, so this prefix parsing happens at request time instead.
 */
export function parseSearchSlug(slug: string): ParsedSearchSlug | null {
  for (const { prefix, status, heading } of PREFIXES) {
    if (slug.startsWith(prefix) && slug.length > prefix.length) {
      return { status, heading, citySlug: slug.slice(prefix.length), prefix };
    }
  }
  return null;
}

export const SEARCH_HUB_PREFIXES = PREFIXES;

/** Swaps the status prefix on a search-hub slug, e.g. "new-projects-in-mumbai" -> "ready-to-move-in-mumbai". */
export function withSearchPrefix(citySlug: string, prefix: string): string {
  return `${prefix}${citySlug}`;
}

const BUILDERS_IN_PREFIX = "builders-in-";
const PROPERTY_RATES_PREFIX = "property-rates-in-";
const REAL_ESTATE_SUFFIX = "-real-estate";

/** Matches "builders-in-{city}" -> the city slug. */
export function parseBuildersInSlug(slug: string): string | null {
  if (slug.startsWith(BUILDERS_IN_PREFIX) && slug.length > BUILDERS_IN_PREFIX.length) {
    return slug.slice(BUILDERS_IN_PREFIX.length);
  }
  return null;
}

/**
 * Matches "property-rates-in-{city}" -> the city slug. This is a distinct
 * namespace from the search hubs: price-intent queries ("2bhk flat price in
 * mumbai") want a rate table and trend chart, not a listing grid, so they
 * never fall through to parseSearchSlug.
 */
export function parsePropertyRatesSlug(slug: string): string | null {
  if (slug.startsWith(PROPERTY_RATES_PREFIX) && slug.length > PROPERTY_RATES_PREFIX.length) {
    return slug.slice(PROPERTY_RATES_PREFIX.length);
  }
  return null;
}

/** Matches "{city}-real-estate" -> the city slug. */
export function parseCityRealEstateSlug(slug: string): string | null {
  if (slug.endsWith(REAL_ESTATE_SUFFIX) && slug.length > REAL_ESTATE_SUFFIX.length) {
    return slug.slice(0, -REAL_ESTATE_SUFFIX.length);
  }
  return null;
}

/** Matches "{locality}-real-estate" -> the locality slug (used as the 2nd path segment under a city). */
export function parseLocalityRealEstateSlug(segment: string): string | null {
  return parseCityRealEstateSlug(segment);
}

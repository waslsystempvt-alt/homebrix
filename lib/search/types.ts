export type ConstructionStatusFilter = "new_launch" | "under_construction" | "ready_to_move" | null;

export type SortOption = "relevance" | "price_asc" | "price_desc" | "newest" | "possession";

export const PRICE_RANGE_MIN = 0;
export const PRICE_RANGE_MAX = BigInt(20_00_00_000); // ₹20 Cr ceiling; UI shows "20 Cr+" at max
export const AREA_RANGE_MIN = 100;
export const AREA_RANGE_MAX = 4000; // sqft ceiling; UI shows "4000+ sq.ft" at max

/**
 * Refinements that stay as query params rather than path segments.
 * Unlike BHK/budget/locality, these don't have meaningful standalone search
 * volume, so they're intentionally kept out of the indexable URL surface
 * (see lib/seo/robots.ts) instead of being given their own SEO paths.
 */
export interface SearchFilters {
  possessionRange: string | null;
  launchStage: string | null;
  nearPlace: string | null;
  withinKm: number | null;
  reraOnly: boolean;
  priceMin: bigint | null;
  priceMax: bigint | null;
  areaMin: number | null;
  areaMax: number | null;
  builderSlugs: string[];
  sort: SortOption;
  page: number;
}

export const PAGE_SIZE = 12;

const VALID_LAUNCH_STAGES = [
  "pre_launch",
  "newly_launched",
  "under_construction",
  "nearing_possession",
  "possession_started",
  "completed",
];

function parseBigIntParam(value: string | string[] | undefined): bigint | null {
  if (typeof value !== "string") return null;
  const n = Number(value);
  if (!Number.isFinite(n) || n <= 0) return null;
  return BigInt(Math.round(n));
}

function parseIntParam(value: string | string[] | undefined): number | null {
  if (typeof value !== "string") return null;
  const n = parseInt(value, 10);
  return Number.isFinite(n) ? n : null;
}

function parseFloatParam(value: string | string[] | undefined): number | null {
  if (typeof value !== "string") return null;
  const n = parseFloat(value);
  return Number.isFinite(n) && n > 0 ? n : null;
}

/**
 * Builder is a comma-joined single query param (?builder=lodha-group,brigade-group)
 * rather than repeated params (?builder=a&builder=b) — same info, but a much
 * shorter, less alarming-looking URL. Still accepts a legacy repeated-param
 * array so any previously shared/bookmarked links keep working.
 */
export function parseBuilderSlugsParam(value: string | string[] | null | undefined): string[] {
  if (!value) return [];
  const joined = Array.isArray(value) ? value.join(",") : value;
  return joined
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
}

export function parseSearchFilters(searchParams: Record<string, string | string[] | undefined>): SearchFilters {
  const sort: SortOption = ["relevance", "price_asc", "price_desc", "newest", "possession"].includes(
    searchParams.sort as string
  )
    ? (searchParams.sort as SortOption)
    : "relevance";

  const page = typeof searchParams.page === "string" ? Math.max(1, parseInt(searchParams.page, 10) || 1) : 1;

  const builderSlugs = parseBuilderSlugsParam(searchParams.builder);

  const rawStage = typeof searchParams.launchStage === "string" ? searchParams.launchStage : null;
  const launchStage = rawStage && VALID_LAUNCH_STAGES.includes(rawStage) ? rawStage : null;

  return {
    possessionRange: typeof searchParams.possession === "string" ? searchParams.possession : null,
    launchStage,
    nearPlace: typeof searchParams.near === "string" ? searchParams.near : null,
    withinKm: parseFloatParam(searchParams.withinKm),
    reraOnly: searchParams.rera === "true",
    priceMin: parseBigIntParam(searchParams.priceMin),
    priceMax: parseBigIntParam(searchParams.priceMax),
    areaMin: parseIntParam(searchParams.areaMin),
    areaMax: parseIntParam(searchParams.areaMax),
    builderSlugs,
    sort,
    page,
  };
}

export function hasNonIndexableParams(filters: SearchFilters): boolean {
  return (
    filters.possessionRange !== null ||
    filters.launchStage !== null ||
    filters.nearPlace !== null ||
    filters.withinKm !== null ||
    filters.reraOnly ||
    filters.priceMin !== null ||
    filters.priceMax !== null ||
    filters.areaMin !== null ||
    filters.areaMax !== null ||
    filters.builderSlugs.length > 0 ||
    filters.sort !== "relevance"
  );
}

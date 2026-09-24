import { findBudgetBand } from "@/lib/search/budgetBands";

export type PathFilterKind =
  | { kind: "bhk"; bhk: number; plus?: boolean; label: string }
  | { kind: "budget"; slug: string; min?: bigint; max?: bigint; label: string }
  | { kind: "locality"; slug: string };

const BHK_PLUS_SLUG = "4-bhk-and-above";
const STUDIO_SLUG = "studio";

export function parsePathFilterSegment(segment: string): PathFilterKind {
  if (segment === STUDIO_SLUG) {
    return { kind: "bhk", bhk: 0, label: "1 RK / Studio" };
  }

  if (segment === BHK_PLUS_SLUG) {
    return { kind: "bhk", bhk: 5, plus: true, label: "4+ BHK" };
  }

  const bhkMatch = segment.match(/^(\d)-bhk$/);
  if (bhkMatch) {
    const bhk = parseInt(bhkMatch[1], 10);
    return { kind: "bhk", bhk, label: `${bhk} BHK` };
  }

  const budget = findBudgetBand(segment);
  if (budget) {
    return { kind: "budget", slug: budget.slug, min: budget.min, max: budget.max, label: budget.label };
  }

  return { kind: "locality", slug: segment };
}

function bhkToSegment(bhk: number, plus?: boolean): string {
  if (bhk === 0) return STUDIO_SLUG;
  if (plus) return BHK_PLUS_SLUG;
  return `${bhk}-bhk`;
}

/**
 * Combines parsed filter dimensions into a single canonical path, in a fixed
 * order (locality/region, then BHK, then budget) so every combination of
 * filters has exactly one indexable URL — regardless of the order segments
 * were requested in. `locality` and `region` are mutually exclusive — a URL
 * carries the specific area or the broader belt, not both.
 */
export function buildFilterPath(
  baseSlug: string,
  filters: { locality?: string; region?: string; bhk?: number; bhkPlus?: boolean; budgetSlug?: string }
): string {
  const segments = [
    filters.locality ?? filters.region,
    filters.bhk !== undefined ? bhkToSegment(filters.bhk, filters.bhkPlus) : undefined,
    filters.budgetSlug,
  ].filter((s): s is string => Boolean(s));
  return segments.length > 0 ? `/${baseSlug}/${segments.join("/")}` : `/${baseSlug}`;
}

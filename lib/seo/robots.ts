import { parseSearchFilters, hasNonIndexableParams } from "@/lib/search/types";

/**
 * BHK, budget, and locality are expressed as path segments and are always
 * indexable. Possession year, RERA-only, and non-default sort don't have
 * their own landing page, so any page carrying them — or paginated past a
 * shallow depth — is marked noindex to avoid diluting crawl budget with
 * near-duplicate content.
 */
export function shouldNoIndexSearchPage(searchParams: Record<string, string | string[] | undefined>): boolean {
  const filters = parseSearchFilters(searchParams);
  if (hasNonIndexableParams(filters)) return true;
  return filters.page > 3;
}

import { BUDGET_BANDS } from "@/lib/search/budgetBands";
import { buildFilterPath } from "@/lib/search/pathFilter";
import { SEARCH_HUB_PREFIXES, withSearchPrefix } from "@/lib/search/slugParser";

export interface CityRef {
  name: string;
  slug: string;
}

export interface LocalityRef {
  name: string;
  slug: string;
  citySlug: string;
}

export interface PlaceRef {
  name: string;
  slug: string;
  seoSlug: string;
}

export interface ParsedQueryResult {
  path: string;
  matched: {
    city?: string;
    locality?: string;
    landmark?: string;
    bhk?: string;
    budget?: string;
    status?: string;
  };
}

const STATUS_KEYWORDS: { pattern: RegExp; prefix: string; label: string }[] = [
  { pattern: /\bnew\s*launch\b/i, prefix: "new-launch-in-", label: "New Launch" },
  { pattern: /\bunder[\s-]*construction\b/i, prefix: "under-construction-in-", label: "Under Construction" },
  { pattern: /\bready\s*to\s*move\b/i, prefix: "ready-to-move-in-", label: "Ready to Move" },
];

const CR = 1_00_00_000;
const L = 1_00_000;

function findBhk(query: string): { bhk?: number; plus?: boolean; label?: string } {
  if (/\b(studio|1\s*rk)\b/i.test(query)) return { bhk: 0, label: "1 RK / Studio" };

  const plusMatch = query.match(/\b(\d)\s*\+\s*(?:bhk|bed(?:room)?s?)\b/i);
  if (plusMatch) return { bhk: 5, plus: true, label: `${plusMatch[1]}+ BHK` };

  const exactMatch = query.match(/\b(\d)\s*(?:bhk|bed(?:room)?s?)\b/i);
  if (exactMatch) {
    const n = parseInt(exactMatch[1], 10);
    if (n >= 4) return { bhk: n === 4 ? 4 : 5, plus: n > 4, label: `${n} BHK` };
    return { bhk: n, label: `${n} BHK` };
  }

  return {};
}

function findBudget(query: string): { slug?: string; label?: string } {
  const amounts: number[] = [];
  const re = /(\d+(?:\.\d+)?)\s*(lakhs?|lacs?|l\b|crores?|cr\b)/gi;
  let match: RegExpExecArray | null;
  while ((match = re.exec(query)) !== null) {
    const value = parseFloat(match[1]);
    const unit = match[2].toLowerCase();
    const isCrore = unit.startsWith("cr");
    amounts.push(isCrore ? value * CR : value * L);
  }

  if (amounts.length === 0) return {};

  const target = Math.max(...amounts);
  const band =
    BUDGET_BANDS.find((b) => b.max !== undefined && target <= Number(b.max)) ??
    BUDGET_BANDS[BUDGET_BANDS.length - 1];

  return { slug: band.slug, label: band.label };
}

function findStatus(query: string): { prefix?: string; label?: string } {
  for (const s of STATUS_KEYWORDS) {
    if (s.pattern.test(query)) return { prefix: s.prefix, label: s.label };
  }
  return {};
}

function findLongestMatch<T extends { name: string }>(query: string, items: T[]): T | undefined {
  const lowerQuery = query.toLowerCase();
  const candidates = items
    .filter((item) => lowerQuery.includes(item.name.toLowerCase()))
    .sort((a, b) => b.name.length - a.name.length);
  return candidates[0];
}

/**
 * Parses natural language search queries and routes to canonical SEO URLs.
 * Detects BHK, budget, status, city, locality, AND places/landmarks.
 */
export function parseNaturalLanguageQuery(
  query: string,
  cities: CityRef[],
  localities: LocalityRef[],
  places: PlaceRef[] = []
): ParsedQueryResult | { error: string } {
  const trimmed = query.trim();
  if (!trimmed) return { error: "Type what you're looking for first." };

  const landmark = findLongestMatch(trimmed, places);
  if (landmark) {
    const { bhk, plus } = findBhk(trimmed);
    const basePath = `/flats-near-${landmark.seoSlug}`;
    const params = new URLSearchParams();
    if (bhk !== undefined) params.set("bhk", String(bhk));
    const path = params.toString() ? `${basePath}?${params.toString()}` : basePath;
    return {
      path,
      matched: {
        landmark: landmark.name,
        bhk: bhk !== undefined ? `${bhk} BHK` : undefined,
      },
    };
  }

  const city = findLongestMatch(trimmed, cities);
  if (!city) {
    return { error: "Mention a city or landmark — e.g. Mumbai, Thane, or Jupiter Hospital." };
  }

  const cityLocalities = localities.filter((l) => l.citySlug === city.slug);
  const locality = findLongestMatch(trimmed, cityLocalities);

  const { bhk, plus, label: bhkLabel } = findBhk(trimmed);
  const { slug: budgetSlug, label: budgetLabel } = findBudget(trimmed);
  const { prefix, label: statusLabel } = findStatus(trimmed);

  const searchPrefix = prefix ?? SEARCH_HUB_PREFIXES[0].prefix;
  const baseSlug = withSearchPrefix(city.slug, searchPrefix);
  const path = buildFilterPath(baseSlug, {
    locality: locality?.slug,
    bhk,
    bhkPlus: plus,
    budgetSlug,
  });

  return {
    path,
    matched: {
      city: city.name,
      locality: locality?.name,
      bhk: bhkLabel,
      budget: budgetLabel,
      status: statusLabel,
    },
  };
}

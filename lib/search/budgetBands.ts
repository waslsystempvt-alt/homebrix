const L = BigInt(1_00_000);
const CR = BigInt(1_00_00_000);

export interface BudgetBand {
  slug: string;
  label: string;
  min?: bigint;
  max?: bigint;
}

/**
 * Canonical budget bands — used both as clickable sidebar filters and as
 * SEO path segments (e.g. /new-projects-in-mumbai/under-50-lakhs). Keeping
 * a single source of truth means every UI-selectable budget maps to a
 * real, indexable URL instead of a query string.
 */
export const BUDGET_BANDS: BudgetBand[] = [
  { slug: "under-50-lakhs", label: "Under ₹50 Lakhs", max: BigInt(50) * L },
  { slug: "50-lakhs-to-1-crore", label: "₹50 Lakhs – ₹1 Crore", min: BigInt(50) * L, max: BigInt(1) * CR },
  { slug: "1-crore-to-2-crore", label: "₹1 Crore – ₹2 Crore", min: BigInt(1) * CR, max: BigInt(2) * CR },
  { slug: "above-2-crore", label: "Above ₹2 Crore", min: BigInt(2) * CR },
];

/** Extra budget slugs that resolve correctly but aren't shown as sidebar chips (avoids overlapping options). */
export const EXTRA_BUDGET_SLUGS: BudgetBand[] = [{ slug: "luxury", label: "Luxury", min: BigInt(3) * CR }];

export function findBudgetBand(slug: string): BudgetBand | undefined {
  return [...BUDGET_BANDS, ...EXTRA_BUDGET_SLUGS].find((b) => b.slug === slug);
}

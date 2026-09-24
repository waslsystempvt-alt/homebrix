export function slugifyCategory(category: string): string {
  return category
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
}

export async function resolveCategorySlug(
  slug: string,
  categories: string[]
): Promise<string | null> {
  return categories.find((c) => slugifyCategory(c) === slug) ?? null;
}

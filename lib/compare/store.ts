export interface CompareItem {
  id: string;
  name: string;
  slug: string;
  citySlug: string;
  cityName: string;
  builderName: string;
  priceMin: string | null;
  priceMax: string | null;
  areaMinSqft: number | null;
  areaMaxSqft: number | null;
  possessionDate: string | null;
  reraVerified: boolean;
  builderVerified: boolean;
  constructionStatus: string;
}

const STORAGE_KEY = "propvista:compare";
export const MAX_COMPARE = 4;
export const COMPARE_CHANGED_EVENT = "propvista:compare-changed";

export function getCompareList(): CompareItem[] {
  if (typeof window === "undefined") return [];
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    return raw ? (JSON.parse(raw) as CompareItem[]) : [];
  } catch {
    return [];
  }
}

function persist(items: CompareItem[]) {
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  window.dispatchEvent(new Event(COMPARE_CHANGED_EVENT));
}

export function isInCompare(id: string): boolean {
  return getCompareList().some((item) => item.id === id);
}

export function toggleCompare(item: CompareItem): CompareItem[] {
  const list = getCompareList();
  const exists = list.some((i) => i.id === item.id);
  const next = exists
    ? list.filter((i) => i.id !== item.id)
    : list.length < MAX_COMPARE
      ? [...list, item]
      : list;
  persist(next);
  return next;
}

export function removeFromCompare(id: string): CompareItem[] {
  const next = getCompareList().filter((i) => i.id !== id);
  persist(next);
  return next;
}

export function clearCompare() {
  persist([]);
}

export const POSSESSION_RANGES = ["2026-2027", "2027-2028", "2028-2029", "2029-2030", "2030-2031"];

export function parsePossessionRange(value: string): { start: number; end: number } | null {
  const match = value.match(/^(\d{4})-(\d{4})$/);
  if (!match) return null;
  const start = parseInt(match[1], 10);
  const end = parseInt(match[2], 10);
  if (end !== start + 1) return null;
  return { start, end };
}

import { Hammer, Home, Sparkles, type LucideIcon } from "lucide-react";

export function formatPriceINR(value: number | bigint | null | undefined): string {
  if (value === null || value === undefined) return "Price on Request";
  const n = typeof value === "bigint" ? Number(value) : value;
  const sign = n < 0 ? "-" : "";
  const abs = Math.abs(n);
  if (abs >= 1_00_00_000) return `${sign}₹${(abs / 1_00_00_000).toFixed(abs % 1_00_00_000 === 0 ? 0 : 2)} Cr`;
  if (abs >= 1_00_000) return `${sign}₹${(abs / 1_00_000).toFixed(abs % 1_00_000 === 0 ? 0 : 1)} L`;
  return `${sign}₹${abs.toLocaleString("en-IN")}`;
}

/** Full, unabbreviated Indian-grouped rupee amount, e.g. 5000000 -> "₹50,00,000". */
export function formatFullINR(value: number | bigint): string {
  const n = typeof value === "bigint" ? Number(value) : value;
  return `₹${Math.round(n).toLocaleString("en-IN")}`;
}

const ONES = [
  "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
  "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen",
];
const TENS = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];

function twoDigitsToWords(n: number): string {
  if (n < 20) return ONES[n];
  const tens = Math.floor(n / 10);
  const ones = n % 10;
  return ones ? `${TENS[tens]}-${ONES[ones]}` : TENS[tens];
}

function threeDigitsToWords(n: number): string {
  const hundred = Math.floor(n / 100);
  const rest = n % 100;
  const parts: string[] = [];
  if (hundred) parts.push(`${ONES[hundred]} Hundred`);
  if (rest) parts.push(twoDigitsToWords(rest));
  return parts.join(" ");
}

/** Converts a rupee amount into Indian numbering words, e.g. 5000000 -> "Fifty Lakhs". */
export function formatIndianAmountInWords(value: number): string {
  const rounded = Math.round(value);
  if (rounded === 0) return "Zero";

  const crore = Math.floor(rounded / 1_00_00_000);
  const lakh = Math.floor((rounded % 1_00_00_000) / 1_00_000);
  const thousand = Math.floor((rounded % 1_00_000) / 1000);
  const hundred = rounded % 1000;

  const parts: string[] = [];
  if (crore) parts.push(`${twoDigitsToWords(crore)} Crore${crore > 1 ? "s" : ""}`);
  if (lakh) parts.push(`${twoDigitsToWords(lakh)} Lakh${lakh > 1 ? "s" : ""}`);
  if (thousand) parts.push(`${twoDigitsToWords(thousand)} Thousand`);
  if (hundred) parts.push(threeDigitsToWords(hundred));

  return parts.join(" ") || "Zero";
}

export function formatPriceRange(
  min: number | bigint | null | undefined,
  max: number | bigint | null | undefined
): string {
  if (!min && !max) return "Price on Request";
  if (!max || min === max) return formatPriceINR(min);
  return `${formatPriceINR(min)} – ${formatPriceINR(max)}`;
}

export function formatArea(min: number | null, max: number | null): string {
  if (!min && !max) return "";
  if (!max || min === max) return `${min ?? max} sqft`;
  return `${min}–${max} sqft`;
}

export function formatPossession(date: Date | null): string {
  if (!date) return "TBD";
  return date.toLocaleDateString("en-IN", { month: "short", year: "numeric" });
}

export const STATUS_LABELS: Record<string, string> = {
  new_launch: "New Launch",
  under_construction: "Under Construction",
  ready_to_move: "Ready to Move",
};

/** Color-codes construction status consistently everywhere it's shown as a badge. */
export const STATUS_BADGE_VARIANT: Record<string, "warning" | "info" | "success"> = {
  new_launch: "warning",
  under_construction: "info",
  ready_to_move: "success",
};

export const STATUS_ICONS: Record<string, LucideIcon> = {
  new_launch: Sparkles,
  under_construction: Hammer,
  ready_to_move: Home,
};

export const STATUS_PILL_CLASS: Record<string, string> = {
  new_launch: "bg-warning text-warning-foreground",
  under_construction: "bg-info text-info-foreground",
  ready_to_move: "bg-success text-success-foreground",
};

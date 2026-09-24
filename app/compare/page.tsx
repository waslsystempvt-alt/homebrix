"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { X } from "lucide-react";
import { COMPARE_CHANGED_EVENT, getCompareList, removeFromCompare, type CompareItem } from "@/lib/compare/store";
import { formatArea, formatPossession, formatPriceRange, STATUS_LABELS } from "@/lib/utils/format";

const ROWS: { label: string; render: (item: CompareItem) => React.ReactNode }[] = [
  { label: "Price", render: (i) => formatPriceRange(i.priceMin ? BigInt(i.priceMin) : null, i.priceMax ? BigInt(i.priceMax) : null) },
  { label: "Area", render: (i) => formatArea(i.areaMinSqft, i.areaMaxSqft) || "—" },
  { label: "Possession", render: (i) => formatPossession(i.possessionDate ? new Date(i.possessionDate) : null) },
  { label: "Status", render: (i) => STATUS_LABELS[i.constructionStatus] ?? i.constructionStatus },
  { label: "Builder", render: (i) => `${i.builderName}${i.builderVerified ? " ✓" : ""}` },
  { label: "RERA", render: (i) => (i.reraVerified ? "Verified ✓" : "—") },
  { label: "Location", render: (i) => i.cityName },
];

export default function ComparePage() {
  const [items, setItems] = useState<CompareItem[]>([]);

  useEffect(() => {
    const sync = () => setItems(getCompareList());
    sync();
    window.addEventListener(COMPARE_CHANGED_EVENT, sync);
    window.addEventListener("storage", sync);
    return () => {
      window.removeEventListener(COMPARE_CHANGED_EVENT, sync);
      window.removeEventListener("storage", sync);
    };
  }, []);

  const waMessage = `Hi, I'm interested in: ${items.map((i) => i.name).join(", ")}`;

  return (
    <div className="mx-auto max-w-5xl px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">Compare Projects</h1>

      {items.length === 0 ? (
        <div className="text-center py-16 text-muted-foreground">
          <p>No projects selected for comparison.</p>
          <Button className="mt-4" asChild>
            <Link href="/">Browse Projects</Link>
          </Button>
        </div>
      ) : (
        <>
          <div className="overflow-x-auto rounded-lg border">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b bg-muted/50">
                  <th className="text-left p-3 font-medium w-32">Project</th>
                  {items.map((item) => (
                    <th key={item.id} className="text-left p-3 font-medium min-w-48">
                      <div className="flex items-start justify-between gap-2">
                        <Link href={`/projects/${item.citySlug}/${item.slug}`} className="hover:underline">
                          {item.name}
                        </Link>
                        <button onClick={() => removeFromCompare(item.id)} aria-label={`Remove ${item.name}`}>
                          <X className="size-4 text-muted-foreground hover:text-foreground" />
                        </button>
                      </div>
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {ROWS.map((row) => (
                  <tr key={row.label} className="border-b">
                    <td className="p-3 font-medium text-muted-foreground">{row.label}</td>
                    {items.map((item) => (
                      <td key={item.id} className="p-3">
                        {row.render(item)}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <Button className="mt-6 w-full sm:w-auto" asChild>
            <a href={`https://wa.me/919999999999?text=${encodeURIComponent(waMessage)}`} target="_blank" rel="noopener noreferrer">
              Enquire for All →
            </a>
          </Button>
        </>
      )}
    </div>
  );
}

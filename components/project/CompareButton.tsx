"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Heart } from "lucide-react";
import { cn } from "@/lib/utils";
import {
  COMPARE_CHANGED_EVENT,
  MAX_COMPARE,
  getCompareList,
  isInCompare,
  toggleCompare,
  type CompareItem,
} from "@/lib/compare/store";

export interface CompareProjectInput {
  id: string;
  name: string;
  slug: string;
  city: { slug: string; name: string };
  builder: { name: string; verified: boolean };
  priceMin: bigint | null;
  priceMax: bigint | null;
  areaMinSqft: number | null;
  areaMaxSqft: number | null;
  possessionDate: Date | null;
  reraVerified: boolean;
  constructionStatus: string;
}

function toCompareItem(project: CompareProjectInput): CompareItem {
  return {
    id: project.id,
    name: project.name,
    slug: project.slug,
    citySlug: project.city.slug,
    cityName: project.city.name,
    builderName: project.builder.name,
    priceMin: project.priceMin?.toString() ?? null,
    priceMax: project.priceMax?.toString() ?? null,
    areaMinSqft: project.areaMinSqft,
    areaMaxSqft: project.areaMaxSqft,
    possessionDate: project.possessionDate ? project.possessionDate.toString() : null,
    reraVerified: project.reraVerified,
    builderVerified: project.builder.verified,
    constructionStatus: project.constructionStatus,
  };
}

export function CompareButton({ project }: { project: CompareProjectInput }) {
  const [active, setActive] = useState(false);
  const [atLimit, setAtLimit] = useState(false);

  useEffect(() => {
    const sync = () => {
      setActive(isInCompare(project.id));
      setAtLimit(getCompareList().length >= MAX_COMPARE);
    };
    sync();
    window.addEventListener(COMPARE_CHANGED_EVENT, sync);
    window.addEventListener("storage", sync);
    return () => {
      window.removeEventListener(COMPARE_CHANGED_EVENT, sync);
      window.removeEventListener("storage", sync);
    };
  }, [project.id]);

  return (
    <Button
      type="button"
      size="icon"
      variant="outline"
      className={cn(
        "size-8 rounded-full border border-slate-200 bg-white/90 backdrop-blur-xs shadow-xs hover:bg-white transition-all text-slate-600 hover:text-red-500",
        active && "text-red-500 bg-white"
      )}
      disabled={!active && atLimit}
      aria-pressed={active}
      aria-label={active ? `Remove ${project.name} from comparison` : `Add ${project.name} to comparison`}
      title={active ? "Remove from comparison" : atLimit ? "Comparison limit reached" : "Add to comparison"}
      onClick={(e) => {
        e.preventDefault();
        toggleCompare(toCompareItem(project));
      }}
    >
      <Heart className={cn("size-4", active && "fill-red-500 text-red-500")} />
    </Button>
  );
}

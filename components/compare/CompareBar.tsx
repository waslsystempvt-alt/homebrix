"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Scale, X } from "lucide-react";
import { COMPARE_CHANGED_EVENT, clearCompare, getCompareList } from "@/lib/compare/store";

export function CompareBar() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const sync = () => setCount(getCompareList().length);
    sync();
    window.addEventListener(COMPARE_CHANGED_EVENT, sync);
    window.addEventListener("storage", sync);
    return () => {
      window.removeEventListener(COMPARE_CHANGED_EVENT, sync);
      window.removeEventListener("storage", sync);
    };
  }, []);

  if (count === 0) return null;

  return (
    <div className="fixed bottom-4 left-1/2 -translate-x-1/2 z-50 flex items-center gap-3 rounded-full border bg-background shadow-lg px-4 py-2.5">
      <Scale className="size-4 text-primary" />
      <span className="text-sm font-medium">{count} project{count > 1 ? "s" : ""} selected</span>
      <Button size="sm" asChild>
        <Link href="/compare">Compare Now</Link>
      </Button>
      <button
        type="button"
        onClick={clearCompare}
        className="text-muted-foreground hover:text-foreground"
        aria-label="Clear compare list"
      >
        <X className="size-4" />
      </button>
    </div>
  );
}

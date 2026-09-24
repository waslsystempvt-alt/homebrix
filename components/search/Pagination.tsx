import Link from "next/link";
import { Button } from "@/components/ui/button";
import { ChevronLeft, ChevronRight } from "lucide-react";

export function Pagination({
  pathname,
  searchParams,
  currentPage,
  totalPages,
}: {
  pathname: string;
  searchParams: Record<string, string | string[] | undefined>;
  currentPage: number;
  totalPages: number;
}) {
  if (totalPages <= 1) return null;

  function hrefFor(page: number) {
    const params = new URLSearchParams();
    for (const [key, value] of Object.entries(searchParams)) {
      if (key === "page") continue;
      if (Array.isArray(value)) value.forEach((v) => params.append(key, v));
      else if (value) params.set(key, value);
    }
    if (page > 1) params.set("page", String(page));
    const qs = params.toString();
    return qs ? `${pathname}?${qs}` : pathname;
  }

  return (
    <div className="flex items-center justify-center gap-2 pt-8">
      <Button variant="outline" size="sm" disabled={currentPage <= 1} asChild={currentPage > 1}>
        {currentPage > 1 ? (
          <Link href={hrefFor(currentPage - 1)}>
            <ChevronLeft className="size-4" /> Prev
          </Link>
        ) : (
          <span>
            <ChevronLeft className="size-4" /> Prev
          </span>
        )}
      </Button>
      <span className="text-sm text-muted-foreground px-2">
        Page {currentPage} of {totalPages}
      </span>
      <Button variant="outline" size="sm" disabled={currentPage >= totalPages} asChild={currentPage < totalPages}>
        {currentPage < totalPages ? (
          <Link href={hrefFor(currentPage + 1)}>
            Next <ChevronRight className="size-4" />
          </Link>
        ) : (
          <span>
            Next <ChevronRight className="size-4" />
          </span>
        )}
      </Button>
    </div>
  );
}

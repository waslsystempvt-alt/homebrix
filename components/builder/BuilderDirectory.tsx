import Link from "next/link";
import { Card } from "@/components/ui/card";
import { BadgeCheck } from "lucide-react";
import type { Builder } from "@/generated/prisma/client";

type BuilderWithCount = Builder & { _count: { projects: number } };

export function BuilderDirectory({ cityName, builders }: { cityName: string; builders: BuilderWithCount[] }) {
  return (
    <div className="mx-auto max-w-7xl px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">Builders in {cityName} ({builders.length})</h1>

      {builders.length === 0 ? (
        <p className="text-muted-foreground py-16 text-center">No builders found in {cityName} yet.</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {builders.map((builder) => (
            <Link key={builder.id} href={`/builder/${builder.slug}`}>
              <Card className="p-6 space-y-2 hover:shadow-md transition-shadow h-full">
                <p className="font-semibold text-lg flex items-center gap-1.5">
                  {builder.name}
                  {builder.verified && <BadgeCheck className="size-4 text-primary" />}
                </p>
                {builder.headquarters && <p className="text-sm text-muted-foreground">{builder.headquarters}</p>}
                <div className="flex gap-4 text-sm pt-2">
                  <span>
                    <strong>{builder._count.projects}</strong> projects in {cityName}
                  </span>
                  {builder.trustScore && (
                    <span>
                      <strong>{Number(builder.trustScore)}</strong> ★
                    </span>
                  )}
                </div>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}

import type { ConstructionUpdate } from "@/generated/prisma/client";

export function ConstructionTimeline({ updates }: { updates: ConstructionUpdate[] }) {
  if (updates.length === 0) return null;

  return (
    <section className="space-y-4">
      <h2 className="text-xl font-bold">Construction Progress</h2>
      <div className="space-y-3">
        {updates.map((update) => (
          <div key={update.id} className="flex items-center gap-4">
            <span className="text-sm text-muted-foreground w-20 shrink-0">
              {update.updateDate.toLocaleDateString("en-IN", { month: "short", year: "numeric" })}
            </span>
            <div className="flex-1 h-2.5 rounded-full bg-muted overflow-hidden">
              <div
                className="h-full bg-primary rounded-full"
                style={{ width: `${update.completionPct ?? 0}%` }}
              />
            </div>
            <span className="text-sm font-medium w-12 text-right shrink-0">{update.completionPct}%</span>
            <span className="text-sm text-muted-foreground hidden sm:block flex-1">{update.title}</span>
          </div>
        ))}
      </div>
      <p className="text-xs text-muted-foreground">
        Last updated: {updates[0].updateDate.toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}
      </p>
    </section>
  );
}

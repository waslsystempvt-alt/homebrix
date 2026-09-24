import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { BadgeCheck } from "lucide-react";
import { getInitials } from "@/lib/utils/initials";
import type { Builder } from "@/generated/prisma/client";

export function BuilderInfoCard({ builder }: { builder: Builder }) {
  return (
    <section className="space-y-4">
      <h2 className="text-xl font-bold">About the Builder</h2>
      <Card className="rounded-2xl p-6 space-y-5 shadow-sm">
        <div className="flex items-center gap-4">
          <span className="flex size-14 shrink-0 items-center justify-center rounded-2xl bg-primary text-lg font-bold text-primary-foreground">
            {getInitials(builder.name)}
          </span>
          <div>
            <p className="font-bold text-lg flex items-center gap-1.5">
              {builder.name}
              {builder.verified && <BadgeCheck className="size-4 text-primary" />}
            </p>
            {builder.headquarters && (
              <p className="text-sm text-muted-foreground">
                {builder.establishedYear ? `Founded ${builder.establishedYear} · ` : ""}
                {builder.headquarters}
              </p>
            )}
          </div>
        </div>
        {builder.description && <p className="text-sm text-muted-foreground">{builder.description}</p>}
        <div className="grid grid-cols-3 gap-3 text-center">
          <div className="rounded-xl bg-muted/60 p-3">
            <p className="text-xl font-bold">{builder.totalDelivered}</p>
            <p className="text-xs text-muted-foreground">Delivered</p>
          </div>
          <div className="rounded-xl bg-muted/60 p-3">
            <p className="text-xl font-bold">{builder.underConstruction}</p>
            <p className="text-xs text-muted-foreground">Under Construction</p>
          </div>
          <div className="rounded-xl bg-muted/60 p-3">
            <p className="text-xl font-bold">
              {builder.deliveryRatePct ? `${Number(builder.deliveryRatePct)}%` : "—"}
            </p>
            <p className="text-xs text-muted-foreground">On-time Delivery</p>
          </div>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" className="flex-1 rounded-xl" asChild>
            <Link href={`/builder/${builder.slug}`}>View All Projects →</Link>
          </Button>
          <Button className="flex-1 rounded-xl" asChild>
            <a href="#lead-form">Enquire Now</a>
          </Button>
        </div>
      </Card>
    </section>
  );
}

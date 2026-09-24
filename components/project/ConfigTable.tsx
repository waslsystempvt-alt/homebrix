import { Card } from "@/components/ui/card";
import { CtaButton } from "@/components/cta/CtaButton";
import { formatPriceRange } from "@/lib/utils/format";
import { Home, Maximize2 } from "lucide-react";
import type { ProjectConfig } from "@/generated/prisma/client";

function configLabel(bhk: number) {
  return bhk === 0 ? "Studio / 1 RK" : `${bhk} BHK`;
}

export function ConfigTable({
  configs,
  projectId,
  projectName,
  builderId,
}: {
  configs: ProjectConfig[];
  projectId: string;
  projectName: string;
  builderId: string;
}) {
  if (configs.length === 0) return null;

  return (
    <section className="space-y-4">
      <div>
        <h2 className="text-xl font-bold">Configuration &amp; Pricing</h2>
        <p className="text-sm text-muted-foreground">Available unit types and starting prices</p>
      </div>

      <div className="flex gap-4 overflow-x-auto snap-x snap-mandatory pb-2 sm:grid sm:grid-cols-2 sm:overflow-visible sm:pb-0 [-ms-overflow-style:none] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
        {configs.map((config) => (
          <Card
            key={config.id}
            className="relative w-[82%] shrink-0 snap-start overflow-hidden rounded-2xl p-5 shadow-sm transition-all hover:-translate-y-0.5 hover:shadow-md sm:w-auto sm:shrink"
          >
            <div className="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-primary to-primary/30" />

            <div className="flex items-start justify-between gap-3">
              <div className="flex items-center gap-3">
                <span className="flex size-12 shrink-0 items-center justify-center rounded-xl bg-primary/10 text-primary">
                  <Home className="size-6" />
                </span>
                <div>
                  <p className="text-lg font-bold leading-tight">{configLabel(config.bhk)}</p>
                  {(config.bedrooms || config.bathrooms) && (
                    <p className="text-xs text-muted-foreground">
                      {config.bedrooms ? `${config.bedrooms} Bed` : ""}
                      {config.bedrooms && config.bathrooms ? " · " : ""}
                      {config.bathrooms ? `${config.bathrooms} Bath` : ""}
                    </p>
                  )}
                </div>
              </div>
              {!config.isAvailable && (
                <span className="shrink-0 rounded-full bg-destructive/10 px-2.5 py-1 text-[11px] font-semibold text-destructive">
                  Sold Out
                </span>
              )}
            </div>

            <div className="mt-4 flex items-center gap-1.5 text-sm text-muted-foreground">
              <Maximize2 className="size-3.5" />
              {config.areaCarpetMin}
              {config.areaCarpetMax && config.areaCarpetMax !== config.areaCarpetMin
                ? `–${config.areaCarpetMax}`
                : ""}{" "}
              sqft carpet
            </div>

            <div className="mt-4 flex items-end justify-between gap-3 border-t pt-4">
              <div>
                <p className="text-[11px] font-medium tracking-wide text-muted-foreground uppercase">
                  Starting Price
                </p>
                <p className="text-xl font-bold text-primary">{formatPriceRange(config.priceMin, config.priceMax)}</p>
              </div>
              <CtaButton
                ctaName={config.isAvailable ? "Enquire" : "Notify Me"}
                leadType={config.isAvailable ? "contact_form" : "callback"}
                subtitle={`${configLabel(config.bhk)} · ${formatPriceRange(config.priceMin, config.priceMax)}`}
                project={{ id: projectId, name: projectName, builderId }}
                size="sm"
                className="rounded-lg"
              >
                {config.isAvailable ? "Enquire" : "Notify Me"}
              </CtaButton>
            </div>
          </Card>
        ))}
      </div>
    </section>
  );
}

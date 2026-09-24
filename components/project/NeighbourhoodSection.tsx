"use client";

import Link from "next/link";
import { useState } from "react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Clock, MapPin } from "lucide-react";

const CATEGORY_LABELS: Record<string, string> = {
  school: "School",
  hospital: "Hospital",
  shopping: "Shopping",
  college_university: "College & University",
};

export interface LandmarkEntry {
  category: string;
  name: string;
  travelMinutes?: number | null;
  distanceLabel?: string | null;
  distanceM?: number | null;
  place?: { seoSlug: string; createSeoPage: boolean } | null;
}

export function NeighbourhoodSection({
  projectName,
  locationLabel,
  mapQuery,
  landmarks,
}: {
  projectName: string;
  locationLabel: string;
  mapQuery: string;
  landmarks: LandmarkEntry[];
}) {
  const categories = Array.from(new Set(landmarks.map((l) => l.category)));
  const [active, setActive] = useState(categories[0]);

  if (landmarks.length === 0) return null;

  const mapSrc = `https://www.google.com/maps?q=${encodeURIComponent(mapQuery)}&output=embed`;

  return (
    <section className="space-y-4">
      <div>
        <h2 className="text-xl font-bold">Neighbourhood</h2>
        <p className="text-sm text-muted-foreground">
          {projectName} · {locationLabel}
        </p>
      </div>

      <div className="overflow-hidden rounded-2xl border shadow-sm">
        <iframe
          src={mapSrc}
          title={`Map showing ${projectName} location`}
          className="h-64 w-full sm:h-80"
          loading="lazy"
          referrerPolicy="no-referrer-when-downgrade"
        />
      </div>

      <div className="flex items-center justify-between gap-3">
        <p className="text-sm font-semibold text-muted-foreground">Nearby places</p>
        <Select value={active} onValueChange={setActive}>
          <SelectTrigger className="w-56">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {categories.map((c) => (
              <SelectItem key={c} value={c}>
                {CATEGORY_LABELS[c] ?? c}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-2">
        {landmarks
          .filter((l) => l.category === active)
          .map((l, i) => (
            <div key={i} className="flex items-center justify-between gap-3 rounded-lg border p-3">
              <span className="flex items-center gap-2 text-sm">
                <MapPin className="size-4 shrink-0 text-primary" />
                {l.place?.createSeoPage && l.place?.seoSlug ? (
                  <Link
                    href={`/flats-near-${l.place.seoSlug}`}
                    className="font-medium hover:text-primary hover:underline"
                  >
                    {l.name}
                  </Link>
                ) : (
                  <span>{l.name}</span>
                )}
              </span>
              <span className="flex shrink-0 items-center gap-1 text-xs text-muted-foreground">
                <Clock className="size-3.5" />
                {l.travelMinutes ? `${l.travelMinutes} mins` : l.distanceLabel || "Nearby"}
              </span>
            </div>
          ))}
      </div>
    </section>
  );
}

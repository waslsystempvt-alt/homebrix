"use client";

import { useState } from "react";
import Image from "next/image";
import { ChevronLeft, ChevronRight, ShieldCheck } from "lucide-react";
import { STATUS_ICONS, STATUS_LABELS, STATUS_PILL_CLASS } from "@/lib/utils/format";
import { getGalleryPhotos } from "@/lib/media/stockPhotos";
import { cn } from "@/lib/utils";
import { CompareButton } from "@/components/project/CompareButton";
import type { CompareProjectInput } from "@/components/project/CompareButton";

export type ProjectGalleryData = CompareProjectInput;

export function ProjectGallery({ project }: { project: ProjectGalleryData }) {
  const photos = getGalleryPhotos(project.id);
  const [active, setActive] = useState(0);
  const StatusIcon = STATUS_ICONS[project.constructionStatus] ?? ShieldCheck;

  function goTo(delta: number) {
    setActive((i) => (i + delta + photos.length) % photos.length);
  }

  return (
    <section className="space-y-3">
      <div className="relative aspect-square sm:aspect-[21/9] w-full overflow-hidden rounded-2xl bg-muted shadow-sm">
        <Image
          src={photos[active]}
          alt={`${project.name} photo ${active + 1}`}
          fill
          sizes="100vw"
          className="object-cover"
          priority
        />
        <div className="absolute inset-x-0 top-0 h-16 bg-gradient-to-b from-black/30 to-transparent pointer-events-none" />
        <div className="absolute top-3 left-3 flex flex-col items-start gap-1.5">
          <span
            className={cn(
              "inline-flex items-center gap-1 rounded-full px-2.5 py-1.5 text-xs font-bold shadow-sm",
              STATUS_PILL_CLASS[project.constructionStatus] ?? "bg-secondary text-secondary-foreground"
            )}
          >
            <StatusIcon className="size-3.5" />
            {STATUS_LABELS[project.constructionStatus] ?? project.constructionStatus}
          </span>
          {project.reraVerified && (
            <span className="inline-flex items-center gap-1 rounded-full bg-white px-2.5 py-1.5 text-xs font-bold text-foreground shadow-sm">
              <ShieldCheck className="size-3.5" />
              RERA
            </span>
          )}
        </div>
        <div className="absolute top-3 right-3">
          <CompareButton project={project} />
        </div>

        {photos.length > 1 && (
          <>
            <button
              type="button"
              onClick={() => goTo(-1)}
              aria-label="Previous photo"
              className="absolute left-3 top-1/2 -translate-y-1/2 flex size-9 items-center justify-center rounded-full bg-white/90 text-foreground shadow-sm transition-colors hover:bg-white"
            >
              <ChevronLeft className="size-5" />
            </button>
            <button
              type="button"
              onClick={() => goTo(1)}
              aria-label="Next photo"
              className="absolute right-3 top-1/2 -translate-y-1/2 flex size-9 items-center justify-center rounded-full bg-white/90 text-foreground shadow-sm transition-colors hover:bg-white"
            >
              <ChevronRight className="size-5" />
            </button>
          </>
        )}

        <span className="absolute bottom-3 right-3 rounded-full bg-black/60 px-3 py-1 text-xs font-medium text-white backdrop-blur-sm">
          {active + 1} / {photos.length}
        </span>
      </div>
      <div className="flex gap-2.5 overflow-x-auto pb-1">
        {photos.map((src, i) => (
          <button
            key={src}
            onClick={() => setActive(i)}
            className={cn(
              "relative aspect-video w-28 shrink-0 overflow-hidden rounded-xl ring-2 transition-all",
              active === i ? "ring-primary" : "ring-transparent opacity-70 hover:opacity-100"
            )}
          >
            <Image src={src} alt={`${project.name} thumbnail ${i + 1}`} fill sizes="112px" className="object-cover" />
          </button>
        ))}
      </div>
    </section>
  );
}

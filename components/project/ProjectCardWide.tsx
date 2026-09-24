"use client";

import { useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { CtaButton } from "@/components/cta/CtaButton";
import {
  formatArea,
  formatPossession,
  formatPriceRange,
  STATUS_ICONS,
  STATUS_LABELS,
  STATUS_PILL_CLASS,
} from "@/lib/utils/format";
import { getInitials } from "@/lib/utils/initials";
import {
  BedDouble,
  Calendar,
  ChevronLeft,
  ChevronRight,
  MapPin,
  ShieldCheck,
  Tag,
  Wallet,
} from "lucide-react";
import type { ProjectCardData } from "@/lib/db/queries";
import { CompareButton } from "@/components/project/CompareButton";
import { getGalleryPhotos } from "@/lib/media/stockPhotos";
import { WhatsAppIcon } from "@/components/icons/WhatsAppIcon";
import { cn } from "@/lib/utils";

function bhkRangeLabel(configs: { bhk: number }[]): string | null {
  if (configs.length === 0) return null;
  const bhks = configs.map((c) => c.bhk).sort((a, b) => a - b);
  const label = (n: number) => (n === 0 ? "Studio" : `${n} BHK`);
  const min = bhks[0];
  const max = bhks[bhks.length - 1];
  return min === max ? label(min) : `${min}-${max} BHK`;
}

function paymentPlanSummary(paymentPlans: unknown): string | null {
  if (typeof paymentPlans !== "object" || paymentPlans === null) return null;
  const flexi = (paymentPlans as Record<string, unknown>).flexi;
  if (!Array.isArray(flexi) || flexi.length === 0) return null;
  const booking = flexi[0] as { pct?: number };
  if (typeof booking.pct !== "number") return null;
  return `${booking.pct}/${100 - booking.pct}`;
}

export function ProjectCardWide({ project }: { project: ProjectCardData }) {
  const photos = getGalleryPhotos(project.id, 800);
  const [active, setActive] = useState(0);
  const StatusIcon = STATUS_ICONS[project.constructionStatus] ?? ShieldCheck;
  const bhkLabel = bhkRangeLabel(project.configs);
  const planSummary = paymentPlanSummary(project.paymentPlans);

  function goTo(delta: number) {
    setActive((i) => (i + delta + photos.length) % photos.length);
  }

  return (
    <Card className="group/card relative overflow-hidden py-0 gap-0 rounded-2xl shadow-soft ring-1 ring-foreground/5 transition-all duration-300 hover:shadow-lift hover:ring-primary/20">
      <div className="flex flex-col sm:flex-row">
        <div className="relative aspect-[4/3] w-full shrink-0 bg-muted sm:aspect-auto sm:w-[38%]">
          <Image
            src={photos[active]}
            alt={`${project.name} photo ${active + 1}`}
            fill
            sizes="(min-width: 640px) 38vw, 100vw"
            className="object-cover transition-transform duration-500 group-hover/card:scale-105"
          />
          <div className="absolute inset-x-0 top-0 h-14 bg-gradient-to-b from-black/30 to-transparent pointer-events-none" />

          <div className="absolute top-3 left-3 flex flex-wrap items-start gap-1.5">
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

          <div className="absolute top-3 right-3 z-20">
            <CompareButton project={project} />
          </div>

          {photos.length > 1 && (
            <>
              <button
                type="button"
                onClick={() => goTo(-1)}
                aria-label="Previous photo"
                className="absolute z-20 left-2 top-1/2 -translate-y-1/2 flex size-8 items-center justify-center rounded-full bg-white/90 text-foreground shadow-sm transition-colors hover:bg-white"
              >
                <ChevronLeft className="size-4" />
              </button>
              <button
                type="button"
                onClick={() => goTo(1)}
                aria-label="Next photo"
                className="absolute z-20 right-2 top-1/2 -translate-y-1/2 flex size-8 items-center justify-center rounded-full bg-white/90 text-foreground shadow-sm transition-colors hover:bg-white"
              >
                <ChevronRight className="size-4" />
              </button>
              <div className="absolute bottom-3 left-1/2 flex -translate-x-1/2 gap-1.5">
                {photos.map((_, i) => (
                  <span
                    key={i}
                    className={cn("size-1.5 rounded-full", i === active ? "bg-white" : "bg-white/50")}
                  />
                ))}
              </div>
            </>
          )}

          <span className="absolute bottom-3 left-3 inline-flex items-center gap-1.5 rounded-full bg-black/55 pl-1 pr-2.5 py-1 text-xs font-medium text-white backdrop-blur-sm">
            <span className="flex size-5 items-center justify-center rounded-full bg-white/25 text-[10px] font-bold">
              {getInitials(project.builder.name)}
            </span>
            {project.builder.name}
          </span>
        </div>

        <div className="flex-1 min-w-0 p-5 space-y-3">
          <p className="nums text-2xl font-bold">{formatPriceRange(project.priceMin, project.priceMax)}</p>

          <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-sm text-muted-foreground">
            <span>Apartment</span>
            {bhkLabel && (
              <>
                <span className="text-border">|</span>
                <span className="flex items-center gap-1">
                  <BedDouble className="size-3.5" />
                  {bhkLabel}
                </span>
              </>
            )}
            <span className="text-border">|</span>
            <span>
              <span className="font-medium text-foreground">Area:</span> {formatArea(project.areaMinSqft, project.areaMaxSqft)}
            </span>
          </div>

          {/* Stretched link — see ProjectCard for the pattern. */}
          <Link
            href={`/projects/${project.city.slug}/${project.slug}`}
            className="block text-lg font-semibold text-primary hover:underline line-clamp-1 after:absolute after:inset-0 after:z-10 after:content-['']"
          >
            {project.name}
          </Link>

          <p className="flex items-center gap-1.5 text-sm text-muted-foreground">
            <MapPin className="size-4 shrink-0 text-primary" />
            <span className="truncate">
              {project.locality?.name ? `${project.locality.name}, ` : ""}
              {project.city.name}
            </span>
          </p>

          {project.reraVerified && (
            <div className="flex items-center gap-2 rounded-lg bg-primary/5 px-3 py-2 text-sm text-primary">
              <ShieldCheck className="size-4 shrink-0" />
              RERA Verified project
            </div>
          )}

          <div className="flex flex-wrap gap-3">
            <div className="rounded-lg bg-muted/60 px-3 py-2">
              <p className="flex items-center gap-1 text-[10px] uppercase tracking-wide text-muted-foreground">
                <Calendar className="size-3" /> Possession
              </p>
              <p className="text-sm font-bold">{formatPossession(project.possessionDate)}</p>
            </div>
            {planSummary && (
              <div className="rounded-lg bg-muted/60 px-3 py-2">
                <p className="flex items-center gap-1 text-[10px] uppercase tracking-wide text-muted-foreground">
                  <Wallet className="size-3" /> Payment Plan
                </p>
                <p className="text-sm font-bold">{planSummary}</p>
              </div>
            )}
          </div>

          <div className="relative z-20 flex gap-2 pt-1">
            <CtaButton
              ctaName="Get Best Price"
              leadType="contact_form"
              project={{ id: project.id, name: project.name, builderId: project.builderId }}
              variant="outline"
              size="sm"
              className="h-9 flex-1 gap-1.5 rounded-xl"
            >
              <Tag className="size-3.5" />
              Get Best Price
            </CtaButton>
            <Button size="sm" className="h-9 flex-1 gap-1.5 rounded-xl bg-[#25D366] text-white hover:bg-[#1ebe5d]" asChild>
              <a
                href={`https://wa.me/919999999999?text=${encodeURIComponent(`Hi, I'm interested in ${project.name}`)}`}
                target="_blank"
                rel="noopener noreferrer"
              >
                <WhatsAppIcon className="size-3.5" />
                WhatsApp
              </a>
            </Button>
          </div>
        </div>
      </div>
    </Card>
  );
}

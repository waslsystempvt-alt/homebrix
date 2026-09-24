import { CtaButton } from "@/components/cta/CtaButton";
import Image from "next/image";
import { BadgeCheck, Building2, CalendarDays, Download, Layers, MapPin } from "lucide-react";
import { formatPossession, formatPriceRange } from "@/lib/utils/format";
import type { Project, Builder, City, Locality } from "@/generated/prisma/client";

type ProjectWithRelations = Project & { builder: Builder; city: City; locality: Locality | null };

export function ProjectOverview({ project }: { project: ProjectWithRelations }) {
  // Price is the number every visitor scans for first, so it gets its own
  // block; the rest are secondary specs in quieter neutral tiles.
  const secondaryStats = [
    { label: "Possession", icon: CalendarDays, value: formatPossession(project.possessionDate) },
    {
      label: "Total Units",
      icon: Building2,
      value: project.totalUnits ? project.totalUnits.toLocaleString("en-IN") : "—",
    },
    {
      label: "Towers / Floors",
      icon: Layers,
      value: `${project.totalTowers ?? "—"} / ${project.totalFloors ?? "—"}`,
    },
  ];

  return (
    <section className="space-y-5">
      <div>
        <div className="flex items-start gap-3">
          <div className="relative flex size-12 shrink-0 items-center justify-center overflow-hidden rounded-xl border border-border bg-muted text-sm font-bold text-primary">
            {project.builder.logoUrl ? <Image src={project.builder.logoUrl} alt={`${project.builder.name} logo`} fill sizes="48px" className="object-contain p-1.5" /> : project.builder.name.slice(0, 2).toUpperCase()}
          </div>
          <h1 className="flex items-center gap-2 text-3xl font-semibold leading-[1.15] tracking-tight sm:text-4xl">
            {project.name}
            {project.builder.verified && <BadgeCheck className="size-6 shrink-0 text-primary" />}
          </h1>
        </div>
        <p className="mt-2 text-muted-foreground">by {project.builder.name}</p>
        <p className="mt-1 flex items-center gap-1 text-sm text-muted-foreground">
          <MapPin className="size-3.5 text-primary" />
          {project.locality?.name ? `${project.locality.name}, ` : ""}
          {project.city.name}
        </p>
      </div>

      <div className="rounded-2xl bg-primary/8 p-4 ring-1 ring-primary/15">
        <p className="text-xs font-semibold uppercase tracking-widest text-primary/70">Price Range</p>
        <p className="nums mt-1 text-3xl font-bold leading-tight text-primary sm:text-4xl">
          {formatPriceRange(project.priceMin, project.priceMax)}
        </p>
      </div>

      <div className="grid grid-cols-3 gap-3">
        {secondaryStats.map(({ label, icon: Icon, value }) => (
          <div key={label} className="rounded-xl border bg-card p-3 shadow-soft">
            <p className="nums text-sm font-bold leading-tight sm:text-base">{value}</p>
            <p className="mt-1 flex items-center gap-1 text-xs text-muted-foreground">
              <Icon className="size-3 shrink-0" />
              <span className="truncate">{label}</span>
            </p>
          </div>
        ))}
      </div>

      <div className="flex gap-2 sm:gap-3">
        <CtaButton
          ctaName="Download Brochure"
          leadType="brochure"
          subtitle="Share your number and we'll send the brochure right away"
          project={{ id: project.id, name: project.name, builderId: project.builderId }}
          variant="outline"
          className="h-11 flex-1 rounded-xl px-5 text-base sm:flex-none"
        >
          <Download className="size-4" />
          <span className="sm:hidden">Brochure</span>
          <span className="hidden sm:inline">Download Brochure</span>
        </CtaButton>
        <CtaButton
          ctaName="Schedule Site Visit"
          leadType="site_visit"
          subtitle="Pick a convenient time — our team will confirm shortly"
          project={{ id: project.id, name: project.name, builderId: project.builderId }}
          className="h-11 flex-1 rounded-xl px-5 text-base sm:flex-none"
        >
          <CalendarDays className="size-4" />
          <span className="sm:hidden">Site Visit</span>
          <span className="hidden sm:inline">Schedule Site Visit</span>
        </CtaButton>
      </div>
    </section>
  );
}

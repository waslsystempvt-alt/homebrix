"use client";

import { useState } from "react";
import { ChevronDown } from "lucide-react";
import { ArrowRight } from "lucide-react";
import Link from "next/link";
import { ProjectCard } from "@/components/project/ProjectCard";
import { SectionHeading } from "@/components/home/SectionHeading";
import type { ProjectCardData } from "@/lib/db/queries";
import { cn } from "@/lib/utils";

const MOBILE_PREVIEW_COUNT = 4;

export function ProjectSection({
  kicker,
  title,
  subtitle,
  projects,
  viewAllHref,
  viewAllLabel = "View All",
  mobileCarousel = false,
}: {
  kicker?: string;
  title: string;
  subtitle?: string;
  projects: ProjectCardData[];
  viewAllHref?: string;
  viewAllLabel?: string;
  /** On mobile, show a horizontal swipeable carousel instead of a stacked grid with a "View All" toggle. */
  mobileCarousel?: boolean;
}) {
  const [showAllMobile, setShowAllMobile] = useState(false);

  if (projects.length === 0) return null;

  return (
    <section className="mx-auto max-w-7xl px-4 py-14">
      <SectionHeading kicker={kicker} title={title} subtitle={subtitle} viewAllHref={viewAllHref} viewAllLabel={viewAllLabel} />

      {mobileCarousel ? (
        <div className="flex gap-4 overflow-x-auto snap-x snap-mandatory pb-2 sm:grid sm:grid-cols-2 sm:gap-6 sm:overflow-visible sm:pb-0 lg:grid-cols-4 [-ms-overflow-style:none] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
          {projects.map((project) => (
            <div key={project.id} className="w-[82%] shrink-0 snap-start sm:w-auto sm:shrink">
              <ProjectCard project={project} />
            </div>
          ))}
        </div>
      ) : (
        <>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {projects.map((project, i) => (
              <div key={project.id} className={cn(i >= MOBILE_PREVIEW_COUNT && !showAllMobile && "hidden sm:block")}>
                <ProjectCard project={project} />
              </div>
            ))}
          </div>
          {projects.length > MOBILE_PREVIEW_COUNT && !showAllMobile && (
            <button
              type="button"
              onClick={() => setShowAllMobile(true)}
              className="sm:hidden mt-5 flex w-full items-center justify-center gap-1 text-sm font-medium text-primary hover:underline"
            >
              View All <ChevronDown className="size-4" />
            </button>
          )}
        </>
      )}
      {viewAllHref && <Link href={viewAllHref} className="mobile-project-view-all sm:hidden">{viewAllLabel} <ArrowRight className="size-4" /></Link>}
    </section>
  );
}

import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { prisma } from "@/lib/db/prisma";
import { LandmarkLandingView } from "@/components/seo/LandmarkLandingView";
import { generateLandmarkSeoContent } from "@/lib/seo/landmarkContent";
import { searchProjects } from "@/lib/search/query";
import { parseSearchFilters } from "@/lib/search/types";
import { SITE_URL } from "@/lib/seo/site";

interface LandmarkPageProps {
  params: Promise<{ seoSlug: string }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}

async function getPlaceBySeoSlug(seoSlug: string) {
  return prisma.place.findFirst({
    where: {
      seoSlug,
      createSeoPage: true,
      isActive: true,
    },
    include: {
      city: { select: { id: true, name: true, slug: true } },
    },
  });
}

export async function generateMetadata({ params }: LandmarkPageProps): Promise<Metadata> {
  const { seoSlug } = await params;
  const place = await getPlaceBySeoSlug(seoSlug);

  if (!place || !place.city) {
    return { title: "Landmark Not Found | Homebrix" };
  }

  const projectCount = await prisma.projectLandmark.count({
    where: { placeId: place.id },
  });

  const content = generateLandmarkSeoContent(place.name, place.city.name, place.category, projectCount);

  return {
    title: content.title,
    description: content.description,
    alternates: { canonical: `${SITE_URL}/flats-near-${place.seoSlug}` },
    openGraph: {
      title: content.title,
      description: content.description,
      type: "website",
    },
  };
}

export default async function LandmarkPage({ params, searchParams }: LandmarkPageProps) {
  const { seoSlug } = await params;
  const rawSearchParams = await searchParams;
  const place = await getPlaceBySeoSlug(seoSlug);

  if (!place || !place.city) {
    notFound();
  }

  const filters = parseSearchFilters(rawSearchParams);
  // Ensure proximity filter is bound to this place
  const activeFilters = {
    ...filters,
    nearPlace: filters.nearPlace ?? place.slug,
    withinKm: filters.withinKm ?? 5,
  };

  const {
    projects,
    total,
    totalPages,
    localityFacets,
    regionFacets,
    builderFacets,
    cityFacets,
  } = await searchProjects({ citySlug: place.city.slug, status: null }, activeFilters);

  return (
    <LandmarkLandingView
      place={place}
      city={place.city}
      projects={projects}
      total={total}
      totalPages={totalPages}
      filters={activeFilters}
      rawSearchParams={rawSearchParams}
      localityFacets={localityFacets}
      regionFacets={regionFacets}
      builderFacets={builderFacets}
      cityFacets={cityFacets}
    />
  );
}

import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getProjectBySlug, getSimilarProjects } from "@/lib/db/queries";
import { ProjectGallery, type ProjectGalleryData } from "@/components/project/ProjectGallery";
import { ProjectOverview } from "@/components/project/ProjectOverview";
import { ConfigTable } from "@/components/project/ConfigTable";
import { AmenitiesGrid } from "@/components/project/AmenitiesGrid";
import { ProjectDescription } from "@/components/project/ProjectDescription";
import { NeighbourhoodSection } from "@/components/project/NeighbourhoodSection";
import { ConstructionTimeline } from "@/components/project/ConstructionTimeline";
import { BuilderInfoCard } from "@/components/project/BuilderInfoCard";
import { ReraInfoSection } from "@/components/project/ReraInfoSection";
import { EmiCalculatorInline } from "@/components/project/EmiCalculatorInline";
import { ProjectFaqSection } from "@/components/project/ProjectFaqSection";
import { LeadForm } from "@/components/project/LeadForm";
import { ProjectSection } from "@/components/home/ProjectSection";

import { SITE_URL } from "@/lib/seo/site";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ city: string; slug: string }>;
}): Promise<Metadata> {
  const { city, slug } = await params;
  const project = await getProjectBySlug(city, slug);
  if (!project) return {};

  const locationLabel = project.locality ? `${project.locality.name}, ${project.city.name}` : project.city.name;
  return {
    title: `${project.name} by ${project.builder.name} in ${locationLabel} – Price, Floor Plans | Homebrix`,
    description:
      project.metaDesc ??
      `${project.name} by ${project.builder.name} in ${locationLabel}. RERA verified, floor plans, pricing and amenities.`,
    alternates: { canonical: `${SITE_URL}/projects/${project.city.slug}/${project.slug}` },
  };
}

export default async function ProjectDetailPage({
  params,
}: {
  params: Promise<{ city: string; slug: string }>;
}) {
  const { city, slug } = await params;
  const project = await getProjectBySlug(city, slug);
  if (!project) notFound();

  const similarProjects = await getSimilarProjects(project.cityId, project.id, 4);
  const avgPrice = project.priceMin && project.priceMax ? (Number(project.priceMin) + Number(project.priceMax)) / 2 : 6500000;
  const locationLabel = project.locality ? `${project.locality.name}, ${project.city.name}` : project.city.name;
  const mapQuery = project.address ?? `${project.name}, ${locationLabel}`;

  // Client components can't receive Prisma's Decimal instances (e.g. builder.trustScore) as
  // props, so pass the gallery a plain object with only the primitive fields it needs.
  const galleryProject: ProjectGalleryData = {
    id: project.id,
    name: project.name,
    slug: project.slug,
    constructionStatus: project.constructionStatus,
    reraVerified: project.reraVerified,
    priceMin: project.priceMin,
    priceMax: project.priceMax,
    areaMinSqft: project.areaMinSqft,
    areaMaxSqft: project.areaMaxSqft,
    possessionDate: project.possessionDate,
    builder: { name: project.builder.name, verified: project.builder.verified },
    city: { name: project.city.name, slug: project.city.slug },
  };

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": ["RealEstateListing", "ApartmentComplex"],
    name: project.name,
    description: project.description || `${project.name} by ${project.builder.name} in ${locationLabel}`,
    url: `https://www.leadestate.in/projects/${project.city.slug}/${project.slug}`,
    address: {
      "@type": "PostalAddress",
      addressLocality: project.locality?.name || project.city.name,
      addressRegion: project.city.name,
      addressCountry: "IN",
    },
    ...(project.lat && project.lng
      ? {
          geo: {
            "@type": "GeoCoordinates",
            latitude: Number(project.lat),
            longitude: Number(project.lng),
          },
        }
      : {}),
    author: {
      "@type": "Organization",
      name: project.builder.name,
    },
    offers: {
      "@type": "AggregateOffer",
      priceCurrency: "INR",
      lowPrice: project.priceMin ? Number(project.priceMin) : undefined,
      highPrice: project.priceMax ? Number(project.priceMax) : undefined,
    },
    ...(project.reraNumber ? { identifier: project.reraNumber } : {}),
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      <div className="bg-gradient-to-b from-primary/[0.06] via-muted/30 to-background">
        <div className="mx-auto max-w-7xl px-4 py-6 space-y-10">
          <ProjectGallery project={galleryProject} />

          <div className="grid grid-cols-1 lg:grid-cols-[1fr_340px] gap-8">
            <div className="space-y-10 min-w-0">
              <ProjectOverview project={project} />
              <ConfigTable
                configs={project.configs}
                projectId={project.id}
                projectName={project.name}
                builderId={project.builderId}
              />
              <AmenitiesGrid amenities={project.amenities} />
              {project.landmarks.length > 0 && (
                <NeighbourhoodSection
                  projectName={project.name}
                  locationLabel={locationLabel}
                  mapQuery={mapQuery}
                  landmarks={project.landmarks}
                />
              )}
              <ConstructionTimeline updates={project.constructionUpdates} />
              <BuilderInfoCard builder={project.builder} />
              {project.reraNumber && (
                <ReraInfoSection projectName={project.name} reraNumber={project.reraNumber} cityName={project.city.name} />
              )}
              <EmiCalculatorInline defaultPrice={avgPrice} />
              <ProjectFaqSection
                project={{
                  name: project.name,
                  reraNumber: project.reraNumber,
                  constructionStatus: project.constructionStatus,
                  possessionDate: project.possessionDate,
                  areaMinSqft: project.areaMinSqft,
                  areaMaxSqft: project.areaMaxSqft,
                }}
                cityName={project.city.name}
                localityName={project.locality?.name ?? null}
                cmsFaqs={project.faqs}
              />
              {project.description && (
                <ProjectDescription projectName={project.name} description={project.description} />
              )}
            </div>

            <div id="lead-form" className="scroll-mt-20 lg:sticky lg:top-36 lg:self-start">
              <LeadForm projectId={project.id} builderId={project.builderId} projectName={project.name} />
            </div>
          </div>
        </div>

        <ProjectSection title="Similar Projects" projects={similarProjects} mobileCarousel />
      </div>
    </>
  );
}

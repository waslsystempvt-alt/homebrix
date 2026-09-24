import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { BadgeCheck, Star } from "lucide-react";
import { Card } from "@/components/ui/card";
import { getBuilderBySlug, getBuilderProjects } from "@/lib/db/queries";
import { ProjectSection } from "@/components/home/ProjectSection";
import { jsonLdScript, localBusinessSchema } from "@/lib/seo/schema";
import { SITE_URL } from "@/lib/seo/site";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const builder = await getBuilderBySlug(slug);
  if (!builder) return {};
  return {
    title: `${builder.name} – Projects, Reviews & RERA Details | Homebrix`,
    description:
      builder.metaDesc ??
      `Explore all projects by ${builder.name}. Trust score, RERA registrations, delivery track record, and customer reviews.`,
  };
}

export default async function BuilderProfilePage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const builder = await getBuilderBySlug(slug);
  if (!builder) notFound();

  const projects = await getBuilderProjects(builder.id);
  const ongoing = projects.filter((p) => p.constructionStatus !== "ready_to_move");
  const completed = projects.filter((p) => p.constructionStatus === "ready_to_move");

  const schema = localBusinessSchema({
    name: builder.name,
    headquarters: builder.headquarters,
    url: `${SITE_URL}/builder/${builder.slug}`,
  });

  const citiesSet = Array.from(new Set(projects.map((p) => p.city.name)));

  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: builder.name,
    url: `${SITE_URL}/builder/${builder.slug}`,
    ...(builder.establishedYear ? { foundingDate: String(builder.establishedYear) } : {}),
    ...(builder.headquarters ? { location: { "@type": "Place", name: builder.headquarters } } : {}),
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 space-y-10">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(schema)} />
      <Card className="p-8">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <h1 className="text-3xl font-bold flex items-center gap-2">
              {builder.name}
              {builder.verified && (
                <span title="RERA Verified Builder">
                  <BadgeCheck className="size-6 text-primary" />
                </span>
              )}
            </h1>
            {builder.headquarters && (
              <p className="text-muted-foreground mt-1">
                {builder.establishedYear ? `Founded ${builder.establishedYear} · ` : ""}
                {builder.headquarters}
              </p>
            )}
            {builder.description && <p className="mt-3 max-w-2xl text-sm text-muted-foreground">{builder.description}</p>}
            
            {citiesSet.length > 0 && (
              <div className="flex flex-wrap items-center gap-2 mt-4 pt-3 border-t">
                <span className="text-xs font-semibold text-muted-foreground">Active in:</span>
                {citiesSet.map((cityName) => (
                  <span key={cityName} className="px-2.5 py-1 rounded-full bg-muted text-xs font-medium">
                    {cityName}
                  </span>
                ))}
              </div>
            )}
          </div>
          {builder.trustScore && (
            <div className="text-center shrink-0 bg-primary/5 border border-primary/20 p-4 rounded-xl">
              <p className="text-3xl font-bold flex items-center justify-center gap-1 text-primary">
                {Number(builder.trustScore)} <Star className="size-6 fill-primary text-primary" />
              </p>
              <p className="text-xs font-semibold text-muted-foreground mt-0.5">Trust Score</p>
            </div>
          )}
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mt-6 pt-6 border-t">
          <Stat label="Founded" value={builder.establishedYear ?? "—"} />
          <Stat label="Projects Delivered" value={builder.totalDelivered} />
          <Stat label="Under Construction" value={builder.underConstruction} />
          <Stat
            label="On-time Delivery"
            value={builder.deliveryRatePct ? `${Number(builder.deliveryRatePct)}%` : "—"}
          />
        </div>
      </Card>

      <ProjectSection title="Ongoing & Upcoming Projects" projects={ongoing} />
      <ProjectSection title="Completed Projects" projects={completed} />
    </div>
  );
}

function Stat({ label, value }: { label: string; value: string | number }) {
  return (
    <div className="text-center">
      <p className="text-xl font-bold">{value}</p>
      <p className="text-xs text-muted-foreground">{label}</p>
    </div>
  );
}

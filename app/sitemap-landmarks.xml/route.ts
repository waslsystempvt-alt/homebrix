import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

export async function GET() {
  const places = await prisma.place.findMany({
    where: { createSeoPage: true, isActive: true },
    select: { seoSlug: true, createdAt: true },
  });

  const xml = buildUrlSetXml(
    places.map((p) => ({
      loc: `${SITE_URL}/flats-near-${p.seoSlug}`,
      changefreq: "weekly" as const,
      priority: 0.6,
    }))
  );
  return xmlResponse(xml);
}

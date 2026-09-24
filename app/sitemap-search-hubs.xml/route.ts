import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

const PREFIXES = ["new-projects-in", "under-construction-in", "new-launch-in", "ready-to-move-in", "builders-in"];

export async function GET() {
  const cities = await prisma.city.findMany({ where: { isActive: true }, select: { slug: true } });

  const entries = cities.flatMap((c) =>
    PREFIXES.map((prefix) => ({
      loc: `${SITE_URL}/${prefix}-${c.slug}`,
      changefreq: "daily" as const,
      priority: 0.6,
    }))
  );

  return xmlResponse(buildUrlSetXml(entries));
}

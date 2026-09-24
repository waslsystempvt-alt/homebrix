import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

export async function GET() {
  const cities = await prisma.city.findMany({ where: { isActive: true }, select: { slug: true } });

  const xml = buildUrlSetXml(
    cities.map((c) => ({
      loc: `${SITE_URL}/property-rates-in-${c.slug}`,
      changefreq: "weekly" as const,
      priority: 0.6,
    }))
  );
  return xmlResponse(xml);
}

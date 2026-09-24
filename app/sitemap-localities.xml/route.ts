import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

export async function GET() {
  const localities = await prisma.locality.findMany({
    include: { city: { select: { slug: true } } },
  });

  const xml = buildUrlSetXml(
    localities.map((l) => ({
      loc: `${SITE_URL}/${l.city.slug}/${l.slug}-real-estate`,
      changefreq: "weekly" as const,
      priority: 0.5,
    }))
  );
  return xmlResponse(xml);
}

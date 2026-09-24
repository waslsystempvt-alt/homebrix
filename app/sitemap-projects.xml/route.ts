import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

export async function GET() {
  const projects = await prisma.project.findMany({
    where: { published: true },
    select: { slug: true, updatedAt: true, city: { select: { slug: true } } },
  });

  const xml = buildUrlSetXml(
    projects.map((p) => ({
      loc: `${SITE_URL}/projects/${p.city.slug}/${p.slug}`,
      lastmod: p.updatedAt.toISOString(),
      changefreq: "daily" as const,
      priority: 0.8,
    }))
  );
  return xmlResponse(xml);
}

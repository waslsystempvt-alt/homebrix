import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

export async function GET() {
  const builders = await prisma.builder.findMany({ select: { slug: true, updatedAt: true } });

  const xml = buildUrlSetXml(
    builders.map((b) => ({
      loc: `${SITE_URL}/builder/${b.slug}`,
      lastmod: b.updatedAt.toISOString(),
      changefreq: "weekly" as const,
      priority: 0.6,
    }))
  );
  return xmlResponse(xml);
}

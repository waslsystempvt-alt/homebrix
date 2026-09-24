import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";
import { slugifyCategory } from "@/lib/blog/category";

export async function GET() {
  const posts = await prisma.blogPost.findMany({
    where: { status: "published" },
    select: { slug: true, category: true, updatedAt: true },
  });

  const xml = buildUrlSetXml(
    posts.map((p) => ({
      loc: `${SITE_URL}/blog/${slugifyCategory(p.category ?? "general")}/${p.slug}`,
      lastmod: p.updatedAt.toISOString(),
      changefreq: "monthly" as const,
      priority: 0.5,
    }))
  );
  return xmlResponse(xml);
}

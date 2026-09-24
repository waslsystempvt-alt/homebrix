import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

const STATIC_PATHS = [
  { path: "/", priority: 1, changefreq: "daily" as const },
  { path: "/calculators", priority: 0.6, changefreq: "monthly" as const },
  { path: "/compare", priority: 0.4, changefreq: "monthly" as const },
  { path: "/blog", priority: 0.7, changefreq: "daily" as const },
  { path: "/about-us", priority: 0.3, changefreq: "yearly" as const },
  { path: "/contact-us", priority: 0.3, changefreq: "yearly" as const },
];

export async function GET() {
  const xml = buildUrlSetXml(
    STATIC_PATHS.map((p) => ({
      loc: `${SITE_URL}${p.path}`,
      changefreq: p.changefreq,
      priority: p.priority,
    }))
  );
  return xmlResponse(xml);
}

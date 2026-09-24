import { SITE_URL } from "@/lib/seo/site";
import { buildSitemapIndexXml, xmlResponse } from "@/lib/seo/sitemapXml";

const SITEMAPS = [
  "sitemap-static.xml",
  "sitemap-cities.xml",
  "sitemap-localities.xml",
  "sitemap-property-rates.xml",
  "sitemap-projects.xml",
  "sitemap-builders.xml",
  "sitemap-blog.xml",
  "sitemap-calculators.xml",
  "sitemap-search-hubs.xml",
  "sitemap-landmarks.xml",
];

export async function GET() {
  return xmlResponse(buildSitemapIndexXml(SITEMAPS.map((name) => `${SITE_URL}/${name}`)));
}

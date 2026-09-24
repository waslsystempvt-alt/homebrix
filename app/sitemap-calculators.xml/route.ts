import { prisma } from "@/lib/db/prisma";
import { SITE_URL } from "@/lib/seo/site";
import { buildUrlSetXml, xmlResponse } from "@/lib/seo/sitemapXml";

const STATIC_CALCULATORS = [
  "/calculators",
  "/emi-calculator",
  "/home-loan-eligibility",
  "/affordability-calculator",
  "/buy-vs-rent-calculator",
  "/rental-yield-calculator",
];

export async function GET() {
  const states = await prisma.state.findMany({ select: { slug: true } });

  const entries = [
    ...STATIC_CALCULATORS.map((path) => ({ loc: `${SITE_URL}${path}`, changefreq: "monthly" as const, priority: 0.6 })),
    ...states.map((s) => ({
      loc: `${SITE_URL}/stamp-duty-calculator/${s.slug}`,
      changefreq: "monthly" as const,
      priority: 0.5,
    })),
  ];

  return xmlResponse(buildUrlSetXml(entries));
}

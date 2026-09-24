import type { Metadata } from "next";
import Link from "next/link";
import { getBlogCategories, getSitemapLocalities } from "@/lib/db/queries";
import { slugifyCategory } from "@/lib/blog/category";
import { CALCULATORS } from "@/app/calculators/page";

export const metadata: Metadata = {
  title: "Sitemap | Homebrix",
  description: "Browse all pages on Homebrix — cities, localities, calculators and company pages.",
};

const EXPLORE_LINKS = [
  { label: "New Projects", prefix: "new-projects-in-" },
  { label: "New Launch", prefix: "new-launch-in-" },
  { label: "Under Construction", prefix: "under-construction-in-" },
  { label: "Ready to Move", prefix: "ready-to-move-in-" },
];

const COMPANY_LINKS = [
  { label: "About Us", href: "/about-us" },
  { label: "Careers", href: "/career" },
  { label: "Contact Us", href: "/contact-us" },
  { label: "Blog", href: "/blog" },
  { label: "Compare Projects", href: "/compare" },
  { label: "Privacy Policy", href: "/privacy-policy" },
  { label: "Terms of Service", href: "/terms-of-service" },
];

function SitemapColumn({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">{title}</h2>
      <ul className="space-y-1.5 text-sm">{children}</ul>
    </div>
  );
}

function SitemapLink({ href, children }: { href: string; children: React.ReactNode }) {
  return (
    <li>
      <Link href={href} className="text-foreground/80 hover:text-primary hover:underline">
        {children}
      </Link>
    </li>
  );
}

export default async function SitemapPage() {
  const [cities, blogCategories] = await Promise.all([getSitemapLocalities(), getBlogCategories()]);

  return (
    <div className="mx-auto max-w-6xl px-4 py-12 space-y-12">
      <div>
        <h1 className="text-3xl font-bold mb-2">Sitemap</h1>
        <p className="text-muted-foreground">Every page on Homebrix, organized by section.</p>
      </div>

      <section className="grid grid-cols-2 gap-8 sm:grid-cols-3 lg:grid-cols-4">
        <SitemapColumn title="Company">
          {COMPANY_LINKS.map((link) => (
            <SitemapLink key={link.href} href={link.href}>
              {link.label}
            </SitemapLink>
          ))}
        </SitemapColumn>

        <SitemapColumn title="Calculators">
          {CALCULATORS.map((calc) => (
            <SitemapLink key={calc.href} href={calc.href}>
              {calc.title}
            </SitemapLink>
          ))}
        </SitemapColumn>

        {blogCategories.length > 0 && (
          <SitemapColumn title="Blog Categories">
            {blogCategories.map((category) => (
              <SitemapLink key={category} href={`/blog/${slugifyCategory(category)}`}>
                {category}
              </SitemapLink>
            ))}
          </SitemapColumn>
        )}
      </section>

      {cities.map((city) => (
        <section key={city.slug} className="space-y-6 border-t pt-8">
          <h2 className="text-xl font-bold">{city.name}</h2>
          <div className="grid grid-cols-2 gap-8 sm:grid-cols-3 lg:grid-cols-4">
            <SitemapColumn title="Explore">
              {EXPLORE_LINKS.map((link) => (
                <SitemapLink key={link.prefix} href={`/${link.prefix}${city.slug}`}>
                  {link.label}
                </SitemapLink>
              ))}
              <SitemapLink href={`/builders-in-${city.slug}`}>Builders</SitemapLink>
              <SitemapLink href={`/${city.slug}-real-estate`}>{city.name} Real Estate</SitemapLink>
              <SitemapLink href={`/property-rates-in-${city.slug}`}>Property Rates</SitemapLink>
            </SitemapColumn>

            {city.localities.length > 0 && (
              <div className="col-span-2 sm:col-span-2 lg:col-span-3">
                <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
                  Localities
                </h2>
                <div className="grid grid-cols-2 gap-x-6 gap-y-1.5 sm:grid-cols-3 lg:grid-cols-4">
                  {city.localities.map((locality) => (
                    <Link
                      key={locality.slug}
                      href={`/${city.slug}/${locality.slug}-real-estate`}
                      className="text-sm text-foreground/80 hover:text-primary hover:underline"
                    >
                      {locality.name}
                    </Link>
                  ))}
                </div>
              </div>
            )}
          </div>
        </section>
      ))}
    </div>
  );
}

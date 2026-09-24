import Link from "next/link";
import { Building2 } from "lucide-react";
import { getFooterLocalities } from "@/lib/db/queries";
import { FacebookIcon, InstagramIcon, LinkedinIcon, XIcon, YoutubeIcon } from "@/components/icons/SocialIcons";
import { BUDGET_BANDS } from "@/lib/search/budgetBands";
import { CONFIG_OPTIONS } from "@/lib/search/configOptions";
import { buildFilterPath } from "@/lib/search/pathFilter";
import { LAUNCH_CITY_SLUGS } from "@/lib/config/launchCities";
import { CALCULATORS } from "@/app/calculators/page";

const SOCIAL_LINKS = [
  { label: "Facebook", href: "#", icon: FacebookIcon },
  { label: "Instagram", href: "#", icon: InstagramIcon },
  { label: "X (Twitter)", href: "#", icon: XIcon },
  { label: "LinkedIn", href: "#", icon: LinkedinIcon },
  { label: "YouTube", href: "#", icon: YoutubeIcon },
];

const EXPLORE_LINKS = [
  { label: "New Projects", prefix: "new-projects-in-" },
  { label: "New Launch", prefix: "new-launch-in-" },
  { label: "Under Construction", prefix: "under-construction-in-" },
  { label: "Ready to Move", prefix: "ready-to-move-in-" },
];

const COMPANY_LINKS = [
  { label: "About Us", href: "/about-us" },
  { label: "Careers", href: "/career" },
  { label: "Blog", href: "/blog" },
  { label: "Compare Projects", href: "/compare" },
  { label: "Contact Us", href: "/contact-us" },
  { label: "Sitemap", href: "/sitemap" },
];

const FLAGSHIP_CITY = LAUNCH_CITY_SLUGS[0];

function FooterHeading({ children }: { children: React.ReactNode }) {
  return <h3 className="mb-3 text-sm font-semibold text-white">{children}</h3>;
}

function FooterLink({ href, children }: { href: string; children: React.ReactNode }) {
  return (
    <Link href={href} className="transition-colors hover:text-[#ff474c]">
      {children}
    </Link>
  );
}

export async function Footer() {
  const cities = await getFooterLocalities();

  return (
    <footer id="all-cities" className="scroll-mt-20 bg-[#30282c] text-sm text-slate-400">
      <div className="mx-auto max-w-7xl px-4 py-14">
        <div className="grid grid-cols-2 gap-8 md:grid-cols-5">
          <div className="col-span-2">
            <Link href="/" className="flex items-center gap-2 text-lg font-bold tracking-tight text-white">
              <span className="flex size-8 items-center justify-center rounded-lg bg-[#ff474c] text-white">
                <Building2 className="size-4.5" strokeWidth={2.5} />
              </span>
              <span>Home<span className="text-[#ff474c]">brix</span></span>
            </Link>
            <p className="mt-3 max-w-xs text-slate-400">
              India&apos;s fastest new builder projects portal — verified under-construction and new-launch homes
              across Mumbai, Navi Mumbai &amp; Thane.
            </p>
            <div className="mt-5 flex items-center gap-2 text-xs font-medium text-slate-400">
              <span className="rounded-full border border-slate-700 px-2.5 py-1">RERA Verified</span>
              <span className="rounded-full border border-slate-700 px-2.5 py-1">Zero Brokerage</span>
            </div>
            <div className="mt-5 flex gap-2">
              {SOCIAL_LINKS.map((social) => (
                <a
                  key={social.label}
                  href={social.href}
                  aria-label={social.label}
                  className="flex size-9 items-center justify-center rounded-full border border-slate-700 text-slate-400 transition-colors hover:border-[#ff474c] hover:text-[#ff474c]"
                >
                  <social.icon className="size-4" />
                </a>
              ))}
            </div>
          </div>

          {cities.map((city) => (
            <div key={city.slug}>
              <FooterHeading>Explore {city.name}</FooterHeading>
              <ul className="space-y-1.5">
                {EXPLORE_LINKS.map((link) => (
                  <li key={link.prefix}>
                    <FooterLink href={`/${link.prefix}${city.slug}`}>{link.label}</FooterLink>
                  </li>
                ))}
                <li>
                  <FooterLink href={`/builders-in-${city.slug}`}>Builders</FooterLink>
                </li>
                <li>
                  <FooterLink href={`/property-rates-in-${city.slug}`}>Property Rates</FooterLink>
                </li>
                <li>
                  <FooterLink href={`/${city.slug}-real-estate`}>{city.name} Real Estate</FooterLink>
                </li>
              </ul>
            </div>
          ))}
        </div>

        <div className="mt-10 grid grid-cols-2 gap-8 border-t border-slate-800 pt-10 md:grid-cols-4">
          {FLAGSHIP_CITY && (
            <div>
              <FooterHeading>Popular Searches</FooterHeading>
              <ul className="space-y-1.5">
                {CONFIG_OPTIONS.map((option) => (
                  <li key={option.label}>
                    <FooterLink
                      href={buildFilterPath(`new-projects-in-${FLAGSHIP_CITY}`, { bhk: option.bhk, bhkPlus: option.plus })}
                    >
                      {option.label} Flats
                    </FooterLink>
                  </li>
                ))}
              </ul>
            </div>
          )}

          {FLAGSHIP_CITY && (
            <div>
              <FooterHeading>Homes by Budget</FooterHeading>
              <ul className="space-y-1.5">
                {BUDGET_BANDS.map((band) => (
                  <li key={band.slug}>
                    <FooterLink
                      href={buildFilterPath(`new-projects-in-${FLAGSHIP_CITY}`, { budgetSlug: band.slug })}
                    >
                      {band.label}
                    </FooterLink>
                  </li>
                ))}
              </ul>
            </div>
          )}

          <div>
            <FooterHeading>Tools &amp; Calculators</FooterHeading>
            <ul className="space-y-1.5">
              {CALCULATORS.map((calc) => (
                <li key={calc.href}>
                  <FooterLink href={calc.href}>{calc.title}</FooterLink>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <FooterHeading>Company</FooterHeading>
            <ul className="space-y-1.5">
              {COMPANY_LINKS.map((link) => (
                <li key={link.href}>
                  <FooterLink href={link.href}>{link.label}</FooterLink>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {cities.some((c) => c.localities.length > 0) && (
          <div className="mt-10 grid grid-cols-2 gap-8 border-t border-slate-800 pt-10 md:grid-cols-4">
            {cities.map((city) => (
              <div key={city.slug}>
                <FooterHeading>Popular in {city.name}</FooterHeading>
                <ul className="space-y-1.5">
                  {city.localities.map((locality) => (
                    <li key={locality.slug}>
                      <FooterLink href={`/${city.slug}/${locality.slug}-real-estate`}>{locality.name}</FooterLink>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        )}
      </div>

      <div className="border-t border-slate-800">
        <div className="mx-auto max-w-7xl px-4 py-6 text-xs leading-relaxed text-slate-500">
          <span>Home<span className="text-[#ff474c]">brix</span></span> is a technology platform that lists builder projects and does not act as a broker or agent.
          RERA registration numbers and project approvals are as declared by the respective builders and are
          available on each project page — buyers are advised to independently verify all details before making
          a purchase decision.
        </div>
      </div>

      <div className="border-t border-slate-800">
        <div className="mx-auto flex max-w-7xl flex-col items-center justify-between gap-2 px-4 py-6 text-xs text-slate-500 md:flex-row">
          <p>© {new Date().getFullYear()} Homebrix. All rights reserved.</p>
          <div className="flex flex-wrap justify-center gap-x-4 gap-y-1">
            <Link href="/about-us" className="hover:text-[#ff474c]">About</Link>
            <Link href="/career" className="hover:text-[#ff474c]">Careers</Link>
            <Link href="/contact-us" className="hover:text-[#ff474c]">Contact</Link>
            <Link href="/privacy-policy" className="hover:text-[#ff474c]">Privacy</Link>
            <Link href="/terms-of-service" className="hover:text-[#ff474c]">Terms</Link>
            <Link href="/sitemap" className="hover:text-[#ff474c]">Sitemap</Link>
          </div>
        </div>
      </div>
    </footer>
  );
}

import type { Metadata } from "next";
import { notFound, permanentRedirect } from "next/navigation";
import { SearchResultsView } from "@/components/search/SearchResultsView";
import { BuilderDirectory } from "@/components/builder/BuilderDirectory";
import { CityLandingView } from "@/components/city/CityLandingView";
import { PropertyRatesView } from "@/components/city/PropertyRatesView";
import { getBuildersInCity, getCityBySlug, getCityLandingData, getPropertyRatesData } from "@/lib/db/queries";
import {
  parseBuildersInSlug,
  parseCityRealEstateSlug,
  parsePropertyRatesSlug,
  parseSearchSlug,
} from "@/lib/search/slugParser";
import { buildFilterPath } from "@/lib/search/pathFilter";
import { shouldNoIndexSearchPage } from "@/lib/seo/robots";
import { SITE_URL } from "@/lib/seo/site";

/**
 * Old `?bhk=2` / `?budget=...` query links (or anything a user might have
 * bookmarked) get permanently redirected to the equivalent SEO path so any
 * link equity consolidates onto the indexable URL instead of a 404 or a
 * second, non-canonical copy of the page.
 */
function legacyQueryRedirectTarget(
  baseSlug: string,
  searchParams: Record<string, string | string[] | undefined>
): string | null {
  const bhkParam = searchParams.bhk;
  const bhkValue = Array.isArray(bhkParam) ? bhkParam[0] : bhkParam;
  const bhk = bhkValue ? parseInt(bhkValue, 10) : undefined;

  const budgetSlug = typeof searchParams.budget === "string" ? searchParams.budget : undefined;

  if (!bhk && !budgetSlug) return null;
  return buildFilterPath(baseSlug, { bhk, budgetSlug });
}

export async function generateMetadata({
  params,
  searchParams,
}: {
  params: Promise<{ slug: string }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}): Promise<Metadata> {
  const { slug } = await params;
  const sp = await searchParams;

  const search = parseSearchSlug(slug);
  if (search) {
    const city = await getCityBySlug(search.citySlug);
    const cityName = city?.name ?? search.citySlug;
    return {
      title: `${search.heading} in ${cityName} | Homebrix`,
      description: `Browse verified ${search.heading.toLowerCase()} in ${cityName}. RERA verified, zero brokerage, floor plans and pricing.`,
      alternates: { canonical: `${SITE_URL}/${slug}` },
      robots: shouldNoIndexSearchPage(sp) ? { index: false, follow: true } : undefined,
    };
  }

  const buildersCitySlug = parseBuildersInSlug(slug);
  if (buildersCitySlug) {
    const city = await getCityBySlug(buildersCitySlug);
    const cityName = city?.name ?? buildersCitySlug;
    return {
      title: `Builders in ${cityName} | Homebrix`,
      description: `Browse verified builders with active projects in ${cityName}. RERA track record, trust scores and reviews.`,
      alternates: { canonical: `${SITE_URL}/${slug}` },
    };
  }

  const cityRealEstateSlug = parseCityRealEstateSlug(slug);
  if (cityRealEstateSlug) {
    const city = await getCityBySlug(cityRealEstateSlug);
    const cityName = city?.name ?? cityRealEstateSlug;
    return {
      title: `${cityName} Real Estate – New Projects, Price Trends | Homebrix`,
      description: `Explore new builder projects, top localities and price trends in ${cityName}.`,
      alternates: { canonical: `${SITE_URL}/${slug}` },
    };
  }

  const propertyRatesCitySlug = parsePropertyRatesSlug(slug);
  if (propertyRatesCitySlug) {
    const city = await getCityBySlug(propertyRatesCitySlug);
    const cityName = city?.name ?? propertyRatesCitySlug;
    return {
      title: `Property Rates in ${cityName} – Price Trends & Rate Trends | Homebrix`,
      description: `Average price per sqft, locality-wise rate comparison and appreciation trends in ${cityName}.`,
      alternates: { canonical: `${SITE_URL}/${slug}` },
    };
  }

  return {};
}

export default async function DynamicSlugPage({
  params,
  searchParams,
}: {
  params: Promise<{ slug: string }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const { slug } = await params;
  const sp = await searchParams;

  const search = parseSearchSlug(slug);
  if (search) {
    const redirectTarget = legacyQueryRedirectTarget(slug, sp);
    if (redirectTarget) permanentRedirect(redirectTarget);

    return (
      <SearchResultsView
        citySlug={search.citySlug}
        status={search.status}
        heading={search.heading}
        baseSlug={slug}
        rawSearchParams={sp}
      />
    );
  }

  const buildersCitySlug = parseBuildersInSlug(slug);
  if (buildersCitySlug) {
    const city = await getCityBySlug(buildersCitySlug);
    if (!city) notFound();
    const builders = await getBuildersInCity(buildersCitySlug);
    return <BuilderDirectory cityName={city.name} builders={builders} />;
  }

  const cityRealEstateSlug = parseCityRealEstateSlug(slug);
  if (cityRealEstateSlug) {
    const data = await getCityLandingData(cityRealEstateSlug);
    if (!data) notFound();
    return <CityLandingView data={data} />;
  }

  const propertyRatesCitySlug = parsePropertyRatesSlug(slug);
  if (propertyRatesCitySlug) {
    const data = await getPropertyRatesData(propertyRatesCitySlug);
    if (!data) notFound();
    return <PropertyRatesView data={data} />;
  }

  notFound();
}

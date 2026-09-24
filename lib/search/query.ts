import { prisma } from "@/lib/db/prisma";
import { getCityBySlug, getLocalityBySlug, getRegionBySlug } from "@/lib/db/queries";
import { LAUNCH_CITY_SLUGS } from "@/lib/config/launchCities";
import type { ConstructionStatusFilter, SearchFilters } from "@/lib/search/types";
import { PAGE_SIZE } from "@/lib/search/types";
import { parsePossessionRange } from "@/lib/search/possession";
import { buildProximityWhere } from "@/lib/search/proximityFilter";
import type { LaunchStage, Prisma } from "@/generated/prisma/client";

const projectCardInclude = {
  builder: { select: { name: true, slug: true, verified: true } },
  city: { select: { name: true, slug: true } },
  locality: { select: { name: true, slug: true } },
  configs: { select: { bhk: true }, orderBy: { bhk: "asc" } },
} as const;

export interface SearchScope {
  citySlug: string;
  localitySlug?: string;
  regionSlug?: string;
  status: ConstructionStatusFilter;
  /** Additional constraint derived from an SEO path segment (e.g. /2-bhk, /under-50-lakhs). */
  pathWhere?: Prisma.ProjectWhereInput;
}

/** Everything except locality/region and builder — the dimensions we compute per-option facet counts for. */
function buildBaseWhere(scope: SearchScope, filters: SearchFilters): Prisma.ProjectWhereInput {
  let where: Prisma.ProjectWhereInput = {
    published: true,
    city: { slug: scope.citySlug },
  };

  if (scope.status) {
    where.constructionStatus = scope.status;
  }

  if (filters.launchStage) {
    where.launchStage = filters.launchStage as LaunchStage;
  }

  if (filters.nearPlace) {
    const proxWhere = buildProximityWhere(filters.nearPlace, filters.withinKm);
    where = { AND: [where, proxWhere] };
  }

  if (filters.possessionRange) {
    const range = parsePossessionRange(filters.possessionRange);
    if (range) {
      where.possessionDate = {
        gte: new Date(range.start, 0, 1),
        lt: new Date(range.end + 1, 0, 1),
      };
    }
  }

  if (filters.reraOnly) {
    where.reraVerified = true;
  }

  // Overlap test: a project matches a price range if its own [min, max] band
  // intersects the requested range, not just if it starts inside it.
  if (filters.priceMin !== null) {
    where.priceMax = { gte: filters.priceMin };
  }
  if (filters.priceMax !== null) {
    where.priceMin = { lte: filters.priceMax };
  }

  if (filters.areaMin !== null) {
    where.areaMaxSqft = { gte: filters.areaMin };
  }
  if (filters.areaMax !== null) {
    where.areaMinSqft = { lte: filters.areaMax };
  }

  if (scope.pathWhere) {
    return { AND: [where, scope.pathWhere] };
  }

  return where;
}

/** A locality is the specific pick; a region is the broader belt — the URL carries at most one. */
function withGeo(
  where: Prisma.ProjectWhereInput,
  opts: { localitySlug?: string; regionSlug?: string }
): Prisma.ProjectWhereInput {
  if (opts.localitySlug) return { AND: [where, { locality: { slug: opts.localitySlug } }] };
  if (opts.regionSlug) return { AND: [where, { locality: { region: { slug: opts.regionSlug } } }] };
  return where;
}

function withBuilders(where: Prisma.ProjectWhereInput, builderSlugs: string[]): Prisma.ProjectWhereInput {
  return builderSlugs.length > 0 ? { AND: [where, { builder: { slug: { in: builderSlugs } } }] } : where;
}

function buildOrderBy(sort: SearchFilters["sort"]): Prisma.ProjectOrderByWithRelationInput {
  switch (sort) {
    case "price_asc":
      return { priceMin: "asc" };
    case "price_desc":
      return { priceMax: "desc" };
    case "possession":
      return { possessionDate: "asc" };
    case "newest":
      return { launchDate: "desc" };
    default:
      return { featured: "desc" };
  }
}

export interface FacetOption {
  slug: string;
  name: string;
  count: number;
}

async function localityFacets(where: Prisma.ProjectWhereInput): Promise<FacetOption[]> {
  const groups = await prisma.project.groupBy({ by: ["localityId"], where, _count: true });
  const ids = groups.map((g) => g.localityId).filter((id): id is number => id !== null);
  if (ids.length === 0) return [];
  const localities = await prisma.locality.findMany({ where: { id: { in: ids } } });
  return groups
    .map((g) => {
      const locality = localities.find((l) => l.id === g.localityId);
      return locality ? { slug: locality.slug, name: locality.name, count: g._count } : null;
    })
    .filter((f): f is FacetOption => f !== null)
    .sort((a, b) => b.count - a.count);
}

/** Rolls locality-level counts up to their region, since Prisma can't group by a two-hop relation directly. */
async function regionFacets(where: Prisma.ProjectWhereInput): Promise<FacetOption[]> {
  const groups = await prisma.project.groupBy({ by: ["localityId"], where, _count: true });
  const ids = groups.map((g) => g.localityId).filter((id): id is number => id !== null);
  if (ids.length === 0) return [];

  const localities = await prisma.locality.findMany({
    where: { id: { in: ids } },
    include: { region: true },
  });

  const countByRegion = new Map<string, FacetOption>();
  for (const g of groups) {
    const region = localities.find((l) => l.id === g.localityId)?.region;
    if (!region) continue;
    const existing = countByRegion.get(region.slug);
    if (existing) existing.count += g._count;
    else countByRegion.set(region.slug, { slug: region.slug, name: region.name, count: g._count });
  }

  return Array.from(countByRegion.values()).sort((a, b) => b.count - a.count);
}

/**
 * Project counts per launch city (Mumbai / Navi Mumbai / Thane) for the
 * current construction-status scope — powers a "Cities" facet that links
 * across search-hub pages. Scoped to LAUNCH_CITY_SLUGS like the homepage's
 * "Top Cities" section: these are the only markets with real region/locality
 * coverage today, so that's what's worth crawling between right now.
 */
async function cityFacets(status: ConstructionStatusFilter): Promise<FacetOption[]> {
  const groups = await prisma.project.groupBy({
    by: ["cityId"],
    where: { published: true, ...(status ? { constructionStatus: status } : {}) },
    _count: true,
  });
  const ids = groups.map((g) => g.cityId);
  if (ids.length === 0) return [];
  const cities = await prisma.city.findMany({
    where: { id: { in: ids }, isActive: true, slug: { in: LAUNCH_CITY_SLUGS } },
  });
  const facetsBySlug = new Map(
    groups
      .map((g) => {
        const city = cities.find((c) => c.id === g.cityId);
        return city ? ([city.slug, { slug: city.slug, name: city.name, count: g._count }] as const) : null;
      })
      .filter((f): f is readonly [string, FacetOption] => f !== null)
  );
  // Fixed Mumbai / Navi Mumbai / Thane order, matching the homepage's launch-city ordering.
  return LAUNCH_CITY_SLUGS.map((slug) => facetsBySlug.get(slug)).filter((f): f is FacetOption => f !== undefined);
}

async function builderFacets(where: Prisma.ProjectWhereInput): Promise<FacetOption[]> {
  const groups = await prisma.project.groupBy({ by: ["builderId"], where, _count: true });
  const ids = groups.map((g) => g.builderId);
  if (ids.length === 0) return [];
  const builders = await prisma.builder.findMany({ where: { id: { in: ids } } });
  return groups
    .map((g) => {
      const builder = builders.find((b) => b.id === g.builderId);
      return builder ? { slug: builder.slug, name: builder.name, count: g._count } : null;
    })
    .filter((f): f is FacetOption => f !== null)
    .sort((a, b) => b.count - a.count);
}

export async function searchProjects(scope: SearchScope, filters: SearchFilters) {
  const baseWhere = buildBaseWhere(scope, filters);
  const geoWhere = withGeo(baseWhere, { localitySlug: scope.localitySlug, regionSlug: scope.regionSlug });
  const mainWhere = withBuilders(geoWhere, filters.builderSlugs);
  const orderBy = buildOrderBy(filters.sort);

  const [
    projects,
    total,
    city,
    locality,
    region,
    localityFacetResults,
    regionFacetResults,
    builderFacetResults,
    cityFacetResults,
  ] = await Promise.all([
    prisma.project.findMany({
      where: mainWhere,
      orderBy,
      skip: (filters.page - 1) * PAGE_SIZE,
      take: PAGE_SIZE,
      include: projectCardInclude,
    }),
    prisma.project.count({ where: mainWhere }),
    getCityBySlug(scope.citySlug),
    scope.localitySlug ? getLocalityBySlug(scope.citySlug, scope.localitySlug) : Promise.resolve(null),
    scope.regionSlug ? getRegionBySlug(scope.citySlug, scope.regionSlug) : Promise.resolve(null),
    // Localities are scoped within the active region (if any) so picking a
    // region narrows the list to areas that actually belong to it.
    localityFacets(withBuilders(withGeo(baseWhere, { regionSlug: scope.regionSlug }), filters.builderSlugs)),
    // Regions always show the full city-wide breakdown so switching stays possible.
    regionFacets(withBuilders(baseWhere, filters.builderSlugs)),
    builderFacets(geoWhere),
    cityFacets(scope.status),
  ]);

  let fallbackProjects: typeof projects = [];
  if (total === 0) {
    const fallbackWhere: Prisma.ProjectWhereInput = {
      published: true,
      city: { slug: scope.citySlug },
      ...(scope.status ? { constructionStatus: scope.status } : {}),
    };
    fallbackProjects = await prisma.project.findMany({
      where: fallbackWhere,
      orderBy: { featured: "desc" },
      take: 4,
      include: projectCardInclude,
    });
  }

  return {
    projects,
    total,
    totalPages: Math.max(1, Math.ceil(total / PAGE_SIZE)),
    city,
    locality,
    region,
    localityFacets: localityFacetResults,
    regionFacets: regionFacetResults,
    builderFacets: builderFacetResults,
    cityFacets: cityFacetResults,
    fallbackProjects,
  };
}

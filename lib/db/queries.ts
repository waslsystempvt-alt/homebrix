import { cache } from "react";
import { prisma } from "@/lib/db/prisma";
import { LAUNCH_CITY_SLUGS } from "@/lib/config/launchCities";

export const getCityBySlug = cache(async (slug: string) => {
  return prisma.city.findUnique({ where: { slug } });
});

export const getLocalityBySlug = cache(async (citySlug: string, localitySlug: string) => {
  return prisma.locality.findFirst({ where: { slug: localitySlug, city: { slug: citySlug } } });
});

export const getRegionBySlug = cache(async (citySlug: string, regionSlug: string) => {
  return prisma.region.findFirst({ where: { slug: regionSlug, city: { slug: citySlug } } });
});

const projectCardInclude = {
  builder: { select: { name: true, slug: true, verified: true } },
  city: { select: { name: true, slug: true } },
  locality: { select: { name: true, slug: true } },
  configs: { select: { bhk: true }, orderBy: { bhk: "asc" } },
} as const;

export type ProjectCardData = NonNullable<
  Awaited<ReturnType<typeof getNewLaunchProjects>>
>[number];

export async function getTopCities(limit = 12) {
  return prisma.city.findMany({
    where: { isActive: true },
    orderBy: [{ sortOrder: "asc" }, { name: "asc" }],
    take: limit,
    include: {
      _count: { select: { projects: { where: { published: true } } } },
    },
  });
}

/** The homepage "Top Cities" section — scoped to the initial launch markets. */
export async function getLaunchCitiesWithCounts() {
  const cities = await prisma.city.findMany({
    where: { slug: { in: LAUNCH_CITY_SLUGS } },
    include: {
      _count: { select: { projects: { where: { published: true } } } },
    },
  });

  // Preserve LAUNCH_CITY_SLUGS order (Mumbai, Navi Mumbai, Thane) rather than DB order.
  return LAUNCH_CITY_SLUGS.map((slug) => cities.find((c) => c.slug === slug)).filter(
    (c): c is (typeof cities)[number] => c !== undefined
  );
}

export async function getNewLaunchProjects(limit = 8) {
  return prisma.project.findMany({
    where: { published: true, constructionStatus: "new_launch" },
    orderBy: { createdAt: "desc" },
    take: limit,
    include: projectCardInclude,
  });
}

export async function getUnderConstructionProjectsByCity(citySlug: string, limit = 6) {
  return prisma.project.findMany({
    where: {
      published: true,
      constructionStatus: "under_construction",
      city: { slug: citySlug },
    },
    orderBy: { createdAt: "desc" },
    take: limit,
    include: projectCardInclude,
  });
}

export async function getReadyToMoveProjects(limit = 8) {
  return prisma.project.findMany({
    where: { published: true, constructionStatus: "ready_to_move" },
    orderBy: { createdAt: "desc" },
    take: limit,
    include: projectCardInclude,
  });
}

export async function getProjectsByBudget(maxPrice: bigint, minPrice = BigInt(0), limit = 4) {
  return prisma.project.findMany({
    where: {
      published: true,
      priceMin: { gte: minPrice },
      priceMax: { lte: maxPrice },
    },
    orderBy: { createdAt: "desc" },
    take: limit,
    include: projectCardInclude,
  });
}

export async function getTopBuilders(limit = 8) {
  return prisma.builder.findMany({
    where: { verified: true },
    orderBy: [{ featured: "desc" }, { trustScore: "desc" }],
    take: limit,
    include: { _count: { select: { projects: true } } },
  });
}

/** Cities shown in the homepage's "Under Construction Projects" city tabs — scoped to the launch markets. */
export async function getLaunchCitiesWithProjects(limit = 5) {
  const cities = await prisma.city.findMany({
    where: {
      isActive: true,
      slug: { in: LAUNCH_CITY_SLUGS },
      projects: { some: { published: true, constructionStatus: "under_construction" } },
    },
    take: limit,
  });

  // Preserve LAUNCH_CITY_SLUGS order (Mumbai, Navi Mumbai, Thane) rather than DB order.
  return LAUNCH_CITY_SLUGS.map((slug) => cities.find((c) => c.slug === slug)).filter(
    (c): c is (typeof cities)[number] => c !== undefined
  );
}

export async function getMarketInsights(limit = 6) {
  const cities = await prisma.city.findMany({
    where: { isActive: true },
    take: limit,
    orderBy: { sortOrder: "asc" },
    include: {
      localities: { select: { avgPriceSqft: true }, where: { avgPriceSqft: { not: null } } },
    },
  });

  return cities
    .map((city) => {
      const prices = city.localities.map((l) => l.avgPriceSqft!).filter(Boolean);
      if (prices.length === 0) return null;
      const avg = Math.round(prices.reduce((a, b) => a + b, 0) / prices.length);
      return { city: city.name, slug: city.slug, avgPriceSqft: avg };
    })
    .filter((c): c is { city: string; slug: string; avgPriceSqft: number } => c !== null);
}

export const getProjectBySlug = cache(async (citySlug: string, projectSlug: string) => {
  return prisma.project.findFirst({
    where: { slug: projectSlug, city: { slug: citySlug }, published: true },
    include: {
      builder: true,
      city: true,
      locality: true,
      configs: { orderBy: { displayOrder: "asc" } },
      constructionUpdates: { orderBy: { updateDate: "desc" } },
      media: { orderBy: { displayOrder: "asc" } },
      faqs: { orderBy: { displayOrder: "asc" } },
      landmarks: {
        orderBy: { displayOrder: "asc" },
        include: { place: { select: { seoSlug: true, createSeoPage: true } } },
      },
    },
  });
});

export async function getSimilarProjects(cityId: number, excludeProjectId: string, limit = 4) {
  return prisma.project.findMany({
    where: { cityId, published: true, id: { not: excludeProjectId } },
    take: limit,
    orderBy: { featured: "desc" },
    include: projectCardInclude,
  });
}

export const getBuilderBySlug = cache(async (slug: string) => {
  return prisma.builder.findUnique({ where: { slug } });
});

export async function getBuilderProjects(builderId: string, limit = 50) {
  return prisma.project.findMany({
    where: { builderId, published: true },
    orderBy: { createdAt: "desc" },
    take: limit,
    include: projectCardInclude,
  });
}

export async function getBuildersInCity(citySlug: string) {
  return prisma.builder.findMany({
    where: { projects: { some: { published: true, city: { slug: citySlug } } } },
    orderBy: [{ featured: "desc" }, { trustScore: "desc" }],
    include: {
      _count: { select: { projects: { where: { published: true, city: { slug: citySlug } } } } },
    },
  });
}

export async function getCityLandingData(citySlug: string) {
  const city = await prisma.city.findUnique({
    where: { slug: citySlug },
    include: {
      localities: { orderBy: { avgPriceSqft: "desc" }, take: 8 },
    },
  });
  if (!city) return null;

  const [newLaunch, underConstruction, readyToMove, totalProjects, builders, nearbyCities] = await Promise.all([
    prisma.project.findMany({
      where: { published: true, cityId: city.id, constructionStatus: "new_launch" },
      take: 4,
      include: projectCardInclude,
    }),
    prisma.project.findMany({
      where: { published: true, cityId: city.id, constructionStatus: "under_construction" },
      take: 4,
      include: projectCardInclude,
    }),
    prisma.project.findMany({
      where: { published: true, cityId: city.id, constructionStatus: "ready_to_move" },
      take: 4,
      include: projectCardInclude,
    }),
    prisma.project.count({ where: { published: true, cityId: city.id } }),
    getBuildersInCity(citySlug),
    prisma.city.findMany({
      where: { isActive: true, id: { not: city.id }, stateId: city.stateId },
      take: 5,
      select: { name: true, slug: true },
    }),
  ]);

  const avgPriceSqft = city.localities.length
    ? Math.round(
        city.localities.reduce((sum, l) => sum + (l.avgPriceSqft ?? 0), 0) /
          city.localities.filter((l) => l.avgPriceSqft).length
      )
    : null;

  return {
    city,
    avgPriceSqft,
    totalProjects,
    newLaunch,
    underConstruction,
    readyToMove,
    builders,
    nearbyCities,
  };
}

export async function getLocalityLandingData(citySlug: string, localitySlug: string) {
  const locality = await getLocalityBySlug(citySlug, localitySlug);
  if (!locality) return null;
  const city = await getCityBySlug(citySlug);
  if (!city) return null;

  const [projects, nearbyLocalities, builders, places] = await Promise.all([
    prisma.project.findMany({
      where: { published: true, localityId: locality.id },
      include: projectCardInclude,
    }),
    prisma.locality.findMany({
      where: { cityId: city.id, id: { not: locality.id } },
      take: 5,
      orderBy: { avgPriceSqft: "desc" },
    }),
    prisma.builder.findMany({
      where: { projects: { some: { published: true, localityId: locality.id } } },
      take: 6,
    }),
    prisma.place.findMany({
      where: {
        OR: [{ localityId: locality.id }, { cityId: city.id }],
        createSeoPage: true,
        isActive: true,
      },
      take: 8,
      orderBy: { importanceScore: "desc" },
    }),
  ]);

  return { city, locality, projects, nearbyLocalities, builders, places };
}

export async function getPropertyRatesData(citySlug: string) {
  const city = await prisma.city.findUnique({
    where: { slug: citySlug },
    include: {
      localities: { orderBy: { avgPriceSqft: "desc" } },
    },
  });
  if (!city) return null;

  const [cityTrend, localityTrends] = await Promise.all([
    prisma.priceTrend.findMany({
      where: { cityId: city.id },
      orderBy: { periodEnd: "asc" },
    }),
    prisma.priceTrend.findMany({
      where: { localityId: { in: city.localities.map((l) => l.id) } },
      orderBy: { periodEnd: "desc" },
    }),
  ]);

  // Most recent trend row per locality — localityTrends is already sorted
  // newest-first, so the first hit per id is the latest one.
  const latestByLocality = new Map<number, (typeof localityTrends)[number]>();
  for (const trend of localityTrends) {
    if (trend.localityId !== null && !latestByLocality.has(trend.localityId)) {
      latestByLocality.set(trend.localityId, trend);
    }
  }

  const localityRates = city.localities.map((locality) => ({
    locality,
    latestTrend: latestByLocality.get(locality.id) ?? null,
  }));

  const mostAppreciated = [...localityRates]
    .filter((l) => l.latestTrend?.yoyChangePct != null)
    .sort((a, b) => Number(b.latestTrend!.yoyChangePct) - Number(a.latestTrend!.yoyChangePct))
    .slice(0, 5);

  const latestCityTrend = cityTrend.at(-1) ?? null;
  const avgPriceSqft =
    latestCityTrend?.avgPriceSqft ??
    (city.localities.length
      ? Math.round(
          city.localities.reduce((sum, l) => sum + (l.avgPriceSqft ?? 0), 0) /
            (city.localities.filter((l) => l.avgPriceSqft).length || 1)
        )
      : null);

  return {
    city,
    avgPriceSqft,
    latestCityTrend,
    cityTrend,
    localityRates,
    mostAppreciated,
  };
}

export const getStateBySlug = cache(async (slug: string) => {
  return prisma.state.findUnique({ where: { slug } });
});

export async function getAllStates() {
  return prisma.state.findMany({ orderBy: { name: "asc" } });
}

export async function getBlogPosts(category?: string) {
  return prisma.blogPost.findMany({
    where: { status: "published", ...(category ? { category } : {}) },
    orderBy: { publishedAt: "desc" },
    include: { author: { select: { name: true } } },
  });
}

export const getBlogPostBySlug = cache(async (slug: string) => {
  return prisma.blogPost.findUnique({
    where: { slug, status: "published" },
    include: { author: { select: { name: true } } },
  });
});

export async function getBlogCategories() {
  const posts = await prisma.blogPost.findMany({
    where: { status: "published" },
    select: { category: true },
    distinct: ["category"],
  });
  return posts.map((p) => p.category).filter((c): c is string => Boolean(c));
}

export async function getRelatedBlogPosts(category: string | null, excludeSlug: string, limit = 3) {
  return prisma.blogPost.findMany({
    where: { status: "published", category: category ?? undefined, slug: { not: excludeSlug } },
    take: limit,
    orderBy: { publishedAt: "desc" },
  });
}

/** Curated per-city locality links for the footer — scoped to the launch markets only. */
export async function getFooterLocalities() {
  const cities = await prisma.city.findMany({
    where: { slug: { in: LAUNCH_CITY_SLUGS } },
    include: {
      localities: { where: { isPopular: true }, orderBy: { projectCount: "desc" }, take: 8 },
    },
  });

  return LAUNCH_CITY_SLUGS.map((slug) => cities.find((c) => c.slug === slug)).filter(
    (c): c is (typeof cities)[number] => c !== undefined
  );
}

export async function getOpenJobs() {
  return prisma.job.findMany({ where: { status: "open" }, orderBy: { createdAt: "desc" } });
}

export const getJobBySlug = cache(async (slug: string) => {
  return prisma.job.findUnique({ where: { slug } });
});

/** Every locality in the launch markets, for the human-readable sitemap page. */
export async function getSitemapLocalities() {
  const cities = await prisma.city.findMany({
    where: { slug: { in: LAUNCH_CITY_SLUGS } },
    include: {
      localities: { orderBy: { name: "asc" } },
    },
  });

  return LAUNCH_CITY_SLUGS.map((slug) => cities.find((c) => c.slug === slug)).filter(
    (c): c is (typeof cities)[number] => c !== undefined
  );
}

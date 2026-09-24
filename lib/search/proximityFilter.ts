import type { Prisma } from "@/generated/prisma/client";

export function buildProximityWhere(nearPlace: string, withinKm: number | null): Prisma.ProjectWhereInput {
  const maxMeters = Math.round((withinKm ?? 5) * 1000);

  return {
    landmarks: {
      some: {
        OR: [
          { place: { slug: nearPlace } },
          { place: { seoSlug: nearPlace } },
          { name: { contains: nearPlace, mode: "insensitive" } },
        ],
        distanceM: { lte: maxMeters },
      },
    },
  };
}

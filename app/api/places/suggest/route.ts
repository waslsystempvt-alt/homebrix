import { NextResponse } from "next/server";
import { prisma } from "@/lib/db/prisma";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q")?.trim();
  const citySlug = searchParams.get("citySlug")?.trim();

  if (!q || q.length < 2) {
    return NextResponse.json([]);
  }

  try {
    // 1. Search Place master database
    const places = await prisma.place.findMany({
      where: {
        name: { contains: q, mode: "insensitive" },
        isActive: true,
        ...(citySlug ? { city: { slug: citySlug } } : {}),
      },
      take: 6,
      select: {
        id: true,
        name: true,
        slug: true,
        category: true,
      },
      orderBy: { importanceScore: "desc" },
    });

    if (places.length > 0) {
      return NextResponse.json(
        places.map((p) => ({
          name: p.name,
          slug: p.slug,
          category: p.category,
        }))
      );
    }

    // 2. Fallback: search ProjectLandmark distinct names if master table has no match yet
    const landmarks = await prisma.projectLandmark.groupBy({
      by: ["name", "category"],
      where: {
        name: { contains: q, mode: "insensitive" },
        ...(citySlug ? { project: { city: { slug: citySlug } } } : {}),
      },
      orderBy: { name: "asc" },
      take: 6,
    });

    return NextResponse.json(
      landmarks.map((l) => ({
        name: l.name,
        slug: l.name.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, ""),
        category: l.category,
      }))
    );
  } catch (err) {
    console.error("Place suggestion error:", err);
    return NextResponse.json([], { status: 500 });
  }
}

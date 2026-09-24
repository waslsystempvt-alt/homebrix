import { NextResponse } from "next/server";
import { prisma } from "@/lib/db/prisma";
import { parseNaturalLanguageQuery } from "@/lib/search/nlParse";

export async function POST(request: Request) {
  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid request body" }, { status: 400 });
  }

  const { query } = body as Record<string, unknown>;
  if (typeof query !== "string" || !query.trim()) {
    return NextResponse.json({ error: "Type what you're looking for first." }, { status: 400 });
  }

  const [cities, localities, places] = await Promise.all([
    prisma.city.findMany({ where: { isActive: true }, select: { name: true, slug: true } }),
    prisma.locality.findMany({
      select: { name: true, slug: true, city: { select: { slug: true } } },
    }),
    prisma.place.findMany({
      where: { isActive: true, createSeoPage: true },
      select: { name: true, slug: true, seoSlug: true },
    }),
  ]);

  const result = parseNaturalLanguageQuery(
    query,
    cities,
    localities.map((l) => ({ name: l.name, slug: l.slug, citySlug: l.city.slug })),
    places
  );

  if ("error" in result) {
    return NextResponse.json({ error: result.error }, { status: 422 });
  }

  return NextResponse.json(result);
}

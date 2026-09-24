"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db/prisma";
import type { LandmarkCategory, PlaceSource } from "@/generated/prisma/client";

function slugify(s: string) {
  return s.toLowerCase().trim().replace(/\s+/g, "-").replace(/[^a-z0-9-]/g, "");
}

function parsePlaceForm(formData: FormData) {
  const name = String(formData.get("name") ?? "").trim();
  const cityId = formData.get("cityId") ? Number(formData.get("cityId")) : null;
  const localityId = formData.get("localityId") ? Number(formData.get("localityId")) : null;

  // Auto-build slugs if not provided
  const slugInput = String(formData.get("slug") ?? "").trim();
  const seoSlugInput = String(formData.get("seoSlug") ?? "").trim();

  return {
    name,
    slug: slugInput || slugify(name),
    seoSlug: seoSlugInput || slugify(name), // caller should append city
    category: String(formData.get("category") ?? "other") as LandmarkCategory,
    cityId,
    localityId,
    lat: formData.get("lat") ? parseFloat(String(formData.get("lat"))) : null,
    lng: formData.get("lng") ? parseFloat(String(formData.get("lng"))) : null,
    address: String(formData.get("address") ?? "") || null,
    photoUrl: String(formData.get("photoUrl") ?? "") || null,
    rating: formData.get("rating") ? parseFloat(String(formData.get("rating"))) : null,
    reviewCount: formData.get("reviewCount") ? Number(formData.get("reviewCount")) : null,
    importanceScore: formData.get("importanceScore") ? Number(formData.get("importanceScore")) : 50,
    createSeoPage: formData.get("createSeoPage") === "on",
    seoPriority: formData.get("seoPriority") ? Number(formData.get("seoPriority")) : 0,
    source: String(formData.get("source") ?? "manual") as PlaceSource,
    verified: formData.get("verified") === "on",
    isActive: formData.get("isActive") !== "off",
  };
}

export async function createPlaceAction(formData: FormData) {
  const data = parsePlaceForm(formData);

  // Auto-build seoSlug: {place-slug}-{city-slug} if city is selected
  let seoSlug = data.slug;
  if (data.cityId) {
    const city = await prisma.city.findUnique({ where: { id: data.cityId }, select: { slug: true } });
    if (city) seoSlug = `${data.slug}-${city.slug}`;
  }

  await prisma.place.create({ data: { ...data, seoSlug } });
  revalidatePath("/admin/places");
  redirect("/admin/places");
}

export async function updatePlaceAction(id: string, formData: FormData) {
  const data = parsePlaceForm(formData);
  await prisma.place.update({ where: { id }, data });
  revalidatePath("/admin/places");
  redirect("/admin/places");
}

export async function toggleSeoPageAction(id: string, current: boolean) {
  await prisma.place.update({ where: { id }, data: { createSeoPage: !current } });
  revalidatePath("/admin/places");
}

export async function togglePlaceActiveAction(id: string, current: boolean) {
  await prisma.place.update({ where: { id }, data: { isActive: !current } });
  revalidatePath("/admin/places");
}

export async function deletePlaceAction(id: string) {
  await prisma.place.delete({ where: { id } });
  revalidatePath("/admin/places");
}

export async function bulkEnableTopLandmarksAction() {
  const topPlaces = await prisma.place.findMany({
    orderBy: { importanceScore: "desc" },
    take: 20,
    select: { id: true },
  });
  const ids = topPlaces.map((p) => p.id);
  if (ids.length > 0) {
    await prisma.place.updateMany({
      where: { id: { in: ids } },
      data: { createSeoPage: true },
    });
  }
  revalidatePath("/admin/places");
}

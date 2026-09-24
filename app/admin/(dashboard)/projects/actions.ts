"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db/prisma";
import type { Prisma } from "@/generated/prisma/client";

function slugify(s: string) {
  return s
    .toLowerCase()
    .trim()
    .replace(/\s+/g, "-")
    .replace(/[^a-z0-9-]/g, "");
}

/**
 * Builds the canonical project slug: {project-name}-{locality}-{city}
 * e.g. "lodha-crown-majiwada-thane"
 * This slug NEVER changes after first publish.
 */
async function buildProjectSlug(name: string, cityId: number, localityId?: number | null): Promise<string> {
  const [city, locality] = await Promise.all([
    prisma.city.findUnique({ where: { id: cityId }, select: { slug: true } }),
    localityId ? prisma.locality.findUnique({ where: { id: localityId }, select: { slug: true } }) : null,
  ]);
  const parts = [slugify(name)];
  if (locality?.slug) parts.push(locality.slug);
  if (city?.slug) parts.push(city.slug);
  return parts.join("-");
}

function parseProjectForm(formData: FormData) {
  const name = String(formData.get("name") ?? "");
  const cityId = Number(formData.get("cityId"));
  const localityIdRaw = formData.get("localityId");
  const constructionStatus = String(formData.get("constructionStatus") ?? "new_launch") as Prisma.ProjectUncheckedCreateInput["constructionStatus"];
  const launchStageRaw = formData.get("launchStage");

  return {
    name,
    builderId: String(formData.get("builderId") ?? ""),
    cityId,
    localityId: localityIdRaw ? Number(localityIdRaw) : null,
    address: String(formData.get("address") ?? "") || null,
    lat: formData.get("lat") ? parseFloat(String(formData.get("lat"))) : null,
    lng: formData.get("lng") ? parseFloat(String(formData.get("lng"))) : null,
    reraNumber: String(formData.get("reraNumber") ?? "") || null,
    reraVerified: formData.get("reraVerified") === "on",
    priceMin: formData.get("priceMin") ? BigInt(Number(formData.get("priceMin"))) : null,
    priceMax: formData.get("priceMax") ? BigInt(Number(formData.get("priceMax"))) : null,
    areaMinSqft: formData.get("areaMinSqft") ? Number(formData.get("areaMinSqft")) : null,
    areaMaxSqft: formData.get("areaMaxSqft") ? Number(formData.get("areaMaxSqft")) : null,
    totalUnits: formData.get("totalUnits") ? Number(formData.get("totalUnits")) : null,
    totalTowers: formData.get("totalTowers") ? Number(formData.get("totalTowers")) : null,
    totalFloors: formData.get("totalFloors") ? Number(formData.get("totalFloors")) : null,
    launchDate: formData.get("launchDate") ? new Date(String(formData.get("launchDate"))) : null,
    possessionDate: formData.get("possessionDate") ? new Date(String(formData.get("possessionDate"))) : null,
    constructionStatus,
    launchStage: launchStageRaw ? (String(launchStageRaw) as Prisma.ProjectUncheckedCreateInput["launchStage"]) : null,
    description: String(formData.get("description") ?? "") || null,
    metaTitle: String(formData.get("metaTitle") ?? "") || null,
    metaDesc: String(formData.get("metaDesc") ?? "") || null,
    published: formData.get("published") === "on",
    featured: formData.get("featured") === "on",
    newLaunchBadge: constructionStatus === "new_launch",
  };
}

export async function createProjectAction(formData: FormData) {
  const data = parseProjectForm(formData);
  const slug = await buildProjectSlug(data.name, data.cityId, data.localityId);
  await prisma.project.create({ data: { ...data, slug } });
  revalidatePath("/admin/projects");
  redirect("/admin/projects");
}

export async function updateProjectAction(id: string, formData: FormData) {
  // The slug is intentionally left untouched on update — regenerating it from the
  // name would silently break any existing links to this project's page.
  const data = parseProjectForm(formData);
  await prisma.project.update({ where: { id }, data });
  revalidatePath("/admin/projects");
  redirect("/admin/projects");
}

export async function togglePublishedAction(id: string, published: boolean) {
  await prisma.project.update({ where: { id }, data: { published: !published } });
  revalidatePath("/admin/projects");
}

export async function toggleFeaturedAction(id: string, featured: boolean) {
  await prisma.project.update({ where: { id }, data: { featured: !featured } });
  revalidatePath("/admin/projects");
}

export async function deleteProjectAction(id: string) {
  await prisma.project.delete({ where: { id } });
  revalidatePath("/admin/projects");
}

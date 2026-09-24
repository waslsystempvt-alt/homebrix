"use server";

import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db/prisma";
import type { LandmarkCategory, TravelMode, PlaceSource } from "@/generated/prisma/client";

function slugify(s: string) {
  return s.toLowerCase().trim().replace(/\s+/g, "-").replace(/[^a-z0-9-]/g, "");
}

/**
 * Add a landmark/highlight to a project.
 * Auto-links to the Place master table if a matching slug exists.
 */
export async function addHighlightAction(projectId: string, formData: FormData) {
  const name = String(formData.get("name") ?? "").trim();
  const category = String(formData.get("category") ?? "") as LandmarkCategory;
  const distanceMRaw = formData.get("distanceM");
  const distanceM = distanceMRaw ? Number(distanceMRaw) : null;

  // Auto-generate distance label if not provided
  const distanceLabelInput = String(formData.get("distanceLabel") ?? "").trim();
  const distanceLabel =
    distanceLabelInput ||
    (distanceM
      ? distanceM < 1000
        ? `${distanceM}m`
        : `${(distanceM / 1000).toFixed(1)}km`
      : null);

  // Try to auto-link to existing Place by name match
  const nameSlug = slugify(name);
  const existingPlace = await prisma.place.findFirst({
    where: { slug: { contains: nameSlug } },
    select: { id: true },
  });

  await prisma.projectLandmark.create({
    data: {
      projectId,
      placeId: existingPlace?.id ?? null,
      name,
      category,
      distanceM,
      distanceLabel,
      travelMinutes: formData.get("travelMinutes") ? Number(formData.get("travelMinutes")) : null,
      travelMode: (String(formData.get("travelMode") ?? "drive")) as TravelMode,
      showOnMap: formData.get("showOnMap") !== "off",
      isFeatured: formData.get("isFeatured") === "on",
      source: (String(formData.get("source") ?? "manual")) as PlaceSource,
      displayOrder: formData.get("displayOrder") ? Number(formData.get("displayOrder")) : 0,
    },
  });

  revalidatePath(`/admin/projects/${projectId}`);
}

export async function deleteHighlightAction(highlightId: string, projectId: string) {
  await prisma.projectLandmark.delete({ where: { id: highlightId } });
  revalidatePath(`/admin/projects/${projectId}`);
}

export async function toggleFeaturedHighlightAction(
  highlightId: string,
  projectId: string,
  current: boolean,
) {
  await prisma.projectLandmark.update({
    where: { id: highlightId },
    data: { isFeatured: !current },
  });
  revalidatePath(`/admin/projects/${projectId}`);
}

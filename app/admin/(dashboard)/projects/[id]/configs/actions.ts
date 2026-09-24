"use server";

import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db/prisma";
import type { Prisma } from "@/generated/prisma/client";

export async function addConfigAction(projectId: string, formData: FormData) {
  await prisma.projectConfig.create({
    data: {
      projectId,
      bhk: Number(formData.get("bhk")),
      areaCarpetMin: formData.get("areaCarpetMin") ? Number(formData.get("areaCarpetMin")) : null,
      areaCarpetMax: formData.get("areaCarpetMax") ? Number(formData.get("areaCarpetMax")) : null,
      areaBuiltupMin: formData.get("areaBuiltupMin") ? Number(formData.get("areaBuiltupMin")) : null,
      areaBuiltupMax: formData.get("areaBuiltupMax") ? Number(formData.get("areaBuiltupMax")) : null,
      priceMin: formData.get("priceMin") ? BigInt(Number(formData.get("priceMin"))) : null,
      priceMax: formData.get("priceMax") ? BigInt(Number(formData.get("priceMax"))) : null,
      floorPlanUrl: String(formData.get("floorPlanUrl") ?? "") || null,
      isAvailable: formData.get("isAvailable") !== "off",
      displayOrder: formData.get("displayOrder") ? Number(formData.get("displayOrder")) : 0,
    },
  });

  await syncProjectStats(projectId);
  revalidatePath(`/admin/projects/${projectId}`);
}

export async function deleteConfigAction(configId: string, projectId: string) {
  await prisma.projectConfig.delete({ where: { id: configId } });
  await syncProjectStats(projectId);
  revalidatePath(`/admin/projects/${projectId}`);
}

async function syncProjectStats(projectId: string) {
  const configs = await prisma.projectConfig.findMany({
    where: { projectId },
    select: { priceMin: true, priceMax: true, bhk: true },
  });
  const prices = configs.flatMap((c) => [c.priceMin, c.priceMax].filter((p): p is bigint => p !== null));
  const bhkSet = new Set<number>();
  for (const c of configs) {
    if (c.bhk !== null && c.bhk !== undefined) bhkSet.add(c.bhk);
  }
  const bhkTypes = Array.from(bhkSet).sort((a, b) => a - b);

  const updateData: Prisma.ProjectUpdateInput = { bhkTypes };
  if (prices.length) {
    updateData.priceMin = prices.reduce((a, b) => (a < b ? a : b));
    updateData.priceMax = prices.reduce((a, b) => (a > b ? a : b));
  }

  await prisma.project.update({
    where: { id: projectId },
    data: updateData,
  });
}

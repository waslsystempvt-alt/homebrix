"use server";

import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db/prisma";

export async function toggleBuilderVerifiedAction(id: string, verified: boolean) {
  await prisma.builder.update({ where: { id }, data: { verified: !verified } });
  revalidatePath("/admin/builders");
}

export async function toggleBuilderFeaturedAction(id: string, featured: boolean) {
  await prisma.builder.update({ where: { id }, data: { featured: !featured } });
  revalidatePath("/admin/builders");
}

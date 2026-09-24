"use server";

import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db/prisma";
import { $Enums } from "@/generated/prisma/client";

const VALID_STATUSES = new Set(Object.values($Enums.LeadStatus));

export async function updateLeadStatusAction(id: string, status: string) {
  if (!VALID_STATUSES.has(status as $Enums.LeadStatus)) return;
  await prisma.lead.update({ where: { id }, data: { status: status as $Enums.LeadStatus } });
  revalidatePath("/admin/leads");
}

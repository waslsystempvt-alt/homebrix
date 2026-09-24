"use server";

import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db/prisma";
import { $Enums } from "@/generated/prisma/client";

const VALID_STATUSES = new Set(Object.values($Enums.JobApplicationStatus));

export async function updateJobApplicationStatusAction(id: string, status: string) {
  if (!VALID_STATUSES.has(status as $Enums.JobApplicationStatus)) return;
  await prisma.jobApplication.update({ where: { id }, data: { status: status as $Enums.JobApplicationStatus } });
  revalidatePath("/admin/job-applications");
}

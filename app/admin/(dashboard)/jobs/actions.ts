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

function parseJobForm(formData: FormData) {
  const title = String(formData.get("title") ?? "");
  const requirements = String(formData.get("requirements") ?? "")
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);

  return {
    title,
    department: String(formData.get("department") ?? ""),
    location: String(formData.get("location") ?? ""),
    type: String(formData.get("type") ?? "Full-time"),
    description: String(formData.get("description") ?? ""),
    requirements,
    status: String(formData.get("status") ?? "open") as Prisma.JobUncheckedCreateInput["status"],
  };
}

export async function createJobAction(formData: FormData) {
  const data = parseJobForm(formData);
  await prisma.job.create({ data: { ...data, slug: slugify(data.title) } });
  revalidatePath("/admin/jobs");
  revalidatePath("/career");
  redirect("/admin/jobs");
}

export async function updateJobAction(id: string, formData: FormData) {
  // The slug is intentionally left untouched on update — regenerating it from the
  // title would silently break any existing links to this job's page.
  const data = parseJobForm(formData);
  await prisma.job.update({ where: { id }, data });
  revalidatePath("/admin/jobs");
  revalidatePath("/career");
  redirect("/admin/jobs");
}

export async function deleteJobAction(id: string) {
  await prisma.job.delete({ where: { id } });
  revalidatePath("/admin/jobs");
  revalidatePath("/career");
}

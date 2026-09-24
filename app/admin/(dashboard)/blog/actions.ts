"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/db/prisma";
import type { Prisma } from "@/generated/prisma/client";

const SEED_EDITOR_ID = "seed-editor";

function slugify(s: string) {
  return s
    .toLowerCase()
    .trim()
    .replace(/\s+/g, "-")
    .replace(/[^a-z0-9-]/g, "");
}

function parseContentBlocks(raw: string) {
  const blocks = raw
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean)
    .map((line) =>
      line.startsWith("## ")
        ? { type: "heading" as const, text: line.slice(3).trim() }
        : { type: "paragraph" as const, text: line }
    );
  return { blocks };
}

function estimateReadingTime(raw: string): number {
  const words = raw.trim().split(/\s+/).filter(Boolean).length;
  return Math.max(1, Math.round(words / 200));
}

function parseBlogForm(formData: FormData) {
  const title = String(formData.get("title") ?? "");
  const contentRaw = String(formData.get("content") ?? "");
  const thumbnailUrl = String(formData.get("thumbnailUrl") ?? "").trim();
  const tags = String(formData.get("tags") ?? "")
    .split(",")
    .map((t) => t.trim())
    .filter(Boolean);
  const status = String(formData.get("status") ?? "draft") as Prisma.BlogPostUncheckedCreateInput["status"];

  return {
    title,
    category: String(formData.get("category") ?? "") || null,
    excerpt: String(formData.get("excerpt") ?? "") || null,
    content: parseContentBlocks(contentRaw),
    thumbnailUrl: thumbnailUrl || null,
    tags,
    readingTime: estimateReadingTime(contentRaw),
    status,
  };
}

export async function createBlogPostAction(formData: FormData) {
  const data = parseBlogForm(formData);
  await prisma.blogPost.create({
    data: {
      ...data,
      slug: slugify(data.title),
      authorId: SEED_EDITOR_ID,
      publishedAt: data.status === "published" ? new Date() : null,
    },
  });
  revalidatePath("/admin/blog");
  revalidatePath("/blog");
  redirect("/admin/blog");
}

export async function updateBlogPostAction(id: string, formData: FormData) {
  // The slug is intentionally left untouched on update — regenerating it from the
  // title would silently break any existing links to this post.
  const data = parseBlogForm(formData);
  const existing = await prisma.blogPost.findUnique({ where: { id }, select: { publishedAt: true } });
  const publishedAt =
    data.status === "published" ? (existing?.publishedAt ?? new Date()) : null;

  await prisma.blogPost.update({ where: { id }, data: { ...data, publishedAt } });
  revalidatePath("/admin/blog");
  revalidatePath("/blog");
  redirect("/admin/blog");
}

export async function deleteBlogPostAction(id: string) {
  await prisma.blogPost.delete({ where: { id } });
  revalidatePath("/admin/blog");
  revalidatePath("/blog");
}

export async function toggleBlogStatusAction(id: string, currentStatus: string) {
  const nextStatus = currentStatus === "published" ? "draft" : "published";
  await prisma.blogPost.update({
    where: { id },
    data: {
      status: nextStatus,
      publishedAt: nextStatus === "published" ? new Date() : null,
    },
  });
  revalidatePath("/admin/blog");
  revalidatePath("/blog");
}

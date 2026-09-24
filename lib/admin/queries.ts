import { prisma } from "@/lib/db/prisma";

export async function getDashboardStats() {
  const startOfToday = new Date();
  startOfToday.setHours(0, 0, 0, 0);
  const startOfMonth = new Date(startOfToday.getFullYear(), startOfToday.getMonth(), 1);

  const [activeProjects, leadsToday, publishedThisMonth, totalLeads, leadsByStatus] = await Promise.all([
    prisma.project.count({ where: { projectStatus: "active" } }),
    prisma.lead.count({ where: { createdAt: { gte: startOfToday } } }),
    prisma.project.count({ where: { publishedAt: { gte: startOfMonth } } }),
    prisma.lead.count(),
    prisma.lead.groupBy({ by: ["status"], _count: true }),
  ]);

  return { activeProjects, leadsToday, publishedThisMonth, totalLeads, leadsByStatus };
}

export async function getAdminProjects() {
  return prisma.project.findMany({
    orderBy: { createdAt: "desc" },
    include: { builder: { select: { name: true } }, city: { select: { name: true, slug: true } } },
  });
}

export async function getAdminProjectById(id: string) {
  return prisma.project.findUnique({
    where: { id },
    include: { configs: true },
  });
}

export async function getAdminLeads() {
  return prisma.lead.findMany({
    orderBy: { createdAt: "desc" },
    take: 100,
    include: { project: { select: { name: true } }, builder: { select: { name: true } } },
  });
}

export async function getAdminBuilders() {
  return prisma.builder.findMany({
    orderBy: { createdAt: "desc" },
    include: { _count: { select: { projects: true } } },
  });
}

export async function getAdminBlogPosts() {
  return prisma.blogPost.findMany({ orderBy: { createdAt: "desc" } });
}

export async function getAdminBlogPostById(id: string) {
  return prisma.blogPost.findUnique({ where: { id } });
}

export async function getAdminJobApplications() {
  return prisma.jobApplication.findMany({ orderBy: { createdAt: "desc" }, take: 100 });
}

export async function getAdminJobs() {
  return prisma.job.findMany({ orderBy: { createdAt: "desc" } });
}

export async function getAdminJobById(id: string) {
  return prisma.job.findUnique({ where: { id } });
}

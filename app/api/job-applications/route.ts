import { NextResponse } from "next/server";
import { prisma } from "@/lib/db/prisma";
import { getJobBySlug } from "@/lib/db/queries";

const BARE_INDIA_PHONE_REGEX = /^[6-9]\d{9}$/;
const INDIA_PHONE_REGEX = /^\+91[6-9]\d{9}$/;
const INTL_PHONE_REGEX = /^\+\d{7,15}$/;

function isValidPhone(phone: string): boolean {
  if (BARE_INDIA_PHONE_REGEX.test(phone)) return true;
  return phone.startsWith("+91") ? INDIA_PHONE_REGEX.test(phone) : INTL_PHONE_REGEX.test(phone);
}

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export async function POST(request: Request) {
  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid request body" }, { status: 400 });
  }

  const { jobSlug, name, email, phone, resumeUrl, coverLetter } = body as Record<string, unknown>;

  if (typeof name !== "string" || !name.trim()) {
    return NextResponse.json({ error: "Enter your name" }, { status: 400 });
  }
  if (typeof email !== "string" || !EMAIL_REGEX.test(email)) {
    return NextResponse.json({ error: "Enter a valid email" }, { status: 400 });
  }
  if (typeof phone !== "string" || !isValidPhone(phone)) {
    return NextResponse.json({ error: "Enter a valid phone number" }, { status: 400 });
  }
  if (typeof resumeUrl !== "string" || !resumeUrl.trim()) {
    return NextResponse.json({ error: "Upload your resume" }, { status: 400 });
  }

  const job = typeof jobSlug === "string" ? await getJobBySlug(jobSlug) : undefined;

  const application = await prisma.jobApplication.create({
    data: {
      jobSlug: job?.slug ?? "general",
      jobTitle: job?.title ?? "General Application",
      name: name.trim(),
      email: email.trim(),
      phone,
      resumeUrl: resumeUrl.trim(),
      coverLetter: typeof coverLetter === "string" && coverLetter.trim() ? coverLetter.trim() : null,
      status: "new",
    },
  });

  return NextResponse.json({ id: application.id }, { status: 201 });
}

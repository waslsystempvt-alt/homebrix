import { NextResponse } from "next/server";
import { prisma } from "@/lib/db/prisma";
import { $Enums } from "@/generated/prisma/client";

const BARE_INDIA_PHONE_REGEX = /^[6-9]\d{9}$/;
const INDIA_PHONE_REGEX = /^\+91[6-9]\d{9}$/;
const INTL_PHONE_REGEX = /^\+\d{7,15}$/;
const VALID_LEAD_TYPES = new Set(Object.values($Enums.LeadType));

/**
 * Accepts a bare 10-digit Indian mobile (no country code, from forms that don't
 * offer a country picker), a "+91"-prefixed Indian number, or a generic
 * "+"-prefixed international number from the country-code dropdown.
 */
function isValidPhone(phone: string): boolean {
  if (BARE_INDIA_PHONE_REGEX.test(phone)) return true;
  return phone.startsWith("+91") ? INDIA_PHONE_REGEX.test(phone) : INTL_PHONE_REGEX.test(phone);
}

function parseLeadType(value: unknown): $Enums.LeadType {
  return typeof value === "string" && VALID_LEAD_TYPES.has(value as $Enums.LeadType)
    ? (value as $Enums.LeadType)
    : "contact_form";
}

export async function POST(request: Request) {
  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid request body" }, { status: 400 });
  }

  const { name, phone, email, projectId, builderId, bhk, message, leadType, pageUrl } = body as Record<string, unknown>;

  if (typeof phone !== "string" || !isValidPhone(phone)) {
    return NextResponse.json({ error: "Enter a valid phone number" }, { status: 400 });
  }

  const resolvedMessage =
    typeof message === "string" && message.trim()
      ? message.trim()
      : typeof bhk === "string"
        ? `Interested in ${bhk}`
        : null;

  const lead = await prisma.lead.create({
    data: {
      name: typeof name === "string" && name.trim() ? name.trim() : null,
      phone,
      email: typeof email === "string" && email.trim() ? email.trim() : null,
      projectId: typeof projectId === "string" ? projectId : null,
      builderId: typeof builderId === "string" ? builderId : null,
      message: resolvedMessage,
      leadType: parseLeadType(leadType),
      source: "direct",
      pageUrl: typeof pageUrl === "string" ? pageUrl : null,
      status: "new",
    },
  });

  if (typeof projectId === "string") {
    await prisma.project.update({
      where: { id: projectId },
      data: { leadCount: { increment: 1 } },
    });
  }

  return NextResponse.json({ id: lead.id }, { status: 201 });
}

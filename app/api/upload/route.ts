import { NextResponse } from "next/server";
import { mkdir, writeFile } from "fs/promises";
import path from "path";
import { randomUUID } from "crypto";
import { cookies } from "next/headers";
import { ADMIN_SESSION_COOKIE, isValidSessionToken } from "@/lib/admin/session";

interface UploadRules {
  mimeTypes: string[];
  extensions: string[];
  maxBytes: number;
  requiresAdmin: boolean;
}

const UPLOAD_TARGETS: Record<string, UploadRules> = {
  resumes: {
    mimeTypes: [
      "application/pdf",
      "application/msword",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    ],
    extensions: [".pdf", ".doc", ".docx"],
    maxBytes: 5 * 1024 * 1024,
    requiresAdmin: false,
  },
  "blog-images": {
    mimeTypes: ["image/jpeg", "image/png", "image/webp"],
    extensions: [".jpg", ".jpeg", ".png", ".webp"],
    maxBytes: 5 * 1024 * 1024,
    requiresAdmin: true,
  },
};

export async function POST(request: Request) {
  const formData = await request.formData();
  const file = formData.get("file");
  const folder = String(formData.get("folder") ?? "");

  const rules = UPLOAD_TARGETS[folder];
  if (!rules) {
    return NextResponse.json({ error: "Invalid upload target" }, { status: 400 });
  }

  if (rules.requiresAdmin) {
    const cookieStore = await cookies();
    const token = cookieStore.get(ADMIN_SESSION_COOKIE)?.value;
    if (!isValidSessionToken(token)) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }
  }

  if (!(file instanceof File)) {
    return NextResponse.json({ error: "No file provided" }, { status: 400 });
  }
  if (file.size === 0) {
    return NextResponse.json({ error: "File is empty" }, { status: 400 });
  }
  if (file.size > rules.maxBytes) {
    return NextResponse.json({ error: "File too large (max 5MB)" }, { status: 400 });
  }

  const ext = path.extname(file.name).toLowerCase();
  if (!rules.extensions.includes(ext) || !rules.mimeTypes.includes(file.type)) {
    return NextResponse.json(
      { error: `Unsupported file type. Allowed: ${rules.extensions.join(", ")}` },
      { status: 400 }
    );
  }

  const dir = path.join(process.cwd(), "public", "uploads", folder);
  await mkdir(dir, { recursive: true });
  const filename = `${randomUUID()}${ext}`;
  const buffer = Buffer.from(await file.arrayBuffer());
  await writeFile(path.join(dir, filename), buffer);

  return NextResponse.json({ url: `/uploads/${folder}/${filename}` }, { status: 201 });
}

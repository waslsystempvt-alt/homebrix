"use client";

import { useState } from "react";
import Image from "next/image";
import { Check, Copy, MessagesSquare, Scale, ShieldCheck, Wrench } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { Card } from "@/components/ui/card";

const RERA_BENEFITS: { icon: LucideIcon; title: string; desc: string }[] = [
  { icon: Scale, title: "Dispute Resolution", desc: "Fair resolution within 120 days" },
  { icon: Wrench, title: "Quality Standards", desc: "Builders accountable for construction" },
  { icon: ShieldCheck, title: "Legal Safeguards", desc: "Formal grievance redressal system" },
  { icon: MessagesSquare, title: "Progress Tracking", desc: "Full visibility into project updates" },
];

export function ReraInfoSection({
  projectName,
  reraNumber,
  cityName,
}: {
  projectName: string;
  reraNumber: string;
  cityName: string;
}) {
  const [copied, setCopied] = useState(false);
  const qrSrc = `https://api.qrserver.com/v1/create-qr-code/?size=140x140&data=${encodeURIComponent(reraNumber)}`;

  async function handleCopy() {
    try {
      await navigator.clipboard.writeText(reraNumber);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      // Clipboard API unavailable (e.g. insecure context) — nothing safe to fall back to.
    }
  }

  return (
    <section className="space-y-3">
      <h2 className="text-xl font-bold">RERA Information</h2>

      <Card className="rounded-2xl p-4 shadow-sm space-y-4">
        <div className="flex flex-wrap items-center gap-4">
          <Image
            src={qrSrc}
            alt={`QR code for RERA number ${reraNumber}`}
            width={64}
            height={64}
            unoptimized
            className="rounded-lg border shrink-0"
          />
          <div className="min-w-0 flex-1">
            <p className="font-semibold truncate">{projectName}</p>
            <p className="font-mono text-sm text-muted-foreground">{reraNumber}</p>
            <p className="text-xs text-muted-foreground">Registered under RERA, {cityName}</p>
          </div>
          <button
            type="button"
            onClick={handleCopy}
            className="flex shrink-0 items-center gap-1.5 rounded-lg border px-3 py-2 text-sm font-medium transition-colors hover:bg-muted"
          >
            {copied ? <Check className="size-4 text-success" /> : <Copy className="size-4" />}
            {copied ? "Copied" : "Copy"}
          </button>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 border-t pt-4">
          {RERA_BENEFITS.map((b) => (
            <div key={b.title} className="flex items-start gap-2">
              <span className="flex size-7 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary">
                <b.icon className="size-3.5" />
              </span>
              <div className="min-w-0">
                <p className="text-xs font-semibold leading-tight">{b.title}</p>
                <p className="text-[11px] text-muted-foreground leading-tight">{b.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </Card>
    </section>
  );
}

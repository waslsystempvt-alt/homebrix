"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { CheckCircle2, Tag } from "lucide-react";
import { WhatsAppIcon } from "@/components/icons/WhatsAppIcon";

const COUNTRY_CODES = [
  { code: "+91", flag: "🇮🇳", label: "India" },
  { code: "+971", flag: "🇦🇪", label: "UAE" },
  { code: "+1", flag: "🇺🇸", label: "US/Canada" },
  { code: "+44", flag: "🇬🇧", label: "UK" },
  { code: "+65", flag: "🇸🇬", label: "Singapore" },
  { code: "+61", flag: "🇦🇺", label: "Australia" },
];

export function LeadForm({
  projectId,
  builderId,
  projectName,
}: {
  projectId: string;
  builderId: string;
  projectName: string;
}) {
  const [name, setName] = useState("");
  const [countryCode, setCountryCode] = useState("+91");
  const [phone, setPhone] = useState("");
  const [consent, setConsent] = useState(false);
  const [homeLoanInterest, setHomeLoanInterest] = useState(false);
  const [status, setStatus] = useState<"idle" | "submitting" | "success" | "error">("idle");
  const [error, setError] = useState<string | null>(null);

  const maxPhoneLength = countryCode === "+91" ? 10 : 14;
  const isPhoneValid = countryCode === "+91" ? phone.length === 10 : phone.length >= 6;

  async function handleSubmit(e: React.FormEvent, leadType: string) {
    e.preventDefault();
    setStatus("submitting");
    setError(null);

    try {
      const res = await fetch("/api/leads", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name,
          phone: `${countryCode}${phone}`,
          projectId,
          builderId,
          leadType,
          message: homeLoanInterest ? "Interested in Home Loans" : undefined,
          pageUrl: typeof window !== "undefined" ? window.location.pathname : undefined,
        }),
      });

      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error ?? "Something went wrong");
      }

      setStatus("success");
    } catch (err) {
      setStatus("error");
      setError(err instanceof Error ? err.message : "Something went wrong");
    }
  }

  if (status === "success") {
    return (
      <Card className="rounded-2xl p-6 text-center space-y-2 shadow-sm">
        <CheckCircle2 className="size-8 text-success mx-auto" />
        <p className="font-semibold">Thanks! We&apos;ve received your enquiry.</p>
        <p className="text-sm text-muted-foreground">
          You&apos;ll get a callback about {projectName} within 30 minutes.
        </p>
      </Card>
    );
  }

  return (
    <Card className="overflow-hidden rounded-2xl p-0 shadow-sm">
      <div className="flex items-center gap-3 bg-gradient-to-br from-primary to-primary/80 px-6 py-5 text-primary-foreground">
        <span className="flex size-10 shrink-0 items-center justify-center rounded-full bg-white/20">
          <Tag className="size-5" />
        </span>
        <div>
          <h3 className="font-bold text-lg leading-tight">Get Best Price</h3>
          <p className="text-xs text-primary-foreground/80">Talk to our property expert</p>
        </div>
      </div>

      <form className="space-y-3 p-6" onSubmit={(e) => handleSubmit(e, "contact_form")}>
        <div className="space-y-1.5">
          <Label htmlFor="lead-name">Name</Label>
          <Input id="lead-name" value={name} onChange={(e) => setName(e.target.value)} placeholder="Your name" />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="lead-phone">Phone</Label>
          <div className="flex gap-2">
            <Select
              value={countryCode}
              onValueChange={(v) => {
                setCountryCode(v);
                setPhone("");
              }}
            >
              <SelectTrigger className="w-[92px] shrink-0">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {COUNTRY_CODES.map((c) => (
                  <SelectItem key={c.code} value={c.code}>
                    {c.flag} {c.code}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <Input
              id="lead-phone"
              value={phone}
              onChange={(e) => setPhone(e.target.value.replace(/\D/g, "").slice(0, maxPhoneLength))}
              placeholder="Mobile number"
              inputMode="numeric"
              className="flex-1"
            />
          </div>
        </div>

        {error && <p className="text-sm text-destructive">{error}</p>}

        <div className="flex gap-2 pt-1">
          <Button
            type="submit"
            variant="outline"
            className="h-11 flex-1 gap-1.5 rounded-xl"
            disabled={status === "submitting" || !isPhoneValid || !consent}
          >
            <Tag className="size-4" />
            {status === "submitting" ? "Submitting..." : "Get Details"}
          </Button>
          <Button type="button" className="h-11 flex-1 gap-1.5 rounded-xl bg-[#25D366] text-white hover:bg-[#1ebe5d]" asChild>
            <a
              href={`https://wa.me/919999999999?text=${encodeURIComponent(`Hi, I'm interested in ${projectName}`)}`}
              target="_blank"
              rel="noopener noreferrer"
            >
              <WhatsAppIcon className="size-4" /> WhatsApp
            </a>
          </Button>
        </div>

        <div className="space-y-2 pt-1">
          <div className="flex items-start gap-2">
            <Checkbox
              id="lead-consent"
              checked={consent}
              onCheckedChange={(c) => setConsent(c === true)}
              className="mt-0.5"
            />
            <Label htmlFor="lead-consent" className="text-xs font-normal leading-snug text-muted-foreground cursor-pointer">
              I agree to be contacted by Homebrix and agents via WhatsApp, SMS, phone etc.
            </Label>
          </div>
          <div className="flex items-center gap-2">
            <Checkbox
              id="lead-home-loan"
              checked={homeLoanInterest}
              onCheckedChange={(c) => setHomeLoanInterest(c === true)}
            />
            <Label htmlFor="lead-home-loan" className="text-xs font-normal text-muted-foreground cursor-pointer">
              I am interested in Home Loans
            </Label>
          </div>
        </div>

        <p className="text-xs text-muted-foreground text-center pt-1">✓ Free · No Spam</p>
      </form>
    </Card>
  );
}

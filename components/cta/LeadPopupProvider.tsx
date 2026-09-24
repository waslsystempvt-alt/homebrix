"use client";

import { createContext, useCallback, useContext, useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { BadgeIndianRupee, Building2, CheckCircle2, Clock, Mail, Phone, ShieldCheck, User } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { cn } from "@/lib/utils";

export type LeadPopupType = "contact_form" | "brochure" | "site_visit" | "callback";

export interface LeadPopupContext {
  /** The CTA's own label — shown as the popup title, e.g. "Download Brochure". */
  ctaName: string;
  subtitle?: string;
  leadType: LeadPopupType;
  project?: { id: string; name: string; builderId?: string };
}

interface LeadPopupState extends LeadPopupContext {
  open: boolean;
}

const BENEFITS: { icon: LucideIcon; title: string; desc: string; iconClass: string }[] = [
  { icon: ShieldCheck, title: "RERA Verified", desc: "Every project checked for compliance", iconClass: "bg-primary/15 text-primary" },
  { icon: BadgeIndianRupee, title: "Zero Brokerage", desc: "No hidden fees, ever", iconClass: "bg-amber-500/15 text-amber-600" },
  { icon: Clock, title: "Fast Response", desc: "Callback within 30 minutes", iconClass: "bg-sky-500/15 text-sky-600" },
];

const COUNTRY_CODES = ["+91", "+971", "+1", "+44", "+65", "+61"];

const LeadPopupCtx = createContext<((ctx: LeadPopupContext) => void) | null>(null);

export function useLeadPopup() {
  const ctx = useContext(LeadPopupCtx);
  if (!ctx) throw new Error("useLeadPopup must be used within a LeadPopupProvider");
  return ctx;
}

export function LeadPopupProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState<LeadPopupState | null>(null);

  const openLeadPopup = useCallback((ctx: LeadPopupContext) => {
    setState({ ...ctx, open: true });
  }, []);

  const setOpen = useCallback((open: boolean) => {
    setState((prev) => (prev ? { ...prev, open } : prev));
  }, []);

  return (
    <LeadPopupCtx.Provider value={openLeadPopup}>
      {children}
      {state && (
        <Dialog open={state.open} onOpenChange={setOpen}>
          <DialogContent className="p-0 overflow-hidden sm:max-w-2xl">
            <LeadPopupForm key={`${state.ctaName}-${state.project?.id ?? "none"}`} state={state} />
          </DialogContent>
        </Dialog>
      )}
    </LeadPopupCtx.Provider>
  );
}

function LeadPopupForm({ state }: { state: LeadPopupState }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [countryCode, setCountryCode] = useState("+91");
  const [phone, setPhone] = useState("");
  const [consent, setConsent] = useState(false);
  const [status, setStatus] = useState<"idle" | "submitting" | "success" | "error">("idle");
  const [error, setError] = useState<string | null>(null);

  const isPhoneValid = countryCode === "+91" ? phone.length === 10 : phone.length >= 6;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setStatus("submitting");
    setError(null);

    try {
      const res = await fetch("/api/leads", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name,
          email,
          phone: `${countryCode}${phone}`,
          projectId: state.project?.id,
          builderId: state.project?.builderId,
          leadType: state.leadType,
          message: state.ctaName,
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
      <div className="p-10 text-center space-y-2">
        <CheckCircle2 className="size-10 text-success mx-auto" />
        <p className="font-semibold text-lg">Thanks! We&apos;ve got your request.</p>
        <p className="text-sm text-muted-foreground">
          {state.project ? `Our team will reach out about ${state.project.name} shortly.` : "Our team will call you back shortly."}
        </p>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-[260px_1fr]">
      {/* Benefits panel */}
      <div className="bg-gradient-to-br from-primary/15 via-primary/5 to-background p-6 sm:p-7">
        {/* Mobile: title + compact benefit badges */}
        <div className="sm:hidden">
          <h2 className="text-xl font-bold pr-8 mb-4">{state.ctaName}</h2>
          <div className="grid grid-cols-3 gap-2">
            {BENEFITS.map((b) => (
              <div key={b.title} className="rounded-xl bg-background/70 p-2.5 text-center">
                <span className={cn("mx-auto mb-1.5 flex size-9 items-center justify-center rounded-full", b.iconClass)}>
                  <b.icon className="size-4.5" />
                </span>
                <p className="text-[11px] font-semibold leading-tight">{b.title}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Desktop: full "why choose us" panel */}
        <div className="hidden sm:block sm:space-y-5">
          <h2 className="text-lg font-bold">Why Choose Homebrix</h2>
          <div className="space-y-4">
            {BENEFITS.map((b) => (
              <div key={b.title} className="flex items-start gap-3">
                <span className={cn("flex size-9 shrink-0 items-center justify-center rounded-full", b.iconClass)}>
                  <b.icon className="size-4.5" />
                </span>
                <div>
                  <p className="font-semibold text-sm leading-tight">{b.title}</p>
                  <p className="text-xs text-muted-foreground mt-0.5">{b.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Form panel */}
      <div className="p-6 sm:p-7 space-y-5">
        <DialogTitle className="sr-only">{state.ctaName}</DialogTitle>
        <div className="flex items-center gap-3">
          <span className="flex size-10 shrink-0 items-center justify-center rounded-lg bg-primary text-primary-foreground">
            <Building2 className="size-5" strokeWidth={2.5} />
          </span>
          <div>
            <p className="text-xs font-medium text-muted-foreground">Exclusive Access</p>
            <p className="font-bold leading-tight">{state.ctaName}</p>
          </div>
        </div>
        {(state.subtitle || state.project) && (
          <p className="text-sm text-muted-foreground -mt-3">
            {state.subtitle ?? `About ${state.project?.name}`}
          </p>
        )}

        <form className="space-y-3.5" onSubmit={handleSubmit}>
          <div className="space-y-1.5">
            <Label htmlFor="popup-name">Name</Label>
            <div className="relative">
              <Input
                id="popup-name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Your name"
                className="h-11 rounded-xl pr-10"
              />
              <User className="absolute right-3.5 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
            </div>
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="popup-email">Email (optional)</Label>
            <div className="relative">
              <Input
                id="popup-email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Email ID"
                className="h-11 rounded-xl pr-10"
              />
              <Mail className="absolute right-3.5 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
            </div>
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="popup-phone">Phone</Label>
            <div className="flex gap-2">
              <Select value={countryCode} onValueChange={(v) => { setCountryCode(v); setPhone(""); }}>
                <SelectTrigger className="h-11 w-[80px] shrink-0 rounded-xl">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {COUNTRY_CODES.map((c) => (
                    <SelectItem key={c} value={c}>
                      {c}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <div className="relative flex-1">
                <Input
                  id="popup-phone"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value.replace(/\D/g, "").slice(0, countryCode === "+91" ? 10 : 14))}
                  placeholder="Phone Number"
                  inputMode="numeric"
                  className="h-11 rounded-xl pr-10"
                />
                <Phone className="absolute right-3.5 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
              </div>
            </div>
          </div>

          {error && <p className="text-sm text-destructive">{error}</p>}

          <Button
            type="submit"
            className="h-12 w-full gap-2 rounded-xl text-base font-bold"
            disabled={status === "submitting" || !isPhoneValid || !consent}
          >
            <Phone className="size-4" />
            {status === "submitting" ? "Submitting..." : "Contact Now"}
          </Button>

          <div className="flex items-start gap-2">
            <Checkbox id="popup-consent" checked={consent} onCheckedChange={(c) => setConsent(c === true)} className="mt-0.5" />
            <label htmlFor="popup-consent" className="text-xs font-normal leading-snug text-muted-foreground cursor-pointer">
              Submitting means you accept the{" "}
              <Link href="/privacy-policy" className="underline hover:text-foreground">Privacy Policy</Link> &amp;{" "}
              <Link href="/terms-of-service" className="underline hover:text-foreground">Terms</Link>.
            </label>
          </div>
        </form>
      </div>
    </div>
  );
}

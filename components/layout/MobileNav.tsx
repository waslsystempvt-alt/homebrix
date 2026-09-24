"use client";

import { useState } from "react";
import Link from "next/link";
import { Building2, Menu } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetTitle, SheetTrigger } from "@/components/ui/sheet";
import { CtaButton } from "@/components/cta/CtaButton";

export function MobileNav({ links }: { links: { label: string; href: string }[] }) {
  const [open, setOpen] = useState(false);

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger asChild>
        <Button variant="ghost" size="icon" className="lg:hidden" aria-label="Open menu">
          <Menu className="size-5" />
        </Button>
      </SheetTrigger>
      <SheetContent side="right" className="w-[86%] gap-0 p-0 sm:max-w-sm">
        <SheetTitle className="sr-only">Navigation menu</SheetTitle>

        <div className="flex items-center gap-2 border-b px-5 py-4 text-lg font-bold tracking-tight">
          <span className="flex size-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
            <Building2 className="size-4.5" strokeWidth={2.5} />
          </span>
          <span>Home<span className="text-[#ff474c]">brix</span></span>
        </div>

        <nav className="flex flex-col px-2 py-3">
          {links.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              onClick={() => setOpen(false)}
              className="rounded-lg px-3 py-2.5 text-[0.95rem] font-medium transition-colors hover:bg-muted hover:text-primary"
            >
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="mt-auto border-t p-5">
          <CtaButton
            ctaName="Talk to an Expert"
            leadType="contact_form"
            className="h-11 w-full rounded-full text-base"
            onClick={() => setOpen(false)}
          >
            Talk to an Expert
          </CtaButton>
        </div>
      </SheetContent>
    </Sheet>
  );
}

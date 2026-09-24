import Link from "next/link";
import { Home, Heart, Wrench, Phone } from "lucide-react";
import { CtaButton } from "@/components/cta/CtaButton";
import { MobileNav } from "@/components/layout/MobileNav";

const NAV_LINKS = [
  { label: "New Projects", href: "/new-projects-in-mumbai" },
  { label: "Ready to Move", href: "/ready-to-move-in-mumbai" },
  { label: "Builders", href: "/builders-in-mumbai" },
  { label: "Property Rates", href: "/property-rates-in-mumbai" },
  { label: "Tools", href: "/calculators" },
  { label: "Blog", href: "/blog" },
];

export function Header() {
  return (
    <header className="sticky top-0 z-40 border-b bg-white/95 backdrop-blur-md">
      <div className="mx-auto flex h-18 max-w-7xl items-center justify-between gap-4 px-4 sm:px-6">
        {/* Logo */}
        <Link href="/" className="group flex shrink-0 items-center gap-2">
          <span className="flex size-9 items-center justify-center rounded-xl bg-[#ff474c] text-white shadow-xs">
            <Home className="size-5" strokeWidth={2.2} />
          </span>
          <div className="flex flex-col">
            <span className="font-sans text-2xl font-bold tracking-tight text-[#0F172A] leading-none">
              Home<span className="text-[#ff474c]">brix</span>
            </span>
            <span className="text-[9px] font-medium text-muted-foreground tracking-wider uppercase leading-tight mt-0.5">
              Find your place.
            </span>
          </div>
        </Link>

        {/* Right Action Items */}
        <div className="flex shrink-0 items-center gap-3">
          <Link
            href="/compare"
            className="flex items-center justify-center size-9 rounded-full hover:bg-gray-100 text-gray-700 transition-colors"
            title="Wishlist & Compare"
          >
            <Heart className="size-4" />
          </Link>

          <Link
            href="/calculators"
            className="flex items-center justify-center size-9 rounded-full hover:bg-gray-100 text-gray-700 transition-colors"
            title="Tools and calculators"
            aria-label="Tools and calculators"
          >
            <Wrench className="size-4" />
          </Link>

          <Link
            href="/admin/login"
            className="hidden 2xl:inline-flex px-4 py-1.5 text-sm font-medium text-gray-700 hover:text-[#ff474c] transition-colors"
          >
            Login
          </Link>

          <CtaButton
            ctaName="Talk to an Expert"
            leadType="contact_form"
            className="hidden sm:inline-flex h-10 rounded-lg bg-[#ff474c] hover:bg-[#ed343a] text-white font-medium px-4 text-xs gap-1.5 shadow-sm"
          >
            <Phone className="size-3.5 fill-current" />
            Talk to an Expert
          </CtaButton>

          <MobileNav links={NAV_LINKS} />

        </div>
      </div>
    </header>
  );
}

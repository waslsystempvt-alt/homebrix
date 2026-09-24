import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "About Us | Homebrix",
  description: "Homebrix is India's fastest new builder projects portal — under-construction, new launch, and ready-to-move homes.",
};

export default function AboutUsPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 space-y-4">
      <h1 className="text-3xl font-bold mb-4">About Homebrix</h1>
      <p className="text-muted-foreground">
        Homebrix is a new builder projects portal focused exclusively on under-construction and new-launch homes
        across India. We don&apos;t list resale properties — every project on Homebrix is posted and verified by
        our internal team.
      </p>
      <p className="text-muted-foreground">
        Our goal is simple: help home buyers find verified, RERA-registered projects with transparent pricing,
        real floor plans, and construction updates — and help builders reach genuine, organic demand without
        paying for low-quality leads.
      </p>
      <p className="text-muted-foreground">
        Built with a modern, fast, SEO-first tech stack, Homebrix aims to be the quickest way to discover and
        compare new homes in India.
      </p>
    </div>
  );
}

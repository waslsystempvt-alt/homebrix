import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Terms of Service | Homebrix",
  robots: { index: false, follow: true },
};

export default function TermsOfServicePage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 space-y-4">
      <h1 className="text-3xl font-bold mb-4">Terms of Service</h1>
      <p className="text-muted-foreground">
        Homebrix is a listings and lead-generation platform. We do not own, develop, or sell any of the
        properties listed on this site — all projects are posted by our internal team on behalf of the
        respective builders.
      </p>
      <p className="text-muted-foreground">
        By using Homebrix, you agree that pricing, availability, and possession dates are indicative and
        subject to change by the builder. Buyers should independently verify RERA registration, approvals,
        and project details before making any payment.
      </p>
      <p className="text-muted-foreground">
        This is placeholder content for a development build — replace with reviewed legal terms before
        launching to production.
      </p>
    </div>
  );
}

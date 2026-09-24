import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Privacy Policy | Homebrix",
  robots: { index: false, follow: true },
};

export default function PrivacyPolicyPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 space-y-4">
      <h1 className="text-3xl font-bold mb-4">Privacy Policy</h1>
      <p className="text-muted-foreground">
        When you submit an enquiry, schedule a site visit, or contact us, we collect your name, phone number,
        and any message you provide. This information is shared with the relevant builder so they can respond
        to your enquiry, and is used internally for our lead management.
      </p>
      <p className="text-muted-foreground">
        We do not sell your personal data to third parties. You can request that your data be deleted by
        contacting us via the Contact Us page.
      </p>
      <p className="text-muted-foreground">
        This is placeholder content for a development build — replace with a reviewed privacy policy before
        launching to production.
      </p>
    </div>
  );
}

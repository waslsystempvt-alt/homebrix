import type { Metadata } from "next";
import { ContactForm } from "@/components/contact/ContactForm";

export const metadata: Metadata = {
  title: "Contact Us | Homebrix",
  description: "Get in touch with the Homebrix team.",
};

export default function ContactUsPage() {
  return (
    <div className="mx-auto max-w-lg px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">Contact Us</h1>
      <p className="text-muted-foreground mb-8">Have a question? We&apos;d love to hear from you.</p>
      <ContactForm />
    </div>
  );
}

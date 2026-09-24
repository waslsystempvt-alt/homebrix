"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { CheckCircle2 } from "lucide-react";
import { FileUploadField } from "@/components/upload/FileUploadField";

export function JobApplicationForm({ jobSlug, jobTitle }: { jobSlug: string; jobTitle: string }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [resumeUrl, setResumeUrl] = useState("");
  const [coverLetter, setCoverLetter] = useState("");
  const [status, setStatus] = useState<"idle" | "submitting" | "success" | "error">("idle");
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setStatus("submitting");
    setError(null);

    try {
      const res = await fetch("/api/job-applications", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ jobSlug, name, email, phone, resumeUrl, coverLetter }),
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
      <Card className="p-8 text-center space-y-2">
        <CheckCircle2 className="size-8 text-success mx-auto" />
        <p className="font-semibold">Application received!</p>
        <p className="text-sm text-muted-foreground">
          Thanks for applying to {jobTitle === "General Application" ? "Homebrix" : `the ${jobTitle} role`}.
          We&apos;ll reach out if it&apos;s a fit.
        </p>
      </Card>
    );
  }

  return (
    <Card className="p-6">
      <form className="space-y-4" onSubmit={handleSubmit}>
        <div className="space-y-1.5">
          <Label htmlFor="job-name">Full Name</Label>
          <Input id="job-name" value={name} onChange={(e) => setName(e.target.value)} required />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="job-email">Email</Label>
          <Input id="job-email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="job-phone">Phone</Label>
          <Input
            id="job-phone"
            value={phone}
            onChange={(e) => setPhone(e.target.value.replace(/\D/g, "").slice(0, 10))}
            inputMode="numeric"
            placeholder="10-digit mobile number"
            required
          />
        </div>
        <FileUploadField
          folder="resumes"
          accept=".pdf,.doc,.docx"
          label="Resume (PDF or Word, max 5MB)"
          onUploaded={setResumeUrl}
        />
        <div className="space-y-1.5">
          <Label htmlFor="job-cover">Why you? (optional)</Label>
          <textarea
            id="job-cover"
            className="w-full rounded-md border bg-transparent px-3 py-2 text-sm min-h-24"
            value={coverLetter}
            onChange={(e) => setCoverLetter(e.target.value)}
            placeholder="A couple of lines on why this role is a fit"
          />
        </div>
        {error && <p className="text-sm text-destructive">{error}</p>}
        <Button
          type="submit"
          className="w-full"
          disabled={status === "submitting" || phone.length !== 10 || !resumeUrl.trim()}
        >
          {status === "submitting" ? "Submitting..." : "Submit Application"}
        </Button>
      </form>
    </Card>
  );
}

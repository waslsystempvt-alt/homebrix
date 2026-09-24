import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft, Briefcase, CheckCircle2, MapPin } from "lucide-react";
import { getJobBySlug } from "@/lib/db/queries";
import { JobApplicationForm } from "@/components/career/JobApplicationForm";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  if (slug === "general") {
    return { title: "General Application | Homebrix Careers" };
  }
  const job = await getJobBySlug(slug);
  if (!job) return {};
  return {
    title: `${job.title} | Homebrix Careers`,
    description: job.description,
  };
}

export default async function JobDetailPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;

  if (slug === "general") {
    return (
      <div className="mx-auto max-w-2xl px-4 py-12 space-y-6">
        <Link href="/career" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-primary">
          <ArrowLeft className="size-4" /> Back to all roles
        </Link>
        <div>
          <h1 className="text-2xl font-bold mb-2">General Application</h1>
          <p className="text-muted-foreground">
            Don&apos;t see a role that matches? Tell us about yourself and what you&apos;d want to work on — we
            keep every application on file and reach out when something fits.
          </p>
        </div>
        <JobApplicationForm jobSlug="general" jobTitle="General Application" />
      </div>
    );
  }

  const job = await getJobBySlug(slug);
  if (!job) notFound();

  return (
    <div className="mx-auto max-w-2xl px-4 py-12 space-y-8">
      <Link href="/career" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-primary">
        <ArrowLeft className="size-4" /> Back to all roles
      </Link>

      <div>
        <h1 className="text-2xl font-bold mb-2">{job.title}</h1>
        <p className="text-sm text-muted-foreground flex items-center gap-3">
          <span className="flex items-center gap-1">
            <Briefcase className="size-3.5" />
            {job.department} · {job.type}
          </span>
          <span className="flex items-center gap-1">
            <MapPin className="size-3.5" />
            {job.location}
          </span>
        </p>
      </div>

      <div className="space-y-4">
        <p className="text-muted-foreground">{job.description}</p>
        {job.requirements.length > 0 && (
          <div>
            <p className="font-semibold text-sm mb-2">What we&apos;re looking for</p>
            <ul className="space-y-1.5">
              {job.requirements.map((req) => (
                <li key={req} className="flex items-start gap-2 text-sm text-muted-foreground">
                  <CheckCircle2 className="size-4 text-primary shrink-0 mt-0.5" />
                  {req}
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>

      {job.status === "open" ? (
        <div>
          <h2 className="text-lg font-bold mb-3">Apply for this role</h2>
          <JobApplicationForm jobSlug={job.slug} jobTitle={job.title} />
        </div>
      ) : (
        <p className="rounded-xl border bg-muted/30 p-4 text-sm text-muted-foreground">
          This role is no longer accepting applications.{" "}
          <Link href="/career/general" className="text-primary hover:underline">
            Submit a general application
          </Link>{" "}
          instead.
        </p>
      )}
    </div>
  );
}

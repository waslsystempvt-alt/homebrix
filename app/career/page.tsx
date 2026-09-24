import type { Metadata } from "next";
import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Briefcase, Heart, MapPin, Rocket, Users } from "lucide-react";
import { getOpenJobs } from "@/lib/db/queries";

export const metadata: Metadata = {
  title: "Careers | Homebrix",
  description: "Open roles at Homebrix — India's fastest new builder projects portal for Mumbai, Navi Mumbai and Thane.",
};

const VALUES = [
  { icon: Rocket, title: "Move Fast", desc: "We ship weekly and value action over lengthy planning." },
  { icon: Users, title: "Customer First", desc: "Every decision starts with what's best for home buyers." },
  { icon: Heart, title: "Own Your Work", desc: "Small team, real ownership — your work ships to real users." },
];

export default async function CareerPage() {
  const jobs = await getOpenJobs();

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 space-y-12">
      <div>
        <h1 className="text-3xl font-bold mb-3">Careers at Homebrix</h1>
        <p className="text-muted-foreground">
          We&apos;re a small team building India&apos;s fastest new builder projects portal, currently focused on
          Mumbai, Navi Mumbai and Thane. Here&apos;s what&apos;s open right now.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {VALUES.map((v) => (
          <div key={v.title} className="rounded-xl border p-4">
            <v.icon className="size-6 text-primary mb-2" />
            <p className="font-semibold text-sm">{v.title}</p>
            <p className="text-sm text-muted-foreground mt-1">{v.desc}</p>
          </div>
        ))}
      </div>

      <div className="space-y-4">
        <h2 className="text-xl font-bold">Open Roles ({jobs.length})</h2>
        {jobs.length === 0 && (
          <p className="text-muted-foreground text-sm">No open roles right now — check back soon.</p>
        )}
        <div className="space-y-3">
          {jobs.map((job) => (
            <Link key={job.slug} href={`/career/${job.slug}`}>
              <Card className="p-5 hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between gap-4">
                  <div>
                    <p className="font-semibold">{job.title}</p>
                    <p className="text-sm text-muted-foreground flex items-center gap-3 mt-1">
                      <span className="flex items-center gap-1">
                        <Briefcase className="size-3.5" />
                        {job.department}
                      </span>
                      <span className="flex items-center gap-1">
                        <MapPin className="size-3.5" />
                        {job.location}
                      </span>
                    </p>
                  </div>
                  <span className="text-sm font-medium text-primary shrink-0">View &amp; Apply →</span>
                </div>
              </Card>
            </Link>
          ))}
        </div>
      </div>

      <div className="rounded-2xl border bg-muted/30 p-6 text-center">
        <p className="font-semibold mb-1">Don&apos;t see an open role that fits?</p>
        <p className="text-sm text-muted-foreground mb-4">
          Send us your resume and tell us what you&apos;d want to work on — we read every application.
        </p>
        <Button asChild>
          <Link href="/career/general">Submit a General Application</Link>
        </Button>
      </div>
    </div>
  );
}

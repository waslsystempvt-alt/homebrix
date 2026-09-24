import Link from "next/link";
import { Card } from "@/components/ui/card";
import { BadgeCheck } from "lucide-react";
import { getTopBuilders } from "@/lib/db/queries";
import { getInitials } from "@/lib/utils/initials";
import { SectionHeading } from "@/components/home/SectionHeading";

export async function BuilderStrip() {
  const builders = await getTopBuilders(8);
  if (builders.length === 0) return null;

  return (
    <section className="mx-auto max-w-7xl px-4 py-14">
      <SectionHeading kicker="TRUSTED PARTNERS" title="Top Builders" subtitle="Ranked by delivery record, RERA compliance, and construction quality." />
      <div className="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-8 gap-4">
        {builders.map((builder) => (
          <Link key={builder.id} href={`/builder/${builder.slug}`}>
            <Card className="flex flex-col items-center justify-center p-4 text-center rounded-2xl border border-slate-200/80 bg-white shadow-2xs transition-all duration-300 hover:-translate-y-1 hover:border-[#ff474c]/30 hover:shadow-lg">
              <div className="flex size-11 items-center justify-center rounded-full bg-rose-50 text-xs font-bold text-[#ff474c] border border-rose-100 mb-2">
                {getInitials(builder.name)}
              </div>
              <p className="flex items-center justify-center gap-1 text-xs font-bold text-slate-900 line-clamp-1">
                {builder.name}
                {builder.verified && <BadgeCheck className="size-3.5 shrink-0 text-[#ff474c]" />}
              </p>
              <p className="text-[11px] font-medium text-slate-500 mt-0.5">{builder._count.projects} projects</p>
            </Card>
          </Link>
        ))}
      </div>
    </section>
  );
}

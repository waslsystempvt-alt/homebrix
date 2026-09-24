import Link from "next/link";
import { ArrowRight } from "lucide-react";

export function SectionHeading({
  kicker,
  title,
  subtitle,
  viewAllHref,
  viewAllLabel = "View All",
  align = "left",
}: {
  kicker?: string;
  title: string;
  subtitle?: string;
  viewAllHref?: string;
  viewAllLabel?: string;
  align?: "left" | "center";
}) {
  return (
    <div
      className={
        align === "center"
          ? "mb-10 flex flex-col items-center text-center"
          : "mb-9 flex flex-wrap items-end justify-between gap-5"
      }
    >
      <div>
        {kicker && (
          <p
            className={
              "mb-2 flex items-center gap-2 text-[10px] font-semibold tracking-[0.18em] text-primary uppercase " +
              (align === "center" ? "justify-center" : "")
            }
          >
            <span className="h-px w-6 bg-primary/50" />
            {kicker}
          </p>
        )}
        <h2 className="text-[1.75rem] font-semibold leading-[1.2] tracking-tight sm:text-3xl">
          {title.split(" ").map((word, index, words) => (
            <span key={`${word}-${index}`} className={index === words.length - 1 ? "text-primary" : ""}>
              {index > 0 ? " " : ""}{word}
            </span>
          ))}
        </h2>
        {subtitle && <p className="mt-2.5 max-w-lg text-sm leading-relaxed text-muted-foreground">{subtitle}</p>}
      </div>
      {viewAllHref && (
        <Link
          href={viewAllHref}
          className="section-heading-view-all group inline-flex shrink-0 items-center gap-2 text-xs font-medium text-primary border-b border-primary/30 pb-2"
        >
          {viewAllLabel}
          <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
        </Link>
      )}
    </div>
  );
}

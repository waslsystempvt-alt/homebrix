import Link from "next/link";
import Image from "next/image";
import { ArrowRight } from "lucide-react";
import { getLaunchCitiesWithCounts } from "@/lib/db/queries";
import { getExteriorPhoto } from "@/lib/media/stockPhotos";
import { SectionHeading } from "@/components/home/SectionHeading";

export async function CityGrid() {
  const cities = await getLaunchCitiesWithCounts();
  if (cities.length === 0) return null;

  return (
    <section className="mx-auto max-w-7xl px-4 py-14">
      <SectionHeading
        kicker="Where We're Live"
        title="Top Cities"
        subtitle="Now live in Mumbai, Navi Mumbai & Thane — more cities coming soon."
      />

      {/* Horizontal swipeable carousel on mobile; a static 3-column grid from sm up. */}
      <div className="flex gap-4 overflow-x-auto snap-x snap-mandatory pb-2 sm:grid sm:grid-cols-3 sm:overflow-visible sm:pb-0 [-ms-overflow-style:none] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
        {cities.map((city) => (
          <Link
            key={city.id}
            href={`/new-projects-in-${city.slug}`}
            className="group relative block w-[78%] shrink-0 snap-start overflow-hidden rounded-2xl shadow-sm transition-shadow duration-200 hover:shadow-lg sm:w-auto"
          >
            <div className="relative aspect-[4/3] overflow-hidden">
              <Image
                src={getExteriorPhoto(city.slug, 500)}
                alt={`${city.name} skyline`}
                fill
                sizes="(min-width: 640px) 33vw, 78vw"
                className="object-cover transition-transform duration-300 group-hover:scale-105"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/15 to-transparent" />
              <span className="absolute bottom-4 right-4 flex size-10 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-sm transition-transform group-hover:translate-x-0.5">
                <ArrowRight className="size-4" />
              </span>
              <div className="absolute inset-x-0 bottom-0 p-4 pr-16">
                <h3 className="text-white font-bold text-xl drop-shadow-sm">{city.name}</h3>
                <p className="text-white/85 text-sm mt-0.5">
                  {city._count.projects.toLocaleString("en-IN")} new projects
                </p>
              </div>
            </div>
          </Link>
        ))}
      </div>

      <div className="mt-6 flex justify-center sm:justify-end">
        <a
          href="#all-cities"
          className="inline-flex items-center gap-1 text-sm font-medium text-primary hover:underline"
        >
          View all cities <ArrowRight className="size-3.5" />
        </a>
      </div>
    </section>
  );
}

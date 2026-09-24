"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { ProjectCard } from "@/components/project/ProjectCard";
import type { ProjectCardData } from "@/lib/db/queries";

export function CityTabsProjects({
  data,
}: {
  data: { citySlug: string; cityName: string; projects: ProjectCardData[] }[];
}) {
  const nonEmpty = data.filter((d) => d.projects.length > 0);
  if (nonEmpty.length === 0) return null;

  return (
    <Tabs defaultValue={nonEmpty[0].citySlug} className="w-full">
      <div className="flex items-center justify-between overflow-x-auto pb-2 scrollbar-none">
        <TabsList className="h-auto bg-transparent p-0 gap-2">
          {nonEmpty.map((d) => (
            <TabsTrigger
              key={d.citySlug}
              value={d.citySlug}
              className="rounded-full px-4 py-2 text-xs sm:text-sm font-semibold transition-all data-[state=active]:bg-[#ff474c] data-[state=active]:text-white text-slate-600 bg-slate-100 hover:bg-slate-200/80"
            >
              {d.cityName}
            </TabsTrigger>
          ))}
        </TabsList>
      </div>

      {nonEmpty.map((d) => (
        <TabsContent key={d.citySlug} value={d.citySlug} className="mt-6">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {d.projects.slice(0, 4).map((project) => (
              <ProjectCard key={project.id} project={project} />
            ))}
          </div>
        </TabsContent>
      ))}
    </Tabs>
  );
}

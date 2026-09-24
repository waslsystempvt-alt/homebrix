import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { prisma } from "@/lib/db/prisma";
import type { Project } from "@/generated/prisma/client";

const STATUS_OPTIONS = [
  { value: "new_launch", label: "New Launch" },
  { value: "under_construction", label: "Under Construction" },
  { value: "ready_to_move", label: "Ready to Move" },
];

const LAUNCH_STAGE_OPTIONS = [
  { value: "", label: "— Select Stage —" },
  { value: "pre_launch", label: "Pre-Launch" },
  { value: "newly_launched", label: "Newly Launched" },
  { value: "under_construction", label: "Under Construction" },
  { value: "nearing_possession", label: "Nearing Possession (< 6 months)" },
  { value: "possession_started", label: "Possession Started" },
  { value: "completed", label: "Completed" },
];

export async function ProjectForm({
  action,
  project,
}: {
  action: (formData: FormData) => Promise<void>;
  project?: Project | null;
}) {
  const [cities, localities, builders] = await Promise.all([
    prisma.city.findMany({ orderBy: { name: "asc" } }),
    prisma.locality.findMany({ include: { city: true }, orderBy: { name: "asc" } }),
    prisma.builder.findMany({ orderBy: { name: "asc" } }),
  ]);

  return (
    <form action={action} className="space-y-8 max-w-3xl">

      {/* ── Section: Core Info ─────────────────────────────────── */}
      <fieldset className="space-y-4">
        <legend className="text-sm font-semibold text-muted-foreground uppercase tracking-wider pb-2 border-b w-full">
          Basic Information
        </legend>
        <div className="grid grid-cols-2 gap-4">

          {/* Project Name */}
          <div className="space-y-1.5 col-span-2">
            <Label htmlFor="name">Project Name *</Label>
            <Input id="name" name="name" defaultValue={project?.name} required />
            {project?.slug && (
              <p className="text-xs text-muted-foreground">
                Slug: <code className="bg-muted px-1 rounded">{project.slug}</code>
                <span className="ml-1 text-amber-600">(locked after creation)</span>
              </p>
            )}
          </div>

          {/* Builder */}
          <div className="space-y-1.5">
            <Label htmlFor="builderId">Builder *</Label>
            <Select name="builderId" defaultValue={project?.builderId}>
              <SelectTrigger id="builderId" className="w-full">
                <SelectValue placeholder="Select builder" />
              </SelectTrigger>
              <SelectContent>
                {builders.map((b) => (
                  <SelectItem key={b.id} value={b.id}>{b.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* City */}
          <div className="space-y-1.5">
            <Label htmlFor="cityId">City *</Label>
            <Select name="cityId" defaultValue={project?.cityId ? String(project.cityId) : undefined}>
              <SelectTrigger id="cityId" className="w-full">
                <SelectValue placeholder="Select city" />
              </SelectTrigger>
              <SelectContent>
                {cities.map((c) => (
                  <SelectItem key={c.id} value={String(c.id)}>{c.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Locality */}
          <div className="space-y-1.5">
            <Label htmlFor="localityId">Locality</Label>
            <Select name="localityId" defaultValue={project?.localityId ? String(project.localityId) : undefined}>
              <SelectTrigger id="localityId" className="w-full">
                <SelectValue placeholder="Select locality" />
              </SelectTrigger>
              <SelectContent>
                {localities.map((l) => (
                  <SelectItem key={l.id} value={String(l.id)}>
                    {l.city.name} — {l.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Address */}
          <div className="space-y-1.5 col-span-2">
            <Label htmlFor="address">Full Address</Label>
            <Input id="address" name="address" defaultValue={project?.address ?? ""} placeholder="Building / street / area" />
          </div>

          {/* Lat / Lng */}
          <div className="space-y-1.5">
            <Label htmlFor="lat">Latitude</Label>
            <Input id="lat" name="lat" type="number" step="any" defaultValue={project?.lat?.toString() ?? ""} placeholder="19.2183" />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="lng">Longitude</Label>
            <Input id="lng" name="lng" type="number" step="any" defaultValue={project?.lng?.toString() ?? ""} placeholder="72.9781" />
          </div>
        </div>
      </fieldset>

      {/* ── Section: Status & Stage ────────────────────────────── */}
      <fieldset className="space-y-4">
        <legend className="text-sm font-semibold text-muted-foreground uppercase tracking-wider pb-2 border-b w-full">
          Status & Dates
        </legend>
        <div className="grid grid-cols-2 gap-4">

          {/* Construction Status */}
          <div className="space-y-1.5">
            <Label htmlFor="constructionStatus">Construction Status *</Label>
            <Select name="constructionStatus" defaultValue={project?.constructionStatus ?? "new_launch"}>
              <SelectTrigger id="constructionStatus" className="w-full">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {STATUS_OPTIONS.map((s) => (
                  <SelectItem key={s.value} value={s.value}>{s.label}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Launch Stage */}
          <div className="space-y-1.5">
            <Label htmlFor="launchStage">Launch Stage</Label>
            <Select name="launchStage" defaultValue={project?.launchStage ?? ""}>
              <SelectTrigger id="launchStage" className="w-full">
                <SelectValue placeholder="Select stage" />
              </SelectTrigger>
              <SelectContent>
                {LAUNCH_STAGE_OPTIONS.map((s) => (
                  <SelectItem key={s.value} value={s.value}>{s.label}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* RERA Number */}
          <div className="space-y-1.5">
            <Label htmlFor="reraNumber">RERA Number</Label>
            <Input id="reraNumber" name="reraNumber" defaultValue={project?.reraNumber ?? ""} placeholder="P51700012345" />
          </div>
          <div className="flex items-center gap-2 pt-6">
            <Checkbox id="reraVerified" name="reraVerified" defaultChecked={project?.reraVerified} />
            <Label htmlFor="reraVerified" className="font-normal">RERA Verified</Label>
          </div>

          {/* Launch Date */}
          <div className="space-y-1.5">
            <Label htmlFor="launchDate">Launch Date</Label>
            <Input id="launchDate" name="launchDate" type="date" defaultValue={project?.launchDate?.toISOString().slice(0, 10)} />
          </div>

          {/* Possession Date */}
          <div className="space-y-1.5">
            <Label htmlFor="possessionDate">Possession Date</Label>
            <Input id="possessionDate" name="possessionDate" type="date" defaultValue={project?.possessionDate?.toISOString().slice(0, 10)} />
          </div>

          {/* Scale */}
          <div className="space-y-1.5">
            <Label htmlFor="totalUnits">Total Units</Label>
            <Input id="totalUnits" name="totalUnits" type="number" defaultValue={project?.totalUnits ?? ""} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="totalTowers">Total Towers</Label>
            <Input id="totalTowers" name="totalTowers" type="number" defaultValue={project?.totalTowers ?? ""} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="totalFloors">Total Floors</Label>
            <Input id="totalFloors" name="totalFloors" type="number" defaultValue={project?.totalFloors ?? ""} />
          </div>
        </div>
      </fieldset>

      {/* ── Section: Pricing ───────────────────────────────────── */}
      <fieldset className="space-y-4">
        <legend className="text-sm font-semibold text-muted-foreground uppercase tracking-wider pb-2 border-b w-full">
          Pricing (Overall Range)
        </legend>
        <p className="text-xs text-muted-foreground">
          These are auto-updated from BHK configurations. Set manually if you haven&apos;t added configs yet.
        </p>
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-1.5">
            <Label htmlFor="priceMin">Price Min (₹)</Label>
            <Input id="priceMin" name="priceMin" type="number" defaultValue={project?.priceMin?.toString()} placeholder="8500000" />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="priceMax">Price Max (₹)</Label>
            <Input id="priceMax" name="priceMax" type="number" defaultValue={project?.priceMax?.toString()} placeholder="15000000" />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="areaMinSqft">Area Min (sqft)</Label>
            <Input id="areaMinSqft" name="areaMinSqft" type="number" defaultValue={project?.areaMinSqft ?? ""} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="areaMaxSqft">Area Max (sqft)</Label>
            <Input id="areaMaxSqft" name="areaMaxSqft" type="number" defaultValue={project?.areaMaxSqft ?? ""} />
          </div>
        </div>
      </fieldset>

      {/* ── Section: Content ───────────────────────────────────── */}
      <fieldset className="space-y-4">
        <legend className="text-sm font-semibold text-muted-foreground uppercase tracking-wider pb-2 border-b w-full">
          Content & SEO
        </legend>
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-1.5 col-span-2">
            <Label htmlFor="description">Project Description</Label>
            <textarea
              id="description"
              name="description"
              className="w-full rounded-md border bg-transparent px-3 py-2 text-sm min-h-28"
              defaultValue={project?.description ?? ""}
              placeholder="Describe the project for buyers and SEO..."
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="metaTitle">SEO Meta Title</Label>
            <Input id="metaTitle" name="metaTitle" defaultValue={project?.metaTitle ?? ""} placeholder="Lodha Crown Majiwada Thane | 2 & 3 BHK" />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="metaDesc">SEO Meta Description</Label>
            <Input id="metaDesc" name="metaDesc" defaultValue={project?.metaDesc ?? ""} />
          </div>
        </div>
      </fieldset>

      {/* ── Section: Visibility Flags ──────────────────────────── */}
      <fieldset className="space-y-3">
        <legend className="text-sm font-semibold text-muted-foreground uppercase tracking-wider pb-2 border-b w-full">
          Visibility
        </legend>
        <div className="flex flex-wrap gap-6">
          <div className="flex items-center gap-2">
            <Checkbox id="published" name="published" defaultChecked={project?.published ?? false} />
            <Label htmlFor="published" className="font-normal">Published</Label>
          </div>
          <div className="flex items-center gap-2">
            <Checkbox id="featured" name="featured" defaultChecked={project?.featured ?? false} />
            <Label htmlFor="featured" className="font-normal">Featured</Label>
          </div>
          <div className="flex items-center gap-2">
            <Checkbox id="hotDealBadge" name="hotDealBadge" defaultChecked={project?.hotDealBadge ?? false} />
            <Label htmlFor="hotDealBadge" className="font-normal">🔥 Hot Deal Badge</Label>
          </div>
          <div className="flex items-center gap-2">
            <Checkbox id="reraBadge" name="reraBadge" defaultChecked={project?.reraBadge ?? false} />
            <Label htmlFor="reraBadge" className="font-normal">✅ RERA Badge</Label>
          </div>
        </div>
      </fieldset>

      <Button type="submit" className="w-full sm:w-auto">
        {project ? "Save Changes" : "Create Project"}
      </Button>
    </form>
  );
}

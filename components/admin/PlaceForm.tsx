import { prisma } from "@/lib/db/prisma";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import type { Place } from "@/generated/prisma/client";

const CATEGORY_GROUPS = [
  { label: "🚂 Transport", items: ["railway_station","metro_station","bus_stop","bus_depot","highway","airport","expressway"] },
  { label: "🎓 Education", items: ["school","college_university","university","coaching"] },
  { label: "🏥 Health", items: ["hospital","clinic","pharmacy"] },
  { label: "🛍️ Shopping", items: ["mall","market","supermarket","wholesale_market"] },
  { label: "🍽️ Lifestyle", items: ["restaurant","hotel","cinema","resort"] },
  { label: "💼 Work", items: ["it_park","sez","business_park","office_hub"] },
  { label: "🌳 Public", items: ["park","garden","sports_complex","stadium"] },
  { label: "🛕 Religious", items: ["temple","mosque","church","gurudwara"] },
  { label: "📍 Location", items: ["locality","colony","sector","nagar"] },
  { label: "📌 Other", items: ["bank","other"] },
];

export async function PlaceForm({
  action,
  place,
}: {
  action: (formData: FormData) => Promise<void>;
  place?: Place | null;
}) {
  const [cities, localities] = await Promise.all([
    prisma.city.findMany({ orderBy: { name: "asc" } }),
    prisma.locality.findMany({ include: { city: true }, orderBy: { name: "asc" } }),
  ]);

  return (
    <form action={action} className="space-y-6 max-w-2xl">

      {/* Name & Slugs */}
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-1.5 col-span-2">
          <Label htmlFor="pl-name">Place Name *</Label>
          <Input id="pl-name" name="name" required defaultValue={place?.name} placeholder="Jupiter Hospital" />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="pl-slug">Slug</Label>
          <Input id="pl-slug" name="slug" defaultValue={place?.slug} placeholder="jupiter-hospital (auto-generated)" />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="pl-seo-slug">SEO Slug</Label>
          <Input id="pl-seo-slug" name="seoSlug" defaultValue={place?.seoSlug} placeholder="jupiter-hospital-thane (auto)" />
        </div>
      </div>

      {/* Category */}
      <div className="space-y-1.5">
        <Label htmlFor="pl-category">Category *</Label>
        <Select name="category" defaultValue={place?.category ?? "hospital"}>
          <SelectTrigger id="pl-category" className="w-full">
            <SelectValue />
          </SelectTrigger>
          <SelectContent className="max-h-64">
            {CATEGORY_GROUPS.map((group) => (
              <div key={group.label}>
                <div className="px-2 py-1 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                  {group.label}
                </div>
                {group.items.map((item) => (
                  <SelectItem key={item} value={item}>
                    {item.replace(/_/g, " ")}
                  </SelectItem>
                ))}
              </div>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* City / Locality */}
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-1.5">
          <Label htmlFor="pl-city">City</Label>
          <Select name="cityId" defaultValue={place?.cityId ? String(place.cityId) : undefined}>
            <SelectTrigger id="pl-city" className="w-full"><SelectValue placeholder="Select city" /></SelectTrigger>
            <SelectContent>
              {cities.map((c) => <SelectItem key={c.id} value={String(c.id)}>{c.name}</SelectItem>)}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="pl-locality">Locality (optional)</Label>
          <Select name="localityId" defaultValue={place?.localityId ? String(place.localityId) : undefined}>
            <SelectTrigger id="pl-locality" className="w-full"><SelectValue placeholder="Select locality" /></SelectTrigger>
            <SelectContent>
              {localities.map((l) => (
                <SelectItem key={l.id} value={String(l.id)}>{l.city.name} — {l.name}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      {/* Location */}
      <div className="space-y-1.5">
        <Label htmlFor="pl-address">Address</Label>
        <Input id="pl-address" name="address" defaultValue={place?.address ?? ""} />
      </div>
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-1.5">
          <Label htmlFor="pl-lat">Latitude</Label>
          <Input id="pl-lat" name="lat" type="number" step="any" defaultValue={place?.lat?.toString() ?? ""} placeholder="19.2224" />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="pl-lng">Longitude</Label>
          <Input id="pl-lng" name="lng" type="number" step="any" defaultValue={place?.lng?.toString() ?? ""} placeholder="72.9845" />
        </div>
      </div>

      {/* Ratings */}
      <div className="grid grid-cols-3 gap-4">
        <div className="space-y-1.5">
          <Label htmlFor="pl-rating">Rating (0–5)</Label>
          <Input id="pl-rating" name="rating" type="number" step="0.1" min="0" max="5" defaultValue={place?.rating?.toString() ?? ""} placeholder="4.2" />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="pl-reviews">Review Count</Label>
          <Input id="pl-reviews" name="reviewCount" type="number" defaultValue={place?.reviewCount?.toString() ?? ""} placeholder="5000" />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="pl-importance">Importance Score (0–100)</Label>
          <Input id="pl-importance" name="importanceScore" type="number" min="0" max="100" defaultValue={place?.importanceScore?.toString() ?? "50"} />
        </div>
      </div>

      {/* SEO Priority */}
      <div className="space-y-1.5">
        <Label htmlFor="pl-seo-priority">SEO Priority</Label>
        <Select name="seoPriority" defaultValue={String(place?.seoPriority ?? "0")}>
          <SelectTrigger id="pl-seo-priority" className="w-64"><SelectValue /></SelectTrigger>
          <SelectContent>
            <SelectItem value="0">0 — Not set</SelectItem>
            <SelectItem value="1">1 — High (top landmark)</SelectItem>
            <SelectItem value="2">2 — Medium</SelectItem>
            <SelectItem value="3">3 — Low</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Source */}
      <div className="space-y-1.5">
        <Label htmlFor="pl-source">Source</Label>
        <Select name="source" defaultValue={place?.source ?? "manual"}>
          <SelectTrigger id="pl-source" className="w-64"><SelectValue /></SelectTrigger>
          <SelectContent>
            <SelectItem value="builder">Builder</SelectItem>
            <SelectItem value="rera">MahaRERA</SelectItem>
            <SelectItem value="manual">Manual</SelectItem>
            <SelectItem value="osm">OpenStreetMap</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Flags */}
      <div className="flex flex-wrap gap-6">
        <div className="flex items-center gap-2">
          <Checkbox id="pl-seo-page" name="createSeoPage" defaultChecked={place?.createSeoPage ?? false} />
          <Label htmlFor="pl-seo-page" className="font-normal">
            Enable SEO page generation for this place
          </Label>
        </div>
        <div className="flex items-center gap-2">
          <Checkbox id="pl-verified" name="verified" defaultChecked={place?.verified ?? false} />
          <Label htmlFor="pl-verified" className="font-normal">Verified</Label>
        </div>
        <div className="flex items-center gap-2">
          <Checkbox id="pl-active" name="isActive" defaultChecked={place?.isActive ?? true} />
          <Label htmlFor="pl-active" className="font-normal">Active</Label>
        </div>
      </div>

      <Button type="submit">{place ? "Save Changes" : "Create Place"}</Button>
    </form>
  );
}

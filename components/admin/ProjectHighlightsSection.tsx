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
import {
  addHighlightAction,
  deleteHighlightAction,
} from "@/app/admin/(dashboard)/projects/[id]/highlights/actions";

// ─── Category config ────────────────────────────────────────────────────────
const CATEGORY_GROUPS = [
  {
    label: "🚂 Transport",
    items: [
      { value: "railway_station", label: "Railway Station" },
      { value: "metro_station", label: "Metro Station" },
      { value: "bus_stop", label: "Bus Stop" },
      { value: "bus_depot", label: "Bus Depot" },
      { value: "highway", label: "Highway / Expressway" },
      { value: "airport", label: "Airport" },
    ],
  },
  {
    label: "🎓 Education",
    items: [
      { value: "school", label: "School" },
      { value: "college_university", label: "College / University" },
      { value: "coaching", label: "Coaching Centre" },
    ],
  },
  {
    label: "🏥 Health",
    items: [
      { value: "hospital", label: "Hospital" },
      { value: "clinic", label: "Clinic" },
      { value: "pharmacy", label: "Pharmacy" },
    ],
  },
  {
    label: "🛍️ Shopping",
    items: [
      { value: "mall", label: "Mall" },
      { value: "market", label: "Market" },
      { value: "supermarket", label: "Supermarket" },
    ],
  },
  {
    label: "💼 Work",
    items: [
      { value: "it_park", label: "IT Park" },
      { value: "sez", label: "SEZ" },
      { value: "business_park", label: "Business Park" },
      { value: "office_hub", label: "Office Hub" },
    ],
  },
  {
    label: "🌳 Public",
    items: [
      { value: "park", label: "Park / Garden" },
      { value: "sports_complex", label: "Sports Complex" },
      { value: "temple", label: "Temple / Religious" },
    ],
  },
  {
    label: "🍽️ Lifestyle",
    items: [
      { value: "restaurant", label: "Restaurant" },
      { value: "hotel", label: "Hotel" },
      { value: "cinema", label: "Cinema" },
    ],
  },
  {
    label: "📍 Other",
    items: [
      { value: "locality", label: "Locality / Area" },
      { value: "bank", label: "Bank" },
      { value: "other", label: "Other" },
    ],
  },
];

const TRAVEL_MODES = [
  { value: "walk", label: "🚶 Walk" },
  { value: "drive", label: "🚗 Drive" },
  { value: "auto", label: "🛺 Auto" },
  { value: "train", label: "🚂 Train" },
  { value: "metro", label: "🚇 Metro" },
  { value: "bus", label: "🚌 Bus" },
];

const CATEGORY_ICONS: Record<string, string> = {
  railway_station: "🚂", metro_station: "🚇", bus_stop: "🚌", bus_depot: "🚌",
  highway: "🛣️", airport: "✈️", expressway: "🛣️",
  school: "🏫", college_university: "🎓", university: "🎓", coaching: "📚",
  hospital: "🏥", clinic: "🏥", pharmacy: "💊",
  mall: "🛍️", market: "🛒", supermarket: "🛒",
  restaurant: "🍽️", hotel: "🏨", cinema: "🎬",
  it_park: "💻", sez: "🏢", business_park: "🏢", office_hub: "🏢",
  park: "🌳", garden: "🌳", sports_complex: "⚽", stadium: "🏟️",
  temple: "🛕", mosque: "🕌", church: "⛪", gurudwara: "🛕",
  bank: "🏦", locality: "📍", colony: "📍", sector: "📍",
  other: "📌",
};

export async function ProjectHighlightsSection({ projectId }: { projectId: string }) {
  const highlights = await prisma.projectLandmark.findMany({
    where: { projectId },
    orderBy: [{ isFeatured: "desc" }, { displayOrder: "asc" }],
    include: { place: { select: { id: true, seoSlug: true } } },
  });

  const addAction = addHighlightAction.bind(null, projectId);

  return (
    <div className="space-y-6">
      <div>
        <h3 className="text-base font-semibold mb-1">Highlights & Connectivity</h3>
        <p className="text-sm text-muted-foreground">
          Add nearby landmarks and distances as provided by the builder or MahaRERA.
          These drive both the neighbourhood map and SEO pages.
        </p>
      </div>

      {/* Existing Highlights */}
      {highlights.length > 0 ? (
        <div className="rounded-md border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-muted-foreground">
              <tr>
                <th className="text-left px-4 py-2 font-medium">Place</th>
                <th className="text-left px-4 py-2 font-medium">Category</th>
                <th className="text-left px-4 py-2 font-medium">Distance</th>
                <th className="text-left px-4 py-2 font-medium">Mode</th>
                <th className="text-left px-4 py-2 font-medium">Flags</th>
                <th className="px-4 py-2"></th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {highlights.map((h) => (
                <tr key={h.id} className="hover:bg-muted/30 transition-colors">
                  <td className="px-4 py-3 font-medium">
                    <span className="mr-1.5">
                      {CATEGORY_ICONS[h.category] ?? "📌"}
                    </span>
                    {h.name}
                    {h.place && (
                      <span className="ml-1.5 text-xs text-green-600 font-normal">✓ linked</span>
                    )}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground capitalize">
                    {h.category.replace(/_/g, " ")}
                  </td>
                  <td className="px-4 py-3">
                    {h.distanceLabel ?? (h.distanceM ? `${h.distanceM}m` : "—")}
                    {h.travelMinutes && (
                      <span className="text-muted-foreground ml-1 text-xs">
                        ({h.travelMinutes} min)
                      </span>
                    )}
                  </td>
                  <td className="px-4 py-3 capitalize text-muted-foreground">
                    {TRAVEL_MODES.find((m) => m.value === h.travelMode)?.label ?? h.travelMode}
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex gap-1.5 flex-wrap">
                      {h.isFeatured && (
                        <span className="text-xs bg-amber-50 text-amber-700 rounded-full px-2 py-0.5">
                          ⭐ Featured
                        </span>
                      )}
                      {h.showOnMap && (
                        <span className="text-xs bg-blue-50 text-blue-700 rounded-full px-2 py-0.5">
                          🗺 Map
                        </span>
                      )}
                    </div>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <form
                      action={deleteHighlightAction.bind(null, h.id, projectId)}
                      className="inline"
                    >
                      <button type="submit" className="text-xs text-destructive hover:underline">
                        Remove
                      </button>
                    </form>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div className="rounded-md border border-dashed p-6 text-center text-muted-foreground text-sm">
          No highlights yet. Add connectivity details from the builder or MahaRERA below.
        </div>
      )}

      {/* Add New Highlight Form */}
      <div className="rounded-md border p-4 space-y-4 bg-muted/20">
        <h4 className="text-sm font-medium">Add Highlight</h4>
        <form action={addAction} className="grid grid-cols-2 gap-3 sm:grid-cols-3">

          {/* Place Name */}
          <div className="space-y-1.5 col-span-2 sm:col-span-2">
            <Label htmlFor="hl-name" className="text-xs">Place Name *</Label>
            <Input id="hl-name" name="name" required className="h-8 text-sm" placeholder="e.g. Jupiter Hospital" />
          </div>

          {/* Category */}
          <div className="space-y-1.5">
            <Label htmlFor="hl-category" className="text-xs">Category *</Label>
            <Select name="category" defaultValue="hospital">
              <SelectTrigger id="hl-category" className="h-8 text-sm">
                <SelectValue />
              </SelectTrigger>
              <SelectContent className="max-h-64">
                {CATEGORY_GROUPS.map((group) => (
                  <div key={group.label}>
                    <div className="px-2 py-1 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                      {group.label}
                    </div>
                    {group.items.map((item) => (
                      <SelectItem key={item.value} value={item.value}>
                        {item.label}
                      </SelectItem>
                    ))}
                  </div>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Distance in meters */}
          <div className="space-y-1.5">
            <Label htmlFor="hl-distance" className="text-xs">Distance (meters)</Label>
            <Input id="hl-distance" name="distanceM" type="number" className="h-8 text-sm" placeholder="800" />
          </div>

          {/* Distance label override */}
          <div className="space-y-1.5">
            <Label htmlFor="hl-label" className="text-xs">Display Label (optional)</Label>
            <Input id="hl-label" name="distanceLabel" className="h-8 text-sm" placeholder="800m or 10 min drive" />
          </div>

          {/* Travel minutes */}
          <div className="space-y-1.5">
            <Label htmlFor="hl-mins" className="text-xs">Travel (minutes)</Label>
            <Input id="hl-mins" name="travelMinutes" type="number" className="h-8 text-sm" placeholder="12" />
          </div>

          {/* Travel mode */}
          <div className="space-y-1.5">
            <Label htmlFor="hl-mode" className="text-xs">Travel Mode</Label>
            <Select name="travelMode" defaultValue="drive">
              <SelectTrigger id="hl-mode" className="h-8 text-sm">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {TRAVEL_MODES.map((m) => (
                  <SelectItem key={m.value} value={m.value}>
                    {m.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Source */}
          <div className="space-y-1.5">
            <Label htmlFor="hl-source" className="text-xs">Source</Label>
            <Select name="source" defaultValue="builder">
              <SelectTrigger id="hl-source" className="h-8 text-sm">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="builder">Builder</SelectItem>
                <SelectItem value="rera">MahaRERA</SelectItem>
                <SelectItem value="manual">Manual</SelectItem>
                <SelectItem value="osm">OpenStreetMap</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Flags */}
          <div className="col-span-2 sm:col-span-3 flex items-center gap-6 pt-1">
            <div className="flex items-center gap-2">
              <Checkbox id="hl-featured" name="isFeatured" />
              <Label htmlFor="hl-featured" className="text-xs font-normal">
                ⭐ Featured highlight
              </Label>
            </div>
            <div className="flex items-center gap-2">
              <Checkbox id="hl-map" name="showOnMap" defaultChecked />
              <Label htmlFor="hl-map" className="text-xs font-normal">
                🗺 Show on map
              </Label>
            </div>
          </div>

          <div className="col-span-2 sm:col-span-3 flex justify-end pt-1">
            <Button type="submit" size="sm">
              + Add Highlight
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}

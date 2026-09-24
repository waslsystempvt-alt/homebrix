import Link from "next/link";
import { prisma } from "@/lib/db/prisma";
import { Button } from "@/components/ui/button";
import {
  toggleSeoPageAction,
  togglePlaceActiveAction,
  deletePlaceAction,
  bulkEnableTopLandmarksAction,
} from "./actions";

const CATEGORY_ICONS: Record<string, string> = {
  railway_station: "🚂",
  metro_station: "🚇",
  bus_stop: "🚌",
  school: "🏫",
  college_university: "🎓",
  hospital: "🏥",
  clinic: "🏥",
  mall: "🛍️",
  market: "🛒",
  it_park: "💻",
  sez: "🏢",
  park: "🌳",
  garden: "🌳",
  restaurant: "🍽️",
  hotel: "🏨",
  temple: "🛕",
  bank: "🏦",
  other: "📌",
};

export default async function PlacesAdminPage() {
  const places = await prisma.place.findMany({
    orderBy: [{ createSeoPage: "desc" }, { importanceScore: "desc" }, { name: "asc" }],
    include: {
      _count: { select: { landmarks: true } },
    },
  });

  const seoEnabled = places.filter((p) => p.createSeoPage).length;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Places / POI Database</h1>
          <p className="text-sm text-muted-foreground mt-1">
            Master database of landmarks, transport, schools, hospitals, etc.{" "}
            <strong>{seoEnabled}</strong> places have SEO page generation enabled.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <form action={bulkEnableTopLandmarksAction}>
            <Button type="submit" variant="outline" size="sm">
              ⚡ Enable Top 20 SEO Pages
            </Button>
          </form>
          <Link href="/admin/places/new">
            <Button size="sm">+ Add Place</Button>
          </Link>
        </div>
      </div>

      {places.length === 0 ? (
        <div className="rounded-md border border-dashed p-10 text-center">
          <p className="text-muted-foreground">No places yet.</p>
          <Link href="/admin/places/new" className="mt-3 inline-block">
            <Button size="sm">Add your first place</Button>
          </Link>
        </div>
      ) : (
        <div className="rounded-md border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-muted-foreground">
              <tr>
                <th className="text-left px-4 py-2 font-medium">Name</th>
                <th className="text-left px-4 py-2 font-medium">Category</th>
                <th className="text-left px-4 py-2 font-medium">Importance</th>
                <th className="text-left px-4 py-2 font-medium">Projects</th>
                <th className="text-left px-4 py-2 font-medium">SEO Pages</th>
                <th className="text-left px-4 py-2 font-medium">Status</th>
                <th className="px-4 py-2"></th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {places.map((place) => (
                <tr key={place.id} className="hover:bg-muted/30 transition-colors">
                  <td className="px-4 py-3">
                    <div className="font-medium">
                      {CATEGORY_ICONS[place.category] ?? "📌"} {place.name}
                    </div>
                    <div className="text-xs text-muted-foreground mt-0.5">
                      <code>{place.seoSlug}</code>
                    </div>
                  </td>
                  <td className="px-4 py-3 capitalize text-muted-foreground text-xs">
                    {place.category.replace(/_/g, " ")}
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-1.5">
                      <div
                        className="h-2 rounded-full bg-primary/30"
                        style={{ width: `${place.importanceScore}px`, maxWidth: "60px" }}
                      />
                      <span className="text-xs text-muted-foreground">{place.importanceScore}</span>
                    </div>
                  </td>
                  <td className="px-4 py-3 text-center text-muted-foreground">
                    {place._count.landmarks}
                  </td>
                  <td className="px-4 py-3">
                    <form action={toggleSeoPageAction.bind(null, place.id, place.createSeoPage)} className="inline">
                      <button
                        type="submit"
                        className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium transition-colors ${
                          place.createSeoPage
                            ? "bg-green-50 text-green-700 hover:bg-green-100"
                            : "bg-gray-100 text-gray-500 hover:bg-gray-200"
                        }`}
                      >
                        {place.createSeoPage ? "✓ Enabled" : "Disabled"}
                      </button>
                    </form>
                  </td>
                  <td className="px-4 py-3">
                    <form action={togglePlaceActiveAction.bind(null, place.id, place.isActive)} className="inline">
                      <button
                        type="submit"
                        className={`text-xs ${place.isActive ? "text-muted-foreground" : "text-red-600 font-medium"}`}
                      >
                        {place.isActive ? "Active" : "Inactive"}
                      </button>
                    </form>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <div className="flex items-center justify-end gap-3">
                      {place.createSeoPage && (
                        <a
                          href={`/flats-near-${place.seoSlug}`}
                          target="_blank"
                          rel="noreferrer"
                          className="text-xs text-primary font-medium hover:underline"
                        >
                          🔗 View SEO Page
                        </a>
                      )}
                      <Link href={`/admin/places/${place.id}`} className="text-xs hover:underline">
                        Edit
                      </Link>
                      <form action={deletePlaceAction.bind(null, place.id)} className="inline">
                        <button type="submit" className="text-xs text-destructive hover:underline">
                          Delete
                        </button>
                      </form>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

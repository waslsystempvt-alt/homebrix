import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { getAdminProjects } from "@/lib/admin/queries";
import { toggleFeaturedAction, togglePublishedAction, deleteProjectAction } from "./actions";
import { formatPriceRange } from "@/lib/utils/format";

export default async function AdminProjectsPage() {
  const projects = await getAdminProjects();

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Projects ({projects.length})</h1>
        <Button asChild>
          <Link href="/admin/projects/new">+ Add Project</Link>
        </Button>
      </div>

      <div className="overflow-x-auto rounded-lg border">
        <table className="w-full text-sm">
          <thead className="bg-muted/50">
            <tr>
              <th className="text-left p-3 font-medium">Name</th>
              <th className="text-left p-3 font-medium">City</th>
              <th className="text-left p-3 font-medium">Builder</th>
              <th className="text-left p-3 font-medium">Price</th>
              <th className="text-left p-3 font-medium">Status</th>
              <th className="text-left p-3 font-medium">Published</th>
              <th className="text-left p-3 font-medium">Featured</th>
              <th className="text-left p-3 font-medium"></th>
            </tr>
          </thead>
          <tbody>
            {projects.map((p) => (
              <tr key={p.id} className="border-t">
                <td className="p-3">
                  <div className="flex items-center gap-2 flex-wrap">
                    <Link href={`/admin/projects/${p.id}`} className="font-medium hover:underline">
                      {p.name}
                    </Link>
                    {!p.possessionDate && (
                      <span
                        className="inline-flex items-center text-[10px] text-amber-700 bg-amber-50 px-1.5 py-0.5 rounded border border-amber-200"
                        title="Missing possession date — possession filter will not match this project"
                      >
                        ⚠️ No Possession Date
                      </span>
                    )}
                  </div>
                </td>
                <td className="p-3">{p.city.name}</td>
                <td className="p-3">{p.builder.name}</td>
                <td className="p-3">{formatPriceRange(p.priceMin, p.priceMax)}</td>
                <td className="p-3">
                  <Badge variant="secondary">{p.constructionStatus.replace(/_/g, " ")}</Badge>
                </td>
                <td className="p-3">
                  <form action={togglePublishedAction.bind(null, p.id, p.published)}>
                    <button type="submit">
                      <Badge variant={p.published ? "default" : "outline"}>{p.published ? "Published" : "Draft"}</Badge>
                    </button>
                  </form>
                </td>
                <td className="p-3">
                  <form action={toggleFeaturedAction.bind(null, p.id, p.featured)}>
                    <button type="submit">
                      <Badge variant={p.featured ? "default" : "outline"}>{p.featured ? "Yes" : "No"}</Badge>
                    </button>
                  </form>
                </td>
                <td className="p-3">
                  <form action={deleteProjectAction.bind(null, p.id)}>
                    <Button type="submit" size="sm" variant="ghost" className="text-destructive">
                      Delete
                    </Button>
                  </form>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

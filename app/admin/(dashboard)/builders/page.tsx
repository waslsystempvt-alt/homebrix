import { getAdminBuilders } from "@/lib/admin/queries";
import { Badge } from "@/components/ui/badge";
import { toggleBuilderFeaturedAction, toggleBuilderVerifiedAction } from "./actions";

export default async function AdminBuildersPage() {
  const builders = await getAdminBuilders();

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Builders ({builders.length})</h1>

      <div className="overflow-x-auto rounded-lg border">
        <table className="w-full text-sm">
          <thead className="bg-muted/50">
            <tr>
              <th className="text-left p-3 font-medium">Name</th>
              <th className="text-left p-3 font-medium">HQ</th>
              <th className="text-left p-3 font-medium">Projects</th>
              <th className="text-left p-3 font-medium">Verified</th>
              <th className="text-left p-3 font-medium">Featured</th>
            </tr>
          </thead>
          <tbody>
            {builders.map((b) => (
              <tr key={b.id} className="border-t">
                <td className="p-3 font-medium">{b.name}</td>
                <td className="p-3 text-muted-foreground">{b.headquarters ?? "—"}</td>
                <td className="p-3">{b._count.projects}</td>
                <td className="p-3">
                  <form action={toggleBuilderVerifiedAction.bind(null, b.id, b.verified)}>
                    <button type="submit">
                      <Badge variant={b.verified ? "default" : "outline"}>{b.verified ? "Verified" : "Unverified"}</Badge>
                    </button>
                  </form>
                </td>
                <td className="p-3">
                  <form action={toggleBuilderFeaturedAction.bind(null, b.id, b.featured)}>
                    <button type="submit">
                      <Badge variant={b.featured ? "default" : "outline"}>{b.featured ? "Yes" : "No"}</Badge>
                    </button>
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

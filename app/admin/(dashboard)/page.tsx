import { Card } from "@/components/ui/card";
import { getDashboardStats } from "@/lib/admin/queries";

export default async function AdminDashboardPage() {
  const stats = await getDashboardStats();

  const cards = [
    { label: "Active Projects", value: stats.activeProjects },
    { label: "Leads Today", value: stats.leadsToday },
    { label: "Published This Month", value: stats.publishedThisMonth },
    { label: "Total Leads", value: stats.totalLeads },
  ];

  return (
    <div className="space-y-8">
      <h1 className="text-2xl font-bold">Dashboard</h1>

      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        {cards.map((c) => (
          <Card key={c.label} className="p-4">
            <p className="text-2xl font-bold">{c.value.toLocaleString("en-IN")}</p>
            <p className="text-xs text-muted-foreground">{c.label}</p>
          </Card>
        ))}
      </div>

      <div>
        <h2 className="text-lg font-semibold mb-3">Lead Pipeline</h2>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          {stats.leadsByStatus.map((group) => (
            <Card key={group.status} className="p-4">
              <p className="text-xl font-bold">{group._count}</p>
              <p className="text-xs text-muted-foreground capitalize">{group.status.replace(/_/g, " ")}</p>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );
}

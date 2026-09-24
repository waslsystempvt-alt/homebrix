import { getAdminLeads } from "@/lib/admin/queries";
import { LeadStatusSelect } from "@/components/admin/LeadStatusSelect";
import { Badge } from "@/components/ui/badge";

export default async function AdminLeadsPage() {
  const leads = await getAdminLeads();

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Leads ({leads.length})</h1>

      <div className="overflow-x-auto rounded-lg border">
        <table className="w-full text-sm">
          <thead className="bg-muted/50">
            <tr>
              <th className="text-left p-3 font-medium">Name</th>
              <th className="text-left p-3 font-medium">Phone</th>
              <th className="text-left p-3 font-medium">Project</th>
              <th className="text-left p-3 font-medium">Type</th>
              <th className="text-left p-3 font-medium">Source</th>
              <th className="text-left p-3 font-medium">Received</th>
              <th className="text-left p-3 font-medium">Status</th>
            </tr>
          </thead>
          <tbody>
            {leads.map((lead) => (
              <tr key={lead.id} className="border-t">
                <td className="p-3">{lead.name ?? "—"}</td>
                <td className="p-3 font-mono">{lead.phone}</td>
                <td className="p-3">{lead.project?.name ?? lead.builder?.name ?? "—"}</td>
                <td className="p-3">
                  <Badge variant="secondary">{lead.leadType.replace(/_/g, " ")}</Badge>
                </td>
                <td className="p-3">{lead.source}</td>
                <td className="p-3 text-muted-foreground">
                  {lead.createdAt.toLocaleDateString("en-IN", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}
                </td>
                <td className="p-3">
                  <LeadStatusSelect leadId={lead.id} status={lead.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {leads.length === 0 && <p className="p-8 text-center text-muted-foreground">No leads yet.</p>}
      </div>
    </div>
  );
}

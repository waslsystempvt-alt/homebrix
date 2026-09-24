import { getAdminJobApplications } from "@/lib/admin/queries";
import { JobApplicationStatusSelect } from "@/components/admin/JobApplicationStatusSelect";
import { Badge } from "@/components/ui/badge";

export default async function AdminJobApplicationsPage() {
  const applications = await getAdminJobApplications();

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Job Applications ({applications.length})</h1>

      <div className="overflow-x-auto rounded-lg border">
        <table className="w-full text-sm">
          <thead className="bg-muted/50">
            <tr>
              <th className="text-left p-3 font-medium">Name</th>
              <th className="text-left p-3 font-medium">Role</th>
              <th className="text-left p-3 font-medium">Phone</th>
              <th className="text-left p-3 font-medium">Email</th>
              <th className="text-left p-3 font-medium">Resume</th>
              <th className="text-left p-3 font-medium">Received</th>
              <th className="text-left p-3 font-medium">Status</th>
            </tr>
          </thead>
          <tbody>
            {applications.map((app) => (
              <tr key={app.id} className="border-t align-top">
                <td className="p-3">{app.name}</td>
                <td className="p-3">
                  <Badge variant="secondary">{app.jobTitle}</Badge>
                </td>
                <td className="p-3 font-mono">{app.phone}</td>
                <td className="p-3">{app.email}</td>
                <td className="p-3">
                  <a
                    href={app.resumeUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-primary hover:underline"
                  >
                    View
                  </a>
                </td>
                <td className="p-3 text-muted-foreground">
                  {app.createdAt.toLocaleDateString("en-IN", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}
                </td>
                <td className="p-3">
                  <JobApplicationStatusSelect applicationId={app.id} status={app.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {applications.length === 0 && (
          <p className="p-8 text-center text-muted-foreground">No applications yet.</p>
        )}
      </div>
    </div>
  );
}

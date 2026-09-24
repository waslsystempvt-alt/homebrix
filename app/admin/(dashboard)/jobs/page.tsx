import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { getAdminJobs } from "@/lib/admin/queries";
import { deleteJobAction } from "./actions";

export default async function AdminJobsPage() {
  const jobs = await getAdminJobs();

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Jobs ({jobs.length})</h1>
        <Button asChild>
          <Link href="/admin/jobs/new">+ Add Job</Link>
        </Button>
      </div>

      <div className="overflow-x-auto rounded-lg border">
        <table className="w-full text-sm">
          <thead className="bg-muted/50">
            <tr>
              <th className="text-left p-3 font-medium">Title</th>
              <th className="text-left p-3 font-medium">Department</th>
              <th className="text-left p-3 font-medium">Location</th>
              <th className="text-left p-3 font-medium">Status</th>
              <th className="text-left p-3 font-medium"></th>
            </tr>
          </thead>
          <tbody>
            {jobs.map((job) => (
              <tr key={job.id} className="border-t">
                <td className="p-3">
                  <Link href={`/admin/jobs/${job.id}`} className="font-medium hover:underline">
                    {job.title}
                  </Link>
                </td>
                <td className="p-3">{job.department}</td>
                <td className="p-3">{job.location}</td>
                <td className="p-3">
                  <Badge variant={job.status === "open" ? "default" : "outline"}>{job.status}</Badge>
                </td>
                <td className="p-3">
                  <form action={deleteJobAction.bind(null, job.id)}>
                    <Button type="submit" size="sm" variant="ghost" className="text-destructive">
                      Delete
                    </Button>
                  </form>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {jobs.length === 0 && <p className="p-8 text-center text-muted-foreground">No jobs yet.</p>}
      </div>
    </div>
  );
}

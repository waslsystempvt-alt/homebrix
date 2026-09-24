import { notFound } from "next/navigation";
import { JobForm } from "@/components/admin/JobForm";
import { getAdminJobById } from "@/lib/admin/queries";
import { updateJobAction } from "../actions";

export default async function EditJobPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const job = await getAdminJobById(id);
  if (!job) notFound();

  const boundAction = updateJobAction.bind(null, id);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Edit Job</h1>
      <JobForm action={boundAction} job={job} />
    </div>
  );
}

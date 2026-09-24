import { JobForm } from "@/components/admin/JobForm";
import { createJobAction } from "../actions";

export default function NewJobPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Add Job</h1>
      <JobForm action={createJobAction} />
    </div>
  );
}

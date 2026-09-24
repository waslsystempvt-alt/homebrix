import { ProjectForm } from "@/components/admin/ProjectForm";
import { createProjectAction } from "../actions";

export default function NewProjectPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Add Project</h1>
      <ProjectForm action={createProjectAction} />
    </div>
  );
}

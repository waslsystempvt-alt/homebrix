import { notFound } from "next/navigation";
import { ProjectForm } from "@/components/admin/ProjectForm";
import { ProjectConfigsSection } from "@/components/admin/ProjectConfigsSection";
import { ProjectHighlightsSection } from "@/components/admin/ProjectHighlightsSection";
import { getAdminProjectById } from "@/lib/admin/queries";
import { updateProjectAction } from "../actions";

export default async function EditProjectPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const project = await getAdminProjectById(id);
  if (!project) notFound();

  const boundAction = updateProjectAction.bind(null, id);

  return (
    <div className="space-y-10 max-w-3xl">
      <div>
        <h1 className="text-2xl font-bold">Edit Project</h1>
        <p className="text-sm text-muted-foreground mt-1">
          Slug:{" "}
          <code className="bg-muted px-1.5 py-0.5 rounded text-xs">{project.slug}</code>
        </p>
      </div>

      {/* ── Basic Info Form ── */}
      <section>
        <ProjectForm action={boundAction} project={project} />
      </section>

      {/* ── BHK Configurations ── */}
      <section className="border-t pt-8">
        <ProjectConfigsSection projectId={id} />
      </section>

      {/* ── Highlights & Connectivity ── */}
      <section className="border-t pt-8">
        <ProjectHighlightsSection projectId={id} />
      </section>
    </div>
  );
}

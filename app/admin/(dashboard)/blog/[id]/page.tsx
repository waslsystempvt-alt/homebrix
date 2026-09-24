import { notFound } from "next/navigation";
import { BlogPostForm } from "@/components/admin/BlogPostForm";
import { getAdminBlogPostById } from "@/lib/admin/queries";
import { updateBlogPostAction } from "../actions";

export default async function EditBlogPostPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const post = await getAdminBlogPostById(id);
  if (!post) notFound();

  const boundAction = updateBlogPostAction.bind(null, id);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Edit Blog Post</h1>
      <BlogPostForm action={boundAction} post={post} />
    </div>
  );
}

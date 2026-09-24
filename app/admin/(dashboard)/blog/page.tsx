import Link from "next/link";
import { Button } from "@/components/ui/button";
import { getAdminBlogPosts } from "@/lib/admin/queries";
import { Badge } from "@/components/ui/badge";
import { toggleBlogStatusAction, deleteBlogPostAction } from "./actions";

export default async function AdminBlogPage() {
  const posts = await getAdminBlogPosts();

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Blog Posts ({posts.length})</h1>
        <Button asChild>
          <Link href="/admin/blog/new">+ Add Post</Link>
        </Button>
      </div>

      <div className="overflow-x-auto rounded-lg border">
        <table className="w-full text-sm">
          <thead className="bg-muted/50">
            <tr>
              <th className="text-left p-3 font-medium">Title</th>
              <th className="text-left p-3 font-medium">Category</th>
              <th className="text-left p-3 font-medium">Status</th>
              <th className="text-left p-3 font-medium"></th>
            </tr>
          </thead>
          <tbody>
            {posts.map((post) => (
              <tr key={post.id} className="border-t">
                <td className="p-3 font-medium">
                  <Link href={`/admin/blog/${post.id}`} className="hover:underline">
                    {post.title}
                  </Link>
                </td>
                <td className="p-3 text-muted-foreground">{post.category ?? "—"}</td>
                <td className="p-3">
                  <form action={toggleBlogStatusAction.bind(null, post.id, post.status)}>
                    <button type="submit">
                      <Badge variant={post.status === "published" ? "default" : "outline"}>{post.status}</Badge>
                    </button>
                  </form>
                </td>
                <td className="p-3">
                  <form action={deleteBlogPostAction.bind(null, post.id)}>
                    <Button type="submit" size="sm" variant="ghost" className="text-destructive">
                      Delete
                    </Button>
                  </form>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {posts.length === 0 && <p className="p-8 text-center text-muted-foreground">No posts yet.</p>}
      </div>
    </div>
  );
}

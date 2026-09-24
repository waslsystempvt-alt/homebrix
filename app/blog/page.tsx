import type { Metadata } from "next";
import Link from "next/link";
import { getBlogCategories, getBlogPosts } from "@/lib/db/queries";
import { slugifyCategory } from "@/lib/blog/category";
import { BlogPostCard } from "@/components/blog/BlogPostCard";

export const metadata: Metadata = {
  title: "Real Estate Blog | Homebrix",
  description: "Buying guides, investment tips, city guides, RERA & legal advice, home loan tips, and market reports.",
};

export default async function BlogHubPage() {
  const [posts, categories] = await Promise.all([getBlogPosts(), getBlogCategories()]);

  return (
    <div className="mx-auto max-w-6xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">Homebrix Blog</h1>
      <p className="text-muted-foreground mb-8">Buying guides, market reports, and everything in between</p>

      <div className="flex flex-wrap gap-2 mb-8">
        {categories.map((cat) => (
          <Link
            key={cat}
            href={`/blog/${slugifyCategory(cat)}`}
            className="px-3 py-1.5 rounded-full border text-sm hover:bg-muted"
          >
            {cat}
          </Link>
        ))}
      </div>

      {posts.length === 0 ? (
        <p className="text-muted-foreground text-center py-16">No posts published yet.</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {posts.map((post) => (
            <BlogPostCard key={post.id} post={post} />
          ))}
        </div>
      )}
    </div>
  );
}

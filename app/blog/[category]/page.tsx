import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getBlogCategories, getBlogPosts } from "@/lib/db/queries";
import { resolveCategorySlug } from "@/lib/blog/category";
import { BlogPostCard } from "@/components/blog/BlogPostCard";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ category: string }>;
}): Promise<Metadata> {
  const { category } = await params;
  const categories = await getBlogCategories();
  const resolved = await resolveCategorySlug(category, categories);
  if (!resolved) return {};
  return {
    title: `${resolved} Articles | Homebrix Blog`,
    description: `Read our latest ${resolved.toLowerCase()} articles and guides.`,
  };
}

export default async function BlogCategoryPage({
  params,
}: {
  params: Promise<{ category: string }>;
}) {
  const { category } = await params;
  const categories = await getBlogCategories();
  const resolved = await resolveCategorySlug(category, categories);
  if (!resolved) notFound();

  const posts = await getBlogPosts(resolved);

  return (
    <div className="mx-auto max-w-6xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-8">{resolved}</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {posts.map((post) => (
          <BlogPostCard key={post.id} post={post} />
        ))}
      </div>
    </div>
  );
}

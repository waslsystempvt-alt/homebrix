import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import { notFound } from "next/navigation";
import { getBlogPostBySlug, getRelatedBlogPosts } from "@/lib/db/queries";
import { slugifyCategory } from "@/lib/blog/category";
import { getBlogThumbnail } from "@/lib/media/stockPhotos";
import { BlogContent } from "@/components/blog/BlogContent";
import { BlogPostCard } from "@/components/blog/BlogPostCard";
import { Badge } from "@/components/ui/badge";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ category: string; slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const post = await getBlogPostBySlug(slug);
  if (!post) return {};
  return {
    title: post.metaTitle ?? `${post.title} | Homebrix Blog`,
    description: post.metaDesc ?? post.excerpt ?? undefined,
  };
}

export default async function BlogPostPage({
  params,
}: {
  params: Promise<{ category: string; slug: string }>;
}) {
  const { category, slug } = await params;
  const post = await getBlogPostBySlug(slug);
  if (!post || slugifyCategory(post.category ?? "general") !== category) notFound();

  const related = await getRelatedBlogPosts(post.category, post.slug, 3);

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    headline: post.title,
    datePublished: post.publishedAt?.toISOString(),
    author: post.author ? { "@type": "Person", name: post.author.name } : undefined,
  };

  return (
    <div className="mx-auto max-w-3xl px-4 py-12">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      <nav className="text-sm text-muted-foreground mb-6 flex gap-1.5">
        <Link href="/blog" className="hover:text-primary">Blog</Link>
        <span>/</span>
        <Link href={`/blog/${category}`} className="hover:text-primary">{post.category}</Link>
      </nav>

      {post.category && <Badge variant="secondary" className="mb-3">{post.category}</Badge>}
      <h1 className="text-3xl font-bold mb-3">{post.title}</h1>
      <p className="text-sm text-muted-foreground mb-6">
        {post.author?.name ? `By ${post.author.name} · ` : ""}
        {post.publishedAt?.toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}
        {post.readingTime ? ` · ${post.readingTime} min read` : ""}
      </p>

      <div className="relative aspect-video w-full overflow-hidden rounded-2xl bg-muted mb-8">
        <Image
          src={post.thumbnailUrl ?? getBlogThumbnail(post.id)}
          alt={post.title}
          fill
          sizes="(min-width: 768px) 768px, 100vw"
          className="object-cover"
          priority
        />
      </div>

      <BlogContent content={post.content} />

      {related.length > 0 && (
        <div className="mt-12 pt-8 border-t">
          <h2 className="text-xl font-bold mb-6">Related Articles</h2>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
            {related.map((p) => (
              <BlogPostCard key={p.id} post={p} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

import Link from "next/link";
import { ArrowUpRight } from "lucide-react";
import { getBlogPosts } from "@/lib/db/queries";
import { BlogPostCard } from "@/components/blog/BlogPostCard";
import { SectionHeading } from "@/components/home/SectionHeading";

export async function HomeBlogSection() {
  const posts = (await getBlogPosts()).slice(0, 3);
  if (posts.length === 0) return null;

  return (
    <section className="home-blog">
      <div className="home-blog-head">
        <SectionHeading kicker="FROM THE HOMEBRIX JOURNAL" title="Ideas for living well" subtitle="Useful perspectives for finding, buying, and making the most of your next home." />
        <Link href="/blog" className="home-blog-link">View all stories <ArrowUpRight size={16} /></Link>
      </div>
      <div className="home-blog-grid">
        {posts.map((post) => <BlogPostCard key={post.id} post={post} />)}
      </div>
    </section>
  );
}

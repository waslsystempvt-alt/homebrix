import Link from "next/link";
import Image from "next/image";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { slugifyCategory } from "@/lib/blog/category";
import { getBlogThumbnail } from "@/lib/media/stockPhotos";
import type { BlogPost } from "@/generated/prisma/client";

export function BlogPostCard({ post }: { post: BlogPost }) {
  return (
    <Link href={`/blog/${slugifyCategory(post.category ?? "general")}/${post.slug}`}>
      <Card className="overflow-hidden py-0 gap-0 h-full hover:shadow-md transition-shadow">
        <div className="relative aspect-video bg-muted">
          <Image
            src={post.thumbnailUrl ?? getBlogThumbnail(post.id)}
            alt={post.title}
            fill
            sizes="(min-width: 1024px) 33vw, (min-width: 640px) 45vw, 90vw"
            className="object-cover"
          />
        </div>
        <div className="p-5 space-y-2">
          {post.category && <Badge variant="secondary">{post.category}</Badge>}
          <h3 className="font-semibold leading-snug">{post.title}</h3>
          {post.excerpt && <p className="text-sm text-muted-foreground line-clamp-3">{post.excerpt}</p>}
          <p className="text-xs text-muted-foreground pt-1">
            {post.publishedAt?.toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}
            {post.readingTime ? ` · ${post.readingTime} min read` : ""}
          </p>
        </div>
      </Card>
    </Link>
  );
}

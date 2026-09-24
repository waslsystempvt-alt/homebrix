import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { FileUploadField } from "@/components/upload/FileUploadField";
import type { BlogPost } from "@/generated/prisma/client";

const STATUS_OPTIONS = ["draft", "published"];

interface ContentBlock {
  type: "heading" | "paragraph";
  text: string;
}

function isBlocksJson(value: unknown): value is { blocks: ContentBlock[] } {
  return (
    typeof value === "object" &&
    value !== null &&
    "blocks" in value &&
    Array.isArray((value as { blocks: unknown }).blocks)
  );
}

function blocksToText(content: unknown): string {
  if (!isBlocksJson(content)) return "";
  return content.blocks.map((b) => (b.type === "heading" ? `## ${b.text}` : b.text)).join("\n");
}

export function BlogPostForm({
  action,
  post,
}: {
  action: (formData: FormData) => Promise<void>;
  post?: BlogPost | null;
}) {
  return (
    <form action={action} className="space-y-6 max-w-2xl">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-1.5 col-span-2">
          <Label htmlFor="title">Title</Label>
          <Input id="title" name="title" defaultValue={post?.title} required />
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="category">Category</Label>
          <Input id="category" name="category" defaultValue={post?.category ?? ""} placeholder="Buying Guide" />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="status">Status</Label>
          <Select name="status" defaultValue={post?.status ?? "draft"}>
            <SelectTrigger id="status" className="w-full">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {STATUS_OPTIONS.map((s) => (
                <SelectItem key={s} value={s}>
                  {s}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-1.5 col-span-2">
          <Label htmlFor="excerpt">Excerpt</Label>
          <textarea
            id="excerpt"
            name="excerpt"
            className="w-full rounded-md border bg-transparent px-3 py-2 text-sm min-h-16"
            defaultValue={post?.excerpt ?? ""}
            placeholder="One or two sentences shown on the blog grid"
          />
        </div>

        <div className="col-span-2">
          <FileUploadField
            folder="blog-images"
            accept="image/jpeg,image/png,image/webp"
            label="Cover Image"
            hiddenFieldName="thumbnailUrl"
            defaultUrl={post?.thumbnailUrl ?? undefined}
          />
        </div>

        <div className="space-y-1.5 col-span-2">
          <Label htmlFor="content">Content</Label>
          <textarea
            id="content"
            name="content"
            className="w-full rounded-md border bg-transparent px-3 py-2 text-sm min-h-64 font-mono"
            defaultValue={blocksToText(post?.content)}
            placeholder={"Start a line with ## for a heading.\nEvery other line becomes a paragraph."}
            required
          />
        </div>

        <div className="space-y-1.5 col-span-2">
          <Label htmlFor="tags">Tags (comma separated)</Label>
          <Input id="tags" name="tags" defaultValue={post?.tags.join(", ") ?? ""} placeholder="rera, legal, mumbai" />
        </div>
      </div>

      <Button type="submit">{post ? "Save Changes" : "Create Post"}</Button>
    </form>
  );
}

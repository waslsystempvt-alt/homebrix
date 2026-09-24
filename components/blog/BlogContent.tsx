interface Block {
  type: "heading" | "paragraph";
  text: string;
}

function isBlocksJson(value: unknown): value is { blocks: Block[] } {
  return (
    typeof value === "object" &&
    value !== null &&
    "blocks" in value &&
    Array.isArray((value as { blocks: unknown }).blocks)
  );
}

export function BlogContent({ content }: { content: unknown }) {
  if (!isBlocksJson(content)) return null;

  return (
    <div className="max-w-none">
      {content.blocks.map((block, i) =>
        block.type === "heading" ? (
          <h2 key={i} className="text-xl font-bold mt-6 mb-2">
            {block.text}
          </h2>
        ) : (
          <p key={i} className="text-muted-foreground leading-relaxed mb-4">
            {block.text}
          </p>
        )
      )}
    </div>
  );
}

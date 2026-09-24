"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const EXPAND_THRESHOLD = 220;

export function ProjectDescription({ projectName, description }: { projectName: string; description: string }) {
  const [expanded, setExpanded] = useState(false);
  if (!description) return null;

  const needsToggle = description.length > EXPAND_THRESHOLD;

  return (
    <section className="space-y-3">
      <h2 className="text-xl font-bold">About {projectName}</h2>
      <p className={cn("text-sm text-muted-foreground leading-relaxed", needsToggle && !expanded && "line-clamp-3")}>
        {description}
      </p>
      {needsToggle && (
        <Button
          variant="link"
          size="sm"
          className="h-auto p-0 text-primary"
          onClick={() => setExpanded((v) => !v)}
        >
          {expanded ? "Show Less" : "Read More"}
        </Button>
      )}
    </section>
  );
}

"use client";

import { useState } from "react";
import { CheckCircle2, Loader2, UploadCloud } from "lucide-react";
import { cn } from "@/lib/utils";

export function FileUploadField({
  folder,
  accept,
  label,
  hiddenFieldName,
  defaultUrl,
  onUploaded,
}: {
  folder: string;
  accept: string;
  label: string;
  hiddenFieldName?: string;
  defaultUrl?: string;
  onUploaded?: (url: string) => void;
}) {
  const [status, setStatus] = useState<"idle" | "uploading" | "success" | "error">(
    defaultUrl ? "success" : "idle"
  );
  const [url, setUrl] = useState(defaultUrl ?? "");
  const [fileName, setFileName] = useState("");
  const [error, setError] = useState<string | null>(null);

  async function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setFileName(file.name);
    setStatus("uploading");
    setError(null);

    const formData = new FormData();
    formData.append("file", file);
    formData.append("folder", folder);

    try {
      const res = await fetch("/api/upload", { method: "POST", body: formData });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error ?? "Upload failed");
      setUrl(data.url);
      setStatus("success");
      onUploaded?.(data.url);
    } catch (err) {
      setStatus("error");
      setError(err instanceof Error ? err.message : "Upload failed");
    }
  }

  return (
    <div className="space-y-1.5">
      <label className="text-sm font-medium">{label}</label>
      <label
        className={cn(
          "flex cursor-pointer items-center gap-2 rounded-md border border-dashed px-3 py-2 text-sm transition-colors",
          status === "success"
            ? "border-success/40 text-foreground"
            : "text-muted-foreground hover:border-primary/40"
        )}
      >
        {status === "uploading" ? (
          <Loader2 className="size-4 shrink-0 animate-spin" />
        ) : status === "success" ? (
          <CheckCircle2 className="size-4 shrink-0 text-success" />
        ) : (
          <UploadCloud className="size-4 shrink-0" />
        )}
        <span className="truncate">
          {status === "uploading" ? "Uploading..." : fileName || (defaultUrl ? "Replace file" : "Choose a file")}
        </span>
        <input type="file" accept={accept} className="hidden" onChange={handleChange} />
      </label>
      {error && <p className="text-sm text-destructive">{error}</p>}
      {hiddenFieldName && <input type="hidden" name={hiddenFieldName} value={url} />}
    </div>
  );
}

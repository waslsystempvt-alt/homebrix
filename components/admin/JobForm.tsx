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
import type { Job } from "@/generated/prisma/client";

const STATUS_OPTIONS = ["draft", "open", "closed"];

export function JobForm({
  action,
  job,
}: {
  action: (formData: FormData) => Promise<void>;
  job?: Job | null;
}) {
  return (
    <form action={action} className="space-y-6 max-w-2xl">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-1.5 col-span-2">
          <Label htmlFor="title">Job Title</Label>
          <Input id="title" name="title" defaultValue={job?.title} required />
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="department">Department</Label>
          <Input id="department" name="department" defaultValue={job?.department} required />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="location">Location</Label>
          <Input id="location" name="location" defaultValue={job?.location} required />
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="type">Type</Label>
          <Input id="type" name="type" defaultValue={job?.type ?? "Full-time"} required />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="status">Status</Label>
          <Select name="status" defaultValue={job?.status ?? "open"}>
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
          <Label htmlFor="description">Description</Label>
          <textarea
            id="description"
            name="description"
            className="w-full rounded-md border bg-transparent px-3 py-2 text-sm min-h-28"
            defaultValue={job?.description ?? ""}
            required
          />
        </div>

        <div className="space-y-1.5 col-span-2">
          <Label htmlFor="requirements">Requirements (one per line)</Label>
          <textarea
            id="requirements"
            name="requirements"
            className="w-full rounded-md border bg-transparent px-3 py-2 text-sm min-h-28"
            defaultValue={job?.requirements.join("\n") ?? ""}
            placeholder={"3+ years in real estate sales\nComfortable with day-to-day site visits"}
          />
        </div>
      </div>

      <Button type="submit">{job ? "Save Changes" : "Create Job"}</Button>
    </form>
  );
}

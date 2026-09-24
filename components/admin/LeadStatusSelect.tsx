"use client";

import { useTransition } from "react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { updateLeadStatusAction } from "@/app/admin/(dashboard)/leads/actions";

const STATUSES = [
  "new",
  "assigned",
  "contacted",
  "interested",
  "visit_scheduled",
  "visited",
  "negotiating",
  "converted",
  "lost",
  "invalid",
  "duplicate",
];

export function LeadStatusSelect({ leadId, status }: { leadId: string; status: string }) {
  const [pending, startTransition] = useTransition();

  return (
    <Select
      value={status}
      disabled={pending}
      onValueChange={(value) => startTransition(() => updateLeadStatusAction(leadId, value))}
    >
      <SelectTrigger className="w-40">
        <SelectValue />
      </SelectTrigger>
      <SelectContent>
        {STATUSES.map((s) => (
          <SelectItem key={s} value={s}>
            {s.replace(/_/g, " ")}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}

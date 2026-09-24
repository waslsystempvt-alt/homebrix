"use client";

import { Button } from "@/components/ui/button";
import { useLeadPopup, type LeadPopupType } from "@/components/cta/LeadPopupProvider";
import type { ComponentProps } from "react";

export function CtaButton({
  ctaName,
  leadType,
  subtitle,
  project,
  onClick,
  ...buttonProps
}: {
  ctaName: string;
  leadType: LeadPopupType;
  subtitle?: string;
  project?: { id: string; name: string; builderId?: string };
} & ComponentProps<typeof Button>) {
  const openLeadPopup = useLeadPopup();

  return (
    <Button
      {...buttonProps}
      data-lead-cta="true"
      onClick={(e) => {
        // Run the caller's handler first (e.g. closing the mobile nav sheet)
        // rather than silently dropping it, then open the lead popup.
        onClick?.(e);
        openLeadPopup({ ctaName, leadType, subtitle, project });
      }}
    />
  );
}

"use client";

import { useState } from "react";
import { Slider } from "@/components/ui/slider";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export function DualRangeControl({
  label,
  min,
  max,
  step,
  value,
  onCommit,
  formatValue,
}: {
  label: string;
  min: number;
  max: number;
  step: number;
  value: [number, number];
  onCommit: (value: [number, number]) => void;
  formatValue: (value: number) => string;
}) {
  const [local, setLocal] = useState<[number, number]>(value);

  // Keep in sync when the URL (server-driven prop) changes underneath us,
  // e.g. after "Clear All" or navigating between filter combinations.
  // Adjusting state during render (rather than in an effect) avoids an
  // extra render pass — see https://react.dev/learn/you-might-not-need-an-effect.
  const [prevValue, setPrevValue] = useState(value);
  if (prevValue[0] !== value[0] || prevValue[1] !== value[1]) {
    setPrevValue(value);
    setLocal(value);
  }

  function commit(next: [number, number]) {
    const clamped: [number, number] = [
      Math.min(next[0], next[1]),
      Math.max(next[0], next[1]),
    ];
    setLocal(clamped);
    onCommit(clamped);
  }

  return (
    <div className="space-y-3">
      <h3 className="font-semibold text-sm">{label}</h3>
      <Slider
        value={local}
        onValueChange={(v) => setLocal([v[0], v[1]])}
        onValueCommit={(v) => commit([v[0], v[1]])}
        min={min}
        max={max}
        step={step}
        minStepsBetweenThumbs={1}
      />
      <div className="flex items-center gap-2">
        <div className="flex-1 space-y-1">
          <Label className="text-xs text-muted-foreground">Min</Label>
          <Input
            type="number"
            value={local[0]}
            onChange={(e) => setLocal([Number(e.target.value) || min, local[1]])}
            onBlur={() => commit(local)}
          />
        </div>
        <span className="text-muted-foreground mt-4 text-sm">to</span>
        <div className="flex-1 space-y-1">
          <Label className="text-xs text-muted-foreground">Max</Label>
          <Input
            type="number"
            value={local[1]}
            onChange={(e) => setLocal([local[0], Number(e.target.value) || max])}
            onBlur={() => commit(local)}
          />
        </div>
      </div>
      <div className="flex justify-between text-xs text-muted-foreground">
        <span>{formatValue(local[0])}</span>
        <span>{formatValue(local[1])}</span>
      </div>
    </div>
  );
}

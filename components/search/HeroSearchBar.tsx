"use client";

import { useRef, useState } from "react";
import type { ReactNode } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Search, SlidersHorizontal, Loader2, X } from "lucide-react";
import { BUDGET_BANDS } from "@/lib/search/budgetBands";
import { CONFIG_OPTIONS } from "@/lib/search/configOptions";
import { POSSESSION_RANGES } from "@/lib/search/possession";
import { buildFilterPath } from "@/lib/search/pathFilter";
import { withSearchPrefix } from "@/lib/search/slugParser";
import { cn } from "@/lib/utils";

const TABS = [
  { value: "new-projects-in-", label: "New Projects" },
  { value: "under-construction-in-", label: "Under Construction" },
  { value: "ready-to-move-in-", label: "Ready to Move" },
];

const CITIES = [
  "mumbai",
  "navi-mumbai",
  "thane",
  "pune",
  "bangalore",
  "hyderabad",
  "chennai",
  "delhi",
  "noida",
  "gurgaon",
  "kolkata",
  "ahmedabad",
];

function cityLabel(slug: string) {
  return slug.replace(/-/g, " ").replace(/\b\w/g, (l) => l.toUpperCase());
}

function LabeledSelect({
  label,
  placeholder,
  value,
  onValueChange,
  children,
}: {
  label: string;
  placeholder: string;
  value: string;
  onValueChange: (v: string) => void;
  children: ReactNode;
}) {
  return (
    <Select value={value} onValueChange={onValueChange}>
      <SelectTrigger className="h-auto! w-full items-center justify-between rounded-lg px-3 py-2">
        <span className="flex flex-col items-start gap-0.5 overflow-hidden text-left">
          <span className="text-[11px] text-muted-foreground">{label}</span>
          <SelectValue placeholder={placeholder} className="text-sm font-semibold text-foreground" />
        </span>
      </SelectTrigger>
      <SelectContent>{children}</SelectContent>
    </Select>
  );
}

export function HeroSearchBar() {
  const router = useRouter();

  const [tab, setTab] = useState(TABS[0].value);
  const [city, setCity] = useState("mumbai");
  const [bhk, setBhk] = useState<string>("any");
  const [budget, setBudget] = useState<string>("any");
  const [possession, setPossession] = useState<string>("any");
  const [reraOnly, setReraOnly] = useState(false);
  const [showMoreFilters, setShowMoreFilters] = useState(false);

  const [query, setQuery] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [focused, setFocused] = useState(false);
  const quickSearches = ["3 BHK in Mumbai", "New projects in Thane", "Ready to move in Navi Mumbai"];
  const popularPlaces = ["Thane West", "Majiwada", "Kolshet Road", "Ghodbunder Road", "Hiranandani Estate"];

  async function handleFilterSearch() {
    setError(null);
    if (query.trim()) {
      setLoading(true);
      try {
        const response = await fetch("/api/search/parse", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ query }) });
        const data = await response.json();
        if (!response.ok) { setError(data.error ?? "Try a city or locality name."); return; }
        router.push(data.matched?.status ? data.path : applyTabPrefix(data.path, tab));
      } catch { setError("Search is unavailable. Please try again."); }
      finally { setLoading(false); }
      return;
    }
    const selectedBhk = CONFIG_OPTIONS.find((o) => String(o.bhk) + (o.plus ? "+" : "") === bhk);
    const baseSlug = withSearchPrefix(city, tab);
    const path = buildFilterPath(baseSlug, {
      bhk: selectedBhk?.bhk,
      bhkPlus: selectedBhk?.plus,
      budgetSlug: budget !== "any" ? budget : undefined,
    });
    const params = new URLSearchParams();
    if (possession !== "any") params.set("possession", possession);
    if (reraOnly) params.set("rera", "true");
    const qs = params.toString();
    router.push(qs ? `${path}?${qs}` : path);
  }

  return (
    <div className="mx-auto w-full max-w-xl rounded-2xl border border-slate-200 bg-white p-2 shadow-xl shadow-slate-950/10">
      <div className="space-y-2">
        {/* Top Tabs + Advanced Search */}
        <div className="hidden">
          <div className="flex items-center gap-1.5 sm:gap-2 overflow-x-auto pb-1 sm:pb-0 scrollbar-none">
            {TABS.map((t) => {
              const isActive = tab === t.value;
              return (
                <button
                  key={t.value}
                  type="button"
                  aria-pressed={isActive}
                  onClick={() => setTab(t.value)}
                  className={cn(
                    "rounded-md px-3 py-1.5 text-[11px] font-medium transition-all shrink-0",
                    isActive
                      ? "bg-[#ff474c] text-white shadow-none"
                      : "text-slate-600 hover:text-slate-900 hover:bg-slate-100/80"
                  )}
                >
                  {t.label}
                </button>
              );
            })}
          </div>
          <button
            type="button"
            aria-expanded={showMoreFilters}
            onClick={() => setShowMoreFilters((v) => !v)}
            className="inline-flex items-center gap-1.5 px-2 py-1 text-[11px] font-medium text-slate-500 hover:text-[#ff474c] transition-colors"
          >
            <SlidersHorizontal className="size-3.5 text-[#ff474c]" />
            <span>{showMoreFilters ? "Hide filters" : "Filters"}</span>
          </button>
        </div>

        {/* Compact search row */}
        <div className="flex items-center gap-2">
          {/* City / Location Input */}
          <div className="relative flex min-w-0 flex-1 items-center rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 focus-within:border-[#ff474c] focus-within:ring-2 focus-within:ring-[#ff474c]/10">
            <Search className="size-4 text-[#ff474c] shrink-0 mr-2.5" />
            <div className="flex-1 min-w-0">
              <input
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onFocus={() => setFocused(true)}
                aria-label="Search by city or locality"
                onKeyDown={(e) => { if (e.key === "Enter") { e.preventDefault(); void handleFilterSearch(); } }}
                placeholder="Search city, locality or project"
                className="w-full bg-transparent p-0 text-sm text-slate-900 outline-none placeholder:text-slate-400"
              />
            </div>
            {focused && <button type="button" aria-label="Close search suggestions" className="ml-2 flex size-6 shrink-0 items-center justify-center rounded-full text-slate-400 hover:bg-slate-200 hover:text-slate-700" onMouseDown={(e) => e.preventDefault()} onClick={() => setFocused(false)}><X className="size-3.5" /></button>}
          </div>

          <div className="hidden">
            <div className="flex-1 min-w-0">
              <label className="block text-[10px] font-bold uppercase tracking-wider text-slate-400">City</label>
              <Select value={city} onValueChange={setCity}>
                <SelectTrigger className="h-5 p-0 border-none shadow-none text-xs sm:text-sm font-semibold text-slate-800 hover:bg-transparent focus:ring-0">
                  <SelectValue placeholder="Select city" />
                </SelectTrigger>
                <SelectContent>
                  {CITIES.map((c) => (
                    <SelectItem key={c} value={c}>
                      {cityLabel(c)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="hidden">
            <div className="flex-1 min-w-0">
              <label className="block text-[10px] font-bold uppercase tracking-wider text-slate-400">Budget</label>
              <Select value={budget} onValueChange={setBudget}>
                <SelectTrigger className="h-5 p-0 border-none shadow-none text-xs sm:text-sm font-semibold text-slate-800 hover:bg-transparent focus:ring-0">
                  <SelectValue placeholder="Any Budget" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="any">Any Budget</SelectItem>
                  {BUDGET_BANDS.map((b) => (
                    <SelectItem key={b.slug} value={b.slug}>
                      {b.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="hidden">
            <div className="flex-1 min-w-0">
              <label className="block text-[10px] font-bold uppercase tracking-wider text-slate-400">BHK</label>
              <Select value={bhk} onValueChange={setBhk}>
                <SelectTrigger className="h-5 p-0 border-none shadow-none text-xs sm:text-sm font-semibold text-slate-800 hover:bg-transparent focus:ring-0">
                  <SelectValue placeholder="Any BHK" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="any">Any BHK</SelectItem>
                  {CONFIG_OPTIONS.map((o) => (
                    <SelectItem key={o.label} value={String(o.bhk) + (o.plus ? "+" : "")}>
                      {o.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Submit Search Button */}
          <div>
            <Button
              type="button"
              disabled={loading}
              onClick={handleFilterSearch}
              className="h-11 rounded-xl bg-[#ff474c] px-4 text-xs font-medium text-white shadow-none hover:bg-[#ed343a]"
            >
              <Search className="size-4 shrink-0" />
              <span>{loading ? "Searching…" : "Find a home"}</span>
            </Button>
          </div>
        </div>

        {error && <p role="alert" className="text-left text-xs text-destructive">{error}</p>}
        {focused && (
          <div className="search-suggestions" role="region" aria-label="Search suggestions">
            <div className="search-mode-row">
              {TABS.map((t) => <button key={t.value} type="button" aria-pressed={tab === t.value} className={tab === t.value ? "active" : ""} onMouseDown={(e) => e.preventDefault()} onClick={() => setTab(t.value)}>{t.label}</button>)}
              <button type="button" className="filter-toggle" onMouseDown={(e) => e.preventDefault()} onClick={() => setShowMoreFilters((value) => !value)}><SlidersHorizontal className="size-3.5"/> Filters</button>
            </div>
            <div className="search-suggestion-group">
              <p className="search-suggestion-title">Try a quick search</p>
              {quickSearches.map((item) => (
                <button key={item} type="button" className="search-suggestion-row" onMouseDown={(e) => e.preventDefault()} onClick={() => { setQuery(item); void handleFilterSearch(); }}>
                  <Search className="size-4" /> <span>{item}</span>
                </button>
              ))}
            </div>
            <div className="search-suggestion-group">
              <p className="search-suggestion-title">Popular locations</p>
              <div className="search-place-grid">
                {popularPlaces.map((item) => <button key={item} type="button" onMouseDown={(e) => e.preventDefault()} onClick={() => setQuery(item)}>{item}</button>)}
              </div>
            </div>
          </div>
        )}
        {showMoreFilters && (
          <div className="flex flex-wrap items-center gap-4 rounded-lg bg-slate-50 p-4 border border-slate-200/80 animate-in fade-in-50">
            <div className="flex-1 min-w-44">
              <LabeledSelect label="Possession" placeholder="Any time" value={possession} onValueChange={setPossession}>
                <SelectItem value="any">Any time</SelectItem>
                {POSSESSION_RANGES.map((range) => (
                  <SelectItem key={range} value={range}>
                    {range}
                  </SelectItem>
                ))}
              </LabeledSelect>
            </div>
            <div className="flex items-center gap-2">
              <Checkbox id="hero-rera" checked={reraOnly} onCheckedChange={(c) => setReraOnly(c === true)} />
              <Label htmlFor="hero-rera" className="text-xs sm:text-sm font-semibold text-slate-700 cursor-pointer">
                RERA Verified only
              </Label>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

/** Compact mobile hero search — status tabs + a single search box, no filters or selects. */
export function MobileHeroSearch() {
  const router = useRouter();
  const [tab, setTab] = useState(TABS[0].value);
  const [query, setQuery] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  async function handleSearch(e: React.FormEvent) {
    e.preventDefault();
    if (!query.trim()) {
      setError("Type what you're looking for first.");
      inputRef.current?.focus();
      return;
    }
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/search/parse", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ query }),
      });
      const data = await res.json();
      if (!res.ok) {
        setError(data.error ?? "Couldn't understand that — try adding a city.");
        return;
      }
      // Honor the selected status tab unless the query text already named one.
      const path: string = data.matched?.status ? data.path : applyTabPrefix(data.path, tab);
      router.push(path);
    } catch {
      setError("Something went wrong. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-3">
      <Tabs value={tab} onValueChange={setTab}>
        <TabsList variant="line" className="h-auto! w-full">
          {TABS.map((t) => (
            <TabsTrigger
              key={t.value}
              value={t.value}
              className="h-auto! flex-1 whitespace-normal text-center text-xs leading-tight px-1 py-1.5"
            >
              {t.label}
            </TabsTrigger>
          ))}
        </TabsList>
      </Tabs>
      <form onSubmit={handleSearch} className="flex gap-2">
        <div className="relative flex-1">
          <Search className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 size-4 text-muted-foreground" />
          <Input
            ref={inputRef}
            value={query}
            onChange={(e) => {
              setQuery(e.target.value);
              if (error) setError(null);
            }}
            placeholder="Project, locality or city"
            className="h-11 pl-9 text-sm"
          />
        </div>
        <Button type="submit" size="lg" className="h-11 px-4" disabled={loading}>
          {loading ? <Loader2 className="size-4 animate-spin" /> : <Search className="size-4" />}
          Search
        </Button>
      </form>
      {error && <p className="text-xs text-destructive">{error}</p>}
    </div>
  );
}

function applyTabPrefix(path: string, tabPrefix: string): string {
  const defaultPrefix = TABS[0].value;
  if (tabPrefix === defaultPrefix || !path.startsWith(`/${defaultPrefix}`)) return path;
  return `/${tabPrefix}${path.slice(1 + defaultPrefix.length)}`;
}

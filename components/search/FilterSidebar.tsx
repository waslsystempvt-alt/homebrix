"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { DualRangeControl } from "@/components/search/DualRangeControl";
import { BUDGET_BANDS } from "@/lib/search/budgetBands";
import { CONFIG_OPTIONS } from "@/lib/search/configOptions";
import { buildFilterPath } from "@/lib/search/pathFilter";
import { POSSESSION_RANGES } from "@/lib/search/possession";
import { SEARCH_HUB_PREFIXES } from "@/lib/search/slugParser";
import { parseSearchSlug, withSearchPrefix } from "@/lib/search/slugParser";
import { AREA_RANGE_MAX, AREA_RANGE_MIN, PRICE_RANGE_MAX, PRICE_RANGE_MIN, parseBuilderSlugsParam } from "@/lib/search/types";
import { formatPriceINR } from "@/lib/utils/format";
import type { FacetOption } from "@/lib/search/query";
import { cn } from "@/lib/utils";

const FACET_PREVIEW_COUNT = 6;

const LAUNCH_STAGES = [
  { slug: "pre_launch", label: "Pre-Launch" },
  { slug: "newly_launched", label: "Newly Launched" },
  { slug: "under_construction", label: "Under Construction" },
  { slug: "nearing_possession", label: "Nearing Possession" },
  { slug: "possession_started", label: "Possession Started" },
  { slug: "completed", label: "Completed" },
];

export function FilterSidebar({
  baseSlug,
  activeLocality,
  activeRegion,
  activeBhk,
  activeBhkPlus,
  activeBudgetSlug,
  localityFacets,
  regionFacets,
  builderFacets,
  cityFacets,
}: {
  baseSlug: string;
  activeLocality?: string;
  activeRegion?: string;
  activeBhk?: number;
  activeBhkPlus?: boolean;
  activeBudgetSlug?: string;
  localityFacets: FacetOption[];
  regionFacets: FacetOption[];
  builderFacets: FacetOption[];
  cityFacets: FacetOption[];
}) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [showAllLocalities, setShowAllLocalities] = useState(false);
  const [showAllRegions, setShowAllRegions] = useState(false);
  const [showAllBuilders, setShowAllBuilders] = useState(false);

  // Proximity filter state
  const activeNear = searchParams.get("near");
  const activeWithinKm = searchParams.get("withinKm") ?? "2";
  const [placeQuery, setPlaceQuery] = useState(activeNear ?? "");
  const [placeSuggestions, setPlaceSuggestions] = useState<{ name: string; slug: string; category?: string }[]>([]);
  const [isSearchingPlaces, setIsSearchingPlaces] = useState(false);
  const [showSuggestions, setShowSuggestions] = useState(false);

  const activePossession = searchParams.get("possession");
  const activeLaunchStage = searchParams.get("launchStage");
  const reraOnly = searchParams.get("rera") === "true";
  const activeBuilders = parseBuilderSlugsParam(searchParams.get("builder"));
  const activeBudgetBand = BUDGET_BANDS.find((b) => b.slug === activeBudgetSlug);
  const priceMin = Number(searchParams.get("priceMin") ?? activeBudgetBand?.min ?? PRICE_RANGE_MIN);
  const priceMax = Number(searchParams.get("priceMax") ?? activeBudgetBand?.max ?? PRICE_RANGE_MAX);
  const areaMin = Number(searchParams.get("areaMin") ?? AREA_RANGE_MIN);
  const areaMax = Number(searchParams.get("areaMax") ?? AREA_RANGE_MAX);

  const currentPrefix = parseSearchSlug(baseSlug)?.prefix;
  const currentCitySlug = parseSearchSlug(baseSlug)?.citySlug;

  const handlePlaceQueryChange = async (val: string) => {
    setPlaceQuery(val);
    if (val.trim().length < 2) {
      setPlaceSuggestions([]);
      setShowSuggestions(false);
      return;
    }
    setIsSearchingPlaces(true);
    try {
      const res = await fetch(`/api/places/suggest?q=${encodeURIComponent(val)}&citySlug=${currentCitySlug || ""}`);
      if (res.ok) {
        const data = await res.json();
        setPlaceSuggestions(data);
        setShowSuggestions(true);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setIsSearchingPlaces(false);
    }
  };

  const selectPlace = (place: { name: string; slug: string }) => {
    setPlaceQuery(place.name);
    setShowSuggestions(false);
    updateQueryOnly((params) => {
      params.set("near", place.slug);
      if (!params.has("withinKm")) params.set("withinKm", "2");
    });
  };

  const clearProximity = () => {
    setPlaceQuery("");
    setPlaceSuggestions([]);
    setShowSuggestions(false);
    updateQueryOnly((params) => {
      params.delete("near");
      params.delete("withinKm");
    });
  };

  // Preserves non-canonical filters (sort, possession, rera, builder, price,
  // area) when following a real link to a different geo/city facet.
  const qs = searchParams.toString();
  function withQs(path: string) {
    return qs ? `${path}?${qs}` : path;
  }

  // Real, crawlable hrefs for the geo facets below — city, region and
  // locality are all canonical path segments, so search engines should be
  // able to follow these links directly instead of relying on JS clicks.
  function cityHref(slug: string) {
    const path = buildFilterPath(withSearchPrefix(slug, currentPrefix ?? "new-projects-in-"), {
      bhk: activeBhk,
      bhkPlus: activeBhkPlus,
      budgetSlug: activeBudgetSlug,
    });
    return withQs(path);
  }

  function regionHref(slug: string) {
    const path = buildFilterPath(baseSlug, {
      region: activeRegion === slug ? undefined : slug,
      bhk: activeBhk,
      bhkPlus: activeBhkPlus,
      budgetSlug: activeBudgetSlug,
    });
    return withQs(path);
  }

  function localityHref(slug: string) {
    const path = buildFilterPath(baseSlug, {
      locality: activeLocality === slug ? undefined : slug,
      bhk: activeBhk,
      bhkPlus: activeBhkPlus,
      budgetSlug: activeBudgetSlug,
    });
    return withQs(path);
  }

  // BHK, budget, and locality/region are SEO path segments — every combination
  // gets its own indexable, bookmarkable URL instead of a query string.
  function navigateToFilters(next: {
    bhk?: number;
    bhkPlus?: boolean;
    budgetSlug?: string;
    locality?: string;
    region?: string;
  }) {
    const path = buildFilterPath(baseSlug, {
      locality: "locality" in next ? next.locality : "region" in next ? undefined : activeLocality,
      region: "region" in next ? next.region : "locality" in next ? undefined : activeRegion,
      bhk: "bhk" in next ? next.bhk : activeBhk,
      bhkPlus: "bhk" in next ? next.bhkPlus : activeBhkPlus,
      budgetSlug: "budgetSlug" in next ? next.budgetSlug : activeBudgetSlug,
    });
    // Filter changes update the results in place — the sidebar and result
    // grid stay exactly where they are instead of the browser resetting
    // scroll to the top of the whole page on every click.
    router.push(withQs(path), { scroll: false });
  }

  function toggleBhk(option: (typeof CONFIG_OPTIONS)[number]) {
    const isActive = activeBhk === option.bhk && !!activeBhkPlus === !!option.plus;
    navigateToFilters(isActive ? { bhk: undefined, bhkPlus: undefined } : { bhk: option.bhk, bhkPlus: option.plus });
  }

  // A preset budget band (canonical path segment) and the custom price slider
  // (query params) both constrain price — letting both stay active at once
  // produces a redundant, confusing URL like /1-crore-to-2-crore?priceMax=...
  // so picking one always clears the other.
  function setBudget(slug: string) {
    updateQueryOnly(
      (params) => {
        params.delete("priceMin");
        params.delete("priceMax");
      },
      { budgetSlug: activeBudgetSlug === slug ? undefined : slug }
    );
  }

  function updateQueryOnly(
    mutator: (params: URLSearchParams) => void,
    pathOverrides: { budgetSlug?: string } = {}
  ) {
    const params = new URLSearchParams(searchParams.toString());
    mutator(params);
    params.delete("page");
    const path = buildFilterPath(baseSlug, {
      locality: activeLocality,
      region: activeRegion,
      bhk: activeBhk,
      bhkPlus: activeBhkPlus,
      budgetSlug: "budgetSlug" in pathOverrides ? pathOverrides.budgetSlug : activeBudgetSlug,
    });
    const qs = params.toString();
    router.push(qs ? `${path}?${qs}` : path, { scroll: false });
  }

  function setPossession(range: string) {
    updateQueryOnly((params) => {
      if (activePossession === range) params.delete("possession");
      else params.set("possession", range);
    });
  }

  function setLaunchStage(stageSlug: string) {
    updateQueryOnly((params) => {
      if (activeLaunchStage === stageSlug) params.delete("launchStage");
      else params.set("launchStage", stageSlug);
    });
  }

  function setWithinKm(kmStr: string) {
    updateQueryOnly((params) => {
      params.set("withinKm", kmStr);
    });
  }

  function goToStatus(prefix: string) {
    if (!currentPrefix) return;
    const parsed = parseSearchSlug(baseSlug);
    if (!parsed) return;
    const newBaseSlug = withSearchPrefix(parsed.citySlug, prefix);
    const path = buildFilterPath(newBaseSlug, {
      locality: activeLocality,
      region: activeRegion,
      bhk: activeBhk,
      bhkPlus: activeBhkPlus,
      budgetSlug: activeBudgetSlug,
    });
    const qs = searchParams.toString();
    router.push(qs ? `${path}?${qs}` : path, { scroll: false });
  }

  function toggleRera(checked: boolean) {
    updateQueryOnly((params) => {
      if (checked) params.set("rera", "true");
      else params.delete("rera");
    });
  }

  function toggleBuilder(slug: string) {
    updateQueryOnly((params) => {
      const current = parseBuilderSlugsParam(params.get("builder"));
      const next = current.includes(slug) ? current.filter((b) => b !== slug) : [...current, slug];
      if (next.length > 0) params.set("builder", next.join(","));
      else params.delete("builder");
    });
  }

  function commitPriceRange([min, max]: [number, number]) {
    updateQueryOnly(
      (params) => {
        if (min <= PRICE_RANGE_MIN) params.delete("priceMin");
        else params.set("priceMin", String(min));
        if (max >= Number(PRICE_RANGE_MAX)) params.delete("priceMax");
        else params.set("priceMax", String(max));
      },
      { budgetSlug: undefined }
    );
  }

  function commitAreaRange([min, max]: [number, number]) {
    updateQueryOnly((params) => {
      if (min <= AREA_RANGE_MIN) params.delete("areaMin");
      else params.set("areaMin", String(min));
      if (max >= AREA_RANGE_MAX) params.delete("areaMax");
      else params.set("areaMax", String(max));
    });
  }

  function clearAll() {
    router.push(`/${baseSlug}`, { scroll: false });
  }

  const localityList = showAllLocalities ? localityFacets : localityFacets.slice(0, FACET_PREVIEW_COUNT);
  const regionList = showAllRegions ? regionFacets : regionFacets.slice(0, FACET_PREVIEW_COUNT);
  const builderList = showAllBuilders ? builderFacets : builderFacets.slice(0, FACET_PREVIEW_COUNT);

  return (
    <aside className="w-full shrink-0 space-y-6 rounded-2xl border border-[#f0e5e2] bg-white p-5 shadow-[0_8px_24px_rgba(53,46,50,0.05)] lg:w-72 lg:sticky lg:top-20 lg:self-start lg:max-h-[calc(100vh-6rem)] lg:overflow-y-auto lg:overscroll-contain">
      {/* Near a Landmark (Proximity) */}
      <div className="relative space-y-2">
        <h3 className="font-semibold text-sm">Near a Landmark</h3>
        <div className="flex items-center gap-2">
          <div className="relative flex-1">
            <input
              type="text"
              value={placeQuery}
              onChange={(e) => handlePlaceQueryChange(e.target.value)}
              onFocus={() => placeSuggestions.length > 0 && setShowSuggestions(true)}
              placeholder="Station, Mall, Hospital..."
              className="w-full px-3 py-1.5 text-sm border rounded-md bg-background focus:outline-none focus:ring-1 focus:ring-primary"
            />
            {isSearchingPlaces && (
              <span className="absolute right-2 top-2 text-xs text-muted-foreground animate-pulse">...</span>
            )}
            {showSuggestions && placeSuggestions.length > 0 && (
              <div className="absolute z-20 top-full left-0 right-0 mt-1 bg-popover text-popover-foreground border rounded-md shadow-md max-h-48 overflow-y-auto">
                {placeSuggestions.map((item) => (
                  <button
                    key={item.slug}
                    type="button"
                    onClick={() => selectPlace(item)}
                    className="w-full text-left px-3 py-2 text-xs hover:bg-accent hover:text-accent-foreground flex justify-between items-center"
                  >
                    <span className="font-medium">{item.name}</span>
                    {item.category && (
                      <span className="text-[10px] text-muted-foreground uppercase">
                        {item.category.replace(/_/g, " ")}
                      </span>
                    )}
                  </button>
                ))}
              </div>
            )}
          </div>
          {activeNear && (
            <select
              value={activeWithinKm}
              onChange={(e) => setWithinKm(e.target.value)}
              className="px-2 py-1.5 text-xs border rounded-md bg-background focus:outline-none"
            >
              <option value="0.5">within 500m</option>
              <option value="1">within 1km</option>
              <option value="2">within 2km</option>
              <option value="5">within 5km</option>
            </select>
          )}
        </div>
        {activeNear && (
          <div className="flex items-center justify-between text-xs text-muted-foreground bg-muted/50 px-2 py-1 rounded-md">
            <span>
              Filtering near: <strong className="text-foreground">{activeNear}</strong>
            </span>
            <button onClick={clearProximity} className="hover:text-foreground font-bold">
              ×
            </button>
          </div>
        )}
      </div>

      <div>
        <h3 className="font-semibold mb-3 text-sm">Configuration</h3>
        <div className="flex flex-wrap gap-2">
          {CONFIG_OPTIONS.map((option) => {
            const isActive = activeBhk === option.bhk && !!activeBhkPlus === !!option.plus;
            return (
              <button
                key={option.label}
                onClick={() => toggleBhk(option)}
                className={cn(
                  "px-3 py-1.5 rounded-full border text-sm transition-colors",
                  isActive ? "bg-primary text-primary-foreground border-primary" : "hover:bg-muted"
                )}
              >
                {option.label}
              </button>
            );
          })}
        </div>
      </div>

      {/* Launch Stage */}
      <div>
        <h3 className="font-semibold mb-3 text-sm">Launch Stage</h3>
        <div className="flex flex-wrap gap-2">
          {LAUNCH_STAGES.map((stage) => (
            <button
              key={stage.slug}
              onClick={() => setLaunchStage(stage.slug)}
              className={cn(
                "px-3 py-1.5 rounded-full border text-xs transition-colors",
                activeLaunchStage === stage.slug
                  ? "bg-primary text-primary-foreground border-primary"
                  : "hover:bg-muted"
              )}
            >
              {stage.label}
            </button>
          ))}
        </div>
      </div>

      <div>
        <h3 className="font-semibold mb-3 text-sm">Budget</h3>
        <div className="flex flex-col gap-2">
          {BUDGET_BANDS.map((band) => (
            <button
              key={band.slug}
              onClick={() => setBudget(band.slug)}
              className={cn(
                "px-3 py-1.5 rounded-md border text-sm text-left transition-colors",
                activeBudgetSlug === band.slug
                  ? "bg-primary text-primary-foreground border-primary"
                  : "hover:bg-muted"
              )}
            >
              {band.label}
            </button>
          ))}
        </div>
      </div>

      <DualRangeControl
        label="Custom Price Range"
        min={PRICE_RANGE_MIN}
        max={Number(PRICE_RANGE_MAX)}
        step={500000}
        value={[priceMin, priceMax]}
        onCommit={commitPriceRange}
        formatValue={(v) => (v >= Number(PRICE_RANGE_MAX) ? `${formatPriceINR(v)}+` : formatPriceINR(v))}
      />

      <DualRangeControl
        label="Carpet Area"
        min={AREA_RANGE_MIN}
        max={AREA_RANGE_MAX}
        step={50}
        value={[areaMin, areaMax]}
        onCommit={commitAreaRange}
        formatValue={(v) => (v >= AREA_RANGE_MAX ? `${v}+ sq.ft` : `${v} sq.ft`)}
      />

      <div>
        <h3 className="font-semibold mb-3 text-sm">Possession</h3>
        <div className="flex flex-wrap gap-2 mb-2">
          {SEARCH_HUB_PREFIXES.filter((p) => p.prefix !== currentPrefix && p.status !== null).map((p) => (
            <button
              key={p.prefix}
              onClick={() => goToStatus(p.prefix)}
              className="px-3 py-1.5 rounded-full border text-sm hover:bg-muted transition-colors"
            >
              {p.heading.replace(" Projects", "")}
            </button>
          ))}
        </div>
        <div className="flex flex-wrap gap-2">
          {POSSESSION_RANGES.map((range) => (
            <button
              key={range}
              onClick={() => setPossession(range)}
              className={cn(
                "px-3 py-1.5 rounded-full border text-sm transition-colors",
                activePossession === range ? "bg-primary text-primary-foreground border-primary" : "hover:bg-muted"
              )}
            >
              {range}
            </button>
          ))}
        </div>
      </div>

      {cityFacets.length > 1 && (
        <div>
          <h3 className="font-semibold mb-3 text-sm">Cities</h3>
          <div className="flex flex-col gap-1">
            {cityFacets.map((facet) => {
              const isActive = facet.slug === currentCitySlug;
              return (
                <Link
                  key={facet.slug}
                  href={cityHref(facet.slug)}
                  scroll={false}
                  aria-current={isActive ? "page" : undefined}
                  className={cn(
                    "flex items-center justify-between px-2 py-1.5 rounded-md text-sm transition-colors",
                    isActive ? "bg-primary text-primary-foreground" : "hover:bg-muted"
                  )}
                >
                  <span>{facet.name}</span>
                  <span className={cn("text-xs", isActive ? "text-primary-foreground/80" : "text-muted-foreground")}>
                    {facet.count}
                  </span>
                </Link>
              );
            })}
          </div>
        </div>
      )}

      {regionFacets.length > 0 && (
        <div>
          <h3 className="font-semibold mb-3 text-sm">Regions</h3>
          <div className="flex flex-col gap-1">
            {regionList.map((facet) => (
              <Link
                key={facet.slug}
                href={regionHref(facet.slug)}
                scroll={false}
                aria-current={activeRegion === facet.slug ? "page" : undefined}
                className={cn(
                  "flex items-center justify-between px-2 py-1.5 rounded-md text-sm transition-colors",
                  activeRegion === facet.slug ? "bg-primary text-primary-foreground" : "hover:bg-muted"
                )}
              >
                <span>{facet.name}</span>
                <span className={cn("text-xs", activeRegion === facet.slug ? "text-primary-foreground/80" : "text-muted-foreground")}>
                  {facet.count}
                </span>
              </Link>
            ))}
          </div>
          {regionFacets.length > FACET_PREVIEW_COUNT && (
            <button
              onClick={() => setShowAllRegions((v) => !v)}
              className="text-sm text-primary hover:underline mt-1"
            >
              {showAllRegions ? "Show less" : `+${regionFacets.length - FACET_PREVIEW_COUNT} more regions`}
            </button>
          )}
        </div>
      )}

      {localityFacets.length > 0 && (
        <div>
          <h3 className="font-semibold mb-3 text-sm">Localities</h3>
          <div className="flex flex-col gap-1">
            {localityList.map((facet) => (
              <Link
                key={facet.slug}
                href={localityHref(facet.slug)}
                scroll={false}
                aria-current={activeLocality === facet.slug ? "page" : undefined}
                className={cn(
                  "flex items-center justify-between px-2 py-1.5 rounded-md text-sm transition-colors",
                  activeLocality === facet.slug ? "bg-primary text-primary-foreground" : "hover:bg-muted"
                )}
              >
                <span>{facet.name}</span>
                <span className={cn("text-xs", activeLocality === facet.slug ? "text-primary-foreground/80" : "text-muted-foreground")}>
                  {facet.count}
                </span>
              </Link>
            ))}
          </div>
          {localityFacets.length > FACET_PREVIEW_COUNT && (
            <button
              onClick={() => setShowAllLocalities((v) => !v)}
              className="text-sm text-primary hover:underline mt-1"
            >
              {showAllLocalities ? "Show less" : `+${localityFacets.length - FACET_PREVIEW_COUNT} more localities`}
            </button>
          )}
        </div>
      )}

      {builderFacets.length > 0 && (
        <div>
          <h3 className="font-semibold mb-3 text-sm">Builders</h3>
          <div className="flex flex-col gap-2">
            {builderList.map((facet) => (
              <div key={facet.slug} className="flex items-center gap-2">
                <Checkbox
                  id={`builder-${facet.slug}`}
                  aria-label={`Filter by ${facet.name}`}
                  checked={activeBuilders.includes(facet.slug)}
                  onCheckedChange={() => toggleBuilder(facet.slug)}
                />
                <Link
                  href={`/builder/${facet.slug}`}
                  className="flex-1 text-sm hover:text-primary hover:underline line-clamp-1"
                >
                  {facet.name}
                </Link>
                <span className="text-xs text-muted-foreground">{facet.count}</span>
              </div>
            ))}
          </div>
          {builderFacets.length > FACET_PREVIEW_COUNT && (
            <button
              onClick={() => setShowAllBuilders((v) => !v)}
              className="text-sm text-primary hover:underline mt-1"
            >
              {showAllBuilders ? "Show less" : `+${builderFacets.length - FACET_PREVIEW_COUNT} more builders`}
            </button>
          )}
        </div>
      )}

      <div className="flex items-center gap-2">
        <Checkbox id="rera" checked={reraOnly} onCheckedChange={(c) => toggleRera(c === true)} />
        <Label htmlFor="rera" className="text-sm font-normal cursor-pointer">
          RERA Verified only
        </Label>
      </div>

      <Button variant="outline" size="sm" className="w-full" onClick={clearAll}>
        Clear All
      </Button>
    </aside>
  );
}

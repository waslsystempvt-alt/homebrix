import { prisma } from "@/lib/db/prisma";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { addConfigAction, deleteConfigAction } from "@/app/admin/(dashboard)/projects/[id]/configs/actions";
import type { ProjectConfig } from "@/generated/prisma/client";

const BHK_OPTIONS = [
  { value: 0, label: "Studio" },
  { value: 1, label: "1 BHK" },
  { value: 2, label: "2 BHK" },
  { value: 3, label: "3 BHK" },
  { value: 4, label: "4 BHK" },
  { value: 5, label: "5 BHK" },
];

function formatPrice(price: bigint | null) {
  if (!price) return "—";
  const n = Number(price);
  if (n >= 10000000) return `₹${(n / 10000000).toFixed(1)} Cr`;
  if (n >= 100000) return `₹${(n / 100000).toFixed(1)} L`;
  return `₹${n.toLocaleString("en-IN")}`;
}

export async function ProjectConfigsSection({ projectId }: { projectId: string }) {
  const configs = await prisma.projectConfig.findMany({
    where: { projectId },
    orderBy: { displayOrder: "asc" },
  });

  const addAction = addConfigAction.bind(null, projectId);

  return (
    <div className="space-y-6">
      <div>
        <h3 className="text-base font-semibold mb-1">BHK Configurations</h3>
        <p className="text-sm text-muted-foreground">
          Add unit types available in this project.
        </p>
      </div>

      {/* Existing Configs Table */}
      {configs.length > 0 ? (
        <div className="rounded-md border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-muted-foreground">
              <tr>
                <th className="text-left px-4 py-2 font-medium">Type</th>
                <th className="text-left px-4 py-2 font-medium">Area (sqft)</th>
                <th className="text-left px-4 py-2 font-medium">Price Range</th>
                <th className="text-left px-4 py-2 font-medium">Status</th>
                <th className="px-4 py-2"></th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {configs.map((config) => (
                <tr key={config.id} className="hover:bg-muted/30 transition-colors">
                  <td className="px-4 py-3 font-medium">
                    {BHK_OPTIONS.find((b) => b.value === config.bhk)?.label ?? `${config.bhk} BHK`}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground">
                    {config.areaCarpetMin && config.areaCarpetMax
                      ? `${config.areaCarpetMin}–${config.areaCarpetMax}`
                      : config.areaCarpetMin ?? config.areaCarpetMax ?? "—"}
                  </td>
                  <td className="px-4 py-3">
                    {formatPrice(config.priceMin)} – {formatPrice(config.priceMax)}
                  </td>
                  <td className="px-4 py-3">
                    <span
                      className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${
                        config.isAvailable
                          ? "bg-green-50 text-green-700"
                          : "bg-gray-100 text-gray-600"
                      }`}
                    >
                      {config.isAvailable ? "Available" : "Sold Out"}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <form
                      action={deleteConfigAction.bind(null, config.id, projectId)}
                      className="inline"
                    >
                      <button
                        type="submit"
                        className="text-xs text-destructive hover:underline"
                      >
                        Remove
                      </button>
                    </form>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div className="rounded-md border border-dashed p-6 text-center text-muted-foreground text-sm">
          No configurations yet. Add the first BHK type below.
        </div>
      )}

      {/* Add New Config Form */}
      <div className="rounded-md border p-4 space-y-4 bg-muted/20">
        <h4 className="text-sm font-medium">Add Configuration</h4>
        <form action={addAction} className="grid grid-cols-2 gap-3 sm:grid-cols-3">
          {/* BHK Type */}
          <div className="space-y-1.5">
            <Label htmlFor="cfg-bhk" className="text-xs">Unit Type *</Label>
            <Select name="bhk" defaultValue="2">
              <SelectTrigger id="cfg-bhk" className="h-8 text-sm">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {BHK_OPTIONS.map((b) => (
                  <SelectItem key={b.value} value={String(b.value)}>
                    {b.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Carpet Area Min */}
          <div className="space-y-1.5">
            <Label htmlFor="cfg-area-min" className="text-xs">Carpet Area Min (sqft)</Label>
            <Input id="cfg-area-min" name="areaCarpetMin" type="number" className="h-8 text-sm" placeholder="650" />
          </div>

          {/* Carpet Area Max */}
          <div className="space-y-1.5">
            <Label htmlFor="cfg-area-max" className="text-xs">Carpet Area Max (sqft)</Label>
            <Input id="cfg-area-max" name="areaCarpetMax" type="number" className="h-8 text-sm" placeholder="750" />
          </div>

          {/* Price Min */}
          <div className="space-y-1.5">
            <Label htmlFor="cfg-price-min" className="text-xs">Price Min (₹)</Label>
            <Input id="cfg-price-min" name="priceMin" type="number" className="h-8 text-sm" placeholder="8500000" />
          </div>

          {/* Price Max */}
          <div className="space-y-1.5">
            <Label htmlFor="cfg-price-max" className="text-xs">Price Max (₹)</Label>
            <Input id="cfg-price-max" name="priceMax" type="number" className="h-8 text-sm" placeholder="10000000" />
          </div>

          {/* Display Order */}
          <div className="space-y-1.5">
            <Label htmlFor="cfg-order" className="text-xs">Sort Order</Label>
            <Input id="cfg-order" name="displayOrder" type="number" className="h-8 text-sm" defaultValue="0" />
          </div>

          <div className="col-span-2 sm:col-span-3 flex justify-end pt-1">
            <Button type="submit" size="sm">
              + Add Configuration
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}

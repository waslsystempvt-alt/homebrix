import { PlaceForm } from "@/components/admin/PlaceForm";
import { createPlaceAction } from "../actions";

export default function NewPlacePage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Add Place / POI</h1>
        <p className="text-sm text-muted-foreground mt-1">
          Add a landmark to the master database. Once added, it can be linked to
          projects and optionally used to generate SEO pages.
        </p>
      </div>
      <PlaceForm action={createPlaceAction} />
    </div>
  );
}

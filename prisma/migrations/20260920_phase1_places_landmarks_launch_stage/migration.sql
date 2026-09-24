-- Phase 1: Places master POI table, extended landmarks, launch stage

-- CreateEnum
CREATE TYPE "LaunchStage" AS ENUM ('pre_launch', 'newly_launched', 'under_construction', 'nearing_possession', 'possession_started', 'completed');

-- CreateEnum
CREATE TYPE "TravelMode" AS ENUM ('walk', 'drive', 'auto', 'train', 'metro', 'bus');

-- CreateEnum
CREATE TYPE "PlaceSource" AS ENUM ('builder', 'rera', 'manual', 'osm');

-- AlterEnum: Expand LandmarkCategory
BEGIN;
CREATE TYPE "LandmarkCategory_new" AS ENUM (
  'railway_station', 'metro_station', 'bus_stop', 'bus_depot', 'highway', 'airport', 'expressway',
  'school', 'college_university', 'university', 'coaching',
  'hospital', 'clinic', 'pharmacy',
  'mall', 'market', 'supermarket', 'wholesale_market',
  'restaurant', 'hotel', 'cinema', 'resort',
  'it_park', 'sez', 'business_park', 'office_hub',
  'park', 'garden', 'sports_complex', 'stadium',
  'temple', 'mosque', 'church', 'gurudwara',
  'bank',
  'locality', 'colony', 'sector', 'nagar',
  'other'
);
ALTER TABLE "project_landmarks" ALTER COLUMN "category" TYPE "LandmarkCategory_new" USING ("category"::text::("LandmarkCategory_new"));
ALTER TYPE "LandmarkCategory" RENAME TO "LandmarkCategory_old";
ALTER TYPE "LandmarkCategory_new" RENAME TO "LandmarkCategory";
DROP TYPE "public"."LandmarkCategory_old";
COMMIT;

-- CreateTable: places
CREATE TABLE "places" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "slug" VARCHAR(255) NOT NULL,
    "seo_slug" VARCHAR(300) NOT NULL,
    "category" "LandmarkCategory" NOT NULL,
    "city_id" INTEGER,
    "locality_id" INTEGER,
    "lat" DECIMAL(10,8),
    "lng" DECIMAL(11,8),
    "address" TEXT,
    "photo_url" TEXT,
    "rating" DECIMAL(3,1),
    "review_count" INTEGER,
    "importance_score" INTEGER NOT NULL DEFAULT 50,
    "create_seo_page" BOOLEAN NOT NULL DEFAULT false,
    "seo_priority" INTEGER NOT NULL DEFAULT 0,
    "source" "PlaceSource" NOT NULL DEFAULT 'manual',
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "places_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "places_slug_key" ON "places"("slug");
CREATE UNIQUE INDEX "places_seo_slug_key" ON "places"("seo_slug");
CREATE INDEX "places_category_idx" ON "places"("category");
CREATE INDEX "places_city_id_idx" ON "places"("city_id");

-- AlterTable: extend project_landmarks
ALTER TABLE "project_landmarks"
  ADD COLUMN "place_id" TEXT,
  ADD COLUMN "distance_m" INTEGER,
  ADD COLUMN "distance_label" VARCHAR(30),
  ADD COLUMN "travel_mode" "TravelMode" NOT NULL DEFAULT 'drive',
  ADD COLUMN "lat" DECIMAL(10,8),
  ADD COLUMN "lng" DECIMAL(11,8),
  ADD COLUMN "show_on_map" BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN "is_featured" BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN "source" "PlaceSource" NOT NULL DEFAULT 'manual',
  ALTER COLUMN "travel_minutes" DROP NOT NULL;

CREATE INDEX "project_landmarks_place_id_idx" ON "project_landmarks"("place_id");

ALTER TABLE "project_landmarks"
  ADD CONSTRAINT "project_landmarks_place_id_fkey"
  FOREIGN KEY ("place_id") REFERENCES "places"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AlterTable: add launchStage to projects
ALTER TABLE "projects" ADD COLUMN "launch_stage" "LaunchStage";

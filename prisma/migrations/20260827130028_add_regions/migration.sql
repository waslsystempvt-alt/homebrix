-- AlterTable
ALTER TABLE "localities" ADD COLUMN     "region_id" INTEGER;

-- CreateTable
CREATE TABLE "regions" (
    "id" SERIAL NOT NULL,
    "city_id" INTEGER NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "slug" VARCHAR(150) NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "regions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "regions_city_id_slug_key" ON "regions"("city_id", "slug");

-- AddForeignKey
ALTER TABLE "regions" ADD CONSTRAINT "regions_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "localities" ADD CONSTRAINT "localities_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "regions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

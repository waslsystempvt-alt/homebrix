-- CreateEnum
CREATE TYPE "LandmarkCategory" AS ENUM ('school', 'hospital', 'shopping', 'college_university');

-- CreateTable
CREATE TABLE "project_faqs" (
    "id" TEXT NOT NULL,
    "project_id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "answer" TEXT NOT NULL,
    "display_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "project_faqs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_landmarks" (
    "id" TEXT NOT NULL,
    "project_id" TEXT NOT NULL,
    "category" "LandmarkCategory" NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "travel_minutes" INTEGER NOT NULL,
    "display_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "project_landmarks_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "project_faqs_project_id_idx" ON "project_faqs"("project_id");

-- CreateIndex
CREATE INDEX "project_landmarks_project_id_idx" ON "project_landmarks"("project_id");

-- AddForeignKey
ALTER TABLE "project_faqs" ADD CONSTRAINT "project_faqs_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "project_landmarks" ADD CONSTRAINT "project_landmarks_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

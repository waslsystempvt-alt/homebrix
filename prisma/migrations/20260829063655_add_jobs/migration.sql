-- CreateEnum
CREATE TYPE "JobStatus" AS ENUM ('draft', 'open', 'closed');

-- CreateTable
CREATE TABLE "jobs" (
    "id" TEXT NOT NULL,
    "slug" VARCHAR(150) NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "department" VARCHAR(100) NOT NULL,
    "location" VARCHAR(150) NOT NULL,
    "type" VARCHAR(50) NOT NULL,
    "description" TEXT NOT NULL,
    "requirements" TEXT[],
    "status" "JobStatus" NOT NULL DEFAULT 'open',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "jobs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "jobs_slug_key" ON "jobs"("slug");

-- CreateIndex
CREATE INDEX "jobs_status_idx" ON "jobs"("status");

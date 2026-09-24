-- CreateEnum
CREATE TYPE "ConstructionStatus" AS ENUM ('new_launch', 'under_construction', 'ready_to_move');

-- CreateEnum
CREATE TYPE "ProjectStatus" AS ENUM ('active', 'sold_out', 'on_hold', 'archived');

-- CreateEnum
CREATE TYPE "MediaType" AS ENUM ('photo', 'video', 'floor_plan', 'brochure', 'site_plan', 'construction_photo', 'document');

-- CreateEnum
CREATE TYPE "LeadType" AS ENUM ('contact_form', 'brochure', 'site_visit', 'callback', 'chatbot', 'whatsapp', 'call');

-- CreateEnum
CREATE TYPE "LeadSource" AS ENUM ('organic', 'paid', 'chatbot', 'whatsapp', 'referral', 'direct', 'social');

-- CreateEnum
CREATE TYPE "LeadStatus" AS ENUM ('new', 'assigned', 'contacted', 'interested', 'visit_scheduled', 'visited', 'negotiating', 'converted', 'lost', 'invalid', 'duplicate');

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('buyer', 'cms_editor', 'cms_admin', 'super_admin');

-- CreateEnum
CREATE TYPE "AlertFrequency" AS ENUM ('instant', 'daily', 'weekly', 'off');

-- CreateEnum
CREATE TYPE "BlogStatus" AS ENUM ('draft', 'published', 'archived');

-- CreateEnum
CREATE TYPE "BoostPlan" AS ENUM ('featured', 'premium', 'spotlight');

-- CreateEnum
CREATE TYPE "BoostStatus" AS ENUM ('pending', 'active', 'expired', 'failed');

-- CreateTable
CREATE TABLE "states" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "stamp_duty" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "states_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cities" (
    "id" SERIAL NOT NULL,
    "state_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "lat" DECIMAL(10,8),
    "lng" DECIMAL(11,8),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_metro" BOOLEAN NOT NULL DEFAULT false,
    "sort_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "cities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "localities" (
    "id" SERIAL NOT NULL,
    "city_id" INTEGER NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "slug" VARCHAR(150) NOT NULL,
    "lat" DECIMAL(10,8),
    "lng" DECIMAL(11,8),
    "avg_price_sqft" INTEGER,
    "project_count" INTEGER NOT NULL DEFAULT 0,
    "is_popular" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "localities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "builders" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "slug" VARCHAR(200) NOT NULL,
    "logo_url" TEXT,
    "cover_url" TEXT,
    "established_year" INTEGER,
    "headquarters" VARCHAR(200),
    "description" TEXT,
    "rera_ids" JSONB,
    "total_delivered" INTEGER NOT NULL DEFAULT 0,
    "under_construction" INTEGER NOT NULL DEFAULT 0,
    "delivery_rate_pct" DECIMAL(5,2),
    "trust_score" DECIMAL(3,2),
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "meta_title" VARCHAR(160),
    "meta_desc" VARCHAR(320),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "builders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "projects" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "slug" VARCHAR(200) NOT NULL,
    "builder_id" TEXT NOT NULL,
    "city_id" INTEGER NOT NULL,
    "locality_id" INTEGER,
    "lat" DECIMAL(10,8),
    "lng" DECIMAL(11,8),
    "address" TEXT,
    "rera_number" VARCHAR(100),
    "rera_state" VARCHAR(50),
    "rera_verified" BOOLEAN NOT NULL DEFAULT false,
    "rera_verified_at" TIMESTAMP(3),
    "price_min" BIGINT,
    "price_max" BIGINT,
    "price_per_sqft_min" INTEGER,
    "price_per_sqft_max" INTEGER,
    "area_min_sqft" INTEGER,
    "area_max_sqft" INTEGER,
    "total_units" INTEGER,
    "total_towers" INTEGER,
    "total_floors" INTEGER,
    "launch_date" DATE,
    "possession_date" DATE,
    "construction_pct" INTEGER NOT NULL DEFAULT 0,
    "construction_status" "ConstructionStatus" NOT NULL,
    "project_status" "ProjectStatus" NOT NULL DEFAULT 'active',
    "description" TEXT,
    "highlights" TEXT[],
    "amenities" JSONB,
    "payment_plans" JSONB,
    "meta_title" VARCHAR(160),
    "meta_desc" VARCHAR(320),
    "og_image_url" TEXT,
    "published" BOOLEAN NOT NULL DEFAULT false,
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "new_launch_badge" BOOLEAN NOT NULL DEFAULT false,
    "hot_deal_badge" BOOLEAN NOT NULL DEFAULT false,
    "rera_badge" BOOLEAN NOT NULL DEFAULT false,
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "lead_count" INTEGER NOT NULL DEFAULT 0,
    "shortlist_count" INTEGER NOT NULL DEFAULT 0,
    "created_by" TEXT,
    "published_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "projects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_configs" (
    "id" TEXT NOT NULL,
    "project_id" TEXT NOT NULL,
    "bhk" INTEGER NOT NULL,
    "bedrooms" INTEGER,
    "bathrooms" INTEGER,
    "area_carpet_min" INTEGER,
    "area_carpet_max" INTEGER,
    "area_builtup_min" INTEGER,
    "area_builtup_max" INTEGER,
    "price_min" BIGINT,
    "price_max" BIGINT,
    "floor_plan_url" TEXT,
    "is_available" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "project_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "construction_updates" (
    "id" TEXT NOT NULL,
    "project_id" TEXT NOT NULL,
    "update_date" DATE NOT NULL,
    "title" VARCHAR(200),
    "description" TEXT,
    "completion_pct" INTEGER,
    "created_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "construction_updates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "media" (
    "id" TEXT NOT NULL,
    "project_id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "thumb_url" TEXT,
    "media_type" "MediaType" NOT NULL,
    "caption" VARCHAR(300),
    "room_tag" VARCHAR(50),
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leads" (
    "id" TEXT NOT NULL,
    "project_id" TEXT,
    "builder_id" TEXT,
    "name" VARCHAR(150),
    "phone" VARCHAR(20) NOT NULL,
    "email" VARCHAR(255),
    "message" TEXT,
    "budget_min" BIGINT,
    "budget_max" BIGINT,
    "bhk_interest" INTEGER[],
    "timeline" VARCHAR(50),
    "lead_type" "LeadType" NOT NULL,
    "source" "LeadSource" NOT NULL,
    "utm_source" VARCHAR(100),
    "utm_medium" VARCHAR(100),
    "utm_campaign" VARCHAR(100),
    "utm_content" VARCHAR(100),
    "page_url" TEXT,
    "status" "LeadStatus" NOT NULL DEFAULT 'new',
    "assigned_to" TEXT,
    "notes" TEXT,
    "follow_up_at" TIMESTAMP(3),
    "converted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "leads_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(150),
    "email" VARCHAR(255),
    "phone" VARCHAR(20),
    "role" "UserRole" NOT NULL DEFAULT 'buyer',
    "avatar_url" TEXT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_seen_at" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "saved_projects" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "project_id" TEXT NOT NULL,
    "notes" TEXT,
    "visited" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "saved_projects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "saved_searches" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "name" VARCHAR(200),
    "filters" JSONB NOT NULL,
    "alert_frequency" "AlertFrequency" NOT NULL DEFAULT 'daily',
    "alert_channels" TEXT[],
    "last_notified_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "saved_searches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" TEXT NOT NULL,
    "project_id" TEXT,
    "builder_id" TEXT,
    "user_id" TEXT,
    "rating_overall" DECIMAL(2,1) NOT NULL,
    "rating_location" DECIMAL(2,1),
    "rating_amenities" DECIMAL(2,1),
    "rating_value" DECIMAL(2,1),
    "rating_builder" DECIMAL(2,1),
    "title" VARCHAR(200),
    "body" TEXT,
    "verified_buyer" BOOLEAN NOT NULL DEFAULT false,
    "helpful_count" INTEGER NOT NULL DEFAULT 0,
    "published" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "blog_posts" (
    "id" TEXT NOT NULL,
    "title" VARCHAR(300) NOT NULL,
    "slug" VARCHAR(300) NOT NULL,
    "category" VARCHAR(100),
    "content" JSONB NOT NULL,
    "excerpt" TEXT,
    "thumbnail_url" TEXT,
    "author_id" TEXT,
    "status" "BlogStatus" NOT NULL DEFAULT 'draft',
    "published_at" TIMESTAMP(3),
    "meta_title" VARCHAR(160),
    "meta_desc" VARCHAR(320),
    "og_image_url" TEXT,
    "tags" TEXT[],
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "reading_time" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "blog_posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price_trends" (
    "id" SERIAL NOT NULL,
    "city_id" INTEGER,
    "locality_id" INTEGER,
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "avg_price_sqft" INTEGER,
    "median_price" BIGINT,
    "project_count" INTEGER,
    "yoy_change_pct" DECIMAL(5,2),
    "qoq_change_pct" DECIMAL(5,2),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "price_trends_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chatbot_sessions" (
    "id" TEXT NOT NULL,
    "session_id" VARCHAR(100) NOT NULL,
    "user_id" TEXT,
    "messages" JSONB NOT NULL DEFAULT '[]',
    "intent" VARCHAR(50),
    "collected_data" JSONB NOT NULL DEFAULT '{}',
    "lead_captured" BOOLEAN NOT NULL DEFAULT false,
    "lead_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "chatbot_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "listing_boosts" (
    "id" TEXT NOT NULL,
    "project_id" TEXT,
    "builder_id" TEXT,
    "plan" "BoostPlan" NOT NULL,
    "amount" INTEGER NOT NULL,
    "razorpay_order_id" VARCHAR(100),
    "razorpay_payment_id" VARCHAR(100),
    "status" "BoostStatus" NOT NULL,
    "starts_at" TIMESTAMP(3),
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "listing_boosts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "states_slug_key" ON "states"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "cities_slug_key" ON "cities"("slug");

-- CreateIndex
CREATE INDEX "cities_state_id_idx" ON "cities"("state_id");

-- CreateIndex
CREATE UNIQUE INDEX "localities_city_id_slug_key" ON "localities"("city_id", "slug");

-- CreateIndex
CREATE UNIQUE INDEX "builders_slug_key" ON "builders"("slug");

-- CreateIndex
CREATE INDEX "projects_city_id_idx" ON "projects"("city_id");

-- CreateIndex
CREATE INDEX "projects_locality_id_idx" ON "projects"("locality_id");

-- CreateIndex
CREATE INDEX "projects_construction_status_project_status_idx" ON "projects"("construction_status", "project_status");

-- CreateIndex
CREATE INDEX "projects_price_min_price_max_idx" ON "projects"("price_min", "price_max");

-- CreateIndex
CREATE INDEX "projects_possession_date_idx" ON "projects"("possession_date");

-- CreateIndex
CREATE INDEX "projects_published_featured_idx" ON "projects"("published", "featured");

-- CreateIndex
CREATE UNIQUE INDEX "projects_city_id_slug_key" ON "projects"("city_id", "slug");

-- CreateIndex
CREATE INDEX "project_configs_project_id_idx" ON "project_configs"("project_id");

-- CreateIndex
CREATE INDEX "construction_updates_project_id_idx" ON "construction_updates"("project_id");

-- CreateIndex
CREATE INDEX "media_project_id_idx" ON "media"("project_id");

-- CreateIndex
CREATE INDEX "leads_project_id_idx" ON "leads"("project_id");

-- CreateIndex
CREATE INDEX "leads_status_idx" ON "leads"("status");

-- CreateIndex
CREATE INDEX "leads_created_at_idx" ON "leads"("created_at" DESC);

-- CreateIndex
CREATE INDEX "leads_phone_idx" ON "leads"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "saved_projects_user_id_project_id_key" ON "saved_projects"("user_id", "project_id");

-- CreateIndex
CREATE UNIQUE INDEX "blog_posts_slug_key" ON "blog_posts"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "chatbot_sessions_session_id_key" ON "chatbot_sessions"("session_id");

-- AddForeignKey
ALTER TABLE "cities" ADD CONSTRAINT "cities_state_id_fkey" FOREIGN KEY ("state_id") REFERENCES "states"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "localities" ADD CONSTRAINT "localities_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_builder_id_fkey" FOREIGN KEY ("builder_id") REFERENCES "builders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_locality_id_fkey" FOREIGN KEY ("locality_id") REFERENCES "localities"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "project_configs" ADD CONSTRAINT "project_configs_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "construction_updates" ADD CONSTRAINT "construction_updates_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media" ADD CONSTRAINT "media_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_builder_id_fkey" FOREIGN KEY ("builder_id") REFERENCES "builders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saved_projects" ADD CONSTRAINT "saved_projects_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saved_projects" ADD CONSTRAINT "saved_projects_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saved_searches" ADD CONSTRAINT "saved_searches_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_builder_id_fkey" FOREIGN KEY ("builder_id") REFERENCES "builders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blog_posts" ADD CONSTRAINT "blog_posts_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "price_trends" ADD CONSTRAINT "price_trends_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "price_trends" ADD CONSTRAINT "price_trends_locality_id_fkey" FOREIGN KEY ("locality_id") REFERENCES "localities"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chatbot_sessions" ADD CONSTRAINT "chatbot_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "listing_boosts" ADD CONSTRAINT "listing_boosts_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "listing_boosts" ADD CONSTRAINT "listing_boosts_builder_id_fkey" FOREIGN KEY ("builder_id") REFERENCES "builders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

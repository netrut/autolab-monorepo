-- Extend service_centers with core app fields + category + onboarding_status
ALTER TABLE "service_centers"
  ADD COLUMN IF NOT EXISTS "category"          VARCHAR(100) NOT NULL DEFAULT 'service_center',
  ADD COLUMN IF NOT EXISTS "maps_link"         VARCHAR(500),
  ADD COLUMN IF NOT EXISTS "latitude"          DECIMAL(10,7),
  ADD COLUMN IF NOT EXISTS "longitude"         DECIMAL(10,7),
  ADD COLUMN IF NOT EXISTS "vehicle_types"     TEXT[]       NOT NULL DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS "service_types"     TEXT[]       NOT NULL DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS "brands_serviced"   TEXT[]       NOT NULL DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS "working_hours"     VARCHAR(255),
  ADD COLUMN IF NOT EXISTS "accepts_bookings"  BOOLEAN      NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS "onboarding_status" VARCHAR(50)  NOT NULL DEFAULT 'draft';

CREATE INDEX IF NOT EXISTS "idx_service_centers_category"  ON "service_centers"("category");
CREATE INDEX IF NOT EXISTS "idx_service_centers_status"    ON "service_centers"("onboarding_status");

-- service_center_details: extended / rarely-used fields
CREATE TABLE IF NOT EXISTS "service_center_details" (
  "id"                      TEXT         NOT NULL DEFAULT gen_random_uuid(),
  "service_center_id"       TEXT         NOT NULL,
  -- Business identity
  "trade_name"              VARCHAR(255),
  "business_type"           VARCHAR(50),
  "year_established"        INT,
  "website"                 VARCHAR(500),
  "logo_url"                VARCHAR(500),
  "whatsapp_number"         VARCHAR(20),
  -- Legal IDs
  "gst_number"              VARCHAR(20),
  "pan_number"              VARCHAR(15),
  "shop_reg_number"         VARCHAR(100),
  "trade_license"           VARCHAR(100),
  "msme_number"             VARCHAR(100),
  -- Owner / contact person
  "owner_name"              VARCHAR(255),
  "owner_phone"             VARCHAR(20),
  "owner_email"             VARCHAR(255),
  "designation"             VARCHAR(100),
  "aadhaar_last4"           VARCHAR(4),
  -- Bank details
  "account_holder"          VARCHAR(255),
  "bank_name"               VARCHAR(255),
  "account_number_encrypted" VARCHAR(500),
  "ifsc_code"               VARCHAR(20),
  "upi_id"                  VARCHAR(100),
  -- Documents (JSONB array of {type, url, verified})
  "documents"               JSONB        NOT NULL DEFAULT '[]',
  -- Admin
  "rejection_reason"        TEXT,
  "verified_at"             TIMESTAMP(6),
  "submitted_at"            TIMESTAMP(6),
  "created_at"              TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  "updated_at"              TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "service_center_details_pkey"    PRIMARY KEY ("id"),
  CONSTRAINT "service_center_details_sc_fkey" FOREIGN KEY ("service_center_id")
    REFERENCES "service_centers"("id") ON DELETE CASCADE,
  CONSTRAINT "service_center_details_unique"  UNIQUE ("service_center_id")
);

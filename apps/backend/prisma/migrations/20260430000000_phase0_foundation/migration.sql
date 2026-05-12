-- Phase 0: Foundation migrations

-- 0.1 Add chassis_number to vehicles
ALTER TABLE "vehicles" ADD COLUMN IF NOT EXISTS "chassis_number" VARCHAR(100);

-- 0.2 Create service_center_user_map
CREATE TABLE IF NOT EXISTS "service_center_user_map" (
    "id"                TEXT NOT NULL DEFAULT gen_random_uuid(),
    "service_center_id" TEXT NOT NULL,
    "user_id"           TEXT NOT NULL,
    "role"              VARCHAR(50) NOT NULL DEFAULT 'user',
    "created_at"        TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "service_center_user_map_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "service_center_user_map_sc_fkey"   FOREIGN KEY ("service_center_id") REFERENCES "service_centers"("id") ON DELETE CASCADE,
    CONSTRAINT "service_center_user_map_user_fkey" FOREIGN KEY ("user_id")           REFERENCES "users"("id")           ON DELETE CASCADE,
    CONSTRAINT "service_center_user_map_unique"    UNIQUE ("service_center_id", "user_id")
);
CREATE INDEX IF NOT EXISTS "idx_sc_user_map_user_id" ON "service_center_user_map"("user_id");

-- 0.3 Create vehicle_user_map
CREATE TABLE IF NOT EXISTS "vehicle_user_map" (
    "id"         TEXT NOT NULL DEFAULT gen_random_uuid(),
    "vehicle_id" TEXT NOT NULL,
    "user_id"    TEXT NOT NULL,
    "role"       VARCHAR(50) NOT NULL DEFAULT 'user',
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "vehicle_user_map_pkey"        PRIMARY KEY ("id"),
    CONSTRAINT "vehicle_user_map_vehicle_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "vehicles"("id") ON DELETE CASCADE,
    CONSTRAINT "vehicle_user_map_user_fkey"    FOREIGN KEY ("user_id")    REFERENCES "users"("id")    ON DELETE CASCADE,
    CONSTRAINT "vehicle_user_map_unique"       UNIQUE ("vehicle_id", "user_id")
);
CREATE INDEX IF NOT EXISTS "idx_vehicle_user_map_user_id" ON "vehicle_user_map"("user_id");

-- 0.4 Create options table
CREATE TABLE IF NOT EXISTS "options" (
    "key"        VARCHAR(100) NOT NULL,
    "value"      TEXT         NOT NULL DEFAULT '',
    "label"      VARCHAR(255) NOT NULL DEFAULT '',
    "group"      VARCHAR(100) NOT NULL DEFAULT 'general',
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "options_pkey" PRIMARY KEY ("key")
);

-- Seed initial options
INSERT INTO "options" ("key", "value", "label", "group") VALUES
    ('helpline_number',       '919664027924',  'Helpline Phone Number',          'contact'),
    ('helpline_whatsapp',     'https://wa.me/919664027924', 'Helpline WhatsApp Link', 'contact'),
    ('app_version',           '1.0.0',         'Minimum App Version',            'app'),
    ('booking_advance_days',  '90',            'Booking Advance Days',           'booking'),
    ('service_due_alert_days','7',             'Service Due Alert Days',         'service'),
    ('invoice_footer_text',   'Thank you for choosing AutoLab!', 'Invoice Footer Text', 'invoice'),
    ('service_centre_name',   'AutoLab Service Centre', 'Default Service Centre Name', 'service')
ON CONFLICT ("key") DO NOTHING;

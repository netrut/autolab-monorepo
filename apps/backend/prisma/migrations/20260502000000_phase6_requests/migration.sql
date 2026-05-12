-- Phase 6: Requests / Invite System

CREATE TABLE IF NOT EXISTS "requests" (
    "id"          TEXT         NOT NULL DEFAULT gen_random_uuid(),
    "type"        VARCHAR(50)  NOT NULL, -- vehicle_access | service_center_join | customer_invite | partner_invite
    "from_user_id" TEXT        NOT NULL,
    "to_user_id"  TEXT,                  -- nullable for broadcast invites
    "entity_type" VARCHAR(50)  NOT NULL, -- vehicle | service_center
    "entity_id"   TEXT         NOT NULL,
    "role"        VARCHAR(50)  NOT NULL DEFAULT 'user',
    "status"      VARCHAR(50)  NOT NULL DEFAULT 'pending', -- pending | accepted | rejected | cancelled
    "message"     TEXT,
    "created_at"  TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "requests_pkey"           PRIMARY KEY ("id"),
    CONSTRAINT "requests_from_user_fkey" FOREIGN KEY ("from_user_id") REFERENCES "users"("id") ON DELETE CASCADE,
    CONSTRAINT "requests_to_user_fkey"   FOREIGN KEY ("to_user_id")   REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "idx_requests_from_user" ON "requests"("from_user_id");
CREATE INDEX IF NOT EXISTS "idx_requests_to_user"   ON "requests"("to_user_id");
CREATE INDEX IF NOT EXISTS "idx_requests_status"    ON "requests"("status");
CREATE INDEX IF NOT EXISTS "idx_requests_entity"    ON "requests"("entity_type", "entity_id");

-- Phase 7: Notifications table

CREATE TABLE IF NOT EXISTS "notifications" (
    "id"          TEXT         NOT NULL DEFAULT gen_random_uuid(),
    "user_id"     TEXT         NOT NULL,
    "type"        VARCHAR(50)  NOT NULL, -- request | service_due | booking_update | service_complete | invoice | system
    "title"       VARCHAR(255) NOT NULL,
    "body"        TEXT         NOT NULL,
    "request_id"  TEXT,                  -- FK → requests (nullable)
    "entity_type" VARCHAR(50),           -- vehicle | booking | service_record | invoice
    "entity_id"   TEXT,                  -- for deep-link
    "is_read"     BOOLEAN      NOT NULL DEFAULT false,
    "channel"     VARCHAR(20)  NOT NULL DEFAULT 'app', -- app | whatsapp | both
    "sent_at"     TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "read_at"     TIMESTAMP(6),
    CONSTRAINT "notifications_pkey"        PRIMARY KEY ("id"),
    CONSTRAINT "notifications_user_fkey"   FOREIGN KEY ("user_id")    REFERENCES "users"("id")    ON DELETE CASCADE,
    CONSTRAINT "notifications_request_fkey" FOREIGN KEY ("request_id") REFERENCES "requests"("id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "idx_notifications_user_id"  ON "notifications"("user_id");
CREATE INDEX IF NOT EXISTS "idx_notifications_is_read"  ON "notifications"("user_id", "is_read");
CREATE INDEX IF NOT EXISTS "idx_notifications_sent_at"  ON "notifications"("sent_at" DESC);

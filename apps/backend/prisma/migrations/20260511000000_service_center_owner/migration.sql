-- Add owner_user_id to service_centers
ALTER TABLE "service_centers"
  ADD COLUMN IF NOT EXISTS "owner_user_id" TEXT REFERENCES "users"("id") ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS "idx_service_centers_owner" ON "service_centers"("owner_user_id");

-- Phase 5: Invoice table

CREATE TABLE IF NOT EXISTS "invoices" (
    "id"                TEXT         NOT NULL DEFAULT gen_random_uuid(),
    "service_id"        TEXT         NOT NULL,
    "vehicle_id"        TEXT         NOT NULL,
    "user_id"           TEXT         NOT NULL,
    "service_center_id" TEXT,
    "invoice_number"    VARCHAR(50)  NOT NULL,
    "service_date"      TIMESTAMP(6) NOT NULL,
    "total_cost"        DECIMAL(10,2) NOT NULL DEFAULT 0,
    "labour_cost"       DECIMAL(10,2) NOT NULL DEFAULT 0,
    "items_cost"        DECIMAL(10,2) NOT NULL DEFAULT 0,
    "footer_text"       TEXT,
    "notes"             TEXT,
    "created_at"        TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "invoices_pkey"           PRIMARY KEY ("id"),
    CONSTRAINT "invoices_service_fkey"   FOREIGN KEY ("service_id")  REFERENCES "vehicle_services"("id") ON DELETE CASCADE,
    CONSTRAINT "invoices_vehicle_fkey"   FOREIGN KEY ("vehicle_id")  REFERENCES "vehicles"("id")         ON DELETE CASCADE,
    CONSTRAINT "invoices_user_fkey"      FOREIGN KEY ("user_id")     REFERENCES "users"("id")            ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "invoices_service_id_key" ON "invoices"("service_id");
CREATE INDEX IF NOT EXISTS "idx_invoices_user_id"    ON "invoices"("user_id");
CREATE INDEX IF NOT EXISTS "idx_invoices_vehicle_id" ON "invoices"("vehicle_id");

-- Auto-generate invoice number sequence
CREATE SEQUENCE IF NOT EXISTS invoice_number_seq START 1000;

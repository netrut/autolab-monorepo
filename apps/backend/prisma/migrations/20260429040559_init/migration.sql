-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone_number" VARCHAR(20),
    "display_name" VARCHAR(255),
    "password_hash" VARCHAR(255),
    "role_id" INTEGER DEFAULT 2,
    "avatar_url" VARCHAR(255),
    "bio" TEXT,
    "address" TEXT,
    "is_active" BOOLEAN DEFAULT true,
    "firebase_uid" VARCHAR(255),
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicles" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "vehicle_type" VARCHAR(50) NOT NULL,
    "brand" VARCHAR(100) NOT NULL,
    "model" VARCHAR(100) NOT NULL,
    "year" INTEGER,
    "registration_number" VARCHAR(50),
    "vehicle_color" VARCHAR(50),
    "fuel_type" VARCHAR(50),
    "transmission" VARCHAR(50),
    "mileage_km" DECIMAL(10,2),
    "notes" TEXT,
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_centers" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "phone" VARCHAR(20) NOT NULL,
    "email" VARCHAR(255),
    "address" TEXT,
    "city" VARCHAR(100),
    "state" VARCHAR(100),
    "pincode" VARCHAR(10),
    "rating" DECIMAL(3,2) DEFAULT 0,
    "is_verified" BOOLEAN DEFAULT false,
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "service_centers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bookings" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "vehicle_id" TEXT NOT NULL,
    "service_center_id" TEXT NOT NULL,
    "service_type" VARCHAR(100) NOT NULL,
    "booking_date" TIMESTAMP(6) NOT NULL,
    "status" VARCHAR(50) DEFAULT 'pending',
    "notes" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bookings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bike_services" (
    "id" TEXT NOT NULL,
    "vehicle_id" TEXT NOT NULL,
    "service_center_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "service_type" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(50) DEFAULT 'pending',
    "scheduled_date" TIMESTAMP(6),
    "completed_date" TIMESTAMP(6),
    "estimated_cost" DECIMAL(10,2),
    "actual_cost" DECIMAL(10,2),
    "notes" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bike_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "car_services" (
    "id" TEXT NOT NULL,
    "vehicle_id" TEXT NOT NULL,
    "service_center_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "service_type" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(50) DEFAULT 'pending',
    "scheduled_date" TIMESTAMP(6),
    "completed_date" TIMESTAMP(6),
    "estimated_cost" DECIMAL(10,2),
    "actual_cost" DECIMAL(10,2),
    "notes" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "car_services_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_number_key" ON "users"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "users_firebase_uid_key" ON "users"("firebase_uid");

-- CreateIndex
CREATE INDEX "idx_users_email" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "vehicles_registration_number_key" ON "vehicles"("registration_number");

-- CreateIndex
CREATE INDEX "idx_vehicles_user_id" ON "vehicles"("user_id");

-- CreateIndex
CREATE INDEX "idx_bookings_status" ON "bookings"("status");

-- CreateIndex
CREATE INDEX "idx_bookings_user_id" ON "bookings"("user_id");

-- CreateIndex
CREATE INDEX "idx_bike_services_vehicle_id" ON "bike_services"("vehicle_id");

-- CreateIndex
CREATE INDEX "idx_car_services_status" ON "car_services"("status");

-- CreateIndex
CREATE INDEX "idx_car_services_vehicle_id" ON "car_services"("vehicle_id");

-- AddForeignKey
ALTER TABLE "vehicles" ADD CONSTRAINT "vehicles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_service_center_id_fkey" FOREIGN KEY ("service_center_id") REFERENCES "service_centers"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "vehicles"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bike_services" ADD CONSTRAINT "bike_services_service_center_id_fkey" FOREIGN KEY ("service_center_id") REFERENCES "service_centers"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bike_services" ADD CONSTRAINT "bike_services_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bike_services" ADD CONSTRAINT "bike_services_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "vehicles"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "car_services" ADD CONSTRAINT "car_services_service_center_id_fkey" FOREIGN KEY ("service_center_id") REFERENCES "service_centers"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "car_services" ADD CONSTRAINT "car_services_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "car_services" ADD CONSTRAINT "car_services_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "vehicles"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

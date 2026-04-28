# 🗄️ SUPABASE DATABASE SETUP - Click-by-Click Guide

**Purpose:** Create PostgreSQL database on Supabase  
**Time:** 45-60 minutes  
**Prerequisites:** GitHub repository set up  
**Next:** 11_CREDENTIALS_VAULT.md (save passwords)

---

## 📋 OVERVIEW

You'll create:
- ✅ Supabase account
- ✅ PostgreSQL database with strong password
- ✅ 6 database tables (users, vehicles, services, bookings)
- ✅ Test data for development
- ✅ Connection string for backend

---

## 🔐 PASSWORD TO USE

**Recommended Database Password:**
```
AutoLabDB@2024!Secure
```

**Where you'll use it:**
- Step 3: Creating database in Supabase
- Step 9: In backend `.env` file
- Step 11: Save in credentials vault

---

## ✅ STEP 1: CREATE SUPABASE ACCOUNT

### Step 1A: Go to Supabase Website

1. **Open browser**
2. **Go to:** https://supabase.com
3. **You'll see:** Supabase homepage

---

### Step 1B: Click "Sign Up"

1. **Look for:** "Sign Up" or "Start your project" button
2. **Click it**

---

### Step 1C: Sign Up with Email

On signup form:

```
Email:              autolabstation@gmail.com
Password:           [Create strong password]
Confirm Password:   [Type same password]
```

**Password requirements:**
- At least 8 characters
- Mix of letters, numbers, symbols

**Recommended:** Use a unique password (not the database password!)

1. **Click:** "Sign up"

---

### Step 1D: Verify Email

1. **Check email:** autolabstation@gmail.com (inbox)
2. **Find:** Email from Supabase
3. **Click:** "Confirm your email" link
4. **You'll be redirected** to Supabase dashboard

---

## 🗄️ STEP 2: CREATE DATABASE PROJECT

### Step 2A: You're Now in Supabase

After email confirmation, you should see:
- Welcome message
- "Create a new project" button
- Supabase dashboard

---

### Step 2B: Click "Create a New Project"

1. **Look for:** "New project" button or "Create project"
2. **Click it**

---

### Step 2C: Fill Project Details

**Form to fill:**

```
Project Name:           autolab-db
Database Password:      AutoLabDB@2024!Secure
Region:                 Asia - Singapore (or India - Mumbai)
Pricing Plan:           Free (starter)
```

**Step by step:**

1. **Project Name field:**
   - Clear any existing text
   - Type: `autolab-db`

2. **Database Password field:**
   - Click on password field
   - Type: `AutoLabDB@2024!Secure`
   - ✅ Make sure caps are correct: `Auto`, `Lab`, `DB`, `S`, `ecure`

3. **Region dropdown:**
   - Click dropdown
   - Select: "Asia - Singapore" (closest to India)
   - OR select: "India - Mumbai" if available

4. **Pricing Plan:**
   - Select: "Free" (starter plan)
   - This is fine for development

---

### Step 2D: Create Project

1. **Click:** "Create new project" button
2. **Wait:** Supabase creates database (2-5 minutes)
3. **You'll see:** Loading screen with message "Setting up your database..."
4. **Don't close** the browser tab

---

### Step 2E: Project Created!

After creation, you'll see:
- Project dashboard
- Left sidebar with menu options
- Your project name: `autolab-db`

---

## 🔐 STEP 3: GET DATABASE CONNECTION STRING

### Step 3A: Open Settings

1. **In left sidebar,** find and click: **"Settings"**

---

### Step 3B: Find Database Section

1. **Scroll down** in Settings page
2. **Look for:** "Database" section
3. **Click on** "Database" section

---

### Step 3C: Get Connection String

1. **Find:** "Connection string" or "Database URL"
2. **Look for tabs:** "URI", "JDBC", "Pooling"
3. **Click:** "URI" tab

---

### Step 3D: Copy Connection String

1. **You'll see:** A long connection string starting with `postgresql://`
2. **It looks like:**
   ```
   postgresql://postgres:PASSWORD@db.PROJECTID.supabase.co:5432/postgres
   ```

3. **Click:** Copy button (icon to the right)
4. **Or manually select and copy** the entire string

---

### Step 3E: Save Connection String

**Save this somewhere safe!** You'll need it in Step 9.

**Format:**
```
postgresql://postgres:AutoLabDB@2024!Secure@db.abcdefgh123456.supabase.co:5432/postgres
```

**Note:** 
- `AutoLabDB@2024!Secure` = Your database password
- `abcdefgh123456` = Your Project ID (unique to your project)

---

## 🧩 STEP 4: ENABLE POSTGRESQL EXTENSIONS

PostgreSQL needs extensions for UUID generation.

### Step 4A: Go to SQL Editor

1. **In left sidebar,** click: **"SQL Editor"**
2. **You'll see:** Text editor for SQL queries

---

### Step 4B: Create New Query

1. **Click:** "New query" button (usually top right)
2. **Or click:** "+" button

---

### Step 4C: Paste SQL Command

Copy and paste this into the editor:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
```

---

### Step 4D: Run Query

1. **Look for:** "Run" button (blue play icon)
2. **Or press:** Ctrl+Enter (or Cmd+Enter on Mac)
3. **You should see:** "Success" message

---

### Step 4E: Verify Extensions

Let's verify they're installed.

1. **Click:** "New query" again
2. **Paste this:**

```sql
SELECT extname, extversion FROM pg_extension 
WHERE extname IN ('uuid-ossp', 'pgcrypto');
```

3. **Click:** "Run"
4. **You should see:**
   ```
   extname    extversion
   ──────────────────────
   uuid-ossp  1.1
   pgcrypto   1.3
   ```

✅ **Extensions installed!**

---

## 📋 STEP 5: CREATE DATABASE TABLES

### Step 5A: Create New Query for Tables

1. **Click:** "New query"
2. **Paste this complete SQL** (creates all 6 tables):

```sql
-- Users Table
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone_number VARCHAR(20) UNIQUE,
  display_name VARCHAR(255),
  password_hash VARCHAR(255),
  role_id INTEGER DEFAULT 2,
  avatar_url VARCHAR(255),
  bio TEXT,
  address TEXT,
  is_active BOOLEAN DEFAULT true,
  firebase_uid VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicles Table
CREATE TABLE IF NOT EXISTS vehicles (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vehicle_type VARCHAR(50) NOT NULL,
  brand VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  year INTEGER,
  registration_number VARCHAR(50) UNIQUE,
  vehicle_color VARCHAR(50),
  fuel_type VARCHAR(50),
  transmission VARCHAR(50),
  mileage_km DECIMAL(10, 2),
  notes TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service Centers Table
CREATE TABLE IF NOT EXISTS service_centers (
  id TEXT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(255),
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  pincode VARCHAR(10),
  rating DECIMAL(3, 2) DEFAULT 0,
  is_verified BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Car Services Table
CREATE TABLE IF NOT EXISTS car_services (
  id TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  service_center_id TEXT NOT NULL REFERENCES service_centers(id),
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  service_type VARCHAR(100) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  scheduled_date TIMESTAMP,
  completed_date TIMESTAMP,
  estimated_cost DECIMAL(10, 2),
  actual_cost DECIMAL(10, 2),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bike Services Table
CREATE TABLE IF NOT EXISTS bike_services (
  id TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  service_center_id TEXT NOT NULL REFERENCES service_centers(id),
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  service_type VARCHAR(100) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  scheduled_date TIMESTAMP,
  completed_date TIMESTAMP,
  estimated_cost DECIMAL(10, 2),
  actual_cost DECIMAL(10, 2),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
  service_center_id TEXT NOT NULL REFERENCES service_centers(id),
  service_type VARCHAR(100) NOT NULL,
  booking_date TIMESTAMP NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_vehicles_user_id ON vehicles(user_id);
CREATE INDEX idx_car_services_vehicle_id ON car_services(vehicle_id);
CREATE INDEX idx_car_services_status ON car_services(status);
CREATE INDEX idx_bike_services_vehicle_id ON bike_services(vehicle_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_status ON bookings(status);
```

---

### Step 5B: Run Table Creation

1. **Click:** "Run" button
2. **Wait:** A few seconds
3. **You should see:** "Success" message

✅ **All 6 tables created!**

---

## 📝 STEP 6: ADD TEST DATA

### Step 6A: Add Test Users

```sql
INSERT INTO users (id, email, phone_number, display_name, role_id, is_active) VALUES
('admin-1', 'admin@autolab.com', '9999999999', 'Admin User', 1, true),
('user-1', 'customer@autolab.com', '9828096110', 'Test Customer', 2, true);
```

1. **Click:** "New query"
2. **Paste** above SQL
3. **Click:** "Run"

---

### Step 6B: Add Test Vehicle

```sql
INSERT INTO vehicles (id, user_id, vehicle_type, brand, model, year, registration_number, vehicle_color, fuel_type, transmission) VALUES
('vehicle-1', 'user-1', 'car', 'Toyota', 'Fortuner', 2022, 'DL01AB1234', 'Silver', 'diesel', 'automatic');
```

1. **Click:** "New query"
2. **Paste** above SQL
3. **Click:** "Run"

---

### Step 6C: Add Test Service Center

```sql
INSERT INTO service_centers (id, name, phone, email, address, city, state, pincode, is_verified, is_active) VALUES
('service-1', 'AutoCare Service Center', '1234567890', 'contact@autocare.com', '123 Main St', 'Delhi', 'Delhi', '110001', true, true);
```

1. **Click:** "New query"
2. **Paste** above SQL
3. **Click:** "Run"

---

### Step 6D: Add Test Service

```sql
INSERT INTO car_services (id, vehicle_id, service_center_id, user_id, service_type, status, estimated_cost) VALUES
('service-r-1', 'vehicle-1', 'service-1', 'user-1', 'oil_change', 'pending', 500);
```

1. **Click:** "New query"
2. **Paste** above SQL
3. **Click:** "Run"

---

### Step 6E: Add Test Booking

```sql
INSERT INTO bookings (id, user_id, vehicle_id, service_center_id, service_type, booking_date, status) VALUES
('booking-1', 'user-1', 'vehicle-1', 'service-1', 'oil_change', NOW(), 'pending');
```

1. **Click:** "New query"
2. **Paste** above SQL
3. **Click:** "Run"

---

## ✅ STEP 7: VERIFY DATA IN SUPABASE

### Step 7A: Open Table Editor

1. **In left sidebar,** click: **"Table Editor"** (or "Tables")

---

### Step 7B: View Users Table

1. **In Table Editor,** click: **"users"** table
2. **You should see:**
   - Row 1: admin@autolab.com (role_id: 1)
   - Row 2: customer@autolab.com (role_id: 2)

---

### Step 7C: View Vehicles Table

1. **Click:** **"vehicles"** table
2. **You should see:**
   - Toyota Fortuner (belongs to customer@autolab.com)

---

### Step 7D: View Service Centers Table

1. **Click:** **"service_centers"** table
2. **You should see:**
   - AutoCare Service Center

---

### Step 7E: View Other Tables

1. **Click:** **"car_services"** - should have 1 record
2. **Click:** **"bookings"** - should have 1 record
3. **Click:** **"bike_services"** - should be empty (for now)

✅ **Test data successfully added!**

---

## 🔐 STEP 8: SAVE CREDENTIALS

**Save these details securely** (you'll need them for backend setup):

```
Database Name:         autolab-db
Database Password:     AutoLabDB@2024!Secure
Connection String:     postgresql://postgres:AutoLabDB@2024!Secure@db.PROJECT_ID.supabase.co:5432/postgres
Region:                Asia - Singapore (or India - Mumbai)
Tables Created:        6 (users, vehicles, service_centers, car_services, bike_services, bookings)
Test Data Added:       ✅ Yes
```

**Save in:** `SETUP_GUIDES/11_CREDENTIALS_VAULT.md` (next step)

---

## ✅ VERIFICATION CHECKLIST

- [ ] Supabase account created with autolabstation@gmail.com
- [ ] Database project "autolab-db" created
- [ ] Database password: AutoLabDB@2024!Secure
- [ ] Connection string obtained
- [ ] PostgreSQL extensions enabled (uuid-ossp, pgcrypto)
- [ ] 6 tables created:
  - [ ] users
  - [ ] vehicles
  - [ ] service_centers
  - [ ] car_services
  - [ ] bike_services
  - [ ] bookings
- [ ] Test data added:
  - [ ] 2 users (admin & customer)
  - [ ] 1 vehicle
  - [ ] 1 service center
  - [ ] 1 car service
  - [ ] 1 booking
- [ ] All data visible in Table Editor
- [ ] Credentials saved securely

---

## 🚀 NEXT STEPS

✅ Database is ready!

→ **Next:** `11_CREDENTIALS_VAULT.md` (Save all passwords)

Then continue with:
→ `04_EXPRESS_BACKEND.md` (Create backend API)

---

## 📞 TROUBLESHOOTING

### "Error: Database already exists"
- Use different database name
- Or delete existing database and try again

### "Connection refused"
- Wait a few minutes for database to fully initialize
- Try again after 5 minutes

### "Permission denied"
- Check your password is correct
- Verify email is confirmed

### "Extensions not found"
- Wait a minute and try again
- Verify extension creation was successful

---

**Last Updated:** April 27, 2026  
**Time:** 45-60 minutes  
**Next file:** 11_CREDENTIALS_VAULT.md (Save passwords)

→ Continue to save all your credentials securely

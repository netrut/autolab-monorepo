# AutoLab Linked Pages - Service Forms & History

## 1. SERVICE FORM PAGES OVERVIEW

Both service form pages follow the same pattern:
- Receive vehicle number as parameter
- Display form with service checklist items
- Allow user to update service status for each component
- Save records to database
- Return to search page

---

## 2. BIKE SERVICE FORM (ServiceForm1Widget)

### 2.1 Page Information

**File Location:** `/lib/service_form1/service_form1_widget.dart`  
**Route Name:** `serviceForm1`  
**Route Path:** `/serviceForm1`  
**Input Parameter:** `vehicleNo` (String - vehicle registration number)

### 2.2 Purpose

- Record service details for motorcycles/bikes
- Capture status of bike-specific components
- Store service history linked to vehicle number
- Update service date to current timestamp

### 2.3 Page Layout

```
┌──────────────────────────────────┐
│ ← [Service Header]               │
│ BIKE SERVICE FORM                │
├──────────────────────────────────┤
│                                  │
│ Vehicle Number: MH02EQ9876       │
│                                  │
├──────────────────────────────────┤
│ Service Components (Checklist):  │
│                                  │
│ ☐ Engine Oil        [Dropdown]   │
│ ☐ Air Filter        [Dropdown]   │
│ ☐ Oil Filter        [Dropdown]   │
│ ☐ Spark Plug        [Dropdown]   │
│ ☐ Self Start        [Dropdown]   │
│ ☐ Bike Wash         [Dropdown]   │
│ ☐ Brake Pads        [Dropdown]   │
│ ☐ Brake Disc        [Dropdown]   │
│ ☐ Lights & Signal   [Dropdown]   │
│ ☐ Clutch Wire       [Dropdown]   │
│ ☐ Battery           [Dropdown]   │
│ ☐ Drive Chain       [Dropdown]   │
│ ☐ Horn              [Dropdown]   │
│                                  │
│ [Save Service]  [Clear Form]    │
│                                  │
└──────────────────────────────────┘
```

### 2.4 Service Components (Bike)

| Field Name | Database Column | Type | Possible Values |
|------------|-----------------|------|-----------------|
| Engine Oil | engine_oil | String | "Good", "Needs Change", "Changed", etc. |
| Air Filter | air_filter | String | "Good", "Needs Change", "Changed", etc. |
| Oil Filter | oil_filter | String | "Good", "Needs Change", "Changed", etc. |
| Spark Plug | spark_plug | String | "Good", "Needs Change", "Changed", etc. |
| Self Start | self_start | String | "Working", "Not Working", "Repaired", etc. |
| Bike Wash | bike_wash | String | "Done", "Not Done", "Pending", etc. |
| Brake Pads | brake_pads | String | "Good", "Needs Change", "Changed", etc. |
| Brake Disc | break_disc | String | "Good", "Needs Change", "Changed", etc. |
| Lights & Signal | lights_signal | String | "Good", "Needs Repair", "Repaired", etc. |
| Clutch Wire | clutch_wire | String | "Good", "Needs Adjustment", "Adjusted", etc. |
| Battery | battery | String | "Good", "Needs Change", "Changed", etc. |
| Drive Chain | drive_chain | String | "Good", "Needs Lubrication", "Lubricated", etc. |
| Horn | horn | String | "Working", "Not Working", "Repaired", etc. |

### 2.5 Form Submission Logic

**On Click "Save Service":**

1. Collect all field values
2. Create BikeServiceRecord with:
   - All component values
   - Current date timestamp (automatically set)
   - Vehicle number (from parameter)
3. Save to `bike_services` collection/table
4. Show success message
5. Pop navigation (return to search page)

**SQL for PostgreSQL:**
```sql
INSERT INTO bike_services (
    engine_oil, air_filter, oil_filter, spark_plug, self_start,
    bike_wash, brake_pads, break_disc, lights_signal, clutch_wire,
    battery, drive_chain, horn, date, vechile_no
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, NOW(), $14
) RETURNING id;
```

### 2.6 Validation

- Vehicle number must be provided
- Date is auto-set (not editable)
- At least one component should be filled (ideally)
- All values are optional (can be null)

---

## 3. CAR SERVICE FORM (ServiceForm2Widget)

### 3.1 Page Information

**File Location:** `/lib/service_form2/service_form2_widget.dart`  
**Route Name:** `serviceForm2`  
**Route Path:** `/serviceForm2`  
**Input Parameter:** `vehicleNo` (String - vehicle registration number)

### 3.2 Purpose

- Record service details for cars (four-wheelers)
- Capture status of car-specific components
- Store service history linked to vehicle number
- Update service date to current timestamp

### 3.3 Page Layout

```
┌──────────────────────────────────┐
│ ← [Service Header]               │
│ CAR SERVICE FORM                 │
├──────────────────────────────────┤
│                                  │
│ Vehicle Number: MH02AB1234       │
│                                  │
├──────────────────────────────────┤
│ Service Components (Checklist):  │
│                                  │
│ ☐ Engine Oil        [Dropdown]   │
│ ☐ Coolant           [Dropdown]   │
│ ☐ Air Filter        [Dropdown]   │
│ ☐ Oil Filter        [Dropdown]   │
│ ☐ AC Filter         [Dropdown]   │
│ ☐ Car Wash          [Dropdown]   │
│ ☐ Brake Pads        [Dropdown]   │
│ ☐ Brake Disc        [Dropdown]   │
│ ☐ Lights & Signal   [Dropdown]   │
│ ☐ Brake Fluid       [Dropdown]   │
│ ☐ Gear Fluid        [Dropdown]   │
│ ☐ Wiper Blades      [Dropdown]   │
│ ☐ Battery           [Dropdown]   │
│                                  │
│ [Save Service]  [Clear Form]    │
│                                  │
└──────────────────────────────────┘
```

### 3.4 Service Components (Car)

| Field Name | Database Column | Type | Possible Values |
|------------|-----------------|------|-----------------|
| Engine Oil | engine_oil | String | "Good", "Needs Change", "Changed", etc. |
| Coolant | coolant | String | "Good", "Needs Refill", "Refilled", etc. |
| Air Filter | airfilter | String | "Good", "Needs Change", "Changed", etc. |
| Oil Filter | oil_filter | String | "Good", "Needs Change", "Changed", etc. |
| AC Filter | ac_filter | String | "Good", "Needs Change", "Changed", etc. |
| Car Wash | car_wash | String | "Done", "Not Done", "Pending", etc. |
| Brake Pads | break_pads | String | "Good", "Needs Change", "Changed", etc. |
| Brake Disc | break_disc | String | "Good", "Needs Change", "Changed", etc. |
| Lights & Signal | lights_signal | String | "Good", "Needs Repair", "Repaired", etc. |
| Brake Fluid | break_fluid | String | "Good", "Needs Refill", "Refilled", etc. |
| Gear Fluid | gear_fluid | String | "Good", "Needs Change", "Changed", etc. |
| Wiper Blades | wiper_blades | String | "Good", "Needs Change", "Changed", etc. |
| Battery | battery | String | "Good", "Needs Change", "Changed", etc. |

### 3.5 Form Submission Logic

**On Click "Save Service":**

1. Collect all field values
2. Create CarServiceRecord with:
   - All component values
   - Current date timestamp (automatically set)
   - Vehicle number (from parameter)
3. Save to `car_services` collection/table
4. Show success message
5. Pop navigation (return to search page)

**SQL for PostgreSQL:**
```sql
INSERT INTO car_services (
    engine_oil, coolant, airfilter, oil_filter, ac_filter, car_wash,
    break_pads, break_disc, lights_signal, break_fluid, gear_fluid,
    wiper_blades, battery, date, vechile_no
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, NOW(), $14
) RETURNING id;
```

---

## 4. BIKE SERVICE HISTORY PAGE (HistoryBikeWidget)

### 4.1 Page Information

**File Location:** `/lib/history_bike/history_bike_widget.dart`  
**Route Name:** `historyBike`  
**Route Path:** `/historyBike`  
**Input Parameters:**
- `vehicleNo` (String - vehicle registration number)
- `carBike` (String - "Bike")

### 4.2 Purpose

- Display complete service history for a specific bike
- Show all past service records in chronological order (latest first)
- Allow user to review service details
- Show service dates and component statuses

### 4.3 Page Layout

```
┌────────────────────────────────────────┐
│ ← SERVICE HISTORY                      │
├────────────────────────────────────────┤
│                                        │
│ Vehicle: MH02EQ9876 (Bike)             │
│ Model: Honda CB Shine                  │
│ Mobile: 9876543210                     │
│                                        │
├────────────────────────────────────────┤
│                                        │
│ Service Record 1 (Latest)              │
│ Date: 2024-05-04 10:30 AM              │
│ ├─ Engine Oil: Changed                 │
│ ├─ Air Filter: Good                    │
│ ├─ Oil Filter: Good                    │
│ ├─ Spark Plug: Changed                 │
│ ├─ Self Start: Working                 │
│ ├─ Bike Wash: Done                     │
│ ├─ Brake Pads: Good                    │
│ ├─ Brake Disc: Good                    │
│ ├─ Lights & Signal: Good               │
│ ├─ Clutch Wire: Good                   │
│ ├─ Battery: Good                       │
│ ├─ Drive Chain: Lubricated             │
│ └─ Horn: Working                       │
│                                        │
│ ────────────────────────────────────   │
│                                        │
│ Service Record 2 (Earlier)             │
│ Date: 2024-04-01 02:15 PM              │
│ ├─ Engine Oil: Good                    │
│ ├─ Air Filter: Good                    │
│ ... (all components)                   │
│                                        │
│ ────────────────────────────────────   │
│                                        │
│ [Scroll for more records]              │
│                                        │
└────────────────────────────────────────┘
```

### 4.4 Data Display Structure

```
Header Section:
├─ Vehicle Registration: vehicleNo
├─ Vehicle Type: "Bike"
├─ Model from VechileDetailsRecord: model
├─ Mobile from VechileDetailsRecord: mobile

History List (StreamBuilder or Future):
├─ Query: BikeServiceRecord where vehicleNo = $1
├─ Order: date DESC (latest first)
├─ For each record:
│  ├─ Service Date (formatted)
│  ├─ Engine Oil: value
│  ├─ Air Filter: value
│  ├─ Oil Filter: value
│  ├─ Spark Plug: value
│  ├─ Self Start: value
│  ├─ Bike Wash: value
│  ├─ Brake Pads: value
│  ├─ Brake Disc: value
│  ├─ Lights & Signal: value
│  ├─ Clutch Wire: value
│  ├─ Battery: value
│  ├─ Drive Chain: value
│  └─ Horn: value
```

### 4.5 SQL Query for PostgreSQL

```sql
-- Get all services for a bike, ordered by latest first
SELECT * FROM bike_services
WHERE vechile_no = $1
ORDER BY date DESC;

-- Get vehicle details for header
SELECT * FROM vechile_details
WHERE vechile_no = $1;
```

### 4.6 Features

- **Infinite Scroll:** Load more records as user scrolls
- **Latest First:** Most recent service at top
- **Complete Details:** All component statuses shown
- **Formatted Dates:** Converting TIMESTAMP to readable format
- **Back Button:** Navigate back to search page

---

## 5. CAR SERVICE HISTORY PAGE (HistoryCarWidget)

### 5.1 Page Information

**File Location:** `/lib/history_car/history_car_widget.dart`  
**Route Name:** `historyCar`  
**Route Path:** `/historyCar`  
**Input Parameters:**
- `vehicleNo` (String - vehicle registration number)
- `carBike` (String - "Car")

### 5.2 Purpose

- Display complete service history for a specific car
- Show all past service records in chronological order (latest first)
- Allow user to review service details
- Show service dates and component statuses

### 5.3 Page Layout

```
┌────────────────────────────────────────┐
│ ← SERVICE HISTORY                      │
├────────────────────────────────────────┤
│                                        │
│ Vehicle: MH02AB1234 (Car)              │
│ Model: Hyundai Creta                   │
│ Mobile: 9876543210                     │
│                                        │
├────────────────────────────────────────┤
│                                        │
│ Service Record 1 (Latest)              │
│ Date: 2024-05-04 02:45 PM              │
│ ├─ Engine Oil: Changed                 │
│ ├─ Coolant: Good                       │
│ ├─ Air Filter: Changed                 │
│ ├─ Oil Filter: Good                    │
│ ├─ AC Filter: Good                     │
│ ├─ Car Wash: Done                      │
│ ├─ Brake Pads: Good                    │
│ ├─ Brake Disc: Good                    │
│ ├─ Lights & Signal: Good               │
│ ├─ Brake Fluid: Good                   │
│ ├─ Gear Fluid: Good                    │
│ ├─ Wiper Blades: Good                  │
│ └─ Battery: Good                       │
│                                        │
│ ────────────────────────────────────   │
│                                        │
│ Service Record 2 (Earlier)             │
│ Date: 2024-03-15 11:20 AM              │
│ ├─ Engine Oil: Good                    │
│ ├─ Coolant: Good                       │
│ ... (all components)                   │
│                                        │
│ ────────────────────────────────────   │
│                                        │
│ [Scroll for more records]              │
│                                        │
└────────────────────────────────────────┘
```

### 5.4 Data Display Structure

```
Header Section:
├─ Vehicle Registration: vehicleNo
├─ Vehicle Type: "Car"
├─ Model from VechileDetailsRecord: model
├─ Mobile from VechileDetailsRecord: mobile

History List (StreamBuilder or Future):
├─ Query: CarServiceRecord where vehicleNo = $1
├─ Order: date DESC (latest first)
├─ For each record:
│  ├─ Service Date (formatted)
│  ├─ Engine Oil: value
│  ├─ Coolant: value
│  ├─ Air Filter: value
│  ├─ Oil Filter: value
│  ├─ AC Filter: value
│  ├─ Car Wash: value
│  ├─ Brake Pads: value
│  ├─ Brake Disc: value
│  ├─ Lights & Signal: value
│  ├─ Brake Fluid: value
│  ├─ Gear Fluid: value
│  ├─ Wiper Blades: value
│  └─ Battery: value
```

### 5.5 SQL Query for PostgreSQL

```sql
-- Get all services for a car, ordered by latest first
SELECT * FROM car_services
WHERE vechile_no = $1
ORDER BY date DESC;

-- Get vehicle details for header
SELECT * FROM vechile_details
WHERE vechile_no = $1;
```

### 5.6 Features

- **Infinite Scroll:** Load more records as user scrolls
- **Latest First:** Most recent service at top
- **Complete Details:** All component statuses shown
- **Formatted Dates:** Converting TIMESTAMP to readable format
- **Back Button:** Navigate back to search page

---

## 6. NAVIGATION FLOW DIAGRAM

```
SEARCH PAGE
├─ Service Button (Car)
│  └─→ ServiceForm2Widget
│      │  (Fill car service details)
│      └─→ Save to car_services
│          └─→ Navigate Back
│              └─→ SEARCH PAGE (Updated status)
│
├─ Service Button (Bike)
│  └─→ ServiceForm1Widget
│      │  (Fill bike service details)
│      └─→ Save to bike_services
│          └─→ Navigate Back
│              └─→ SEARCH PAGE (Updated status)
│
├─ History Button (Car)
│  └─→ HistoryCarWidget
│      │  (Show all car services)
│      └─→ Navigate Back
│          └─→ SEARCH PAGE
│
└─ History Button (Bike)
   └─→ HistoryBikeWidget
       │  (Show all bike services)
       └─→ Navigate Back
           └─→ SEARCH PAGE
```

---

## 7. DATA FLOW FROM SEARCH TO FORMS AND HISTORY

```
User on Search Page
│
├─ Taps "Service" Button on Vehicle Card
│  ├─ Get vehicleNo from VechileDetailsRecord
│  ├─ Check record.carBike type
│  └─ Navigate with query parameter:
│     if (Car) → /serviceForm2?vehicleNo=MH02AB1234
│     if (Bike) → /serviceForm1?vehicleNo=EQ02CD9876
│
│  Service Form Opens
│  ├─ Receive vehicleNo parameter
│  ├─ Display form with empty fields
│  ├─ User fills all components
│  └─ User clicks "Save Service"
│     ├─ Create record object
│     ├─ Insert into car_services/bike_services table
│     ├─ Current date auto-filled by DB
│     ├─ Show success message
│     └─ Pop to Search Page
│
│  Back on Search Page
│  ├─ Page reloads/rebuilds
│  ├─ Fetches vehicle list again
│  ├─ Queries service records for vehicle
│  ├─ Recalculates service status (now 'completed')
│  └─ Displays updated status badge
│
├─ Taps "History" Button on Vehicle Card
│  ├─ Get vehicleNo and carBike from record
│  ├─ Check record.carBike type
│  └─ Navigate with query parameters:
│     if (Car) → /historyCar?vehicleNo=MH02AB1234&carBike=Car
│     if (Bike) → /historyBike?vehicleNo=EQ02CD9876&carBike=Bike
│
│  History Page Opens
│  ├─ Receive vehicleNo and carBike parameters
│  ├─ Query all services for vehicle:
│     SELECT * FROM [car/bike]_services WHERE vehicleNo = param
│  ├─ Order by date DESC (latest first)
│  ├─ Display header with vehicle details
│  ├─ Display each service record with all components
│  └─ Enable infinite scroll for more records
│
│  User Reviews History
│  ├─ Scrolls through all service records
│  ├─ Sees what was serviced and when
│  ├─ Identifies patterns (e.g., "Oil changed every 3 months")
│  └─ Taps Back Button
│
└─ Back on Search Page
```

---

## 8. COMPONENT DETAILS FOR DROPDOWNS

### 8.1 Status Values for Each Component

**Engine Oil (Both Bike & Car):**
- Good
- Needs Change
- Changed
- Low Level
- Blackish

**Air Filter (Bike: air_filter):**
- Good
- Needs Change
- Changed
- Clogged

**Air Filter (Car: airfilter):**
- Good
- Needs Change
- Changed
- Clogged

**Oil Filter (Both Bike & Car):**
- Good
- Needs Change
- Changed
- Low

**Spark Plug (Bike Only):**
- Good
- Needs Change
- Changed
- Worn

**Self Start (Bike Only):**
- Working
- Not Working
- Repaired
- Weak

**Bike Wash (Bike Only):**
- Done
- Not Done
- Pending
- Partial

**Car Wash (Car Only):**
- Done
- Not Done
- Pending
- Partial

**Brake Pads (Both Bike & Car):**
- Good
- Needs Change
- Changed
- Worn

**Brake Disc (Brake Disc) (Both Bike & Car):**
- Good
- Needs Change
- Changed
- Warped

**Lights & Signal (Both Bike & Car):**
- Good
- Needs Repair
- Repaired
- Not Working

**Clutch Wire (Bike Only):**
- Good
- Needs Adjustment
- Adjusted
- Loose

**Battery (Both Bike & Car):**
- Good
- Needs Change
- Changed
- Low

**Drive Chain (Bike Only):**
- Good
- Needs Lubrication
- Lubricated
- Worn

**Horn (Bike Only):**
- Working
- Not Working
- Repaired
- Weak

**Coolant (Car Only):**
- Good
- Needs Refill
- Refilled
- Low

**AC Filter (Car Only):**
- Good
- Needs Change
- Changed
- Clogged

**Brake Fluid (Car Only):**
- Good
- Needs Refill
- Refilled
- Low

**Gear Fluid (Car Only):**
- Good
- Needs Change
- Changed
- Low

**Wiper Blades (Car Only):**
- Good
- Needs Change
- Changed
- Worn

---

## 9. FIELD VALIDATION RULES

### 9.1 Service Form Validation

**Bike Service Form (ServiceForm1):**
```
vehicleNo: Required (passed as parameter - auto-filled)
date: Auto-set (current timestamp)
user_input_fields: All optional, but at least one recommended
```

**Car Service Form (ServiceForm2):**
```
vehicleNo: Required (passed as parameter - auto-filled)
date: Auto-set (current timestamp)
user_input_fields: All optional, but at least one recommended
```

### 9.2 History Page Validation

**Vehicle Number:**
```
Must exist in vechile_details table
If not found: Show error message "Vehicle not found"
```

**Service Records:**
```
If no records found: Show "No service history found"
Display only records with matching vehicleNo
```

---

## 10. ERROR HANDLING FOR LINKED PAGES

### 10.1 Service Form Errors

| Scenario | Error Message | Action |
|----------|---------------|--------|
| Vehicle not found | "Vehicle not found" | Clear form, navigate back |
| Save failed | "Failed to save service record" | Show retry button |
| Network error | "Network error" | Show retry button |
| Invalid vehicle number | "Invalid vehicle number" | Clear form |
| Duplicate entry | "Service already recorded for today" | Ask if user wants to update |

### 10.2 History Page Errors

| Scenario | Error Message | Action |
|----------|---------------|--------|
| Vehicle not found | "Vehicle not found" | Navigate back |
| No history | "No service history found" | Show empty state |
| Load more failed | "Failed to load more records" | Show retry button |
| Network error | "Unable to load service history" | Show retry button |
| Invalid parameters | "Invalid parameters" | Navigate back |

---

## 11. TESTING SCENARIOS

### 11.1 Service Form Testing

```
Test 1: Fill and Save Bike Service
├─ Navigate to ServiceForm1 with valid vehicleNo
├─ Fill all fields
├─ Click Save
└─ Verify record created in bike_services

Test 2: Partial Service Record
├─ Navigate to ServiceForm1 with valid vehicleNo
├─ Fill only 3 components
├─ Click Save
└─ Verify record created with nulls for unfilled fields

Test 3: Clear Form
├─ Navigate to ServiceForm1
├─ Fill some fields
├─ Click Clear Form
└─ Verify all fields cleared

Test 4: Invalid Vehicle Number
├─ Navigate to ServiceForm1 with invalid vehicleNo
├─ Verify error handling
└─ Verify form doesn't allow save

Test 5: Network Errors
├─ Navigate to ServiceForm1
├─ Disconnect network
├─ Click Save
└─ Verify error message and retry option
```

### 11.2 History Page Testing

```
Test 1: Load Bike History
├─ Navigate to HistoryBike with valid vehicleNo
├─ Verify all service records displayed
├─ Verify ordered by date DESC
└─ Verify each record shows all components

Test 2: Infinite Scroll
├─ Load HistoryBike
├─ Scroll to bottom
├─ Verify more records loaded
└─ Verify no duplicate records

Test 3: Empty History
├─ Navigate to HistoryBike with vehicle having no services
├─ Verify empty state message
└─ Verify can navigate back

Test 4: Vehicle Details Header
├─ Load HistoryBike
├─ Verify vehicle name, model, mobile displayed
│
└─ Verify car/bike badge shown

Test 5: Network Errors
├─ Load HistoryBike
├─ Disconnect network during scroll
├─ Verify error handling
└─ Verify retry option
```

---

## 12. POSTGRESQL API DEVELOPMENT GUIDE

### 12.1 Service Form API Endpoint

**Endpoint:** `POST /api/[car|bike]-services`

**Request Body:**
```json
{
    "vehicleNo": "MH02AB1234",
    "engineOil": "Changed",
    "airFilter": "Good",
    "oilFilter": "Good",
    ... // all other fields
    "date": "2024-05-04T10:30:00Z"  // Optional: use NOW() if not provided
}
```

**Success Response (201 Created):**
```json
{
    "id": 123,
    "vehicleNo": "MH02AB1234",
    "engineOil": "Changed",
    ... // all fields
    "date": "2024-05-04T10:30:00Z",
    "createdAt": "2024-05-04T10:35:00Z"
}
```

**Error Response (400 Bad Request):**
```json
{
    "error": "Invalid vehicle number",
    "message": "Vehicle MH02AB1234 not found"
}
```

### 12.2 History Page API Endpoint

**Endpoint:** `GET /api/[car|bike]-services?vehicleNo={xxx}&limit=20&offset=0`

**Query Parameters:**
- `vehicleNo`: Vehicle registration number (required)
- `limit`: Items per page (default: 20)
- `offset`: Pagination offset (default: 0)

**Success Response (200 OK):**
```json
{
    "data": [
        {
            "id": 125,
            "vehicleNo": "MH02AB1234",
            "engineOil": "Changed",
            ... // all fields
            "date": "2024-05-04T10:30:00Z",
            "createdAt": "2024-05-04T10:35:00Z"
        },
        {
            "id": 124,
            "vehicleNo": "MH02AB1234",
            ... // previous service record
        }
    ],
    "total": 45,
    "limit": 20,
    "offset": 0,
    "hasMore": true
}
```

**Error Response (404 Not Found):**
```json
{
    "error": "Vehicle not found",
    "message": "No vehicle with number MH02AB1234"
}
```

---

## 13. SUMMARY OF REQUIRED FILES

For PostgreSQL implementation, you'll need to create/update:

1. **Database Schema:**
   - `car_services` table
   - `bike_services` table
   - `vechile_details` table
   - Proper indexes and foreign keys

2. **API Endpoints:**
   - `POST /api/car-services` - Create car service
   - `POST /api/bike-services` - Create bike service
   - `GET /api/car-services?vehicleNo={xxx}` - Get car service history
   - `GET /api/bike-services?vehicleNo={xxx}` - Get bike service history

3. **Flutter Data Models:**
   - CarServiceResponse
   - BikeServiceResponse
   - VehicleHistoryResponse

4. **Flutter API Services:**
   - CarServiceService
   - BikeServiceService
   - HistoryService

5. **Error Handling:**
   - Network error handling
   - Validation error handling
   - Database error handling

---

**Document Version:** 1.0  
**Last Updated:** May 4, 2026  
**For:** PostgreSQL Migration & AI Agent Implementation


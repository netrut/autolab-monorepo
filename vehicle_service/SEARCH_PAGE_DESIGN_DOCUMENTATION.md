# AutoLab Search Page - Design & Functionality Documentation

## 1. PROJECT OVERVIEW

**Page Name:** Search Vehicles Page  
**File Location:** `/lib/search/search_widget.dart`  
**Route Name:** `search`  
**Route Path:** `/search`  
**Type:** Stateful Widget  
**Purpose:** Display all vehicles registered in the system and allow users to:
- Search vehicles by vehicle number or mobile number
- Filter services by status (Due, Upcoming, Completed)
- Access vehicle service form
- View complete service history

---

## 2. UI DESIGN & LAYOUT

### 2.1 Page Structure

```
┌─────────────────────────────────────────┐
│          AppBar (SEARCH)                │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  Search Vehicles                        │
│  Find your vehicle and open service...  │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  [Search Icon] [Search Field] [Filter]  │
│  "Search vehicle number or mobile"      │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ [All] [Due] [Upcoming] [Completed]      │
│ Service Filter Chips (Horizontal)       │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│                                         │
│  ┌──────────────────────────────────┐  │
│  │ [Car Icon] | Model: ABC123       │  │
│  │             Status: [Due Service]│  │
│  │             Bike • 9876543210    │  │
│  │             [Service] [History]  │  │
│  └──────────────────────────────────┘  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │ [Bike Icon] | Model: XYZ789      │  │
│  │              Status: [Upcoming]  │  │
│  │              Car • 1234567890    │  │
│  │              [Service] [History] │  │
│  └──────────────────────────────────┘  │
│                                         │
│         [Infinite Scroll List]         │
│                                         │
└─────────────────────────────────────────┘
```

### 2.2 Color Scheme

| Element | Color Code | Usage |
|---------|-----------|-------|
| Background (Page) | `#F3F3F3` | Main background |
| AppBar | `#F3F3F3` | Header background |
| White Cards | `#FFFFFF` | Vehicle cards |
| Text Primary | `#1F1F1F` | Main headings & text |
| Text Secondary | `#7A7A7A` | Subtitle text |
| Due Service (BG) | `#FFF0DE` | Due status background |
| Due Service (Text) | `#DA8A1D` | Due status text |
| Upcoming Service (BG) | `#EAF2FF` | Upcoming status background |
| Upcoming Service (Text) | `#2F7DE1` | Upcoming status text |
| Completed Service (BG) | `#E8F7EE` | Completed status background |
| Completed Service (Text) | `#2F9E56` | Completed status text |
| Border | `#E4E4E4` | Card borders |
| Disabled Filter | `#EFEF` | All Services filter |
| Button (Service) | `#1F1F1F` | Black button |
| Button (History) | `#FFFFFF` | White with border |

### 2.3 Typography

| Element | Font Family | Font Size | Font Weight |
|---------|-------------|-----------|-------------|
| Page Title | Poppins | 30px | 700 (Bold) |
| Subtitle | Poppins | 14px | 500 (Medium) |
| Vehicle Number | Poppins | 17px | 600 (Semi-bold) |
| Service Status | Poppins | 12px | 600 (Semi-bold) |
| Details Text | Poppins | 12px | 500 (Medium) |
| Button Text | Poppins | 12.5px | 500 (Medium) |
| Filter Dialog Title | Poppins | 20px | 700 (Bold) |

---

## 3. FEATURES & FUNCTIONALITY

### 3.1 Search Field

**Functionality:**
- Real-time search using debounce (350ms delay)
- Searches vehicle number and mobile number
- Case-insensitive search
- Clear button appears when text is entered
- Updates search results dynamically

**Technical Details:**
```
Controller: TextEditingController (_model.searchFieldTextController)
FocusNode: FocusNode (_model.searchFieldFocusNode)
Debounce: 350 milliseconds
Hint: "Search vehicle number or mobile"
```

**Search Logic:**
```dart
final searchQuery = _model.searchFieldTextController.text.toLowerCase().trim();

// Matches if any field contains search query
final matchesQuery = searchQuery.isEmpty ||
    record.vechileNo.toLowerCase().contains(searchQuery) ||
    record.carBike.toLowerCase().contains(searchQuery) ||
    record.mobile.toLowerCase().contains(searchQuery);
```

### 3.2 Service Filter Chips

**Filter Options:**
1. **All Services** (Default) - Shows all vehicles regardless of service status
2. **Due Services** - Shows vehicles with service due
3. **Upcoming Services** - Shows vehicles with upcoming service
4. **Service Completed** - Shows vehicles with completed service

**Visual States:**
- **Selected:** Colored background + colored border + colored text
- **Unselected:** White background + gray border + gray text

**Implementation:**
```dart
selectedServiceFilter = null;  // null = 'All Services'
selectedServiceFilter = 'due';
selectedServiceFilter = 'upcoming';
selectedServiceFilter = 'completed';
```

### 3.3 Advanced Filter Dialog

**Triggered by:** Clicking the filter icon in the search field

**Filter Categories:**

#### Due Services Section (Orange - #DA8A1D)
- Due Today
- Due Yesterday
- Due Last 7 Days
- Due Last 30 Days

#### Upcoming Services Section (Blue - #2F7DE1)
- Next 7 Days
- Next 30 Days

#### Service Completed Section (Green - #2F9E56)
- Completed Yesterday
- Completed Last 7 Days
- Completed Last 30 Days

**Currently:** Date filter state is defined but not fully implemented in v1

### 3.4 Vehicle Card Display

**Card Layout:**
```
┌─────────────────────────────────────────────┐
│ ┌──────────┐  Vehicle Number (ABC123)       │
│ │  Image   │  [Status Badge]                │
│ │  112x112 │  Car • 9876543210              │
│ │ (rounded)│                                │
│ │          │  [Service Button] [History]    │
│ └──────────┘                                │
└─────────────────────────────────────────────┘
```

**Card Specifications:**
- Width: Full width (double.infinity)
- Height: 154px
- Background: White (#FFFFFF)
- Border Radius: 16px
- Border: 1px #E4E4E4
- Shadow: Blur 10, Color 0x14000000, Offset (0, 4)

**Card Fields Displayed:**
- **Vehicle Number:** `record.vechileNo` (17px, Bold)
- **Service Status:** Status badge (Due/Upcoming/Completed)
- **Car/Bike Type & Mobile:** `${record.carBike} • ${record.mobile}` (12px, Gray)
- **Vehicle Image:** Based on `record.carBike` type
  - If Car: `assets/images/four-wheeler.png`
  - If Bike: `assets/images/carApp2.png`

---

## 4. SERVICE STATUS LOGIC

### 4.1 Status Determination Algorithm

**Function:** `_getServiceStatusFromDates(Iterable<DateTime?> dates)`

**Logic:**
1. Collect all service dates from the corresponding car/bike service records
2. Filter out null values
3. Sort dates in descending order (latest first)
4. Get the most recent date
5. Compare with today's date:

```
if (latestDate > today) {
    status = 'upcoming'
}
else if (latestDate < today - 30 days) {
    status = 'completed'
}
else {
    status = 'due'  // Within last 30 days
}
```

**Status States:**

| Status | Condition | Label | Background | Text Color |
|--------|-----------|-------|------------|-----------|
| due | Latest date within last 30 days | "Due Service" | #FFF0DE | #DA8A1D |
| upcoming | Latest date is in future | "Upcoming Service" | #EAF2FF | #2F7DE1 |
| completed | Latest date > 30 days ago | "Service Completed" | #E8F7EE | #2F9E56 |

### 4.2 Start of Today Calculation

```dart
DateTime get _startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
}
```

---

## 5. DATA FETCHING FROM FIREBASE

### 5.1 Data Flow Architecture

```
VechileDetailsRecord Collection
    ↓
    ├─→ For each vehicle with carBike = 'Car'
    │   └─→ Query CarServiceRecord where vechile_no = vehicle.vechileNo
    │       └─→ Get all service dates
    │           └─→ Calculate status = 'due'|'upcoming'|'completed'
    │
    └─→ For each vehicle with carBike = 'Bike'
        └─→ Query BikeServiceRecord where vechile_no = vehicle.vechileNo
            └─→ Get all service dates
                └─→ Calculate status = 'due'|'upcoming'|'completed'
```

### 5.2 Main Data Fetching Method

**Function:** `_buildSearchCardWithFilter(BuildContext context, VechileDetailsRecord record)`

This function:
1. Checks if vehicle is Car or Bike
2. Sets up appropriate StreamBuilder
3. Queries the corresponding service table
4. Filters by vehicle number
5. Calculates service status
6. Applies service status filter
7. Returns the vehicle card or empty widget if filtered out

**Code Flow:**

```dart
// If Car
StreamBuilder<List<CarServiceRecord>>(
    stream: queryCarServiceRecord(
        queryBuilder: (carServiceRecord) =>
            carServiceRecord.where('vechile_no', 
                isEqualTo: record.vechileNo),
    ),
    builder: (context, snapshot) {
        if (!snapshot.hasData) {
            return SizedBox.shrink();
        }
        
        // Extract dates and calculate status
        final status = _getServiceStatusFromDates(
            snapshot.data!.map((e) => e.date)
        );
        
        // Apply filter - if status doesn't match filter, hide
        if (status == null || !_matchesServiceFilter(status)) {
            return SizedBox.shrink();
        }
        
        // Build and return card
        return _buildSearchCard(context, record, status);
    },
);

// Similar for Bike...
```

### 5.3 List Pagination

**Implementation:** `PagedListView` with `PagingController`

```dart
PagedListView<DocumentSnapshot<Object?>?, VechileDetailsRecord>(
    pagingController: _model.setListViewController(
        VechileDetailsRecord.collection,
    ),
    builderDelegate: PagedChildBuilderDelegate<VechileDetailsRecord>(
        firstPageProgressIndicatorBuilder: (_) => LoadingSpinner,
        newPageProgressIndicatorBuilder: (_) => LoadingSpinner,
        noItemsFoundIndicatorBuilder: (_) => "No vehicles found",
        itemBuilder: (context, _, listViewIndex) => VehicleCard,
    ),
)
```

**Features:**
- Infinite scroll pagination
- Progress indicators on first page load
- Progress indicators on new page load
- Shows "No vehicles found" when empty
- Automatic pagination when scrolling

---

## 6. DATA MODELS & DATABASE SCHEMA

### 6.1 VechileDetailsRecord (Main Vehicle Data)

**Collection Name:** `vechile_details`

**Fields:**

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| name | String | Owner name | "John Doe" |
| mobile | String | Owner mobile number | "9876543210" |
| company | String | Company/Organization | "ABC Company" |
| model | String | Vehicle model | "Hyundai Creta" |
| vechile_no | String | Vehicle registration number | "MH02AB1234" |
| make_year | String | Year of manufacture | "2020" |
| chasis_no | String | Chassis number | "CH123456" |
| fuel_type | String | Fuel type | "Diesel" OR "Petrol" |
| transmission | String | Transmission type | "Automatic" OR "Manual" |
| car_bike | String | Vehicle type | "Car" OR "Bike" |

---

### 6.2 CarServiceRecord (Car Service History)

**Collection Name:** `car_services` (Firebase) → `car_services` table (PostgreSQL)

**Fields:**

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| engine_oil | String | Engine oil status | "Good" / "Needs Change" |
| coolant | String | Coolant status | "Good" |
| airfilter | String | Air filter status | "Good" |
| oil_filter | String | Oil filter status | "Needs Change" |
| ac_filter | String | AC filter status | "Good" |
| car_wash | String | Car wash status | "Done" |
| break_pads | String | Brake pads status | "Good" |
| break_disc | String | Brake disc status | "Good" |
| lights_signal | String | Lights & signal status | "Good" |
| break_fluid | String | Brake fluid status | "Good" |
| gear_fluid | String | Gear fluid status | "Good" |
| wiper_blades | String | Wiper blades status | "Good" |
| battery | String | Battery status | "Good" |
| date | DateTime | Service date | "2024-05-04T10:30:00Z" |
| vechile_no | String | FK - Vehicle reference | "MH02AB1234" |

---

### 6.3 BikeServiceRecord (Bike Service History)

**Collection Name:** `bike_services` (Firebase) → `bike_services` table (PostgreSQL)

**Fields:**

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| engine_oil | String | Engine oil status | "Good" |
| air_filter | String | Air filter status | "Needs Change" |
| oil_filter | String | Oil filter status | "Good" |
| spark_plug | String | Spark plug status | "Good" |
| self_start | String | Self start status | "Working" |
| bike_wash | String | Bike wash status | "Done" |
| brake_pads | String | Brake pads status | "Good" |
| break_disc | String | Brake disc status | "Good" |
| lights_signal | String | Lights & signal status | "Good" |
| clutch_wire | String | Clutch wire status | "Good" |
| battery | String | Battery status | "Good" |
| drive_chain | String | Drive chain status | "Good" |
| horn | String | Horn status | "Working" |
| date | DateTime | Service date | "2024-05-04T10:30:00Z" |
| vechile_no | String | FK - Vehicle reference | "EQ02CD9876" |

---

## 7. USER INTERACTIONS & NAVIGATION

### 7.1 Service Button

**Triggered:** When user clicks "Service" button on vehicle card

**Action:**
- Checks if vehicle is Car or Bike
- Routes to appropriate service form page
- Passes vehicle number as query parameter

**Routing Logic:**

```dart
if (record.carBike == 'Car') {
    context.pushNamed(
        ServiceForm2Widget.routeName,  // '/serviceForm2'
        queryParameters: {
            'vechileNo': record.vechileNo,
        },
    );
} else {
    context.pushNamed(
        ServiceForm1Widget.routeName,  // '/serviceForm1'
        queryParameters: {
            'vechileNo': record.vechileNo,
        },
    );
}
```

**Linked Pages:**
- **Bike Service Form:** `ServiceForm1Widget` → `/lib/service_form1/service_form1_widget.dart`
- **Car Service Form:** `ServiceForm2Widget` → `/lib/service_form2/service_form2_widget.dart`

---

### 7.2 History Button

**Triggered:** When user clicks "History" button on vehicle card

**Action:**
- Checks if vehicle is Car or Bike
- Routes to appropriate history page
- Passes vehicle number and vehicle type as query parameters

**Routing Logic:**

```dart
if (record.carBike == 'Car') {
    context.pushNamed(
        HistoryCarWidget.routeName,  // '/historyCar'
        queryParameters: {
            'vechileNo': record.vechileNo,
            'carBike': record.carBike,
        },
    );
} else {
    context.pushNamed(
        HistoryBikeWidget.routeName,  // '/historyBike'
        queryParameters: {
            'vechileNo': record.vechileNo,
            'carBike': record.carBike,
        },
    );
}
```

**Linked Pages:**
- **Bike History:** `HistoryBikeWidget` → `/lib/history_bike/history_bike_widget.dart`
- **Car History:** `HistoryCarWidget` → `/lib/history_car/history_car_widget.dart`

---

## 8. LINKED PAGES DOCUMENTATION

### 8.1 ServiceForm1Widget (Bike Service Form)

**File:** `/lib/service_form1/service_form1_widget.dart`  
**Route:** `/serviceForm1`  
**Route Name:** `serviceForm1`

**Purpose:** 
- Collect bike service details
- Record new service for a specific bike
- Fill in service status for various bike components

**Input Parameters:**
- `vehicleNo` (String): The bike's registration number

**Bike Service Components to Fill:**
- Engine Oil
- Air Filter
- Oil Filter
- Spark Plug
- Self Start
- Bike Wash
- Brake Pads
- Brake Disc
- Lights & Signal
- Clutch Wire
- Battery
- Drive Chain
- Horn

**Data Submission:**
- Creates/updates record in `bike_services` collection
- Records service date (current date/time)
- Links to vehicle via `vehicle_no` field

---

### 8.2 ServiceForm2Widget (Car Service Form)

**File:** `/lib/service_form2/service_form2_widget.dart`  
**Route:** `/serviceForm2`  
**Route Name:** `serviceForm2`

**Purpose:**
- Collect car service details
- Record new service for a specific car
- Fill in service status for various car components

**Input Parameters:**
- `vehicleNo` (String): The car's registration number

**Car Service Components to Fill:**
- Engine Oil
- Coolant
- Air Filter
- Oil Filter
- AC Filter
- Car Wash
- Brake Pads
- Brake Disc
- Lights & Signal
- Brake Fluid
- Gear Fluid
- Wiper Blades
- Battery

**Data Submission:**
- Creates/updates record in `car_services` collection
- Records service date (current date/time)
- Links to vehicle via `vehicle_no` field

---

### 8.3 HistoryBikeWidget (Bike Service History)

**File:** `/lib/history_bike/history_bike_widget.dart`  
**Route:** `/historyBike`  
**Route Name:** `historyBike`

**Purpose:**
- Display chronological list of all past bike services
- Show detailed service records for a specific bike
- Let user review what services were performed

**Input Parameters:**
- `vehicleNo` (String): The bike's registration number
- `carBike` (String): Vehicle type ("Bike")

**Display Features:**
- Vehicle header card with bike details
- Service history list (sorted by latest first)
- Each entry shows:
  - Service date
  - All bike service components with their status
  - Visual status indicators

**Data Source:**
- Queries `bike_services` collection/table
- Filters by `vehicle_no` matching input parameter
- Orders by date (latest first)

---

### 8.4 HistoryCarWidget (Car Service History)

**File:** `/lib/history_car/history_car_widget.dart`  
**Route:** `/historyCar`  
**Route Name:** `historyCar`

**Purpose:**
- Display chronological list of all past car services
- Show detailed service records for a specific car
- Let user review maintenance history

**Input Parameters:**
- `vehicleNo` (String): The car's registration number
- `carBike` (String): Vehicle type ("Car")

**Display Features:**
- Vehicle header card with car details
- Service history list (sorted by latest first)
- Each entry shows:
  - Service date
  - All car service components with their status
  - Visual status indicators

**Data Source:**
- Queries `car_services` collection/table
- Filters by `vehicle_no` matching input parameter
- Orders by date (latest first)

---

## 9. IMPLEMENTATION FOR PostgreSQL WITH SUPABASE

### 9.1 Database 

**Required Tables already created in PostgreSQL as mentioned in backend schema:**

#### Table: `vechile_details`
```sql
CREATE TABLE vechile_details (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    company VARCHAR(255),
    model VARCHAR(255),
    vechile_no VARCHAR(50) NOT NULL UNIQUE,
    make_year VARCHAR(4),
    chasis_no VARCHAR(100),
    fuel_type VARCHAR(50),
    transmission VARCHAR(50),
    car_bike VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Table: `car_services`
```sql
CREATE TABLE car_services (
    id BIGSERIAL PRIMARY KEY,
    engine_oil VARCHAR(255),
    coolant VARCHAR(255),
    airfilter VARCHAR(255),
    oil_filter VARCHAR(255),
    ac_filter VARCHAR(255),
    car_wash VARCHAR(255),
    break_pads VARCHAR(255),
    break_disc VARCHAR(255),
    lights_signal VARCHAR(255),
    break_fluid VARCHAR(255),
    gear_fluid VARCHAR(255),
    wiper_blades VARCHAR(255),
    battery VARCHAR(255),
    date TIMESTAMP NOT NULL,
    vechile_no VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vechile_no) REFERENCES vechile_details(vechile_no) ON DELETE CASCADE
);

CREATE INDEX idx_car_services_vehicle_no ON car_services(vechile_no);
CREATE INDEX idx_car_services_date ON car_services(date);
```

#### Table: `bike_services`
```sql
CREATE TABLE bike_services (
    id BIGSERIAL PRIMARY KEY,
    engine_oil VARCHAR(255),
    air_filter VARCHAR(255),
    oil_filter VARCHAR(255),
    spark_plug VARCHAR(255),
    self_start VARCHAR(255),
    bike_wash VARCHAR(255),
    brake_pads VARCHAR(255),
    break_disc VARCHAR(255),
    lights_signal VARCHAR(255),
    clutch_wire VARCHAR(255),
    battery VARCHAR(255),
    drive_chain VARCHAR(255),
    horn VARCHAR(255),
    date TIMESTAMP NOT NULL,
    vechile_no VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vechile_no) REFERENCES vechile_details(vechile_no) ON DELETE CASCADE
);

CREATE INDEX idx_bike_services_vehicle_no ON bike_services(vechile_no);
CREATE INDEX idx_bike_services_date ON bike_services(date);
```

### 9.2 API Requirements

#### Endpoint: Get All Vehicles

```
GET /api/vehicles
Response: List[VehicleDetail]
Pagination: offset, limit
```

**Response Example:**
```json
{
    "data": [
        {
            "id": 1,
            "name": "John Doe",
            "mobile": "9876543210",
            "company": "ABC Company",
            "model": "Hyundai Creta",
            "vechile_no": "MH02AB1234",
            "make_year": "2020",
            "chasis_no": "CH123456",
            "fuel_type": "Diesel",
            "transmission": "Automatic",
            "car_bike": "Car"
        }
    ],
    "total": 100,
    "page": 1,
    "limit": 10
}
```

#### Endpoint: Get Car Services for Vehicle

```
GET /api/car-services?vehicle_no={vehicle_no}
Response: List[CarService]
Order: date DESC
```

**Response Example:**
```json
{
    "data": [
        {
            "id": 1,
            "engine_oil": "Changed",
            "coolant": "Good",
            "airfilter": "Needs Change",
            "oil_filter": "Changed",
            "ac_filter": "Good",
            "car_wash": "Done",
            "break_pads": "Good",
            "break_disc": "Good",
            "lights_signal": "Good",
            "break_fluid": "Good",
            "gear_fluid": "Good",
            "wiper_blades": "Good",
            "battery": "Good",
            "date": "2024-05-04T10:30:00Z",
            "vechile_no": "MH02AB1234"
        }
    ]
}
```

#### Endpoint: Get Bike Services for Vehicle

```
GET /api/bike-services?vehicle_no={vehicle_no}
Response: List[BikeService]
Order: date DESC
```

**Response Example:**
```json
{
    "data": [
        {
            "id": 1,
            "engine_oil": "Changed",
            "air_filter": "Good",
            "oil_filter": "Changed",
            "spark_plug": "Good",
            "self_start": "Working",
            "bike_wash": "Done",
            "brake_pads": "Good",
            "break_disc": "Good",
            "lights_signal": "Good",
            "clutch_wire": "Good",
            "battery": "Good",
            "drive_chain": "Good",
            "horn": "Working",
            "date": "2024-05-04T10:30:00Z",
            "vechile_no": "EQ02CD9876"
        }
    ]
}
```

#### Endpoint: Create Car Service Record

```
POST /api/car-services
Body: {
    "engine_oil": "Changed",
    "coolant": "Good",
    ... // all other fields
    "date": "2024-05-04T10:30:00Z",
    "vechile_no": "MH02AB1234"
}
Response: CarService (created record)
```

#### Endpoint: Create Bike Service Record

```
POST /api/bike-services
Body: {
    "engine_oil": "Changed",
    "air_filter": "Good",
    ... // all other fields
    "date": "2024-05-04T10:30:00Z",
    "vechile_no": "EQ02CD9876"
}
Response: BikeService (created record)
```

### 9.3 Search Implementation Logic

**Search Query (Case-Insensitive):**
```sql
SELECT * FROM vechile_details
WHERE LOWER(vechile_no) LIKE LOWER($1)
   OR LOWER(mobile) LIKE LOWER($2)
   OR LOWER(car_bike) LIKE LOWER($3)
ORDER BY vechile_no ASC
LIMIT $4 OFFSET $5
```

### 9.4 Service Status Filter Logic (Backend)

**Calculate Service Status:**
```sql
-- Get latest service date for a vehicle
SELECT date FROM car_services 
WHERE vechile_no = $1 
ORDER BY date DESC 
LIMIT 1;

-- Then in application logic:
if (latestDate > TODAY) {
    status = 'upcoming'
} else if (latestDate < TODAY - 30 DAYS) {
    status = 'completed'
} else {
    status = 'due'
}
```

**Or implement as database function:**
```sql
CREATE OR REPLACE FUNCTION get_service_status(
    vehicle_number VARCHAR,
    vehicle_type VARCHAR
) RETURNS VARCHAR AS $$
DECLARE
    latest_date TIMESTAMP;
BEGIN
    IF vehicle_type = 'Car' THEN
        SELECT MAX(date) INTO latest_date FROM car_services 
        WHERE vechile_no = vehicle_number;
    ELSE
        SELECT MAX(date) INTO latest_date FROM bike_services 
        WHERE vechile_no = vehicle_number;
    END IF;
    
    IF latest_date IS NULL THEN
        RETURN NULL;
    ELSIF latest_date > NOW() THEN
        RETURN 'upcoming';
    ELSIF latest_date < NOW() - INTERVAL '30 days' THEN
        RETURN 'completed';
    ELSE
        RETURN 'due';
    END IF;
END;
$$ LANGUAGE plpgsql;
```

### 9.5 Real-Time Updates (For Flutter App)

**Option 1: Polling**
- Fetch vehicle list every 30 seconds
- Fetch service records when opening vehicle detail

**Option 2: WebSocket (Recommended)**
- Use Supabase Realtime subscriptions
- Subscribe to changes on `vechile_details`, `car_services`, `bike_services` tables
- Update UI when data changes

**Example with Supabase Realtime:**
```dart
// Subscribe to vehicle changes
final subscription = supabase
    .from('vechile_details')
    .on(RealtimeListenTypes.all, (payload) {
        // Update UI with new data
    })
    .subscribe();
```

---

## 10. IMPLEMENTATION CHECKLIST FOR PostgreSQL VERSION

- [ ] Create PostgreSQL tables (`vechile_details`, `car_services`, `bike_services`)
- [ ] Create indexes on `vehicle_no` and `date` fields
- [ ] Implement API endpoints for:
  - [ ] Get all vehicles (with pagination)
  - [ ] Get car services by vehicle number
  - [ ] Get bike services by vehicle number
  - [ ] Create car service record
  - [ ] Create bike service record
  - [ ] Search vehicles (by number or mobile)
- [ ] Implement service status calculation logic
- [ ] Create Flutter data models for API responses
- [ ] Replace Firebase StreamBuilder with HTTP/WebSocket requests
- [ ] Implement PagedListView with API pagination
- [ ] Test search functionality
- [ ] Test filter functionality
- [ ] Test navigation to service forms
- [ ] Test navigation to history pages
- [ ] Implement error handling and loading states
- [ ] Set up Supabase Realtime subscriptions (optional)

---

## 11. KEY DIFFERENCES FROM Firebase TO PostgreSQL

| Aspect | Firebase | PostgreSQL |
|--------|----------|-----------|
| Real-time Data | StreamBuilder | HTTP polling or WebSocket |
| Query | `where()` clauses | SQL queries |
| Pagination | PagingController | Limit/Offset in SQL |
| Service Status | Calculated in Flutter | Can be pre-calculated or function |
| Indexing | Auto-created | Manual creation recommended |
| Transactions | Automatic | SQL ACID transactions |
| Cost Model | Per read/write | Time-based connection |

---

## 12. NOTES FOR POSTGRESQL IMPLEMENTATION

1. **DateTime Handling:** PostgreSQL uses TIMESTAMP, ensure proper timezone handling in Flutter
2. **Null Safety:** Both systems handle nulls, but behavior differs - test thoroughly
3. **Foreign Keys:** Use proper FK constraints to maintain data integrity
4. **Indexes:** Create indexes on `vechile_no` and `date` for performance
5. **Pagination:** Implement cursor-based pagination for better performance with large datasets
6. **Search Performance:** Consider full-text search if vehicle numbers grow large
7. **Service Status:** Pre-calculate in database using triggers for better performance
8. **Caching:** Implement local caching in Flutter to reduce API calls
9. **Error Handling:** Add proper error responses from API (HTTP status codes)
10. **Rate Limiting:** Implement rate limiting on API endpoints to prevent abuse

---

## 13. DEPLOYMENT NOTES

### Flutter App Changes Required:

1. Remove Firebase imports and dependencies
2. Add HTTP/Supabase client dependencies
3. Replace Firebase data models with API response DTOs
4. Replace StreamBuilder with FutureBuilder or PagedListView with API
5. Implement proper error handling and retry logic
6. Add connectivity checks before making API calls
7. Implement local caching using SQLite or Hive
8. Test thoroughly on both iOS and Android

### Backend Deployment:

1. Deploy PostgreSQL database
2. Set up Supabase project
3. Deploy API server (Node.js/Flutter Cloud Functions)
4. Configure CORS for Flutter app
5. Set up monitoring and logging
6. Create database backups
7. Implement rate limiting
8. Add API authentication/authorization if needed

---

## DOCUMENT VERSION

- **Version:** 1.0
- **Last Updated:** May 4, 2026
- **Created For:** PostgreSQL Migration Planning
- **Designed For:** CrossTeam AI Agent Implementation

---

## CONTACT & SUPPORT

For questions about this design document or implementation details, please refer to the original Firebase implementation in the Flutter codebase.


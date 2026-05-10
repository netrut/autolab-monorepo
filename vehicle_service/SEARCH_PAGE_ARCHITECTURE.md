# AutoLab Search Page - Technical Architecture & Data Flow

## 1. SYSTEM ARCHITECTURE DIAGRAM

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         FLUTTER MOBILE APP                               │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  SearchWidget (_SearchWidgetState)                                      │
│  ├─── SearchModel (_model)                                             │
│  │    ├─── TextEditingController (searchFieldTextController)          │
│  │    ├─── String selectedServiceFilter                               │
│  │    ├─── PagingController<DocumentSnapshot?, VechileDetailsRecord> │
│  │    └─── List<StreamSubscription> (for realtime updates)           │
│  │                                                                     │
│  ├─── UI Components                                                   │
│  │    ├─── AppBar (SEARCH)                                           │
│  │    ├─── Search Field with Debounce (350ms)                       │
│  │    ├─── Service Filter Chips (All, Due, Upcoming, Completed)    │
│  │    ├─── Advanced Date Filter Dialog                              │
│  │    └─── PagedListView (Infinite Scroll)                          │
│  │         └─── Vehicle Cards (SearchCard widgets)                  │
│  │                                                                     │
│  └─── Local State                                                    │
│       ├─── searchText (String)                                      │
│       ├─── _selectedDateFilter (String?)                            │
│       └─── scaffoldKey (GlobalKey<ScaffoldState>)                  │
│                                                                     │
└──────────────────────────────────────────────────────────────────────┘
                               ↓
            ┌─────────────────────────────────────┐
            │    FIREBASE (Current Implementation)│
            └─────────────────────────────────────┘
            
                     OR (For PostgreSQL)
                         ↓
┌──────────────────────────────────────────────────────────────────────────┐
│                      SUPABASE/REST API LAYER                            │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  HTTP Client / WebSocket Connection                                    │
│  ├─── GET /api/vehicles?page=1&limit=10                              │
│  ├─── GET /api/car-services?vehicle_no={xxx}                        │
│  ├─── GET /api/bike-services?vehicle_no={xxx}                       │
│  ├─── POST /api/car-services (Create service)                       │
│  └─── POST /api/bike-services (Create service)                      │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
                               ↓
┌──────────────────────────────────────────────────────────────────────────┐
│                         PostgreSQL DATABASE                              │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Tables:                                                                │
│  ├─── vechile_details (pk: id, uk: vechile_no)                       │
│  ├─── car_services (fk: vechile_no → vechile_details.vechile_no)    │
│  └─── bike_services (fk: vechile_no → vechile_details.vechile_no)   │
│                                                                          │
│  Indexes:                                                               │
│  ├─── idx_car_services_vehicle_no → Fast lookup by vehicle           │
│  ├─── idx_car_services_date → Fast date-based queries                │
│  ├─── idx_bike_services_vehicle_no → Fast lookup by vehicle          │
│  └─── idx_bike_services_date → Fast date-based queries               │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

## 2. DATA FLOW SEQUENCE

### 2.1 Initial Page Load Sequence

```
1. User navigates to Search page
   └─→ SearchWidget.build() called

2. SearchModel initialized
   └─→ PagingController created for VechileDetailsRecord.collection
   └─→ TextEditingController created for search field
   └─→ Initial query: SELECT ALL FROM vechile_details (limit: pageSize)

3. Firebase StreamBuilder attached to PagingController
   └─→ Listens to VechileDetailsRecord collection
   └─→ On data received: PagedListView rebuilds

4. For each VechileDetailsRecord:
   └─→ _buildSearchCardWithFilter() called
       ├─→ Check if record.carBike == 'Car' or 'Bike'
       ├─→ Query corresponding service table
       ├─→ Get all service dates for that vehicle
       ├─→ Calculate service status
       ├─→ Check if status matches current filter
       ├─→ If matches: Build and display card
       └─→ If not matches: Return empty widget (SizedBox.shrink())

5. PagedListView renders all matching cards with infinite scroll
```

### 2.2 Search Query Sequence (with Debounce)

```
1. User types in search field
   └─→ onChanged: triggered
   └─→ EasyDebounce triggered (350ms delay)

2. After delay (wait for user to stop typing):
   └─→ _model.searchText = new search value
   └─→ setState() called
   └─→ rebuild() triggered

3. In build() method:
   └─→ searchQuery = searchFieldTextController.text.toLowerCase().trim()
   └─→ PagedListView rebuilds with current paging controller

4. For each rendered item in PagedListView:
   └─→ Check if item matches search:
       matchesQuery = searchQuery.isEmpty ||
                      record.vechileNo.toLowerCase().contains(searchQuery) ||
                      record.carBike.toLowerCase().contains(searchQuery) ||
                      record.mobile.toLowerCase().contains(searchQuery)
       
   └─→ If matchesQuery: Display card
   └─→ Else: return SizedBox.shrink() (hide item)

5. Results update dynamically as user types
```

**Note:** The search filtering happens ON CLIENT SIDE, not on database. All vehicles are fetched from Firebase/database, and filtering is done in Flutter.

### 2.3 Service Status Filter Sequence

```
1. User taps a service filter chip (e.g., "Due Services")
   └─→ onSelected: triggered
   └─→ setState() called with new selectedServiceFilter value

2. setState() triggers rebuild()

3. For each vehicle in PagedListView:
   └─→ _buildSearchCardWithFilter() called again
   └─→ Fetches service records (StreamBuilder listens)
   └─→ Calculates status via _getServiceStatusFromDates()
   └─→ Checks filter match:
       
       if (_matchesServiceFilter(status)) {
           return _buildSearchCard(...)  // Show card
       } else {
           return SizedBox.shrink()      // Hide card
       }

4. Only cards matching filter are displayed
```

### 2.4 Service Status Calculation Sequence

```
INPUT: Iterable<DateTime?> dates (from service records)

1. Filter out null dates:
   validDates = dates.whereType<DateTime>().toList()

2. Check if empty:
   if (validDates.isEmpty) return null

3. Sort in descending order (latest first):
   validDates.sort((a, b) => b.compareTo(a))

4. Get the most recent date:
   latest = validDates.first

5. Compare with today:
   _startOfToday = DateTime(now.year, now.month, now.day)
   
   if (latest.isAfter(_startOfToday)) {
       return 'upcoming'
   }
   else if (latest.isBefore(_startOfToday.subtract(Duration(days: 30)))) {
       return 'completed'
   }
   else {
       return 'due'
   }

OUTPUT: 'due' | 'upcoming' | 'completed' | null
```

### 2.5 Service Button Navigation Sequence

```
1. User taps "Service" button on vehicle card
   └─→ onPressed: triggered with record data

2. Check vehicle type:
   if (record.carBike == 'Car') {
       // Route to Car Service Form
       context.pushNamed(
           ServiceForm2Widget.routeName,
           queryParameters: { 'vechileNo': record.vechileNo }
       )
   } else {
       // Route to Bike Service Form
       context.pushNamed(
           ServiceForm1Widget.routeName,
           queryParameters: { 'vechileNo': record.vechileNo }
       )
   }

3. Service form page opens with pre-filled vehicle number
   └─→ User fills service details
   └─→ User submits form
   └─→ New service record created in database

4. Navigation returns to Search page
   └─→ Search page reloads
   └─→ New service record fetched
   └─→ Service status updated
   └─→ Card displays new status
```

### 2.6 History Button Navigation Sequence

```
1. User taps "History" button on vehicle card
   └─→ onPressed: triggered with record data

2. Check vehicle type:
   if (record.carBike == 'Car') {
       // Route to Car History
       context.pushNamed(
           HistoryCarWidget.routeName,
           queryParameters: {
               'vechileNo': record.vechileNo,
               'carBike': record.carBike
           }
       )
   } else {
       // Route to Bike History
       context.pushNamed(
           HistoryBikeWidget.routeName,
           queryParameters: {
               'vechileNo': record.vechileNo,
               'carBike': record.carBike
           }
       )
   }

3. History page opens
   └─→ Queries all service records for vehicle
   └─→ Displays in chronological order (latest first)
   └─→ Shows all service details for each record

4. User can review complete service history
```

---

## 3. STATE MANAGEMENT FLOW

### 3.1 SearchWidget State Variables

```
Class: _SearchWidgetState extends State<SearchWidget>

Local State:
┌─────────────────────────────────────────────────┐
│ String? _selectedDateFilter                    │
│ Purpose: Store selected date filter option      │
│ Values: 'due_today' | 'due_yesterday' |        │
│         'due_7days' | 'due_30days' |           │
│         'upcoming_7days' | 'upcoming_30days' |  │
│         'completed_yesterday' | ...            │
│ Usage: Currently stored but not much used in v1│
└─────────────────────────────────────────────────┘

Model State (SearchModel):
┌─────────────────────────────────────────────────┐
│ String searchText                              │
│ Purpose: Store current search query            │
│ Updates: Every 350ms after user stops typing  │
│ Usage: Filter vehicle list on client-side     │
└─────────────────────────────────────────────────┘

│ String? selectedServiceFilter                  │
│ Purpose: Store selected service status filter  │
│ Values: null | 'due' | 'upcoming' |            │
│         'completed'                            │
│ Updates: When user taps filter chip            │
│ Usage: Hide/show cards based on status        │
└─────────────────────────────────────────────────┘

│ TextEditingController searchFieldTextController│
│ Purpose: Control search input field            │
│ Usage: Get current text, set text, clear      │
└─────────────────────────────────────────────────┘

│ FocusNode searchFieldFocusNode                 │
│ Purpose: Manage focus for search field         │
│ Usage: Show/hide keyboard                      │
└─────────────────────────────────────────────────┘

│ PagingController<DocumentSnapshot?,            │
│   VechileDetailsRecord> listViewPagingController
│ Purpose: Manage pagination for vehicle list   │
│ Usage: Infinite scroll, loading more pages    │
└─────────────────────────────────────────────────┘
```

### 3.2 State Update Flow

```
User Action → setState() → build() → Widget Tree Rebuilt

Example 1: Search Query Update
─────────────────────────────
searchFieldTextController.onChanged 
  → EasyDebounce.debounce(350ms)
  → _model.searchText = newValue
  → safeSetState(() {})  // setState() with build context safety
  → rebuild()
  → PagedListView rebuilds
  → _buildSearchCardWithFilter() called for each item
  → matchesQuery check filters cards

Example 2: Service Filter Update
─────────────────────────────────
FilterChip.onSelected(isSelected)
  → setState(() {
      _model.selectedServiceFilter = newValue
    })
  → rebuild()
  → _buildSearchCardWithFilter() called for each item
  → _matchesServiceFilter() checks if status matches
  → Cards hidden/shown accordingly

Example 3: Infinite Scroll
──────────────────────────
User scrolls to bottom
  → PagedListView detects
  → PagingController requests next page
  → Firebase query fetches next batch
  → New items added to list
  → List rebuilds with new items
```

---

## 4. COMPONENT INTERACTION MAP

```
SearchWidget (Main Widget)
│
├─── AppBar
│    └─── "SEARCH" title
│
├─── Column (Body Layout)
│    │
│    ├─── Text: "Search Vehicles"
│    │
│    ├─── Text: "Find your vehicle..."
│    │
│    ├─── Search Container
│    │    ├─── Icon: search_rounded
│    │    ├─── TextFormField ← searchFieldTextController
│    │    ├─── Icon: clear (conditional)
│    │    └─── Icon: tune_rounded ← Opens filter dialog
│    │
│    ├─── _buildServiceFilterChips()
│    │    └─── Row of FilterChips
│    │         ├─── "All Services"
│    │         ├─── "Due Services"
│    │         ├─── "Upcoming Services"
│    │         └─── "Service Completed"
│    │
│    └─── PagedListView
│         ├─── ListViewPagingController (pagination)
│         └─── For each VechileDetailsRecord:
│              └─── _buildSearchCardWithFilter()
│                   │
│                   ├─── StreamBuilder<List<CarServiceRecord>>
│                   │    or
│                   ├─── StreamBuilder<List<BikeServiceRecord>>
│                   │    │
│                   │    └─── Query by vehicle_no
│                   │         └─── Calculate status
│                   │             └─── Check filter
│                   │                 └─── _buildSearchCard()
│                   │
│                   └─── Vehicle Card
│                        ├─── Image (Car/Bike)
│                        ├─── Vehicle Number
│                        ├─── Status Badge
│                        ├─── Car/Bike Type & Mobile
│                        ├─── Service Button → Push to ServiceForm1/2
│                        └─── History Button → Push to HistoryBike/Car

_showFilterDialog() (Modal)
│
├─── Title: "Filter by Date"
│
├─── "Due Service" Section
│    ├─── Due Today
│    ├─── Due Yesterday
│    ├─── Due Last 7 Days
│    └─── Due Last 30 Days
│
├─── "Upcoming Services" Section
│    ├─── Next 7 Days
│    └─── Next 30 Days
│
├─── "Service Completed" Section
│    ├─── Completed Yesterday
│    ├─── Completed Last 7 Days
│    └─── Completed Last 30 Days
│
└─── Close Button
```

---

## 5. PERFORMANCE CONSIDERATIONS

### 5.1 Current Implementation (Firebase)

**Strengths:**
- Real-time updates via StreamBuilder
- Automatic query caching
- Built-in scalability

**Bottlenecks:**
- Client-side filtering (searches all vehicles)
- Multiple concurrent queries for service records
- No server-side pagination filtering

**Optimization Tips:**
```dart
// 1. Use composite queries (if Firebase allows)
// 2. Cache results locally using Hive/SQLite
// 3. Implement request coalescing
// 4. Use takeUntil() to cancel subscriptions properly
```

### 5.2 PostgreSQL Implementation

**Recommended Optimizations:**

1. **Server-Side Search:**
```sql
-- Execute search on database, not client
SELECT * FROM vechile_details
WHERE LOWER(vechile_no) LIKE LOWER('%' || $1 || '%')
   OR LOWER(mobile) LIKE LOWER('%' || $1 || '%')
LIMIT $2 OFFSET $3;
```

2. **Service Status Pre-calculation:**
```sql
-- Add computed column or materialized view
SELECT vd.*,
       gs.service_status,
       gs.latest_service_date
FROM vechile_details vd
LEFT JOIN get_service_status(vd.vechile_no, vd.car_bike) gs
```

3. **Connection Pooling:**
```python
# In API server
from psycopg2 import pool

connection_pool = psycopg2.pool.SimpleConnectionPool(
    1, 20,  # min, max connections
    host="localhost",
    postgres="5432",
    database="autolab",
    user="user",
    password="password"
)
```

4. **Caching Strategy:**
```dart
// In Flutter app
// Cache vehicle list for 5 minutes
if (DateTime.now().difference(lastFetchTime) > Duration(minutes: 5)) {
    fetchVehicles();
} else {
    loadFromCache();
}
```

5. **Pagination Limits:**
```
- Page load: 20-30 items per page
- Infinite scroll: +20 items per scroll
- Max items in memory: 500
```

---

## 6. ERROR HANDLING FLOW

### 6.1 Firebase (Current)

```
StreamBuilder Error Handling:
━━━━━━━━━━━━━━━━━━━━━━━━━━
Query Fails
  └─→ StreamBuilder.connectionState = ConnectionState.waiting
  └─→ Show loading indicator
  
Data Fetch Error
  └─→ snapshot.hasError = true
  └─→ Show error message: "Unable to load vehicles"
  └─→ Provide retry button

No Data
  └─→ snapshot.hasData = false BUT no error
  └─→ Show empty state: "No vehicles found"
```

### 6.2 PostgreSQL (Required Implementation)

```
HTTP Error Handling:
━━━━━━━━━━━━━━━━━
Status Code: 400 (Bad Request)
  └─→ Show: "Invalid search parameters"
  └─→ Action: Clear search and retry

Status Code: 401 (Unauthorized)
  └─→ Show: "Authentication required"
  └─→ Action: Redirect to login

Status Code: 429 (Too Many Requests)
  └─→ Show: "Too many requests, please wait"
  └─→ Action: Exponential backoff retry

Status Code: 500 (Server Error)
  └─→ Show: "Server error, please try again"
  └─→ Action: Retry after 5 seconds

Network Error
  └─→ Show: "No internet connection"
  └─→ Action: Check connectivity and retry

Timeout Error
  └─→ Show: "Request took too long"
  └─→ Action: Manual retry or cancel
```

---

## 7. TESTING STRATEGY

### 7.1 Unit Tests

```dart
// Test service status calculation
test('Service status due when within 30 days', () {
    final dates = [
        DateTime.now().subtract(Duration(days: 15))
    ];
    final status = searchState._getServiceStatusFromDates(dates);
    expect(status, equals('due'));
});

test('Service status upcoming when future date', () {
    final dates = [
        DateTime.now().add(Duration(days: 15))
    ];
    final status = searchState._getServiceStatusFromDates(dates);
    expect(status, equals('upcoming'));
});

test('Service status completed when > 30 days ago', () {
    final dates = [
        DateTime.now().subtract(Duration(days: 60))
    ];
    final status = searchState._getServiceStatusFromDates(dates);
    expect(status, equals('completed'));
});

// Test search filter
test('Search matches vehicle number', () {
    final record = createMockVehicle(
        vechileNo: 'MH02AB1234',
        mobile: '9876543210'
    );
    final matchesQuery = 'MH02AB'.isEmpty ||
        record.vechileNo.toLowerCase().contains('MH02AB'.toLowerCase());
    expect(matchesQuery, isTrue);
});

// Test service filter
test('Service filter matches selected status', () {
    final filter = 'due';
    final matches = filter == null ? true : 'due' == filter;
    expect(matches, isTrue);
});
```

### 7.2 Widget Tests

```dart
testWidgets('Search field updates results', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    
    // Find search field
    final searchField = find.byType(TextFormField);
    
    // Type search query
    await tester.enterText(searchField, 'MH02AB');
    await tester.pumpAndSettle(Duration(milliseconds: 400));
    
    // Verify results updated
    expect(find.text('MH02AB1234'), findsOneWidget);
});

testWidgets('Filter chips toggle state', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    
    final dueChip = find.text('Due Services');
    await tester.tap(dueChip);
    await tester.pumpAndSettle();
    
    // Verify chip is selected
    expect(find.byType(FilterChip), findsWidgets);
});

testWidgets('Service button navigates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    
    final serviceButton = find.text('Service').first;
    await tester.tap(serviceButton);
    await tester.pumpAndSettle();
    
    // Verify navigation
    expect(find.byType(ServiceForm1Widget), findsOneWidget);
});
```

### 7.3 Integration Tests

```dart
testWidgets('Complete user flow', (WidgetTester tester) async {
    // 1. Load search page
    // 2. Search for vehicle
    // 3. Filter by service status
    // 4. Click service button
    // 5. Fill form
    // 6. Navigate back
    // 7. Verify updated status
});
```

---

## 8. POSTGRESQL MIGRATION CHECKLIST

- [ ] Database setup complete
- [ ] Tables created with proper indexes
- [ ] Foreign key relationships verified
- [ ] Sample data inserted for testing
- [ ] API endpoints developed and tested
- [ ] Search implementation verified
- [ ] Pagination working correctly
- [ ] Service status calculation correct
- [ ] Error handling comprehensive
- [ ] Performance benchmarks met
- [ ] Flutter app updated to use API
- [ ] Data models updated
- [ ] Navigation logic unchanged
- [ ] UI/UX remains identical
- [ ] All features working end-to-end
- [ ] Load testing completed
- [ ] Security review completed

---

## GLOSSARY

- **VechileDetailsRecord:** Main vehicle record with ownership details
- **CarServiceRecord:** Service history for cars
- **BikeServiceRecord:** Service history for bikes
- **Service Status:** Calculated state (due, upcoming, completed)
- **Debounce:** Delay before action (350ms used here)
- **StreamBuilder:** Firebase real-time listener
- **PagedListView:** Infinite scroll list widget
- **PagingController:** Manages pagination state


# 🗄️ DATABASE COMPATIBILITY - UI Layer Integration

**Purpose:** Ensure new DB & APIs work seamlessly with existing UI  
**Status:** ✅ Ready to implement  
**Time:** 2-3 hours  

---

## 🎯 WHAT YOU'RE CHECKING

Your existing Flutter UI has:
- ✅ Data fetch logic
- ✅ Filter functionality
- ✅ Search capabilities
- ✅ Sort options
- ✅ Pagination
- ✅ UI components

**We need to verify:** New database & APIs work with ALL of these

---

## 📋 EXISTING UI FEATURES - CHECKLIST

### **Section 1: Data Display Components**

```
☐ Home screen data fetch
   Location: lib/pages/home_page.dart
   Currently fetches: ___________________________
   Expected fields: ____________________________

☐ Service list display
   Location: lib/pages/service_list.dart (or similar)
   Show: Service name, price, duration, rating
   Fields needed: ______________________________

☐ Booking history
   Location: lib/pages/history_*.dart
   Show: Booking date, service, status
   Fields needed: ______________________________

☐ Service center list
   Location: lib/pages/service_center.dart
   Show: Name, location, rating, distance
   Fields needed: ______________________________

☐ Vehicle details
   Location: lib/pages/vehicle_details.dart
   Show: Model, year, reg number, services
   Fields needed: ______________________________

☐ Profile page
   Location: lib/pages/profile.dart
   Show: User info, bookings, vehicles
   Fields needed: ______________________________
```

### **Section 2: Filter Features**

```
☐ Filter by service type
   Current filter logic: ________________________
   UI component: _______________________________
   API call: ___________________________________

☐ Filter by location
   Current filter logic: ________________________
   UI component: _______________________________
   API call: ___________________________________

☐ Filter by price range
   Current filter logic: ________________________
   UI component: _______________________________
   API call: ___________________________________

☐ Filter by rating
   Current filter logic: ________________________
   UI component: _______________________________
   API call: ___________________________________

☐ Filter by distance
   Current filter logic: ________________________
   UI component: _______________________________
   API call: ___________________________________

☐ Any custom filters
   Current filter logic: ________________________
   UI component: _______________________________
   API call: ___________________________________
```

### **Section 3: Search Features**

```
☐ Search by service name
   Current implementation: ______________________
   Required fields: ____________________________
   Minimum characters: __________________________

☐ Search by service center
   Current implementation: ______________________
   Required fields: ____________________________

☐ Search by vehicle type
   Current implementation: ______________________
   Required fields: ____________________________

☐ Autocomplete in search
   Currently enabled: (Y/N)
   Data source: ________________________________

☐ Search filters combined
   Can filter + search together: (Y/N)
   Current logic: _______________________________
```

### **Section 4: Sorting Features**

```
☐ Sort by price (ascending/descending)
   UI: Sort button at location: ________________
   Required fields: ____________________________

☐ Sort by rating (high to low)
   UI: Sort button at location: ________________
   Required fields: ____________________________

☐ Sort by distance (closest first)
   UI: Sort button at location: ________________
   Required fields: ____________________________

☐ Sort by date (newest first)
   UI: Sort button at location: ________________
   Required fields: ____________________________

☐ Sort by popularity
   UI: Sort button at location: ________________
   Required fields: ____________________________
```

### **Section 5: Pagination & Lazy Loading**

```
☐ List pagination
   Items per page: ______________________________
   Pagination type: ____________________________
   (Offset/Limit OR Cursor-based)

☐ Load more button
   Currently used: (Y/N)
   Where: ______________________________________

☐ Infinite scroll
   Currently used: (Y/N)
   Where: ______________________________________

☐ Page size configurable: (Y/N)
```

---

## 🔄 NEW API STRUCTURE - COMPATIBILITY MAPPING

### **Check: All Required Endpoints Exist**

#### **Home Screen Data**

**Current:**
```dart
// What current API returns
GET /api/services
GET /api/nearby-centers?lat=X&lng=Y
GET /api/user/upcoming-bookings
```

**New API Must Have:**
```bash
GET /api/services                     ☐ Exists
GET /api/services?limit=10&offset=0   ☐ Pagination
GET /api/services?search=query        ☐ Search
GET /api/services?sort=price          ☐ Sort
GET /api/services?filter=type&value=X ☐ Filter

GET /api/service-centers              ☐ Exists
GET /api/service-centers?lat=X&lng=Y&radius=5km ☐ Geo query

GET /api/users/{id}/bookings          ☐ Exists
GET /api/users/{id}/bookings?status=upcoming ☐ Filter
```

#### **Service List**

**Required Fields:**
```json
{
  "id": "service_123",
  "name": "Oil Change",
  "price": 500,
  "duration": 30,
  "category": "maintenance",
  "rating": 4.5,
  "reviews_count": 125,
  "estimated_time": 30,
  "description": "...",
  "image_url": "...",
  // MUST HAVE for UI:
  "discounted_price": 400,  // ☐ Check if used
  "is_popular": true,       // ☐ Check if used
  "is_trending": false      // ☐ Check if used
}
```

**Verify in new API:**
```
☐ id - service identifier
☐ name - display name
☐ price - base price
☐ duration - service duration in minutes
☐ category - service type
☐ rating - average rating
☐ reviews_count - number of reviews
☐ estimated_time - how long it takes
☐ description - service details
☐ image_url - service image

Optional but check if UI uses:
☐ discounted_price
☐ is_popular
☐ is_trending
☐ tags/keywords for search
☐ availability status
```

#### **Service Centers**

**Required Fields:**
```json
{
  "id": "center_456",
  "name": "AutoLab Service Center",
  "location": {
    "latitude": 19.0760,
    "longitude": 72.8777,
    "address": "..."
  },
  "rating": 4.8,
  "distance": 2.5,  // in km
  "services_count": 15,
  "opening_hours": "9 AM - 6 PM",
  // MUST HAVE for UI:
  "phone": "+91...",      // ☐ Check if used
  "image_url": "...",     // ☐ Check if used
  "is_verified": true,    // ☐ Check if used
  "specialties": ["..."], // ☐ Check if used
  "reviews": [...]        // ☐ Check if used
}
```

**Verify in new API:**
```
☐ id - center identifier
☐ name - center name
☐ latitude - for map display
☐ longitude - for map display
☐ address - full address
☐ rating - average rating
☐ distance - calculated distance
☐ services_count - how many services
☐ opening_hours - business hours
☐ phone - contact number
☐ image_url - center image

Check if UI uses these:
☐ is_verified badge
☐ specialties list
☐ reviews section
☐ working hours today
☐ availability
```

#### **Bookings**

**Required Fields:**
```json
{
  "id": "booking_789",
  "service": { /*service object*/ },
  "service_center": { /*center object*/ },
  "vehicle": { /*vehicle object*/ },
  "booking_date": "2024-01-15",
  "booking_time": "10:00 AM",
  "status": "confirmed", // upcoming, completed, cancelled
  "total_price": 500,
  "estimated_duration": 30,
  // MUST HAVE for UI:
  "confirmation_number": "...", // ☐ Check
  "technician_name": "...",     // ☐ Check
  "notes": "...",               // ☐ Check
  "can_cancel": true            // ☐ Check
}
```

**Verify in new API:**
```
☐ id - booking identifier
☐ service - full service details
☐ service_center - full center details
☐ vehicle - vehicle being serviced
☐ booking_date - appointment date
☐ booking_time - appointment time
☐ status - booking status
☐ total_price - final price
☐ estimated_duration - service duration

Check if UI uses:
☐ confirmation_number
☐ technician_name
☐ special_notes
☐ can_cancel (boolean for cancel button)
☐ can_reschedule
☐ rating_given
☐ review_text
```

---

## 🔍 FILTER QUERIES - COMPATIBILITY CHECK

### **Price Filter**

**Current UI implementation:**
```dart
// Example from existing code
List<Service> filteredServices = services
  .where((s) => s.price >= minPrice && s.price <= maxPrice)
  .toList();
```

**New API must support:**
```
GET /api/services?min_price=100&max_price=500  ☐ Works
GET /api/services?price_range=100-500          ☐ Alternative
GET /api/services?price_gte=100&price_lte=500  ☐ Alternative
```

**Verify API response includes price field:**
```
☐ price (base price)
☐ discount_percentage (if applicable)
☐ discounted_price (calculated)
☐ tax (if applicable)
☐ final_price (total)
```

### **Location/Distance Filter**

**Current implementation (if using):**
```dart
double distanceInKm = calculateDistance(
  lat1, lng1,  // user location
  lat2, lng2   // service center
);

bool isWithinRadius = distanceInKm <= selectedRadius;
```

**New API must support:**
```
// Option 1: Backend calculates distance
GET /api/service-centers?latitude=19&longitude=72&radius=5  ☐ Works

// Option 2: Frontend filters
GET /api/service-centers?latitude=19&longitude=72           ☐ Works
// (Frontend calculates distance)
```

**Verify API response:**
```
☐ latitude/longitude for each center
☐ address (for display)
☐ distance (if backend calculates) OR
☐ Can be calculated by frontend from coords
```

### **Category/Type Filter**

**Current UI:**
```dart
// Example filter
List<Service> filtered = services
  .where((s) => selectedCategories.contains(s.category))
  .toList();
```

**New API must support:**
```
GET /api/services?category=maintenance                     ☐ Works
GET /api/services?category=maintenance,repair              ☐ Multiple
GET /api/services?type=car_service                         ☐ Alternative
```

**Verify API has categories:**
```
☐ service.category field exists
☐ All categories from UI covered in API
☐ Category values match between UI & API

Current categories in UI:
- Maintenance ☐
- Repair ☐
- Inspection ☐
- Customization ☐
- Emergency ☐
- Other: _________________ ☐
```

### **Rating Filter**

**Current UI:**
```dart
List<Service> filtered = services
  .where((s) => s.rating >= selectedMinRating)
  .toList();
```

**New API must support:**
```
GET /api/services?min_rating=4.0                           ☐ Works
GET /api/services?rating_gte=4.0                           ☐ Alternative
```

**Verify API has rating:**
```
☐ rating (average 0-5)
☐ reviews_count (number of reviews)
☐ Can sort by rating
```

---

## 🔎 SEARCH FUNCTIONALITY - COMPATIBILITY CHECK

### **Search Implementation**

**Current search in UI:**
```dart
// Example from existing code
TextEditingController searchController = TextEditingController();

List<Service> searchResults = services
  .where((s) => s.name.toLowerCase().contains(searchController.text.toLowerCase()))
  .toList();
```

**New API must support:**
```
GET /api/services?search=oil%20change              ☐ Works
GET /api/services?q=oil%20change                   ☐ Alternative
GET /api/services?query=oil%20change               ☐ Alternative
```

### **What Gets Searched**

**Current UI searches for:**
```
Service name        ☐ Check: API searches service.name
Service description ☐ Check: API searches service.description
Service category    ☐ Check: API searches service.category

Service centers:
Center name         ☐ Check: API searches center.name
Location/address    ☐ Check: API searches center.address

Vehicles:
Vehicle model       ☐ Check: API searches vehicle.model
Vehicle number      ☐ Check: API searches vehicle.registration_number
```

### **Search Performance**

```
☐ API returns results quickly (< 500ms)
☐ Pagination works with search
☐ Filters work with search (combined queries)
☐ Sort works with search results
```

**Verify API supports combined queries:**
```
GET /api/services?search=oil&category=maintenance&min_price=200&sort=price ☐
```

---

## 📊 SORTING - COMPATIBILITY CHECK

### **Current Sorting Options in UI**

```
Sorting by:
☐ Price (low to high, high to low)
   API param needed: sort=price&order=asc|desc

☐ Rating (high to low)
   API param needed: sort=rating&order=desc

☐ Distance (closest first)
   API param needed: sort=distance&order=asc
   Requires: latitude, longitude params

☐ Date added (newest first)
   API param needed: sort=created_at&order=desc

☐ Popularity (most booked)
   API param needed: sort=popularity&order=desc

☐ Duration (shortest first)
   API param needed: sort=duration&order=asc
```

**Verify new API supports all:**
```
GET /api/services?sort=price&order=asc     ☐ Works
GET /api/services?sort=rating&order=desc   ☐ Works
GET /api/services?sort=distance&order=asc  ☐ Works (with lat/lng)
```

---

## 📄 PAGINATION - COMPATIBILITY CHECK

### **Current Pagination**

```
Approach used:
☐ Offset/Limit pagination
   GET /api/services?limit=10&offset=0    ☐ Check

☐ Page number pagination
   GET /api/services?page=1&page_size=10  ☐ Check

☐ Cursor-based pagination
   GET /api/services?cursor=abc123&limit=10 ☐ Check

Items per page: ________________________
```

**Verify API response format:**

If Offset/Limit:
```json
{
  "data": [...],
  "limit": 10,
  "offset": 0,
  "total": 150,
  "has_more": true
}
```

If Cursor-based:
```json
{
  "data": [...],
  "cursor": "next_cursor_token",
  "has_more": true
}
```

---

## 🎨 UI LAYOUT - REQUIRED FIELDS MAPPING

### **Home Screen Layout**

Current layout shows:
```
Card 1: Featured Service
  - Image          ☐ image_url
  - Name           ☐ name
  - Price          ☐ price
  - Rating         ☐ rating
  - Booking count  ☐ reviews_count

Card 2: Nearby Centers
  - Name           ☐ name
  - Distance       ☐ calculated from lat/lng
  - Rating         ☐ rating
  - Services count ☐ services_count

Card 3: Your Vehicles
  - Image          ☐ image_url
  - Model          ☐ model
  - Year           ☐ year
  - Services       ☐ services_count

Section 4: Recent Bookings
  - Service name   ☐ booking.service.name
  - Date/time      ☐ booking.booking_date, booking_time
  - Status         ☐ booking.status
  - Center name    ☐ booking.service_center.name
```

**Verify all these fields exist in new API responses:**

```
Services endpoint response:
☐ id, name, price, image_url, rating, reviews_count
☐ category, description, duration, estimated_time

Service centers endpoint response:
☐ id, name, latitude, longitude, rating, distance
☐ phone, address, services_count, image_url

Vehicles endpoint response:
☐ id, model, year, image_url, registration_number
☐ services_count, last_service_date

Bookings endpoint response:
☐ id, service (nested object), service_center (nested object)
☐ booking_date, booking_time, status, total_price
```

---

## ✅ COMPATIBILITY VERIFICATION CHECKLIST

### **Data Fetch**
- [ ] Home screen data loads without errors
- [ ] All required fields present in API response
- [ ] No missing or unexpected field names
- [ ] Data types match UI expectations (string, number, date)
- [ ] Images load correctly from image URLs
- [ ] Nested objects (service in booking) work correctly

### **Filtering**
- [ ] Price filter works correctly
- [ ] Category filter works correctly
- [ ] Location/distance filter works (if used)
- [ ] Rating filter works (if used)
- [ ] Multiple filters can be combined
- [ ] Filter values match UI options

### **Search**
- [ ] Search returns correct results
- [ ] Search is case-insensitive
- [ ] Partial matches work
- [ ] Search combined with filters works
- [ ] Search returns empty state correctly

### **Sorting**
- [ ] Sorting by price works
- [ ] Sorting by rating works
- [ ] Sorting by distance works
- [ ] Sorting by date works
- [ ] Default sort order is correct

### **Pagination**
- [ ] First page loads correctly
- [ ] Page navigation works
- [ ] Load more button works
- [ ] Infinite scroll works (if used)
- [ ] Total count is correct

### **Performance**
- [ ] API responses in < 1 second
- [ ] No timeout errors
- [ ] Images load smoothly
- [ ] Scrolling is smooth
- [ ] No memory leaks

---

## 🔧 COMMON ISSUES & SOLUTIONS

### **Issue: Fields Don't Match**

**Problem:** UI expects `service.image` but API returns `service.image_url`

**Solution:**
```dart
// In data model mapper
final imageUrl = service['image_url'] ?? service['image'];
```

OR update API to match UI expectations.

### **Issue: Filter Values Don't Match**

**Problem:** UI sends `category=maintenance` but API expects `type=car_service`

**Solution:** Check API documentation and update UI filter values to match.

### **Issue: Pagination Format Different**

**Problem:** UI expects `limit/offset` but API uses `page/page_size`

**Solution:** Update API client to convert between formats:
```dart
final offset = (page - 1) * pageSize;
final limit = pageSize;
// Use offset & limit in API call
```

### **Issue: Sorting Parameter Different**

**Problem:** UI sends `sort=price` but API expects `order_by=price`

**Solution:** Update API client parameter names.

---

## 📋 FINAL COMPATIBILITY REPORT

Create a summary:

```
UI Feature                API Support    Status    Notes
─────────────────────────────────────────────────────────
Service list fetch        ✅/❌/⚠️       OK/ISSUE
Service detail fetch      ✅/❌/⚠️       OK/ISSUE
Service center list       ✅/❌/⚠️       OK/ISSUE
Booking list fetch        ✅/❌/⚠️       OK/ISSUE
User profile fetch        ✅/❌/⚠️       OK/ISSUE
─────────────────────────────────────────────────────────
Filter by price           ✅/❌/⚠️       OK/ISSUE
Filter by location        ✅/❌/⚠️       OK/ISSUE
Filter by category        ✅/❌/⚠️       OK/ISSUE
─────────────────────────────────────────────────────────
Search functionality      ✅/❌/⚠️       OK/ISSUE
─────────────────────────────────────────────────────────
Sort by price             ✅/❌/⚠️       OK/ISSUE
Sort by rating            ✅/❌/⚠️       OK/ISSUE
Sort by distance          ✅/❌/⚠️       OK/ISSUE
─────────────────────────────────────────────────────────
Pagination/Load more      ✅/❌/⚠️       OK/ISSUE
```

---

**Status:** ✅ Ready to verify compatibility  
**Time:** 2-3 hours  

---

**→ Next:** Update 06_FLUTTER_FRONTEND.md with required API calls based on this checklist

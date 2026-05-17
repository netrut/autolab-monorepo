# 📱 Customer App — Screens Documentation

---

## 1. Auth Screens

### 1.1 Login Screen
- Phone number / email input
- Password field
- "Forgot Password" link
- "Register" link
- OTP login option

### 1.2 Register Screen
- Full name
- Phone number
- Email
- Password + confirm
- Terms & conditions checkbox

### 1.3 OTP Screen
- 6-digit OTP input
- Resend timer
- Verify button

### 1.4 Forgot Password Screen
- Email/phone input
- Send reset link/OTP

---

## 2. Home Screen (Main Dashboard)

> See [HOME_DESIGN.md](./HOME_DESIGN.md) for detailed UI/UX spec

### Sections:
1. **Greeting + Avatar** — "Hello, {name}" with profile pic
2. **Quick Actions Row** — My Vehicles, Book Service, Service History, Invoices
3. **Vehicle Summary Card** — Active vehicle with next service due date, km reading
4. **Upcoming Services** — List of due/upcoming services with countdown
5. **Recent Activity** — Last 3 service records (date, centre name, cost)
6. **Nearby Service Centres** — Horizontal scroll cards (name, rating, distance)
7. **Notifications Badge** — Unread count on bell icon in AppBar

---

## 3. My Vehicles Screen

### 3.1 Vehicles List
- Card per vehicle: brand, model, reg number, type icon (car/bike)
- Tap → Vehicle Detail
- FAB → Add Vehicle
- Swipe to delete (with confirmation)

### 3.2 Add/Edit Vehicle Screen
- Vehicle type toggle (Car / Bike)
- Brand (dropdown/search)
- Model
- Year
- Registration number
- Color
- Fuel type
- Transmission
- Mileage (km)
- Chassis number (optional)
- Notes

### 3.3 Vehicle Detail Screen
- Vehicle info card
- Service history timeline for this vehicle
- Shared users list (family/friends with access)
- "Share Vehicle" button → sends request
- Next service due alert

---

## 4. Bookings Screen

### 4.1 Bookings List
- Tabs: Upcoming | Completed | Cancelled
- Card: vehicle name, service centre, date, status badge
- Tap → Booking Detail

### 4.2 Create Booking Screen
- Select vehicle (from my vehicles)
- Select/search service centre
- Service type (dropdown: General, Oil Change, Major Service, etc.)
- Preferred date & time picker
- Notes field
- Submit button

### 4.3 Booking Detail Screen
- Full booking info
- Status timeline (pending → confirmed → in-progress → completed)
- Service centre contact info
- Cancel button (if pending)

---

## 5. Service History Screen

### 5.1 Service History List
- Grouped by vehicle
- Each entry: date, service type, centre name, total cost
- Filter by vehicle / date range
- Tap → Service Detail

### 5.2 Service Detail Screen (View Only)
- Service date, odometer reading
- Service type badge
- Items list (item name, status, cost, notes)
- Labour cost + total cost
- Next service date
- Service centre info
- "View Invoice" button (if invoice exists)

---

## 6. Invoices Screen

### 6.1 Invoices List
- All invoices received from service centres
- Card: invoice #, date, vehicle, total amount
- Filter by vehicle / date
- Tap → Invoice Detail

### 6.2 Invoice Detail Screen (View Only)
- Invoice header (centre name, logo, address)
- Vehicle info
- Line items table
- Labour + total
- Footer/terms
- "Download PDF" button
- "Share" button

---

## 7. Search / Discover Service Centres

### 7.1 Search Screen
- Search bar (by name, city, pincode)
- Filter chips: vehicle type, service type, rating
- Results list: centre cards with name, rating, address, distance
- Tap → Centre Detail

### 7.2 Service Centre Detail Screen
- Name, description, rating
- Address + maps link
- Phone, email, WhatsApp
- Working hours
- Vehicle types serviced
- Service types offered
- Brands serviced
- "Book Service" CTA button
- Reviews (future scope)

---

## 8. Requests Screen

### 8.1 Requests List
- Tabs: Received | Sent
- **Received:** vehicle access requests from family/friends
- **Sent:** requests you sent to access others' vehicles
- Each card: requester name, vehicle/entity, status, date
- Actions: Accept / Reject (for received), Cancel (for sent)

---

## 9. Notifications Screen

- List of all notifications (newest first)
- Types: service_due, booking_update, request, invoice, system
- Unread highlighted
- Tap → navigate to relevant screen
- "Mark all read" button

---

## 10. Profile Screen

- Avatar (editable)
- Display name
- Phone number
- Email
- Address
- Bio
- Edit button → inline edit mode
- "Change Password" link
- "Delete Account" (danger zone)

---

## 11. Settings Screen

- **Notification Preferences:**
  - Service reminders ON/OFF
  - Booking updates ON/OFF
  - Parts expiry alerts ON/OFF
  - Join requests ON/OFF
  - Reminder days before (slider: 3/5/7/14)
- **App Preferences:**
  - Default vehicle type (Car/Bike)
  - Dark mode toggle (future)
- **Account:**
  - Logout button
  - Delete account

---

## 12. Vehicle Share / Family Access

- From Vehicle Detail → "Share Access" button
- Enter phone/email of family member
- Select role: viewer / co-owner
- Sends a `vehicle_access` request
- Recipient sees in Requests → can accept/reject
- Accepted → vehicle appears in their "Shared Vehicles" section

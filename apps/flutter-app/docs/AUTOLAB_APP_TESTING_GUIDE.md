# AutoLab App — Complete Testing Guide
### For Non-Technical Testers | Test Sequence: Start to End

---

> **Before you start:**
> - App must be running on your device or browser
> - You need 2 test accounts (User A = Owner/Admin, User B = Mechanic/Staff)
> - Internet connection required
> - Use the Ports tab → port 8080 to open the app

---

## SECTION 1 — SIGN UP & ONBOARDING

### Test 1.1 — New User Registration
1. Open the app → you should see the **Login** screen
2. Tap **Sign Up** at the bottom
3. Fill in:
   - Full Name: `Test Owner`
   - Email: `testowner@autolab.com`
   - Phone: `9876543210`
   - Password: `Test@1234`
4. Tap **Create Account**
5. ✅ **Expected:** A message appears saying "Account created! Set up your service centre."
6. ✅ **Expected:** App automatically opens the **Service Centre Onboarding** screen (Register or Join)

---

### Test 1.2 — Service Centre Onboarding Gateway
1. You should see two options: **Register New Service Centre** and **Join an Existing Centre**
2. Check that both cards show:
   - An icon, a badge (REGISTER / JOIN), a title, a description
   - A list of 4 feature points with checkmarks
   - A button at the bottom
3. Read the help note at the bottom — it should explain which option to choose
4. ✅ **Expected:** Both cards are visible and readable

---

### Test 1.3 — Register New Service Centre (Step 1 — Basic Info)
1. Tap **Register My Centre**
2. You should see a 5-step form with a progress bar at the top
3. Step 1 — Basic Info:
   - Select category: tap **Service Centre**
   - Business Name: `Friends Auto Garage`
   - Phone: `9876543210`
   - Email: `garage@test.com`
   - Description: `Best garage in town`
4. Notice the blue info box: "Steps 2–5 are optional"
5. Tap **Continue**
6. ✅ **Expected:** Moves to Step 2 (Location)

---

### Test 1.4 — Register New Service Centre (Steps 2–5, Skip)
1. **Step 2 — Location:** Fill Address, City = `Jaipur`, State = `Rajasthan`, Pincode = `302001` → tap **Save & Continue**
2. **Step 3 — Services:** Select `Car` and `Bike` vehicle types → select `General Service` and `Major Service` → tap **Save & Continue**
3. **Step 4 — Business Details:** Enter GST = `27AAPFU0939F1ZV` → tap **Save & Continue**
4. **Step 5 — Owner Details:** Enter Owner Name = `Test Owner`, Phone = `9876543210`, Designation = `Owner` → tap **Submit for Review**
5. ✅ **Expected:** A success popup appears: "Submitted!" with a green checkmark
6. Tap **Done**
7. ✅ **Expected:** Returns to previous screen

---

## SECTION 2 — LOGIN & SESSION

### Test 2.1 — Login with Email
1. Open the app (or logout if already logged in)
2. Enter email and password from Test 1.1
3. Tap **Login with Email**
4. ✅ **Expected:** App checks for service centre and goes to **Home Screen**
5. ✅ **Expected:** The side drawer top shows your service centre name (not "AUTOLAB")

---

### Test 2.2 — Login with No Service Centre (New User)
1. Create a brand new account with a different email
2. After registration → ✅ **Expected:** Redirected to Service Centre Onboarding
3. Tap **Find & Join a Centre** instead
4. ✅ **Expected:** A search sheet opens showing available service centres

---

### Test 2.3 — Login with Multiple Service Centres
> *(Skip if you only have one service centre)*
1. If your account is linked to 2+ service centres, login
2. ✅ **Expected:** A "Select Active Centre" sheet appears automatically
3. The sheet lists all your centres with name, role, city
4. Tap one centre → tap **Continue with [name]**
5. ✅ **Expected:** Goes to Home Screen with that centre active

---

## SECTION 3 — HOME SCREEN

### Test 3.1 — Home Screen Layout
1. After login, check the Home Screen:
   - ✅ Greeting: "Hello, [Your Name]"
   - ✅ Hero banner with car image
   - ✅ "Due Services" card — shows real count (or "All up to date")
   - ✅ "Next Service" card — shows a date or "Not scheduled"
   - ✅ "My Bookings" and "Service Centers" cards
   - ✅ "Service Update" section with vehicle name and service items
   - ✅ "Add New Vehicle" section with Car and Bike buttons
   - ✅ "Contact Us" section with Call Now button
   - ✅ Bell icon in top-right corner

---

### Test 3.2 — Notification Bell
1. Tap the **bell icon** (top right)
2. ✅ **Expected:** Opens Notifications screen
3. If no notifications: shows "No notifications yet" with a bell icon
4. Go back to Home

---

### Test 3.3 — Contact Us Button
1. Scroll to bottom → tap **Call Now**
2. ✅ **Expected:** Opens WhatsApp or phone dialer with the helpline number

---

## SECTION 4 — SIDE DRAWER

### Test 4.1 — Open Drawer
1. Tap the **hamburger menu** (☰) on any screen that has it (Home, Vehicles, Service)
2. ✅ **Expected:** Drawer slides in from the left

---

### Test 4.2 — Service Centre Switcher (Drawer Header)
1. Look at the top of the drawer
2. ✅ **Expected:** Shows AUTOLAB label (small), your service centre name (bold), your role + city below
3. If you have multiple centres: a **⇅ icon** appears on the right
4. Tap the header (if multiple centres)
5. ✅ **Expected:** "Switch Service Centre" sheet opens with list of your centres
6. Tap a different centre → ✅ **Expected:** Drawer header updates to new centre name

---

### Test 4.3 — Drawer Navigation Links
Test each link in the drawer:
1. **Home** → goes to Home Screen ✅
2. **My Vehicles** → goes to Vehicles Screen ✅
3. **Bookings** → goes to Bookings Screen ✅
4. **Services** → goes to Service Screen *(only visible for Owner/Mechanic roles)* ✅
5. **Service Centers** → goes to Service Centers Screen ✅
6. **Requests** → goes to Requests Screen ✅
7. **Join Service Centre** → opens search sheet *(only visible for Owner/Mechanic roles)* ✅
8. **Profile** → goes to Profile Screen ✅
9. **Logout** → logs out and returns to Login Screen ✅

---

### Test 4.4 — Requests Badge
1. If you have pending requests, the **Requests** item should show a red number badge
2. ✅ **Expected:** Badge shows correct count

---

## SECTION 5 — MY VEHICLES

### Test 5.1 — Vehicles Screen
1. Open **My Vehicles** from drawer or bottom nav
2. ✅ **Expected:** Shows only vehicles linked to your account
3. ✅ **Expected:** Search bar at top, filter icon on right
4. ✅ **Expected:** FAB (+ button) at bottom right

---

### Test 5.2 — Add New Vehicle
1. Tap the **+ FAB** button
2. Select vehicle type: **Car / SUV**
3. In the Registration Number field, type `GJ01AB1234`
4. ✅ **Expected:** A **🔍 search icon** appears in the field
5. Tap the search icon (or tap outside the field)
6. ✅ **Expected:** If new reg → form fields appear below
7. Fill in:
   - Brand: `Maruti` *(dropdown suggestions should appear)*
   - Model: `Swift`
   - Year: `2022`
   - Color: `White`
   - Fuel Type: `Petrol`
   - Transmission: `Manual`
8. Tap **Add Vehicle**
9. ✅ **Expected:** Vehicle appears in the list

---

### Test 5.3 — Add Duplicate Registration Number
1. Tap **+ FAB** again
2. Enter the same reg number `GJ01AB1234`
3. Tap the search icon
4. ✅ **Expected:** Yellow warning banner: "Vehicle Already Registered"
5. ✅ **Expected:** "Send Request to Owner" button appears
6. ✅ **Expected:** Form fields are hidden

---

### Test 5.4 — Add Vehicle from Home Screen
1. Go to Home Screen
2. Tap **+ Add Four-Wheeler**
3. ✅ **Expected:** Add Vehicle form opens with **Car** pre-selected
4. Go back → tap **+ Add Two-Wheeler**
5. ✅ **Expected:** Add Vehicle form opens with **Bike** pre-selected

---

### Test 5.5 — Edit Vehicle
1. On the Vehicles screen, tap the **⋮ (3-dot)** icon on any vehicle card
2. Tap **Edit Vehicle**
3. ✅ **Expected:** Form opens with all existing data pre-filled
4. Change the Color to `Black`
5. Tap **Save Changes**
6. ✅ **Expected:** Vehicle card updates with new color

---

### Test 5.6 — Vehicle Card 3-Dot Menu Order
1. Tap **⋮** on any vehicle card
2. ✅ **Expected:** Options appear in this order:
   1. Book Service (top)
   2. New Service Record
   3. Service History
   4. Edit Vehicle
   5. Remove Vehicle (red)

---

### Test 5.7 — Search & Filter Vehicles
1. Type `GJ01` in the search bar
2. ✅ **Expected:** Only matching vehicles shown
3. Tap the **filter icon** (funnel)
4. Select **Bike** filter → tap outside
5. ✅ **Expected:** Only bikes shown, filter chip appears

---

### Test 5.8 — Pull to Refresh
1. Pull down on the vehicles list
2. ✅ **Expected:** Loading spinner appears, list refreshes

---

## SECTION 6 — BOOKINGS

### Test 6.1 — Create a Booking
1. Go to **My Vehicles** → tap **⋮** on a vehicle → tap **Book Service**
2. ✅ **Expected:** Booking form opens with vehicle **pre-selected** in dropdown
3. ✅ **Expected:** Service Centre is **auto-filled** (shows your centre name with blue check)
4. Select Service Type: **General Service**
5. Tap the date field → pick a date and time
6. Add notes: `Oil change needed`
7. Tap **Confirm Booking**
8. ✅ **Expected:** Returns to Bookings screen, new booking appears

---

### Test 6.2 — Bookings Screen
1. Open **Bookings** from bottom nav
2. ✅ **Expected:** Shows bookings scoped to your service centre
3. Each card shows: vehicle name/reg, service type, date, status badge
4. ✅ **Expected:** Two buttons on each card: **Service Form** and **Update**

---

### Test 6.3 — Update Booking Status
1. Tap **Update** on any booking card
2. ✅ **Expected:** Bottom sheet opens with status chips, service type, date, notes
3. Tap **Confirmed** status chip
4. Tap **Save Changes**
5. ✅ **Expected:** Booking card status badge changes to "CONFIRMED"

---

### Test 6.4 — Go to Service Form from Booking
1. Tap **Service Form** button on a booking card
2. ✅ **Expected:** Opens Service Form for that vehicle

---

## SECTION 7 — SERVICE SCREEN

### Test 7.1 — Service Screen Layout
1. Open **Services** from bottom nav or drawer
2. ✅ **Expected:** Hamburger menu (☰) in top-left to open drawer
3. ✅ **Expected:** Search bar with filter icon
4. ✅ **Expected:** FAB (+) button at bottom right to add new vehicle
5. ✅ **Expected:** Vehicle cards showing only your mapped vehicles

---

### Test 7.2 — Vehicle Card on Service Screen
1. Look at a vehicle card:
   - ✅ Vehicle image (car or bike)
   - ✅ Registration number as title
   - ✅ Sub-line: `Car • Maruti Swi… • Petrol` *(name truncated to 14 chars)*
   - ✅ Status badge: Due / Upcoming / Completed / No Service Yet
2. Tap **⋮** → ✅ **Expected:** Book Service is the FIRST option

---

### Test 7.3 — Filter Sheet
1. Tap the **filter icon** (funnel) in the search bar
2. ✅ **Expected:** Amazon-style filter sheet opens with two columns
3. Left column: Service Status, Vehicle Type, Date Range, Sort By
4. Tap **Service Status** → select **Due** on the right
5. Tap **Vehicle Type** → select **Car**
6. Tap **Apply Filters**
7. ✅ **Expected:** List filtered, filter icon shows a blue badge with count "2"
8. Tap filter icon again → tap **Clear All**
9. ✅ **Expected:** All vehicles shown, badge disappears

---

### Test 7.4 — Add Vehicle from Service Screen
1. Tap the **+ FAB** on Service Screen
2. ✅ **Expected:** Opens Add Vehicle form

---

## SECTION 8 — SERVICE FORM

### Test 8.1 — Open Service Form
1. From Service Screen → tap **⋮** on a vehicle → tap **New Service Record**
2. ✅ **Expected:** Service Form opens
3. Check the header card shows:
   - Vehicle name and type
   - Service centre name (with store icon)
   - Your name (with person icon)

---

### Test 8.2 — Fill Service Form
1. Service Date: today's date (already set)
2. Service Type: **General**
3. Next Service Date: pick a date 3 months from now
4. Odometer: `45000`
5. Tap **+ Add Item**
6. ✅ **Expected:** Item catalogue sheet opens with search and categories
7. Tap **Engine Oil** (or any item)
8. ✅ **Expected:** Item added to the list
9. Tap the item → edit: Status = `Changed`, Cost = `500`
10. Labour cost: type `200`
11. ✅ **Expected:** Total updates automatically (500 + 200 = 700)
12. Notes: `Full service done`

---

### Test 8.3 — Save as Draft
1. Tap **Save Draft**
2. ✅ **Expected:** "Service saved as draft!" message
3. Returns to previous screen

---

### Test 8.4 — Complete Service
1. Open the same vehicle's service form again
2. Fill details → tap **Complete Service**
3. ✅ **Expected:** "Service completed!" message
4. ✅ **Expected:** A notification appears in the bell icon

---

### Test 8.5 — Generate Invoice
1. After completing a service, tap **Generate Invoice**
2. ✅ **Expected:** Invoice screen opens
3. Check invoice shows:
   - Invoice number (INV-2026-XXXX)
   - Vehicle details
   - All service items with status badges
   - Cost breakdown (items + labour + total)
   - Footer text

---

## SECTION 9 — INVOICE

### Test 9.1 — Invoice Screen
1. On the Invoice screen:
   - ✅ AUTOLAB header with service centre name
   - ✅ INVOICE badge with number and date
   - ✅ Vehicle details section
   - ✅ Service items table
   - ✅ Cost summary
   - ✅ Footer text
   - ✅ Download PDF and Share WhatsApp buttons in AppBar and at bottom

---

### Test 9.2 — Share Invoice via WhatsApp
1. Tap **Share WhatsApp** (green button)
2. ✅ **Expected:** WhatsApp opens with a pre-filled message containing invoice details

---

### Test 9.3 — Download PDF
1. Tap **Download PDF**
2. ✅ **Expected:** System print/save dialog opens with formatted invoice

---

### Test 9.4 — Generate Invoice Again (Idempotent)
1. Go back to the service form
2. Tap **Generate Invoice** again
3. ✅ **Expected:** Same invoice opens (not a duplicate)

---

## SECTION 10 — SERVICE HISTORY

### Test 10.1 — View Service History
1. From Vehicles screen → tap **⋮** → tap **Service History**
2. ✅ **Expected:** List of all past service records for that vehicle
3. Tap any record
4. ✅ **Expected:** Service detail screen opens with full details

---

## SECTION 11 — SERVICE CENTRES

### Test 11.1 — My Service Centres Screen
1. Open **Service Centers** from drawer
2. ✅ **Expected:** Shows only YOUR mapped service centres (not all centres)
3. ✅ **Expected:** Active centre has a blue border and green "● Active" badge
4. ✅ **Expected:** Each card shows: name, role chip, category chip, verified badge (if verified), city

---

### Test 11.2 — Service Centre Card Actions
1. On a service centre card, check the 4 action buttons:
   - **Set Active** (blue) — only shown on non-active centres
   - **Share** (grey)
   - **Edit** (amber)
   - **⋯ More** (popup with Invite + Remove)

---

### Test 11.3 — Switch Active Centre
1. If you have 2+ centres, tap **Set Active** on a non-active centre
2. ✅ **Expected:** That centre gets the blue border + "Active" badge
3. ✅ **Expected:** The previously active centre loses its badge
4. Open the drawer → ✅ **Expected:** Drawer header shows the new active centre name

---

### Test 11.4 — Edit Service Centre
1. Tap **Edit** on a service centre card
2. ✅ **Expected:** 5-step form opens with all existing data pre-filled
3. Change the working hours → tap **Save & Continue** through steps
4. ✅ **Expected:** Changes saved

---

### Test 11.5 — Share Service Centre
1. Tap **Share** on a service centre card
2. ✅ **Expected:** Share sheet opens with WhatsApp, Email, Copy options
3. Tap **WhatsApp**
4. ✅ **Expected:** WhatsApp opens with centre details message

---

### Test 11.6 — Add New Centre (FAB)
1. Tap the **Add Centre** FAB button
2. ✅ **Expected:** Service Centre Onboarding Gateway screen opens (Register or Join)

---

## SECTION 12 — REQUESTS

### Test 12.1 — Send Vehicle Access Request
> *(Requires 2 devices/accounts)*
1. On **User B's device**: Add a vehicle with reg `MH01XY9999`
2. On **User A's device**: Go to Add Vehicle → enter `MH01XY9999` → tap search icon
3. ✅ **Expected:** "Vehicle Already Registered" banner appears
4. Tap **Send Request to Owner**
5. ✅ **Expected:** "Request sent to owner!" message

---

### Test 12.2 — Receive and Accept Request
1. On **User B's device**: Open drawer → tap **Requests**
2. ✅ **Expected:** Red badge on Requests item showing count
3. ✅ **Expected:** Received tab shows the request from User A
4. Tap **Accept**
5. ✅ **Expected:** Status changes to "ACCEPTED"
6. On **User A's device**: ✅ **Expected:** Vehicle now appears in their Vehicles list

---

### Test 12.3 — Reject a Request
1. Send another request (repeat 12.1)
2. On User B: tap **Reject**
3. ✅ **Expected:** Status changes to "REJECTED"

---

### Test 12.4 — Cancel a Sent Request
1. On User A: Open Requests → **Sent** tab
2. Find a pending request → tap **Cancel Request**
3. ✅ **Expected:** Status changes to "CANCELLED"

---

### Test 12.5 — Join Service Centre Request
1. Open drawer → tap **Join Service Centre**
2. ✅ **Expected:** Search sheet opens with list of service centres
3. Type a centre name in the search box
4. Tap a centre to select it (blue highlight + check icon)
5. Add a message (optional)
6. Tap **Send Join Request**
7. ✅ **Expected:** "Join request sent!" message

---

## SECTION 13 — NOTIFICATIONS

### Test 13.1 — Notification Bell Badge
1. After any of the above actions (request sent/accepted, booking updated, service completed)
2. ✅ **Expected:** Bell icon on Home Screen shows a red number badge
3. Tap the bell
4. ✅ **Expected:** Notifications screen opens

---

### Test 13.2 — Notification List
1. On Notifications screen:
   - ✅ Unread notifications have blue background tint + blue dot
   - ✅ Read notifications have white background
   - ✅ Each notification shows: icon, title (bold if unread), body, time ago
2. Tap a notification
3. ✅ **Expected:** Marked as read (blue dot disappears) + navigates to relevant screen

---

### Test 13.3 — Mark All Read
1. If there are unread notifications, tap **Mark all read** in the top-right
2. ✅ **Expected:** All blue dots disappear, bell badge clears

---

### Test 13.4 — Pull to Refresh Notifications
1. Pull down on the notifications list
2. ✅ **Expected:** List refreshes

---

### Test 13.5 — Notification Deep Links
Test each notification type navigates correctly:
| Notification Type | Should Navigate To |
|---|---|
| New Access Request | Requests Screen |
| Request Accepted/Rejected | Requests Screen |
| Booking Status Updated | Bookings Screen |
| Service Record Completed | Service Detail Screen |
| Invoice Ready | Invoice Screen |

---

## SECTION 14 — PROFILE

### Test 14.1 — View Profile
1. Open drawer → tap **Profile**
2. ✅ **Expected:** Profile screen shows:
   - Blue gradient header with name and role badge
   - Role badge shows correct label: Admin / Partner / Customer / Mechanic / Driver
   - Contact Information section (phone, email)
   - Account section (role + description)
   - Logout button at bottom

---

### Test 14.2 — Edit Profile
1. Tap the **pencil icon** (✏️) in the top-right of Profile screen
2. ✅ **Expected:** Name and phone fields become editable (blue border)
3. Change name to `Test Owner Updated`
4. Tap **Save** in the top-right
5. ✅ **Expected:** Profile updates, edit mode exits
6. ✅ **Expected:** Home screen greeting updates to new name

---

### Test 14.3 — Cancel Edit
1. Tap pencil icon → make changes → tap **Cancel**
2. ✅ **Expected:** Original values restored, edit mode exits

---

### Test 14.4 — Logout
1. Tap **Logout** button at the bottom of Profile screen
2. ✅ **Expected:** Returns to Login screen
3. ✅ **Expected:** All local data cleared (service_center_id, user_id)

---

## SECTION 15 — ROLE-BASED UI

### Test 15.1 — Admin / Partner / Mechanic Role
1. Login with an account that has role Admin, Partner, or Mechanic
2. Open drawer
3. ✅ **Expected:** "Services" menu item is visible
4. ✅ **Expected:** "Join Service Centre" menu item is visible

---

### Test 15.2 — Customer / Driver Role
1. Login with an account that has role Customer or Driver
2. Open drawer
3. ✅ **Expected:** "Services" menu item is **NOT visible**
4. ✅ **Expected:** "Join Service Centre" menu item is **NOT visible**

---

## SECTION 16 — BOTTOM NAVIGATION

### Test 16.1 — Bottom Nav Tabs
Test each bottom nav tab highlights correctly:
| Tab | Screen | Expected Active Tab |
|---|---|---|
| Home | Home Screen | House icon highlighted |
| Vehicles | My Vehicles | Car icon highlighted |
| Bookings | Bookings | Calendar icon highlighted |
| Services | Service Screen | Wrench icon highlighted |

---

## SECTION 17 — EDGE CASES & ERROR HANDLING

### Test 17.1 — No Internet Connection
1. Turn off internet
2. Open the app
3. ✅ **Expected:** App shows error states with Retry buttons (not blank screens)
4. Turn internet back on → tap Retry
5. ✅ **Expected:** Data loads correctly

---

### Test 17.2 — Empty States
Check these screens when they have no data:
| Screen | Expected Empty State |
|---|---|
| My Vehicles (no vehicles) | "No vehicles added yet" + Add Vehicle button |
| Bookings (no bookings) | "No bookings yet" + Book a Service button |
| Service Screen (no vehicles) | "No vehicles found" message |
| Notifications (none) | "No notifications yet" with bell icon |
| Requests (none) | "No requests received/sent" with inbox icon |

---

### Test 17.3 — Long Vehicle Names
1. Add a vehicle with a very long brand+model name (e.g. `Royal Enfield Classic 350 Gunmetal Grey`)
2. Go to Service Screen
3. ✅ **Expected:** Sub-line shows `Bike • Royal Enfield C… • Petrol` (name truncated at 14 chars)
4. ✅ **Expected:** Vehicle type and fuel type are NOT truncated

---

### Test 17.4 — Pull to Refresh
Test pull-to-refresh works on:
- ✅ My Vehicles screen
- ✅ Bookings screen
- ✅ Service screen
- ✅ Notifications screen
- ✅ Requests screen (Received + Sent tabs)
- ✅ My Service Centres screen

---

## QUICK REFERENCE — PASS/FAIL CHECKLIST

| # | Feature | Pass ✅ | Fail ❌ | Notes |
|---|---|---|---|---|
| 1 | Sign up → redirects to onboarding | | | |
| 2 | Login → service centre auto-set | | | |
| 3 | Login → picker shown for 2+ centres | | | |
| 4 | Home screen shows real data | | | |
| 5 | Bell icon shows unread count | | | |
| 6 | Drawer header shows centre name | | | |
| 7 | Drawer switcher changes active centre | | | |
| 8 | Add vehicle → reg lookup works | | | |
| 9 | Add vehicle → added to vehicle_user_map | | | |
| 10 | Edit vehicle → pre-filled form | | | |
| 11 | Book Service → vehicle pre-selected | | | |
| 12 | Booking form → centre auto-filled | | | |
| 13 | Update booking status works | | | |
| 14 | Service form → centre + user in header | | | |
| 15 | Add service items from catalogue | | | |
| 16 | Generate Invoice → invoice screen | | | |
| 17 | Download PDF works | | | |
| 18 | Share WhatsApp works | | | |
| 19 | Send vehicle access request | | | |
| 20 | Accept request → vehicle appears | | | |
| 21 | Join service centre request | | | |
| 22 | Notifications appear after actions | | | |
| 23 | Notification tap → correct screen | | | |
| 24 | Edit profile → saves correctly | | | |
| 25 | Role-based drawer items | | | |
| 26 | Service screen filter sheet | | | |
| 27 | Vehicle name truncated (14 chars) | | | |
| 28 | Book Service is first in 3-dot menu | | | |
| 29 | Service screen has + FAB | | | |
| 30 | Service screen has drawer (☰) | | | |

---

## REPORTING ISSUES

When you find a bug, note:
1. **Screen name** — which screen were you on?
2. **Steps** — what did you tap/type?
3. **Expected** — what should have happened?
4. **Actual** — what actually happened?
5. **Screenshot** — if possible

---

*AutoLab Testing Guide v1.0 — Generated for complete app testing*

### autolab-monorepo

The app purpose is to provide a centralized digital vehicle service history and reminder system for both customers and service centres.
🧩 PRODUCT PURPOSE

## AUTOLAB is used by:

# Customers

Track vehicle service history

See due & upcoming services

Maintain oil change details, parts replaced, etc.

Receive reminders

Add four-wheeler and two-wheeler

# Service Centres

Search vehicle by number

Update service details

Mark parts replaced

Enter oil & service details

Set next service date

Notify customer

This is a vehicle service record management system.

---

# Use full commands

kill backend command is below

lsof -ti:3002 | xargs kill -9 2>/dev/null;

# Start working

#First start backend
cd apps/backend
npm run start or npm run dev

#Flutter app start app
cd apps/flutter-app
./run.sh

#Flutter customer start app
cd apps/customer_app
./run.sh

```bash

```

# Today changes files check

git diff --name-only HEAD | xargs -I{} stat -c "%y {}" {} | grep "^$(date +%Y-%m-%d)" | awk '{print $NF}'

# Next
push all remaing changes on git main branch
make clone on local mac system
create apk for both apps
apk update on website so anyone can download 
-----

# Note
*Note: do not change anything other then this requirement and do it will minimum code change

========

A Flutter mobile application project for cross-platform development.

## 🚀 Getting Started

This Flutter project has been set up and is ready for development.

### Prerequisites
- Flutter SDK (v3.24.5 or later)
- Dart SDK (v3.5.4 or later)
- Android Studio / VS Code with Flutter extensions

### Running the App

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run on web (currently running):**
   ```bash
   flutter run -d web-server --web-port=8080
   ```
   Access at: http://localhost:8080

3. **Run on other platforms:**
   ```bash
   flutter run    # Auto-detect device
   flutter run -d android    # Android
   flutter run -d ios        # iOS
   ```

#### Step 1: Add adb to PATH (run once per terminal session)
```bash
export PATH="/Users/developer/Library/Android/sdk/platform-tools:$PATH"
```

#### Step 2: Get pairing info from phone
1. Open phone → Settings → Developer options → Wireless debugging
2. Tap "Pair device with pairing code"
3. Note down:
   - **IP address & pairing port** (e.g., 192.168.1.8:34735)
   - **Pairing code** (6-digit code, e.g., 892169)

#### Step 3: Pair the phone (first time or after reboot)
```bash
# Replace IP:PORT and PAIRING_CODE with values from Step 2
adb pair 192.168.1.19:40469
# Enter pairing code when prompted: 892169
```

#### Step 4: Get connection port from phone
1. Go back to "Wireless debugging" main screen (not pairing screen)
2. Note the **IP address & port** shown at top (e.g., 192.168.1.8:45779)
   - ⚠️ This port is DIFFERENT from the pairing port!

#### Step 5: Connect to phone
```bash
# Replace IP:PORT with connection port from Step 4
adb connect 192.168.1.19:45247
```
#### Step 6: Verify connection
```bash
adb devices -l
# Should show: 192.168.1.8:45779    device ...
```

#### Step 7: Verify Flutter sees the device
```bash
flutter devices
# Should list your phone model (e.g., M2003J15SC)
```

#### Step 8: Run the app on phone
```bash
flutter run -d 192.168.1.19:45247
```


# Run in emulator
```bash
flutter run -d emulator-5554
```
adb connect 192.168.43.77:41211
# Capture Logs
```bash
export PATH="/Users/developer/Library/Android/sdk/platform-tools:$PATH" && cd /Users/developer/Documents/GitHub/HFC-App && flutter run -d 192.168.43.77:41211 2>&1 | tee docs/logs/flutter_app_logs_$(date +%Y%m%d_%H%M%S).log
```

# Test production mode logs
```bash
flutter build apk --release
flutter build apk --release --dart-define=API_URL=https://autolab-api.vercel.app
# 📋 WHAT TO COPY FROM CURRENT CODEBASE

**Purpose:** Know exactly what to migrate from your existing AutoLab app  
**Time:** 15-20 minutes to read  
**Next:** 02_GITHUB_SETUP.md

---

## 🎯 Overview

You're creating a FRESH monorepo with:
- ✅ New database (Supabase PostgreSQL)
- ✅ New backend (Express.js)
- ✅ New dashboard (Next.js)
- ⚠️ Reuse UI designs from Flutter app
- ⚠️ Reuse Firebase configuration (initially)
- ⚠️ Reuse Google Play Store setup

**You're NOT copying:**
- ❌ Old Firestore code
- ❌ Old Firebase functions
- ❌ Old navigation structure (rebuilding from scratch)

---

## 📱 FROM FLUTTER APP (`apps/flutter-app/`)

### ✅ COPY THESE FILES

#### 1. **UI Designs & Assets**

**Location in current code:** `assets/`

**Copy to new project:** `apps/flutter-app/assets/`

```
✅ assets/images/        (App logo, icons, backgrounds)
✅ assets/fonts/         (Custom fonts - Lexend Deca)
✅ assets/audios/        (Sound effects if any)
✅ assets/videos/        (Videos if any)
✅ assets/jsons/         (Animations - Rive)
```

**Example:**
```
Current:  autolab-main/assets/images/AutoLabLogo.png
New:      autolab-monorepo/apps/flutter-app/assets/images/AutoLabLogo.png
```

#### 2. **Flutter Dependencies**

**Location in current code:** `pubspec.yaml`

**Key packages to keep:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts:              # For Lexend Deca font
  flutter_localizations:     # For multilingual support
  intl:                      # Date/time formatting
  cached_network_image:      # Image caching
  google_maps_flutter:       # Maps (if using)
  firebase_core:             # Firebase (initially)
  firebase_auth:             # Auth (can migrate later)
  cloud_firestore:           # DB (will replace with HTTP)
  firebase_messaging:        # Push notifications (can migrate)
  http: ^1.1.0              # NEW: For API calls

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner:             # For code generation
```

**Copy:** `pubspec.yaml` as base, then add HTTP client

#### 3. **Code Patterns (Not Files)**

**Location in current code:** `lib/`

**DO copy patterns for:**
- ✅ Authentication flow structure
- ✅ Navigation patterns
- ✅ State management approach
- ✅ Error handling patterns
- ✅ Widget organization
- ✅ Service/Provider patterns

**DON'T copy code for:**
- ❌ Firebase calls (replace with HTTP API)
- ❌ Firestore queries (replace with API)
- ❌ Complex nested Firestore logic

#### 4. **Important Files to Analyze**

```
Current codebase:

📄 lib/auth/auth_manager.dart
   → Study: How to authenticate users
   → Rewrite: To use Express backend instead of Firebase

📄 lib/backend/backend.dart
   → Study: API structure and patterns
   → Rewrite: To call Express API instead of Firebase

📄 lib/app_state.dart
   → Study: State management approach
   → Keep: General pattern (Provider, Riverpod, etc.)
   → Rewrite: To fetch from Express backend

📄 lib/pages/
   → Keep: UI layouts and designs
   → Rewrite: API calls to use Express endpoints
```

---

## 🔐 FROM FIREBASE SETUP (`firebase/`)

### ✅ COPY THESE CREDENTIALS

**Location in current code:** `firebase/`

**What to extract:**

#### 1. **Firebase Configuration**

```
Copy these files:
✅ android/app/google-services.json
✅ ios/Runner/GoogleService-Info.plist

Why: Continue using Firebase Auth initially, then migrate
```

**New location:**
```
apps/flutter-app/android/app/google-services.json
apps/flutter-app/ios/Runner/GoogleService-Info.plist
```

#### 2. **Firebase Project Details**

**Get from Firebase Console:**

```
Project Name:           [Your project name]
Project ID:             [Your project ID]
Web API Key:            [API key]
Sender ID (FCM):        [Sender ID]
Database URL:           [Firebase DB URL if using]
```

**Save in:** `11_CREDENTIALS_VAULT.md`

#### 3. **Firebase Service Account** (For Backend)

**Get from Firebase Console:**
- Go to: Project Settings → Service Accounts
- Download: `serviceAccountKey.json`

**Usage:**
- Keep secure (don't commit to Git)
- Use in backend for Firebase Admin SDK
- For sending notifications, validating tokens

**New location:**
```
apps/backend/firebase/serviceAccountKey.json
(Add to .gitignore!)
```

### ❌ DON'T COPY

- ❌ Old Cloud Functions
- ❌ Firestore security rules (will rebuild)
- ❌ Old Firebase indexes config
- ❌ Emulator configurations

---

## 📱 FROM GOOGLE PLAY STORE SETUP

### ✅ COPY THESE CREDENTIALS

**Location:** Google Play Console

**What to get:**

#### 1. **Keystore File** (for signing APK)

```
Copy from current setup:
✅ android/app/key.properties
✅ The keystore file (usually autolab-key.jks or similar)

Why: Same keystore needed to update the existing app on Play Store
     Different keystore = Considered different app!
```

**New location:**
```
apps/flutter-app/android/app/
```

**Important:**
- Keep the same keystore to update existing app
- If lost, can't update the app (must publish new)
- Never share keystore file
- Store password securely in vault

#### 2. **App Signing Certificate**

```
From Google Play Console:
✅ Signing certificate SHA1
✅ Signing certificate fingerprint
✅ Upload certificate SHA1
```

**Usage:**
- For firebase.json configuration
- For signing APK builds

**Save in:** `11_CREDENTIALS_VAULT.md`

#### 3. **Google Play Console Setup**

```
Copy/Note these:
✅ App ID (e.g., com.example.autolab)
✅ Console URL: https://play.google.com/console/u/0/
✅ Package name
✅ Store listing URL
```

**Keep for:** Publishing updates

#### 4. **Release Notes & Description**

```
Copy from Play Store:
✅ Full app description
✅ Screenshots (keep all)
✅ Feature graphics
✅ Privacy policy (if any)
✅ Release notes template
```

**Usage:**
- When publishing updates
- Consistency across versions

---

## 🎨 FLUTTER UI REUSE STRATEGY

### How to Reuse Flutter Code

#### 1. **Copy Widget Structure**

```dart
// ✅ Copy this: Widget structure and layout
class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Hello')),
    );
  }
}

// ❌ Don't copy this: API/Firestore calls
// Replace with: HTTP calls to Express backend
```

#### 2. **Copy Styling**

```dart
// ✅ Copy color definitions
const primaryColor = Color(0xFF2196F3);
const secondaryColor = Color(0xFFFFC107);

// ✅ Copy text styles
final headingStyle = GoogleFonts.lexendDeca(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

// ✅ Copy theme configuration
final theme = ThemeData(
  primaryColor: primaryColor,
  textTheme: TextTheme(...),
);
```

#### 3. **Copy Components**

```dart
// ✅ Copy reusable widgets
class CustomButton extends StatelessWidget { ... }
class CustomTextField extends StatelessWidget { ... }
class LoadingSpinner extends StatelessWidget { ... }

// ❌ Don't copy: Firestore-specific widgets
// Example: FirestoreListView with database bindings
```

---

## 💻 CODE MIGRATION APPROACH

### Step-by-Step: Convert Firebase → Express API

#### Example: Get User Data

**Current (Firebase) - DON'T COPY:**
```dart
// OLD - Firebase Firestore
Future<User> getUser(String userId) async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .get();
  
  return User.fromJson(doc.data());
}
```

**New (Express API) - DO THIS:**
```dart
// NEW - Express backend
Future<User> getUser(String userId) async {
  final response = await http.get(
    Uri.parse('$API_URL/api/users/$userId'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}
```

---

## 📊 COPY CHECKLIST

### Design Assets
- [ ] `/assets/images/` - Logos, icons, images
- [ ] `/assets/fonts/` - Custom fonts (Lexend Deca)
- [ ] `/assets/jsons/` - Animations (Rive)
- [ ] Color scheme definitions
- [ ] Theme definitions

### Flutter Code Patterns
- [ ] Widget structure patterns
- [ ] State management approach
- [ ] Error handling patterns
- [ ] Navigation patterns
- [ ] Service/Provider patterns
- [ ] Utility functions
- [ ] Constants and enums

### Firebase Credentials
- [ ] `google-services.json` (Android)
- [ ] `GoogleService-Info.plist` (iOS)
- [ ] Firebase project ID
- [ ] Firebase Web API key
- [ ] Firebase Sender ID
- [ ] Service account key (for backend)

### Google Play Store
- [ ] Keystore file (`*.jks`)
- [ ] `key.properties` file
- [ ] Signing certificate SHA1
- [ ] App package name (`com.example.autolab`)
- [ ] Store listing description
- [ ] Screenshots and graphics
- [ ] Privacy policy URL

### Documentation
- [ ] Current app screenshots
- [ ] Feature list
- [ ] User manual (if exists)
- [ ] API patterns documentation

---

## ⚠️ MIGRATION TIMELINE

```
Week 1: Setup monorepo, copy assets
Week 2: Rebuild Flutter UI with API calls
Week 3: Build Express backend API
Week 4: Build Admin dashboard
Week 5: Test everything
Week 6: Deploy to Vercel
Week 7: Deploy to Google Play Store
```

---

## 🎯 Summary: What Goes Where

```
Current Codebase          New Monorepo
─────────────────────     ──────────────────

assets/                   → apps/flutter-app/assets/
lib/ (UI only)           → apps/flutter-app/lib/ (rewrite logic)
lib/auth/                → apps/backend/src/ (new auth API)
lib/backend/ (Firebase)  → apps/backend/src/routes/ (new APIs)
firebase/                → Credentials saved in vault
android/                 → apps/flutter-app/android/
ios/                     → apps/flutter-app/ios/
pubspec.yaml             → apps/flutter-app/pubspec.yaml (modified)
```

---

## 💾 Quick Reference: Exact Copy Instructions

### 1. Copy Flutter Assets (Copy entire folder)
```bash
# From current project
cp -r assets/ ../autolab-monorepo/apps/flutter-app/

# This copies:
# - Images (logos, icons)
# - Fonts (Lexend Deca)
# - Animations (Rive JSONs)
```

### 2. Copy Firebase Files
```bash
# Android Firebase
cp android/app/google-services.json \
   ../autolab-monorepo/apps/flutter-app/android/app/

# iOS Firebase
cp ios/Runner/GoogleService-Info.plist \
   ../autolab-monorepo/apps/flutter-app/ios/Runner/

# Keystore (for signing)
cp android/app/key.properties \
   ../autolab-monorepo/apps/flutter-app/android/app/
cp android/app/autolab-key.jks \
   ../autolab-monorepo/apps/flutter-app/android/app/
```

### 3. Save Credentials
Write these to `11_CREDENTIALS_VAULT.md`:
```
Firebase Project ID:     [value]
Firebase API Key:        [value]
Firebase Sender ID:      [value]
Google Play Keystore:    [password]
App Package Name:        [value]
```

---

## ✅ Next Steps

After identifying what to copy:

1. ✅ Create GitHub repository
2. ✅ Set up monorepo folder structure
3. ✅ Copy assets and credentials
4. ✅ Push initial commit

→ **Next:** `02_GITHUB_SETUP.md`

---

## 📞 Key Takeaways

1. **UI Assets:** Copy `/assets/` folder as-is
2. **Code:** Reuse patterns, rewrite API calls
3. **Credentials:** Extract & save in vault
4. **Keystore:** Keep same for Play Store updates
5. **Start Fresh:** New database, new backend, new dashboard

**You're building a modern, professional version of your app!** 🚀

---

**Last Updated:** April 27, 2026  
**Time to read:** 15-20 minutes  
**Next file:** 02_GITHUB_SETUP.md

→ Continue to set up GitHub repository

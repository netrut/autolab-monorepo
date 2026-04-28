# 📱 GOOGLE PLAY STORE - App Publishing Guide

**Purpose:** Build, test, and publish Flutter app to Google Play Store  
**Time:** 3-5 hours (first publish takes longer)  
**Complexity:** Intermediate  
**Tech:** Flutter, Google Play Console, App Signing  
**Status:** ✅ Ready to implement

---

## 🎯 What You'll Do

- ✅ Create Google Play Developer account
- ✅ Create app in Play Console
- ✅ Build release APK/AAB
- ✅ Create app store listing
- ✅ Add screenshots and descriptions
- ✅ Configure store visibility
- ✅ Submit for review
- ✅ Monitor app status

---

## 📋 Prerequisites

- ✅ Google account
- ✅ Flutter app configured (from 06_FLUTTER_FRONTEND.md)
- ✅ Firebase setup (from 09_FIREBASE_DETAILS.md)
- ✅ App signing certificate created
- ✅ Version code and name set

---

## 💰 Costs

- **Google Play Developer Account:** $25 (one-time)
- **App Publishing:** Free
- **In-app purchases:** 30% fee to Google

---

## 🚀 STEP-BY-STEP PROCESS

### STEP 1: Create Google Play Developer Account

1. Go to **https://play.google.com/console**
2. Click **"Create account"**
3. Accept Terms & Conditions
4. Pay **$25 registration fee**
5. Add **Developer Account Details:**
   - Name: Your name or company
   - Email: Your email
   - Phone: Your phone number
   - Address: Your address
6. Verify payment method
7. Wait for account approval (usually instant)

✅ **Done:** Developer account ready

---

### STEP 2: Update pubspec.yaml

Ensure your app has proper version info:

```yaml
name: autolab
description: AutoLab - Vehicle Service Booking App
publish_to: none

version: 1.0.0+1  # version_name+version_code

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # ... your dependencies ...

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/fonts/
    - assets/jsons/
  
  fonts:
    - family: LexendDeca
      fonts:
        - asset: assets/fonts/Lexend Deca-SemiBold.ttf
          weight: 600
```

---

### STEP 3: Update Android Manifest

Update `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  
  <!-- Add permissions -->
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.CALL_PHONE" />
  
  <application
    android:label="AutoLab"
    android:icon="@mipmap/ic_launcher"
    android:roundIcon="@mipmap/ic_launcher_round"
    android:usesCleartextTraffic="false">
    
    <!-- MainActivity -->
    <activity
      android:name=".MainActivity"
      android:exported="true"
      android:launchMode="singleTop"
      android:theme="@style/LaunchTheme"
      android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
      android:hardwareAccelerated="true"
      android:windowSoftInputMode="adjustResize">
      
      <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>
    </activity>
    
  </application>
  
</manifest>
```

---

### STEP 4: Update App Icons

Replace app icons in:

- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

**Icon Requirements:**
- Square shape (no rounded corners)
- PNG format
- 192x192 for xxxhdpi (reference size)
- No transparency needed for Play Store

---

### STEP 5: Configure App Signing

Ensure you have `key.properties` set up (from 09_FIREBASE_DETAILS.md).

Verify in `android/app/build.gradle`:

```gradle
android {
  compileSdkVersion 34
  ndkVersion "25.1.8937393"

  compileOptions {
    sourceCompatibility JavaVersion.VERSION_11
    targetCompatibility JavaVersion.VERSION_11
  }

  kotlinOptions {
    jvmTarget = '11'
  }

  sourceSets {
    main.java.srcDirs += 'src/main/kotlin'
  }

  lintOptions {
    disable 'MissingFirebaseInstanceId'
  }

  defaultConfig {
    applicationId "com.autolab.app"
    minSdkVersion 21
    targetSdkVersion 34
    versionCode 1
    versionName "1.0.0"
    multiDexEnabled true
  }

  signingConfigs {
    release {
      keyAlias keystoreProperties['keyAlias']
      keyPassword keystoreProperties['keyPassword']
      storeFile file(keystoreProperties['storeFile'])
      storePassword keystoreProperties['storePassword']
    }
  }

  buildTypes {
    release {
      signingConfig signingConfigs.release
      minifyEnabled true
      shrinkResources true
      proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
  }
}
```

---

### STEP 6: Build Release APK

```bash
cd mobile-app

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build APK
flutter build apk --release

# Output: mobile-app/build/app/outputs/flutter-app/release/app-release.apk
```

Or build **App Bundle** (AAB - recommended for Play Store):

```bash
flutter build appbundle --release

# Output: mobile-app/build/app/outputs/bundle/release/app-release.aab
```

**AAB vs APK:**
- **AAB:** Smaller downloads, Play Store optimizes per device
- **APK:** Older format, larger downloads
- **Recommendation:** Use AAB for Play Store

---

### STEP 7: Create App in Play Console

1. Go to **Google Play Console**
2. Click **"Create app"**
3. **App name:** AutoLab
4. **Default language:** English
5. **App or game:** App
6. **Category:** Travel & Local
7. Check: "Interested in Google Play's pre-launch report"
8. Click **"Create app"**

✅ **Done:** App created in Play Console

---

### STEP 8: Fill App Details

#### Part A: Basic Info

1. Go to **Play Console** → **Your App** → **Dashboard**
2. Click **"App details"**
3. Fill in:
   - **App name:** AutoLab
   - **Short description:** (max 80 chars)
     ```
     Book vehicle maintenance & repairs instantly
     ```
   - **Full description:** (max 4000 chars)
     ```
     AutoLab is your one-stop solution for all vehicle 
     maintenance and repair needs. Book appointments at 
     nearby service centers, get expert advice, and track 
     your vehicle's service history.
     
     Features:
     - Book appointments instantly
     - Find nearby service centers
     - Track service history
     - Get maintenance reminders
     - Real-time notifications
     ```
   - **Developer contact:** Your email

#### Part B: Store Listing

1. Click **"Store listing"** in left menu
2. Fill in:
   - **App name:** AutoLab
   - **Short description:** (80 chars max)
   - **Full description:** (4000 chars max)
   - **Category:** Travel & Local (or Tools)

#### Part C: Graphic Assets

Upload images to **"Store listing"**:

**App Icon:**
- Dimensions: 512x512
- Format: PNG/JPEG
- Background: Solid color (no transparency)
- File: `assets/images/AutoLabLogo.png`

**Screenshots (minimum 2, max 8):**
- Dimensions: 1080x1920 (9:16 aspect ratio)
- Show key app features
- Add text overlays if needed
- Create 2-3 screenshots showing:
  1. Home screen with available services
  2. Booking flow
  3. Booking confirmation

**Feature Graphic:**
- Dimensions: 1024x500
- Shows app's best feature
- Your app logo + key benefit

**Video (optional):**
- Max 30 seconds
- Shows app in action
- Upload to YouTube first

#### Part D: Content Rating Questionnaire

1. Click **"Content rating"** in left menu
2. Fill **Email address:** Your email
3. Answer questions about app content
4. Questions include:
   - Violence
   - Profanity
   - Sexual content
   - Ads
   - Etc.
5. Auto-generates rating based on answers

#### Part E: Target Audience

1. Click **"Target audience"**
2. Set:
   - **Age:** 13+
   - **Intent:** Financial/Shopping (or Productivity)

---

### STEP 9: Upload App Bundle

1. Go to **Play Console** → **Your App** → **Release**
2. Click **"Create new release"** under **Production**
3. Click **"Browse files"** to upload AAB
4. Select: `build/app/outputs/bundle/release/app-release.aab`
5. Wait for upload (2-3 minutes)
6. Verify:
   - Version code: 1
   - Version name: 1.0.0
   - Size: Should show app size
7. Click **"Next"**

---

### STEP 10: Review Release

1. Review all details:
   - **App name:** AutoLab
   - **Version:** 1.0.0
   - **Target devices:** Android 5.0+
   - **Permissions:** Check all requested
   - **Permissions warning:** May show warnings - that's ok
2. Click **"Save"** to save as draft
3. Or click **"Review"** to proceed

---

### STEP 11: Submit for Review

1. Click **"Review"** button
2. Check **Declarations:**
   - [ ] "My app complies with Google Play policies"
   - [ ] "My app is appropriate for families"
3. Click **"Confirm release"**
4. Select **Stage:** Production (for all users)
5. Click **"Send to production"**

**Status:** Your app is now in review!

---

### STEP 12: Monitor Review Status

1. Go to **Play Console** → **Your App** → **Release**
2. Check **Status:**
   - 🟡 **In review:** Waiting for Google (usually 3-24 hours)
   - 🟢 **Published:** Live on Play Store!
   - 🔴 **Rejected:** Check rejection reason and resubmit

---

## 📋 Pre-Submission Checklist

- [ ] App name matches brand
- [ ] Version code incremented
- [ ] All permissions declared
- [ ] App icons set correctly
- [ ] Screenshots uploaded (min 2)
- [ ] Feature graphic uploaded
- [ ] Short & full descriptions filled
- [ ] Content rating completed
- [ ] Target audience set
- [ ] Developer contact added
- [ ] Privacy policy URL set (if using user data)
- [ ] Category selected correctly
- [ ] App signing configured
- [ ] No crashes or errors in testing

---

## 📱 Testing Before Submission

### Local Testing:

```bash
# Run release build
flutter run --release

# Test:
# - All screens load
# - API calls work
# - Notifications work
# - Location works (if used)
# - Camera works (if used)
# - No crashes or errors
```

### Internal Test Track:

For early testing, use Play Console's internal test:

1. Go to **Play Console** → **Release** → **Internal testing**
2. Create release with AAB
3. Add testers (their Google accounts)
4. Testers get link to install from Play Store
5. Get feedback before submitting to production

---

## 🔄 Updates & New Versions

### To Submit Update:

1. Increment `versionCode` in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # versionCode increased from 1 to 2
   ```

2. Build new AAB:
   ```bash
   flutter build appbundle --release
   ```

3. Upload to **Play Console** → **Create new release**

4. Write **"What's new"** describing changes

5. Submit for review

**Version Code Rules:**
- Each release needs higher versionCode
- versionCode must be integer
- versionCode can't decrease

---

## 📊 Monitor App Performance

In **Play Console**, track:

1. **Statistics:**
   - Total installs
   - Active installs
   - Crashes
   - ANR (App Not Responding)

2. **Ratings:**
   - Star rating (1-5)
   - Review count
   - Recent reviews

3. **Crashes:**
   - Crash rate
   - Top crash errors
   - Device/OS affected

---

## 🐛 Common Rejection Reasons

| Reason | Solution |
|--------|----------|
| **Targetless APK** | Build AAB, not APK |
| **Missing privacy policy** | Add privacy policy URL if collecting data |
| **Crashes on startup** | Test thoroughly, check logs |
| **Ads don't comply** | Ensure ads follow policy |
| **Location data** | Get proper permissions |
| **Authentication issues** | Ensure login/signup works smoothly |

---

## 📧 Manage App Updates

### Once Published:

1. **Monitor reviews** for bugs or feedback
2. **Fix critical bugs** within 24-48 hours
3. **Release updates** via:
   ```bash
   # Increment version
   # Build new AAB
   # Upload to Play Console
   ```

4. **Rollout strategies:**
   - 10% → 25% → 100% (safe rollout)
   - Or go straight to 100%

### Staged Rollout:

1. Go to **Play Console** → **Release** → **Staged rollout**
2. Set percentage: 10%
3. Monitor crashes for 24 hours
4. Increase to 25%, then 100%

---

## ✅ Verification Checklist

- [ ] Developer account created
- [ ] App created in Play Console
- [ ] App details filled
- [ ] Screenshots uploaded
- [ ] Icons set correctly
- [ ] Content rating completed
- [ ] App bundle built
- [ ] App bundle uploaded
- [ ] Review submission sent
- [ ] Status monitoring set up
- [ ] App live on Play Store

---

## 🎯 Next Steps

1. ✅ App published to Play Store
2. ✅ Monitor reviews and ratings
3. ✅ Fix bugs and release updates
4. ✅ Promote app through marketing

---

## 📚 Helpful Resources

- **Google Play Policy Center:** https://play.google.com/about/developer-content-policy/
- **Pre-launch Report:** Check for compatibility issues
- **App signing guide:** https://developer.android.com/studio/publish/app-signing
- **Play Console Help:** https://support.google.com/googleplay/android-developer

---

**Status:** ✅ Complete Google Play Store Publishing Guide  
**Ready to implement:** Yes  
**Difficulty:** Intermediate

---

## 🎉 Congratulations!

You've successfully:
- ✅ Built Flutter app with backend API
- ✅ Created admin dashboard
- ✅ Deployed backend & dashboard
- ✅ Setup CI/CD automation
- ✅ Configured Firebase & push notifications
- ✅ Published app to Google Play Store

**Your app is now live!** 🚀

---

**Next:** Market your app and gather user feedback!

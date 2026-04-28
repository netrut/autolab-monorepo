# 📦 EXISTING APP MIGRATION - Certificate & Details Extraction

**Purpose:** Extract and preserve existing app signing details for Play Store updates  
**Status:** ✅ Ready to implement  
**Time:** 1-2 hours  

---

## 🎯 WHAT YOU NEED TO EXTRACT

Your AutoLab app is already live on Google Play Store. Before creating a new version, you must preserve:

1. **App Signing Certificate** (fingerprints & keys)
2. **Package Name** (reverse domain)
3. **App ID in Play Store**
4. **Version codes & names**
5. **Previous release notes**
6. **Store listing details**
7. **User reviews & ratings**
8. **Download statistics**

---

## 📋 EXISTING APP DETAILS CHECKLIST

### **Step 1: Google Play Console - App Information**

Go to: **Google Play Console** → **Your AutoLab App** → **Dashboard**

Save these details:

```
☐ App Name: ___________________________________
☐ Package Name: ________________________________ (e.g., com.autolab.app)
☐ App ID (internal): __________________________
☐ Category: ___________________________________
☐ Current Version Name: ________________________
☐ Current Version Code: ________________________
☐ Minimum SDK: ________________________________
☐ Target SDK: __________________________________
☐ Release Date: ________________________________
```

### **Step 2: Android App Signing Certificate**

Go to: **Google Play Console** → **Settings** → **App Integrity** → **App Signing**

Save these details:

```
☐ SHA-1 Certificate Fingerprint: ________________
☐ SHA-256 Certificate Fingerprint: ______________
☐ MD5 Certificate Fingerprint: __________________
☐ Issuer: _____________________________________
☐ Serial Number: ______________________________
☐ Validity: ___________________________________
```

**IMPORTANT:** These fingerprints are used by:
- Firebase authentication
- Google Maps API
- Push notifications
- Third-party integrations

### **Step 3: Upload Key & Keystore**

You need to find your existing **keystore file**:

```bash
# On your development machine, find the keystore:
# Usually at: ~/.android/upload-keystore.jks
# Or: ~/Android/keystore/
# Or: <project>/android/app/upload_key.jks

# If you have the keystore, export the certificate:
keytool -list -v -keystore ~/path/to/upload_key.jks \
  -alias upload \
  -storepass <password> \
  -keypass <password>
```

Save these details:

```
☐ Keystore File Path: ___________________________
☐ Keystore Password: ____________________________
☐ Key Alias: ____________________________________
☐ Key Password: _________________________________
☐ Keystore Format: ____________________________
```

### **Step 4: Current App Release History**

Go to: **Google Play Console** → **Release** → **Production**

For each release, save:

```
Release 1:
☐ Version Name: ________________________________
☐ Version Code: ________________________________
☐ Release Date: ________________________________
☐ Release Notes: ________________________________
☐ Status: ______________________________________

Release 2:
☐ Version Name: ________________________________
☐ Version Code: ________________________________
☐ Release Date: ________________________________
☐ Release Notes: ________________________________
☐ Status: ______________________________________

[Continue for all releases...]
```

### **Step 5: Store Listing Details**

Go to **Google Play Console** → **Store Listing**

Save these:

```
☐ Short Description: _____________________________
☐ Full Description: ______________________________
☐ Promotional Text: ______________________________
☐ Category: _____________________________________
☐ Category Details: ______________________________
☐ Website URL: _________________________________
☐ Support Email: ________________________________
☐ Support Website: ______________________________
☐ Privacy Policy URL: ____________________________
☐ Permissions: _________________________________
```

### **Step 6: Screenshots & Graphics**

```
☐ Phone Screenshots Count: _____________________
☐ Tablet Screenshots Count: _____________________
☐ Feature Graphic: Available? (Y/N)
☐ Video URL: ___________________________________
☐ Icon (512x512): Filename: _____________________
☐ Banner: Filename: _____________________________
```

### **Step 7: Current App Users & Analytics**

Go to **Google Play Console** → **Statistics**

Save these:

```
☐ Total Installs: _______________________________
☐ Active Installs: ______________________________
☐ Uninstalls: __________________________________
☐ Rating: ______________________________________
☐ Total Reviews: ________________________________
☐ Crash Rate: __________________________________
☐ ANR Rate: ____________________________________
☐ Countries with Most Downloads: ________________
```

### **Step 8: Content Rating**

Go to **Google Play Console** → **Content Rating**

Save these:

```
☐ Content Rating Category: ______________________
☐ Target Age Group: _____________________________
☐ Violence Level: _______________________________
☐ Language Level: _______________________________
☐ Sexual Content: _______________________________
☐ Ads: _________________________________________
☐ Financial Transactions: ________________________
```

---

## 🔐 SIGNING KEY RETRIEVAL

### **If You Still Have the Keystore File:**

```bash
# List all certificates in keystore
keytool -list -v -keystore ~/path/to/upload_key.jks

# Export certificate in PEM format (for backup)
keytool -exportcert -alias upload \
  -keystore ~/path/to/upload_key.jks \
  -file certificate.pem

# Get SHA-1 fingerprint
keytool -list -v -keystore ~/path/to/upload_key.jks -alias upload
```

### **If You Lost the Keystore File:**

⚠️ **IMPORTANT:** Google Play Console will manage app signing for you.

1. Go to **Play Console** → **Settings** → **App Integrity** → **App Signing**
2. You'll see Google's managed certificate (NOT your original)
3. You can still release updates using Google Play's signing system
4. Your original keystore doesn't matter anymore

**What to do:**
- Generate NEW keystore for local testing
- Use Google Play's certificate for releases
- See 10_GOOGLE_PLAY_STORE.md for process

---

## 📝 FIREBASE PROJECT DETAILS

If using Firebase, save:

```
☐ Firebase Project ID: ___________________________
☐ Firebase Project Name: _________________________
☐ Google App ID: ________________________________
☐ API Key: _____________________________________
☐ Database URL: ________________________________
☐ Storage Bucket: ______________________________
☐ Messaging Sender ID: __________________________
☐ Service Account Email: _________________________
```

### **Export Service Account Key:**

1. Go to **Firebase Console** → **Project Settings**
2. Click **Service Accounts** tab
3. Click **Generate New Private Key**
4. Save the JSON file securely
5. Don't commit to Git!

---

## 🔧 ANDROID BUILD CONFIGURATION

Check your current `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion = ?                  ☐ Save: ____
    ndkVersion = "?"                       ☐ Save: ____
    
    defaultConfig {
        applicationId = "?"                ☐ Save: ____
        minSdkVersion = ?                  ☐ Save: ____
        targetSdkVersion = ?               ☐ Save: ____
        versionCode = ?                    ☐ Save: ____
        versionName = "?"                  ☐ Save: ____
    }
}
```

---

## 📱 APP STORE LISTING BACKUP

### **Take Screenshots of:**

```
☐ Store listing page
☐ Current screenshots
☐ Ratings & reviews
☐ Version history
☐ User feedback
☐ Analytics dashboard
```

### **Export Store Listing:**

1. **Google Play Console** → **Store Listing**
2. Click **Download as PDF** (if available)
3. Or manually copy all text

---

## 🔐 SECURE STORAGE

After collecting everything, store securely:

```
Create folder: ~/autolab-backup/
├── certificates/
│   ├── sha1_fingerprint.txt
│   ├── sha256_fingerprint.txt
│   └── certificate.pem
├── keystores/
│   ├── upload_key.jks (if you have it)
│   └── key_properties.txt
├── firebase/
│   └── service-account-key.json
├── credentials/
│   ├── play_store_details.txt
│   ├── release_history.txt
│   └── store_listing.txt
└── analytics/
    ├── user_stats.csv
    ├── reviews_backup.csv
    └── crash_reports.txt
```

⚠️ **NEVER COMMIT KEYSTORES TO GIT!**

---

## 📊 RELEASE CHECKLIST FOR NEW VERSION

Before releasing new version, verify:

```
☐ Package name matches existing app
☐ Version code incremented (e.g., 1 → 2 → 3)
☐ Target SDK matches or higher
☐ All permissions declared
☐ Signing certificate correct
☐ SHA-256 fingerprint matches
☐ App tested locally
☐ Release notes prepared
☐ Screenshots updated (if UI changed)
☐ All existing users can update
```

---

## 🔄 VERSION CODE INCREMENT RULES

**Current Version Code:** ☐ ____

**Next Version Code:** ☐ ____ (must be higher than current)

```
Rules:
- Version code must ALWAYS increase
- Can never decrease
- Must be integer (no decimals)
- Each release needs new code
- Google Play enforces this

Example:
Version 1.0.0 → versionCode 1
Version 1.0.1 → versionCode 2
Version 1.1.0 → versionCode 3
Version 2.0.0 → versionCode 4
```

---

## ✅ EXTRACTION COMPLETE CHECKLIST

- [ ] App details saved (Step 1)
- [ ] Certificates & fingerprints saved (Step 2)
- [ ] Keystore file located (Step 3)
- [ ] Release history documented (Step 4)
- [ ] Store listing details saved (Step 5)
- [ ] Screenshots backed up (Step 6)
- [ ] Analytics noted (Step 7)
- [ ] Content rating saved (Step 8)
- [ ] Firebase details saved (if used)
- [ ] Build configuration documented
- [ ] Store listing backed up
- [ ] All files secured in backup folder
- [ ] Credentials NOT committed to Git

---

## 📝 NEXT STEPS

1. **Extract all details** using this checklist
2. **Create backup folder** with all information
3. **Update 11_CREDENTIALS_VAULT.md** with details
4. **Never lose the keystore again!** (backup to cloud)
5. **Document for your team** (who needs access?)
6. **When ready to release:** Follow 10_GOOGLE_PLAY_STORE.md

---

## ⚠️ IMPORTANT NOTES

### **For Seamless Updates:**
- Same package name ✅
- Same signing certificate ✅
- Incremented version code ✅
- Users will automatically get update ✅

### **If Details Are Lost:**
- Play Console manages signing now (no problem)
- You can still release new versions
- Just use Play Console's upload process
- See troubleshooting below

### **Protecting the Future:**
- Backup keystore to cloud (Google Drive/Dropbox)
- Save credentials in secure vault
- Document for team members
- Update this list for next release

---

**Status:** ✅ Ready to extract existing app details  
**Time:** 1-2 hours  
**Difficulty:** Easy

---

**→ Next:** Complete this checklist, then 10_GOOGLE_PLAY_STORE.md for release process

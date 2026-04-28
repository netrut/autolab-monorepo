# 🔥 FIREBASE SETUP - Push Notifications & Play Store Signing

**Purpose:** Configure Firebase for FCM push notifications and Play Store signing  
**Time:** 2-3 hours  
**Complexity:** Intermediate  
**Tech:** Firebase, FCM, Google Cloud  
**Status:** ✅ Ready to implement

---

## 🎯 What You'll Do

- ✅ Create Firebase project
- ✅ Enable Firestore (optional)
- ✅ Configure Cloud Messaging (FCM)
- ✅ Generate service account key
- ✅ Setup app signing certificate
- ✅ Configure backend FCM integration
- ✅ Setup Flutter FCM listener
- ✅ Test push notifications

---

## 📋 Prerequisites

- ✅ Google account
- ✅ Google Cloud account
- ✅ Express backend (from 04_EXPRESS_BACKEND.md)
- ✅ Flutter app (from 06_FLUTTER_FRONTEND.md)
- ✅ Read: ARCHITECTURE_CLARIFICATIONS.md

---

## 🚀 STEP-BY-STEP SETUP

### STEP 1: Create Firebase Project

1. Go to **https://console.firebase.google.com/**
2. Click **"Create a project"**
3. Project name: `AutoLab` (or your app name)
4. Click **"Continue"**
5. Disable **"Enable Google Analytics"** (optional)
6. Click **"Create project"**
7. Wait 1-2 minutes for creation

✅ **Done:** Firebase project created

---

### STEP 2: Register iOS App (Optional - Only if publishing to App Store)

1. In **Firebase Console**, click your project
2. Click **"+ Add app"** → **"iOS"**
3. Bundle ID: `com.autolab.app` (your reverse domain)
4. Click **"Register app"**
5. Download **GoogleService-Info.plist**
6. Add to Xcode project:
   - Open `ios/Runner.xcodeproj`
   - Select `Runner` project
   - Drag **GoogleService-Info.plist** to project
   - Check "Copy items if needed"
   - Click "Finish"

✅ **Done:** iOS app registered

---

### STEP 3: Register Android App

1. In **Firebase Console**, click **"+ Add app"** → **"Android"**
2. Android package name: `com.autolab.app` (match pubspec.yaml)
3. Debug signing certificate SHA-1:
   - Open terminal in Flutter project
   - Run: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
   - Copy the **SHA1** value
   - Paste in Firebase form
4. Click **"Register app"**
5. Download **google-services.json**
6. Place in `android/app/google-services.json`

✅ **Done:** Android app registered

---

### STEP 4: Generate Service Account Key

This is needed for backend to send push notifications.

1. Go to **Firebase Console** → **Project Settings** (gear icon, top)
2. Click **"Service Accounts"** tab
3. Click **"Generate New Private Key"**
4. Save the downloaded **JSON file** securely
5. Keep it safe - contains sensitive credentials

**File structure:**
```json
{
  "type": "service_account",
  "project_id": "autolab-123456",
  "private_key_id": "key_id",
  "private_key": "-----BEGIN PRIVATE KEY-----...",
  "client_email": "firebase-adminsdk-xyz@autolab-123456.iam.gserviceaccount.com",
  "client_id": "123456789",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token"
}
```

✅ **Done:** Service account key downloaded

---

### STEP 5: Configure Backend FCM Integration

#### Part A: Install Firebase Admin SDK

```bash
cd backend
npm install firebase-admin
```

#### Part B: Create FCM Service

Create `src/services/fcm-service.ts`:

```typescript
import * as admin from 'firebase-admin';
import fs from 'fs';
import path from 'path';

// Initialize Firebase Admin SDK
const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH || 
  path.join(__dirname, '../firebase-service-account.json');

const serviceAccount = JSON.parse(
  fs.readFileSync(serviceAccountPath, 'utf8')
);

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    databaseURL: process.env.FIREBASE_DATABASE_URL,
  });
}

export interface FCMNotification {
  title: string;
  body: string;
  imageUrl?: string;
  data?: Record<string, string>;
}

export class FCMService {
  /**
   * Send notification to single device
   */
  static async sendToDevice(
    deviceToken: string,
    notification: FCMNotification
  ): Promise<string> {
    try {
      const message = {
        notification: {
          title: notification.title,
          body: notification.body,
          imageUrl: notification.imageUrl,
        },
        data: notification.data || {},
        token: deviceToken,
      };

      const response = await admin.messaging().send(message as any);
      console.log(`Notification sent: ${response}`);
      return response;
    } catch (error) {
      console.error('Error sending notification:', error);
      throw error;
    }
  }

  /**
   * Send notification to multiple devices
   */
  static async sendToMultipleDevices(
    deviceTokens: string[],
    notification: FCMNotification
  ): Promise<admin.messaging.BatchResponse> {
    try {
      const messages = deviceTokens.map(token => ({
        notification: {
          title: notification.title,
          body: notification.body,
          imageUrl: notification.imageUrl,
        },
        data: notification.data || {},
        token,
      }));

      const response = await admin.messaging().sendAll(messages as any);
      console.log(`${response.successCount} messages sent successfully`);
      return response;
    } catch (error) {
      console.error('Error sending notifications:', error);
      throw error;
    }
  }

  /**
   * Subscribe device to topic
   */
  static async subscribeToTopic(
    deviceTokens: string[],
    topic: string
  ): Promise<void> {
    try {
      await admin.messaging().subscribeToTopic(deviceTokens, topic);
      console.log(`${deviceTokens.length} devices subscribed to topic: ${topic}`);
    } catch (error) {
      console.error('Error subscribing to topic:', error);
      throw error;
    }
  }

  /**
   * Send notification to topic subscribers
   */
  static async sendToTopic(
    topic: string,
    notification: FCMNotification
  ): Promise<string> {
    try {
      const message = {
        notification: {
          title: notification.title,
          body: notification.body,
          imageUrl: notification.imageUrl,
        },
        data: notification.data || {},
        topic,
      };

      const response = await admin.messaging().send(message as any);
      console.log(`Topic message sent: ${response}`);
      return response;
    } catch (error) {
      console.error('Error sending topic notification:', error);
      throw error;
    }
  }
}

export default FCMService;
```

#### Part C: Create FCM Route in Express

Create `src/routes/notifications.ts`:

```typescript
import { Router } from 'express';
import FCMService, { FCMNotification } from '../services/fcm-service';
import { authenticateToken } from '../middleware/auth';

const router = Router();

/**
 * Send notification to specific device
 * POST /api/notifications/send
 */
router.post('/send', authenticateToken, async (req, res) => {
  try {
    const { deviceToken, title, body, data } = req.body;

    if (!deviceToken || !title || !body) {
      return res.status(400).json({
        error: 'Missing required fields: deviceToken, title, body',
      });
    }

    const result = await FCMService.sendToDevice(deviceToken, {
      title,
      body,
      data,
    });

    res.json({
      success: true,
      messageId: result,
    });
  } catch (error) {
    res.status(500).json({ error: error instanceof Error ? error.message : 'Failed to send notification' });
  }
});

/**
 * Send notification to multiple devices
 * POST /api/notifications/send-bulk
 */
router.post('/send-bulk', authenticateToken, async (req, res) => {
  try {
    const { deviceTokens, title, body, data } = req.body;

    if (!deviceTokens || !Array.isArray(deviceTokens) || !title || !body) {
      return res.status(400).json({
        error: 'Missing required fields: deviceTokens (array), title, body',
      });
    }

    const result = await FCMService.sendToMultipleDevices(deviceTokens, {
      title,
      body,
      data,
    });

    res.json({
      success: true,
      successCount: result.successCount,
      failureCount: result.failureCount,
    });
  } catch (error) {
    res.status(500).json({ error: error instanceof Error ? error.message : 'Failed to send notifications' });
  }
});

/**
 * Subscribe to topic
 * POST /api/notifications/subscribe-topic
 */
router.post('/subscribe-topic', authenticateToken, async (req, res) => {
  try {
    const { deviceTokens, topic } = req.body;

    if (!deviceTokens || !Array.isArray(deviceTokens) || !topic) {
      return res.status(400).json({
        error: 'Missing required fields: deviceTokens (array), topic',
      });
    }

    await FCMService.subscribeToTopic(deviceTokens, topic);

    res.json({
      success: true,
      message: `Subscribed ${deviceTokens.length} devices to topic: ${topic}`,
    });
  } catch (error) {
    res.status(500).json({ error: error instanceof Error ? error.message : 'Failed to subscribe to topic' });
  }
});

/**
 * Send notification to topic
 * POST /api/notifications/send-topic
 */
router.post('/send-topic', authenticateToken, async (req, res) => {
  try {
    const { topic, title, body, data } = req.body;

    if (!topic || !title || !body) {
      return res.status(400).json({
        error: 'Missing required fields: topic, title, body',
      });
    }

    const result = await FCMService.sendToTopic(topic, {
      title,
      body,
      data,
    });

    res.json({
      success: true,
      messageId: result,
    });
  } catch (error) {
    res.status(500).json({ error: error instanceof Error ? error.message : 'Failed to send topic notification' });
  }
});

export default router;
```

#### Part D: Add to Express App

In `src/index.ts`:

```typescript
import notificationsRouter from './routes/notifications';

// ... existing code ...

// Add notifications routes
app.use('/api/notifications', notificationsRouter);
```

---

### STEP 6: Configure Flutter for FCM

#### Part A: Update pubspec.yaml

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.6.0
  flutter_local_notifications: ^16.1.0  # For local notifications
```

#### Part B: Create FCM Service in Flutter

Create `lib/services/fcm_service.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

class FCMService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  static late FlutterLocalNotificationsPlugin _localNotifications;
  static late AndroidNotificationChannel _androidChannel;

  // Initialize Firebase and FCM
  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Request notification permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Setup local notifications
    _setupLocalNotifications();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background notifications
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Get initial message (if app was terminated)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  // Setup local notifications
  static void _setupLocalNotifications() {
    _localNotifications = FlutterLocalNotificationsPlugin();

    _androidChannel = const AndroidNotificationChannel(
      'autolab_channel',
      'AutoLab Notifications',
      description: 'Notifications from AutoLab',
      importance: Importance.high,
    );

    _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _localNotifications.initialize(initSettings);
  }

  // Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    print('Got foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      _localNotifications.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true),
        ),
      );
    }
  }

  // Handle background messages (top-level function)
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Got background message: ${message.notification?.title}');
    // Handle background notification
  }

  // Handle notification tap
  static void _handleMessageOpenedApp(RemoteMessage message) {
    print('User tapped notification: ${message.notification?.title}');
    // Navigate to relevant screen based on data
    // Navigator.of(context).pushNamed('/booking-details', arguments: message.data);
  }

  // Get FCM token
  static Future<String> getToken() async {
    final token = await _firebaseMessaging.getToken();
    return token ?? '';
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
```

#### Part C: Generate Firebase Options

```bash
cd mobile-app
flutterfire configure --project=autolab-123456
```

#### Part D: Update main.dart

```dart
import 'services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FCM
  await FCMService.initialize();
  
  // Get and save FCM token to backend
  final fcmToken = await FCMService.getToken();
  print('FCM Token: $fcmToken');
  // Save to backend: POST /api/users/{id}/fcm-token
  
  runApp(const MyApp());
}
```

---

### STEP 7: Configure App Signing Certificate

For **production APK/AAB**, create a signing key:

```bash
# Generate keystore
keytool -genkey -v -keystore ~/autolab.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias autolab \
  -storetype JKS

# You'll be asked for:
# - Password (use: AutoLab@2024#)
# - Full Name: AutoLab Inc
# - Organization: AutoLab
# - City: Your City
# - State: Your State
# - Country: Your Country (e.g., IN)
```

Create `android/key.properties`:

```properties
storePassword=AutoLab@2024#
keyPassword=AutoLab@2024#
keyAlias=autolab
storeFile=../autolab.keystore
```

Update `android/app/build.gradle`:

```gradle
android {
  // ... existing code ...

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
    }
  }
}
```

✅ **Done:** App signing configured

---

### STEP 8: Update Credentials Vault

Update `11_CREDENTIALS_VAULT.md` with Firebase info:

```markdown
## Firebase Configuration

### Project Info
- **Project ID:** autolab-123456
- **Project Name:** AutoLab
- **Console URL:** https://console.firebase.google.com/project/autolab-123456

### Service Account
- **Service Account Email:** firebase-adminsdk-xyz@autolab-123456.iam.gserviceaccount.com
- **Service Account Key:** Stored in `backend/firebase-service-account.json`
- **Keep Private:** YES - contains sensitive credentials

### FCM Configuration
- **Sender ID:** Get from Firebase Console → Project Settings
- **Server API Key:** Get from Firebase Console → Project Settings

### Backend Environment Variables
```bash
FIREBASE_PROJECT_ID=autolab-123456
FIREBASE_SERVICE_ACCOUNT_PATH=./firebase-service-account.json
FIREBASE_DATABASE_URL=https://autolab-123456.firebaseio.com
```

### Flutter Configuration
- **Google Services Config:** `android/app/google-services.json`
- **iOS Config:** `ios/Runner/GoogleService-Info.plist`
```

---

## 📊 Testing Push Notifications

### Test from Firebase Console:

1. Go to **Firebase Console** → **Cloud Messaging**
2. Click **"Send your first message"**
3. Enter **Title** and **Body**
4. Click **"Send test message"**
5. Enter your **FCM token** from the app
6. Click **"Test"**
7. Notification should appear in app

### Test from Backend API:

```bash
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "deviceToken": "YOUR_FCM_TOKEN",
    "title": "Test Notification",
    "body": "This is a test message",
    "data": {
      "type": "booking",
      "bookingId": "123"
    }
  }'
```

---

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] Android app registered
- [ ] Service account key downloaded
- [ ] google-services.json in Android app
- [ ] FCM service created in backend
- [ ] Notification routes added to Express
- [ ] Firebase initialized in Flutter
- [ ] FCM token retrieved in Flutter
- [ ] Local notifications configured
- [ ] App signing certificate created
- [ ] Key.properties file created
- [ ] Credentials vault updated

---

## 🎯 Next Steps

1. ✅ Firebase & FCM configured
2. ⏳ Build and publish to Play Store (10_GOOGLE_PLAY_STORE.md)

---

**Status:** ✅ Complete Firebase Setup Guide  
**Ready to implement:** Yes  
**Difficulty:** Intermediate

---

**→ Next Guide:** `10_GOOGLE_PLAY_STORE.md` (coming next)

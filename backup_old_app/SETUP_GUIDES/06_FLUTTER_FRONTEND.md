# 📱 FLUTTER FRONTEND INTEGRATION - Complete Guide

**Purpose:** Connect Flutter app to Express backend API (no Firebase Auth)  
**Time:** 3-4 days of coding  
**Complexity:** Intermediate  
**Tech:** Flutter, Dart, Dio HTTP client, JWT tokens, Secure Storage  
**Status:** ✅ Ready to implement

---

## 🎯 What You'll Do

Update Flutter app to:

- ✅ Remove Firebase authentication
- ✅ Call Express backend API instead
- ✅ Store JWT tokens securely
- ✅ Implement login/register with OTP
- ✅ Email verification flow
- ✅ Password reset flow
- ✅ API request interceptors
- ✅ Automatic token refresh
- ✅ Error handling
- ✅ Loading states

---

## 📋 Prerequisites

- ✅ Flutter SDK 3.32.8+ installed
- ✅ Express backend running (from 04_EXPRESS_BACKEND.md)
- ✅ Existing Flutter app structure
- ✅ Read: ARCHITECTURE_CLARIFICATIONS.md

---

## 🚀 STEP-BY-STEP IMPLEMENTATION

### STEP 1: Add Dependencies

Update `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP & API
  dio: ^5.3.0              # HTTP client with interceptors
  retrofit: ^4.0.0         # API client generator
  
  # Security
  flutter_secure_storage: ^9.0.0   # Secure token storage
  flutter_dotenv: ^5.1.0           # Environment variables
  
  # State Management
  provider: ^6.0.0
  riverpod: ^2.4.0         # Alternative to Provider
  
  # JSON Serialization
  json_serializable: ^6.7.0
  
  # UI & Utils
  get: ^4.6.5              # Navigation and DI
  intl: ^0.19.0            # Date formatting
  
  # Local Storage
  shared_preferences: ^2.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  retrofit_generator: ^8.0.0
```

Install:

```bash
flutter pub get
flutter pub run build_runner build
```

### STEP 2: Create API Client

Create `lib/backend/api_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio _dio;
  static const secureStorage = FlutterSecureStorage();

  // Use your backend URL
  static const String apiUrl = 'http://localhost:3000';
  static const String apiUrlProd = 'https://api.autolab.com';

  ApiClient._internal() {
    _initializeDio();
  }

  factory ApiClient() {
    return _instance;
  }

  void _initializeDio() {
    final BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  // Attach JWT token to every request
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  // Handle errors
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      // Token expired - clear and redirect to login
      await secureStorage.delete(key: 'jwt_token');
      await secureStorage.delete(key: 'user');
    }
    handler.next(error);
  }

  // GET request
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  // POST request
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await _dio.post(path, data: data);
  }

  // PUT request
  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return await _dio.put(path, data: data);
  }

  // DELETE request
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  // Save JWT token
  static Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
  }

  // Get JWT token
  static Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  // Clear token (logout)
  static Future<void> clearToken() async {
    await secureStorage.delete(key: 'jwt_token');
  }
}
```

### STEP 3: Create Auth Models

Create `lib/models/auth_models.dart`:

```dart
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class SendOtpRequest {
  final String phone;

  SendOtpRequest({required this.phone});

  Map<String, dynamic> toJson() => {
    'phone': phone,
  };
}

class VerifyOtpRequest {
  final String phone;
  final String otp;
  final String name;
  final String email;
  final String password;

  VerifyOtpRequest({
    required this.phone,
    required this.otp,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'otp': otp,
    'name': name,
    'email': email,
    'password': password,
  };
}

class AuthResponse {
  final String token;
  final UserData user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: UserData.fromJson(json['user'] ?? {}),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String role;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'CUSTOMER',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'role': role,
  };
}
```

### STEP 4: Create Auth Service

Create `lib/services/auth_service.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../backend/api_client.dart';
import '../models/auth_models.dart';

class AuthService {
  static const secureStorage = FlutterSecureStorage();
  final ApiClient _apiClient = ApiClient();

  // Login with email/password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save token and user
      await ApiClient.saveToken(authResponse.token);
      await secureStorage.write(
        key: 'user',
        value: authResponse.user.toJson().toString(),
      );

      return authResponse;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Send OTP
  Future<void> sendOtp({required String phone}) async {
    try {
      await _apiClient.post(
        '/api/auth/send-otp',
        data: SendOtpRequest(phone: phone).toJson(),
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  // Verify OTP and create account
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String otp,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/verify-otp',
        data: VerifyOtpRequest(
          phone: phone,
          otp: otp,
          name: name,
          email: email,
          password: password,
        ).toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save token and user
      await ApiClient.saveToken(authResponse.token);
      await secureStorage.write(
        key: 'user',
        value: authResponse.user.toJson().toString(),
      );

      return authResponse;
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    await ApiClient.clearToken();
    await secureStorage.delete(key: 'user');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await ApiClient.getToken();
    return token != null && token.isNotEmpty;
  }

  // Get current user
  Future<UserData?> getCurrentUser() async {
    final userJson = await secureStorage.read(key: 'user');
    if (userJson != null) {
      // Parse the user data
      return UserData.fromJson(Map<String, dynamic>.from({}));
    }
    return null;
  }
}
```

### STEP 5: Update Login Screen

Create or update `lib/pages/login_page.dart`:

```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/auth_models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please enter email and password');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        // Navigate to home/dashboard
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error message
            if (_error != null)
              Container(
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),

            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            // Password field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 24),

            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),

            const SizedBox(height: 16),

            // Register link
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/register'),
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### STEP 6: Create OTP Registration Page

Create `lib/pages/otp_register_page.dart`:

```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class OtpRegisterPage extends StatefulWidget {
  const OtpRegisterPage({Key? key}) : super(key: key);

  @override
  State<OtpRegisterPage> createState() => _OtpRegisterPageState();
}

class _OtpRegisterPageState extends State<OtpRegisterPage> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _authService = AuthService();

  bool _showOtpInput = false;
  bool _isLoading = false;
  String? _error;

  Future<void> _sendOtp() async {
    if (_phoneController.text.isEmpty) {
      setState(() => _error = 'Please enter phone number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.sendOtp(phone: _phoneController.text);
      setState(() => _showOtpInput = true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      setState(() => _error = 'Please enter OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.verifyOtp(
        phone: _phoneController.text,
        otp: _otpController.text,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register with OTP')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Error message
            if (_error != null)
              Container(
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(12),
                child: Text(_error!),
              ),

            const SizedBox(height: 20),

            // Step 1: Enter phone
            if (!_showOtpInput) ...[
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+919876543210',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Send OTP'),
                ),
              ),
            ],

            // Step 2: OTP & Registration details
            if (_showOtpInput) ...[
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
```

### STEP 7: Update App State Management

Update `lib/app_state.dart`:

```dart
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'models/auth_models.dart';

class AppState extends ChangeNotifier {
  final _authService = AuthService();
  
  bool _isLoggedIn = false;
  UserData? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  UserData? get currentUser => _currentUser;

  Future<void> initializeApp() async {
    _isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
```

### STEP 8: Update Main App

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'pages/login_page.dart';
import 'pages/otp_register_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'AutoLab',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthGate(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const OtpRegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.isLoggedIn) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
```

---

## 🔄 API Integration Examples

### Fetch Users List:

```dart
Future<List<UserData>> fetchUsers() async {
  try {
    final response = await ApiClient().get('/api/users');
    List<dynamic> usersList = response.data['users'] ?? [];
    return usersList.map((user) => UserData.fromJson(user)).toList();
  } catch (e) {
    throw Exception('Failed to fetch users: $e');
  }
}
```

### Create Booking:

```dart
Future<void> createBooking({
  required String vehicleId,
  required String serviceCenterId,
  required String serviceId,
  required DateTime bookingDate,
}) async {
  try {
    await ApiClient().post(
      '/api/bookings',
      data: {
        'vehicleId': vehicleId,
        'serviceCenterId': serviceCenterId,
        'serviceId': serviceId,
        'bookingDate': bookingDate.toIso8601String(),
      },
    );
  } catch (e) {
    throw Exception('Failed to create booking: $e');
  }
}
```

---

## ✅ Verification Checklist

- [ ] Dio HTTP client configured
- [ ] JWT token storage working
- [ ] API client with interceptors created
- [ ] Login page calls backend API
- [ ] OTP registration working
- [ ] Token saved and retrieved correctly
- [ ] Logout clears token
- [ ] Error handling working
- [ ] All pages can access API

---

## 🚀 Next Steps

1. ✅ Flutter app updated to use backend API
2. ⏳ Test all auth flows locally
3. ⏳ Deploy backend (07_VERCEL_DEPLOYMENT.md)
4. ⏳ Update API URL for production
5. ⏳ Publish to Play Store (10_GOOGLE_PLAY_STORE.md)

---

**Status:** ✅ Complete Flutter Integration Guide  
**Ready to implement:** Yes  
**Difficulty:** Intermediate

---

**→ Next Guide:** `07_VERCEL_DEPLOYMENT.md` (coming next)

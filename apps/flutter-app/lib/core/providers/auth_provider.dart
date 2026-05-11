import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../models/user_model.dart';

/// Manages authentication state for the whole app.
/// Wrap MaterialApp with ChangeNotifierProvider<AuthProvider>.
class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  static const _keyUserId = 'user_id';
  static const _keyServiceCenterId = 'service_center_id';

  final _api = ApiClient();

  // ── Initialise ─────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (!await ApiClient.hasToken()) return;
    try {
      final res = await _api.get('/api/users/profile');
      _user = UserModel.fromJson(res.data as Map<String, dynamic>);
      await _saveSession(_user!.id);
    } catch (_) {
      await ApiClient.clearToken();
    }
    notifyListeners();
  }

  // ── Email login ────────────────────────────────────────────────────────────

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      final res = await _api.post('/api/auth/login',
          data: {'email': email, 'password': password});
      final body = res.data as Map<String, dynamic>;
      await ApiClient.saveToken(body['token'] as String);
      _user = UserModel.fromJson(body['user'] as Map<String, dynamic>);
      await _saveSession(_user!.id);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Register ───────────────────────────────────────────────────────────────

  Future<bool> register({
    required String email,
    required String phone,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    try {
      await _api.post('/api/auth/register', data: {
        'email': email,
        'phone': phone,
        'password': password,
        'name': name,
      });
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── OTP ────────────────────────────────────────────────────────────────────

  Future<bool> sendOtp(String phone) async {
    _setLoading(true);
    try {
      await _api.post('/api/auth/send-otp', data: {'phone': phone});
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOtp({
    required String phone,
    required String otp,
    String? name,
    String? email,
    String? password,
  }) async {
    _setLoading(true);
    try {
      final res = await _api.post('/api/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
      });
      final body = res.data as Map<String, dynamic>;
      await ApiClient.saveToken(body['token'] as String);
      _user = UserModel.fromJson(body['user'] as Map<String, dynamic>);
      await _saveSession(_user!.id);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Forgot / Reset password ────────────────────────────────────────────────

  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    try {
      await _api.post('/api/auth/forgot-password', data: {'email': email});
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await ApiClient.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyServiceCenterId);
    _user = null;
    notifyListeners();
  }

  // ── Session helpers ────────────────────────────────────────────────────────

  Future<void> _saveSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    // Fetch service_center_id for this user
    try {
      final res = await _api.get('/api/users/service-center');
      final scId = (res.data as Map<String, dynamic>)['service_center_id'] as String?;
      if (scId != null) {
        await prefs.setString(_keyServiceCenterId, scId);
      } else {
        await prefs.remove(_keyServiceCenterId);
      }
    } catch (_) {
      // non-fatal — service center may not be assigned yet
    }
  }

  static Future<String?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getSavedServiceCenterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyServiceCenterId);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      final msg = e.toString();
      // Dio error body
      if (msg.contains('"message"')) {
        final match = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(msg);
        if (match != null) return match.group(1)!;
      }
      return msg.replaceAll('Exception: ', '');
    }
    return 'Something went wrong';
  }
}

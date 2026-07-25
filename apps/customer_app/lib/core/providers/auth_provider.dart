import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _emailNotVerified = false;
  String? _unverifiedEmail;
  bool _phoneNotFound = false;
  bool _wrongApp = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get emailNotVerified => _emailNotVerified;
  String? get unverifiedEmail => _unverifiedEmail;
  bool get phoneNotFound => _phoneNotFound;
  bool get wrongApp => _wrongApp;

  static const _keyUserId = 'user_id';
  final _api = ApiClient();

  Future<void> init() async {
    if (!await ApiClient.hasToken()) return;
    try {
      final res = await _api.get('/api/users/profile');
      _user = UserModel.fromJson(res.data as Map<String, dynamic>);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, _user!.id);
    } catch (_) {
      await ApiClient.clearToken();
    }
    notifyListeners();
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _emailNotVerified = false;
    _unverifiedEmail = null;
    _wrongApp = false;
    try {
      final res = await _api.post('/api/auth/login',
          data: {'email': email, 'password': password});
      final body = res.data as Map<String, dynamic>;
      final user = UserModel.fromJson(body['user'] as Map<String, dynamic>);
      if (user.roleId == 2) {
        _wrongApp = true;
        _error = 'wrong_app';
        notifyListeners();
        return false;
      }
      await ApiClient.saveToken(body['token'] as String);
      _user = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, _user!.id);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 403 &&
          e.response?.data is Map &&
          (e.response!.data as Map)['error'] == 'email_not_verified') {
        _emailNotVerified = true;
        _unverifiedEmail = (e.response!.data as Map)['email'] as String? ?? email;
        _error = 'email_not_verified';
      } else {
        _error = _parseError(e);
      }
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

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
        'role_id': 3, // Customer
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

  Future<bool> sendOtp(String phone) async {
    _setLoading(true);
    _phoneNotFound = false;
    _wrongApp = false;
    try {
      final res = await _api.post('/api/auth/send-otp', data: {'phone': phone});
      final roleId = (res.data as Map<String, dynamic>)['role_id'] as int?;
      if (roleId == 2) {
        _wrongApp = true;
        _error = 'wrong_app';
        notifyListeners();
        return false;
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        _phoneNotFound = true;
      }
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
  }) async {
    _setLoading(true);
    _phoneNotFound = false;
    _wrongApp = false;
    try {
      final res = await _api.post('/api/auth/verify-otp', data: {'phone': phone, 'otp': otp});
      final body = res.data as Map<String, dynamic>;
      final user = UserModel.fromJson(body['user'] as Map<String, dynamic>);
      if (user.roleId == 2) {
        _wrongApp = true;
        _error = 'wrong_app';
        notifyListeners();
        return false;
      }
      await ApiClient.saveToken(body['token'] as String);
      _user = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, _user!.id);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        _phoneNotFound = true;
      }
      _error = _parseError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

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

  Future<void> logout() async {
    await ApiClient.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    _user = null;
    notifyListeners();
  }

  Future<bool> resendVerificationEmail(String email) async {
    try {
      await _api.post('/api/auth/resend-verification', data: {'email': email});
      return true;
    } catch (_) {
      return false;
    }
  }

  void clearError() {
    _error = null;
    _emailNotVerified = false;
    _unverifiedEmail = null;
    _phoneNotFound = false;
    _wrongApp = false;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is DioException && e.response?.data is Map) {
      final msg = (e.response!.data as Map)['message'] ?? (e.response!.data as Map)['error'];
      if (msg != null) return msg.toString();
    }
    return 'Something went wrong';
  }
}

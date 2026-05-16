import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';

enum SetupAction { goHome, autoSet, pickCentre, onboard }

/// Lightweight model for a centre entry in the switcher.
class UserServiceCentre {
  final String id;
  final String name;
  final String? city;
  final String? category;
  final bool isVerified;
  final String role; // owner | user | mechanic etc.

  const UserServiceCentre({
    required this.id,
    required this.name,
    this.city,
    this.category,
    this.isVerified = false,
    required this.role,
  });

  factory UserServiceCentre.fromJson(Map<String, dynamic> json) =>
      UserServiceCentre(
        id: json['id'] as String,
        name: json['name'] as String,
        city: json['city'] as String?,
        category: json['category'] as String?,
        isVerified: json['is_verified'] as bool? ?? false,
        role: json['role'] as String? ?? 'user',
      );

  String get roleLabel {
    switch (role) {
      case 'owner':    return 'Owner';
      case 'mechanic': return 'Mechanic';
      case 'partner':  return 'Partner';
      default:         return 'Staff';
    }
  }

  String get categoryLabel {
    switch (category) {
      case 'decor_accessories': return 'Decor & Accessories';
      case 'seller':            return 'Seller';
      default:                  return 'Service Centre';
    }
  }
}

class ServiceCentreProvider extends ChangeNotifier {
  List<UserServiceCentre> _centres = [];
  UserServiceCentre? _current;
  bool _loading = false;
  bool _initialized = false;

  List<UserServiceCentre> get centres => _centres;
  UserServiceCentre? get current => _current;
  bool get loading => _loading;
  bool get initialized => _initialized;
  bool get hasMultiple => _centres.length > 1;

  final _api = ApiClient();
  static const _keyServiceCenterId = 'service_center_id';

  /// Call on login / app init — loads all mapped centres + restores last active.
  Future<void> init() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/users/service-centers');
      final list = res.data['centers'] as List;
      _centres = list
          .map((e) => UserServiceCentre.fromJson(e as Map<String, dynamic>))
          .toList();

      // Restore previously active centre from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_keyServiceCenterId);

      if (savedId != null) {
        _current = _centres.where((c) => c.id == savedId).firstOrNull;
      }
      // Fall back to first centre if saved one no longer exists
      _current ??= _centres.isNotEmpty ? _centres.first : null;

      // Persist whichever we resolved
      if (_current != null) {
        await prefs.setString(_keyServiceCenterId, _current!.id);
      }
      _initialized = true;
    } catch (_) {
      // non-fatal — user may have no centres yet
      // Do NOT set _initialized on error so router won't redirect prematurely
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Switch to a different centre — updates SharedPreferences immediately.
  Future<void> switchTo(UserServiceCentre centre) async {
    if (_current?.id == centre.id) return;
    _current = centre;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyServiceCenterId, centre.id);
    notifyListeners();
  }

  /// Called on logout — clears state.
  void clear() {
    _centres = [];
    _current = null;
    _initialized = false;
    notifyListeners();
  }

  /// Called after login/OTP verify.
  /// Returns what the app should do next:
  ///   - [SetupAction.goHome]       — service_center_id already in prefs, nothing to do
  ///   - [SetupAction.autoSet]      — exactly 1 centre found, auto-set + go home
  ///   - [SetupAction.pickCentre]   — 2+ centres, user must pick one
  ///   - [SetupAction.onboard]      — new user, no centres at all
  Future<SetupAction> resolveAfterLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_keyServiceCenterId);

    // Already set — nothing to do
    if (savedId != null && savedId.isNotEmpty) {
      await init(); // refresh list in background
      return SetupAction.goHome;
    }

    // Fetch all mapped centres
    await init();

    if (_centres.isEmpty) {
      _initialized = true; // confirmed empty from server
      notifyListeners();
      return SetupAction.onboard;
    }
    if (_centres.length == 1) {
      await switchTo(_centres.first);
      return SetupAction.autoSet;
    }
    return SetupAction.pickCentre;
  }
}

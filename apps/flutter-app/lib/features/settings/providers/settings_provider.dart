import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';

class SettingsProvider extends ChangeNotifier {
  final _api = ApiClient();
  Map<String, dynamic> _prefs = {};
  bool _loading = false;

  bool get loading => _loading;
  bool get notifyServiceReminder => _prefs['notify_service_reminder'] ?? true;
  bool get notifyBookingUpdates => _prefs['notify_booking_updates'] ?? true;
  bool get notifyPartsExpiry => _prefs['notify_parts_expiry'] ?? true;
  bool get notifyJoinRequests => _prefs['notify_join_requests'] ?? true;
  int get reminderDaysBefore => _prefs['reminder_days_before'] ?? 7;
  String? get defaultVehicleType => _prefs['default_vehicle_type'];
  bool get darkMode => _prefs['dark_mode'] ?? false;

  Future<void> fetch() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/user-preferences');
      _prefs = Map<String, dynamic>.from(res.data as Map);
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> update(Map<String, dynamic> changes) async {
    // Optimistic update
    _prefs.addAll(changes);
    notifyListeners();
    try {
      final res = await _api.put('/api/user-preferences', data: changes);
      _prefs = Map<String, dynamic>.from(res.data as Map);
    } catch (_) {
      // Revert on failure
      await fetch();
    }
    notifyListeners();
  }
}

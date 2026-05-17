import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';

class SettingsProvider extends ChangeNotifier {
  bool _serviceReminder = true;
  bool _bookingUpdates = true;
  bool _partsExpiry = true;
  bool _joinRequests = true;
  int _reminderDays = 7;
  bool _loading = false;

  bool get serviceReminder => _serviceReminder;
  bool get bookingUpdates => _bookingUpdates;
  bool get partsExpiry => _partsExpiry;
  bool get joinRequests => _joinRequests;
  int get reminderDays => _reminderDays;
  bool get loading => _loading;

  final _api = ApiClient();

  Future<void> fetch() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/user-preferences');
      final data = res.data as Map<String, dynamic>;
      _serviceReminder = data['notify_service_reminder'] ?? true;
      _bookingUpdates = data['notify_booking_updates'] ?? true;
      _partsExpiry = data['notify_parts_expiry'] ?? true;
      _joinRequests = data['notify_join_requests'] ?? true;
      _reminderDays = data['reminder_days_before'] ?? 7;
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<void> update(Map<String, dynamic> data) async {
    try {
      await _api.put('/api/user-preferences', data: data);
      if (data.containsKey('notify_service_reminder')) _serviceReminder = data['notify_service_reminder'];
      if (data.containsKey('notify_booking_updates')) _bookingUpdates = data['notify_booking_updates'];
      if (data.containsKey('notify_parts_expiry')) _partsExpiry = data['notify_parts_expiry'];
      if (data.containsKey('notify_join_requests')) _joinRequests = data['notify_join_requests'];
      if (data.containsKey('reminder_days_before')) _reminderDays = data['reminder_days_before'];
      notifyListeners();
    } catch (_) {}
  }
}

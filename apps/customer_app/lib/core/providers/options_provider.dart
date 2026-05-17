import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';

class OptionsProvider extends ChangeNotifier {
  static const String _cachePrefix = 'opt_';
  static const Map<String, String> _defaults = {
    'helpline_number': '919664027924',
    'helpline_whatsapp': 'https://wa.me/919664027924',
    'booking_advance_days': '90',
    'service_due_alert_days': '7',
  };

  final Map<String, String> _options = Map.from(_defaults);

  String get(String key) => _options[key] ?? _defaults[key] ?? '';
  String get helplineNumber => get('helpline_number');
  String get helplineWhatsapp => get('helpline_whatsapp');
  int get bookingAdvanceDays => int.tryParse(get('booking_advance_days')) ?? 90;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _defaults.keys) {
      final cached = prefs.getString('$_cachePrefix$key');
      if (cached != null) _options[key] = cached;
    }
    notifyListeners();
    try {
      final res = await ApiClient().get('/api/options');
      final map = res.data as Map<String, dynamic>;
      for (final entry in map.entries) {
        _options[entry.key] = entry.value.toString();
        await prefs.setString('$_cachePrefix${entry.key}', entry.value.toString());
      }
      notifyListeners();
    } catch (_) {}
  }
}

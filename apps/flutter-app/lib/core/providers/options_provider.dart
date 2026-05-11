import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';

/// Fetches app-wide config from /api/options on startup.
/// Falls back to cached values if offline.
class OptionsProvider extends ChangeNotifier {
  static const String _cachePrefix = 'opt_';

  // Defaults (used if no cache and no network)
  static const Map<String, String> _defaults = {
    'helpline_number': '919664027924',
    'helpline_whatsapp': 'https://wa.me/919664027924',
    'booking_advance_days': '90',
    'service_due_alert_days': '7',
    'invoice_footer_text': 'Thank you for choosing AutoLab!',
    'service_centre_name': 'AutoLab Service Centre',
  };

  final Map<String, String> _options = Map.from(_defaults);

  String get(String key) => _options[key] ?? _defaults[key] ?? '';

  String get helplineNumber => get('helpline_number');
  String get helplineWhatsapp => get('helpline_whatsapp');
  int get bookingAdvanceDays => int.tryParse(get('booking_advance_days')) ?? 90;
  int get serviceDueAlertDays => int.tryParse(get('service_due_alert_days')) ?? 7;
  String get invoiceFooterText => get('invoice_footer_text');
  String get serviceCentreName => get('service_centre_name');

  Future<void> init() async {
    await _loadFromCache();
    await _fetchFromApi();
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _defaults.keys) {
      final cached = prefs.getString('$_cachePrefix$key');
      if (cached != null) _options[key] = cached;
    }
    notifyListeners();
  }

  Future<void> _fetchFromApi() async {
    try {
      final res = await ApiClient().get('/api/options');
      final map = res.data as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      for (final entry in map.entries) {
        _options[entry.key] = entry.value.toString();
        await prefs.setString('$_cachePrefix${entry.key}', entry.value.toString());
      }
      notifyListeners();
    } catch (_) {
      // silently use cached/default values
    }
  }
}

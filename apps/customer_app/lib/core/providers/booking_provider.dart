import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final _api = ApiClient();

  Future<void> fetchBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/bookings');
      final list = res.data['bookings'] as List;
      _bookings = list.map((e) => BookingModel.fromJson(e)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBooking(Map<String, dynamic> data) async {
    try {
      final res = await _api.post('/api/bookings', data: data);
      _bookings.insert(0, BookingModel.fromJson(res.data));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBooking(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('/api/bookings/$id', data: data);
      final updated = BookingModel.fromJson(res.data);
      final idx = _bookings.indexWhere((b) => b.id == id);
      if (idx != -1) _bookings[idx] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelBooking(String id) async {
    try {
      await _api.delete('/api/bookings/$id');
      _bookings.removeWhere((b) => b.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

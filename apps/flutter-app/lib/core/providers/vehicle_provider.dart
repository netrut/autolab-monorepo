import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  List<VehicleModel> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  List<VehicleModel> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final _api = ApiClient();

  Future<void> fetchVehicles() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/vehicles');
      final list = (res.data['vehicles'] as List);
      _vehicles = list.map((e) => VehicleModel.fromJson(e)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addVehicle(Map<String, dynamic> data) async {
    try {
      final res = await _api.post('/api/vehicles', data: data);
      _vehicles.insert(0, VehicleModel.fromJson(res.data));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateVehicle(String id, Map<String, dynamic> data) async {
    try {
      final res = await _api.put('/api/vehicles/$id', data: data);
      final idx = _vehicles.indexWhere((v) => v.id == id);
      if (idx != -1) _vehicles[idx] = VehicleModel.fromJson(res.data);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteVehicle(String id) async {
    try {
      await _api.delete('/api/vehicles/$id');
      _vehicles.removeWhere((v) => v.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Returns {exists: bool, vehicle?: VehicleModel} for reg number lookup.
  Future<Map<String, dynamic>> lookupByReg(String reg) async {
    try {
      final res = await _api.get('/api/vehicles/lookup',
          queryParameters: {'reg': reg.trim().toUpperCase()});
      final data = res.data as Map<String, dynamic>;
      if (data['exists'] == true) {
        final v = data['vehicle'] as Map<String, dynamic>;
        return {
          'exists': true,
          'vehicle': VehicleModel.fromJson(v),
          'ownerId': v['user_id'] as String?,
        };
      }
      return {'exists': false};
    } catch (_) {
      return {'exists': false};
    }
  }

  /// Fetch a single vehicle by id (used for edit pre-fill).
  Future<VehicleModel?> fetchById(String id) async {
    // Check local cache first
    final cached = _vehicles.where((v) => v.id == id).firstOrNull;
    if (cached != null) return cached;
    try {
      final res = await _api.get('/api/vehicles/$id');
      return VehicleModel.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

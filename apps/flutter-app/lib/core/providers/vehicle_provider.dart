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
}

import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/vehicle_service_model.dart';

class VehicleServiceProvider extends ChangeNotifier {
  List<VehicleWithServiceStatus> _vehicles = [];
  List<VehicleServiceModel> _history = [];
  bool _vehiclesLoading = false;
  bool _historyLoading = false;
  String? _error;

  int _dueCount = 0;
  DateTime? _nextServiceDate;
  VehicleServiceModel? _latestService;
  String? _latestServiceVehicleId;

  List<VehicleWithServiceStatus> get vehicles => _vehicles;
  List<VehicleServiceModel> get history => _history;
  bool get vehiclesLoading => _vehiclesLoading;
  bool get historyLoading => _historyLoading;
  String? get error => _error;
  int get dueCount => _dueCount;
  DateTime? get nextServiceDate => _nextServiceDate;
  VehicleServiceModel? get latestService => _latestService;
  String? get latestServiceVehicleId => _latestServiceVehicleId;

  final _api = ApiClient();

  Future<void> fetchVehiclesWithStatus() async {
    _vehiclesLoading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/vehicle-services/vehicles');
      final list = res.data['vehicles'] as List;
      _vehicles = list
          .map((e) => VehicleWithServiceStatus.fromJson(e as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _vehiclesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchServiceHistory(String vehicleId) async {
    _historyLoading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/vehicle-services/$vehicleId');
      final list = res.data['services'] as List;
      _history = list
          .map((e) => VehicleServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _historyLoading = false;
      notifyListeners();
    }
  }

  Future<VehicleServiceModel?> fetchServiceRecord(String id) async {
    try {
      final res = await _api.get('/api/vehicle-services/record/$id');
      return VehicleServiceModel.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchHomeSummary() async {
    try {
      if (_vehicles.isEmpty) await fetchVehiclesWithStatus();
      _dueCount = _vehicles.where((v) => v.serviceStatus == 'due').length;

      final upcoming = _vehicles
          .where((v) => v.serviceStatus == 'upcoming' && v.nextServiceDate != null)
          .map((v) => v.nextServiceDate!)
          .toList()
        ..sort();
      _nextServiceDate = upcoming.isNotEmpty ? upcoming.first : null;

      final res = await _api.get('/api/vehicle-services/latest');
      final data = res.data as Map<String, dynamic>;
      if (data['service'] != null) {
        _latestService = VehicleServiceModel.fromJson(data['service'] as Map<String, dynamic>);
        _latestServiceVehicleId = _latestService!.vehicleId;
      }
    } catch (_) {}
    notifyListeners();
  }
}

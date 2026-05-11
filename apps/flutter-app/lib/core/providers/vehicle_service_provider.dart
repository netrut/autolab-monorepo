import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/vehicle_service_model.dart';
import '../models/service_item_model.dart';

class VehicleServiceProvider extends ChangeNotifier {
  // Vehicles with service status
  List<VehicleWithServiceStatus> _vehicles = [];
  bool _vehiclesLoading = false;
  String? _vehiclesError;

  // Service history for a vehicle
  List<VehicleServiceModel> _history = [];
  bool _historyLoading = false;
  String? _historyError;

  // Catalogue items
  List<CatalogueItem> _catalogue = [];
  bool _catalogueLoading = false;

  // Upcoming services
  List<VehicleServiceModel> _upcoming = [];

  // Home screen summary
  int _dueCount = 0;
  DateTime? _nextServiceDate;
  VehicleServiceModel? _latestService;
  String? _latestServiceVehicleId;
  bool _summaryLoading = false;

  // Form state
  bool _saving = false;
  String? _saveError;

  // Getters
  List<VehicleWithServiceStatus> get vehicles => _vehicles;
  bool get vehiclesLoading => _vehiclesLoading;
  String? get vehiclesError => _vehiclesError;

  List<VehicleServiceModel> get history => _history;
  bool get historyLoading => _historyLoading;
  String? get historyError => _historyError;

  List<CatalogueItem> get catalogue => _catalogue;
  bool get catalogueLoading => _catalogueLoading;

  List<VehicleServiceModel> get upcoming => _upcoming;

  int get dueCount => _dueCount;
  DateTime? get nextServiceDate => _nextServiceDate;
  VehicleServiceModel? get latestService => _latestService;
  String? get latestServiceVehicleId => _latestServiceVehicleId;
  bool get summaryLoading => _summaryLoading;

  bool get saving => _saving;
  String? get saveError => _saveError;

  final _api = ApiClient();

  // ── Fetch vehicles with service status ──────────────────────────────────────

  Future<void> fetchVehiclesWithStatus({String? search, String? status}) async {
    _vehiclesLoading = true;
    _vehiclesError = null;
    notifyListeners();
    try {
      final res = await _api.get('/api/vehicle-services/vehicles', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status,
      });
      final list = res.data['vehicles'] as List;
      _vehicles = list
          .map((e) => VehicleWithServiceStatus.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _vehiclesError = e.toString();
    } finally {
      _vehiclesLoading = false;
      notifyListeners();
    }
  }

  // ── Fetch service history for a vehicle ─────────────────────────────────────

  Future<void> fetchServiceHistory(String vehicleId) async {
    _historyLoading = true;
    _historyError = null;
    notifyListeners();
    try {
      final res = await _api.get('/api/vehicle-services/$vehicleId');
      final list = res.data['services'] as List;
      _history = list
          .map((e) => VehicleServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _historyError = e.toString();
    } finally {
      _historyLoading = false;
      notifyListeners();
    }
  }

  // ── Fetch single service record ──────────────────────────────────────────────

  Future<VehicleServiceModel?> fetchServiceRecord(String id) async {
    try {
      final res = await _api.get('/api/vehicle-services/record/$id');
      return VehicleServiceModel.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // ── Fetch catalogue ──────────────────────────────────────────────────────────

  Future<void> fetchCatalogue({String? vehicleType}) async {
    if (_catalogue.isNotEmpty) return; // already loaded
    _catalogueLoading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/vehicle-services/catalogue', queryParameters: {
        if (vehicleType != null) 'vehicle_type': vehicleType,
      });
      final list = res.data['items'] as List;
      _catalogue = list
          .map((e) => CatalogueItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
    } finally {
      _catalogueLoading = false;
      notifyListeners();
    }
  }

  // Force reload catalogue for a specific vehicle type
  Future<void> reloadCatalogue(String vehicleType) async {
    _catalogue = [];
    await fetchCatalogue(vehicleType: vehicleType);
  }

  // ── Fetch upcoming services ──────────────────────────────────────────────────

  Future<void> fetchUpcoming() async {
    try {
      final res = await _api.get('/api/vehicle-services/upcoming');
      final list = res.data['services'] as List;
      _upcoming = list
          .map((e) => VehicleServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (_) {}
  }

  // ── Fetch home screen summary (due count, next date, latest service) ─────────

  Future<void> fetchHomeSummary() async {
    _summaryLoading = true;
    notifyListeners();
    try {
      // Reuse vehicles-with-status endpoint — already has due/upcoming info
      if (_vehicles.isEmpty) await fetchVehiclesWithStatus();

      // Due count = vehicles with status 'due'
      _dueCount = _vehicles.where((v) => v.serviceStatus == 'due').length;

      // Next service date = earliest upcoming nextServiceDate
      final upcoming = _vehicles
          .where((v) =>
              v.serviceStatus == 'upcoming' && v.nextServiceDate != null)
          .map((v) => v.nextServiceDate!)
          .toList()
        ..sort();
      _nextServiceDate = upcoming.isNotEmpty ? upcoming.first : null;

      // Latest completed service record
      final res = await _api.get('/api/vehicle-services/latest');
      final data = res.data as Map<String, dynamic>;
      if (data['service'] != null) {
        _latestService = VehicleServiceModel.fromJson(
            data['service'] as Map<String, dynamic>);
        _latestServiceVehicleId = _latestService!.vehicleId;
      }
    } catch (_) {
      // non-fatal — home screen degrades gracefully
    } finally {
      _summaryLoading = false;
      notifyListeners();
    }
  }

  // ── Create service record ────────────────────────────────────────────────────

  Future<VehicleServiceModel?> createService(Map<String, dynamic> data) async {
    _saving = true;
    _saveError = null;
    notifyListeners();
    try {
      final res = await _api.post('/api/vehicle-services', data: data);
      final service = VehicleServiceModel.fromJson(res.data as Map<String, dynamic>);
      // Refresh vehicles list to update status badges
      fetchVehiclesWithStatus();
      return service;
    } catch (e) {
      _saveError = _parseError(e);
      return null;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  // ── Update service record ────────────────────────────────────────────────────

  Future<VehicleServiceModel?> updateService(String id, Map<String, dynamic> data) async {
    _saving = true;
    _saveError = null;
    notifyListeners();
    try {
      final res = await _api.put('/api/vehicle-services/record/$id', data: data);
      final service = VehicleServiceModel.fromJson(res.data as Map<String, dynamic>);
      // Update in history list
      final idx = _history.indexWhere((s) => s.id == id);
      if (idx != -1) _history[idx] = service;
      fetchVehiclesWithStatus();
      return service;
    } catch (e) {
      _saveError = _parseError(e);
      return null;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  // ── Delete service record ────────────────────────────────────────────────────

  Future<bool> deleteService(String id) async {
    try {
      await _api.delete('/api/vehicle-services/record/$id');
      _history.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void clearSaveError() {
    _saveError = null;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    final msg = e.toString();
    final match = RegExp(r'"error"\s*:\s*"([^"]+)"').firstMatch(msg);
    if (match != null) return match.group(1)!;
    return msg.replaceAll('Exception: ', '');
  }
}

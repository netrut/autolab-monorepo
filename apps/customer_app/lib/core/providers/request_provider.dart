import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/request_model.dart';

class RequestProvider extends ChangeNotifier {
  List<RequestModel> _received = [];
  List<RequestModel> _sent = [];
  int _pendingCount = 0;
  bool _loading = false;
  String? _error;

  List<RequestModel> get received => _received;
  List<RequestModel> get sent => _sent;
  int get pendingCount => _pendingCount;
  bool get loading => _loading;
  String? get error => _error;

  final _api = ApiClient();

  Future<void> fetchReceived() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/requests/received');
      _received = (res.data['requests'] as List)
          .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSent() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/requests/sent');
      _sent = (res.data['requests'] as List)
          .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPendingCount() async {
    try {
      final res = await _api.get('/api/requests/pending-count');
      _pendingCount = (res.data['count'] as int?) ?? 0;
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> sendVehicleAccessRequest({
    required String vehicleId,
    required String toUserId,
    String? message,
  }) async {
    try {
      final res = await _api.post('/api/requests', data: {
        'type': RequestType.vehicleAccess.value,
        'to_user_id': toUserId,
        'entity_type': 'vehicle',
        'entity_id': vehicleId,
        'role': 'user',
        if (message != null) 'message': message,
      });
      final req = RequestModel.fromJson(res.data as Map<String, dynamic>);
      _sent.insert(0, req);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> accept(String id) async => _updateStatus(id, 'accept', _received);
  Future<bool> reject(String id) async => _updateStatus(id, 'reject', _received);
  Future<bool> cancel(String id) async => _updateStatus(id, 'cancel', _sent);

  Future<bool> _updateStatus(String id, String action, List<RequestModel> list) async {
    try {
      final res = await _api.put('/api/requests/$id/$action');
      final updated = RequestModel.fromJson(res.data as Map<String, dynamic>);
      final idx = list.indexWhere((r) => r.id == id);
      if (idx != -1) list[idx] = updated;
      await fetchPendingCount();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

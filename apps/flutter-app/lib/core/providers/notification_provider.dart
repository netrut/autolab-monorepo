import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _loading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get loading => _loading;
  String? get error => _error;

  final _api = ApiClient();

  Future<void> fetchNotifications() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await _api.get('/api/notifications');
      final data = res.data as Map<String, dynamic>;
      _notifications = (data['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _unreadCount = (data['unread_count'] as int?) ?? 0;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final res = await _api.get('/api/notifications/unread-count');
      _unreadCount = (res.data['count'] as int?) ?? 0;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> markRead(String id) async {
    try {
      await _api.put('/api/notifications/$id/read');
      final idx = _notifications.indexWhere((n) => n.id == id);
      if (idx != -1 && !_notifications[idx].isRead) {
        _notifications[idx] = _notifications[idx].copyWith(
            isRead: true, readAt: DateTime.now());
        if (_unreadCount > 0) _unreadCount--;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _api.put('/api/notifications/read-all');
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
          .toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (_) {}
  }
}

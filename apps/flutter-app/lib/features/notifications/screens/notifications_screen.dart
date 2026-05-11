import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/models/notification_model.dart';
import '../../../core/providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  // 7.7 — deep-link navigation on notification tap
  void _onTap(BuildContext context, NotificationModel n) {
    // Mark as read first
    context.read<NotificationProvider>().markRead(n.id);

    switch (n.type) {
      case NotificationType.request:
        context.push('/requests');
      case NotificationType.bookingUpdate:
        context.push('/bookings');
      case NotificationType.serviceDue:
      case NotificationType.serviceComplete:
        if (n.entityId != null) {
          context.push('/service/detail/${n.entityId}');
        } else {
          context.push('/services');
        }
      case NotificationType.invoice:
        if (n.entityId != null) {
          // entityId is invoice.id — navigate via service lookup
          // We push to invoice screen using the service_id stored in entityId
          context.push('/invoice/${n.entityId}');
        }
      case NotificationType.system:
        break; // no navigation for system notifications
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600)),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllRead(),
              child: Text('Mark all read',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2F7DE1))),
            ),
        ],
      ),
      body: provider.loading && provider.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications_none_outlined,
                          size: 56, color: Color(0xFFBDBDBD)),
                      const SizedBox(height: 12),
                      Text('No notifications yet',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: const Color(0xFF7A7A7A))),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => provider.fetchNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: provider.notifications.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (_, i) => _NotificationTile(
                      notification: provider.notifications[i],
                      onTap: () => _onTap(context, provider.notifications[i]),
                    ),
                  ),
                ),
    );
  }
}

// ── Notification tile ─────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile(
      {required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.request:         return Icons.swap_horiz_outlined;
      case NotificationType.serviceDue:      return Icons.build_outlined;
      case NotificationType.bookingUpdate:   return Icons.calendar_today_outlined;
      case NotificationType.serviceComplete: return Icons.check_circle_outline;
      case NotificationType.invoice:         return Icons.receipt_long_outlined;
      case NotificationType.system:          return Icons.info_outline;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.request:         return const Color(0xFF2F7DE1);
      case NotificationType.serviceDue:      return const Color(0xFFDA8A1D);
      case NotificationType.bookingUpdate:   return const Color(0xFF7B61FF);
      case NotificationType.serviceComplete: return const Color(0xFF2F9E56);
      case NotificationType.invoice:         return const Color(0xFF1B1F26);
      case NotificationType.system:          return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread
            ? const Color(0xFFF0F7FF)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: _iconColor, size: 20),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: isUnread
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: const Color(0xFF1A1A1A)),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF2F7DE1),
                              shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: const Color(0xFF5A5A5A)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (notification.sentAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _timeAgo(notification.sentAt!),
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: const Color(0xFFAAAAAA)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM').format(dt);
  }
}

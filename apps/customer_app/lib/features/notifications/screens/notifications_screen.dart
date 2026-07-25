import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/models/notification_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/app_back_button.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<NotificationProvider>().fetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const AppBackButton(),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllRead(),
              child: Text('Mark all read', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.primaryBlue)),
            ),
        ],
      ),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
              ? const EmptyState(icon: Icons.notifications_outlined, title: 'No Notifications', subtitle: 'You\'re all caught up!')
              : RefreshIndicator(
                  onRefresh: () => provider.fetchNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _NotifCard(notif: provider.notifications[i]),
                  ),
                ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationModel notif;
  const _NotifCard({required this.notif});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!notif.isRead) context.read<NotificationProvider>().markRead(notif.id);
        _navigateToTarget(context);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? AppTheme.surface : AppTheme.primaryBlue.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: notif.isRead ? AppTheme.border : AppTheme.primaryBlue.withOpacity(0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_icon(notif.type), size: 20, color: notif.isRead ? AppTheme.secondaryText : AppTheme.primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(notif.body, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (notif.sentAt != null) ...[
                    const SizedBox(height: 4),
                    Text(_timeAgo(notif.sentAt!), style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.secondaryText)),
                  ],
                ],
              ),
            ),
            if (!notif.isRead)
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primaryBlue, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }

  IconData _icon(NotificationType type) {
    switch (type) {
      case NotificationType.serviceDue: return Icons.build_outlined;
      case NotificationType.bookingUpdate: return Icons.calendar_today_outlined;
      case NotificationType.request: return Icons.people_outline;
      case NotificationType.invoice: return Icons.receipt_long_outlined;
      case NotificationType.serviceComplete: return Icons.check_circle_outline;
      default: return Icons.info_outline;
    }
  }

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${d.day}/${d.month}/${d.year}';
  }

  void _navigateToTarget(BuildContext context) {
    switch (notif.type) {
      case NotificationType.serviceDue:
        if (notif.entityId != null) context.push('/service-history');
        break;
      case NotificationType.bookingUpdate:
        if (notif.entityId != null) context.push('/bookings/${notif.entityId}');
        break;
      case NotificationType.request:
        context.push('/requests');
        break;
      case NotificationType.invoice:
        if (notif.entityId != null) context.push('/invoices/${notif.entityId}');
        break;
      case NotificationType.serviceComplete:
        if (notif.entityId != null) context.push('/service-detail/${notif.entityId}');
        break;
      default:
        break;
    }
  }
}

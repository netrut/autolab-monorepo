import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/models/booking_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/status_badge.dart';

class BookingDetailScreen extends StatelessWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final booking = provider.bookings.where((b) => b.id == bookingId).firstOrNull;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Booking Details'), leading: const AppBackButton()),
      body: booking == null
          ? const Center(child: Text('Booking not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(booking.vehicleDisplayName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                            StatusBadge(label: booking.status ?? 'pending', type: _statusType(booking.status)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InfoRow('Service Type', booking.serviceType),
                        _InfoRow('Date', _formatDate(booking.bookingDate)),
                        if (booking.notes != null && booking.notes!.isNotEmpty)
                          _InfoRow('Notes', booking.notes!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Timeline
                  Text('Status Timeline', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _StatusTimeline(currentStatus: booking.status ?? 'pending'),

                  // Cancel button
                  if (booking.status == 'pending' || booking.status == 'confirmed') ...[
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _confirmCancel(context, booking.id),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.error,
                          side: const BorderSide(color: AppTheme.error),
                        ),
                        child: const Text('Cancel Booking'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  void _confirmCancel(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingProvider>().cancelBooking(id);
              Navigator.pop(context);
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  StatusType _statusType(String? s) {
    switch (s) {
      case 'confirmed': return StatusType.info;
      case 'completed': return StatusType.success;
      case 'cancelled': return StatusType.error;
      default: return StatusType.warning;
    }
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final String currentStatus;
  const _StatusTimeline({required this.currentStatus});

  static const _steps = ['pending', 'confirmed', 'in-progress', 'completed'];
  static const _labels = ['Pending', 'Confirmed', 'In Progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final currentIdx = _steps.indexOf(currentStatus);
    final isCancelled = currentStatus == 'cancelled';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final isCompleted = !isCancelled && i <= currentIdx;
          final isLast = i == _steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppTheme.success : AppTheme.border,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Center(child: Text('${i + 1}', style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText))),
                  ),
                  if (!isLast)
                    Container(width: 2, height: 28, color: isCompleted ? AppTheme.success.withOpacity(0.3) : AppTheme.border),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  _labels[i],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                    color: isCompleted ? AppTheme.primaryText : AppTheme.secondaryText,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

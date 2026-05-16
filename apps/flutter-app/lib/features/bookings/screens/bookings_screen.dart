import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/booking_model.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/options_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/empty_state.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final scId = prefs.getString('service_center_id');
      if (!mounted) return;
      if (scId == null || scId.isEmpty) {
        context.go('/service-centers/onboard');
        return;
      }
      context.read<BookingProvider>().fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('MY BOOKINGS')),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B1F26),
        onPressed: () => context.push('/bookings/create'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          // 8.5 — error state with retry
          : provider.error != null && provider.bookings.isEmpty
              ? EmptyState(
                  icon: Icons.error_outline,
                  message: 'Failed to load bookings',
                  subMessage: 'Check your connection and try again',
                  retryLabel: 'Retry',
                  onRetry: () => provider.fetchBookings(),
                )
              : provider.bookings.isEmpty
                  // 8.3 — improved empty state
                  ? EmptyState(
                      icon: Icons.calendar_today_outlined,
                      message: 'No bookings yet',
                      subMessage: 'Book a service to get started',
                      actionLabel: 'Book a Service',
                      onAction: () => context.push('/bookings/create'),
                    )
                  : RefreshIndicator(
                      onRefresh: () => provider.fetchBookings(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.bookings.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, i) =>
                            _BookingCard(booking: provider.bookings[i]),
                      ),
                    ),
    );
  }
}

// ── Booking card ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case 'confirmed':
        return const Color(0xFF249689);
      case 'cancelled':
        return const Color(0xFFFF5963);
      case 'completed':
        return const Color(0xFF4B39EF);
      case 'in_progress':
        return const Color(0xFF2F7DE1);
      default:
        return const Color(0xFFDA8A1D); // pending
    }
  }

  // 3.5 — update booking bottom sheet
  void _showUpdateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _UpdateBookingSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row: service type + status badge ─────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 3.7 — vehicle name
                    Text(
                      booking.vehicleDisplayName,
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _serviceTypeLabel(booking.serviceType),
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF7A7A7A)),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(booking.status),
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Date ────────────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: Color(0xFF7A7A7A)),
              const SizedBox(width: 6),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(booking.bookingDate),
                style: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFF7A7A7A)),
              ),
            ],
          ),

          if (booking.notes != null && booking.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(booking.notes!,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: const Color(0xFF9E9E9E))),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // ── Action buttons (3.5 + 3.6) ──────────────────────────────────
          Row(
            children: [
              // 3.6 — Go to Service Form
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push('/service/form/${booking.vehicleId}'),
                  icon: const Icon(Icons.build_outlined, size: 15),
                  label: const Text('Service Form'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2F7DE1),
                    side: const BorderSide(color: Color(0xFF2F7DE1)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle:
                        GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // 3.5 — Update booking
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUpdateSheet(context),
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1F26),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle:
                        GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(String? s) {
    switch (s) {
      case 'confirmed': return 'CONFIRMED';
      case 'cancelled': return 'CANCELLED';
      case 'completed': return 'COMPLETED';
      case 'in_progress': return 'IN PROGRESS';
      default: return 'PENDING';
    }
  }

  String _serviceTypeLabel(String s) {
    const labels = {
      'general': 'General Service',
      'major': 'Major Service',
      'emergency': 'Emergency Repair',
    };
    return labels[s] ?? s;
  }
}

// ── Update booking bottom sheet (3.5) ─────────────────────────────────────────

class _UpdateBookingSheet extends StatefulWidget {
  final BookingModel booking;
  const _UpdateBookingSheet({required this.booking});

  @override
  State<_UpdateBookingSheet> createState() => _UpdateBookingSheetState();
}

class _UpdateBookingSheetState extends State<_UpdateBookingSheet> {
  late String _status;
  late String _serviceType;
  late DateTime _bookingDate;
  final _notesCtrl = TextEditingController();

  static const _statuses = [
    ('pending', 'Pending'),
    ('confirmed', 'Confirmed'),
    ('in_progress', 'In Progress'),
    ('completed', 'Completed'),
    ('cancelled', 'Cancelled'),
  ];

  static const _serviceTypeLabels = {
    'general': 'General Service',
    'major': 'Major Service',
    'emergency': 'Emergency Repair',
  };

  @override
  void initState() {
    super.initState();
    _status = widget.booking.status ?? 'pending';
    // Normalize legacy service types (e.g. 'oil change', 'General Service')
    // to the unified set: general | major | emergency
    _serviceType = _normalizeServiceType(widget.booking.serviceType);
    _bookingDate = widget.booking.bookingDate;
    _notesCtrl.text = widget.booking.notes ?? '';
  }

  /// Maps any legacy or free-text service type to the nearest unified value.
  static String _normalizeServiceType(String raw) {
    const valid = {'general', 'major', 'emergency'};
    final lower = raw.toLowerCase().trim();
    if (valid.contains(lower)) return lower;
    // Map common legacy values
    if (lower.contains('major') || lower.contains('full')) return 'major';
    if (lower.contains('emergency') || lower.contains('urgent')) return 'emergency';
    // Everything else (oil change, tire rotation, brake, etc.) → general
    return 'general';
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final advanceDays = context.read<OptionsProvider>().bookingAdvanceDays;
    final picked = await showDatePicker(
      context: context,
      initialDate: _bookingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: advanceDays)),
    );
    if (!mounted || picked == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_bookingDate),
    );
    if (!mounted || time == null) return;
    setState(() {
      _bookingDate = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    final provider = context.read<BookingProvider>();
    final ok = await provider.updateBooking(widget.booking.id, {
      'status': _status,
      'service_type': _serviceType,
      'booking_date': _bookingDate.toIso8601String(),
      'notes': _notesCtrl.text.trim(),
    });
    if (!mounted) return;
    Navigator.pop(context);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error ?? 'Update failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Update Booking',
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),

          // Status
          Text('Status',
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statuses.map((s) {
              final selected = _status == s.$1;
              return GestureDetector(
                onTap: () => setState(() => _status = s.$1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1B1F26)
                        : const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(s.$2,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF5A5A5A))),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Service type
          Text('Service Type',
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _serviceType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
              ),
            ),
            items: VehicleServiceModel.serviceTypes
                .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(_serviceTypeLabels[s] ?? s)))
                .toList(),
            onChanged: (v) => setState(() => _serviceType = v!),
          ),
          const SizedBox(height: 16),

          // Date
          Text('Date & Time',
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E3E7)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: Color(0xFF57636C)),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(_bookingDate),
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: const Color(0xFF14181B)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notes
          TextFormField(
            controller: _notesCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Notes',
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B1F26),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text('Save Changes',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

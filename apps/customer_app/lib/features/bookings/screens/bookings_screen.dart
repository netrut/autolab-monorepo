import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/models/booking_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/status_badge.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<BookingProvider>().fetchBookings());
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Bookings'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.secondaryText,
          indicatorColor: AppTheme.primaryBlue,
          labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Completed'), Tab(text: 'Cancelled')],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/bookings/create'),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabCtrl,
              children: [
                _BookingList(bookings: provider.bookings.where((b) => b.status == 'pending' || b.status == 'confirmed').toList()),
                _BookingList(bookings: provider.bookings.where((b) => b.status == 'completed').toList()),
                _BookingList(bookings: provider.bookings.where((b) => b.status == 'cancelled').toList()),
              ],
            ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  const _BookingList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyState(icon: Icons.calendar_today_outlined, title: 'No Bookings', subtitle: 'Your bookings will appear here');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _BookingCard(booking: bookings[i]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isPending = booking.status == 'pending' || booking.status == 'confirmed';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(booking.vehicleDisplayName, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
              StatusBadge(label: booking.status ?? 'pending', type: _statusType(booking.status)),
            ],
          ),
          const SizedBox(height: 6),
          Text(booking.serviceType, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDate(booking.bookingDate), style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
              if (isPending)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _showEditSheet(context, booking),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('Edit', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _confirmCancel(context, booking.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.error)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, BookingModel booking) {
    String serviceType = booking.serviceType;
    DateTime date = booking.bookingDate;
    final notesCtrl = TextEditingController(text: booking.notes ?? '');

    final serviceTypes = ['General Service', 'Oil Change', 'Major Service', 'Brake Service', 'Tyre Change', 'Other'];
    // Ensure current value is in the list
    if (!serviceTypes.contains(serviceType)) {
      serviceTypes.add(serviceType);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text('Edit Booking', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: serviceType,
                decoration: const InputDecoration(labelText: 'Service Type'),
                items: serviceTypes
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setSheetState(() => serviceType = v ?? serviceType),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(context: ctx, initialDate: date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                  if (picked != null) setSheetState(() => date = picked);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(text: '${date.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][date.month-1]} ${date.year}'),
                    decoration: const InputDecoration(labelText: 'Booking Date', suffixIcon: Icon(Icons.calendar_today, size: 18)),
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 2),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final provider = ctx.read<BookingProvider>();
                    await provider.updateBooking(booking.id, {
                      'service_type': serviceType,
                      'booking_date': date.toIso8601String(),
                      'notes': notesCtrl.text.trim(),
                    });
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Booking?', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to cancel this booking?', style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('No', style: GoogleFonts.poppins(color: AppTheme.secondaryText))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingProvider>().cancelBooking(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Yes, Cancel', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
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

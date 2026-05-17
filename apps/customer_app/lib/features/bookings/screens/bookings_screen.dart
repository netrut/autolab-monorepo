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
          Text(_formatDate(booking.bookingDate), style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
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

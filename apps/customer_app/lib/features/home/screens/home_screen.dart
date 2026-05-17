import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/options_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/service_center_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ServiceCenterModel> _nearbyCentres = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles();
      context.read<VehicleServiceProvider>().fetchHomeSummary();
      context.read<NotificationProvider>().fetchUnreadCount();
      _fetchNearbyCentres();
    });
  }

  Future<void> _fetchNearbyCentres() async {
    try {
      final res = await ApiClient().get('/api/service-centers');
      final list = (res.data['service_centers'] ?? res.data['serviceCenters'] ?? []) as List;
      if (mounted) setState(() => _nearbyCentres = list.take(6).map((e) => ServiceCenterModel.fromJson(e as Map<String, dynamic>)).toList());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final vehicles = context.watch<VehicleProvider>();
    final svc = context.watch<VehicleServiceProvider>();
    final notifs = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        title: Text('AUTOLAB', style: GoogleFonts.interTight(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
        actions: [
          GestureDetector(
            onTap: () => context.push('/notifications'),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_outlined, size: 24),
                  if (notifs.unreadCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: AppTheme.error, shape: BoxShape.circle),
                        child: Text(
                          notifs.unreadCount > 9 ? '9+' : '${notifs.unreadCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            context.read<VehicleProvider>().fetchVehicles(),
            context.read<VehicleServiceProvider>().fetchHomeSummary(),
            context.read<NotificationProvider>().fetchUnreadCount(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Hello, ${auth.user?.displayName?.split(' ').first ?? 'there'} 👋',
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.primaryText),
              ),
              const SizedBox(height: 2),
              Text('Keep your ride in top shape', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
              const SizedBox(height: 20),

              // Vehicle Summary Card
              _VehicleSummaryCard(vehicles: vehicles, svc: svc),
              const SizedBox(height: 24),

              // Quick Actions
              Text('QUICK ACTIONS', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.secondaryText, letterSpacing: 1.0)),
              const SizedBox(height: 12),
              _QuickActionsGrid(),
              const SizedBox(height: 24),

              // Upcoming Services
              if (svc.dueCount > 0) ...[
                Text('UPCOMING SERVICES', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.secondaryText, letterSpacing: 1.0)),
                const SizedBox(height: 12),
                ...svc.vehicles.where((v) => v.serviceStatus == 'due').take(2).map(
                  (v) => _UpcomingServiceCard(
                    vehicleName: v.displayName,
                    nextDate: v.nextServiceDate,
                    onBook: () => context.push('/bookings/create?vehicleId=${v.id}'),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Recent Service
              if (svc.latestService != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RECENT SERVICE', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.secondaryText, letterSpacing: 1.0)),
                    GestureDetector(
                      onTap: () => context.push('/service-history'),
                      child: Text('View All', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryBlue)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _RecentServiceCard(service: svc.latestService!),
                const SizedBox(height: 24),
              ],

              // Nearby Service Centres
              if (_nearbyCentres.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SERVICE CENTRES', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.secondaryText, letterSpacing: 1.0)),
                    GestureDetector(
                      onTap: () => context.push('/search'),
                      child: Text('See All', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryBlue)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _nearbyCentres.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => _NearbyCentreCard(centre: _nearbyCentres[i]),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Contact
              _ContactCard(
                onTap: () async {
                  final options = context.read<OptionsProvider>();
                  final url = options.helplineWhatsapp.isNotEmpty ? options.helplineWhatsapp : 'https://wa.me/${options.helplineNumber}';
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleSummaryCard extends StatelessWidget {
  final VehicleProvider vehicles;
  final VehicleServiceProvider svc;
  const _VehicleSummaryCard({required this.vehicles, required this.svc});

  @override
  Widget build(BuildContext context) {
    if (vehicles.vehicles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: Column(
          children: [
            Icon(Icons.directions_car_outlined, size: 40, color: AppTheme.secondaryText.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text('Add Your First Vehicle', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Start tracking your service history', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              height: 40,
              child: ElevatedButton(
                onPressed: () => context.push('/vehicles/add'),
                child: const Text('Add Vehicle', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      );
    }

    final v = vehicles.vehicles.first;
    final status = svc.vehicles.where((sv) => sv.id == v.id).firstOrNull;
    final statusLabel = status?.serviceStatus ?? 'no_service';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(v.isCar ? Icons.directions_car : Icons.two_wheeler, size: 20, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(v.displayName, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              ),
              _StatusChip(status: statusLabel),
            ],
          ),
          if (v.registrationNumber != null) ...[
            const SizedBox(height: 4),
            Text(v.registrationNumber!, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
          ],
          const Divider(height: 24),
          Row(
            children: [
              _InfoItem(label: 'Next Service', value: svc.nextServiceDate != null ? _formatDate(svc.nextServiceDate!) : 'Not set'),
              const SizedBox(width: 24),
              _InfoItem(label: 'Total Vehicles', value: '${vehicles.vehicles.length}'),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/vehicles'),
              child: Text('View All →', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryBlue)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    String label;
    switch (status) {
      case 'due':
        bg = AppTheme.error.withOpacity(0.1);
        fg = AppTheme.error;
        label = 'Overdue';
      case 'upcoming':
        bg = AppTheme.warning.withOpacity(0.1);
        fg = const Color(0xFFB45309);
        label = 'Due Soon';
      case 'completed':
        bg = AppTheme.success.withOpacity(0.1);
        fg = AppTheme.success;
        label = 'All Good';
      default:
        bg = AppTheme.border;
        fg = AppTheme.secondaryText;
        label = 'No Service';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
        Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QA(Icons.directions_car_outlined, 'My Vehicles', '/vehicles'),
      _QA(Icons.calendar_today_outlined, 'Book Service', '/bookings/create'),
      _QA(Icons.history_outlined, 'History', '/service-history'),
      _QA(Icons.receipt_long_outlined, 'Invoices', '/invoices'),
    ];

    return Row(
      children: actions.map((a) => Expanded(
        child: GestureDetector(
          onTap: () => context.push(a.route),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
            child: Column(
              children: [
                Icon(a.icon, size: 24, color: AppTheme.primaryBlue),
                const SizedBox(height: 8),
                Text(a.label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }
}

class _QA {
  final IconData icon;
  final String label;
  final String route;
  const _QA(this.icon, this.label, this.route);
}

class _UpcomingServiceCard extends StatelessWidget {
  final String vehicleName;
  final DateTime? nextDate;
  final VoidCallback onBook;
  const _UpcomingServiceCard({required this.vehicleName, this.nextDate, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final daysLeft = nextDate != null ? nextDate!.difference(DateTime.now()).inDays : 0;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicleName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text(daysLeft > 0 ? 'Due in $daysLeft days' : 'Overdue', style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
              ],
            ),
          ),
          TextButton(
            onPressed: onBook,
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
            child: Text('Book', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
          ),
        ],
      ),
    );
  }
}

class _RecentServiceCard extends StatelessWidget {
  final dynamic service;
  const _RecentServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(service.vehicleDisplayName ?? 'Service', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
              Text('₹${service.totalCost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
            ],
          ),
          const SizedBox(height: 4),
          Text(_formatDate(service.serviceDate), style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
          if (service.items.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: service.items.take(3).map<Widget>((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(6)),
                child: Text(item.itemName, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _ContactCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ContactCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need Help?', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("We're here to assist you", style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 34,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.chat_outlined, size: 16),
                    label: Text('WhatsApp Us', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.support_agent_outlined, size: 48, color: AppTheme.secondaryText.withOpacity(0.3)),
        ],
      ),
    );
  }
}

class _NearbyCentreCard extends StatelessWidget {
  final ServiceCenterModel centre;
  const _NearbyCentreCard({required this.centre});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search/${centre.id}'),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.store_outlined, size: 16, color: AppTheme.primaryBlue),
            ),
            const SizedBox(height: 8),
            Text(centre.name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            if (centre.rating != null && centre.rating! > 0)
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: AppTheme.warning),
                  const SizedBox(width: 2),
                  Text(centre.rating!.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

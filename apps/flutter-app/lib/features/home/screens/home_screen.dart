import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/options_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles();
      context.read<VehicleServiceProvider>().fetchHomeSummary();
      context.read<NotificationProvider>().fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final vehicles = context.watch<VehicleProvider>();
    final options = context.watch<OptionsProvider>();
    final svc = context.watch<VehicleServiceProvider>();
    final notifs = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        iconTheme: const IconThemeData(color: Color(0xFF3E3E3E)),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'AUTOLAB',
          style: GoogleFonts.interTight(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF232323),
              letterSpacing: 1.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 12, 6),
            child: GestureDetector(
              onTap: () => context.push('/notifications'),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F1F1F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 22),
                  ),
                  // 7.6 — unread badge
                  if (notifs.unreadCount > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: Color(0xFFFF5963),
                            shape: BoxShape.circle),
                        child: Text(
                          notifs.unreadCount > 9
                              ? '9+'
                              : '${notifs.unreadCount}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 2, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${auth.user?.displayName ?? 'Dear'}',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF1E1E1E)),
                    ),
                    Text('Your Automotive Service Hub',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7A7A7A))),
                  ],
                ),
              ),

              // Hero banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDCDCDC)),
                ),
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your one stop solution for all\nyour automotive needs',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF232323)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/header-car.png',
                        height: 106,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox(height: 106),
                      ),
                    ),
                    // Vehicles row
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E9E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/four-wheeler.png',
                                  height: 38,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/carApp2.png',
                                  height: 38,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.push('/vehicles/add'),
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFFD4D4D4)),
                                ),
                                child: Center(
                                  child: Text('+ Add Vehicle',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2A2A2A))),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              Text('SERVICE & MAINTENANCE',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF616161),
                      letterSpacing: 1.0)),
              const SizedBox(height: 8),

              // Service summary cards
              Row(
                children: [
                  Expanded(
                    child: _ServiceCard(
                      icon: Icons.handyman_outlined,
                      title: 'Due Services',
                      // 4.4 — real due count
                      subtitle: svc.dueCount > 0
                          ? '${svc.dueCount} Service${svc.dueCount == 1 ? '' : 's'} Pending'
                          : 'All up to date',
                      onTap: () => context.push('/services?status=due'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ServiceCard(
                      icon: Icons.calendar_month_outlined,
                      title: 'Next Service',
                      // 4.5 — real next service date
                      subtitle: svc.nextServiceDate != null
                          ? _formatDate(svc.nextServiceDate!)
                          : 'Not scheduled',
                      onTap: () => context.push('/services?status=upcoming'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ServiceCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'My Bookings',
                      subtitle: 'View all bookings',
                      onTap: () => context.push('/bookings'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ServiceCard(
                      icon: Icons.store_outlined,
                      title: 'Service Centers',
                      subtitle: 'Find near you',
                      onTap: () => context.push('/service-centers'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text('Service Update',
                  style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF202020))),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE3E3E3)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 16,
                        offset: Offset(0, 5))
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 4.6 — show latest service vehicle name
                            svc.latestService != null
                                ? svc.latestService!.vehicleDisplayName.isNotEmpty
                                    ? svc.latestService!.vehicleDisplayName
                                    : 'Latest Service'
                                : 'Service Update',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF232323))),
                          const SizedBox(height: 10),
                          // 4.6 — show latest service items or static fallback
                          if (svc.latestService != null &&
                              svc.latestService!.items.isNotEmpty)
                            ...svc.latestService!.items.take(4).map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('•  ${item.itemName}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF3B3B3B))),
                              ),
                            )
                          else ...[
                            Text('•  Parts Replaced',
                                style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF3B3B3B))),
                            const SizedBox(height: 4),
                            Text('•  Oil Changed',
                                style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF3B3B3B))),
                            const SizedBox(height: 4),
                            Text('•  Next Due Updated',
                                style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF3B3B3B))),
                          ],
                          const SizedBox(height: 14),
                          ElevatedButton(
                            // 4.7 — route to service form for most recent vehicle
                            onPressed: () {
                              final vehicleId = svc.latestServiceVehicleId;
                              if (vehicleId != null) {
                                context.push('/service/form/$vehicleId');
                              } else {
                                context.push('/services');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B1F26),
                              minimumSize: const Size(0, 36),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Text('Update Service',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          height: 210,
                          child: Image.asset(
                            'assets/images/service_update_img.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.centerRight,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.build_circle_outlined,
                                size: 80,
                                color: Color(0xFFAAAAAA)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text('Add New Vehicle',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF202020))),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _VehicleTypeCard(
                      imagePath: 'assets/images/four-wheeler.png',
                      title: '+ Add Four-Wheeler',
                      subtitle: 'Car, SUV',
                      onTap: () => context.push('/vehicles/add?type=car'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _VehicleTypeCard(
                      imagePath: 'assets/images/two-wheeler.png',
                      title: '+ Add Two-Wheeler',
                      subtitle: 'Bike, Scooter',
                      onTap: () => context.push('/vehicles/add?type=bike'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text('Contact Us',
                  style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF202020))),
              const SizedBox(height: 8),
              _ContactCard(onTap: () async {
                final url = options.helplineWhatsapp.isNotEmpty
                    ? options.helplineWhatsapp
                    : 'https://wa.me/${options.helplineNumber}';
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), blurRadius: 18, offset: Offset(0, 6))
          ],
        ),
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1F1F1F), size: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFF7A7A7A),
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleTypeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _VehicleTypeCard(
      {required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0E000000), blurRadius: 16, offset: Offset(0, 6))
          ],
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          children: [
            // Fallback icon if image not found
            SizedBox(
              height: 72,
              child: Image.asset(imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.directions_car,
                      size: 48,
                      color: Color(0xFF1F1F1F))),
            ),
            const SizedBox(height: 12),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: const Color(0xFF808080))),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ContactCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0E000000), blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We're here to assist you.\nPlease contact us, and our\nrepresentative would be happy\nto assist you.",
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: const Color(0xFF303030)),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1F26),
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Call Now',
                      style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Image.asset('assets/images/contact-us.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.support_agent, size: 60)),
          ),
        ],
      ),
    );
  }
}

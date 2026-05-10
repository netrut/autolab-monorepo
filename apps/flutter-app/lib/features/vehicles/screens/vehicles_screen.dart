import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<VehicleProvider>();

    final filtered = provider.vehicles.where((v) {
      final q = _searchController.text.toLowerCase().trim();
      final matchSearch = q.isEmpty ||
          v.displayName.toLowerCase().contains(q) ||
          (v.registrationNumber?.toLowerCase().contains(q) ?? false);
      final matchType = _selectedType == null ||
          v.vehicleType.toLowerCase() == _selectedType;
      return matchSearch && matchType;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: _buildDrawer(context, auth),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        iconTheme: const IconThemeData(color: Color(0xFF3E3E3E)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF3E3E3E)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'MY VEHICLES',
          style: GoogleFonts.interTight(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF232323),
              letterSpacing: 1.0),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B1F26),
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar + filter icon
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCDCDC)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(Icons.search_rounded,
                              color: Color(0xFF8B8B8B), size: 22),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search vehicle number',
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF8A8A8A)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Color(0xFF7A7A7A),
                                            size: 20),
                                        onPressed: () =>
                                            _searchController.clear(),
                                      )
                                    : null,
                              ),
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2B2B2B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter icon button
                  GestureDetector(
                    onTap: () => _showFilterSheet(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _selectedType != null
                            ? const Color(0xFF1F1F1F)
                            : const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCDCDC)),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: _selectedType != null
                            ? Colors.white
                            : const Color(0xFF5A5A5A),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Active filter chip
              if (_selectedType != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedType == 'car' ? 'Car' : 'Bike',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedType = null),
                              child: const Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // List
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? Center(
                            child: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.directions_car_outlined,
                                    size: 64, color: Color(0xFFBDBDBD)),
                                const SizedBox(height: 16),
                                Text(
                                    provider.vehicles.isEmpty
                                        ? 'No vehicles added yet'
                                        : 'No vehicles match your search',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: const Color(0xFF7A7A7A))),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () =>
                                      context.push('/vehicles/add'),
                                  child: const Text('Add Vehicle'),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) =>
                                _VehicleCard(vehicle: filtered[i]),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Type',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                _filterOption('All', null),
                const SizedBox(width: 10),
                _filterOption('Car', 'car'),
                const SizedBox(width: 10),
                _filterOption('Bike', 'bike'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String label, String? type) {
    final selected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = type);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1F1F1F) : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected
                  ? const Color(0xFF1F1F1F)
                  : const Color(0xFFDCDCDC)),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF5A5A5A))),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider auth) {
    return Drawer( 
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('AUTOLAB',
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            const Divider(),
            _drawerItem(Icons.home_outlined, 'Home',
                () => context.go('/home')),
            _drawerItem(Icons.directions_car_outlined, 'My Vehicles',
                () => context.go('/vehicles')),
            _drawerItem(Icons.calendar_today_outlined, 'Bookings',
                () => context.push('/bookings')),
            _drawerItem(Icons.store_outlined, 'Service Centers',
                () => context.push('/service-centers')),
            _drawerItem(Icons.person_outline, 'Profile',
                () => context.push('/profile')),
            const Spacer(),
            const Divider(),
            _drawerItem(Icons.logout, 'Logout', () async {
              await auth.logout();
            }, color: Colors.red),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 15, color: color ?? Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  const _VehicleCard({required this.vehicle});

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
      child: Row(
        children: [
          Container(  
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              vehicle.isCar ? Icons.directions_car : Icons.two_wheeler,
              size: 32,
              color: const Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.displayName,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                if (vehicle.registrationNumber != null)
                  Text(vehicle.registrationNumber!,
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: const Color(0xFF7A7A7A))),
                Text(
                    '${vehicle.vehicleType.toUpperCase()}${vehicle.fuelType != null ? ' • ${vehicle.fuelType}' : ''}',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: const Color(0xFF9E9E9E))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptions(context),
          ),
        ],
      ), 
    ); 
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.build_outlined, color: Color(0xFF2F7DE1)),
            title: const Text('New Service Record'),
            subtitle: const Text('Fill service details after a service'),
            onTap: () {
              Navigator.pop(context);
              context.push('/service/form/${vehicle.id}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF2F9E56)),
            title: const Text('Service History'),
            subtitle: const Text('View all past service records'),
            onTap: () {
              Navigator.pop(context);
              context.push('/service/history/${vehicle.id}');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Book Service'),
            onTap: () {
              Navigator.pop(context);
              context.push('/bookings/create');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Remove Vehicle',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await context
                  .read<VehicleProvider>()
                  .deleteVehicle(vehicle.id);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('MY VEHICLES')),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B1F26),
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.vehicles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.directions_car_outlined,
                          size: 64, color: Color(0xFFBDBDBD)),
                      const SizedBox(height: 16),
                      Text('No vehicles added yet',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: const Color(0xFF7A7A7A))),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => context.push('/vehicles/add'),
                        child: const Text('Add Vehicle'),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.vehicles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) =>
                      _VehicleCard(vehicle: provider.vehicles[i]),
                ),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/empty_state.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<VehicleProvider>().fetchVehicles());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('My Vehicles')),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/add'),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.vehicles.isEmpty
              ? EmptyState(
                  icon: Icons.directions_car_outlined,
                  title: 'No Vehicles Yet',
                  subtitle: 'Add your first vehicle to start tracking services',
                  actionLabel: 'Add Vehicle',
                  onAction: () => context.push('/vehicles/add'),
                )
              : RefreshIndicator(
                  onRefresh: () => provider.fetchVehicles(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.vehicles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _VehicleCard(vehicle: provider.vehicles[i]),
                  ),
                ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/vehicles/${vehicle.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
              child: Icon(vehicle.isCar ? Icons.directions_car : Icons.two_wheeler, color: AppTheme.primaryBlue, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.displayName, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  if (vehicle.registrationNumber != null)
                    Text(vehicle.registrationNumber!, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20),
              onSelected: (v) {
                if (v == 'view') context.push('/vehicles/${vehicle.id}');
                if (v == 'edit') context.push('/vehicles/edit/${vehicle.id}');
                if (v == 'delete') _confirmDelete(context, vehicle.id);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'view', child: Text('View Details')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Vehicle?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VehicleProvider>().deleteVehicle(id);
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
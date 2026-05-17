import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<VehicleServiceProvider>().fetchVehiclesWithStatus());
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<VehicleServiceProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Service History')),
      body: svc.vehiclesLoading
          ? const Center(child: CircularProgressIndicator())
          : svc.vehicles.isEmpty
              ? const EmptyState(icon: Icons.history_outlined, title: 'No Service Records', subtitle: 'Your service history will appear here')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: svc.vehicles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final v = svc.vehicles[i];
                    return _VehicleServiceTile(vehicle: v, onTap: () {
                      svc.fetchServiceHistory(v.id);
                      context.push('/service-detail/${v.id}');
                    });
                  },
                ),
    );
  }
}

class _VehicleServiceTile extends StatelessWidget {
  final VehicleWithServiceStatus vehicle;
  final VoidCallback onTap;
  const _VehicleServiceTile({required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: Row(
          children: [
            Icon(vehicle.isCar ? Icons.directions_car : Icons.two_wheeler, color: AppTheme.primaryBlue, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.displayName, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('${vehicle.totalServices} services', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.secondaryText, size: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/app_back_button.dart';

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
      appBar: AppBar(title: const Text('Service History'), leading: const AppBackButton()),
      body: svc.vehiclesLoading
          ? const Center(child: CircularProgressIndicator())
          : svc.vehicles.isEmpty
              ? const EmptyState(icon: Icons.history_outlined, title: 'No Service Records', subtitle: 'Your service history will appear here')
              : RefreshIndicator(
                  onRefresh: () => svc.fetchVehiclesWithStatus(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: svc.vehicles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final v = svc.vehicles[i];
                      return _VehicleServiceTile(
                        vehicle: v,
                        onTap: () => context.push('/service-history/${v.id}?name=${Uri.encodeComponent(v.displayName)}'),
                      );
                    },
                  ),
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
            Container(
              width: 44, height: 44,
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
                  Text('${vehicle.totalServices} service${vehicle.totalServices == 1 ? '' : 's'}', style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
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


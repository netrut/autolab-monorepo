import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/app_back_button.dart';

class VehicleServiceListScreen extends StatefulWidget {
  final String vehicleId;
  final String? vehicleName;
  const VehicleServiceListScreen({super.key, required this.vehicleId, this.vehicleName});

  @override
  State<VehicleServiceListScreen> createState() => _VehicleServiceListScreenState();
}

class _VehicleServiceListScreenState extends State<VehicleServiceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleServiceProvider>().fetchServiceHistory(widget.vehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<VehicleServiceProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(widget.vehicleName ?? 'Service History'), leading: const AppBackButton()),
      body: svc.historyLoading
          ? const Center(child: CircularProgressIndicator())
          : svc.history.isEmpty
              ? const EmptyState(icon: Icons.history_outlined, title: 'No Services', subtitle: 'No service records found for this vehicle')
              : RefreshIndicator(
                  onRefresh: () => svc.fetchServiceHistory(widget.vehicleId),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: svc.history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _ServiceTile(service: svc.history[i]),
                  ),
                ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final VehicleServiceModel service;
  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/service-detail/${service.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.build_outlined, size: 18, color: AppTheme.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.serviceType, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(_formatDate(service.serviceDate), style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
                  if (service.items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        service.items.take(3).map((i) => i.itemName).join(', '),
                        style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${service.totalCost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                const Icon(Icons.chevron_right, size: 18, color: AppTheme.secondaryText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

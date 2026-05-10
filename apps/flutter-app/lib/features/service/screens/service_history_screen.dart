import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/models/vehicle_service_model.dart';
import '../../../core/providers/vehicle_service_provider.dart';

class ServiceHistoryScreen extends StatefulWidget {
  final String vehicleId;

  const ServiceHistoryScreen({super.key, required this.vehicleId});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  VehicleWithServiceStatus? _vehicle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<VehicleServiceProvider>();
      // Fetch vehicles if not yet loaded (e.g. navigating directly from Vehicles page)
      if (provider.vehicles.isEmpty) {
        await provider.fetchVehiclesWithStatus();
      }
      final match = provider.vehicles.where((v) => v.id == widget.vehicleId);
      if (match.isNotEmpty) _vehicle = match.first;
      provider.fetchServiceHistory(widget.vehicleId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleServiceProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => context.pop()),
        title: Text('Service History', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () => context.push('/service/form/${widget.vehicleId}'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Vehicle header
          if (_vehicle != null) _buildVehicleHeader(),

          // History list
          Expanded(
            child: provider.historyLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 56, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text('No service records yet', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () => context.push('/service/form/${widget.vehicleId}'),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add First Service'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchServiceHistory(widget.vehicleId),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.history.length,
                          itemBuilder: (_, i) => _buildServiceCard(provider.history[i], i == 0),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleHeader() {
    final v = _vehicle!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(10)),
            child: Icon(v.isCar ? Icons.directions_car : Icons.two_wheeler, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.registrationNumber ?? v.displayName, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                Text('${v.isCar ? 'Car' : 'Bike'} • ${v.displayName} • ${v.totalServices} services', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(VehicleServiceModel service, bool isLatest) {
    final typeColor = _typeColor(service.serviceType);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/service/detail/${service.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isLatest ? const Color(0xFF2F7DE1).withOpacity(0.3) : const Color(0xFFE8E8E8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Date
                  Text(DateFormat('dd MMM yyyy').format(service.serviceDate), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(service.serviceType[0].toUpperCase() + service.serviceType.substring(1), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: typeColor)),
                  ),
                  if (service.status == 'draft') ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('DRAFT', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.orange)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Info row
              Row(
                children: [
                  _infoChip(Icons.build_outlined, '${service.items.length} items'),
                  const SizedBox(width: 12),
                  _infoChip(Icons.currency_rupee, service.totalCost.toStringAsFixed(0)),
                  if (service.odometerKm != null) ...[
                    const SizedBox(width: 12),
                    _infoChip(Icons.speed, '${service.odometerKm!.toStringAsFixed(0)} km'),
                  ],
                ],
              ),
              if (service.nextServiceDate != null) ...[
                const SizedBox(height: 6),
                Text('Next due: ${DateFormat('dd MMM yyyy').format(service.nextServiceDate!)}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'major': return const Color(0xFF7B61FF);
      case 'emergency': return Colors.red;
      default: return const Color(0xFF2F7DE1);
    }
  }
}

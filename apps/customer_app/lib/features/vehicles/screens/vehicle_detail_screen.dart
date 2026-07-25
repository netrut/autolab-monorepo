import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../core/providers/request_provider.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/app_back_button.dart';

class VehicleDetailScreen extends StatefulWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  VehicleModel? _vehicle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await context.read<VehicleProvider>().fetchById(widget.vehicleId);
    if (mounted) {
      setState(() { _vehicle = v; _loading = false; });
      context.read<VehicleServiceProvider>().fetchServiceHistory(widget.vehicleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<VehicleServiceProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        leading: const AppBackButton(),
        actions: [
          if (_vehicle != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => context.push('/vehicles/edit/${widget.vehicleId}'),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _vehicle == null
              ? const Center(child: Text('Vehicle not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Info Card
                      _VehicleInfoCard(vehicle: _vehicle!),
                      const SizedBox(height: 16),

                      // Share Access
                      _ShareAccessSection(vehicleId: widget.vehicleId),
                      const SizedBox(height: 20),

                      // Service History
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Service History', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                          if (svc.history.isNotEmpty)
                            TextButton(
                              onPressed: () => context.push('/service-history/${widget.vehicleId}?name=${Uri.encodeComponent(_vehicle?.displayName ?? 'Vehicle')}'),
                              child: Text('View All', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.primaryBlue)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (svc.historyLoading)
                        const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                      else if (svc.history.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                          child: Column(
                            children: [
                              Icon(Icons.history_outlined, size: 32, color: AppTheme.secondaryText.withOpacity(0.4)),
                              const SizedBox(height: 8),
                              Text('No service records yet', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
                            ],
                          ),
                        )
                      else
                        ...svc.history.take(5).map((s) => _ServiceHistoryTile(service: s)),
                    ],
                  ),
                ),
    );
  }
}

class _VehicleInfoCard extends StatelessWidget {
  final VehicleModel vehicle;
  const _VehicleInfoCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
                child: Icon(vehicle.isCar ? Icons.directions_car : Icons.two_wheeler, color: AppTheme.primaryBlue, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicle.displayName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    if (vehicle.registrationNumber != null)
                      Text(vehicle.registrationNumber!, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _DetailRow('Type', vehicle.vehicleType.toUpperCase()),
          _DetailRow('Brand', vehicle.brand),
          _DetailRow('Model', vehicle.model),
          if (vehicle.year != null) _DetailRow('Year', '${vehicle.year}'),
          if (vehicle.vehicleColor != null) _DetailRow('Color', vehicle.vehicleColor!),
          if (vehicle.fuelType != null) _DetailRow('Fuel', vehicle.fuelType!),
          if (vehicle.transmission != null) _DetailRow('Transmission', vehicle.transmission!),
          if (vehicle.chassisNumber != null) _DetailRow('Chassis', vehicle.chassisNumber!),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
          Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ShareAccessSection extends StatefulWidget {
  final String vehicleId;
  const _ShareAccessSection({required this.vehicleId});

  @override
  State<_ShareAccessSection> createState() => _ShareAccessSectionState();
}

class _ShareAccessSectionState extends State<_ShareAccessSection> {
  bool _showForm = false;
  final _userIdCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _userIdCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendRequest() async {
    if (_userIdCtrl.text.trim().isEmpty) return;
    setState(() => _sending = true);
    final success = await context.read<RequestProvider>().sendVehicleAccessRequest(
      vehicleId: widget.vehicleId,
      toUserId: _userIdCtrl.text.trim(),
      message: _messageCtrl.text.trim().isNotEmpty ? _messageCtrl.text.trim() : null,
    );
    setState(() => _sending = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Access request sent!')));
      setState(() { _showForm = false; _userIdCtrl.clear(); _messageCtrl.clear(); });
    }
  }

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
              Text('Share Access', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
              if (!_showForm)
                TextButton.icon(
                  onPressed: () => setState(() => _showForm = true),
                  icon: const Icon(Icons.person_add_outlined, size: 16),
                  label: Text('Share', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                ),
            ],
          ),
          Text('Share vehicle access with family or friends', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
          if (_showForm) ...[
            const SizedBox(height: 12),
            AppTextField(label: 'User ID or Email', controller: _userIdCtrl, hint: 'Enter user ID'),
            const SizedBox(height: 10),
            AppTextField(label: 'Message (optional)', controller: _messageCtrl, hint: 'Add a note'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _showForm = false),
                    child: const Text('Cancel', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sending ? null : _sendRequest,
                    child: _sending
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Send', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ServiceHistoryTile extends StatelessWidget {
  final VehicleServiceModel service;
  const _ServiceHistoryTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/service-detail/${service.id}'),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.build_outlined, size: 16, color: AppTheme.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.serviceType, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(_formatDate(service.serviceDate), style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
                ],
              ),
            ),
            Text('₹${service.totalCost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
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

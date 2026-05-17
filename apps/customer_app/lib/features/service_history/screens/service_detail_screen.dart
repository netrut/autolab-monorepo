import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/theme/app_theme.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  VehicleServiceModel? _service;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await context.read<VehicleServiceProvider>().fetchServiceRecord(widget.serviceId);
    if (mounted) setState(() { _service = s; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Service Detail')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _service == null
              ? const Center(child: Text('Service not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_service!.vehicleDisplayName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            _Row(label: 'Date', value: _formatDate(_service!.serviceDate)),
                            _Row(label: 'Type', value: _service!.serviceType),
                            if (_service!.odometerKm != null) _Row(label: 'Odometer', value: '${_service!.odometerKm!.toStringAsFixed(0)} km'),
                            _Row(label: 'Labour', value: '₹${_service!.labourCost.toStringAsFixed(0)}'),
                            _Row(label: 'Total', value: '₹${_service!.totalCost.toStringAsFixed(0)}'),
                            if (_service!.nextServiceDate != null) _Row(label: 'Next Due', value: _formatDate(_service!.nextServiceDate!)),
                            if (_service!.notes != null && _service!.notes!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text('Notes: ${_service!.notes}', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
                            ],
                          ],
                        ),
                      ),
                      // View Invoice button
                      const SizedBox(height: 16),
                      _ViewInvoiceButton(serviceId: widget.serviceId),
                      if (_service!.items.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('Items', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        ...(_service!.items.map((item) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.itemName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                                    Text(item.status, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
                                  ],
                                ),
                              ),
                              Text('₹${item.cost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ))),
                      ],
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

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

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

class _ViewInvoiceButton extends StatefulWidget {
  final String serviceId;
  const _ViewInvoiceButton({required this.serviceId});

  @override
  State<_ViewInvoiceButton> createState() => _ViewInvoiceButtonState();
}

class _ViewInvoiceButtonState extends State<_ViewInvoiceButton> {
  String? _invoiceId;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checkInvoice();
  }

  Future<void> _checkInvoice() async {
    try {
      final res = await ApiClient().get('/api/invoices/service/${widget.serviceId}');
      final data = res.data as Map<String, dynamic>;
      _invoiceId = data['id'] as String?;
    } catch (_) {}
    if (mounted) setState(() => _checked = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) return const SizedBox.shrink();
    if (_invoiceId == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.push('/invoices/$_invoiceId'),
        icon: const Icon(Icons.receipt_long_outlined, size: 18),
        label: const Text('View Invoice'),
      ),
    );
  }
}

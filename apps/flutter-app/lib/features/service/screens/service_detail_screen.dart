import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../core/providers/options_provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final record = await context.read<VehicleServiceProvider>().fetchServiceRecord(widget.serviceId);
    if (mounted) setState(() { _service = record; _loading = false; });
  }

  Future<void> _generateInvoice() async {
    try {
      final options = context.read<OptionsProvider>();
      await ApiClient().post('/api/invoices', data: {
        'service_id': widget.serviceId,
        'footer_text': options.invoiceFooterText,
      });
      if (!mounted) return;
      context.push('/invoice/${widget.serviceId}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate invoice: $e')),
      );
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Service Record?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final ok = await context.read<VehicleServiceProvider>().deleteService(widget.serviceId);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service record deleted')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Service Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_service == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Service Detail')),
        body: const Center(child: Text('Record not found')),
      );
    }

    final s = _service!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => context.pop()),
        title: Text('Service Detail', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () => context.push('/service/form/${s.vehicleId}?serviceId=${s.id}'),
          ),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: _delete),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Vehicle info
          _card([
            Row(
              children: [
                Icon(s.vehicleType?.toLowerCase() == 'car' ? Icons.directions_car : Icons.two_wheeler, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.registrationNumber ?? s.vehicleDisplayName, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                      Text(s.vehicleDisplayName, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 12),

          // Service meta
          _card([
            _metaRow('Date', DateFormat('dd MMM yyyy').format(s.serviceDate)),
            _metaRow('Type', s.serviceType[0].toUpperCase() + s.serviceType.substring(1)),
            _metaRow('Status', s.status[0].toUpperCase() + s.status.substring(1)),
            if (s.odometerKm != null) _metaRow('Odometer', '${s.odometerKm!.toStringAsFixed(0)} km'),
            if (s.nextServiceDate != null) _metaRow('Next Service', DateFormat('dd MMM yyyy').format(s.nextServiceDate!)),
          ]),
          const SizedBox(height: 12),

          // Items
          _sectionTitle('Items (${s.items.length})'),
          const SizedBox(height: 8),
          if (s.items.isEmpty)
            _card([Text('No items recorded', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey))])
          else
            ...s.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE8E8E8))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.itemName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _statusBadge(item.status),
                              if (item.notes != null && item.notes!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Flexible(child: Text(item.notes!, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]), overflow: TextOverflow.ellipsis)),
                              ],
                            ],
                          ),
                          if (item.expiryDate != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('Expires: ${DateFormat('dd MMM yyyy').format(item.expiryDate!)}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.orange[700])),
                            ),
                        ],
                      ),
                    ),
                    Text('₹${item.cost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            )),
          const SizedBox(height: 12),

          // Cost breakdown
          _sectionTitle('Cost Breakdown'),
          const SizedBox(height: 8),
          _card([
            _metaRow('Items Subtotal', '₹${s.items.fold<double>(0, (sum, i) => sum + i.cost).toStringAsFixed(0)}'),
            _metaRow('Labour', '₹${s.labourCost.toStringAsFixed(0)}'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                Text('₹${s.totalCost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
          ]),

          // Notes
          if (s.notes != null && s.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionTitle('Mechanic Notes'),
            const SizedBox(height: 8),
            _card([Text(s.notes!, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]))]),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _generateInvoice,
            icon: const Icon(Icons.receipt_long_outlined, size: 18),
            label: Text('Generate Invoice', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2F7DE1),
              side: const BorderSide(color: Color(0xFF2F7DE1)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700));

  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8E8E8))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _metaRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
        Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    ),
  );

  Widget _statusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Changed': return const Color(0xFF2F7DE1);
      case 'Replaced': return const Color(0xFF7B61FF);
      case 'Repaired': return const Color(0xFFDA8A1D);
      case 'Good': return const Color(0xFF2F9E56);
      case 'Needs Attention': return Colors.red;
      default: return Colors.grey;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/service_center_model.dart';
import '../../../core/models/service_item_model.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/options_provider.dart';
import '../../../core/providers/vehicle_service_provider.dart';

class ServiceFormScreen extends StatefulWidget {
  final String vehicleId;
  final String? serviceId; // null = create, non-null = edit

  const ServiceFormScreen({super.key, required this.vehicleId, this.serviceId});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;

  // Form fields
  DateTime _serviceDate = DateTime.now();
  DateTime? _nextServiceDate;
  final _odometerCtrl = TextEditingController();
  String _serviceType = 'general';
  final _labourCostCtrl = TextEditingController(text: '0');
  final _notesCtrl = TextEditingController();
  String _status = 'completed';

  // Dynamic items
  final List<ServiceItemInput> _items = [];

  // Vehicle info (from provider vehicles list)
  VehicleWithServiceStatus? _vehicle;
  VehicleServiceModel? _existingRecord;

  // 4.1 — service centre + submitted-by info
  String? _centreName;
  String? _submittedBy;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final provider = context.read<VehicleServiceProvider>();

    // 4.1 — load service centre name + submitted-by user
    final auth = context.read<AuthProvider>();
    _submittedBy = auth.user?.displayName ?? auth.user?.email;
    try {
      final prefs = await SharedPreferences.getInstance();
      final scId = prefs.getString('service_center_id');
      if (scId != null && scId.isNotEmpty) {
        final res = await ApiClient().get('/api/service-centers/$scId');
        final center = ServiceCenterModel.fromJson(
            res.data as Map<String, dynamic>);
        _centreName = center.name;
      } else {
        // fallback to options table value
        if (mounted) {
          _centreName =
              context.read<OptionsProvider>().serviceCentreName;
        }
      }
    } catch (_) {
      if (mounted) {
        _centreName = context.read<OptionsProvider>().serviceCentreName;
      }
    }

    // Find vehicle from already-loaded list, or fetch if not yet loaded
    if (provider.vehicles.isEmpty) {
      await provider.fetchVehiclesWithStatus();
    }
    final match = provider.vehicles.where((v) => v.id == widget.vehicleId);
    if (match.isNotEmpty) _vehicle = match.first;

    // Load catalogue
    await provider.fetchCatalogue(vehicleType: _vehicle?.vehicleType);

    // If editing, load existing record
    if (widget.serviceId != null) {
      final record = await provider.fetchServiceRecord(widget.serviceId!);
      if (record != null) {
        _existingRecord = record;
        _serviceDate = record.serviceDate;
        _nextServiceDate = record.nextServiceDate;
        _odometerCtrl.text = record.odometerKm?.toStringAsFixed(0) ?? '';
        _serviceType = record.serviceType;
        _labourCostCtrl.text = record.labourCost.toStringAsFixed(0);
        _notesCtrl.text = record.notes ?? '';
        _status = record.status;
        _items.addAll(record.items.map((i) => ServiceItemInput(
              itemName: i.itemName,
              status: i.status,
              cost: i.cost,
              notes: i.notes,
              expiryDate: i.expiryDate,
            )));
      }
    }

    setState(() => _loading = false);
  }

  double get _itemsTotal => _items.fold(0, (s, i) => s + i.cost);
  double get _labourCost => double.tryParse(_labourCostCtrl.text) ?? 0;
  double get _totalCost => _itemsTotal + _labourCost;

  @override
  void dispose() {
    _odometerCtrl.dispose();
    _labourCostCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // ── Save ────────────────────────────────────────────────────────────────────

  Future<void> _save(String status) async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'vehicle_id': widget.vehicleId,
      'service_date': _serviceDate.toIso8601String(),
      if (_nextServiceDate != null)
        'next_service_date': _nextServiceDate!.toIso8601String(),
      if (_odometerCtrl.text.isNotEmpty)
        'odometer_km': double.tryParse(_odometerCtrl.text) ?? 0,
      'service_type': _serviceType,
      'labour_cost': _labourCost,
      'notes': _notesCtrl.text,
      'status': status,
      'items': _items.map((i) => i.toJson()).toList(),
    };

    final provider = context.read<VehicleServiceProvider>();
    VehicleServiceModel? result;

    if (widget.serviceId != null) {
      result = await provider.updateService(widget.serviceId!, data);
    } else {
      result = await provider.createService(data);
    }

    if (!mounted) return;
    if (result != null) {
      if (status == 'completed') {
        context.pushReplacement('/service/detail/${result.id}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service saved as draft!')),
        );
        context.pop();
      }
    } else if (provider.saveError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.saveError!), backgroundColor: Colors.red),
      );
    }
  }

  // ── Date picker ─────────────────────────────────────────────────────────────

  // ── Generate Invoice (5.7) ──────────────────────────────────────────────────

  Future<void> _showCompletionDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFF)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2F7DE1), Color(0xFF7BAAF7)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2F7DE1).withOpacity(0.18),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Completed',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F1F1F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your service record has been saved successfully.',
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                color: Colors.grey[700],
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD7E6FF)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_outlined, color: Color(0xFF2F7DE1), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Generate an invoice now or return to the previous screen.',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: const Color(0xFF2459A6),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            context.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1F1F1F),
                            side: const BorderSide(color: Color(0xFFD9D9D9)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            'Back',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            await _generateInvoice();
                          },
                          icon: const Icon(Icons.receipt_long_outlined, size: 18),
                          label: Text(
                            'Generate Invoice',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2F7DE1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _generateInvoice() async {
    final serviceId = _existingRecord?.id ?? widget.serviceId;
    if (serviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save the service record first before generating an invoice')),
      );
      return;
    }
    try {
      final options = context.read<OptionsProvider>();
      await ApiClient().post('/api/invoices', data: {
        'service_id': serviceId,
        'footer_text': options.invoiceFooterText,
      });
      if (!mounted) return;
      context.push('/invoice/$serviceId');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate invoice: $e')),
      );
    }
  }

  Future<void> _pickDate({required bool isNext}) async {
    final initial = isNext ? (_nextServiceDate ?? DateTime.now().add(const Duration(days: 90))) : _serviceDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isNext) {
          _nextServiceDate = picked;
        } else {
          _serviceDate = picked;
        }
      });
    }
  }

  // ── Add item bottom sheet ───────────────────────────────────────────────────

  void _showAddItemSheet() {
    final catalogue = context.read<VehicleServiceProvider>().catalogue;
    final searchCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final query = searchCtrl.text.toLowerCase();
          final filtered = catalogue.where((c) => c.name.toLowerCase().contains(query)).toList();
          // Group by category
          final grouped = <String, List<CatalogueItem>>{};
          for (final c in filtered) {
            grouped.putIfAbsent(c.category, () => []).add(c);
          }

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            builder: (_, scrollCtrl) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 12),
                  Text('Add Service Item', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  // Search / custom name
                  TextField(
                    controller: searchCtrl,
                    onChanged: (_) => setS(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search or type custom item name',
                      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  // Custom item button
                  if (searchCtrl.text.isNotEmpty && filtered.every((c) => c.name.toLowerCase() != query))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: InkWell(
                        onTap: () {
                          _addItem(searchCtrl.text.trim());
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              const Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF2F7DE1)),
                              const SizedBox(width: 8),
                              Text('Add "${searchCtrl.text.trim()}"', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF2F7DE1))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Catalogue list
                  Expanded(
                    child: ListView(
                      controller: scrollCtrl,
                      children: grouped.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(entry.key.toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[600], letterSpacing: 0.5)),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: entry.value.map((c) => ActionChip(
                                label: Text(c.name, style: GoogleFonts.poppins(fontSize: 12)),
                                onPressed: () {
                                  _addItem(c.name);
                                  Navigator.pop(ctx);
                                },
                              )).toList(),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _addItem(String name) {
    setState(() {
      _items.add(ServiceItemInput(itemName: name, status: 'Changed'));
    });
  }

  // ── Edit item dialog ────────────────────────────────────────────────────────

  void _editItem(int index) {
    final item = _items[index];
    final costCtrl = TextEditingController(text: item.cost > 0 ? item.cost.toStringAsFixed(0) : '');
    final notesCtrl = TextEditingController(text: item.notes ?? '');
    String status = item.status;
    DateTime? expiry = item.expiryDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(item.itemName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status dropdown
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(labelText: 'Status', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                  items: ServiceItemModel.statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.poppins(fontSize: 13)))).toList(),
                  onChanged: (v) => setS(() => status = v!),
                ),
                const SizedBox(height: 12),
                // Cost
                TextField(
                  controller: costCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Cost (₹)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(height: 12),
                // Notes
                TextField(
                  controller: notesCtrl,
                  decoration: InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(height: 12),
                // Expiry date
                InkWell(
                  onTap: () async {
                    final d = await showDatePicker(context: ctx, initialDate: expiry ?? DateTime.now().add(const Duration(days: 180)), firstDate: DateTime.now(), lastDate: DateTime(2030));
                    if (d != null) setS(() => expiry = d);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: 'Expiry Date', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text(expiry != null ? DateFormat('dd MMM yyyy').format(expiry!) : 'Not set', style: GoogleFonts.poppins(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                setState(() {
                  _items[index] = item.copyWith(
                    status: status,
                    cost: double.tryParse(costCtrl.text) ?? 0,
                    notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
                    expiryDate: expiry,
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleServiceProvider>();

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.serviceId != null ? 'Edit Service' : 'New Service')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => context.pop()),
          title: Text(
            widget.serviceId != null ? 'Edit Service' : 'New Service Record',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Vehicle info header
              if (_vehicle != null) _buildVehicleHeader(),
              const SizedBox(height: 16),

              // Service date & type
              _sectionTitle('Service Details'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _dateTile('Service Date', _serviceDate, () => _pickDate(isNext: false))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildServiceTypeDropdown()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _dateTile('Next Service', _nextServiceDate, () => _pickDate(isNext: true))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _odometerCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecor('Odometer (km)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Items section
              _sectionTitle('Service Items (${_items.length})'),
              const SizedBox(height: 8),
              ..._items.asMap().entries.map((e) => _buildItemTile(e.key, e.value)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _showAddItemSheet,
                icon: const Icon(Icons.add),
                label: Text('Add Item', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),

              // Cost section
              _sectionTitle('Cost Summary'),
              const SizedBox(height: 8),
              _buildCostSection(),
              const SizedBox(height: 12),

              // Notes
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: _inputDecor('General Notes / Remarks'),
              ),
              const SizedBox(height: 24),

              // Save buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: provider.saving ? null : () => _save('draft'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('Save Draft', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: provider.saving ? null : () => _save('completed'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1F1F1F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: provider.saving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('Complete Service', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 5.7 — Generate Invoice (wired)
              // OutlinedButton.icon(
              //   onPressed: _generateInvoice,
              //   icon: const Icon(Icons.receipt_long_outlined, size: 18),
              //   label: Text('Generate Invoice',
              //       style: GoogleFonts.poppins(
              //           fontSize: 13, fontWeight: FontWeight.w600)),
              //   style: OutlinedButton.styleFrom(
              //     foregroundColor: const Color(0xFF2F7DE1),
              //     side: const BorderSide(color: Color(0xFF2F7DE1)),
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10)),
              //   ),
              // ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets ─────────────────────────────────────────────────────────────────

  Widget _buildVehicleHeader() {
    final v = _vehicle!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4E4E4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(v.isCar ? Icons.directions_car : Icons.two_wheeler,
                    color: Colors.grey[600]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.registrationNumber ?? v.displayName,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    Text('${v.isCar ? 'Car' : 'Bike'} • ${v.displayName}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          // 4.1 — service centre + submitted by
          if (_centreName != null || _submittedBy != null) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_centreName != null) ...[
                  const Icon(Icons.store_outlined,
                      size: 13, color: Color(0xFF7A7A7A)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(_centreName!,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: const Color(0xFF7A7A7A))),
                  ),
                ],
                if (_submittedBy != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.person_outline,
                      size: 13, color: Color(0xFF7A7A7A)),
                  const SizedBox(width: 4),
                  Text(_submittedBy!,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: const Color(0xFF7A7A7A))),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF1F1F1F)));

  Widget _dateTile(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecor(label),
        child: Text(
          date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select',
          style: GoogleFonts.poppins(fontSize: 13, color: date != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildServiceTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _serviceType,
      decoration: _inputDecor('Service Type'),
      items: VehicleServiceModel.serviceTypes.map((t) => DropdownMenuItem(value: t, child: Text(t[0].toUpperCase() + t.substring(1), style: GoogleFonts.poppins(fontSize: 13)))).toList(),
      onChanged: (v) => setState(() => _serviceType = v!),
    );
  }

  InputDecoration _inputDecor(String label) => InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        filled: true,
        fillColor: Colors.white,
      );

  Widget _buildItemTile(int index, ServiceItemInput item) {
    final statusColor = _itemStatusColor(item.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE8E8E8))),
        child: ListTile(
          dense: true,
          title: Text(item.itemName, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(item.status, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
              ),
              if (item.cost > 0) ...[
                const SizedBox(width: 8),
                Text('₹${item.cost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700])),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => _editItem(index)),
              IconButton(icon: const Icon(Icons.close, size: 18, color: Colors.red), onPressed: () => setState(() => _items.removeAt(index))),
            ],
          ),
          onTap: () => _editItem(index),
        ),
      ),
    );
  }

  Color _itemStatusColor(String status) {
    switch (status) {
      case 'Changed': return const Color(0xFF2F7DE1);
      case 'Replaced': return const Color(0xFF7B61FF);
      case 'Repaired': return const Color(0xFFDA8A1D);
      case 'Good': return const Color(0xFF2F9E56);
      case 'Needs Attention': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildCostSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE4E4E4))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items Subtotal', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
              Text('₹${_itemsTotal.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Labour', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
              const Spacer(),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _labourCostCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixText: '₹',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
              Text('₹${_totalCost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1F1F1F))),
            ],
          ),
        ],
      ),
    );
  }
}

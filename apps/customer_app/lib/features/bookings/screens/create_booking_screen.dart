import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/models/service_center_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class CreateBookingScreen extends StatefulWidget {
  final String? initialVehicleId;
  const CreateBookingScreen({super.key, this.initialVehicleId});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _vehicleId;
  String? _selectedCentreId;
  String? _selectedCentreName;
  String _serviceType = 'General Service';
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  final _notesCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _vehicleId = widget.initialVehicleId;
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<VehicleProvider>().fetchVehicles());
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _vehicleId == null) return;
    if (_selectedCentreId == null || _selectedCentreId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a service centre')));
      return;
    }
    setState(() => _loading = true);
    final success = await context.read<BookingProvider>().createBooking({
      'vehicle_id': _vehicleId,
      'service_center_id': _selectedCentreId,
      'service_type': _serviceType,
      'booking_date': _date.toIso8601String(),
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
    });
    setState(() => _loading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking created!')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = context.watch<VehicleProvider>().vehicles;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Book Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Vehicle', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _vehicleId,
                decoration: const InputDecoration(hintText: 'Choose vehicle'),
                validator: (v) => v == null ? 'Select a vehicle' : null,
                items: vehicles.map((v) => DropdownMenuItem(value: v.id, child: Text(v.displayName))).toList(),
                onChanged: (v) => setState(() => _vehicleId = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _serviceType,
                decoration: const InputDecoration(labelText: 'Service Type'),
                items: ['General Service', 'Oil Change', 'Major Service', 'Brake Service', 'Tyre Change', 'Other']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _serviceType = v ?? _serviceType),
              ),
              const SizedBox(height: 16),
              _ServiceCentreField(
                selectedName: _selectedCentreName,
                onSelected: (id, name) => setState(() { _selectedCentreId = id; _selectedCentreName = name; }),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: AppTextField(label: 'Preferred Date', controller: TextEditingController(text: DateFormat('dd MMM yyyy').format(_date)), readOnly: true, suffixIcon: const Icon(Icons.calendar_today, size: 18)),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(label: 'Notes (optional)', controller: _notesCtrl, maxLines: 3),
              const SizedBox(height: 28),
              AppButton(label: 'Book Now', isLoading: _loading, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}


class _ServiceCentreField extends StatefulWidget {
  final String? selectedName;
  final void Function(String id, String name) onSelected;
  const _ServiceCentreField({required this.selectedName, required this.onSelected});

  @override
  State<_ServiceCentreField> createState() => _ServiceCentreFieldState();
}

class _ServiceCentreFieldState extends State<_ServiceCentreField> {
  final _searchCtrl = TextEditingController();
  List<ServiceCenterModel> _centres = [];
  bool _loading = false;
  bool _showList = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetch([String query = '']) async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get('/api/service-centers', queryParameters: query.isNotEmpty ? {'search': query} : null);
      final list = (res.data['centers'] ?? res.data['service_centers'] ?? res.data['serviceCenters'] ?? []) as List;
      _centres = list.map((e) => ServiceCenterModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // If already selected, show chip
    if (widget.selectedName != null && widget.selectedName!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.store_outlined, size: 18, color: AppTheme.primaryBlue),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.selectedName!, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue))),
            GestureDetector(
              onTap: () {
                widget.onSelected('', '');
                setState(() { _showList = false; _searchCtrl.clear(); });
              },
              child: const Icon(Icons.close, size: 18, color: AppTheme.primaryBlue),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchCtrl,
          onChanged: (v) => _fetch(v),
          onTap: () {
            if (!_showList) { _fetch(); setState(() => _showList = true); }
          },
          decoration: InputDecoration(
            labelText: 'Service Centre',
            hintText: 'Tap to search service centre...',
            hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText),
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            fillColor: AppTheme.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryBlue)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        if (_showList) ...[
          const SizedBox(height: 4),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: _loading
                ? const Padding(padding: EdgeInsets.all(20), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
                : _centres.isEmpty
                    ? Padding(padding: const EdgeInsets.all(16), child: Text('No service centres found', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)))
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: _centres.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final c = _centres[i];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.store_outlined, size: 18, color: AppTheme.secondaryText),
                            title: Text(c.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                            subtitle: c.city != null ? Text(c.city!, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)) : null,
                            onTap: () {
                              widget.onSelected(c.id, c.name);
                              setState(() { _showList = false; _searchCtrl.clear(); });
                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      ),
          ),
        ],
      ],
    );
  }
}

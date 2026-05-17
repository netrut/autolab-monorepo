import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/models/vehicle_model.dart';
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
  String _serviceType = 'General Service';
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  final _notesCtrl = TextEditingController();
  final _centreIdCtrl = TextEditingController();
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
    _centreIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _vehicleId == null) return;
    setState(() => _loading = true);
    final success = await context.read<BookingProvider>().createBooking({
      'vehicle_id': _vehicleId,
      'service_center_id': _centreIdCtrl.text.trim(),
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
              AppTextField(label: 'Service Centre ID', controller: _centreIdCtrl, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
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

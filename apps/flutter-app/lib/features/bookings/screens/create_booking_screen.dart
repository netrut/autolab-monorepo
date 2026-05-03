import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/service_center_model.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _api = ApiClient();

  VehicleModel? _selectedVehicle;
  ServiceCenterModel? _selectedCenter;
  String? _serviceType;
  DateTime? _bookingDate;

  List<ServiceCenterModel> _centers = [];
  bool _loadingCenters = false;

  final _serviceTypes = [
    'Oil Change',
    'Tire Rotation',
    'Brake Inspection',
    'Battery Replacement',
    'AC Repair',
    'General Service',
    'Engine Check',
  ];

  @override
  void initState() {
    super.initState();
    _loadCenters();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCenters() async {
    setState(() => _loadingCenters = true);
    try {
      final res = await _api.get('/api/service-centers');
      final list = res.data['centers'] as List;
      setState(() {
        _centers = list.map((e) => ServiceCenterModel.fromJson(e)).toList();
      });
    } catch (_) {}
    setState(() => _loadingCenters = false);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (!mounted || picked == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (!mounted || time == null) return;
    setState(() {
      _bookingDate = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVehicle == null ||
        _selectedCenter == null ||
        _serviceType == null ||
        _bookingDate == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')));
      return;
    }
    final provider = context.read<BookingProvider>();
    final ok = await provider.createBooking({
      'vehicle_id': _selectedVehicle!.id,
      'service_center_id': _selectedCenter!.id,
      'service_type': _serviceType,
      'booking_date': _bookingDate!.toIso8601String(),
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
    });
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error ?? 'Failed to create booking')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = context.watch<VehicleProvider>().vehicles;
    final bookingProvider = context.watch<BookingProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Book Service')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Select Vehicle'),
                  DropdownButtonFormField<VehicleModel>(
                    value: _selectedVehicle,
                    decoration: _dropDecoration('Vehicle'),
                    items: vehicles
                        .map((v) => DropdownMenuItem(
                            value: v, child: Text(v.displayName)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedVehicle = v),
                    validator: (v) => v == null ? 'Select a vehicle' : null,
                  ),
                  const SizedBox(height: 16),
                  _sectionLabel('Service Type'),
                  DropdownButtonFormField<String>(
                    value: _serviceType,
                    decoration: _dropDecoration('Service Type'),
                    items: _serviceTypes
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _serviceType = v),
                    validator: (v) => v == null ? 'Select service type' : null,
                  ),
                  const SizedBox(height: 16),
                  _sectionLabel('Service Center'),
                  _loadingCenters
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<ServiceCenterModel>(
                          value: _selectedCenter,
                          decoration: _dropDecoration('Service Center'),
                          items: _centers
                              .map((c) => DropdownMenuItem(
                                  value: c, child: Text(c.name)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCenter = v),
                          validator: (v) =>
                              v == null ? 'Select a service center' : null,
                        ),
                  const SizedBox(height: 16),
                  _sectionLabel('Booking Date & Time'),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE0E3E7)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 18, color: Color(0xFF57636C)),
                          const SizedBox(width: 12),
                          Text(
                            _bookingDate != null
                                ? DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(_bookingDate!)
                                : 'Select date and time',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: _bookingDate != null
                                    ? const Color(0xFF14181B)
                                    : const Color(0xFF57636C)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _notesCtrl,
                    label: 'Notes (optional)',
                    hint: 'Any specific issues or requests',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Confirm Booking',
                    isLoading: bookingProvider.isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600)),
      );

  InputDecoration _dropDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
        ),
      );
}

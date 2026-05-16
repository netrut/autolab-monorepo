import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/service_center_model.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/models/vehicle_service_model.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/options_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
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
  final _notesCtrl = TextEditingController();
  final _api = ApiClient();

  VehicleModel? _selectedVehicle;
  String? _serviceType;
  DateTime? _bookingDate;

  // Service centre — auto-filled from prefs; null = not assigned yet
  ServiceCenterModel? _autoCenter;
  bool _loadingCenter = true;

  // 3.3 — unified service types from VehicleServiceModel + display labels
  static const _serviceTypeLabels = {
    'general': 'General Service',
    'major': 'Major Service',
    'emergency': 'Emergency Repair',
  };

  @override
  void initState() {
    super.initState();
    _loadServiceCenter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 3.1 — pre-select vehicle from query param
      if (widget.initialVehicleId != null) {
        final vehicles = context.read<VehicleProvider>().vehicles;
        final match =
            vehicles.where((v) => v.id == widget.initialVehicleId).firstOrNull;
        if (match != null) setState(() => _selectedVehicle = match);
      }
    });
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  // 3.2 — load service centre from shared_preferences service_center_id
  Future<void> _loadServiceCenter() async {
    setState(() => _loadingCenter = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final scId = prefs.getString('service_center_id');
      if (scId != null && scId.isNotEmpty) {
        final res = await _api.get('/api/service-centers/$scId');
        final center = ServiceCenterModel.fromJson(
            res.data as Map<String, dynamic>);
        if (mounted) setState(() => _autoCenter = center);
      }
    } catch (_) {
      // non-fatal — center stays null, user sees manual dropdown
    } finally {
      if (mounted) setState(() => _loadingCenter = false);
    }
  }

  Future<void> _pickDate() async {
    final advanceDays = context.read<OptionsProvider>().bookingAdvanceDays;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: advanceDays)),
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
        _autoCenter == null ||
        _serviceType == null ||
        _bookingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')));
      return;
    }
    final provider = context.read<BookingProvider>();
    final ok = await provider.createBooking({
      'vehicle_id': _selectedVehicle!.id,
      'service_center_id': _autoCenter!.id,
      'service_type': _serviceType,
      'booking_date': _bookingDate!.toIso8601String(),
      if (_notesCtrl.text.isNotEmpty) 'notes': _notesCtrl.text.trim(),
    });
    if (!mounted) return;
    if (ok) {
      context.go('/bookings');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(provider.error ?? 'Failed to create booking')));
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
                  // ── Vehicle ────────────────────────────────────────────────
                  _label('Select Vehicle'),
                  DropdownButtonFormField<VehicleModel>(
                    value: _selectedVehicle,
                    decoration: _dropDeco('Vehicle'),
                    items: vehicles
                        .map((v) => DropdownMenuItem(
                            value: v, child: Text(v.displayName)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedVehicle = v),
                    validator: (v) => v == null ? 'Select a vehicle' : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Service type (3.3 unified) ─────────────────────────────
                  _label('Service Type'),
                  DropdownButtonFormField<String>(
                    value: _serviceType,
                    decoration: _dropDeco('Service Type'),
                    items: VehicleServiceModel.serviceTypes
                        .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                                _serviceTypeLabels[s] ?? s)))
                        .toList(),
                    onChanged: (v) => setState(() => _serviceType = v),
                    validator: (v) =>
                        v == null ? 'Select service type' : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Service centre (3.2 auto-filled) ──────────────────────
                  _label('Service Centre'),
                  _loadingCenter
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : _autoCenter != null
                          ? _centerInfoTile(_autoCenter!)
                          : _noCenterBanner(),
                  const SizedBox(height: 16),

                  // ── Date & time ────────────────────────────────────────────
                  _label('Booking Date & Time'),
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
                    onPressed: _autoCenter != null ? _submit : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Auto-filled centre display tile
  Widget _centerInfoTile(ServiceCenterModel center) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2F7DE1).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.store_outlined,
              color: Color(0xFF2F7DE1), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(center.name,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A))),
                if (center.city != null)
                  Text(center.city!,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: const Color(0xFF7A7A7A))),
              ],
            ),
          ),
          const Icon(Icons.check_circle,
              color: Color(0xFF2F7DE1), size: 18),
        ],
      ),
    );
  }

  Widget _noCenterBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFD700)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFB8860B), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No service centre assigned to your account. '
              'Contact admin to be linked to a service centre.',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color(0xFF7A5C00)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600)),
      );

  InputDecoration _dropDeco(String label) => InputDecoration(
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

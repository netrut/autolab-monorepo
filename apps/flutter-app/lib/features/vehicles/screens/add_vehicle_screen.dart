import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/request_provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class AddVehicleScreen extends StatefulWidget {
  /// Non-null = edit mode (pre-fill existing vehicle data).
  final String? vehicleId;

  /// Pre-selected vehicle type from route query param (?type=car|bike).
  final String? initialType;

  const AddVehicleScreen({super.key, this.vehicleId, this.initialType});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _regCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _chassisCtrl = TextEditingController();

  late String _vehicleType;
  String? _fuelType;
  String? _transmission;

  // ── Reg lookup state ────────────────────────────────────────────────────────
  bool _regLookupLoading = false;
  bool _regExists = false;
  bool _showFields = false;
  String? _existingVehicleId;  // id of the already-registered vehicle
  String? _ownerId;            // owner's user_id for sending request

  bool get _isEditMode => widget.vehicleId != null;

  @override
  void initState() {
    super.initState();
    _vehicleType = widget.initialType ?? 'car';
    if (_isEditMode) {
      _showFields = true; // edit mode always shows all fields
      _loadExistingVehicle();
    }
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _regCtrl.dispose();
    _colorCtrl.dispose();
    _chassisCtrl.dispose();
    super.dispose();
  }

  // ── Edit mode: pre-fill form ────────────────────────────────────────────────

  Future<void> _loadExistingVehicle() async {
    final vehicle =
        await context.read<VehicleProvider>().fetchById(widget.vehicleId!);
    if (!mounted || vehicle == null) return;
    setState(() {
      _vehicleType = vehicle.vehicleType;
      _brandCtrl.text = vehicle.brand;
      _modelCtrl.text = vehicle.model;
      _yearCtrl.text = vehicle.year?.toString() ?? '';
      _regCtrl.text = vehicle.registrationNumber ?? '';
      _colorCtrl.text = vehicle.vehicleColor ?? '';
      _chassisCtrl.text = vehicle.chassisNumber ?? '';
      _fuelType = vehicle.fuelType;
      _transmission = vehicle.transmission;
    });
  }

  // ── Reg number lookup on blur ───────────────────────────────────────────────

  Future<void> _onRegBlur() async {
    final reg = _regCtrl.text.trim();
    if (reg.isEmpty) {
      setState(() { _showFields = false; _regExists = false; });
      return;
    }
    setState(() { _regLookupLoading = true; _regExists = false; });
    final result = await context.read<VehicleProvider>().lookupByReg(reg);
    if (!mounted) return;
    setState(() {
      _regLookupLoading = false;
      _regExists = result['exists'] == true;
      _showFields = !_regExists;
      if (_regExists) {
        final v = result['vehicle'] as VehicleModel?;
        _existingVehicleId = v?.id;
        _ownerId = result['ownerId'] as String?;
      }
    });
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<VehicleProvider>();
    final data = {
      'vehicle_type': _vehicleType,
      'brand': _brandCtrl.text.trim(),
      'model': _modelCtrl.text.trim(),
      if (_yearCtrl.text.isNotEmpty) 'year': int.tryParse(_yearCtrl.text),
      if (_regCtrl.text.isNotEmpty)
        'registration_number': _regCtrl.text.trim().toUpperCase(),
      if (_colorCtrl.text.isNotEmpty) 'vehicle_color': _colorCtrl.text.trim(),
      if (_chassisCtrl.text.isNotEmpty)
        'chassis_number': _chassisCtrl.text.trim().toUpperCase(),
      if (_fuelType != null) 'fuel_type': _fuelType,
      if (_transmission != null) 'transmission': _transmission,
    };

    final bool ok;
    if (_isEditMode) {
      ok = await provider.updateVehicle(widget.vehicleId!, data);
    } else {
      ok = await provider.addVehicle(data);
    }

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error ?? 'Failed to save vehicle')));
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Vehicle' : 'Add Vehicle'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Vehicle type ──────────────────────────────────────────
                  Text('Vehicle Type',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _typeChip('car', Icons.directions_car, 'Car / SUV'),
                      const SizedBox(width: 12),
                      _typeChip('bike', Icons.two_wheeler, 'Bike / Scooter'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Registration number + lookup ──────────────────────────
                  Text('Registration Number',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus && !_isEditMode) _onRegBlur();
                    },
                    child: AppTextField(
                      controller: _regCtrl,
                      label: 'Registration Number',
                      hint: 'GJ01AB1234',
                      textCapitalization: TextCapitalization.characters,
                      suffixIcon: _regLookupLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : _isEditMode
                              ? null
                              : IconButton(
                                  icon: const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF2F7DE1)),
                                  tooltip: 'Search registration number',
                                  onPressed: _onRegBlur,
                                ),
                    ),
                  ),

                  // ── Already registered banner ─────────────────────────────
                  if (_regExists) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFD700)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Color(0xFFB8860B), size: 20),
                              const SizedBox(width: 8),
                              Text('Vehicle Already Registered',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF7A5C00))),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'This registration number is already in the system. '
                            'You can request access from the owner.',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: const Color(0xFF7A5C00)),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () async {
                              if (_existingVehicleId == null || _ownerId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not find vehicle owner')));
                                return;
                              }
                              final ok = await context
                                  .read<RequestProvider>()
                                  .sendVehicleAccessRequest(
                                    vehicleId: _existingVehicleId!,
                                    toUserId: _ownerId!,
                                  );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(ok
                                    ? 'Request sent to owner!'
                                    : 'Failed to send request'),
                              ));
                            },
                            icon: const Icon(Icons.send_outlined, size: 16),
                            label: const Text('Send Request to Owner'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF7A5C00),
                              side: const BorderSide(color: Color(0xFFB8860B)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Remaining fields (hidden until reg passes lookup) ──────
                  if (_showFields || _isEditMode) ...[
                    const SizedBox(height: 16),
                    // 8.2 — Brand searchable autocomplete
                    _autocompleteField(
                      controller: _brandCtrl,
                      label: 'Brand',
                      hint: 'e.g. Maruti, Honda',
                      suggestions: provider.vehicles
                          .map((v) => v.brand)
                          .toSet()
                          .toList()
                        ..sort(),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Brand is required' : null,
                    ),
                    const SizedBox(height: 16),
                    // 8.2 — Model searchable autocomplete
                    _autocompleteField(
                      controller: _modelCtrl,
                      label: 'Model',
                      hint: 'e.g. Swift, Activa',
                      suggestions: provider.vehicles
                          .where((v) =>
                              _brandCtrl.text.isEmpty ||
                              v.brand.toLowerCase() ==
                                  _brandCtrl.text.toLowerCase())
                          .map((v) => v.model)
                          .toSet()
                          .toList()
                        ..sort(),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Model is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _yearCtrl,
                            label: 'Year',
                            hint: '2022',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            controller: _colorCtrl,
                            label: 'Color',
                            hint: 'White',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _chassisCtrl,
                      label: 'Chassis Number (optional)',
                      hint: 'MA3ERLF1S00123456',
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    _dropdownField(
                      label: 'Fuel Type',
                      value: _fuelType,
                      items: ['Petrol', 'Diesel', 'CNG', 'Electric', 'Hybrid'],
                      onChanged: (v) => setState(() => _fuelType = v),
                    ),
                    const SizedBox(height: 16),
                    _dropdownField(
                      label: 'Transmission',
                      value: _transmission,
                      items: ['Manual', 'Automatic'],
                      onChanged: (v) => setState(() => _transmission = v),
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: _isEditMode ? 'Save Changes' : 'Add Vehicle',
                      isLoading: provider.isLoading,
                      onPressed: _submit,
                    ),
                  ],

                  // ── Hint when reg field is empty (add mode) ───────────────
                  if (!_showFields && !_regExists && !_isEditMode) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Enter the registration number above to continue.',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: const Color(0xFF9E9E9E)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 8.2 — Searchable autocomplete field for brand/model
  Widget _autocompleteField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required List<String> suggestions,
    String? Function(String?)? validator,
  }) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (value) {
        if (value.text.isEmpty) return suggestions;
        return suggestions.where(
            (s) => s.toLowerCase().contains(value.text.toLowerCase()));
      },
      onSelected: (val) => controller.text = val,
      fieldViewBuilder: (ctx, ctrl, focusNode, onSubmit) {
        ctrl.text = controller.text;
        ctrl.addListener(() => controller.text = ctrl.text);
        return TextFormField(
          controller: ctrl,
          focusNode: focusNode,
          validator: validator,
          style: GoogleFonts.interTight(fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            labelStyle: GoogleFonts.interTight(
                color: const Color(0xFF57636C), fontSize: 14),
            hintStyle: GoogleFonts.interTight(
                color: const Color(0xFF57636C), fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF040404)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFF5963)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFF5963)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        );
      },
      optionsViewBuilder: (ctx, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (_, i) {
                final opt = options.elementAt(i);
                return ListTile(
                  dense: true,
                  title: Text(opt, style: GoogleFonts.poppins(fontSize: 13)),
                  onTap: () => onSelected(opt),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String type, IconData icon, String label) {
    final selected = _vehicleType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _vehicleType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1B1F26) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected
                    ? const Color(0xFF1B1F26)
                    : const Color(0xFFE0E3E7)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: selected ? Colors.white : const Color(0xFF57636C),
                  size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          selected ? Colors.white : const Color(0xFF57636C))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

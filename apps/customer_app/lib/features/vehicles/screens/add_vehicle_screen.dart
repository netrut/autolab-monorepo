import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/providers/request_provider.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_back_button.dart';

class AddVehicleScreen extends StatefulWidget {
  final String? vehicleId;
  final String? initialType;
  const AddVehicleScreen({super.key, this.vehicleId, this.initialType});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _regCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _chassisCtrl = TextEditingController();

  String _type = 'car';
  String? _fuelType;
  bool _loading = false;

  // Reg lookup state
  bool _regLookupLoading = false;
  bool _regExists = false;
  bool _showFields = false;
  String? _existingVehicleId;
  String? _ownerId;

  bool get _isEdit => widget.vehicleId != null;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? 'car';
    if (_isEdit) {
      _showFields = true;
      _loadVehicle();
    }
  }

  @override
  void dispose() {
    _regCtrl.dispose();
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _colorCtrl.dispose();
    _chassisCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadVehicle() async {
    final v = await context.read<VehicleProvider>().fetchById(widget.vehicleId!);
    if (v != null && mounted) {
      setState(() {
        _type = v.vehicleType;
        _regCtrl.text = v.registrationNumber ?? '';
        _brandCtrl.text = v.brand;
        _modelCtrl.text = v.model;
        _yearCtrl.text = v.year?.toString() ?? '';
        _colorCtrl.text = v.vehicleColor ?? '';
        _chassisCtrl.text = v.chassisNumber ?? '';
        _fuelType = v.fuelType;
      });
    }
  }

  Future<void> _onRegSearch() async {
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final data = {
      'vehicle_type': _type,
      'brand': _brandCtrl.text.trim(),
      'model': _modelCtrl.text.trim(),
      if (_yearCtrl.text.isNotEmpty) 'year': int.tryParse(_yearCtrl.text),
      if (_regCtrl.text.isNotEmpty) 'registration_number': _regCtrl.text.trim().toUpperCase(),
      if (_colorCtrl.text.isNotEmpty) 'vehicle_color': _colorCtrl.text.trim(),
      if (_chassisCtrl.text.isNotEmpty) 'chassis_number': _chassisCtrl.text.trim().toUpperCase(),
      if (_fuelType != null) 'fuel_type': _fuelType,
    };
    final provider = context.read<VehicleProvider>();
    final success = _isEdit ? await provider.updateVehicle(widget.vehicleId!, data) : await provider.addVehicle(data);
    setState(() => _loading = false);
    if (success && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: Text(_isEdit ? 'Edit Vehicle' : 'Add Vehicle'), leading: const AppBackButton()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Type
                Text('Vehicle Type', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _TypeChip(label: 'Car / SUV', icon: Icons.directions_car, selected: _type == 'car', onTap: () => setState(() => _type = 'car')),
                    const SizedBox(width: 12),
                    _TypeChip(label: 'Bike / Scooter', icon: Icons.two_wheeler, selected: _type == 'bike', onTap: () => setState(() => _type = 'bike')),
                  ],
                ),
                const SizedBox(height: 20),

                // Registration Number + Lookup
                Text('Registration Number', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus && !_isEdit && _regCtrl.text.isNotEmpty) _onRegSearch();
                  },
                  child: AppTextField(
                    controller: _regCtrl,
                    label: 'Registration Number',
                    hint: 'GJ01AB1234',
                    suffixIcon: _regLookupLoading
                        ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                        : _isEdit
                            ? null
                            : IconButton(icon: const Icon(Icons.search_rounded, color: AppTheme.primaryBlue), onPressed: _onRegSearch),
                  ),
                ),

                // Already registered banner
                if (_regExists) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.warning.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 20),
                            const SizedBox(width: 8),
                            Text('Vehicle Already Registered', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF7A5C00))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'This registration number is already in the system. You can request access from the owner.',
                          style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF7A5C00)),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () async {
                            if (_existingVehicleId == null || _ownerId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not find vehicle owner')));
                              return;
                            }
                            final ok = await context.read<RequestProvider>().sendVehicleAccessRequest(
                              vehicleId: _existingVehicleId!,
                              toUserId: _ownerId!,
                            );
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Request sent to owner!' : 'Failed to send request')));
                          },
                          icon: const Icon(Icons.send_outlined, size: 16),
                          label: const Text('Send Request to Owner'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF7A5C00),
                            side: BorderSide(color: AppTheme.warning),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Hint when waiting for reg lookup
                if (!_showFields && !_regExists && !_isEdit) ...[
                  const SizedBox(height: 16),
                  Text('Enter the registration number above to continue.', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
                ],

                // Full form fields (shown after reg passes or in edit mode)
                if (_showFields) ...[
                  const SizedBox(height: 20),
                  AppTextField(label: 'Brand *', controller: _brandCtrl, hint: 'e.g. Maruti, Honda', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  AppTextField(label: 'Model *', controller: _modelCtrl, hint: 'e.g. Swift, Activa', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: AppTextField(label: 'Year', controller: _yearCtrl, hint: '2022', keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: AppTextField(label: 'Color', controller: _colorCtrl, hint: 'White')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppTextField(label: 'Chassis Number (optional)', controller: _chassisCtrl, hint: 'MA3ERLF1S00123456'),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _fuelType,
                    decoration: const InputDecoration(labelText: 'Fuel Type'),
                    items: ['Petrol', 'Diesel', 'Electric', 'CNG', 'Hybrid'].map((f) => DropdownMenuItem(value: f.toLowerCase(), child: Text(f))).toList(),
                    onChanged: (v) => setState(() => _fuelType = v),
                  ),
                  const SizedBox(height: 28),
                  AppButton(label: _isEdit ? 'Save Changes' : 'Add Vehicle', isLoading: _loading, onPressed: _save),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? AppTheme.primary : AppTheme.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : AppTheme.secondaryText),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppTheme.secondaryText)),
            ],
          ),
        ),
      ),
    );
  }
}

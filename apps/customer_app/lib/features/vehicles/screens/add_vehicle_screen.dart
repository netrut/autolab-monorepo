import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class AddVehicleScreen extends StatefulWidget {
  final String? vehicleId;
  final String? initialType;
  const AddVehicleScreen({super.key, this.vehicleId, this.initialType});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'car';
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _regCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  String? _fuelType;
  bool _loading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? 'car';
    if (widget.vehicleId != null) {
      _isEdit = true;
      _loadVehicle();
    }
  }

  Future<void> _loadVehicle() async {
    final v = await context.read<VehicleProvider>().fetchById(widget.vehicleId!);
    if (v != null && mounted) {
      setState(() {
        _type = v.vehicleType;
        _brandCtrl.text = v.brand;
        _modelCtrl.text = v.model;
        _yearCtrl.text = v.year?.toString() ?? '';
        _regCtrl.text = v.registrationNumber ?? '';
        _colorCtrl.text = v.vehicleColor ?? '';
        _fuelType = v.fuelType;
      });
    }
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
      if (_fuelType != null) 'fuel_type': _fuelType,
    };
    final provider = context.read<VehicleProvider>();
    final success = _isEdit ? await provider.updateVehicle(widget.vehicleId!, data) : await provider.addVehicle(data);
    setState(() => _loading = false);
    if (success && mounted) context.pop();
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _regCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(_isEdit ? 'Edit Vehicle' : 'Add Vehicle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle Type', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _TypeChip(label: 'Car', icon: Icons.directions_car, selected: _type == 'car', onTap: () => setState(() => _type = 'car')),
                  const SizedBox(width: 10),
                  _TypeChip(label: 'Bike', icon: Icons.two_wheeler, selected: _type == 'bike', onTap: () => setState(() => _type = 'bike')),
                ],
              ),
              const SizedBox(height: 20),
              AppTextField(label: 'Brand *', controller: _brandCtrl, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 14),
              AppTextField(label: 'Model *', controller: _modelCtrl, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 14),
              AppTextField(label: 'Year', controller: _yearCtrl, keyboardType: TextInputType.number),
              const SizedBox(height: 14),
              AppTextField(label: 'Registration Number', controller: _regCtrl),
              const SizedBox(height: 14),
              AppTextField(label: 'Color', controller: _colorCtrl),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _fuelType,
                decoration: const InputDecoration(labelText: 'Fuel Type'),
                items: ['Petrol', 'Diesel', 'Electric', 'CNG', 'Hybrid'].map((f) => DropdownMenuItem(value: f.toLowerCase(), child: Text(f))).toList(),
                onChanged: (v) => setState(() => _fuelType = v),
              ),
              const SizedBox(height: 28),
              AppButton(label: _isEdit ? 'Update Vehicle' : 'Add Vehicle', isLoading: _loading, onPressed: _save),
            ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppTheme.primaryBlue : AppTheme.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? AppTheme.primaryBlue : AppTheme.secondaryText),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? AppTheme.primaryBlue : AppTheme.primaryText)),
          ],
        ),
      ),
    );
  }
}

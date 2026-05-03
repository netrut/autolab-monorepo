import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/vehicle_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

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

  String _vehicleType = 'car';
  String? _fuelType;
  String? _transmission;

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _regCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<VehicleProvider>();
    final ok = await provider.addVehicle({
      'vehicle_type': _vehicleType,
      'brand': _brandCtrl.text.trim(),
      'model': _modelCtrl.text.trim(),
      if (_yearCtrl.text.isNotEmpty) 'year': int.tryParse(_yearCtrl.text),
      if (_regCtrl.text.isNotEmpty)
        'registration_number': _regCtrl.text.trim(),
      if (_colorCtrl.text.isNotEmpty) 'vehicle_color': _colorCtrl.text.trim(),
      if (_fuelType != null) 'fuel_type': _fuelType,
      if (_transmission != null) 'transmission': _transmission,
    });
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error ?? 'Failed to add vehicle')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Vehicle')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle type selector
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
                  AppTextField(
                    controller: _brandCtrl,
                    label: 'Brand',
                    hint: 'e.g. Maruti, Honda',
                    validator: (v) => v!.isEmpty ? 'Brand is required' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _modelCtrl,
                    label: 'Model',
                    hint: 'e.g. Swift, Activa',
                    validator: (v) => v!.isEmpty ? 'Model is required' : null,
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
                    controller: _regCtrl,
                    label: 'Registration Number',
                    hint: 'GJ01AB1234',
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
                    label: 'Add Vehicle',
                    isLoading: provider.isLoading,
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
                      color: selected ? Colors.white : const Color(0xFF57636C))),
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

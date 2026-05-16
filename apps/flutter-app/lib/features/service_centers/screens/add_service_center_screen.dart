import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/api/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const _kPrimary = Color(0xFF1B1F26);
const _kAccent  = Color(0xFF2F7DE1);
const _kBg      = Color(0xFFF5F5F5);

const _categories = [
  ('service_center',    'Service Centre',       Icons.build_outlined),
  ('decor_accessories', 'Decor & Accessories',  Icons.chair_outlined),
  ('seller',            'Seller / Dealer',      Icons.storefront_outlined),
  ('other',             'Other',                Icons.more_horiz),
];

const _vehicleTypeOptions = ['Car', 'Bike', 'Both', 'Commercial'];
const _serviceTypeOptions  = [
  'General Service', 'Major Service', 'Denting & Painting',
  'AC Repair', 'Electrical', 'Tyres & Wheels', 'Emergency',
];
const _stateOptions = [
  'Andhra Pradesh','Arunachal Pradesh','Assam','Bihar','Chhattisgarh',
  'Goa','Gujarat','Haryana','Himachal Pradesh','Jharkhand','Karnataka',
  'Kerala','Madhya Pradesh','Maharashtra','Manipur','Meghalaya','Mizoram',
  'Nagaland','Odisha','Punjab','Rajasthan','Sikkim','Tamil Nadu','Telangana',
  'Tripura','Uttar Pradesh','Uttarakhand','West Bengal',
  'Delhi','Jammu & Kashmir','Ladakh','Chandigarh','Puducherry',
];

// ── Screen ────────────────────────────────────────────────────────────────────

class AddServiceCenterScreen extends StatefulWidget {
  /// Non-null = edit mode — pre-fills form with existing centre data.
  final String? centreId;
  const AddServiceCenterScreen({super.key, this.centreId});

  @override
  State<AddServiceCenterScreen> createState() => _AddServiceCenterScreenState();
}

class _AddServiceCenterScreenState extends State<AddServiceCenterScreen> {
  final _api = ApiClient();
  final _pageCtrl = PageController();

  int _step = 0;
  bool _saving = false;
  bool _loadingEdit = false;
  String? _createdId; // set after Step 1 creates the record

  // ── Step 1 controllers ────────────────────────────────────────────────────
  final _s1Form = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _descCtrl    = TextEditingController();
  String _category   = 'service_center';

  // ── Step 2 controllers ────────────────────────────────────────────────────
  final _addressCtrl  = TextEditingController();
  final _cityCtrl     = TextEditingController();
  String? _state;
  final _pincodeCtrl  = TextEditingController();
  final _mapsCtrl     = TextEditingController();

  // ── Step 3 state ──────────────────────────────────────────────────────────
  final Set<String> _vehicleTypes  = {};
  final Set<String> _serviceTypes  = {};
  final _hoursCtrl = TextEditingController();
  bool _acceptsBookings = true;

  // ── Step 4 controllers ────────────────────────────────────────────────────
  final _tradeNameCtrl  = TextEditingController();
  final _bizTypeCtrl    = TextEditingController();
  final _gstCtrl        = TextEditingController();
  final _panCtrl        = TextEditingController();
  final _shopRegCtrl    = TextEditingController();

  // ── Invoice template controllers ──────────────────────────────────────────
  final _invBizNameCtrl  = TextEditingController();
  final _invLogoCtrl     = TextEditingController();
  final _invFooterCtrl   = TextEditingController();
  final _invGstCtrl      = TextEditingController();
  final _invTermsCtrl    = TextEditingController();

  // ── Step 5 controllers ────────────────────────────────────────────────────
  final _ownerNameCtrl  = TextEditingController();
  final _ownerPhoneCtrl = TextEditingController();
  final _ownerEmailCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _aadhaarCtrl    = TextEditingController();

  bool get _isEditMode => widget.centreId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _createdId = widget.centreId;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadForEdit());
    }
  }

  Future<void> _loadForEdit() async {
    setState(() => _loadingEdit = true);
    try {
      final res = await _api.get(
          '/api/service-centers/onboard/${widget.centreId!}');
      final data = res.data as Map<String, dynamic>;
      setState(() {
        _nameCtrl.text    = data['name'] ?? '';
        _phoneCtrl.text   = data['phone'] ?? '';
        _emailCtrl.text   = data['email'] ?? '';
        _descCtrl.text    = data['description'] ?? '';
        _category         = data['category'] ?? 'service_center';
        _addressCtrl.text = data['address'] ?? '';
        _cityCtrl.text    = data['city'] ?? '';
        _state            = data['state'] as String?;
        _pincodeCtrl.text = data['pincode'] ?? '';
        _mapsCtrl.text    = data['maps_link'] ?? '';
        _hoursCtrl.text   = data['working_hours'] ?? '';
        _acceptsBookings  = data['accepts_bookings'] as bool? ?? true;
        final vt = data['vehicle_types'];
        if (vt is List) _vehicleTypes.addAll(vt.map((e) => e.toString()));
        final st = data['service_types'];
        if (st is List) _serviceTypes.addAll(st.map((e) => e.toString()));
        final det = data['details'] as Map<String, dynamic>?;
        if (det != null) {
          _tradeNameCtrl.text   = det['trade_name'] ?? '';
          _bizTypeCtrl.text     = det['business_type'] ?? '';
          _gstCtrl.text         = det['gst_number'] ?? '';
          _panCtrl.text         = det['pan_number'] ?? '';
          _shopRegCtrl.text     = det['shop_reg_number'] ?? '';
          _ownerNameCtrl.text   = det['owner_name'] ?? '';
          _ownerPhoneCtrl.text  = det['owner_phone'] ?? '';
          _ownerEmailCtrl.text  = det['owner_email'] ?? '';
          _designationCtrl.text = det['designation'] ?? '';
          _aadhaarCtrl.text     = det['aadhaar_last4'] ?? '';
          _invBizNameCtrl.text  = det['invoice_business_name'] ?? '';
          _invLogoCtrl.text     = det['invoice_logo_url'] ?? '';
          _invFooterCtrl.text   = det['invoice_footer'] ?? '';
          _invGstCtrl.text      = det['invoice_gst_percent']?.toString() ?? '';
          _invTermsCtrl.text    = det['invoice_terms'] ?? '';
        }
      });
    } catch (_) {}
    setState(() => _loadingEdit = false);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    for (final c in [
      _nameCtrl, _phoneCtrl, _emailCtrl, _descCtrl,
      _addressCtrl, _cityCtrl, _pincodeCtrl, _mapsCtrl,
      _hoursCtrl,
      _tradeNameCtrl, _bizTypeCtrl, _gstCtrl, _panCtrl, _shopRegCtrl,
      _invBizNameCtrl, _invLogoCtrl, _invFooterCtrl, _invGstCtrl, _invTermsCtrl,
      _ownerNameCtrl, _ownerPhoneCtrl, _ownerEmailCtrl,
      _designationCtrl, _aadhaarCtrl,
    ]) { c.dispose(); }
    super.dispose();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _goTo(int step) {
    setState(() => _step = step);
    _pageCtrl.animateToPage(step,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> _nextFromStep1() async {
    if (!_s1Form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (_isEditMode) {
        // Edit mode: update existing record
        await _api.put('/api/service-centers/${_createdId!}', data: {
          'name':        _nameCtrl.text.trim(),
          'phone':       _phoneCtrl.text.trim(),
          'email':       _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
          'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          'category':    _category,
        });
        _goTo(1);
      } else {
        final res = await _api.post('/api/service-centers/onboard', data: {
          'name':     _nameCtrl.text.trim(),
          'phone':    _phoneCtrl.text.trim(),
          'email':    _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
          'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          'category': _category,
        });
        _createdId = res.data['id'] as String;
        _goTo(1);
      }
    } catch (e) {
      _snack(_parseError(e));
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _saveStep(Map<String, dynamic> data, int nextStep) async {
    if (_createdId == null) { _goTo(nextStep); return; }
    setState(() => _saving = true);
    try {
      // Steps 2 update core service_centers fields
      if (nextStep <= 3) {
        await _api.put('/api/service-centers/${_createdId!}', data: data);
      } else {
        // Steps 4-5 update details
        await _api.put(
            '/api/service-centers/onboard/${_createdId!}/details', data: data);
      }
      _goTo(nextStep);
    } catch (e) {
      final msg = _parseError(e);
      if (msg.contains('owner') || msg.contains('admin') || msg.contains('authorised')) {
        _snack(msg);
      } else {
        _goTo(nextStep); // non-fatal for other errors — skip silently
      }
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    if (_createdId == null) { context.pop(); return; }
    setState(() => _saving = true);
    try {
      // Save step 5 details first
      if (_ownerNameCtrl.text.isNotEmpty || _gstCtrl.text.isNotEmpty) {
        await _api.put(
            '/api/service-centers/onboard/${_createdId!}/details',
            data: {
              if (_ownerNameCtrl.text.isNotEmpty)
                'owner_name': _ownerNameCtrl.text.trim(),
              if (_ownerPhoneCtrl.text.isNotEmpty)
                'owner_phone': _ownerPhoneCtrl.text.trim(),
              if (_ownerEmailCtrl.text.isNotEmpty)
                'owner_email': _ownerEmailCtrl.text.trim(),
              if (_designationCtrl.text.isNotEmpty)
                'designation': _designationCtrl.text.trim(),
              if (_aadhaarCtrl.text.length == 4)
                'aadhaar_last4': _aadhaarCtrl.text.trim(),
            });
      }
      await _api.put(
          '/api/service-centers/onboard/${_createdId!}/submit', data: {});
      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      _snack('Submission failed. Please try again.');
    } finally {
      setState(() => _saving = false);
    }
  }

  String _parseError(dynamic e) {
    if (e is DioException && e.response?.data is Map) {
      final msg = (e.response!.data as Map)['error'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return 'Something went wrong. Please try again.';
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                  color: const Color(0xFFE8F7EE),
                  shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline,
                  color: Color(0xFF2F9E56), size: 36),
            ),
            const SizedBox(height: 16),
            Text('Submitted!',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Your service centre has been submitted for review. '
              'You will be notified once it is verified.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF7A7A7A)),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Done',
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  static const _stepTitles = [
    'Basic Info',
    'Location',
    'Services',
    'Business Details',
    'Owner Details',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: _kPrimary),
            onPressed: () => _step > 0 ? _goTo(_step - 1) : context.pop(),
          ),
          title: Text(_isEditMode ? 'Edit Service Centre' : 'Add Service Centre',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _kPrimary)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: _StepHeader(current: _step, titles: _stepTitles),
          ),
        ),
        body: PageView(
          controller: _pageCtrl,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _Step1BasicInfo(
              formKey: _s1Form,
              nameCtrl: _nameCtrl,
              phoneCtrl: _phoneCtrl,
              emailCtrl: _emailCtrl,
              descCtrl: _descCtrl,
              category: _category,
              onCategoryChanged: (v) => setState(() => _category = v),
              saving: _saving,
              onNext: _nextFromStep1,
            ),
            _Step2Location(
              addressCtrl: _addressCtrl,
              cityCtrl: _cityCtrl,
              state: _state,
              onStateChanged: (v) => setState(() => _state = v),
              pincodeCtrl: _pincodeCtrl,
              mapsCtrl: _mapsCtrl,
              saving: _saving,
              onSkip: () => _goTo(2),
              onNext: () => _saveStep({
                'address': _addressCtrl.text.trim(),
                'city':    _cityCtrl.text.trim(),
                'state':   _state,
                'pincode': _pincodeCtrl.text.trim(),
                'maps_link': _mapsCtrl.text.trim().isEmpty
                    ? null : _mapsCtrl.text.trim(),
              }, 2),
            ),
            _Step3Services(
              vehicleTypes: _vehicleTypes,
              serviceTypes: _serviceTypes,
              hoursCtrl: _hoursCtrl,
              acceptsBookings: _acceptsBookings,
              onAcceptsChanged: (v) => setState(() => _acceptsBookings = v),
              saving: _saving,
              onSkip: () => _goTo(3),
              onNext: () => _saveStep({
                'vehicle_types':  _vehicleTypes.toList(),
                'service_types':  _serviceTypes.toList(),
                'working_hours':  _hoursCtrl.text.trim().isEmpty
                    ? null : _hoursCtrl.text.trim(),
                'accepts_bookings': _acceptsBookings,
              }, 3),
            ),
            _Step4Business(
              tradeNameCtrl: _tradeNameCtrl,
              bizTypeCtrl: _bizTypeCtrl,
              gstCtrl: _gstCtrl,
              panCtrl: _panCtrl,
              shopRegCtrl: _shopRegCtrl,
              invBizNameCtrl: _invBizNameCtrl,
              invLogoCtrl: _invLogoCtrl,
              invFooterCtrl: _invFooterCtrl,
              invGstCtrl: _invGstCtrl,
              invTermsCtrl: _invTermsCtrl,
              saving: _saving,
              onSkip: () => _goTo(4),
              onNext: () => _saveStep({
                if (_tradeNameCtrl.text.isNotEmpty)
                  'trade_name': _tradeNameCtrl.text.trim(),
                if (_bizTypeCtrl.text.isNotEmpty)
                  'business_type': _bizTypeCtrl.text.trim(),
                if (_gstCtrl.text.isNotEmpty)
                  'gst_number': _gstCtrl.text.trim().toUpperCase(),
                if (_panCtrl.text.isNotEmpty)
                  'pan_number': _panCtrl.text.trim().toUpperCase(),
                if (_shopRegCtrl.text.isNotEmpty)
                  'shop_reg_number': _shopRegCtrl.text.trim(),
                if (_invBizNameCtrl.text.isNotEmpty)
                  'invoice_business_name': _invBizNameCtrl.text.trim(),
                if (_invLogoCtrl.text.isNotEmpty)
                  'invoice_logo_url': _invLogoCtrl.text.trim(),
                if (_invFooterCtrl.text.isNotEmpty)
                  'invoice_footer': _invFooterCtrl.text.trim(),
                if (_invGstCtrl.text.isNotEmpty)
                  'invoice_gst_percent': _invGstCtrl.text.trim(),
                if (_invTermsCtrl.text.isNotEmpty)
                  'invoice_terms': _invTermsCtrl.text.trim(),
              }, 4),
            ),
            _Step5Owner(
              ownerNameCtrl: _ownerNameCtrl,
              ownerPhoneCtrl: _ownerPhoneCtrl,
              ownerEmailCtrl: _ownerEmailCtrl,
              designationCtrl: _designationCtrl,
              aadhaarCtrl: _aadhaarCtrl,
              saving: _saving,
              onSubmit: _submit,
              onSkip: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step header with progress ─────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final int current;
  final List<String> titles;
  const _StepHeader({required this.current, required this.titles});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(titles.length, (i) {
              final done    = i < current;
              final active  = i == current;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: done || active
                              ? _kAccent
                              : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (i < titles.length - 1) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${current + 1} of ${titles.length}  •  ${titles[current]}',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kAccent),
              ),
              if (current > 0)
                Text('${((current / titles.length) * 100).round()}% complete',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: const Color(0xFF9E9E9E))),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared step wrapper ───────────────────────────────────────────────────────

class _StepWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final Widget footer;

  const _StepWrapper({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _kPrimary)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: const Color(0xFF7A7A7A))),
                const SizedBox(height: 20),
                body,
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: footer,
        ),
      ],
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

Widget _sectionLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: GoogleFonts.poppins(
              fontSize: 13, fontWeight: FontWeight.w600, color: _kPrimary)),
    );

Widget _multiChip(
    String label, bool selected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? _kAccent : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: selected ? _kAccent : const Color(0xFFDDDDDD)),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF5A5A5A))),
    ),
  );
}

InputDecoration _inputDeco(String label, {String? hint}) => InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      labelStyle: GoogleFonts.poppins(
          fontSize: 13, color: const Color(0xFF57636C)),
      hintStyle: GoogleFonts.poppins(
          fontSize: 13, color: const Color(0xFF9E9E9E)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E3E7))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kAccent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF5963))),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF5963))),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );

// ── Step 1 — Basic Info (mandatory) ──────────────────────────────────────────

class _Step1BasicInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, phoneCtrl, emailCtrl, descCtrl;
  final String category;
  final ValueChanged<String> onCategoryChanged;
  final bool saving;
  final VoidCallback onNext;

  const _Step1BasicInfo({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.descCtrl,
    required this.category,
    required this.onCategoryChanged,
    required this.saving,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: 'Basic Information',
      subtitle: 'Required to register your service centre',
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category selector
            _sectionLabel('Category'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.2,
              children: _categories.map((c) {
                final selected = category == c.$1;
                return GestureDetector(
                  onTap: () => onCategoryChanged(c.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: selected ? _kPrimary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: selected
                              ? _kPrimary
                              : const Color(0xFFE0E3E7)),
                    ),
                    child: Row(
                      children: [
                        Icon(c.$3,
                            size: 18,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF5A5A5A)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(c.$2,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF3A3A3A)),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Name
            _sectionLabel('Business Name *'),
            TextFormField(
              controller: nameCtrl,
              decoration: _inputDeco('Service Centre Name',
                  hint: 'e.g. Friends Auto Service'),
              style: GoogleFonts.poppins(fontSize: 14),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),

            // Phone
            _sectionLabel('Primary Phone *'),
            TextFormField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: _inputDeco('Phone Number', hint: '9876543210'),
              style: GoogleFonts.poppins(fontSize: 14),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Phone is required';
                if (v.trim().length < 10) return 'Enter valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Email
            _sectionLabel('Business Email'),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDeco('Email Address (optional)',
                  hint: 'service@example.com'),
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 14),

            // Description
            _sectionLabel('Description'),
            TextFormField(
              controller: descCtrl,
              maxLines: 3,
              decoration: _inputDeco('Brief description (optional)',
                  hint: 'What makes your service centre special?'),
              style: GoogleFonts.poppins(fontSize: 14),
            ),

            // Mandatory note
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _kAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: _kAccent, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Steps 2–5 are optional. You can complete them later from your profile.',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: _kAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      footer: AppButton(
        label: 'Continue',
        isLoading: saving,
        onPressed: onNext,
      ),
    );
  }
}

// ── Step 2 — Location ─────────────────────────────────────────────────────────

class _Step2Location extends StatelessWidget {
  final TextEditingController addressCtrl, cityCtrl, pincodeCtrl, mapsCtrl;
  final String? state;
  final ValueChanged<String?> onStateChanged;
  final bool saving;
  final VoidCallback onSkip, onNext;

  const _Step2Location({
    required this.addressCtrl,
    required this.cityCtrl,
    required this.state,
    required this.onStateChanged,
    required this.pincodeCtrl,
    required this.mapsCtrl,
    required this.saving,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: 'Location Details',
      subtitle: 'Help customers find you easily',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Address'),
          TextFormField(
            controller: addressCtrl,
            maxLines: 2,
            decoration: _inputDeco('Street Address',
                hint: 'Shop No, Building, Street'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: cityCtrl,
                  decoration: _inputDeco('City', hint: 'Jaipur'),
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: pincodeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDeco('Pincode', hint: '302001'),
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _sectionLabel('State'),
          DropdownButtonFormField<String>(
            value: state,
            decoration: _inputDeco('Select State'),
            style: GoogleFonts.poppins(fontSize: 14, color: _kPrimary),
            items: _stateOptions
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: onStateChanged,
          ),
          const SizedBox(height: 14),
          _sectionLabel('Google Maps Link (optional)'),
          TextFormField(
            controller: mapsCtrl,
            decoration: _inputDeco('Maps URL',
                hint: 'https://maps.google.com/...'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onSkip,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Skip',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7A7A7A))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: AppButton(
                label: 'Save & Continue',
                isLoading: saving,
                onPressed: onNext),
          ),
        ],
      ),
    );
  }
}

// ── Step 3 — Services ─────────────────────────────────────────────────────────

class _Step3Services extends StatelessWidget {
  final Set<String> vehicleTypes, serviceTypes;
  final TextEditingController hoursCtrl;
  final bool acceptsBookings, saving;
  final ValueChanged<bool> onAcceptsChanged;
  final VoidCallback onSkip, onNext;

  const _Step3Services({
    required this.vehicleTypes,
    required this.serviceTypes,
    required this.hoursCtrl,
    required this.acceptsBookings,
    required this.onAcceptsChanged,
    required this.saving,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: 'Services Offered',
      subtitle: 'Used for search & filter in the app',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Vehicle Types Serviced'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _vehicleTypeOptions.map((t) {
              final sel = vehicleTypes.contains(t);
              return _multiChip(t, sel, () {
                if (sel) {
                  vehicleTypes.remove(t);
                } else {
                  vehicleTypes.add(t);
                }
                // trigger rebuild via parent setState
                (context as Element).markNeedsBuild();
              });
            }).toList(),
          ),
          const SizedBox(height: 20),
          _sectionLabel('Service Types Offered'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _serviceTypeOptions.map((t) {
              final sel = serviceTypes.contains(t);
              return _multiChip(t, sel, () {
                if (sel) {
                  serviceTypes.remove(t);
                } else {
                  serviceTypes.add(t);
                }
                (context as Element).markNeedsBuild();
              });
            }).toList(),
          ),
          const SizedBox(height: 20),
          _sectionLabel('Working Hours'),
          TextFormField(
            controller: hoursCtrl,
            decoration: _inputDeco('e.g. Mon–Sat 9am–7pm'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accept Online Bookings',
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('Allow customers to book via the app',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: const Color(0xFF9E9E9E))),
                  ],
                ),
              ),
              Switch.adaptive(
                value: acceptsBookings,
                activeColor: _kAccent,
                onChanged: onAcceptsChanged,
              ),
            ],
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onSkip,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Skip',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7A7A7A))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: AppButton(
                label: 'Save & Continue',
                isLoading: saving,
                onPressed: onNext),
          ),
        ],
      ),
    );
  }
}

// ── Step 4 — Business Details ─────────────────────────────────────────────────

class _Step4Business extends StatelessWidget {
  final TextEditingController tradeNameCtrl, bizTypeCtrl, gstCtrl,
      panCtrl, shopRegCtrl;
  final TextEditingController invBizNameCtrl, invLogoCtrl, invFooterCtrl,
      invGstCtrl, invTermsCtrl;
  final bool saving;
  final VoidCallback onSkip, onNext;

  const _Step4Business({
    required this.tradeNameCtrl,
    required this.bizTypeCtrl,
    required this.gstCtrl,
    required this.panCtrl,
    required this.shopRegCtrl,
    required this.invBizNameCtrl,
    required this.invLogoCtrl,
    required this.invFooterCtrl,
    required this.invGstCtrl,
    required this.invTermsCtrl,
    required this.saving,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: 'Business Details',
      subtitle: 'Legal information for verification',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Trade Name (if different)'),
          TextFormField(
            controller: tradeNameCtrl,
            decoration: _inputDeco('Trade / Brand Name'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Business Type'),
          DropdownButtonFormField<String>(
            value: bizTypeCtrl.text.isEmpty ? null : bizTypeCtrl.text,
            decoration: _inputDeco('Select Business Type'),
            style: GoogleFonts.poppins(fontSize: 14, color: _kPrimary),
            items: const [
              'Proprietorship', 'Partnership', 'Pvt Ltd', 'LLP', 'Other',
            ]
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => bizTypeCtrl.text = v ?? '',
          ),
          const SizedBox(height: 14),
          _sectionLabel('GST Number'),
          TextFormField(
            controller: gstCtrl,
            textCapitalization: TextCapitalization.characters,
            decoration: _inputDeco('GST Number',
                hint: '27AAPFU0939F1ZV'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('PAN Number'),
          TextFormField(
            controller: panCtrl,
            textCapitalization: TextCapitalization.characters,
            decoration: _inputDeco('Business PAN', hint: 'AAPFU0939F'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Shop / Establishment Reg No (optional)'),
          TextFormField(
            controller: shopRegCtrl,
            decoration: _inputDeco('Registration Number'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),

          // ── Invoice Template Settings ──────────────────────────────────────
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: _kAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Invoice Template Settings',
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: _kAccent)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Business Name (on invoice)'),
          TextFormField(
            controller: invBizNameCtrl,
            decoration: _inputDeco('Invoice Header Name',
                hint: 'e.g. Friends Auto Service Pvt Ltd'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Logo URL'),
          TextFormField(
            controller: invLogoCtrl,
            decoration: _inputDeco('Logo Image URL (optional)',
                hint: 'https://...'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('GST % (for invoice)'),
          TextFormField(
            controller: invGstCtrl,
            keyboardType: TextInputType.number,
            decoration: _inputDeco('GST Percentage', hint: '18'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Invoice Footer'),
          TextFormField(
            controller: invFooterCtrl,
            maxLines: 2,
            decoration: _inputDeco('Footer text',
                hint: 'Thank you for your business!'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Terms & Conditions'),
          TextFormField(
            controller: invTermsCtrl,
            maxLines: 3,
            decoration: _inputDeco('Terms (optional)',
                hint: 'Warranty valid for 30 days...'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onSkip,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Skip',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7A7A7A))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: AppButton(
                label: 'Save & Continue',
                isLoading: saving,
                onPressed: onNext),
          ),
        ],
      ),
    );
  }
}

// ── Step 5 — Owner Details ────────────────────────────────────────────────────

class _Step5Owner extends StatelessWidget {
  final TextEditingController ownerNameCtrl, ownerPhoneCtrl, ownerEmailCtrl,
      designationCtrl, aadhaarCtrl;
  final bool saving;
  final VoidCallback onSubmit, onSkip;

  const _Step5Owner({
    required this.ownerNameCtrl,
    required this.ownerPhoneCtrl,
    required this.ownerEmailCtrl,
    required this.designationCtrl,
    required this.aadhaarCtrl,
    required this.saving,
    required this.onSubmit,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: 'Owner / Contact Person',
      subtitle: 'Person responsible for this service centre',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Owner Full Name'),
          TextFormField(
            controller: ownerNameCtrl,
            decoration: _inputDeco('As per Aadhaar / PAN'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Owner Phone'),
          TextFormField(
            controller: ownerPhoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: _inputDeco('Contact Number'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Owner Email (optional)'),
          TextFormField(
            controller: ownerEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDeco('Email Address'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Designation'),
          DropdownButtonFormField<String>(
            value: designationCtrl.text.isEmpty ? null : designationCtrl.text,
            decoration: _inputDeco('Select Designation'),
            style: GoogleFonts.poppins(fontSize: 14, color: _kPrimary),
            items: const ['Owner', 'Director', 'Manager', 'Partner']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => designationCtrl.text = v ?? '',
          ),
          const SizedBox(height: 14),
          _sectionLabel('Aadhaar — Last 4 Digits Only'),
          TextFormField(
            controller: aadhaarCtrl,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: _inputDeco('Last 4 digits', hint: 'XXXX'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 4),
          // Privacy note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFD54F)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline,
                    color: Color(0xFFB8860B), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'We only store the last 4 digits of Aadhaar for verification. '
                    'Your data is kept secure.',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: const Color(0xFF7A5C00)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: 'Submit for Review',
            isLoading: saving,
            onPressed: onSubmit,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: saving ? null : onSkip,
            child: Text('Skip & Submit Later',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF7A7A7A))),
          ),
        ],
      ),
    );
  }
}

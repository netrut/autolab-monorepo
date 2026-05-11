import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/service_centre_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.verifyOtp(
      phone: widget.phone,
      otp: _otpCtrl.text.trim(),
    );
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.error ?? 'Invalid OTP')));
      return;
    }
    // Post-login: resolve service centre
    final scProvider = context.read<ServiceCentreProvider>();
    final action = await scProvider.resolveAfterLogin();
    if (!mounted) return;
    switch (action) {
      case SetupAction.goHome:
      case SetupAction.autoSet:
        context.go('/home');
      case SetupAction.onboard:
        context.go('/service-centers/onboard');
      case SetupAction.pickCentre:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20))),
          builder: (_) => _CentrePickerSheet(provider: scProvider),
        );
        if (mounted) context.go('/home');
    }
  }

  Future<void> _resend() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.sendOtp(widget.phone);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok ? 'OTP resent!' : auth.error ?? 'Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Verify OTP')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter OTP',
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('OTP sent to ${widget.phone}',
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF57636C))),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _otpCtrl,
                    label: 'OTP',
                    hint: '6-digit OTP',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v!.length != 6 ? 'Enter 6-digit OTP' : null,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Verify',
                    isLoading: auth.isLoading,
                    onPressed: _verify,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: auth.isLoading ? null : _resend,
                      child: const Text('Resend OTP'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Centre picker sheet ───────────────────────────────────────────────────────

class _CentrePickerSheet extends StatefulWidget {
  final ServiceCentreProvider provider;
  const _CentrePickerSheet({required this.provider});

  @override
  State<_CentrePickerSheet> createState() => _CentrePickerSheetState();
}

class _CentrePickerSheetState extends State<_CentrePickerSheet> {
  UserServiceCentre? _selected;

  @override
  Widget build(BuildContext context) {
    final centres = widget.provider.centres;
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom +
              16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Active Centre',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  'You are linked to ${centres.length} service centres. '
                  'Choose which one to work in now.',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: const Color(0xFF7A7A7A)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          ...centres.map((c) {
            final isSelected = _selected?.id == c.id;
            return ListTile(
              onTap: () => setState(() => _selected = c),
              selected: isSelected,
              selectedTileColor: const Color(0xFFEAF2FF),
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1B1F26)
                      : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.store_outlined,
                    size: 20,
                    color: isSelected ? Colors.white : const Color(0xFF5A5A5A)),
              ),
              title: Text(c.name,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
              subtitle: Text(
                c.roleLabel + (c.city != null ? '  •  ${c.city}' : ''),
                style: GoogleFonts.poppins(
                    fontSize: 11, color: const Color(0xFF9E9E9E)),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle,
                      color: Color(0xFF2F7DE1), size: 22)
                  : null,
            );
          }),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected == null
                    ? null
                    : () async {
                        await widget.provider.switchTo(_selected!);
                        if (context.mounted) Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B1F26),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                    'Continue with ${_selected?.name ?? 'selected centre'}',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

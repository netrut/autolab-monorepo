import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpCtrl = TextEditingController();

  Future<void> _verify() async {
    if (_otpCtrl.text.length < 4) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(phone: widget.phone, otp: _otpCtrl.text.trim());
    if (success && mounted) context.go('/home');
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(backgroundColor: AppTheme.surface, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify OTP', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.primaryText)),
              const SizedBox(height: 4),
              Text('Enter the code sent to ${widget.phone}', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.secondaryText)),
              const SizedBox(height: 32),
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 8),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(counterText: ''),
              ),
              if (auth.error != null) ...[
                const SizedBox(height: 12),
                Text(auth.error!, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.error)),
              ],
              const SizedBox(height: 28),
              AppButton(label: 'Verify', isLoading: auth.isLoading, onPressed: _verify),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: auth.isLoading ? null : () => context.read<AuthProvider>().sendOtp(widget.phone),
                  child: Text('Resend OTP', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.primaryBlue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

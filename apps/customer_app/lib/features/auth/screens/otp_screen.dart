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
    final ok = await context.read<AuthProvider>().verifyOtp(phone: widget.phone, otp: _otpCtrl.text.trim());
    if (!mounted) return;
    if (ok) {
      context.go('/home');
    } else {
      final auth = context.read<AuthProvider>();
      if (auth.wrongApp) {
        showDialog(context: context, builder: (_) => const _WrongAppDialog());
      } else if (auth.phoneNotFound) {
        showDialog(context: context, builder: (_) => _PhoneNotFoundDialog(phone: widget.phone));
      }
      // error text already shown via auth.error in build
    }
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

// ── Wrong App Dialog ──────────────────────────────────────────────────────────

class _WrongAppDialog extends StatelessWidget {
  const _WrongAppDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.store_outlined, color: AppTheme.primaryBlue, size: 28),
          ),
          const SizedBox(height: 16),
          Text('Wrong App',
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Your account is registered as an AutoLab Service Centre Partner. Please use the AutoLab Partner App to login and manage your service centre.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppTheme.secondaryText, height: 1.5),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: GoogleFonts.poppins(color: AppTheme.secondaryText)),
        ),
      ],
    );
  }
}

// ── Phone Not Found Dialog ────────────────────────────────────────────────────

class _PhoneNotFoundDialog extends StatelessWidget {
  final String phone;
  const _PhoneNotFoundDialog({required this.phone});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.phone_missed_outlined, color: AppTheme.warning, size: 28),
          ),
          const SizedBox(height: 16),
          Text('Number Not Registered',
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('We couldn\'t find an account linked to',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(phone,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryText)),
          ),
          const SizedBox(height: 10),
          Text('Please check the number or create a new account.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppTheme.secondaryText, height: 1.5)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.pop();
          },
          child: Text('Change Number', style: GoogleFonts.poppins(color: AppTheme.secondaryText)),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            context.push('/auth/register');
          },
          icon: const Icon(Icons.person_add_outlined, size: 16),
          label: Text('Create Account',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

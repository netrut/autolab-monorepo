import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  Future<void> _submit() async {
    if (_emailCtrl.text.isEmpty) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.forgotPassword(_emailCtrl.text.trim());
    if (success && mounted) setState(() => _sent = true);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
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
              Text('Forgot Password', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.primaryText)),
              const SizedBox(height: 4),
              Text('Enter your email to receive a reset link', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.secondaryText)),
              const SizedBox(height: 32),
              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text('Reset link sent! Check your email.', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.success)),
                ),
              ] else ...[
                AppTextField(label: 'Email', controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
                if (auth.error != null) ...[
                  const SizedBox(height: 12),
                  Text(auth.error!, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.error)),
                ],
                const SizedBox(height: 28),
                AppButton(label: 'Send Reset Link', isLoading: auth.isLoading, onPressed: _submit),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

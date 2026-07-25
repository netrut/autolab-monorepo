import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isEmailMode = true;
  bool _passwordVisible = false;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _showEmailNotVerifiedDialog(String email) {
    showDialog(
      context: context,
      builder: (_) => _EmailNotVerifiedDialog(email: email),
    );
  }

  void _showLoginErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.lock_outline_rounded, color: AppTheme.error, size: 28),
            ),
            const SizedBox(height: 16),
            Text('Login Failed', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'The email or password you entered is incorrect. Please try again or reset your password.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Try Again', style: GoogleFonts.poppins(color: AppTheme.secondaryText)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.push('/auth/forgot-password');
            },
            icon: const Icon(Icons.key_outlined, size: 16),
            label: Text('Forgot Password', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    auth.clearError();

    if (_isEmailMode) {
      final ok = await auth.loginWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text);
      if (!mounted) return;
      if (ok) {
        context.go('/home');
      } else {
        if (!mounted) return;
        final freshAuth = context.read<AuthProvider>();
        if (freshAuth.wrongApp) {
          showDialog(context: context, builder: (_) => const _WrongAppDialog());
        } else if (freshAuth.emailNotVerified) {
          _showEmailNotVerifiedDialog(freshAuth.unverifiedEmail ?? _emailCtrl.text.trim());
        } else {
          _showLoginErrorDialog();
        }
      }
    } else {
      final phone = '+91${_phoneCtrl.text.trim()}';
      final ok = await auth.sendOtp(phone);
      if (!mounted) return;
      if (ok) {
        context.push('/auth/otp?phone=${Uri.encodeComponent(phone)}');
      } else {
        final freshAuth = context.read<AuthProvider>();
        if (freshAuth.phoneNotFound) {
          showDialog(context: context, builder: (_) => _PhoneNotFoundDialog(phone: phone));
        } else if (freshAuth.wrongApp) {
          showDialog(context: context, builder: (_) => const _WrongAppDialog());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(freshAuth.error ?? 'Failed to send OTP')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Text('Welcome', style: GoogleFonts.interTight(fontSize: 28, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Please enter your details to login', style: GoogleFonts.interTight(fontSize: 14, color: AppTheme.secondaryText)),
                  const SizedBox(height: 24),

                  // Email / Phone toggle
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _toggleTab('Email', _isEmailMode, () => setState(() => _isEmailMode = true)),
                        _toggleTab('Phone', !_isEmailMode, () => setState(() => _isEmailMode = false)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_isEmailMode) ...[
                    AppTextField(
                      controller: _emailCtrl,
                      label: 'Email Address',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Email is required' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordCtrl,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: !_passwordVisible,
                      validator: (v) => v!.isEmpty ? 'Password is required' : null,
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/auth/forgot-password'),
                        child: Text('Forgot Password?', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.primaryBlue)),
                      ),
                    ),
                  ] else ...[
                    AppTextField(
                      controller: _phoneCtrl,
                      label: 'Mobile Number',
                      hint: '9876543210',
                      keyboardType: TextInputType.phone,
                      prefixText: '+91 ',
                      validator: (v) => v!.length < 10 ? 'Enter valid mobile number' : null,
                    ),
                  ],

                  const SizedBox(height: 24),
                  AppButton(
                    label: _isEmailMode ? 'Login with Email' : 'Send OTP',
                    isLoading: auth.isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: GoogleFonts.interTight(color: AppTheme.secondaryText)),
                      GestureDetector(
                        onTap: () => context.push('/auth/register'),
                        child: Text('Sign Up', style: GoogleFonts.interTight(fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _toggleTab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppTheme.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Email Not Verified Dialog ─────────────────────────────────────────────────

class _EmailNotVerifiedDialog extends StatefulWidget {
  final String email;
  const _EmailNotVerifiedDialog({required this.email});

  @override
  State<_EmailNotVerifiedDialog> createState() => _EmailNotVerifiedDialogState();
}

class _EmailNotVerifiedDialogState extends State<_EmailNotVerifiedDialog> {
  bool _sending = false;
  bool _sent = false;

  Future<void> _resend() async {
    setState(() => _sending = true);
    final ok = await context.read<AuthProvider>().resendVerificationEmail(widget.email);
    if (!mounted) return;
    setState(() { _sending = false; _sent = ok; });
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification email sent! Check your inbox.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.mark_email_unread_outlined, color: AppTheme.warning, size: 30),
          ),
          const SizedBox(height: 16),
          Text('Email Not Verified', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Your account is not yet verified. Please check your inbox for a verification email sent to:',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.email,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryText),
            ),
          ),
          const SizedBox(height: 16),
          if (_sent)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppTheme.success, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Verification email sent!', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.success, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: GoogleFonts.poppins(color: AppTheme.secondaryText)),
        ),
        ElevatedButton.icon(
          onPressed: _sending ? null : _resend,
          icon: _sending
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.send_outlined, size: 16),
          label: Text(_sent ? 'Resend Again' : 'Resend Email', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
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

// ── Wrong App Dialog (Partner trying to login on Customer app) ────────────────

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
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.poppins(color: AppTheme.secondaryText)),
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

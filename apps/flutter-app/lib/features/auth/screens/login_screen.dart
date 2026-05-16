import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/service_centre_provider.dart';
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
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  color: Color(0xFFFF5963), size: 28),
            ),
            const SizedBox(height: 16),
            Text('Login Failed',
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'The email or password you entered is incorrect. Please try again or reset your password.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF7A7A7A), height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Try Again',
                style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A))),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.push('/auth/forgot-password');
            },
            icon: const Icon(Icons.key_outlined, size: 16),
            label: Text('Forgot Password',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B1F26),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePostLogin() async {
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
        await _showPickerSheet();
        if (mounted) context.go('/home');
    }
  }

  Future<void> _showPickerSheet() async {
    final scProvider = context.read<ServiceCentreProvider>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CentrePickerSheet(provider: scProvider),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();

    if (_isEmailMode) {
      final ok = await auth.loginWithEmail(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (!mounted) return;
      if (ok) {
        await _handlePostLogin();
      } else {
        if (!mounted) return;
        if (auth.emailNotVerified) {
          _showEmailNotVerifiedDialog(auth.unverifiedEmail ?? _emailCtrl.text.trim());
        } else {
          _showLoginErrorDialog();
        }
      }
    } else {
      // Phone → send OTP then navigate to OTP screen
      final phone = '+91${_phoneCtrl.text.trim()}';
      final ok = await auth.sendOtp(phone);
      if (mounted) {
        if (ok) {
          context.push('/auth/otp?phone=${Uri.encodeComponent(phone)}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(auth.error ?? 'Failed to send OTP')));
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Text('Welcome',
                      style: GoogleFonts.interTight(
                          fontSize: 28, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Please enter your details to login',
                      style: GoogleFonts.interTight(
                          fontSize: 14, color: const Color(0xFF57636C))),
                  const SizedBox(height: 24),

                  // Email / Phone toggle
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _toggleTab('Email', _isEmailMode,
                            () => setState(() => _isEmailMode = true)),
                        _toggleTab('Phone', !_isEmailMode,
                            () => setState(() => _isEmailMode = false)),
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
                      validator: (v) =>
                          v!.isEmpty ? 'Email is required' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordCtrl,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: !_passwordVisible,
                      validator: (v) =>
                          v!.isEmpty ? 'Password is required' : null,
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _passwordVisible = !_passwordVisible),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/auth/forgot-password'),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                  ] else ...[
                    AppTextField(
                      controller: _phoneCtrl,
                      label: 'Mobile Number',
                      hint: '9876543210',
                      keyboardType: TextInputType.phone,
                      prefixText: '+91 ',
                      validator: (v) =>
                          v!.length < 10 ? 'Enter valid mobile number' : null,
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
                      Text("Don't have an account?",
                          style: GoogleFonts.interTight(
                              color: const Color(0xFF57636C))),
                      TextButton(
                        onPressed: () => context.push('/auth/register'),
                        child: Text('Sign Up',
                            style: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600)),
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
            color: active ? const Color(0xFF040404) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.interTight(
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : const Color(0xFF57636C),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Centre picker sheet (shown when user has 2+ centres) ─────────────────────

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
          // Handle
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
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
          // Centre list
          ...centres.map((c) {
            final isSelected = _selected?.id == c.id;
            return ListTile(
              onTap: () => setState(() => _selected = c),
              selected: isSelected,
              selectedTileColor: const Color(0xFFEAF2FF),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1B1F26)
                      : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.store_outlined,
                    size: 20,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF5A5A5A)),
              ),
              title: Text(c.name,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500)),
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
                child: Text('Continue with ${_selected?.name ?? 'selected centre'}',
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

// ── Email Not Verified Dialog ─────────────────────────────────────────────────

class _EmailNotVerifiedDialog extends StatefulWidget {
  final String email;
  const _EmailNotVerifiedDialog({required this.email});

  @override
  State<_EmailNotVerifiedDialog> createState() =>
      _EmailNotVerifiedDialogState();
}

class _EmailNotVerifiedDialogState extends State<_EmailNotVerifiedDialog> {
  bool _sending = false;
  bool _sent = false;

  Future<void> _resend() async {
    setState(() => _sending = true);
    final ok =
        await context.read<AuthProvider>().resendVerificationEmail(widget.email);
    if (!mounted) return;
    setState(() {
      _sending = false;
      _sent = ok;
    });
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Verification email sent! Check your inbox.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to send. Please try again.')));
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
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.mark_email_unread_outlined,
                color: Color(0xFFB8860B), size: 30),
          ),
          const SizedBox(height: 16),
          Text('Email Not Verified',
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Your account is not yet verified. Please check your inbox for a verification email sent to:',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF7A7A7A)),
          ),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.email,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B1F26)),
            ),
          ),
          const SizedBox(height: 16),
          if (_sent)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Color(0xFF2F9E56), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Verification email sent!',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF2F9E56),
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close',
              style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A))),
        ),
        ElevatedButton.icon(
          onPressed: _sending ? null : _resend,
          icon: _sending
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.send_outlined, size: 16),
          label: Text(_sent ? 'Resend Again' : 'Resend Email',
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B1F26),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

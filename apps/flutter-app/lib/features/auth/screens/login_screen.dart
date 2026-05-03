import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();

    if (_isEmailMode) {
      final ok = await auth.loginWithEmail(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (!ok && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(auth.error ?? 'Login failed')));
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

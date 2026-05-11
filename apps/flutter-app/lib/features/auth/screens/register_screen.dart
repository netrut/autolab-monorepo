import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/service_centre_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    if (!mounted) return;
    if (ok) {
      // New user: init provider (no centres yet) then go to onboard
      await context.read<ServiceCentreProvider>().init();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account created! Set up your service centre.')));
      context.go('/service-centers/onboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.error ?? 'Registration failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Sign Up',
                      style: GoogleFonts.interTight(
                          fontSize: 28, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Create your AutoLab account',
                      style: GoogleFonts.interTight(
                          color: const Color(0xFF57636C))),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _nameCtrl,
                    label: 'Full Name',
                    hint: 'Enter your name',
                    validator: (v) => v!.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email Address',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Email is required' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _phoneCtrl,
                    label: 'Phone Number',
                    hint: '9876543210',
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v!.length < 10 ? 'Enter valid phone number' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordCtrl,
                    label: 'Password',
                    hint: 'Min 8 characters',
                    obscureText: !_passwordVisible,
                    validator: (v) =>
                        v!.length < 8 ? 'Password must be 8+ characters' : null,
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Create Account',
                    isLoading: auth.isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: GoogleFonts.interTight(
                              color: const Color(0xFF57636C))),
                      TextButton(
                        onPressed: () => context.go('/auth/login'),
                        child: const Text('Login'),
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
}

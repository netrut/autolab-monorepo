import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_client.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  bool _saving = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _phoneCtrl = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    try {
      final api = ApiClient();
      await api.put('/api/users/profile', data: {
        'display_name': _nameCtrl.text.trim(),
        'phone_number': _phoneCtrl.text.trim(),
      });
      await context.read<AuthProvider>().init();
      if (mounted) setState(() => _editing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showChangePasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (_) => _DeleteAccountDialog(
        onDeleted: () async {
          await context.read<AuthProvider>().logout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final hasPassword = user?.email != null && user!.email.isNotEmpty && !user.email.endsWith('@autolab.com');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Profile',
              onPressed: () => setState(() => _editing = true),
            )
          else
            TextButton(
              onPressed: _saving ? null : _saveProfile,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Save',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F4FD8))),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                child: Column(
                  children: [
                    // ── Profile header card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 8,
                              color: Color(0x08000000),
                              offset: Offset(0, 2))
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.person_outline,
                                color: Colors.white, size: 38),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Welcome Back',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color(0xFF6B7280))),
                                const SizedBox(height: 4),
                                Text(user?.displayName ?? 'User',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF111827))),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFE5E7EB)),
                                  ),
                                  child: Text(
                                    user?.roleLabel ?? 'User',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF374151)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Contact Information
                    _sectionLabel('Contact Information'),
                    const SizedBox(height: 12),

                    if (_editing) ...[
                      _editField(
                        icon: Icons.person_outline,
                        label: 'Display Name',
                        controller: _nameCtrl,
                      ),
                      const SizedBox(height: 10),
                      _editField(
                        icon: Icons.phone_outlined,
                        label: 'Mobile Number',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      _infoCard(Icons.email_outlined, 'Email Address',
                          user?.email ?? 'Not set',
                          readOnly: true),
                    ] else ...[
                      _infoCard(Icons.phone_outlined, 'Mobile Number',
                          user?.phoneNumber ?? 'Not set'),
                      const SizedBox(height: 10),
                      _infoCard(Icons.email_outlined, 'Email Address',
                          user?.email ?? 'Not set'),
                    ],
                    const SizedBox(height: 24),

                    // ── Account
                    _sectionLabel('Account'),
                    const SizedBox(height: 12),
                    _infoCard(
                      Icons.verified_user_outlined,
                      'Role',
                      user?.roleLabel ?? 'User',
                      subtitle: user?.roleDescription,
                    ),
                    const SizedBox(height: 24),

                    // ── Security
                    if (hasPassword) ...[
                      _sectionLabel('Security'),
                      const SizedBox(height: 12),
                      _actionTile(
                        icon: Icons.lock_outline,
                        label: 'Change Password',
                        onTap: _showChangePasswordSheet,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // ── Danger Zone
                    _sectionLabel('Danger Zone'),
                    const SizedBox(height: 12),
                    _actionTile(
                      icon: Icons.delete_outline,
                      label: 'Delete Account',
                      color: const Color(0xFFFF5963),
                      onTap: _showDeleteAccountDialog,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom buttons
            if (!_editing)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: ElevatedButton(
                  onPressed: () async => auth.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F1F1F),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Logout',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            if (_editing)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: OutlinedButton(
                  onPressed: () {
                    final user = context.read<AuthProvider>().user;
                    _nameCtrl.text = user?.displayName ?? '';
                    _phoneCtrl.text = user?.phoneNumber ?? '';
                    setState(() => _editing = false);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600)),
      );

  Widget _infoCard(IconData icon, String label, String value,
      {String? subtitle, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? const Color(0xFFF8F8F8) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1F1F1F), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7A7A7A))),
                const SizedBox(height: 4),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: const Color(0xFF9E9E9E))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _editField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1F1F1F), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 12, color: const Color(0xFF7A7A7A)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final c = color ?? const Color(0xFF1F1F1F);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color?.withOpacity(0.3) ?? const Color(0xFFE8E8E8)),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: c.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: c, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600, color: c)),
            ),
            Icon(Icons.chevron_right, color: c.withOpacity(0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Change Password Bottom Sheet ─────────────────────────────────────────────

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final current = _currentCtrl.text.trim();
    final newPass = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (current.isEmpty || newPass.isEmpty) {
      setState(() => _error = 'All fields are required');
      return;
    }
    if (newPass.length < 6) {
      setState(() => _error = 'New password must be at least 6 characters');
      return;
    }
    if (newPass != confirm) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      final api = ApiClient();
      await api.put('/api/auth/change-password', data: {
        'current_password': current,
        'new_password': newPass,
      });
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
    } catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _parseError(dynamic e) {
    try {
      if (e is Exception && e.toString().contains('DioException')) {
        final msg = (e as dynamic).response?.data?['error'];
        if (msg != null) return msg.toString();
      }
    } catch (_) {}
    return 'Failed to change password';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Change Password',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _passwordField(_currentCtrl, 'Current Password', _obscureCurrent,
              () => setState(() => _obscureCurrent = !_obscureCurrent)),
          const SizedBox(height: 12),
          _passwordField(_newCtrl, 'New Password', _obscureNew,
              () => setState(() => _obscureNew = !_obscureNew)),
          const SizedBox(height: 12),
          _passwordField(_confirmCtrl, 'Confirm New Password', _obscureNew, null),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFFF5963))),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B1F26),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _loading
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Update Password',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(TextEditingController ctrl, String hint, bool obscure, VoidCallback? toggle) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF9E9E9E)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                onPressed: toggle)
            : null,
      ),
    );
  }
}

// ── Delete Account Dialog ────────────────────────────────────────────────────

class _DeleteAccountDialog extends StatefulWidget {
  final VoidCallback onDeleted;
  const _DeleteAccountDialog({required this.onDeleted});

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (_passCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Enter your password to confirm');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final api = ApiClient();
      await api.delete('/api/auth/account', data: {
        'password': _passCtrl.text.trim(),
      });
      if (!mounted) return;
      Navigator.pop(context);
      widget.onDeleted();
    } catch (e) {
      String msg = 'Failed to delete account';
      try {
        final resp = (e as dynamic).response?.data?['error'];
        if (resp != null) msg = resp.toString();
      } catch (_) {}
      setState(() => _error = msg);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5963), size: 24),
          const SizedBox(width: 8),
          Text('Delete Account', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This will permanently delete your account and all associated data. This action cannot be undone.',
            style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF5A5A5A)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passCtrl,
            obscureText: true,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter password to confirm',
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF9E9E9E)),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFFF5963))),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A))),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _delete,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5963),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _loading
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text('Delete', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

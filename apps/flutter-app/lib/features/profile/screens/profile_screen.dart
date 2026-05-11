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

  // 8.7 — save profile edits
  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    try {
      final api = ApiClient();
      await api.put('/api/users/profile', data: {
        'display_name': _nameCtrl.text.trim(),
        'phone_number': _phoneCtrl.text.trim(),
      });
      // Refresh user in AuthProvider
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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

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
                          color: const Color(0xFF2F7DE1))),
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
                    // ── Profile header card ──────────────────────────────
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2F7DE1), Color(0xFF1F4FA8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 15,
                              color: Color(0x1F2F7DE1),
                              offset: Offset(0, 6))
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 2),
                            ),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Welcome Back!',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color:
                                            Colors.white.withOpacity(0.8))),
                                const SizedBox(height: 4),
                                Text(user?.displayName ?? 'User',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                                const SizedBox(height: 4),
                                // 8.8 — role badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user?.roleLabel ?? 'User',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Contact Information ──────────────────────────────
                    _sectionLabel('Contact Information'),
                    const SizedBox(height: 12),

                    if (_editing) ...[
                      // 8.7 — editable fields
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

                    // ── Account ──────────────────────────────────────────
                    _sectionLabel('Account'),
                    const SizedBox(height: 12),
                    // 8.8 — full role info card
                    _infoCard(
                      Icons.verified_user_outlined,
                      'Role',
                      user?.roleLabel ?? 'User',
                      subtitle: user?.roleDescription,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Logout button ────────────────────────────────────────────
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
        border: Border.all(color: const Color(0xFF2F7DE1).withOpacity(0.4)),
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
}

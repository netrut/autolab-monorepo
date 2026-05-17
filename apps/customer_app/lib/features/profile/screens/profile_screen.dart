import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  bool _saving = false;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameCtrl.text = user.displayName ?? '';
      _phoneCtrl.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ApiClient().put('/api/users/me', data: {
        'display_name': _nameCtrl.text.trim(),
        if (_addressCtrl.text.isNotEmpty) 'address': _addressCtrl.text.trim(),
      });
      await context.read<AuthProvider>().init();
      setState(() => _editing = false);
    } catch (_) {}
    setState(() => _saving = false);
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPwCtrl = TextEditingController();
    final newPwCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPwCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
            const SizedBox(height: 12),
            TextField(controller: newPwCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                await ApiClient().put('/api/auth/change-password', data: {
                  'old_password': oldPwCtrl.text,
                  'new_password': newPwCtrl.text,
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed!')));
                }
              } catch (_) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to change password')));
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This will permanently delete your account and all data. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                await ApiClient().delete('/api/auth/account');
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  Navigator.pop(context);
                  context.go('/auth/login');
                }
              } catch (_) {}
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_editing)
            IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => setState(() => _editing = true)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryLight,
              child: Text(
                (user?.displayName ?? 'U')[0].toUpperCase(),
                style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
              ),
            ),
            const SizedBox(height: 12),
            if (!_editing) ...[
              Text(user?.displayName ?? 'User', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              Text(user?.email ?? '', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
              if (user?.phoneNumber != null) Text(user!.phoneNumber!, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
            ] else ...[
              const SizedBox(height: 16),
              AppTextField(label: 'Name', controller: _nameCtrl),
              const SizedBox(height: 14),
              AppTextField(label: 'Phone', controller: _phoneCtrl, readOnly: true),
              const SizedBox(height: 14),
              AppTextField(label: 'Address', controller: _addressCtrl, maxLines: 2),
              const SizedBox(height: 20),
              AppButton(label: 'Save', isLoading: _saving, onPressed: _save),
              const SizedBox(height: 8),
              AppButton(label: 'Cancel', isOutlined: true, onPressed: () => setState(() => _editing = false)),
            ],
            const SizedBox(height: 32),
            // Change Password
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline, size: 20),
                    title: Text('Change Password', style: GoogleFonts.poppins(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, size: 20, color: AppTheme.error),
                    title: Text('Delete Account', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.error)),
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

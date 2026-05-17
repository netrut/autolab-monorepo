import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/api/api_client.dart';
import '../providers/settings_provider.dart';
import '../../../shared/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<SettingsProvider>().fetch());
  }

  void _confirmDelete(BuildContext context, AuthProvider auth) {
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
                await auth.logout();
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
    final settings = context.watch<SettingsProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Settings')),
      body: settings.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionHeader('Notifications'),
                _ToggleTile('Service Reminders', 'Get notified before service is due', settings.serviceReminder, (v) => settings.update({'notify_service_reminder': v})),
                _ToggleTile('Booking Updates', 'Status changes for your bookings', settings.bookingUpdates, (v) => settings.update({'notify_booking_updates': v})),
                _ToggleTile('Parts Expiry', 'Alerts when parts warranty expires', settings.partsExpiry, (v) => settings.update({'notify_parts_expiry': v})),
                _ToggleTile('Join Requests', 'Vehicle access requests', settings.joinRequests, (v) => settings.update({'notify_join_requests': v})),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Remind days before', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                      DropdownButton<int>(
                        value: settings.reminderDays,
                        underline: const SizedBox(),
                        items: [3, 5, 7, 14].map((d) => DropdownMenuItem(value: d, child: Text('$d days'))).toList(),
                        onChanged: (v) { if (v != null) settings.update({'reminder_days_before': v}); },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SectionHeader('Account'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline, size: 20),
                        title: Text('Profile', style: GoogleFonts.poppins(fontSize: 14)),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        onTap: () => context.push('/profile'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout, size: 20, color: AppTheme.error),
                        title: Text('Logout', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.error)),
                        onTap: () async {
                          await auth.logout();
                          if (context.mounted) context.go('/auth/login');
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.delete_forever_outlined, size: 20, color: AppTheme.error),
                        title: Text('Delete Account', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.error)),
                        onTap: () => _confirmDelete(context, auth),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.secondaryText, letterSpacing: 1.0)),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile(this.title, this.subtitle, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppTheme.primaryBlue),
        ],
      ),
    );
  }
}

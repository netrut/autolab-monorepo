import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/api/api_client.dart';
import '../providers/settings_provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

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

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.poppins(color: AppTheme.secondaryText))),
          ElevatedButton(
            onPressed: () async { Navigator.pop(context); await context.read<AuthProvider>().logout(); },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Logout', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 24),
          const SizedBox(width: 8),
          Text('Delete Account', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        content: Text('This will permanently delete your account and all data. This cannot be undone.', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.poppins(color: AppTheme.secondaryText))),
          ElevatedButton(
            onPressed: () async {
              try {
                await ApiClient().delete('/api/auth/account');
                await context.read<AuthProvider>().logout();
                if (mounted) { Navigator.pop(context); context.go('/auth/login'); }
              } catch (_) {}
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Delete', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('SETTINGS')),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      body: settings.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Card
                  InkWell(
                    onTap: () => context.push('/profile'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(14)),
                            child: Center(child: Text((user?.displayName ?? 'U')[0].toUpperCase(), style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?.displayName ?? 'User', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.primaryText), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(user?.email ?? '', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.border)),
                                  child: Text('Customer', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryText)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.border)),
                            child: const Icon(Icons.chevron_right, color: AppTheme.secondaryText, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notifications
                  _sectionLabel('NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  _Card(children: [
                    _ToggleRow(icon: Icons.build_outlined, label: 'Service Reminders', subtitle: 'Upcoming service alerts', value: settings.serviceReminder, onChanged: (v) => settings.update({'notify_service_reminder': v})),
                    _divider(),
                    _ToggleRow(icon: Icons.calendar_today_outlined, label: 'Booking Updates', subtitle: 'Status changes & confirmations', value: settings.bookingUpdates, onChanged: (v) => settings.update({'notify_booking_updates': v})),
                    _divider(),
                    _ToggleRow(icon: Icons.warning_amber_outlined, iconColor: AppTheme.warning, label: 'Parts Expiry Alerts', subtitle: 'Before warranty expires', value: settings.partsExpiry, onChanged: (v) => settings.update({'notify_parts_expiry': v})),
                    _divider(),
                    _ToggleRow(icon: Icons.group_add_outlined, label: 'Join Requests', subtitle: 'Vehicle access request notifications', value: settings.joinRequests, onChanged: (v) => settings.update({'notify_join_requests': v})),
                    _divider(),
                    _DropdownRow(icon: Icons.timer_outlined, label: 'Reminder Interval', subtitle: 'Days before service due', value: settings.reminderDays, options: const [3, 5, 7, 14], display: (v) => '$v days', onChanged: (v) => settings.update({'reminder_days_before': v})),
                  ]),
                  const SizedBox(height: 24),

                  // Support
                  _sectionLabel('SUPPORT'),
                  const SizedBox(height: 8),
                  _Card(children: [
                    _NavRow(icon: Icons.help_outline_rounded, label: 'Help & Support', subtitle: 'Contact us via email', onTap: () async {
                      final url = Uri.parse('mailto:support@autolab.app?subject=Help%20Request');
                      if (await canLaunchUrl(url)) await launchUrl(url);
                    }),
                    _divider(),
                    _NavRow(icon: Icons.notifications_outlined, label: 'Notifications', subtitle: 'View all notifications', onTap: () => context.push('/notifications')),
                  ]),
                  const SizedBox(height: 24),

                  // Logout
                  InkWell(
                    onTap: _logout,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.error.withOpacity(0.2))),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 20)),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Logout', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.error))),
                          const Icon(Icons.chevron_right, color: AppTheme.error, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Delete Account
                  InkWell(
                    onTap: _confirmDelete,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.delete_forever_outlined, color: AppTheme.error, size: 20)),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Delete Account', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.error))),
                          const Icon(Icons.chevron_right, color: AppTheme.error, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // App Version
                  Center(
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(20)),
                        child: Text('Version 1.0.0', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.secondaryText)),
                      ),
                      const SizedBox(height: 6),
                      Text('AutoLab © 2025', style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.secondaryText)),
                    ]),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionLabel(String text) => Text(text, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.secondaryText, letterSpacing: 1.1));
  Widget _divider() => const Divider(height: 1, indent: 62, endIndent: 0, color: Color(0xFFF0F0F0));
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 3))]),
      child: Column(children: children),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, this.iconColor, required this.label, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = iconColor ?? AppTheme.primaryText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: c)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryText)),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
          ])),
          Switch.adaptive(value: value, activeColor: AppTheme.primaryBlue, onChanged: onChanged, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ],
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final int value;
  final List<int> options;
  final String Function(int) display;
  final ValueChanged<int> onChanged;
  const _DropdownRow({required this.icon, required this.label, required this.subtitle, required this.value, required this.options, required this.display, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: AppTheme.primaryText)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryText)),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
          ])),
          DropdownButton<int>(
            value: value, underline: const SizedBox(), isDense: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.secondaryText),
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(display(o)))).toList(),
            onChanged: (v) { if (v != null) onChanged(v); },
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final VoidCallback onTap;
  const _NavRow({required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: AppTheme.primaryText)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryText)),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText)),
            ])),
            const Icon(Icons.chevron_right, size: 18, color: AppTheme.secondaryText),
          ],
        ),
      ),
    );
  }
}

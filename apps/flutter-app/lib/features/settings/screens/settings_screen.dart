import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/service_centre_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().fetch();
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5963),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Logout', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showSwitcher(ServiceCentreProvider scProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _SwitcherSheet(provider: scProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final scProvider = context.watch<ServiceCentreProvider>();
    final settings = context.watch<SettingsProvider>();
    final current = scProvider.current;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text('SETTINGS'),
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF3E3E3E)),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      body: settings.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Profile Card
                  InkWell(
                    onTap: () => context.push('/profile'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.person_outline, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? 'User',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF111827)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user?.email ?? '',
                                  style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF6B7280)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFE5E7EB)),
                                  ),
                                  child: Text(
                                    user?.roleLabel ?? 'User',
                                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF374151)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: const Icon(Icons.chevron_right, color: Color(0xFF6B7280), size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Active Service Centre Card
                  _sectionLabel('ACTIVE SERVICE CENTRE'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                      boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 3))],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1F26),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.store_outlined, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                current?.name ?? 'No Service Centre',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: current != null ? const Color(0xFF1B1F26) : const Color(0xFF9E9E9E),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (current != null)
                                Text(
                                  current.roleLabel + (current.city != null ? '  •  ${current.city}' : ''),
                                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E)),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                  // ── Switch button pill
                        GestureDetector(
                          onTap: () => _showSwitcher(scProvider),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Text('Switch', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (current?.role == 'owner') ...[
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => context.push('/service-centers/edit/${current!.id}'),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF1F4FD8)),
                            const SizedBox(width: 4),
                            Text('Edit Centre', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF1F4FD8))),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // ── Notifications
                  _sectionLabel('NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  _Card(children: [
                    _ToggleRow(
                      icon: Icons.build_outlined,
                      iconColor: const Color(0xFF111827),
                      iconBg: const Color(0xFFF3F4F6),
                      label: 'Service Reminders',
                      subtitle: 'Upcoming service alerts',
                      value: settings.notifyServiceReminder,
                      onChanged: (v) => settings.update({'notify_service_reminder': v}),
                    ),
                    _divider(),
                    _ToggleRow(
                      icon: Icons.calendar_today_outlined,
                      iconColor: const Color(0xFF111827),
                      iconBg: const Color(0xFFF3F4F6),
                      label: 'Booking Updates',
                      subtitle: 'Status changes & confirmations',
                      value: settings.notifyBookingUpdates,
                      onChanged: (v) => settings.update({'notify_booking_updates': v}),
                    ),
                    _divider(),
                    _ToggleRow(
                      icon: Icons.warning_amber_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      iconBg: const Color(0xFFFFFBEB),
                      label: 'Parts Expiry Alerts',
                      subtitle: 'Before warranty expires',
                      value: settings.notifyPartsExpiry,
                      onChanged: (v) => settings.update({'notify_parts_expiry': v}),
                    ),
                    _divider(),
                    _ToggleRow(
                      icon: Icons.group_add_outlined,
                      iconColor: const Color(0xFF111827),
                      iconBg: const Color(0xFFF3F4F6),
                      label: 'Join Requests',
                      subtitle: 'Staff join request notifications',
                      value: settings.notifyJoinRequests,
                      onChanged: (v) => settings.update({'notify_join_requests': v}),
                    ),
                    _divider(),
                    _DropdownRow<int>(
                      icon: Icons.timer_outlined,
                      iconColor: const Color(0xFF111827),
                      iconBg: const Color(0xFFF3F4F6),
                      label: 'Reminder Interval',
                      subtitle: 'Days before service due',
                      value: settings.reminderDaysBefore,
                      options: const [1, 3, 5, 7, 14],
                      display: (v) => '$v days',
                      onChanged: (v) => settings.update({'reminder_days_before': v}),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // ── Preferences
                  _sectionLabel('PREFERENCES'),
                  const SizedBox(height: 8),
                  _Card(children: [
                    _DropdownRow<String?>(
                      icon: Icons.directions_car_outlined,
                      iconColor: const Color(0xFF111827),
                      iconBg: const Color(0xFFF3F4F6),
                      label: 'Default Vehicle Type',
                      subtitle: 'Filter vehicles by type',
                      value: settings.defaultVehicleType,
                      options: const [null, 'car', 'bike'],
                      display: (v) => v == null ? 'All' : '${v[0].toUpperCase()}${v.substring(1)}',
                      onChanged: (v) => settings.update({'default_vehicle_type': v}),
                    ),
                    _divider(),
                    _ToggleRow(
                      icon: Icons.dark_mode_outlined,
                      iconColor: const Color(0xFF111827),
                      iconBg: const Color(0xFFF3F4F6),
                      label: 'Dark Mode',
                      subtitle: 'Switch app appearance',
                      value: settings.darkMode,
                      onChanged: (v) => settings.update({'dark_mode': v}),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // ── Support
                  _sectionLabel('SUPPORT'),
                  const SizedBox(height: 8),
                  _Card(children: [
                    _NavRow(
                      icon: Icons.help_outline_rounded,
                      iconColor: const Color(0xFF111827),
                      iconBg: const Color(0xFFF3F4F6),
                      label: 'Help & Support',
                      subtitle: 'Contact us via email',
                      onTap: () async {
                        final url = Uri.parse('mailto:support@autolab.app?subject=Help%20Request');
                        if (await canLaunchUrl(url)) await launchUrl(url);
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // ── Logout
                  InkWell(
                    onTap: _logout,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFD6D6)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5963).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.logout_rounded, color: Color(0xFFFF5963), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text('Logout', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFFF5963))),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFFFF5963), size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── App Version
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Version 1.0.0', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E))),
                        ),
                        const SizedBox(height: 6),
                        Text('AutoLab © 2025', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFFBBBBBB))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF9E9E9E), letterSpacing: 1.1),
      );

  Widget _divider() => const Divider(height: 1, indent: 62, endIndent: 0, color: Color(0xFFF0F0F0));
}

// ── Reusable Card container ───────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(children: children),
    );
  }
}

// ── Toggle Row ────────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.label, required this.subtitle,
    required this.value, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1B1F26))),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E))),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: const Color(0xFF1F4FD8),
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

// ── Dropdown Row ──────────────────────────────────────────────────────────────

class _DropdownRow<T> extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, subtitle;
  final T value;
  final List<T> options;
  final String Function(T) display;
  final ValueChanged<T> onChanged;

  const _DropdownRow({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.label, required this.subtitle,
    required this.value, required this.options,
    required this.display, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1B1F26))),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E))),
              ],
            ),
          ),
          DropdownButton<T>(
            value: value,
            underline: const SizedBox(),
            isDense: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF9E9E9E)),
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1F4FD8)),
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(display(o)))).toList(),
            onChanged: (v) { if (v != null || null is T) onChanged(v as T); },
          ),
        ],
      ),
    );
  }
}

// ── Nav Row ───────────────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, subtitle;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.label, required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1B1F26))),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Color(0xFFBDBDBD)),
          ],
        ),
      ),
    );
  }
}

// ── Service Centre Switcher Sheet ─────────────────────────────────────────────

class _SwitcherSheet extends StatelessWidget {
  final ServiceCentreProvider provider;
  const _SwitcherSheet({required this.provider});

  @override
  Widget build(BuildContext context) {
    final centres = provider.centres;
    final currentId = provider.current?.id;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Switch Service Centre', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
              Text('Select the centre you want to work in', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF9E9E9E))),
            ]),
          ),
          const Divider(height: 16),
          ...centres.map((c) {
            final isActive = c.id == currentId;
            return ListTile(
              onTap: () async {
                await provider.switchTo(c);
                if (context.mounted) Navigator.pop(context);
              },
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF1B1F26) : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.store_outlined, size: 20, color: isActive ? Colors.white : const Color(0xFF5A5A5A)),
              ),
              title: Text(c.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
              subtitle: Text(
                c.roleLabel + (c.city != null ? '  •  ${c.city}' : ''),
                style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E)),
              ),
              trailing: isActive
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFE8F7EE), borderRadius: BorderRadius.circular(20)),
                      child: Text('Active', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF2F9E56))),
                    )
                  : const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD), size: 20),
            );
          }),
          const Divider(height: 8),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              context.push('/service-centers/onboard');
            },
            leading: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add_rounded, size: 22, color: Color(0xFF1F4FD8)),
            ),
            title: Text('Add or Join a Centre', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1F4FD8))),
            subtitle: Text('Register new or join existing', style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E))),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

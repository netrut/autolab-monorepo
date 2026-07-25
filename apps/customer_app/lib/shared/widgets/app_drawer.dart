import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Drawer(
      backgroundColor: AppTheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      (user?.displayName ?? 'U')[0].toUpperCase(),
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Customer',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryText),
                  ),
                  Text(
                    user?.email ?? '',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText),
                  ),
                ],
              ),
            ),
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(icon: Icons.home_outlined, label: 'Home', onTap: () => _navigate(context, '/home')),
                  _DrawerItem(icon: Icons.directions_car_outlined, label: 'My Vehicles', onTap: () => _navigate(context, '/vehicles')),
                  _DrawerItem(icon: Icons.calendar_today_outlined, label: 'Bookings', onTap: () => _navigate(context, '/bookings')),
                  _DrawerItem(icon: Icons.history_outlined, label: 'Service History', onTap: () => _navigate(context, '/service-history')),
                  _DrawerItem(icon: Icons.receipt_long_outlined, label: 'Invoices', onTap: () => _navigate(context, '/invoices')),
                  _DrawerItem(icon: Icons.search_outlined, label: 'Find Service Centre', onTap: () => _navigate(context, '/search')),
                  const Divider(height: 24, indent: 20, endIndent: 20),
                  _DrawerItem(icon: Icons.people_outline, label: 'Requests', onTap: () => _navigate(context, '/requests')),
                  _DrawerItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => _navigate(context, '/notifications')),
                  _DrawerItem(icon: Icons.person_outline, label: 'Profile', onTap: () => _navigate(context, '/profile')),
                  _DrawerItem(icon: Icons.settings_outlined, label: 'Settings', onTap: () => _navigate(context, '/settings')),
                ],
              ),
            ),
            // Logout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: _DrawerItem(
                icon: Icons.logout_outlined,
                label: 'Logout',
                color: AppTheme.error,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text('Logout', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                      content: Text('Are you sure you want to logout?', style: GoogleFonts.poppins(fontSize: 13)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: GoogleFonts.poppins(color: AppTheme.secondaryText)),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context); // close dialog
                            Navigator.pop(context); // close drawer
                            await auth.logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Logout', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primaryText;
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 22, color: c),
      title: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: c)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

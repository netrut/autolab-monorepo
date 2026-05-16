import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_drawer.dart';

class ServiceCentreGatewayScreen extends StatelessWidget {
  const ServiceCentreGatewayScreen({super.key});

  void _openJoinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const JoinServiceCentreSheetBase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final name = user?.displayName?.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF1B1F26)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Service Centre',
          style: GoogleFonts.interTight(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF232323),
              letterSpacing: 0.5),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_outlined, color: Color(0xFF1B1F26), size: 22),
            tooltip: 'Requests',
            onPressed: () => context.push('/requests'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF1B1F26), size: 22),
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Hero banner ────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1F26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Partner with AutoLab',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 14),
                    Text('Hello, $name 👋',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(
                      'Grow your service\nbusiness with us',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.25),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Register your own service centre or join an existing one '
                      'as a mechanic, partner, or staff member.',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white60,
                          height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _statChip(Icons.add_business_outlined, 'Register', 'New Centre'),
                        const SizedBox(width: 10),
                        _statChip(Icons.group_add_outlined, 'Join', 'Existing'),
                        const SizedBox(width: 10),
                        _statChip(Icons.verified_outlined, 'Get', 'Verified'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              Text(
                'CHOOSE AN OPTION',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF9E9E9E),
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 14),

              // ── Option 1 — Register ────────────────────────────────────────
              _OptionCard(
                icon: Icons.add_business_outlined,
                iconBg: const Color(0xFFEAF2FF),
                iconColor: const Color(0xFF2F7DE1),
                badge: 'REGISTER',
                badgeBg: const Color(0xFFEAF2FF),
                badgeColor: const Color(0xFF2F7DE1),
                title: 'Register New Service Centre',
                subtitle:
                    'Set up your own service centre profile, add your team, '
                    'manage bookings and service records.',
                features: const [
                  'Full control of your service centre',
                  'Manage staff & mechanics',
                  'Accept bookings & generate invoices',
                  'Get verified badge',
                ],
                ctaLabel: 'Register My Centre',
                ctaIcon: Icons.arrow_forward_rounded,
                onTap: () => context.push('/service-centers/add'),
              ),

              const SizedBox(height: 16),

              // ── Option 2 — Join ────────────────────────────────────────────
              _OptionCard(
                icon: Icons.group_add_outlined,
                iconBg: const Color(0xFFE8F7EE),
                iconColor: const Color(0xFF2F9E56),
                badge: 'JOIN',
                badgeBg: const Color(0xFFE8F7EE),
                badgeColor: const Color(0xFF2F9E56),
                title: 'Join an Existing Centre',
                subtitle:
                    'Send a request to join a service centre as a mechanic, '
                    'partner, or staff. The owner will approve your request.',
                features: const [
                  'Work under an existing centre',
                  'Access service records & tools',
                  'Receive job assignments',
                  'No setup required',
                ],
                ctaLabel: 'Find & Join a Centre',
                ctaIcon: Icons.search_rounded,
                onTap: () => _openJoinSheet(context),
              ),

              const SizedBox(height: 28),

              // ── Help note ──────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.help_outline_rounded,
                          color: Color(0xFFB8860B), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Not sure which to choose?',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1B1F26))),
                          const SizedBox(height: 4),
                          Text(
                            'If you own or manage a garage, choose Register. '
                            "If you work at someone else's garage, choose Join.",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF7A7A7A),
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String top, String bottom) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(height: 4),
            Text(top,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Text(bottom,
                style: GoogleFonts.poppins(
                    fontSize: 10, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

// ── Option card ───────────────────────────────────────────────────────────────

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String badge, title, subtitle, ctaLabel;
  final Color badgeBg, badgeColor;
  final IconData ctaIcon;
  final List<String> features;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.badge,
    required this.badgeBg,
    required this.badgeColor,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.ctaLabel,
    required this.ctaIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 16,
              offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(badge,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                              letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 4),
                    Text(title,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1F26))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(subtitle,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF7A7A7A),
                  height: 1.5)),
          const SizedBox(height: 14),

          // Features
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          color: iconBg, shape: BoxShape.circle),
                      child: Icon(Icons.check, color: iconColor, size: 11),
                    ),
                    const SizedBox(width: 8),
                    Text(f,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF3A3A3A),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(ctaIcon, size: 18),
              label: Text(ctaLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B1F26),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

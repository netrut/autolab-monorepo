import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/service_centre_provider.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/empty_state.dart';

class ServiceCentersScreen extends StatefulWidget {
  const ServiceCentersScreen({super.key});

  @override
  State<ServiceCentersScreen> createState() => _ServiceCentersScreenState();
}

class _ServiceCentersScreenState extends State<ServiceCentersScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCentreProvider>().init();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scProvider = context.watch<ServiceCentreProvider>();
    final activeId = scProvider.current?.id;
    final centres = scProvider.centres;

    // Filter by search
    final q = _searchCtrl.text.toLowerCase().trim();
    final filtered = q.isEmpty
        ? centres
        : centres
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                (c.city?.toLowerCase().contains(q) ?? false))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF1B1F26)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text('My Service Centres',
            style: GoogleFonts.interTight(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF232323),
                letterSpacing: 0.5)),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1B1F26),
        onPressed: () => context.push('/service-centers/onboard'),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Centre',
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDCDCDC)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search_rounded,
                        color: Color(0xFF8B8B8B), size: 20),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search by name or city',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF9E9E9E)),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      size: 18,
                                      color: Color(0xFF7A7A7A)),
                                  onPressed: () => _searchCtrl.clear())
                              : null,
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: const Color(0xFF2B2B2B)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Summary row ────────────────────────────────────────────────
            if (centres.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Text(
                      '${centres.length} centre${centres.length == 1 ? '' : 's'}',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7A7A7A)),
                    ),
                    const SizedBox(width: 8),
                    if (activeId != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F7EE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.radio_button_checked,
                                size: 10, color: Color(0xFF2F9E56)),
                            const SizedBox(width: 4),
                            Text('Active: ${scProvider.current?.name ?? ''}',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2F9E56))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            // ── List ───────────────────────────────────────────────────────
            Expanded(
              child: scProvider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.store_outlined,
                          message: centres.isEmpty
                              ? 'No service centres yet'
                              : 'No results for "$q"',
                          subMessage: centres.isEmpty
                              ? 'Register a new centre or join an existing one'
                              : null,
                          actionLabel:
                              centres.isEmpty ? 'Get Started' : null,
                          onAction: centres.isEmpty
                              ? () => context
                                  .push('/service-centers/onboard')
                              : null,
                        )
                      : RefreshIndicator(
                          onRefresh: () =>
                              context.read<ServiceCentreProvider>().init(),
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                                16, 4, 16, 100),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (_, i) {
                              final c = filtered[i];
                              return _ServiceCentreCard(
                                centre: c,
                                isActive: c.id == activeId,
                                onSetActive: () => context
                                    .read<ServiceCentreProvider>()
                                    .switchTo(c),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Service Centre Card ───────────────────────────────────────────────────────

class _ServiceCentreCard extends StatelessWidget {
  final UserServiceCentre centre;
  final bool isActive;
  final VoidCallback onSetActive;

  const _ServiceCentreCard({
    required this.centre,
    required this.isActive,
    required this.onSetActive,
  });

  // ── Share ─────────────────────────────────────────────────────────────────

  void _share(BuildContext context) {
    final msg = Uri.encodeComponent(
      '🔧 *${centre.name}*\n'
      '${centre.city != null ? '📍 ${centre.city}\n' : ''}'
      '🏷️ ${centre.categoryLabel}\n'
      '${centre.isVerified ? '✅ Verified Service Centre\n' : ''}'
      '\nFind us on AutoLab app!',
    );
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _ShareSheet(centre: centre, encodedMsg: msg),
    );
  }

  // ── Invite ────────────────────────────────────────────────────────────────

  void _invite(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const JoinServiceCentreSheetBase(),
    );
  }

  // ── Remove ────────────────────────────────────────────────────────────────

  void _confirmRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove Centre?',
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          'You will lose access to "${centre.name}". '
          'This does not delete the service centre.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Removed from your centres')));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5963), elevation: 0),
            child: Text('Remove',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String get _categoryLabel {
    switch (centre.category) {
      case 'decor_accessories': return 'Decor & Accessories';
      case 'seller':            return 'Seller';
      default:                  return 'Service Centre';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive
              ? const Color(0xFF2F7DE1)
              : const Color(0xFFEAEAEA),
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? const Color(0xFF2F7DE1).withOpacity(0.08)
                : const Color(0x0A000000),
            blurRadius: isActive ? 20 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF1B1F26)
                        : const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    size: 22,
                    color: isActive
                        ? Colors.white
                        : const Color(0xFF5A5A5A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              centre.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1B1F26)),
                            ),
                          ),
                          // Active badge
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F7EE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.radio_button_checked,
                                      size: 10,
                                      color: Color(0xFF2F9E56)),
                                  const SizedBox(width: 3),
                                  Text('Active',
                                      style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF2F9E56))),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Role + category chips
                      Wrap(
                        spacing: 6,
                        children: [
                          _chip(centre.roleLabel,
                              const Color(0xFFEAF2FF),
                              const Color(0xFF2F7DE1)),
                          _chip(_categoryLabel,
                              const Color(0xFFF2F2F2),
                              const Color(0xFF5A5A5A)),
                          if (centre.isVerified)
                            _chip('Verified',
                                const Color(0xFFE8F7EE),
                                const Color(0xFF2F9E56)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Location ──────────────────────────────────────────────────────
          if (centre.city != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: Color(0xFF9E9E9E)),
                  const SizedBox(width: 4),
                  Text(centre.city!,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF7A7A7A))),
                ],
              ),
            ),

          const SizedBox(height: 14),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Action buttons ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                // Set Active (only when not active)
                if (!isActive)
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.radio_button_unchecked,
                      label: 'Set Active',
                      color: const Color(0xFF2F7DE1),
                      bg: const Color(0xFFEAF2FF),
                      onTap: onSetActive,
                    ),
                  ),
                if (!isActive) const SizedBox(width: 8),

                // Share
                Expanded(
                  child: _actionBtn(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    color: const Color(0xFF5A5A5A),
                    bg: const Color(0xFFF2F2F2),
                    onTap: () => _share(context),
                  ),
                ),
                const SizedBox(width: 8),

                // Team (for owners)
                if (centre.role == 'owner') ...[
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.group_outlined,
                      label: 'Team',
                      color: const Color(0xFF2F9E56),
                      bg: const Color(0xFFE8F7EE),
                      onTap: () => context
                          .push('/service-centers/${centre.id}/team?name=${Uri.encodeComponent(centre.name)}&owner=true'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Edit (only for owners)
                if (centre.role == 'owner') ...[
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: const Color(0xFFDA8A1D),
                      bg: const Color(0xFFFFF0DE),
                      onTap: () => context
                          .push('/service-centers/edit/${centre.id}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // More (Invite + Remove)
                _moreBtn(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color bg, Color color) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(6)),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color)),
      );

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 3),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _moreBtn(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (v) {
        if (v == 'invite') _invite(context);
        if (v == 'remove') _confirmRemove(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'invite',
          child: Row(
            children: [
              const Icon(Icons.group_add_outlined,
                  size: 18, color: Color(0xFF2F9E56)),
              const SizedBox(width: 10),
              Text('Invite Member',
                  style: GoogleFonts.poppins(fontSize: 13)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'remove',
          child: Row(
            children: [
              const Icon(Icons.exit_to_app_outlined,
                  size: 18, color: Color(0xFFFF5963)),
              const SizedBox(width: 10),
              Text('Remove / Leave',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: const Color(0xFFFF5963))),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.more_horiz,
            size: 20, color: Color(0xFF5A5A5A)),
      ),
    );
  }
}

// ── Share bottom sheet ────────────────────────────────────────────────────────

class _ShareSheet extends StatelessWidget {
  final UserServiceCentre centre;
  final String encodedMsg;

  const _ShareSheet({required this.centre, required this.encodedMsg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20),
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
          Text('Share Service Centre',
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Share ${centre.name} details via',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF7A7A7A))),
          const SizedBox(height: 20),
          Row(
            children: [
              _shareOption(
                context,
                icon: Icons.chat_outlined,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () async {
                  Navigator.pop(context);
                  final url = Uri.parse(
                      'https://wa.me/?text=$encodedMsg');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url,
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
              const SizedBox(width: 12),
              _shareOption(
                context,
                icon: Icons.email_outlined,
                label: 'Email',
                color: const Color(0xFF2F7DE1),
                onTap: () async {
                  Navigator.pop(context);
                  final url = Uri.parse(
                      'mailto:?subject=${Uri.encodeComponent(centre.name)}&body=$encodedMsg');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
              const SizedBox(width: 12),
              _shareOption(
                context,
                icon: Icons.copy_outlined,
                label: 'Copy',
                color: const Color(0xFF5A5A5A),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Details copied to clipboard')));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shareOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/models/service_center_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/request_provider.dart';
import '../../core/providers/service_centre_provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestProvider>().fetchPendingCount();
    });
  }

  // 6.8 — open sheet immediately; sheet fetches its own data
  void _showJoinServiceCentreSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _JoinServiceCentreSheet(),
    );
  }

  // Service centre switcher sheet
  void _showSwitcherSheet(BuildContext context, ServiceCentreProvider provider) {
    Navigator.pop(context); // close drawer first
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _SwitcherSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final requests = context.watch<RequestProvider>();
    final pendingCount = requests.pendingCount;
    final user = auth.user;

    final scProvider = context.watch<ServiceCentreProvider>();

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _ServiceCentreSwitcherHeader(
              provider: scProvider,
              onSwitch: () => _showSwitcherSheet(context, scProvider),
            ),
            const Divider(height: 1),
            _item(context, Icons.home_outlined, 'Home',
                () => context.go('/home')),
            _item(context, Icons.directions_car_outlined, 'My Vehicles',
                () => context.go('/vehicles')),
            _item(context, Icons.calendar_today_outlined, 'Bookings',
                () => context.push('/bookings')),
            if (user == null || user.canManageService)
              _item(context, Icons.build_outlined, 'Services',
                  () => context.push('/services')),
            _item(context, Icons.store_outlined, 'Service Centers',
                () => context.push('/service-centers')),
            _itemWithBadge(
              context,
              Icons.swap_horiz_outlined,
              'Requests',
              () => context.push('/requests'),
              badge: pendingCount,
            ),
            if (user == null || user.canManageService)
              _item(context, Icons.group_add_outlined, 'Join Service Centre',
                  () => context.push('/service-centers/onboard')),
            _item(context, Icons.settings_outlined, 'Settings',
                () => context.push('/settings')),
            _item(context, Icons.person_outline, 'Profile',
                () => context.push('/profile')),
            const Spacer(),
            const Divider(),
            _item(context, Icons.logout, 'Logout', () {
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
                        await auth.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5963),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Logout', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            }, color: Colors.red),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 15, color: color ?? Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _itemWithBadge(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    required int badge,
  }) {
    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: Colors.black),
          if (badge > 0)
            Positioned(
              top: -4,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                    color: Color(0xFFFF5963), shape: BoxShape.circle),
                child: Text('$badge',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
      title: Text(label,
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

// ── Join Service Centre bottom sheet ─────────────────────────────────────────

// ── Service Centre Switcher Header ───────────────────────────────────────────

class _ServiceCentreSwitcherHeader extends StatelessWidget {
  final ServiceCentreProvider provider;
  final VoidCallback onSwitch;

  const _ServiceCentreSwitcherHeader({
    required this.provider,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final current = provider.current;
    final hasMultiple = provider.hasMultiple;

    return InkWell(
      onTap: hasMultiple ? onSwitch : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1F26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.build_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AUTOLAB',
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9E9E9E),
                        letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 1),
                  provider.loading
                      ? Container(
                          height: 14,
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                      : Text(
                          current?.name ?? 'No Service Centre',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: current != null
                                  ? const Color(0xFF1B1F26)
                                  : const Color(0xFF9E9E9E)),
                          overflow: TextOverflow.ellipsis,
                        ),
                  if (current != null)
                    Text(
                      current.roleLabel +
                          (current.city != null ? '  •  \${current.city}' : ''),
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: const Color(0xFF9E9E9E)),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (hasMultiple)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.unfold_more_rounded,
                    size: 18, color: Color(0xFF5A5A5A)),
              ),
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
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Switch Service Centre',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                Text('Select the centre you want to work in',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: const Color(0xFF9E9E9E))),
              ],
            ),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1B1F26)
                      : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.store_outlined,
                    size: 20,
                    color: isActive ? Colors.white : const Color(0xFF5A5A5A)),
              ),
              title: Text(c.name,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w500,
                      color: const Color(0xFF1B1F26))),
              subtitle: Text(
                c.roleLabel + (c.city != null ? '  •  \${c.city}' : ''),
                style: GoogleFonts.poppins(
                    fontSize: 11, color: const Color(0xFF9E9E9E)),
              ),
              trailing: isActive
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7EE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Active',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2F9E56))),
                    )
                  : const Icon(Icons.chevron_right,
                      color: Color(0xFFBDBDBD), size: 20),
            );
          }),
          const Divider(height: 8),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              context.push('/service-centers/onboard');
            },
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_rounded,
                  size: 22, color: Color(0xFF2F7DE1)),
            ),
            title: Text('Add or Join a Centre',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F7DE1))),
            subtitle: Text('Register new or join existing',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: const Color(0xFF9E9E9E))),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Public base so it can be used from both AppDrawer and ServiceCentreGatewayScreen
class JoinServiceCentreSheetBase extends StatefulWidget {
  const JoinServiceCentreSheetBase();

  @override
  State<JoinServiceCentreSheetBase> createState() =>
      _JoinServiceCentreSheetState();
}

class _JoinServiceCentreSheet extends JoinServiceCentreSheetBase {
  const _JoinServiceCentreSheet();
}

class _JoinServiceCentreSheetState extends State<JoinServiceCentreSheetBase> {
  final _searchCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _api = ApiClient();

  List<ServiceCenterModel> _all = [];
  ServiceCenterModel? _selected;
  bool _loading = true;
  String? _error;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
    _fetchCenters();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchCenters() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.get('/api/service-centers',
          queryParameters: {'limit': '100'});
      final list = res.data['centers'] as List;
      setState(() {
        _all = list
            .map((e) =>
                ServiceCenterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      setState(
          () => _error = 'Failed to load service centres. Tap to retry.');
    } finally {
      setState(() => _loading = false);
    }
  }

  List<ServiceCenterModel> get _filtered {
    final q = _searchCtrl.text.toLowerCase().trim();
    if (q.isEmpty) return _all;
    return _all
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            (c.city?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  Future<void> _send() async {
    if (_selected == null) return;
    setState(() => _sending = true);
    final ok = await context
        .read<RequestProvider>()
        .sendServiceCenterJoinRequest(
          serviceCenterId: _selected!.id,
          message:
              _msgCtrl.text.trim().isEmpty ? null : _msgCtrl.text.trim(),
        );
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Join request sent!' : 'Failed to send request'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: const Color(0xFFDDDDDD),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),

            // Header + search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Join a Service Centre',
                      style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                      'Search and select a service centre to send a join request.',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF7A7A7A))),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchCtrl,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Search by name or city…',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, color: const Color(0xFF9E9E9E)),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Color(0xFF8B8B8B), size: 20),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () => _searchCtrl.clear())
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                    ),
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // List area
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 40, color: Color(0xFFBDBDBD)),
                              const SizedBox(height: 10),
                              Text(_error!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF7A7A7A))),
                              const SizedBox(height: 10),
                              TextButton.icon(
                                onPressed: _fetchCenters,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _filtered.isEmpty
                          ? Center(
                              child: Text(
                                _all.isEmpty
                                    ? 'No service centres available'
                                    : 'No results for "${_searchCtrl.text}"',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: const Color(0xFF9E9E9E)),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollCtrl,
                              itemCount: _filtered.length,
                              itemBuilder: (_, i) {
                                final c = _filtered[i];
                                final isSelected = _selected?.id == c.id;
                                return ListTile(
                                  onTap: () =>
                                      setState(() => _selected = c),
                                  selected: isSelected,
                                  selectedTileColor:
                                      const Color(0xFFEAF2FF),
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF2F7DE1)
                                              .withOpacity(0.1)
                                          : const Color(0xFFF2F2F2),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.store_outlined,
                                        size: 20,
                                        color: isSelected
                                            ? const Color(0xFF2F7DE1)
                                            : const Color(0xFF5A5A5A)),
                                  ),
                                  title: Text(c.name,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500)),
                                  subtitle: c.city != null
                                      ? Text(c.city!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: const Color(
                                                  0xFF9E9E9E)))
                                      : null,
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle,
                                          color: Color(0xFF2F7DE1),
                                          size: 20)
                                      : null,
                                );
                              },
                            ),
            ),

            // Bottom panel — shown only when a centre is selected
            if (_selected != null) ...[
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    MediaQuery.of(context).viewInsets.bottom + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Selected chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.store_outlined,
                              size: 16, color: Color(0xFF2F7DE1)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_selected!.name,
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2F7DE1))),
                          ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _selected = null),
                            child: const Icon(Icons.close,
                                size: 16, color: Color(0xFF2F7DE1)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _msgCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Message (optional)',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF9E9E9E)),
                        filled: true,
                        fillColor: const Color(0xFFF8F8F8),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E3E7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E3E7)),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sending ? null : _send,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B1F26),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _sending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : Text('Send Join Request',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

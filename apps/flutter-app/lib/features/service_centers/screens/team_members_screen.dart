import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/api/api_client.dart';

class TeamMembersScreen extends StatefulWidget {
  final String centreId;
  final String centreName;
  final bool isOwner;

  const TeamMembersScreen({
    super.key,
    required this.centreId,
    required this.centreName,
    this.isOwner = false,
  });

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  final _api = ApiClient();
  List<Map<String, dynamic>> _members = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await _api.get('/api/service-centers/${widget.centreId}/members');
      final list = res.data['members'] as List;
      setState(() => _members = list.cast<Map<String, dynamic>>());
    } catch (e) {
      setState(() => _error = 'Failed to load team members');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showChangeRoleSheet(Map<String, dynamic> member) {
    final userId = member['user_id'] as String;
    final currentRole = member['role'] as String;
    final userName = member['user']?['display_name'] ?? 'Member';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _RolePickerSheet(
        userName: userName,
        currentRole: currentRole,
        onSelect: (role) async {
          Navigator.pop(context);
          try {
            await _api.put(
              '/api/service-centers/${widget.centreId}/members/$userId',
              data: {'role': role},
            );
            _fetch();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Role updated to $role')));
            }
          } catch (_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update role')));
            }
          }
        },
      ),
    );
  }

  void _confirmRemove(Map<String, dynamic> member) {
    final userId = member['user_id'] as String;
    final userName = member['user']?['display_name'] ?? 'this member';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove Member', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('Remove $userName from ${widget.centreName}?',
            style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _api.delete('/api/service-centers/${widget.centreId}/members/$userId');
                _fetch();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Member removed')));
                }
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to remove member')));
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5963), elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Remove', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Team', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1B1F26))),
            Text(widget.centreName, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E))),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF7A7A7A))),
                      const SizedBox(height: 10),
                      TextButton.icon(onPressed: _fetch, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetch,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _members.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _MemberCard(
                      member: _members[i],
                      isOwner: widget.isOwner,
                      onChangeRole: () => _showChangeRoleSheet(_members[i]),
                      onRemove: () => _confirmRemove(_members[i]),
                    ),
                  ),
                ),
    );
  }
}

// ── Member Card ──────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isOwner;
  final VoidCallback onChangeRole;
  final VoidCallback onRemove;

  const _MemberCard({
    required this.member,
    required this.isOwner,
    required this.onChangeRole,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final user = member['user'] as Map<String, dynamic>? ?? {};
    final name = user['display_name'] ?? 'Unknown';
    final email = user['email'] ?? '';
    final role = member['role'] as String? ?? 'user';
    final isOwnerMember = role == 'owner';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isOwnerMember ? const Color(0xFF2F7DE1).withOpacity(0.3) : const Color(0xFFEAEAEA)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isOwnerMember ? const Color(0xFFEAF2FF) : const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person_outline, size: 22,
                color: isOwnerMember ? const Color(0xFF2F7DE1) : const Color(0xFF5A5A5A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(email, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E)),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                _roleBadge(role),
              ],
            ),
          ),
          if (isOwner && !isOwnerMember)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'role') onChangeRole();
                if (v == 'remove') onRemove();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'role', child: Row(children: [
                  const Icon(Icons.swap_horiz, size: 18, color: Color(0xFF2F7DE1)),
                  const SizedBox(width: 8),
                  Text('Change Role', style: GoogleFonts.poppins(fontSize: 13)),
                ])),
                PopupMenuItem(value: 'remove', child: Row(children: [
                  const Icon(Icons.person_remove_outlined, size: 18, color: Color(0xFFFF5963)),
                  const SizedBox(width: 8),
                  Text('Remove', style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFFF5963))),
                ])),
              ],
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.more_vert, size: 18, color: Color(0xFF5A5A5A)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _roleBadge(String role) {
    Color bg, fg;
    switch (role) {
      case 'owner':    bg = const Color(0xFFEAF2FF); fg = const Color(0xFF2F7DE1); break;
      case 'partner':  bg = const Color(0xFFE8F7EE); fg = const Color(0xFF2F9E56); break;
      case 'mechanic': bg = const Color(0xFFFFF0DE); fg = const Color(0xFFDA8A1D); break;
      default:         bg = const Color(0xFFF2F2F2); fg = const Color(0xFF5A5A5A);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(role[0].toUpperCase() + role.substring(1),
          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

// ── Role Picker Sheet ────────────────────────────────────────────────────────

class _RolePickerSheet extends StatelessWidget {
  final String userName;
  final String currentRole;
  final ValueChanged<String> onSelect;

  const _RolePickerSheet({required this.userName, required this.currentRole, required this.onSelect});

  static const _roles = [
    ('partner', 'Partner', 'Can manage services and bookings', Icons.handshake_outlined),
    ('mechanic', 'Mechanic', 'Can create and edit services', Icons.build_outlined),
    ('user', 'Viewer', 'Read-only access', Icons.visibility_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text('Change Role', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
          Text('Select a new role for $userName', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF7A7A7A))),
          const SizedBox(height: 16),
          ..._roles.map((r) {
            final isActive = r.$1 == currentRole;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: isActive ? null : () => onSelect(r.$1),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFEAF2FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isActive ? const Color(0xFF2F7DE1) : const Color(0xFFE8E8E8)),
                  ),
                  child: Row(
                    children: [
                      Icon(r.$4, size: 20, color: isActive ? const Color(0xFF2F7DE1) : const Color(0xFF5A5A5A)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.$2, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(r.$3, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9E9E9E))),
                        ],
                      )),
                      if (isActive) const Icon(Icons.check_circle, color: Color(0xFF2F7DE1), size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

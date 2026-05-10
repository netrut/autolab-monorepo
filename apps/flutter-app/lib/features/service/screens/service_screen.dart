import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/models/vehicle_service_model.dart';
import '../../../core/providers/vehicle_service_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _searchController = TextEditingController();
  String? _statusFilter; // null=all, due, upcoming, completed
  String? _dateFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleServiceProvider>().fetchVehiclesWithStatus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Status style ─────────────────────────────────────────────────────────────

  ({String label, Color bg, Color text}) _statusStyle(String status) {
    switch (status) {
      case 'upcoming':
        return (label: 'Upcoming Service', bg: const Color(0xFFEAF2FF), text: const Color(0xFF2F7DE1));
      case 'completed':
        return (label: 'Service Completed', bg: const Color(0xFFE8F7EE), text: const Color(0xFF2F9E56));
      case 'due':
        return (label: 'Due Service', bg: const Color(0xFFFFF0DE), text: const Color(0xFFDA8A1D));
      default:
        return (label: 'No Service Yet', bg: const Color(0xFFF0F0F0), text: const Color(0xFF9E9E9E));
    }
  }

  Color _filterBg(String? f) {
    switch (f) {
      case 'due': return const Color(0xFFFFF0DE);
      case 'upcoming': return const Color(0xFFEAF2FF);
      case 'completed': return const Color(0xFFE8F7EE);
      default: return const Color(0xFFEFEFEF);
    }
  }

  Color _filterText(String? f) {
    switch (f) {
      case 'due': return const Color(0xFFDA8A1D);
      case 'upcoming': return const Color(0xFF2F7DE1);
      case 'completed': return const Color(0xFF2F9E56);
      default: return const Color(0xFF2B2B2B);
    }
  }

  // ── Date filter dialog ────────────────────────────────────────────────────────

  void _showDateFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter by Date', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  _dlgSection('Due Service', const Color(0xFFDA8A1D), [
                    ('Due Today', 'due_today'), ('Due Yesterday', 'due_yesterday'),
                    ('Due Last 7 Days', 'due_7days'), ('Due Last 30 Days', 'due_30days'),
                  ], setS),
                  _dlgSection('Upcoming Services', const Color(0xFF2F7DE1), [
                    ('Next 7 Days', 'upcoming_7days'), ('Next 30 Days', 'upcoming_30days'),
                  ], setS),
                  _dlgSection('Service Completed', const Color(0xFF2F9E56), [
                    ('Completed Yesterday', 'completed_yesterday'),
                    ('Completed Last 7 Days', 'completed_7days'),
                    ('Completed Last 30 Days', 'completed_30days'),
                  ], setS),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_dateFilter != null)
                          TextButton(
                            onPressed: () { setState(() => _dateFilter = null); Navigator.pop(ctx); },
                            child: Text('Clear', style: GoogleFonts.poppins(color: Colors.red)),
                          ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Close', style: GoogleFonts.poppins(color: const Color(0xFF2F7DE1), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dlgSection(String title, Color color, List<(String, String)> opts, StateSetter setS) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        const SizedBox(height: 8),
        ...opts.map((o) {
          final selected = _dateFilter == o.$2;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setS(() => _dateFilter = selected ? null : o.$2);
                setState(() => _dateFilter = selected ? null : o.$2);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFF0F5FF) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: selected ? const Color(0xFF2F7DE1) : const Color(0xFFDCDCDC), width: selected ? 2 : 1),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(o.$1, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500))),
                    if (selected) const Icon(Icons.check_circle, color: Color(0xFF2F7DE1), size: 18),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Vehicle card ──────────────────────────────────────────────────────────────

  Widget _buildVehicleCard(VehicleWithServiceStatus v) {
    final style = _statusStyle(v.serviceStatus);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E4E4)),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Vehicle image
              Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    v.isCar ? 'assets/images/four-wheeler.png' : 'assets/images/two-wheeler.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.registrationNumber ?? v.displayName,
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF232323)),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: style.bg, borderRadius: BorderRadius.circular(999)),
                      child: Text(style.label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: style.text)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${v.isCar ? 'Car' : 'Bike'} • ${v.displayName}',
                          style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF7A7A7A)),
                        ),
                        if (v.lastServiceDate != null) ...[
                          const Text(' • ', style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 11)),
                          Text(
                            DateFormat('dd MMM yy').format(v.lastServiceDate!),
                            style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF7A7A7A)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _actionBtn('Service', filled: true, onTap: () => context.push('/service/form/${v.id}')),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _actionBtn('History', filled: false, onTap: () => context.push('/service/history/${v.id}')),
                        ),
                      ],
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

  Widget _actionBtn(String label, {required bool filled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF1F1F1F) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1F1F1F)),
        ),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: filled ? Colors.white : const Color(0xFF1F1F1F))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleServiceProvider>();
    final query = _searchController.text.toLowerCase().trim();

    final filtered = provider.vehicles.where((v) {
      final matchSearch = query.isEmpty ||
          (v.registrationNumber?.toLowerCase().contains(query) ?? false) ||
          v.displayName.toLowerCase().contains(query);
      final matchStatus = _statusFilter == null || v.serviceStatus == _statusFilter;
      return matchSearch && matchStatus;
    }).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F3F3),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('SERVICE', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1F1F1F), letterSpacing: 0.8)),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text('Vehicle Service', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: const Color(0xFF1E1E1E))),
                Text('Find vehicle and manage service records', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF7A7A7A))),
                const SizedBox(height: 12),

                // Search bar
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDCDCDC)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Color(0xFF8B8B8B), size: 22),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search vehicle number or name',
                              hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF8A8A8A)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(icon: const Icon(Icons.clear, color: Color(0xFF7A7A7A), size: 20), onPressed: () => _searchController.clear())
                                  : null,
                            ),
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF2B2B2B)),
                          ),
                        ),
                        InkWell(
                          onTap: _showDateFilterDialog,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.tune_rounded, color: _dateFilter != null ? const Color(0xFF2F7DE1) : const Color(0xFF2A2A2A), size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Status filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      (null, 'All'), ('due', 'Due'), ('upcoming', 'Upcoming'), ('completed', 'Completed'),
                    ].map((opt) {
                      final val = opt.$1;
                      final lbl = opt.$2;
                      final selected = _statusFilter == val;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(lbl, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: selected ? _filterText(val) : const Color(0xFF7A7A7A))),
                          selected: selected,
                          onSelected: (_) => setState(() => _statusFilter = val),
                          backgroundColor: Colors.white,
                          selectedColor: _filterBg(val),
                          showCheckmark: false,
                          side: BorderSide(color: selected ? _filterText(val) : const Color(0xFFDCDCDC)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // List
                Expanded(
                  child: provider.vehiclesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.build_circle_outlined, size: 64, color: Color(0xFFBDBDBD)),
                                  const SizedBox(height: 16),
                                  Text(
                                    provider.vehicles.isEmpty ? 'No vehicles found' : 'No vehicles match your filter',
                                    style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF7A7A7A)),
                                  ),
                                  if (provider.vehiclesError != null) ...[
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: () => provider.fetchVehiclesWithStatus(),
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => provider.fetchVehiclesWithStatus(),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: filtered.length,
                                itemBuilder: (_, i) => _buildVehicleCard(filtered[i]),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

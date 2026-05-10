import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/vehicle_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _searchController = TextEditingController();
  String? _selectedServiceFilter; // null = all
  String? _selectedDateFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Status helpers ──────────────────────────────────────────────────────────

  String _serviceStatus(VehicleModel v) {
    final next = v.nextServiceDue;
    final last = v.lastServiceDate;
    final today = DateTime.now();

    if (next != null && next.isAfter(today)) return 'upcoming';
    if (last != null &&
        last.isBefore(today.subtract(const Duration(days: 30)))) {
      return 'completed';
    }
    return 'due';
  }

  ({String label, Color bgColor, Color textColor}) _statusStyle(String status) {
    switch (status) {
      case 'upcoming':
        return (
          label: 'Upcoming Service',
          bgColor: const Color(0xFFEAF2FF),
          textColor: const Color(0xFF2F7DE1),
        );
      case 'completed':
        return (
          label: 'Service Completed',
          bgColor: const Color(0xFFE8F7EE),
          textColor: const Color(0xFF2F9E56),
        );
      default:
        return (
          label: 'Due Service',
          bgColor: const Color(0xFFFFF0DE),
          textColor: const Color(0xFFDA8A1D),
        );
    }
  }

  Color _filterBgColor(String? f) {
    switch (f) {
      case 'due':       return const Color(0xFFFFF0DE);
      case 'upcoming':  return const Color(0xFFEAF2FF);
      case 'completed': return const Color(0xFFE8F7EE);
      default:          return const Color(0xFFEFEFEF);
    }
  }

  Color _filterTextColor(String? f) {
    switch (f) {
      case 'due':       return const Color(0xFFDA8A1D);
      case 'upcoming':  return const Color(0xFF2F7DE1);
      case 'completed': return const Color(0xFF2F9E56);
      default:          return const Color(0xFF2B2B2B);
    }
  }

  // ── Date filter matching ────────────────────────────────────────────────────

  bool _matchesDateFilter(VehicleModel v) {
    if (_selectedDateFilter == null) return true;
    final today = DateTime.now();
    final d = v.nextServiceDue ?? v.lastServiceDate;
    if (d == null) return false;

    switch (_selectedDateFilter) {
      case 'due_today':
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      case 'due_yesterday':
        final y = today.subtract(const Duration(days: 1));
        return d.year == y.year && d.month == y.month && d.day == y.day;
      case 'due_7days':
        return d.isAfter(today.subtract(const Duration(days: 7))) &&
            d.isBefore(today);
      case 'due_30days':
        return d.isAfter(today.subtract(const Duration(days: 30))) &&
            d.isBefore(today);
      case 'upcoming_7days':
        return d.isAfter(today) &&
            d.isBefore(today.add(const Duration(days: 7)));
      case 'upcoming_30days':
        return d.isAfter(today) &&
            d.isBefore(today.add(const Duration(days: 30)));
      case 'completed_yesterday':
        final y = today.subtract(const Duration(days: 1));
        return d.year == y.year && d.month == y.month && d.day == y.day;
      case 'completed_7days':
        return d.isAfter(today.subtract(const Duration(days: 7)));
      case 'completed_30days':
        return d.isAfter(today.subtract(const Duration(days: 30)));
      default:
        return true;
    }
  }

  // ── Filter dialog ───────────────────────────────────────────────────────────

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlgState) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter by Date',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F1F1F))),
                  const SizedBox(height: 20),
                  Text('Due Service',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: const Color(0xFFDA8A1D))),
                  const SizedBox(height: 10),
                  _dlgOption('Due Today', 'due_today', setDlgState),
                  _dlgOption('Due Yesterday', 'due_yesterday', setDlgState),
                  _dlgOption('Due Last 7 Days', 'due_7days', setDlgState),
                  _dlgOption('Due Last 30 Days', 'due_30days', setDlgState),
                  const SizedBox(height: 20),
                  Text('Upcoming Services',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: const Color(0xFF2F7DE1))),
                  const SizedBox(height: 10),
                  _dlgOption('Next 7 Days', 'upcoming_7days', setDlgState),
                  _dlgOption('Next 30 Days', 'upcoming_30days', setDlgState),
                  const SizedBox(height: 20),
                  Text('Service Completed',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: const Color(0xFF2F9E56))),
                  const SizedBox(height: 10),
                  _dlgOption('Completed Yesterday', 'completed_yesterday',
                      setDlgState),
                  _dlgOption(
                      'Completed Last 7 Days', 'completed_7days', setDlgState),
                  _dlgOption('Completed Last 30 Days', 'completed_30days',
                      setDlgState),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Close',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF2F7DE1),
                              fontWeight: FontWeight.w600)),
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

  Widget _dlgOption(String label, String value, StateSetter setDlgState) {
    final selected = _selectedDateFilter == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setDlgState(
              () => _selectedDateFilter = selected ? null : value);
          setState(() => _selectedDateFilter = selected ? null : value);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF5F5F5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xFF2F7DE1)
                  : const Color(0xFFDCDCDC),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500,
                        color: const Color(0xFF1F1F1F))),
              ),
              if (selected)
                const Icon(Icons.check_circle,
                    color: Color(0xFF2F7DE1), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Service filter chips ────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    final options = [
      (null, 'All Services'),
      ('due', 'Due Services'),
      ('upcoming', 'Upcoming Services'),
      ('completed', 'Service Completed'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: options.map((opt) {
            final val = opt.$1;
            final lbl = opt.$2;
            final selected = _selectedServiceFilter == val;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(lbl,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: selected
                            ? _filterTextColor(val)
                            : const Color(0xFF7A7A7A))),
                selected: selected,
                onSelected: (_) =>
                    setState(() => _selectedServiceFilter = val),
                backgroundColor: Colors.white,
                selectedColor: _filterBgColor(val),
                showCheckmark: false,
                side: BorderSide(
                  color: selected
                      ? _filterTextColor(val)
                      : const Color(0xFFDCDCDC),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Vehicle service card ────────────────────────────────────────────────────

  Widget _buildVehicleCard(VehicleModel v) {
    final status = _serviceStatus(v);
    final style = _statusStyle(status);
    final isCar = v.isCar;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        height: 154,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E4E4)),
          boxShadow: const [
            BoxShadow(
                blurRadius: 10,
                color: Color(0x14000000),
                offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            // Vehicle image
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: 112,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    isCar
                        ? 'assets/images/four-wheeler.png'
                        : 'assets/images/two-wheeler.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.registrationNumber ?? v.displayName,
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF232323)),
                    ),
                    const SizedBox(height: 6),
                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: style.bgColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(style.label,
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: style.textColor)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${isCar ? 'Car' : 'Bike'} • ${v.displayName}',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A7A7A)),
                    ),
                    const Spacer(),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            label: 'Service',
                            filled: true,
                            onTap: () => context.push('/bookings/create'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _actionButton(
                            label: 'History',
                            filled: false,
                            onTap: () => context.push('/bookings'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      {required String label,
      required bool filled,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF1F1F1F) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1F1F1F)),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: filled ? Colors.white : const Color(0xFF1F1F1F))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();
    final query = _searchController.text.toLowerCase().trim();

    final filtered = provider.vehicles.where((v) {
      final matchSearch = query.isEmpty ||
          (v.registrationNumber?.toLowerCase().contains(query) ?? false) ||
          v.displayName.toLowerCase().contains(query) ||
          v.vehicleType.toLowerCase().contains(query);
      final status = _serviceStatus(v);
      final matchStatus = _selectedServiceFilter == null ||
          status == _selectedServiceFilter;
      return matchSearch && matchStatus && _matchesDateFilter(v);
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
          title: Text('SEARCH',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F1F),
                  letterSpacing: 0.8)),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Search Vehicles',
                          style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1E1E))),
                      Text(
                          'Find your vehicle and open service or history in one tap',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF7A7A7A))),
                    ],
                  ),
                ),
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
                        const Icon(Icons.search_rounded,
                            color: Color(0xFF8B8B8B), size: 22),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search vehicle number or type',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF8A8A8A)),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Color(0xFF7A7A7A), size: 20),
                                      onPressed: () =>
                                          _searchController.clear(),
                                    )
                                  : null,
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2B2B2B)),
                          ),
                        ),
                        InkWell(
                          onTap: _showFilterDialog,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.tune_rounded,
                              color: _selectedDateFilter != null
                                  ? const Color(0xFF2F7DE1)
                                  : const Color(0xFF2A2A2A),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Service filter chips
                _buildFilterChips(),
                const SizedBox(height: 14),

                // List
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Text(
                                  provider.vehicles.isEmpty
                                      ? 'No vehicles found'
                                      : 'No vehicles match your search',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF7A7A7A)),
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) =>
                                  _buildVehicleCard(filtered[i]),
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

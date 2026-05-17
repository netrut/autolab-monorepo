import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/vehicle_service_provider.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/vehicle_card.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  // Active filters
  String? _statusFilter;
  String? _vehicleTypeFilter;
  String? _dateFilter;
  String? _sortFilter;

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

  int get _activeFilterCount => [
        _statusFilter,
        _vehicleTypeFilter,
        _dateFilter,
        _sortFilter,
      ].where((f) => f != null).length;

  void _clearAllFilters() {
    setState(() {
      _statusFilter = null;
      _vehicleTypeFilter = null;
      _dateFilter = null;
      _sortFilter = null;
    });
  }

  // ── 8.1 Amazon-style filter bottom sheet ─────────────────────────────────

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        statusFilter: _statusFilter,
        vehicleTypeFilter: _vehicleTypeFilter,
        dateFilter: _dateFilter,
        sortFilter: _sortFilter,
        onApply: (status, vehicleType, date, sort) {
          setState(() {
            _statusFilter = status;
            _vehicleTypeFilter = vehicleType;
            _dateFilter = date;
            _sortFilter = sort;
          });
        },
        onClear: _clearAllFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleServiceProvider>();
    final query = _searchController.text.toLowerCase().trim();

    var filtered = provider.vehicles.where((v) {
      final matchSearch = query.isEmpty ||
          (v.registrationNumber?.toLowerCase().contains(query) ?? false) ||
          v.displayName.toLowerCase().contains(query);
      final matchStatus =
          _statusFilter == null || v.serviceStatus == _statusFilter;
      final matchType = _vehicleTypeFilter == null ||
          v.vehicleType.toLowerCase() == _vehicleTypeFilter;
      return matchSearch && matchStatus && matchType;
    }).toList();

    // Apply sort
    if (_sortFilter == 'last_serviced_newest') {
      filtered.sort((a, b) =>
          (b.lastServiceDate ?? DateTime(0)).compareTo(a.lastServiceDate ?? DateTime(0)));
    } else if (_sortFilter == 'last_serviced_oldest') {
      filtered.sort((a, b) =>
          (a.lastServiceDate ?? DateTime(0)).compareTo(b.lastServiceDate ?? DateTime(0)));
    } else if (_sortFilter == 'next_service_soonest') {
      filtered.sort((a, b) =>
          (a.nextServiceDate ?? DateTime(9999)).compareTo(b.nextServiceDate ?? DateTime(9999)));
    } else if (_sortFilter == 'reg_az') {
      filtered.sort((a, b) =>
          (a.registrationNumber ?? '').compareTo(b.registrationNumber ?? ''));
    } else if (_sortFilter == 'total_services_most') {
      filtered.sort((a, b) => b.totalServices.compareTo(a.totalServices));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF3F3F3),
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F3F3),
          iconTheme: const IconThemeData(color: Color(0xFF3E3E3E)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF3E3E3E)),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text('SERVICE',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F1F),
                  letterSpacing: 0.8)),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF1B1F26),
          onPressed: () => context.push('/vehicles/add'),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Vehicle Service',
                //     style: GoogleFonts.poppins(
                //         fontSize: 26,
                //         fontWeight: FontWeight.w700,
                //         color: const Color(0xFF1E1E1E))),
                // Text('Find vehicle and manage service records',
                //     style: GoogleFonts.poppins(
                //         fontSize: 13,
                //         fontWeight: FontWeight.w500,
                //         color: const Color(0xFF7A7A7A))),
                // const SizedBox(height: 12),

                // Search bar with filter icon + badge
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
                              hintText: 'Search vehicle number or name',
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
                                          _searchController.clear())
                                  : null,
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2B2B2B)),
                          ),
                        ),
                        // Filter icon with active count badge
                        InkWell(
                          onTap: _showFilterSheet,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(Icons.tune_rounded,
                                    color: _activeFilterCount > 0
                                        ? const Color(0xFF2F7DE1)
                                        : const Color(0xFF2A2A2A),
                                    size: 22),
                                if (_activeFilterCount > 0)
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF2F7DE1),
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Text('$_activeFilterCount',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  const Icon(Icons.build_circle_outlined,
                                      size: 64, color: Color(0xFFBDBDBD)),
                                  const SizedBox(height: 16),
                                  Text(
                                    provider.vehicles.isEmpty
                                        ? 'No vehicles found'
                                        : 'No vehicles match your filter',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: const Color(0xFF7A7A7A)),
                                  ),
                                  if (_activeFilterCount > 0) ...[
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: _clearAllFilters,
                                      child: const Text('Clear Filters'),
                                    ),
                                  ],
                                  if (provider.vehiclesError != null) ...[
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: () => provider
                                          .fetchVehiclesWithStatus(),
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () =>
                                  provider.fetchVehiclesWithStatus(),
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.only(bottom: 20),
                                itemCount: filtered.length,
                                itemBuilder: (_, i) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10),
                                  child: VehicleCard(
                                    vehicleId: filtered[i].id,
                                    displayName: filtered[i].displayName,
                                    registrationNumber:
                                        filtered[i].registrationNumber,
                                    vehicleType: filtered[i].vehicleType,
                                    fuelType: filtered[i].fuelType,
                                    serviceStatus:
                                        filtered[i].serviceStatus,
                                    lastServiceDate:
                                        filtered[i].lastServiceDate,
                                    nextServiceDate:
                                        filtered[i].nextServiceDate,
                                  ),
                                ),
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

// ── Amazon-style filter bottom sheet ─────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final String? statusFilter;
  final String? vehicleTypeFilter;
  final String? dateFilter;
  final String? sortFilter;
  final void Function(String?, String?, String?, String?) onApply;
  final VoidCallback onClear;

  const _FilterSheet({
    required this.statusFilter,
    required this.vehicleTypeFilter,
    required this.dateFilter,
    required this.sortFilter,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _status;
  late String? _vehicleType;
  late String? _date;
  late String? _sort;
  int _selectedCategory = 0;

  static const _categories = [
    'Service Status',
    'Vehicle Type',
    'Date Range',
    'Sort By',
  ];

  @override
  void initState() {
    super.initState();
    _status = widget.statusFilter;
    _vehicleType = widget.vehicleTypeFilter;
    _date = widget.dateFilter;
    _sort = widget.sortFilter;
  }

  String? _currentValue(int cat) {
    switch (cat) {
      case 0: return _status;
      case 1: return _vehicleType;
      case 2: return _date;
      case 3: return _sort;
      default: return null;
    }
  }

  void _setValue(int cat, String? val) {
    setState(() {
      switch (cat) {
        case 0: _status = val;
        case 1: _vehicleType = val;
        case 2: _date = val;
        case 3: _sort = val;
      }
    });
  }

  List<(String, String)> _options(int cat) {
    switch (cat) {
      case 0:
        return [
          ('All', ''),
          ('Due', 'due'),
          ('Upcoming', 'upcoming'),
          ('Completed', 'completed'),
          ('No Service Yet', 'no_service'),
        ];
      case 1:
        return [
          ('All', ''),
          ('Car / SUV', 'car'),
          ('Bike / Scooter', 'bike'),
        ];
      case 2:
        return [
          ('Due Today', 'due_today'),
          ('Due Last 7 Days', 'due_7days'),
          ('Due Last 30 Days', 'due_30days'),
          ('Upcoming Next 7 Days', 'upcoming_7days'),
          ('Upcoming Next 30 Days', 'upcoming_30days'),
          ('Completed Last 7 Days', 'completed_7days'),
          ('Completed Last 30 Days', 'completed_30days'),
        ];
      case 3:
        return [
          ('Last Serviced (newest)', 'last_serviced_newest'),
          ('Last Serviced (oldest)', 'last_serviced_oldest'),
          ('Next Service (soonest)', 'next_service_soonest'),
          ('Registration (A-Z)', 'reg_az'),
          ('Total Services (most)', 'total_services_most'),
        ];
      default:
        return [];
    }
  }

  int get _totalActive => [_status, _vehicleType, _date, _sort]
      .where((f) => f != null && f.isNotEmpty)
      .length;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('Filters',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                if (_totalActive > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFF2F7DE1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('$_totalActive active',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Two-column layout
          Expanded(
            child: Row(
              children: [
                // Left sidebar — categories
                Container(
                  width: 130,
                  color: const Color(0xFFF8F8F8),
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (_, i) {
                      final isSelected = _selectedCategory == i;
                      final hasValue = _currentValue(i) != null &&
                          _currentValue(i)!.isNotEmpty;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            border: isSelected
                                ? const Border(
                                    left: BorderSide(
                                        color: Color(0xFF2F7DE1),
                                        width: 3))
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _categories[i],
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? const Color(0xFF1A1A1A)
                                          : const Color(0xFF5A5A5A)),
                                ),
                              ),
                              if (hasValue)
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF2F7DE1),
                                      shape: BoxShape.circle),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const VerticalDivider(width: 1),

                // Right panel — options
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: _options(_selectedCategory).map((opt) {
                      final val = opt.$2;
                      final label = opt.$1;
                      final current = _currentValue(_selectedCategory);
                      final isSelected =
                          val.isEmpty ? current == null || current.isEmpty
                                      : current == val;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => _setValue(
                              _selectedCategory,
                              val.isEmpty ? null : val),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEAF2FF)
                                  : const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF2F7DE1)
                                      : Colors.transparent,
                                  width: isSelected ? 1.5 : 1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(label,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: isSelected
                                              ? const Color(0xFF2F7DE1)
                                              : const Color(0xFF3A3A3A))),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check,
                                      color: Color(0xFF2F7DE1), size: 16),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Sticky bottom bar
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _status = null;
                        _vehicleType = null;
                        _date = null;
                        _sort = null;
                      });
                      widget.onClear();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Clear All',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5A5A5A))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        _status?.isEmpty == true ? null : _status,
                        _vehicleType?.isEmpty == true ? null : _vehicleType,
                        _date?.isEmpty == true ? null : _date,
                        _sort?.isEmpty == true ? null : _sort,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B1F26),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Apply Filters',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

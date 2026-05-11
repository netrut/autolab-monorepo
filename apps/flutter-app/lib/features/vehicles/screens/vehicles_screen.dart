import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/vehicle_provider.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/vehicle_card.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String? _selectedType;

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    final filtered = provider.vehicles.where((v) {
      final q = _searchController.text.toLowerCase().trim();
      final matchSearch = q.isEmpty ||
          v.displayName.toLowerCase().contains(q) ||
          (v.registrationNumber?.toLowerCase().contains(q) ?? false);
      final matchType = _selectedType == null ||
          v.vehicleType.toLowerCase() == _selectedType;
      return matchSearch && matchType;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        iconTheme: const IconThemeData(color: Color(0xFF3E3E3E)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF3E3E3E)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'MY VEHICLES',
          style: GoogleFonts.interTight(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF232323),
              letterSpacing: 1.0),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B1F26),
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar + filter icon
              Row(
                children: [
                  Expanded(
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
                              color: Color(0xFF8B8B8B), size: 22),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search vehicle number',
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF8A8A8A)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Color(0xFF7A7A7A),
                                            size: 20),
                                        onPressed: () =>
                                            _searchController.clear(),
                                      )
                                    : null,
                              ),
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2B2B2B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter icon button
                  GestureDetector(
                    onTap: () => _showFilterSheet(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _selectedType != null
                            ? const Color(0xFF1F1F1F)
                            : const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCDCDC)),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: _selectedType != null
                            ? Colors.white
                            : const Color(0xFF5A5A5A),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Active filter chip
              if (_selectedType != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedType == 'car' ? 'Car' : 'Bike',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedType = null),
                              child: const Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // List
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    // 8.5 — error state with retry
                    : provider.error != null && provider.vehicles.isEmpty
                        ? EmptyState(
                            icon: Icons.error_outline,
                            message: 'Failed to load vehicles',
                            subMessage: 'Check your connection and try again',
                            retryLabel: 'Retry',
                            onRetry: () => provider.fetchVehicles(),
                          )
                        : filtered.isEmpty
                            // 8.3 — improved empty state
                            ? EmptyState(
                                icon: Icons.directions_car_outlined,
                                message: provider.vehicles.isEmpty
                                    ? 'No vehicles added yet'
                                    : 'No vehicles match your search',
                                subMessage: provider.vehicles.isEmpty
                                    ? 'Add your first vehicle to get started'
                                    : null,
                                actionLabel: provider.vehicles.isEmpty
                                    ? 'Add Vehicle'
                                    : null,
                                onAction: provider.vehicles.isEmpty
                                    ? () => context.push('/vehicles/add')
                                    : null,
                              )
                            // 8.4 — pull-to-refresh
                            : RefreshIndicator(
                                onRefresh: () => provider.fetchVehicles(),
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (_, i) => VehicleCard(
                                    vehicleId: filtered[i].id,
                                    displayName: filtered[i].displayName,
                                    registrationNumber:
                                        filtered[i].registrationNumber,
                                    vehicleType: filtered[i].vehicleType,
                                    fuelType: filtered[i].fuelType,
                                  ),
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Type',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                _filterOption('All', null),
                const SizedBox(width: 10),
                _filterOption('Car', 'car'),
                const SizedBox(width: 10),
                _filterOption('Bike', 'bike'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String label, String? type) {
    final selected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = type);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1F1F1F) : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected
                  ? const Color(0xFF1F1F1F)
                  : const Color(0xFFDCDCDC)),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF5A5A5A))),
      ),
    );
  }

}


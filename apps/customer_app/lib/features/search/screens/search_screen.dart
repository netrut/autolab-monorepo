import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/service_center_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_back_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  List<ServiceCenterModel> _results = [];
  bool _loading = false;
  String? _vehicleTypeFilter;
  String? _serviceTypeFilter;

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      final params = <String, dynamic>{};
      if (_searchCtrl.text.isNotEmpty) params['search'] = _searchCtrl.text;
      if (_vehicleTypeFilter != null) params['vehicleTypes'] = _vehicleTypeFilter;
      if (_serviceTypeFilter != null) params['serviceTypes'] = _serviceTypeFilter;
      final res = await ApiClient().get('/api/service-centers', queryParameters: params.isNotEmpty ? params : null);
      final data = res.data;
      final list = (data is Map ? (data['centers'] ?? []) : []) as List;
      _results = list.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        // ensure phone is never null
        map['phone'] = map['phone']?.toString() ?? '';
        return ServiceCenterModel.fromJson(map);
      }).toList();
    } catch (e) {
      debugPrint('SearchScreen error: $e');
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Find Service Centre'), leading: const AppBackButton()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Search by name, city...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () { _searchCtrl.clear(); _search(); })
                    : null,
              ),
            ),
          ),
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'Car', selected: _vehicleTypeFilter == 'car', onTap: () {
                    setState(() => _vehicleTypeFilter = _vehicleTypeFilter == 'car' ? null : 'car');
                    _search();
                  }),
                  const SizedBox(width: 6),
                  _FilterChip(label: 'Bike', selected: _vehicleTypeFilter == 'bike', onTap: () {
                    setState(() => _vehicleTypeFilter = _vehicleTypeFilter == 'bike' ? null : 'bike');
                    _search();
                  }),
                  const SizedBox(width: 6),
                  _FilterChip(label: 'General', selected: _serviceTypeFilter == 'general', onTap: () {
                    setState(() => _serviceTypeFilter = _serviceTypeFilter == 'general' ? null : 'general');
                    _search();
                  }),
                  const SizedBox(width: 6),
                  _FilterChip(label: 'Oil Change', selected: _serviceTypeFilter == 'oil_change', onTap: () {
                    setState(() => _serviceTypeFilter = _serviceTypeFilter == 'oil_change' ? null : 'oil_change');
                    _search();
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? Center(child: Text('No service centres found', style: GoogleFonts.poppins(color: AppTheme.secondaryText)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final c = _results[i];
                          return GestureDetector(
                            onTap: () => context.push('/search/${c.id}'),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44, height: 44,
                                    decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
                                    child: const Icon(Icons.store_outlined, color: AppTheme.primaryBlue, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                                        if (c.city != null) Text(c.city!, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
                                      ],
                                    ),
                                  ),
                                  if (c.rating != null && c.rating! > 0)
                                    Row(children: [
                                      const Icon(Icons.star, size: 14, color: AppTheme.warning),
                                      const SizedBox(width: 2),
                                      Text(c.rating!.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                                    ]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.primaryBlue : AppTheme.border),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: selected ? AppTheme.primaryBlue : AppTheme.secondaryText),
        ),
      ),
    );
  }
}

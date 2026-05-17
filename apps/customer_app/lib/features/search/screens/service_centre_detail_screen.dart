import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/service_center_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';

class ServiceCentreDetailScreen extends StatefulWidget {
  final String centreId;
  const ServiceCentreDetailScreen({super.key, required this.centreId});

  @override
  State<ServiceCentreDetailScreen> createState() => _ServiceCentreDetailScreenState();
}

class _ServiceCentreDetailScreenState extends State<ServiceCentreDetailScreen> {
  ServiceCenterModel? _centre;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final res = await ApiClient().get('/api/service-centers/${widget.centreId}');
      _centre = ServiceCenterModel.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Service Centre')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _centre == null
              ? const Center(child: Text('Not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_centre!.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                            if (_centre!.description != null) ...[
                              const SizedBox(height: 4),
                              Text(_centre!.description!, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
                            ],
                            const SizedBox(height: 12),
                            if (_centre!.address != null) _InfoRow(Icons.location_on_outlined, _centre!.address!),
                            _InfoRow(Icons.phone_outlined, _centre!.phone),
                            if (_centre!.email != null) _InfoRow(Icons.email_outlined, _centre!.email!),
                            if (_centre!.workingHours != null) _InfoRow(Icons.access_time_outlined, _centre!.workingHours!),
                            if (_centre!.rating != null && _centre!.rating! > 0)
                              _InfoRow(Icons.star_outline, '${_centre!.rating!.toStringAsFixed(1)} Rating'),
                          ],
                        ),
                      ),
                      if (_centre!.vehicleTypes.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('Vehicle Types', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Wrap(spacing: 6, children: _centre!.vehicleTypes.map((t) => Chip(label: Text(t, style: const TextStyle(fontSize: 12)))).toList()),
                      ],
                      if (_centre!.serviceTypes.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text('Services Offered', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Wrap(spacing: 6, children: _centre!.serviceTypes.map((t) => Chip(label: Text(t, style: const TextStyle(fontSize: 12)))).toList()),
                      ],
                      const SizedBox(height: 24),
                      if (_centre!.acceptsBookings)
                        AppButton(label: 'Book Service', onPressed: () => context.push('/bookings/create')),
                      if (_centre!.mapsLink != null) ...[
                        const SizedBox(height: 12),
                        AppButton(
                          label: 'Open in Maps',
                          isOutlined: true,
                          icon: Icons.map_outlined,
                          onPressed: () => launchUrl(Uri.parse(_centre!.mapsLink!), mode: LaunchMode.externalApplication),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.secondaryText),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.primaryText))),
        ],
      ),
    );
  }
}

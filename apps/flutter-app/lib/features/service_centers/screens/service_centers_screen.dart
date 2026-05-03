import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/service_center_model.dart';

class ServiceCentersScreen extends StatefulWidget {
  const ServiceCentersScreen({super.key});

  @override
  State<ServiceCentersScreen> createState() => _ServiceCentersScreenState();
}

class _ServiceCentersScreenState extends State<ServiceCentersScreen> {
  final _api = ApiClient();
  List<ServiceCenterModel> _centers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final res = await _api.get('/api/service-centers');
      final list = res.data['centers'] as List;
      setState(() {
        _centers = list.map((e) => ServiceCenterModel.fromJson(e)).toList();
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SERVICE CENTERS')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load', style: GoogleFonts.poppins()),
                      TextButton(
                          onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : _centers.isEmpty
                  ? Center(
                      child: Text('No service centers found',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF7A7A7A))))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _centers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _CenterCard(center: _centers[i]),
                    ),
    );
  }
}

class _CenterCard extends StatelessWidget {
  final ServiceCenterModel center;
  const _CenterCard({required this.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(center.name,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              if (center.isVerified == true)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF249689).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Verified',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF249689))),
                ),
            ],
          ),
          if (center.address != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Color(0xFF7A7A7A)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${center.address}${center.city != null ? ', ${center.city}' : ''}',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: const Color(0xFF7A7A7A)),
                  ),
                ),
              ],
            ),
          ],
          if (center.rating != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Color(0xFFF9CF58)),
                const SizedBox(width: 4),
                Text(center.rating!.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await launchUrl(Uri.parse('tel:${center.phone}'));
            },
            icon: const Icon(Icons.phone_outlined, size: 16),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1B1F26)),
              foregroundColor: const Color(0xFF1B1F26),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/providers/vehicle_provider.dart';

/// Unified vehicle card used by VehiclesScreen and ServiceScreen.
///
/// Pass [serviceStatus] to show the status badge (due / upcoming / completed /
/// no_service). Omit it (null) to hide the badge — used on VehiclesScreen.
/// Pass [lastServiceDate] / [nextServiceDate] for the date sub-line.
class VehicleCard extends StatelessWidget {
  final String vehicleId;
  final String displayName;
  final String? registrationNumber;
  final String vehicleType; // 'car' | 'bike'
  final String? fuelType;

  /// null = no badge shown (VehiclesScreen mode)
  final String? serviceStatus;
  final DateTime? lastServiceDate;
  final DateTime? nextServiceDate;

  const VehicleCard({
    super.key,
    required this.vehicleId,
    required this.displayName,
    required this.vehicleType,
    this.registrationNumber,
    this.fuelType,
    this.serviceStatus,
    this.lastServiceDate,
    this.nextServiceDate,
  });

  bool get _isCar => vehicleType.toLowerCase() == 'car';

  String _truncate(String s, int max) =>
      s.length <= max ? s : '${s.substring(0, max)}…';

  // ── Status badge style ──────────────────────────────────────────────────────

  ({String label, Color bg, Color text}) get _statusStyle {
    switch (serviceStatus) {
      case 'upcoming':
        return (
          label: 'Upcoming Service',
          bg: const Color(0xFFEAF2FF),
          text: const Color(0xFF2F7DE1)
        );
      case 'completed':
        return (
          label: 'Service Completed',
          bg: const Color(0xFFE8F7EE),
          text: const Color(0xFF2F9E56)
        );
      case 'due':
        return (
          label: 'Due Service',
          bg: const Color(0xFFFFF0DE),
          text: const Color(0xFFDA8A1D)
        );
      default:
        return (
          label: 'No Service Yet',
          bg: const Color(0xFFF0F0F0),
          text: const Color(0xFF9E9E9E)
        );
    }
  }

  // ── Options bottom sheet ────────────────────────────────────────────────────

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined,
                color: Color(0xFF2F7DE1)),
            title: const Text('Book Service'),
            subtitle: const Text('Schedule a service appointment'),
            onTap: () {
              Navigator.pop(context);
              context.push('/bookings/create?vehicleId=$vehicleId');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                const Icon(Icons.build_outlined, color: Color(0xFFDA8A1D)),
            title: const Text('New Service Record'),
            subtitle: const Text('Fill service details after a service'),
            onTap: () {
              Navigator.pop(context);
              context.push('/service/form/$vehicleId');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF2F9E56)),
            title: const Text('Service History'),
            subtitle: const Text('View all past service records'),
            onTap: () {
              Navigator.pop(context);
              context.push('/service/history/$vehicleId');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit Vehicle'),
            onTap: () {
              Navigator.pop(context);
              context.push('/vehicles/edit/$vehicleId');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Remove Vehicle',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await context.read<VehicleProvider>().deleteVehicle(vehicleId);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasBadge = serviceStatus != null;
    final style = _statusStyle;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Vehicle image
          Container(
            width: 90,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _isCar
                    ? 'assets/images/four-wheeler.png'
                    : 'assets/images/two-wheeler.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  _isCar ? Icons.directions_car : Icons.two_wheeler,
                  size: 36,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        registrationNumber ?? displayName,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF232323)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _showOptions(context),
                    ),
                  ],
                ),

                // Sub-line: type • name (truncated to 14) • fuel
                Text(
                  '${_isCar ? 'Car' : 'Bike'} • ${_truncate(displayName, 14)}'
                  '${fuelType != null ? ' • $fuelType' : ''}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: const Color(0xFF7A7A7A)),
                  overflow: TextOverflow.ellipsis,
                ),

                // Status badge (only when serviceStatus provided)
                if (hasBadge) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: style.bg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(style.label,
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: style.text)),
                      ),
                      if (lastServiceDate != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('dd MMM yy').format(lastServiceDate!),
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: const Color(0xFF9E9E9E)),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

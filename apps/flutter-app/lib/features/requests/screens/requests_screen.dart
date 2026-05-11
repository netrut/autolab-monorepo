import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/models/request_model.dart';
import '../../../core/providers/request_provider.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<RequestProvider>();
      p.fetchReceived();
      p.fetchSent();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests',
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabs,
          labelStyle:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400),
          tabs: const [Tab(text: 'Received'), Tab(text: 'Sent')],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _RequestList(mode: _Mode.received),
          _RequestList(mode: _Mode.sent),
        ],
      ),
    );
  }
}

enum _Mode { received, sent }

class _RequestList extends StatelessWidget {
  final _Mode mode;
  const _RequestList({required this.mode});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();
    final list = mode == _Mode.received ? provider.received : provider.sent;

    if (provider.loading && list.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined,
                size: 56, color: Color(0xFFBDBDBD)),
            const SizedBox(height: 12),
            Text(
              mode == _Mode.received
                  ? 'No requests received'
                  : 'No requests sent',
              style: GoogleFonts.poppins(
                  fontSize: 15, color: const Color(0xFF7A7A7A)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => mode == _Mode.received
          ? context.read<RequestProvider>().fetchReceived()
          : context.read<RequestProvider>().fetchSent(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) =>
            RequestCard(request: list[i], mode: mode),
      ),
    );
  }
}

// ── RequestCard (6.6) ─────────────────────────────────────────────────────────

class RequestCard extends StatelessWidget {
  final RequestModel request;
  final _Mode mode;

  const RequestCard({super.key, required this.request, required this.mode});

  Color get _statusColor {
    switch (request.status) {
      case RequestStatus.accepted:  return const Color(0xFF2F9E56);
      case RequestStatus.rejected:  return const Color(0xFFFF5963);
      case RequestStatus.cancelled: return const Color(0xFF9E9E9E);
      default:                      return const Color(0xFFDA8A1D);
    }
  }

  String get _statusLabel {
    switch (request.status) {
      case RequestStatus.accepted:  return 'ACCEPTED';
      case RequestStatus.rejected:  return 'REJECTED';
      case RequestStatus.cancelled: return 'CANCELLED';
      default:                      return 'PENDING';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RequestProvider>();
    final isPending = request.status == RequestStatus.pending;

    final who = mode == _Mode.received
        ? request.fromUser?.name ?? 'Unknown'
        : request.toUser?.name ?? 'Owner';

    final entityLabel = request.entityType == 'vehicle'
        ? 'Vehicle access'
        : 'Service centre join';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  request.entityType == 'vehicle'
                      ? Icons.directions_car_outlined
                      : Icons.store_outlined,
                  size: 20,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.type.label,
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(
                      mode == _Mode.received
                          ? 'From: $who'
                          : 'To: $who',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF7A7A7A)),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_statusLabel,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _statusColor)),
              ),
            ],
          ),

          // ── Details ──────────────────────────────────────────────────────
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.label_outline,
                  size: 13, color: Color(0xFF9E9E9E)),
              const SizedBox(width: 4),
              Text('$entityLabel • Role: ${request.role}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: const Color(0xFF7A7A7A))),
            ],
          ),
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('"${request.message}"',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF5A5A5A))),
          ],
          if (request.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy, hh:mm a').format(request.createdAt!),
              style: GoogleFonts.poppins(
                  fontSize: 11, color: const Color(0xFFAAAAAA)),
            ),
          ],

          // ── Actions ──────────────────────────────────────────────────────
          if (isPending) ...[
            const SizedBox(height: 12),
            if (mode == _Mode.received)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final ok = await provider.reject(request.id);
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      provider.error ?? 'Failed')));
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF5963),
                        side: const BorderSide(color: Color(0xFFFF5963)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Reject',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final ok = await provider.accept(request.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(ok
                                  ? 'Request accepted!'
                                  : provider.error ?? 'Failed')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F9E56),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Accept',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final ok = await provider.cancel(request.id);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(provider.error ?? 'Failed')));
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF9E9E9E),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Cancel Request',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

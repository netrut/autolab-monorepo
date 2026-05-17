import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/request_provider.dart';
import '../../../core/models/request_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/status_badge.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestProvider>().fetchReceived();
      context.read<RequestProvider>().fetchSent();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Requests'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.secondaryText,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [Tab(text: 'Received'), Tab(text: 'Sent')],
        ),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabCtrl,
              children: [
                _RequestList(requests: provider.received, isReceived: true),
                _RequestList(requests: provider.sent, isReceived: false),
              ],
            ),
    );
  }
}

class _RequestList extends StatelessWidget {
  final List<RequestModel> requests;
  final bool isReceived;
  const _RequestList({required this.requests, required this.isReceived});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const EmptyState(icon: Icons.people_outline, title: 'No Requests', subtitle: 'Requests will appear here');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _RequestCard(request: requests[i], isReceived: isReceived),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final RequestModel request;
  final bool isReceived;
  const _RequestCard({required this.request, required this.isReceived});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RequestProvider>();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.type.label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
              StatusBadge(label: request.status.value, type: _statusType(request.status)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isReceived ? 'From: ${request.fromUser?.name ?? 'Unknown'}' : 'To: ${request.toUser?.name ?? 'Unknown'}',
            style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText),
          ),
          if (request.message != null) ...[
            const SizedBox(height: 4),
            Text(request.message!, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.secondaryText)),
          ],
          if (request.status == RequestStatus.pending) ...[
            const SizedBox(height: 10),
            Row(
              children: isReceived
                  ? [
                      Expanded(child: OutlinedButton(onPressed: () => provider.reject(request.id), child: const Text('Reject', style: TextStyle(fontSize: 12)))),
                      const SizedBox(width: 8),
                      Expanded(child: ElevatedButton(onPressed: () => provider.accept(request.id), child: const Text('Accept', style: TextStyle(fontSize: 12)))),
                    ]
                  : [
                      Expanded(child: OutlinedButton(onPressed: () => provider.cancel(request.id), child: const Text('Cancel', style: TextStyle(fontSize: 12)))),
                    ],
            ),
          ],
        ],
      ),
    );
  }

  StatusType _statusType(RequestStatus s) {
    switch (s) {
      case RequestStatus.accepted: return StatusType.success;
      case RequestStatus.rejected: return StatusType.error;
      case RequestStatus.cancelled: return StatusType.neutral;
      default: return StatusType.warning;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/invoice_model.dart';
import '../../../core/models/service_item_model.dart';
import '../../../core/providers/options_provider.dart';

class InvoiceScreen extends StatefulWidget {
  final String serviceId;
  const InvoiceScreen({super.key, required this.serviceId});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _api = ApiClient();
  InvoiceModel? _invoice;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res =
          await _api.get('/api/invoices/service/${widget.serviceId}');
      setState(() {
        _invoice = InvoiceModel.fromJson(res.data as Map<String, dynamic>);
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  // ── 5.5 PDF generation ──────────────────────────────────────────────────────

  Future<void> _downloadPdf() async {
    final inv = _invoice!;
    final svc = inv.service;
    final options = context.read<OptionsProvider>();

    final doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context ctx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('AUTOLAB',
                        style: pw.TextStyle(
                            fontSize: 22, fontWeight: pw.FontWeight.bold)),
                    pw.Text(options.serviceCentreName,
                        style: const pw.TextStyle(fontSize: 11)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('INVOICE',
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(inv.invoiceNumber,
                        style: const pw.TextStyle(fontSize: 11)),
                    pw.Text(
                        DateFormat('dd MMM yyyy').format(inv.serviceDate),
                        style: const pw.TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Divider(),
            pw.SizedBox(height: 12),

            // Vehicle info
            if (svc != null) ...[
              pw.Text('Vehicle Details',
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Text(
                  '${svc.vehicleBrand ?? ''} ${svc.vehicleModel ?? ''}'
                  '${svc.registrationNumber != null ? ' — ${svc.registrationNumber}' : ''}',
                  style: const pw.TextStyle(fontSize: 11)),
              pw.Text(
                  'Service Type: ${svc.serviceType[0].toUpperCase()}${svc.serviceType.substring(1)}',
                  style: const pw.TextStyle(fontSize: 11)),
              if (svc.odometerKm != null)
                pw.Text('Odometer: ${svc.odometerKm!.toStringAsFixed(0)} km',
                    style: const pw.TextStyle(fontSize: 11)),
              pw.SizedBox(height: 12),
            ],

            // Items table
            if (svc != null && svc.items.isNotEmpty) ...[
              pw.Text('Service Items',
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(
                    color: PdfColors.grey300, width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _cell('Item', bold: true),
                      _cell('Status', bold: true),
                      _cell('Cost (₹)', bold: true, right: true),
                    ],
                  ),
                  ...svc.items.map((item) => pw.TableRow(children: [
                        _cell(item.itemName),
                        _cell(item.status),
                        _cell('₹${item.cost.toStringAsFixed(0)}',
                            right: true),
                      ])),
                ],
              ),
              pw.SizedBox(height: 12),
            ],

            // Cost summary
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 200,
                child: pw.Column(
                  children: [
                    _summaryRow('Items Subtotal',
                        '₹${inv.itemsCost.toStringAsFixed(0)}'),
                    _summaryRow(
                        'Labour', '₹${inv.labourCost.toStringAsFixed(0)}'),
                    pw.Divider(),
                    _summaryRow(
                        'TOTAL', '₹${inv.totalCost.toStringAsFixed(0)}',
                        bold: true),
                  ],
                ),
              ),
            ),

            pw.Spacer(),
            pw.Divider(),
            pw.SizedBox(height: 6),
            pw.Text(
                inv.footerText ??
                    options.invoiceFooterText,
                style: pw.TextStyle(
                    fontSize: 10,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey600)),
          ],
        );
      },
    ));

    await Printing.layoutPdf(
        onLayout: (_) async => doc.save(),
        name: '${inv.invoiceNumber}.pdf');
  }

  pw.Widget _cell(String text,
      {bool bold = false, bool right = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: pw.Text(text,
          textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
          style: pw.TextStyle(
              fontSize: 10,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
    );
  }

  pw.Widget _summaryRow(String label, String value,
      {bool bold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                fontSize: 11,
                fontWeight:
                    bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 11,
                fontWeight:
                    bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    );
  }

  // ── 5.6 WhatsApp share ──────────────────────────────────────────────────────

  Future<void> _shareWhatsApp() async {
    final inv = _invoice!;
    final svc = inv.service;
    final options = context.read<OptionsProvider>();

    final vehicle = svc != null
        ? '${svc.vehicleBrand ?? ''} ${svc.vehicleModel ?? ''}'
            '${svc.registrationNumber != null ? ' (${svc.registrationNumber})' : ''}'
        : '';

    final msg = Uri.encodeComponent(
      '🔧 *Service Invoice — ${options.serviceCentreName}*\n\n'
      '📋 Invoice: ${inv.invoiceNumber}\n'
      '🚗 Vehicle: $vehicle\n'
      '📅 Date: ${DateFormat('dd MMM yyyy').format(inv.serviceDate)}\n'
      '💰 Total: ₹${inv.totalCost.toStringAsFixed(0)}\n\n'
      '${options.invoiceFooterText}',
    );

    final number = options.helplineNumber;
    final url = Uri.parse('https://wa.me/$number?text=$msg');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open WhatsApp')));
      }
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invoice')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _invoice == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invoice')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: Color(0xFFBDBDBD)),
              const SizedBox(height: 12),
              Text('Failed to load invoice',
                  style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A))),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final inv = _invoice!;
    final svc = inv.service;
    final options = context.watch<OptionsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text('Invoice',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        leading: const BackButton(color: Colors.black),
        actions: [
          // 5.5 — PDF download
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black),
            tooltip: 'Download PDF',
            onPressed: _downloadPdf,
          ),
          // 5.6 — WhatsApp share
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            tooltip: 'Share via WhatsApp',
            onPressed: _shareWhatsApp,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Invoice header card ──────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AUTOLAB',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2)),
                          Text(options.serviceCentreName,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF7A7A7A))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F7EE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('INVOICE',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2F9E56))),
                          ),
                          const SizedBox(height: 4),
                          Text(inv.invoiceNumber,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          Text(
                              DateFormat('dd MMM yyyy')
                                  .format(inv.serviceDate),
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF7A7A7A))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Vehicle details ──────────────────────────────────────────
            if (svc != null) ...[
              _sectionLabel('Vehicle Details'),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(Icons.directions_car_outlined,
                        '${svc.vehicleBrand ?? ''} ${svc.vehicleModel ?? ''}'.trim()),
                    if (svc.registrationNumber != null)
                      _infoRow(Icons.pin_outlined, svc.registrationNumber!),
                    _infoRow(Icons.build_outlined,
                        '${svc.serviceType[0].toUpperCase()}${svc.serviceType.substring(1)} Service'),
                    _infoRow(Icons.calendar_today_outlined,
                        DateFormat('dd MMM yyyy').format(svc.serviceDate)),
                    if (svc.odometerKm != null)
                      _infoRow(Icons.speed_outlined,
                          '${svc.odometerKm!.toStringAsFixed(0)} km'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── Service items ────────────────────────────────────────────
            if (svc != null && svc.items.isNotEmpty) ...[
              _sectionLabel('Service Items'),
              _card(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text('Item',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600))),
                          Expanded(
                              flex: 2,
                              child: Text('Status',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600))),
                          Text('Cost',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    ...svc.items.asMap().entries.map((e) {
                      final i = e.value;
                      final isLast = e.key == svc.items.length - 1;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : const Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFF0F0F0))),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(i.itemName,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                  if (i.notes != null &&
                                      i.notes!.isNotEmpty)
                                    Text(i.notes!,
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: const Color(
                                                0xFF9E9E9E))),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _statusColor(i.status)
                                      .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                                child: Text(i.status,
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: _statusColor(i.status))),
                              ),
                            ),
                            Text(
                              i.cost > 0
                                  ? '₹${i.cost.toStringAsFixed(0)}'
                                  : '—',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── Cost summary ─────────────────────────────────────────────
            _sectionLabel('Cost Summary'),
            _card(
              child: Column(
                children: [
                  _costRow('Items Subtotal',
                      '₹${inv.itemsCost.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _costRow(
                      'Labour', '₹${inv.labourCost.toStringAsFixed(0)}'),
                  const Divider(height: 20),
                  _costRow(
                      'TOTAL', '₹${inv.totalCost.toStringAsFixed(0)}',
                      bold: true, large: true),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Footer ───────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF2F7DE1).withOpacity(0.2)),
              ),
              child: Text(
                inv.footerText ?? options.invoiceFooterText,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF2F7DE1)),
              ),
            ),
            const SizedBox(height: 24),

            // ── Action buttons ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _downloadPdf,
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: Text('Download PDF',
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1B1F26),
                      side: const BorderSide(color: Color(0xFF1B1F26)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareWhatsApp,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text('Share WhatsApp',
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F1F1F))),
      );

  Widget _infoRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Icon(icon, size: 15, color: const Color(0xFF7A7A7A)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: const Color(0xFF3A3A3A))),
            ),
          ],
        ),
      );

  Widget _costRow(String label, String value,
      {bool bold = false, bool large = false}) {
    final size = large ? 15.0 : 13.0;
    final weight = bold ? FontWeight.w700 : FontWeight.w500;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: size,
                fontWeight: weight,
                color: const Color(0xFF3A3A3A))),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: size,
                fontWeight: weight,
                color: const Color(0xFF1F1F1F))),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Changed':
        return const Color(0xFF2F7DE1);
      case 'Replaced':
        return const Color(0xFF7B61FF);
      case 'Repaired':
        return const Color(0xFFDA8A1D);
      case 'Good':
        return const Color(0xFF2F9E56);
      case 'Needs Attention':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

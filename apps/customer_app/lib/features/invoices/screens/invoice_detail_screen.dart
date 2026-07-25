import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/invoice_model.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_back_button.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  InvoiceModel? _invoice;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final res = await ApiClient().get('/api/invoices/${widget.invoiceId}');
      _invoice = InvoiceModel.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Invoice'), leading: const AppBackButton(),
        actions: [
          if (_invoice != null)
            IconButton(
              icon: const Icon(Icons.download_outlined, size: 22),
              onPressed: _downloadPdf,
              tooltip: 'Download PDF',
            ),
          if (_invoice != null)
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 22),
              onPressed: _sharePdf,
              tooltip: 'Share',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _invoice == null
              ? const Center(child: Text('Invoice not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Invoice #${_invoice!.invoiceNumber}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(_formatDate(_invoice!.serviceDate), style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondaryText)),
                        const Divider(height: 24),
                        if (_invoice!.service != null && _invoice!.service!.items.isNotEmpty) ...[
                          Text('Items', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          ...(_invoice!.service!.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(item.itemName, style: GoogleFonts.poppins(fontSize: 13))),
                                Text('₹${item.cost.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ))),
                          const Divider(height: 20),
                        ],
                        _TotalRow(label: 'Items Cost', value: '₹${_invoice!.itemsCost.toStringAsFixed(0)}'),
                        _TotalRow(label: 'Labour Cost', value: '₹${_invoice!.labourCost.toStringAsFixed(0)}'),
                        const Divider(height: 16),
                        _TotalRow(label: 'Total', value: '₹${_invoice!.totalCost.toStringAsFixed(0)}', bold: true),
                        if (_invoice!.footerText != null) ...[
                          const SizedBox(height: 16),
                          Text(_invoice!.footerText!, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.secondaryText, fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> _downloadPdf() async {
    if (_invoice == null) return;
    final pdf = _buildPdf(_invoice!);
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> _sharePdf() async {
    if (_invoice == null) return;
    final pdf = _buildPdf(_invoice!);
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice_${_invoice!.invoiceNumber}.pdf');
  }

  pw.Document _buildPdf(InvoiceModel inv) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('#${inv.invoiceNumber}', style: const pw.TextStyle(fontSize: 14)),
            pw.Text('Date: ${_formatDate(inv.serviceDate)}'),
            pw.Divider(),
            pw.SizedBox(height: 12),
            if (inv.service != null && inv.service!.items.isNotEmpty) ...
              inv.service!.items.map((item) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text(item.itemName)),
                    pw.Text(item.status),
                    pw.SizedBox(width: 20),
                    pw.Text('Rs.${item.cost.toStringAsFixed(0)}'),
                  ],
                ),
              )),
            pw.Divider(),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('Items Cost'), pw.Text('Rs.${inv.itemsCost.toStringAsFixed(0)}'),
            ]),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('Labour Cost'), pw.Text('Rs.${inv.labourCost.toStringAsFixed(0)}'),
            ]),
            pw.Divider(),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.Text('Rs.${inv.totalCost.toStringAsFixed(0)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            ]),
            if (inv.footerText != null) ...[pw.SizedBox(height: 20), pw.Text(inv.footerText!, style: const pw.TextStyle(fontSize: 10))],
          ],
        ),
      ),
    );
    return pdf;
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _TotalRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: bold ? FontWeight.w600 : FontWeight.w400, color: bold ? AppTheme.primaryText : AppTheme.secondaryText)),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: bold ? AppTheme.primaryBlue : AppTheme.primaryText)),
        ],
      ),
    );
  }
}

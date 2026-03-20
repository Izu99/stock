import 'dart:io';
import 'dart:developer' as dev;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:stock/features/admin/data/models/company.dart';
import 'package:stock/features/sales/presentation/screens/billing_screen.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class ExportUtils {
  // Helper to save and share files
  static Future<void> _saveAndShareFile(
    List<int> bytes,
    String fileName,
    String mimeType,
  ) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Invoice $fileName');
  }

  static Future<void> generateInvoiceExcel({
    required Company company,
    required List<dynamic> cartItems,
    required double total,
    required String invoiceNumber,
  }) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Add Company Info
    sheet.appendRow([TextCellValue(company.name)]);
    sheet.appendRow([TextCellValue(company.address)]);
    sheet.appendRow([TextCellValue('Phone: ${company.phone}')]);
    sheet.appendRow([TextCellValue('')]);

    // Add Invoice Info
    sheet.appendRow([TextCellValue('INVOICE'), TextCellValue(invoiceNumber)]);
    sheet.appendRow([
      TextCellValue('Date'),
      TextCellValue(DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())),
    ]);
    sheet.appendRow([TextCellValue('')]);

    // Headers
    sheet.appendRow([
      TextCellValue('Item'),
      TextCellValue('Price'),
      TextCellValue('Qty'),
      TextCellValue('Total'),
    ]);

    // Data
    for (var item in cartItems) {
      sheet.appendRow([
        TextCellValue(item.stockItem.name),
        DoubleCellValue(item.sellPrice),
        DoubleCellValue(item.quantity),
        DoubleCellValue(item.subtotal),
      ]);
    }

    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('TOTAL'),
      DoubleCellValue(total),
    ]);

    final bytes = excel.save();
    if (bytes != null) {
      await _saveAndShareFile(
        bytes,
        'Invoice_$invoiceNumber.xlsx',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
    }
  }

  static Future<void> generateInvoicePdf({
    required Company company,
    required List<dynamic> cartItems,
    required double total,
    required String invoiceNumber,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final now = DateTime.now();

    // Try to load logo with fallback
    pw.ImageProvider? logoImage;
    try {
      logoImage = pw.MemoryImage(
        (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
      );
    } catch (e) {
      // Fallback if logo not found
      dev.log('⚠️ Logo not found, using text-based header');
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Segment
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (logoImage != null)
                        pw.SizedBox(
                          height: 60,
                          width: 60,
                          child: pw.Image(logoImage),
                        )
                      else
                        pw.Text(
                          company.name.substring(0, 1),
                          style: pw.TextStyle(
                            fontSize: 40,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue900,
                          ),
                        ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        company.name.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                      pw.Text(
                        company.address,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'TEL: ${company.phone}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                      pw.Text(
                        '#$invoiceNumber',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'DATE: ${dateFormat.format(now)}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),

              // Billing Section
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'BILL TO:',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text('Cash Customer',
                            style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Items Table
              pw.Table(
                border: const pw.TableBorder(
                  bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                  horizontalInside:
                      pw.BorderSide(color: PdfColors.grey200, width: 0.5),
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1.2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue50),
                    children: [
                      _buildHeaderCell('DESCRIPTION'),
                      _buildHeaderCell('UNIT PRICE', align: pw.Alignment.centerRight),
                      _buildHeaderCell('QTY', align: pw.Alignment.center),
                      _buildHeaderCell('AMOUNT', align: pw.Alignment.centerRight),
                    ],
                  ),
                  // Table Items
                  ...cartItems.map((item) {
                    return pw.TableRow(
                      children: [
                        _buildCell(item.stockItem.name),
                        _buildCell(item.sellPrice.toStringAsFixed(2),
                            align: pw.Alignment.centerRight),
                        _buildCell(
                          item.quantity.toStringAsFixed(
                            item.quantity == item.quantity.roundToDouble()
                                ? 0
                                : 1,
                          ),
                          align: pw.Alignment.center,
                        ),
                        _buildCell(item.subtotal.toStringAsFixed(2),
                            align: pw.Alignment.centerRight, isBold: true),
                      ],
                    );
                  }),
                ],
              ),

              pw.SizedBox(height: 20),

              // Totals Section
              pw.Row(
                children: [
                  pw.Spacer(flex: 2),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      children: [
                        _buildTotalRow('SUBTOTAL', total.toStringAsFixed(2)),
                        _buildTotalRow('TOTAL LKR', total.toStringAsFixed(2),
                            isTotal: true),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // Footer
              pw.Divider(thickness: 0.5, color: PdfColors.grey300),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Thank you for your business!',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.blueGrey700,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Terms: Return items within 7 days with the original receipt.',
                      style: const pw.TextStyle(
                          fontSize: 8, color: PdfColors.grey600),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Print the document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildHeaderCell(String text, {pw.Alignment? align}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Container(
        alignment: align ?? pw.Alignment.centerLeft,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
      ),
    );
  }

  static pw.Widget _buildCell(String text,
      {pw.Alignment? align, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: pw.Container(
        alignment: align ?? pw.Alignment.centerLeft,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }

  static pw.Widget _buildTotalRow(String label, String value,
      {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 12 : 10,
              fontWeight: pw.FontWeight.bold,
              color: isTotal ? PdfColors.blue900 : PdfColors.grey700,
            ),
          ),
          pw.Text(
            'Rs. $value',
            style: pw.TextStyle(
              fontSize: isTotal ? 12 : 10,
              fontWeight: pw.FontWeight.bold,
              color: isTotal ? PdfColors.blue900 : PdfColors.blueGrey800,
            ),
          ),
        ],
      ),
    );
  }
}

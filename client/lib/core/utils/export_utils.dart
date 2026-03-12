import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class ExportUtils {
  // Export data to CSV
  static Future<void> exportToCsv({
    required String filename,
    required List<List<dynamic>> data,
    String? shareText,
  }) async {
    try {
      final csv = const ListToCsvConverter().convert(data);
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename';
      final file = File(path);
      await file.writeAsString(csv);

      await Share.shareXFiles([
        XFile(path),
      ], text: shareText ?? 'Exported data');
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  // Export stock report to PDF
  static Future<void> exportStockReportToPdf({
    required List<Map<String, dynamic>> stockItems,
    required String companyName,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  companyName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Stock Report - ${dateFormat.format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.Divider(thickness: 2),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: [
              'Item',
              'Category',
              'Quantity',
              'Unit',
              'Buy Price',
              'Sell Price',
              'Value',
            ],
            data: stockItems.map((item) {
              final value = (item['quantity'] ?? 0) * (item['buyPrice'] ?? 0);
              return [
                item['name'] ?? '',
                item['category'] ?? '',
                item['quantity']?.toString() ?? '0',
                item['unit'] ?? '',
                item['buyPrice']?.toStringAsFixed(2) ?? '0.00',
                item['sellPrice']?.toStringAsFixed(2) ?? '0.00',
                value.toStringAsFixed(2),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Total Items: ${stockItems.length}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    await _savePdf(
      pdf,
      'stock_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  // Export profit statement to PDF
  static Future<void> exportProfitStatementToPdf({
    required String companyName,
    required double totalRevenue,
    required double totalExpenses,
    required double totalIncome,
    required double netProfit,
    required String period,
    List<Map<String, dynamic>>? topItems,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  companyName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Profit & Loss Statement',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(period, style: const pw.TextStyle(fontSize: 12)),
                pw.Divider(thickness: 2),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              _buildPdfRow('Revenue from Sales', totalRevenue, isHeader: false),
              _buildPdfRow('Other Income', totalIncome, isHeader: false),
              _buildPdfRow(
                'Total Income',
                totalRevenue + totalIncome,
                isBold: true,
              ),
              pw.TableRow(
                children: [pw.SizedBox(height: 10), pw.SizedBox(height: 10)],
              ),
              _buildPdfRow('Total Expenses', totalExpenses, isHeader: false),
              pw.TableRow(
                children: [pw.SizedBox(height: 10), pw.SizedBox(height: 10)],
              ),
              _buildPdfRow(
                'Net Profit',
                netProfit,
                isBold: true,
                isProfit: true,
              ),
            ],
          ),
          if (topItems != null && topItems.isNotEmpty) ...[
            pw.SizedBox(height: 30),
            pw.Text(
              'Top Selling Items',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Item', 'Quantity Sold', 'Revenue'],
              data: topItems
                  .map(
                    (item) => [
                      item['name'] ?? '',
                      item['totalQuantity']?.toString() ?? '0',
                      (item['totalRevenue'] ?? 0).toStringAsFixed(2),
                    ],
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );

    await _savePdf(
      pdf,
      'profit_statement_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static pw.TableRow _buildPdfRow(
    String label,
    double value, {
    bool isHeader = false,
    bool isBold = false,
    bool isProfit = false,
  }) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isHeader ? 14 : 12,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value.toStringAsFixed(2),
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isHeader ? 14 : 12,
            ),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  static Future<void> _savePdf(pw.Document pdf, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(path)], text: 'Report generated');
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  // Export to CSV for stock items
  static Future<void> exportStockToCsv(
    List<Map<String, dynamic>> stockItems,
  ) async {
    final data = [
      [
        'Item Name',
        'Category',
        'Quantity',
        'Unit',
        'Buy Price',
        'Sell Price',
        'Total Value',
      ],
      ...stockItems.map((item) {
        final value = (item['quantity'] ?? 0) * (item['buyPrice'] ?? 0);
        return [
          item['name'] ?? '',
          item['category'] ?? '',
          item['quantity']?.toString() ?? '0',
          item['unit'] ?? '',
          item['buyPrice']?.toString() ?? '0',
          item['sellPrice']?.toString() ?? '0',
          value.toString(),
        ];
      }),
    ];

    await exportToCsv(
      filename: 'stock_report_${DateTime.now().millisecondsSinceEpoch}.csv',
      data: data,
      shareText: 'Stock Report',
    );
  }
}

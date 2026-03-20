import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock/l10n/app_localizations.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../dashboard/data/models/dashboard_summary.dart';
import '../../../../core/utils/export_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class _DummyStockItem {
  final String name;
  _DummyStockItem(this.name);
}

class _DummyCartItem {
  final _DummyStockItem stockItem;
  final double sellPrice;
  final double quantity;
  final double subtotal;
  _DummyCartItem(this.stockItem, this.sellPrice, this.quantity, this.subtotal);
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _customRange;
  bool _showAllTransactions = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _exportToPdf(DashboardSummary summary) async {
    final pdf = pw.Document();
    final dateStr = _customRange != null
        ? '${DateFormat('yyyy-MM-dd').format(_customRange!.start)} to ${DateFormat('yyyy-MM-dd').format(_customRange!.end)}'
        : 'Summary';

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Business Report')),
          pw.Paragraph(text: 'Report Period: $dateStr'),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Metric', 'Value'],
            data: [
              ['Total Sales', 'Rs. ${summary.monthlySales.toStringAsFixed(2)}'],
              [
                'Total Expenses',
                'Rs. ${summary.totalExpenses.toStringAsFixed(2)}',
              ],
              ['Other Income', 'Rs. ${summary.otherIncome.toStringAsFixed(2)}'],
              ['Net Profit', 'Rs. ${summary.profit.toStringAsFixed(2)}'],
            ],
          ),
          if (summary.allTransactions != null &&
              summary.allTransactions!.isNotEmpty) ...[
            pw.SizedBox(height: 30),
            pw.Header(level: 1, child: pw.Text('Detailed Transactions')),
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Title', 'Type', 'Amount'],
              data: summary.allTransactions!
                  .map(
                    (tx) => [
                      DateFormat('yyyy-MM-dd HH:mm').format(tx.date.toUtc().add(const Duration(hours: 5, minutes: 30))),
                      tx.title,
                      tx.type.toUpperCase(),
                      'Rs. ${tx.amount.toStringAsFixed(2)}',
                    ],
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> _exportToExcel(DashboardSummary summary) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Report'];

    sheetObject.appendRow([TextCellValue('Business Report')]);
    sheetObject.appendRow([
      TextCellValue('Report Period'),
      TextCellValue(
        _customRange != null
            ? '${DateFormat('yyyy-MM-dd').format(_customRange!.start)} - ${DateFormat('yyyy-MM-dd').format(_customRange!.end)}'
            : 'Summary',
      ),
    ]);
    sheetObject.appendRow([null]);
    sheetObject.appendRow([TextCellValue('Summary Statistics')]);
    sheetObject.appendRow([
      TextCellValue('Metric'),
      TextCellValue('Amount (Rs.)'),
    ]);
    sheetObject.appendRow([
      TextCellValue('Total Sales'),
      DoubleCellValue(summary.monthlySales),
    ]);
    sheetObject.appendRow([
      TextCellValue('Total Expenses'),
      DoubleCellValue(summary.totalExpenses),
    ]);
    sheetObject.appendRow([
      TextCellValue('Other Income'),
      DoubleCellValue(summary.otherIncome),
    ]);
    sheetObject.appendRow([
      TextCellValue('Net Profit'),
      DoubleCellValue(summary.profit),
    ]);

    if (summary.allTransactions != null &&
        summary.allTransactions!.isNotEmpty) {
      sheetObject.appendRow([null]);
      sheetObject.appendRow([TextCellValue('Detailed Transactions')]);
      sheetObject.appendRow([
        TextCellValue('Date'),
        TextCellValue('Title'),
        TextCellValue('Type'),
        TextCellValue('Amount (Rs.)'),
      ]);
      for (var tx in summary.allTransactions!) {
        sheetObject.appendRow([
          TextCellValue(DateFormat('yyyy-MM-dd HH:mm').format(tx.date.toUtc().add(const Duration(hours: 5, minutes: 30)))),
          TextCellValue(tx.title),
          TextCellValue(tx.type.toUpperCase()),
          DoubleCellValue(tx.amount),
        ]);
      }
    }

    final fileBytes = excel.save();
    final directory = await getTemporaryDirectory();
    final fileName = 'Report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }

    await Share.shareXFiles([XFile(file.path)], text: 'Business Report Excel');
  }

  Widget _buildExportButton({required String iconPath, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(iconPath, width: 22, height: 22),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Determine ranges for both tabs if no custom range is set
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final dailySummaryAsync = ref.watch(
      dashboardSummaryProvider(
        startDate: _customRange?.start ?? todayStart,
        endDate: _customRange?.end ?? todayEnd,
      ),
    );

    final monthlySummaryAsync = ref.watch(
      dashboardSummaryProvider(
        startDate: _customRange?.start ?? monthStart,
        endDate: _customRange?.end ?? monthEnd,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExportButton(
                iconPath: 'assets/icons/pdf.png',
                onTap: () {
                  final summ = _tabController.index == 0
                      ? dailySummaryAsync.asData?.value
                      : monthlySummaryAsync.asData?.value;
                  if (summ != null) _exportToPdf(summ);
                },
              ),
              const SizedBox(width: 8),
              _buildExportButton(
                iconPath: 'assets/icons/excel.png',
                onTap: () {
                  final summ = _tabController.index == 0
                      ? dailySummaryAsync.asData?.value
                      : monthlySummaryAsync.asData?.value;
                  if (summ != null) _exportToExcel(summ);
                },
              ),
              const SizedBox(width: 8),
              _buildExportButton(
                iconPath: 'assets/icons/print.png',
                onTap: () {
                  final summ = _tabController.index == 0
                      ? dailySummaryAsync.asData?.value
                      : monthlySummaryAsync.asData?.value;
                  if (summ != null) _exportToPdf(summ); // Print uses PDF layout
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.divider.withOpacity(0.5),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (index) => setState(() {}), // Force rebuild to update exports
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: l10n.dailyReport),
                Tab(text: l10n.monthlyReport),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryView(dailySummaryAsync, l10n, isDaily: true),
          _buildSummaryView(monthlySummaryAsync, l10n, isDaily: false),
        ],
      ),
    );
  }

  Widget _buildSummaryView(AsyncValue<DashboardSummary> summaryAsync, AppLocalizations l10n, {required bool isDaily}) {
    return summaryAsync.when(
      data: (summary) => _buildReportContent(l10n, summary, isDaily: isDaily),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (err, _) => EmptyStateWidget(
        icon: Icons.error_outline,
        title: l10n.error,
        subtitle: err.toString(),
        action: ElevatedButton.icon(
          onPressed: () {
            final now = DateTime.now();
            final todayStart = DateTime(now.year, now.month, now.day);
            final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
            final monthStart = DateTime(now.year, now.month, 1);
            final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
            if (isDaily) {
              ref.refresh(
                dashboardSummaryProvider(
                  startDate: _customRange?.start ?? todayStart,
                  endDate: _customRange?.end ?? todayEnd,
                ),
              );
            } else {
              ref.refresh(
                dashboardSummaryProvider(
                  startDate: _customRange?.start ?? monthStart,
                  endDate: _customRange?.end ?? monthEnd,
                ),
              );
            }
          },
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(l10n.retry),
        ),
      ),
    );
  }

  Future<void> _exportSingleBill(DashboardTransaction tx, String format) async {
    final authState = ref.read(authProvider);
    final company = authState.value?.company;
    if (company == null) return;

    final mapItems = tx.items?.map((e) => _DummyCartItem(_DummyStockItem(e.name), e.price, e.qty, e.total)).toList() ?? [];
    final invoiceNumber = tx.title.replaceAll(RegExp(r'[^0-9]'), '');

    if (format == 'pdf' || format == 'print') {
      await ExportUtils.generateInvoicePdf(
        company: company,
        cartItems: mapItems,
        total: tx.amount,
        invoiceNumber: invoiceNumber.isEmpty ? 'N/A' : invoiceNumber,
      );
    } else if (format == 'excel') {
      await ExportUtils.generateInvoiceExcel(
        company: company,
        cartItems: mapItems,
        total: tx.amount,
        invoiceNumber: invoiceNumber.isEmpty ? 'N/A' : invoiceNumber,
      );
    }
  }

  void _showBillDetails(BuildContext context, DashboardTransaction tx, AppLocalizations l10n) {
    final totalProfit = tx.items?.fold(0.0, (sum, item) => sum + item.profit) ?? 0.0;
    final itemCount = tx.items?.fold(0.0, (sum, item) => sum + item.qty) ?? 0.0;
    // MongoDB stores in UTC — convert explicitly to Sri Lanka time (UTC+5:30)
    final sriLankaTime = tx.date.toUtc().add(const Duration(hours: 5, minutes: 30));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            color: const Color(0xFFF8F9FE),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Gradient Header ──────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.75),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.receipt_long_rounded,
                                color: Colors.white, size: 22),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${itemCount.toInt()} ${l10n.units}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tx.title,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 13, color: Colors.white70),
                          const SizedBox(width: 5),
                          Text(
                            DateFormat('MMM dd, yyyy  •  HH:mm').format(sriLankaTime),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Items List ────────────────────────────────────
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (tx.items != null && tx.items!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                            child: Column(
                              children: tx.items!.asMap().entries.map((entry) {
                                final i = entry.key;
                                final item = entry.value;
                                final isLast = i == tx.items!.length - 1;
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Index badge
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${i + 1}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        // Name + qty×price
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                '${item.qty.toStringAsFixed(item.qty == item.qty.roundToDouble() ? 0 : 1)} × Rs. ${item.price.toInt()}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Total
                                        Text(
                                          'Rs. ${item.total.toInt()}',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!isLast)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Divider(
                                          height: 1,
                                          color: AppColors.divider
                                              .withOpacity(0.5),
                                        ),
                                      )
                                    else
                                      const SizedBox(height: 20),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),

                        // ── Dashed separator ─────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: List.generate(
                              25,
                              (i) => Expanded(
                                child: Container(
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2),
                                  color: i.isEven
                                      ? AppColors.divider
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ── Summary row ───────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Row(
                            children: [
                              // Total chip
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_balance_wallet_outlined,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.total,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Rs. ${tx.amount.toInt()}',
                                          style: GoogleFonts.inter(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Profit chip
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.trending_up_rounded,
                                            size: 14,
                                            color: AppColors.success,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.profit,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.success,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Rs. ${totalProfit.toInt()}',
                                          style: GoogleFonts.inter(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        // ── Actions ──────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: Column(
                            children: [
                              // Export Buttons Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildExportButton(
                                    iconPath: 'assets/icons/pdf.png',
                                    onTap: () => _exportSingleBill(tx, 'pdf'),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildExportButton(
                                    iconPath: 'assets/icons/excel.png',
                                    onTap: () => _exportSingleBill(tx, 'excel'),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildExportButton(
                                    iconPath: 'assets/icons/print.png',
                                    onTap: () => _exportSingleBill(tx, 'print'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Close Button
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.cancel,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildReportContent(AppLocalizations l10n, DashboardSummary summary, {required bool isDaily}) {
    // ... logic from old _buildDailyReport but renamed and optimized
    final sales = summary.rangeStats?['sales'] ?? (isDaily ? summary.todaySales : summary.monthlySales);
    final expenses = summary.rangeStats?['expenses'] ?? summary.totalExpenses;
    final income = summary.rangeStats?['income'] ?? summary.otherIncome;
    final profit = summary.rangeStats?['profit'] ?? summary.profit;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final displayStart = _customRange?.start ?? (isDaily ? todayStart : monthStart);
    final displayEnd = _customRange?.end ?? (isDaily ? todayEnd : monthEnd);
    
    // Exactly matches backend logic for returning monthly vs daily history
    final bool isMonthlyData = displayEnd.difference(displayStart).inDays > 25;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(l10n, displayStart, displayEnd, isCustom: _customRange != null),
          const SizedBox(height: 32),

          // 1. Line Chart: Sales Trends
          if (summary.salesHistory != null && summary.salesHistory!.isNotEmpty) ...[
            SectionHeader(title: l10n.salesTrends),
            _buildTrendsChart(summary.salesHistory!, l10n, isMonthly: isMonthlyData),
            const SizedBox(height: 32),
          ],

          // 2. Summary Cards
          SectionHeader(
            title: _customRange != null
                ? l10n.filteredStatistics
                : (isDaily ? l10n.today : l10n.thisMonth),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: [
              SummaryCard(
                title: l10n.totalSales,
                value: 'Rs. ${sales.toInt()}',
                icon: Icons.trending_up_rounded,
                color: AppColors.primary,
              ),
              SummaryCard(
                title: l10n.totalExpenses,
                value: 'Rs. ${expenses.toInt()}',
                icon: Icons.trending_down_rounded,
                color: AppColors.error,
              ),
              SummaryCard(
                title: l10n.otherIncome,
                value: 'Rs. ${income.toInt()}',
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFF7C3AED),
              ),
              SummaryCard(
                title: l10n.netProfit,
                value: 'Rs. ${profit.toInt()}',
                icon: Icons.auto_graph_rounded,
                color: profit >= 0 ? AppColors.success : AppColors.error,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 3. Top Selling Items Table
          if (summary.topItems != null && summary.topItems!.isNotEmpty) ...[
            SectionHeader(title: l10n.topPerformingItems),
            _buildTopItemsTable(summary.topItems!, l10n),
            const SizedBox(height: 32),
          ],

          // 4. Business Overview Chart (Replacing Expense Pie Chart)
          SectionHeader(title: l10n.businessProfitability),
          _buildBusinessOverviewChart(sales, expenses, profit, l10n),
          const SizedBox(height: 32),

          // 5. Transaction Details
          if (summary.allTransactions != null) ...[
            SectionHeader(title: l10n.detailedActivity),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.divider.withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _showAllTransactions
                        ? summary.allTransactions!.length
                        : (summary.allTransactions!.length > 10
                            ? 10
                            : summary.allTransactions!.length),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final tx = summary.allTransactions![index];
                      final isPositive =
                          tx.type == 'sale' || tx.type == 'income';
                      return ListTile(
                        onTap: tx.type == 'sale' ? () => _showBillDetails(context, tx, l10n) : null,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        title: Text(
                          tx.title,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        subtitle: Text(
                          DateFormat('MMM dd, yyyy').format(tx.date.toUtc().add(const Duration(hours: 5, minutes: 30))),
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${isPositive ? "+" : "-"} Rs. ${tx.amount.toInt()}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w900,
                                color:
                                    isPositive ? AppColors.success : AppColors.error,
                              ),
                            ),
                            if (tx.type == 'sale')
                              const Icon(Icons.chevron_right, size: 16, color: AppColors.textHint),
                          ],
                        ),
                      );
                    },
                  ),
                  if (summary.allTransactions!.length > 10)
                    TextButton(
                      onPressed: () =>
                          setState(() => _showAllTransactions = !_showAllTransactions),
                      child: Text(_showAllTransactions ? l10n.showLess : l10n.viewMore),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExportActionButtons(DashboardSummary summary, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            assetIcon: 'assets/icons/pdf.png',
            label: 'Save PDF',
            bgColor: const Color(0xFFE53935).withOpacity(0.1),
            textColor: const Color(0xFFC62828),
            onTap: () => _exportToPdf(summary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            assetIcon: 'assets/icons/excel.png',
            label: 'Excel',
            bgColor: const Color(0xFF2E7D32).withOpacity(0.1),
            textColor: const Color(0xFF1B5E20),
            onTap: () => _exportToExcel(summary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            assetIcon: 'assets/icons/print.png',
            label: 'Print',
            bgColor: AppColors.primary.withOpacity(0.1),
            textColor: AppColors.primaryDark,
            onTap: () => _exportToPdf(summary),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String assetIcon,
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetIcon, width: 16, height: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsChart(List<SalesHistoryPoint> history, AppLocalizations l10n, {bool isMonthly = false}) {
    // Show only last 7 days/months for clarity
    final recent = history.length > 7 ? history.sublist(history.length - 7) : history;
    final maxAmount = recent.fold(0.0, (m, h) => h.amount > m ? h.amount : m);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: recent.map((point) {
          final fraction = maxAmount > 0 ? (point.amount / maxAmount).clamp(0.0, 1.0) : 0.0;
          final isProfit = point.profit >= 0;
          // Parse date and convert to Sri Lanka time
          final rawDate = DateTime.parse(point.date);
          final slDate = rawDate.toUtc().add(const Duration(hours: 5, minutes: 30));
          
          final dateLabel = isMonthly ? DateFormat('yyyy').format(slDate) : DateFormat('MMM dd').format(slDate);
          final mainLabel = isMonthly ? DateFormat('MMM').format(slDate) : DateFormat('EEE').format(slDate);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                // Day/Month label
                SizedBox(
                  width: 42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mainLabel,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        dateLabel,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Bar + amount
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bar
                      LayoutBuilder(
                        builder: (context, constraints) => Stack(
                          children: [
                            Container(
                              height: 10,
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            Container(
                              height: 10,
                              width: constraints.maxWidth * fraction,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rs. ${point.amount.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isProfit
                                  ? AppColors.success.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${isProfit ? '+' : ''}Rs. ${point.profit.toInt()}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isProfit ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopItemsTable(List<TopItem> items, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withOpacity(0.4)),
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (items.indexOf(item) + 1).toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${item.qty.toInt()} ${l10n.sold}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Rs. ${item.total.toInt()}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBusinessOverviewChart(double sales, double expenses, double profit, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: ([sales, expenses, profit.abs()].reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.blueGrey.shade900,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        'Rs. ${rod.toY.toInt()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: sales,
                        color: AppColors.primary,
                        width: 25,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: expenses,
                        color: AppColors.error,
                        width: 25,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: profit > 0 ? profit : 0,
                        color: AppColors.success,
                        width: 25,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(l10n.sales, AppColors.primary),
              _buildLegendItem(l10n.expenses, AppColors.error),
              _buildLegendItem(l10n.profit, AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(AppLocalizations l10n, DateTime start, DateTime end, {required bool isCustom}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            initialDateRange: _customRange ?? DateTimeRange(start: start, end: end),
          );
          if (range != null) {
            setState(() => _customRange = range);
          }
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCustom ? l10n.customRange : l10n.filterByDate,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${DateFormat('MMM dd').format(start)} - ${DateFormat('MMM dd, yyyy').format(end)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isCustom)
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _customRange = null),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

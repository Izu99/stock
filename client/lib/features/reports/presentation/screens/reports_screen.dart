import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _customRange;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          const SizedBox(width: 8),
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
                color: AppColors.divider.withValues(alpha: 0.5),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
      body: summaryAsync.when(
        data: (summary) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildDailyReport(l10n, summary),
              _buildMonthlyReport(l10n, summary),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => EmptyStateWidget(
          icon: Icons.error_outline,
          title: l10n.error,
          subtitle: err.toString(),
          action: ElevatedButton.icon(
            onPressed: () =>
                ref.read(dashboardSummaryProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.retry),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyReport(AppLocalizations l10n, dynamic summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date selector area
          _buildDateSelector(l10n),
          const SizedBox(height: 32),

          // Cards Grid
          SectionHeader(title: l10n.today),
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
                value: 'Rs. ${summary.todaySales.toStringAsFixed(0)}',
                icon: Icons.trending_up_rounded,
                color: AppColors.primary,
              ),
              SummaryCard(
                title: l10n.totalExpenses,
                value: 'Rs. ${summary.totalExpenses.toStringAsFixed(0)}',
                icon: Icons.trending_down_rounded,
                color: AppColors.error,
              ),
              SummaryCard(
                title: l10n.otherIncome,
                value: 'Rs. ${summary.otherIncome.toStringAsFixed(0)}',
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFF7C3AED),
              ),
              SummaryCard(
                title: l10n.netProfit,
                value: 'Rs. ${summary.profit.toStringAsFixed(0)}',
                icon: Icons.star_rounded,
                color: summary.profit >= 0
                    ? AppColors.success
                    : AppColors.error,
              ),
            ],
          ),

          const SizedBox(height: 32),
          // Visual Overview
          SectionHeader(title: l10n.overview),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: [
                        PieChartSectionData(
                          value: summary.todaySales > 0
                              ? summary.todaySales
                              : 1,
                          color: AppColors.primary,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: summary.totalExpenses > 0
                              ? summary.totalExpenses
                              : 1,
                          color: AppColors.error,
                          title: '',
                          radius: 40,
                        ),
                        PieChartSectionData(
                          value: summary.otherIncome > 0
                              ? summary.otherIncome
                              : 1,
                          color: const Color(0xFF7C3AED),
                          title: '',
                          radius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildLegendItem(l10n.sales, AppColors.primary),
                    const SizedBox(width: 16),
                    _buildLegendItem(l10n.expenses, AppColors.error),
                    const SizedBox(width: 16),
                    _buildLegendItem(l10n.income, const Color(0xFF7C3AED)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyReport(AppLocalizations l10n, dynamic summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Month Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.analytics_rounded,
                    size: 100,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat(
                        'MMMM yyyy',
                      ).format(DateTime.now()).toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rs. ${summary.monthlySales.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.monthlySales,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Detail Rows
          SectionHeader(title: 'Breakdown'),
          _buildDetailRow(
            l10n.totalSales,
            'Rs. ${summary.monthlySales.toStringAsFixed(0)}',
            Icons.trending_up_rounded,
            AppColors.primary,
          ),
          _buildDetailRow(
            l10n.totalExpenses,
            'Rs. ${summary.totalExpenses.toStringAsFixed(0)}',
            Icons.trending_down_rounded,
            AppColors.error,
          ),
          _buildDetailRow(
            l10n.otherIncome,
            'Rs. ${summary.otherIncome.toStringAsFixed(0)}',
            Icons.account_balance_wallet_outlined,
            const Color(0xFF7C3AED),
          ),
          _buildDetailRow(
            l10n.totalStockValue,
            'Rs. ${summary.totalStockValue.toStringAsFixed(0)}',
            Icons.inventory_2_outlined,
            const Color(0xFFFF6B35),
          ),

          const SizedBox(height: 24),

          // Profit Insight
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: summary.profit >= 0
                  ? AppColors.success.withValues(alpha: 0.05)
                  : AppColors.error.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    (summary.profit >= 0 ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        (summary.profit >= 0
                                ? AppColors.success
                                : AppColors.error)
                            .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    summary.profit >= 0
                        ? Icons.north_east_rounded
                        : Icons.south_east_rounded,
                    color: summary.profit >= 0
                        ? AppColors.success
                        : AppColors.error,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.netProfit,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Rs. ${summary.profit.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: summary.profit >= 0
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
            initialDateRange:
                _customRange ??
                DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 7)),
                  end: DateTime.now(),
                ),
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
                color: AppColors.primary.withValues(alpha: 0.08),
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
                    l10n.filterByDate,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _customRange != null
                        ? '${DateFormat('MMM dd, yyyy').format(_customRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_customRange!.end)}'
                        : 'Today - Select Range',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (_customRange != null)
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
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

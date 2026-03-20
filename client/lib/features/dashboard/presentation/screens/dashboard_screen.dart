import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/modern_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/feature_card.dart';
import 'package:stock/features/auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../../data/models/dashboard_summary.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(
      dashboardSummaryProvider(startDate: null, endDate: null),
    );
    final userAsync = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref
            .read(
              dashboardSummaryProvider(startDate: null, endDate: null).notifier,
            )
            .refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Modern Header
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                    // Decorative patterns
                    Positioned(
                      top: -40,
                      right: -40,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _getGreeting(l10n),
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildHeaderAction(
                                      Icons.notifications_none_rounded,
                                      () {},
                                    ),
                                    const SizedBox(width: 8),
                                    _buildHeaderAction(
                                      Icons.settings_outlined,
                                      () => context.go('/settings'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            userAsync.when(
                              data: (user) => Text(
                                user?.companyName ?? l10n.dashboard,
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                              ),
                              loading: () => const SizedBox(height: 24),
                              error: (_, __) => const SizedBox(height: 24),
                            ),
                            const Spacer(),
                            // Performance Highlight
                            summaryAsync.when(
                              data: (summary) =>
                                  _buildMainBalance(summary, l10n),
                              loading: () =>
                                  _buildPulseLine(height: 80, borderRadius: 24),
                              error: (_, __) => const SizedBox(height: 80),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  summaryAsync.when(
                    data: (summary) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Key Metrics Grid
                        SectionHeader(title: l10n.overview),
                        GridView.count(
                          crossAxisCount: 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3.2,
                          children: [
                            _buildStatCard(
                              l10n.totalStockValue,
                              'Rs. ${summary.totalStockValue.toStringAsFixed(0)}',
                              Icons.inventory_2_outlined,
                              AppColors.primary,
                            ),
                            _buildStatCard(
                              l10n.totalItems,
                              summary.totalItems.toString(),
                              Icons.category_outlined,
                              const Color(0xFF7C3AED),
                            ),
                            _buildStatCard(
                              l10n.todaySales,
                              'Rs. ${summary.todaySales.toStringAsFixed(0)}',
                              Icons.trending_up_rounded,
                              AppColors.success,
                            ),
                            _buildStatCard(
                              l10n.lowStock,
                              summary.lowStockCount.toString(),
                              Icons.warning_amber_rounded,
                              summary.lowStockCount > 0
                                  ? AppColors.error
                                  : AppColors.success,
                              isUrgent: summary.lowStockCount > 0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Interactive Business Performance Chart
                        SectionHeader(
                          title: l10n.businessPerformance,
                          trailing: Icon(
                            Icons.info_outline,
                            size: 18,
                            color: AppColors.textHint,
                          ),
                        ),
                        _buildPerformanceChart(summary, l10n),
                        const SizedBox(height: 32),

                        // Low Stock Alert Section
                        if (summary.lowStockCount > 0) ...[
                          _buildLowStockAlert(
                            summary.lowStockCount,
                            l10n,
                            () => context.go('/stock'),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // Quick Actions (Helakuru Style)
                        SectionHeader(title: l10n.quickActions),
                        FeatureCardGrid(
                          title: '',
                          features: [
                            FeatureCardData(
                              icon: Icons.add_shopping_cart_rounded,
                              label: l10n.newSale,
                              gradient: ModernTheme.blueGradient,
                              onTap: () => context.go('/billing'),
                            ),
                            FeatureCardData(
                              icon: Icons.add_box_outlined,
                              label: l10n.addStock,
                              gradient: ModernTheme.greenGradient,
                              onTap: () => context.go('/stock'),
                            ),
                            FeatureCardData(
                              icon: Icons.qr_code_scanner,
                              label: 'Scan',
                              gradient: ModernTheme.purpleGradient,
                              onTap: () {
                                // Open scanner
                              },
                            ),
                            FeatureCardData(
                              icon: Icons.bar_chart_rounded,
                              label: l10n.reports,
                              gradient: ModernTheme.orangeGradient,
                              onTap: () => context.go('/reports'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Recent Transactions
                        SectionHeader(
                          title: l10n.recentTransactions,
                          trailing: TextButton(
                            onPressed: () => context.go('/reports'),
                            child: Text(l10n.viewAll),
                          ),
                        ),
                        _buildRecentTransactions(summary, l10n),
                      ],
                    ),
                    loading: () => _buildLoadingSkeleton(l10n),
                    error: (err, stack) =>
                        _buildErrorWidget(context, ref, err, l10n),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBalance(DashboardSummary summary, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.monthlySales,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                ),
                Text(
                  'Rs. ${NumberFormat('#,###').format(summary.monthlySales)}',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isUrgent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: isUrgent
            ? Border.all(color: AppColors.error.withOpacity(0.3), width: 1.5)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint.withValues(alpha: 0.3),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(
    DashboardSummary summary,
    AppLocalizations l10n,
  ) {
    final double maxVal = [
      summary.monthlySales,
      summary.totalExpenses,
      summary.profit.abs(),
    ].reduce((a, b) => a > b ? a : b);

    final double chartMaxY = maxVal == 0 ? 100 : maxVal * 1.3;

    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(10, 24, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: chartMaxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  'Rs. ${rod.toY.toInt()}',
                  GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final titles = [l10n.sales, l10n.expenses, l10n.profit];
                  if (value.toInt() >= titles.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      titles[value.toInt()],
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _buildBarGroup(
              0,
              summary.monthlySales,
              AppColors.primary,
              chartMaxY,
            ),
            _buildBarGroup(
              1,
              summary.totalExpenses,
              AppColors.error,
              chartMaxY,
            ),
            _buildBarGroup(
              2,
              summary.profit.abs(),
              summary.profit >= 0 ? AppColors.success : AppColors.warning,
              chartMaxY,
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 32,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: color.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildLowStockAlert(
    int count,
    AppLocalizations l10n,
    VoidCallback onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.error.withOpacity(0.1),
            AppColors.error.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.priority_high_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.lowStockAlert,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                    Text(
                      '$count ${l10n.itemsLowStock}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.error.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.error.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.viewAll,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        _buildActionItem(
          context,
          l10n.newSale,
          Icons.add_shopping_cart_rounded,
          AppColors.primary,
          '/billing',
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          context,
          l10n.addStock,
          Icons.add_box_outlined,
          const Color(0xFFFF6B35),
          '/stock',
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          context,
          l10n.reports,
          Icons.bar_chart_rounded,
          const Color(0xFF7C3AED),
          '/reports',
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    String route,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
    DashboardSummary summary,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: summary.recentTransactions.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(l10n.noRecentActivity)),
            )
          : Column(
              children: summary.recentTransactions.take(5).map((tx) {
                final isSale = tx.type == 'sale';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isSale ? AppColors.success : AppColors.error)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isSale
                          ? Icons.south_west_rounded
                          : Icons.north_east_rounded,
                      color: isSale ? AppColors.success : AppColors.error,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    tx.title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('MMM dd, hh:mm a').format(tx.date.toUtc().add(const Duration(hours: 5, minutes: 30))),
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    '${isSale ? "+" : "-"} Rs. ${tx.amount.toInt()}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: isSale ? AppColors.success : AppColors.error,
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    WidgetRef ref,
    Object err,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text('Failed to load dashboard: $err'),
          TextButton(
            onPressed: () => ref
                .read(
                  dashboardSummaryProvider(
                    startDate: null,
                    endDate: null,
                  ).notifier,
                )
                .refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(AppLocalizations l10n) {
    return Column(
      children: [
        _buildPulseLine(height: 150, borderRadius: 24),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: List.generate(4, (_) => _buildPulseLine(borderRadius: 20)),
        ),
      ],
    );
  }

  Widget _buildPulseLine({double height = 20, double borderRadius = 12}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

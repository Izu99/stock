import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:Stock/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/dashboard_provider.dart';

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
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(dashboardSummaryProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Premium Header
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(decoration: const BoxDecoration(gradient: AppColors.blueGradient)),
                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
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
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Text(
                                         _getGreeting(l10n),
                                         style: GoogleFonts.inter(
                                           fontSize: 13,
                                           color: Colors.white.withOpacity(0.8),
                                         ),
                                         maxLines: 1,
                                         overflow: TextOverflow.ellipsis,
                                       ),
                                       Text(
                                         l10n.appTitle,
                                         style: GoogleFonts.inter(
                                           fontSize: 18,
                                           fontWeight: FontWeight.w800,
                                           color: Colors.white,
                                         ),
                                         maxLines: 1,
                                         overflow: TextOverflow.ellipsis,
                                       ),
                                     ],
                                   ),
                                 ),
                                 const SizedBox(width: 12),
                                 AnimatedOpacity(
                                   duration: const Duration(milliseconds: 500),
                                   opacity: summaryAsync.isLoading ? 0 : 1,
                                   child: Row(
                                     children: [
                                       _buildHeaderButton(Icons.notifications_none_rounded, () {}),
                                       const SizedBox(width: 8),
                                       _buildHeaderButton(Icons.settings_outlined, () => context.go('/settings')),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                            const Spacer(),
                            // Glassmorphism Balance Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
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
                                           style: GoogleFonts.inter(
                                             fontSize: 13,
                                             color: Colors.white.withOpacity(0.8),
                                           ),
                                         ),
                                         const SizedBox(height: 4),
                                         AnimatedSwitcher(
                                           duration: const Duration(milliseconds: 400),
                                           child: summaryAsync.when(
                                             data: (summary) => FittedBox(
                                               fit: BoxFit.scaleDown,
                                               alignment: Alignment.centerLeft,
                                               child: Text(
                                                 'Rs. ${summary.monthlySales.toStringAsFixed(0)}',
                                                 style: GoogleFonts.inter(
                                                   fontSize: 32,
                                                   fontWeight: FontWeight.w900,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                             ),
                                             loading: () => _buildPulseLine(width: 120, height: 32),
                                             error: (_, __) => const Text('---', style: TextStyle(color: Colors.white)),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   AnimatedOpacity(
                                     duration: const Duration(milliseconds: 600),
                                     opacity: summaryAsync.isLoading ? 0 : 1,
                                     child: Container(
                                       padding: const EdgeInsets.all(12),
                                       decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(16),
                                       ),
                                       child: Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary),
                                     ),
                                   ),
                                 ],
                               ),
                            ),
                            const SizedBox(height: 10),
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
                  // Summary Cards
                  summaryAsync.when(
                    data: (summary) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: l10n.overview,
                          trailing: Text(
                            l10n.all,
                            style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
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
                              title: l10n.totalStockValue,
                              value: 'Rs. ${summary.totalStockValue.toStringAsFixed(0)}',
                              icon: Icons.inventory_2_outlined,
                              color: const Color(0xFFFF6B35),
                            ),
                            SummaryCard(
                              title: l10n.todaySales,
                              value: 'Rs. ${summary.todaySales.toStringAsFixed(0)}',
                              icon: Icons.today_outlined,
                              color: AppColors.success,
                            ),
                            SummaryCard(
                              title: l10n.totalExpenses,
                              value: 'Rs. ${summary.totalExpenses.toStringAsFixed(0)}',
                              icon: Icons.receipt_long_outlined,
                              color: AppColors.error,
                            ),
                            SummaryCard(
                              title: l10n.otherIncome,
                              value: 'Rs. ${summary.otherIncome.toStringAsFixed(0)}',
                              icon: Icons.account_balance_wallet_outlined,
                              color: const Color(0xFF7C3AED),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Performance Chart
                        SectionHeader(title: 'Business Performance'),
                        Container(
                          height: 240,
                          padding: const EdgeInsets.all(20),
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
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: (summary.monthlySales > summary.totalExpenses ? summary.monthlySales : summary.totalExpenses) * 1.3,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      'Rs. ${rod.toY.toStringAsFixed(0)}',
                                      GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
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
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          titles[value.toInt()],
                                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                              barGroups: [
                                _buildBarGroup(0, summary.monthlySales, AppColors.primary),
                                _buildBarGroup(1, summary.totalExpenses, AppColors.error),
                                _buildBarGroup(2, summary.profit.abs(), summary.profit >= 0 ? AppColors.success : AppColors.warning),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Quick Actions
                        SectionHeader(title: l10n.quickActions),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                          children: [
                            QuickActionButton(
                              label: l10n.newSale,
                              icon: Icons.point_of_sale_rounded,
                              color: AppColors.primary,
                              onTap: () => context.go('/billing'),
                            ),
                            QuickActionButton(
                              label: l10n.manageStock,
                              icon: Icons.inventory_2_rounded,
                              color: const Color(0xFFFF6B35),
                              onTap: () => context.go('/stock'),
                            ),
                            QuickActionButton(
                              label: l10n.viewReports,
                              icon: Icons.analytics_rounded,
                              color: const Color(0xFF7C3AED),
                              onTap: () => context.go('/reports'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Recent Activity (Table look)
                        SectionHeader(title: 'Recent Transactions'),
                        Container(
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
                          child: summary.recentTransactions.isEmpty 
                            ? Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text('No recent transactions', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                              )
                            : Column(
                                children: [
                                  for (int i = 0; i < summary.recentTransactions.length; i++) ...[
                                    _buildTransactionItem(
                                      summary.recentTransactions[i].title, 
                                      'Rs. ${summary.recentTransactions[i].amount.toStringAsFixed(0)}', 
                                      _formatDate(summary.recentTransactions[i].date), 
                                      summary.recentTransactions[i].type == 'sale' ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, 
                                      summary.recentTransactions[i].type == 'sale' ? AppColors.success : AppColors.error
                                    ),
                                    if (i < summary.recentTransactions.length - 1)
                                      const Divider(height: 1, indent: 60),
                                  ],
                                ],
                              ),
                        ),
                      ],
                    ),
                    loading: () => _buildLoadingSkeleton(l10n),
                    error: (err, stack) => _buildErrorWidget(context, ref, err, l10n),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 32,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y * 0.1,
            color: color.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String amount, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                Text(
                  time,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object err, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text('${l10n.error}: $err', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.read(dashboardSummaryProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.overview),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: List.generate(4, (index) => _buildSkeletonCard()),
        ),
        const SizedBox(height: 32),
        SectionHeader(title: 'Business Performance'),
        _buildSkeletonCard(height: 240),
      ],
    );
  }

  Widget _buildSkeletonCard({double height = 150}) {
    return _buildPulseLine(height: height, borderRadius: 24, color: Colors.white);
  }

  Widget _buildPulseLine({
    double width = double.infinity,
    double height = 20,
    double borderRadius = 12,
    Color? color,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 0.7),
      duration: const Duration(milliseconds: 1000),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color ?? Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}

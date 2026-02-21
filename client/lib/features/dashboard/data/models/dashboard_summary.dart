import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary.freezed.dart';
part 'dashboard_summary.g.dart';

@freezed
abstract class DashboardTransaction with _$DashboardTransaction {
  const factory DashboardTransaction({
    required String id,
    required String title,
    required double amount,
    required DateTime date,
    required String type,
  }) = _DashboardTransaction;

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) => _$DashboardTransactionFromJson(json);
}

@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required double totalStockValue,
    required double todaySales,
    required double monthlySales,
    required double totalExpenses,
    required double otherIncome,
    required double profit,
    @Default([]) List<DashboardTransaction> recentTransactions,
  }) = _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) => _$DashboardSummaryFromJson(json);
}

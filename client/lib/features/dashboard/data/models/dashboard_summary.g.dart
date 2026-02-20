// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    _DashboardSummary(
      totalStockValue: (json['totalStockValue'] as num).toDouble(),
      todaySales: (json['todaySales'] as num).toDouble(),
      monthlySales: (json['monthlySales'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      otherIncome: (json['otherIncome'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardSummaryToJson(_DashboardSummary instance) =>
    <String, dynamic>{
      'totalStockValue': instance.totalStockValue,
      'todaySales': instance.todaySales,
      'monthlySales': instance.monthlySales,
      'totalExpenses': instance.totalExpenses,
      'otherIncome': instance.otherIncome,
      'profit': instance.profit,
    };

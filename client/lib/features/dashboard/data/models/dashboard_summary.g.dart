// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardTransaction _$DashboardTransactionFromJson(
  Map<String, dynamic> json,
) => _DashboardTransaction(
  id: json['id'] as String,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  type: json['type'] as String,
);

Map<String, dynamic> _$DashboardTransactionToJson(
  _DashboardTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'type': instance.type,
};

_DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    _DashboardSummary(
      totalStockValue: (json['totalStockValue'] as num).toDouble(),
      todaySales: (json['todaySales'] as num).toDouble(),
      monthlySales: (json['monthlySales'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      otherIncome: (json['otherIncome'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      lowStockCount: (json['lowStockCount'] as num?)?.toInt() ?? 0,
      recentTransactions:
          (json['recentTransactions'] as List<dynamic>?)
              ?.map(
                (e) => DashboardTransaction.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      salesHistory: (json['salesHistory'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      topItems: (json['topItems'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$DashboardSummaryToJson(_DashboardSummary instance) =>
    <String, dynamic>{
      'totalStockValue': instance.totalStockValue,
      'todaySales': instance.todaySales,
      'monthlySales': instance.monthlySales,
      'totalExpenses': instance.totalExpenses,
      'otherIncome': instance.otherIncome,
      'profit': instance.profit,
      'totalItems': instance.totalItems,
      'lowStockCount': instance.lowStockCount,
      'recentTransactions': instance.recentTransactions,
      'salesHistory': instance.salesHistory,
      'topItems': instance.topItems,
    };

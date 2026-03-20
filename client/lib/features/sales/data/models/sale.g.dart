// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sale _$SaleFromJson(Map<String, dynamic> json) => _Sale(
  id: json['_id'] as String,
  companyId: json['companyId'] as String?,
  items: (json['items'] as List<dynamic>)
      .map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  totalProfit: (json['totalProfit'] as num).toDouble(),
  billId: json['billId'] as String,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$SaleToJson(_Sale instance) => <String, dynamic>{
  '_id': instance.id,
  'companyId': instance.companyId,
  'items': instance.items,
  'totalAmount': instance.totalAmount,
  'totalProfit': instance.totalProfit,
  'billId': instance.billId,
  'date': instance.date.toIso8601String(),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sale _$SaleFromJson(Map<String, dynamic> json) => _Sale(
  id: json['_id'] as String,
  companyId: json['companyId'] as String?,
  itemId: json['item'] as String,
  itemName: json['itemName'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  sellPrice: (json['sellPrice'] as num).toDouble(),
  subtotal: (json['subtotal'] as num).toDouble(),
  profit: (json['profit'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$SaleToJson(_Sale instance) => <String, dynamic>{
  '_id': instance.id,
  'companyId': instance.companyId,
  'item': instance.itemId,
  'itemName': instance.itemName,
  'quantity': instance.quantity,
  'sellPrice': instance.sellPrice,
  'subtotal': instance.subtotal,
  'profit': instance.profit,
  'date': instance.date.toIso8601String(),
};

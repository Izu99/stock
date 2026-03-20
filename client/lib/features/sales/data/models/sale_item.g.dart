// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItem _$SaleItemFromJson(Map<String, dynamic> json) => _SaleItem(
  itemId: json['item'] as String,
  itemName: json['itemName'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  sellPrice: (json['sellPrice'] as num).toDouble(),
  subtotal: (json['subtotal'] as num).toDouble(),
  profit: (json['profit'] as num).toDouble(),
);

Map<String, dynamic> _$SaleItemToJson(_SaleItem instance) => <String, dynamic>{
  'item': instance.itemId,
  'itemName': instance.itemName,
  'quantity': instance.quantity,
  'sellPrice': instance.sellPrice,
  'subtotal': instance.subtotal,
  'profit': instance.profit,
};

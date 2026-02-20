// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockItem _$StockItemFromJson(Map<String, dynamic> json) => _StockItem(
  id: json['_id'] as String,
  companyId: json['companyId'] as String?,
  name: json['name'] as String,
  buyPrice: (json['buyPrice'] as num).toDouble(),
  sellPrice: (json['sellPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num).toDouble(),
  unit: $enumDecode(_$ItemUnitEnumMap, json['unit']),
  category: json['category'] as String,
  subcategory: json['subcategory'] as String?,
  date: DateTime.parse(json['date'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _$StockItemToJson(_StockItem instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'companyId': instance.companyId,
      'name': instance.name,
      'buyPrice': instance.buyPrice,
      'sellPrice': instance.sellPrice,
      'quantity': instance.quantity,
      'unit': _$ItemUnitEnumMap[instance.unit]!,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
    };

const _$ItemUnitEnumMap = {
  ItemUnit.kg: 'kg',
  ItemUnit.L: 'L',
  ItemUnit.pcs: 'pcs',
};

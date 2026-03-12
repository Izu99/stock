// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    _StockMovement(
      id: json['_id'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      type: $enumDecode(_$StockMovementTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$StockMovementToJson(_StockMovement instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'quantity': instance.quantity,
      'type': _$StockMovementTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
    };

const _$StockMovementTypeEnumMap = {
  StockMovementType.stockIn: 'stockIn',
  StockMovementType.stockOut: 'stockOut',
  StockMovementType.wastage: 'wastage',
  StockMovementType.adjustment: 'adjustment',
};
